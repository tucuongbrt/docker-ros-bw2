###########################################################################
# Copyright (C) 2016 OceanScan - Marine Systems & Technology, Lda.        #
###########################################################################
# This program is free software; you can redistribute it and/or modify    #
# it under the terms of the GNU General Public License as published by    #
# the Free Software Foundation; either version 2 of the License, or (at   #
# your option) any later version.                                         #
#                                                                         #
# This program is distributed in the hope that it will be useful, but     #
# WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       #
# General Public License for more details.                                #
#                                                                         #
# You should have received a copy of the GNU General Public License       #
# along with this program; if not, write to the Free Software             #
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA           #
# 02110-1301 USA.                                                         #
###########################################################################
# Author: Ricardo Martins                                                 #
###########################################################################

FROM ubuntu:18.04

MAINTAINER Ricardo Martins <rasm@oceanscan-mst.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_VERSION=melodic

RUN apt-get update -y && apt-get install -y lsb-release gnupg

# Add ROS repository.
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update -y && apt-get install -y \
    bzip2 \
    cmake \
    g++-multilib \
    git \
    libasio-dev \
    ninja-build \
    python-rosinstall \
    python3-pip \
    ros-$ROS_VERSION-ros-base \
    python-rosdep \
    unzip \
    valgrind \
    wget \
    xz-utils \
    zip

# For Bugwright2
RUN apt-get update -y && apt-get install -y \
    ros-$ROS_VERSION-simulators \
    ros-$ROS_VERSION-move-base-msgs \
    libgflags-dev \
    libgoogle-glog-dev \
    libeigen3-dev \
    liboctomap-dev \
    libpcl-dev \
    libopencv-dev \
    libcgal-dev \
    gazebo9 \
    ros-$ROS_VERSION-mavros \
    ros-$ROS_VERSION-mavros-extras \
    ros-$ROS_VERSION-joy \
    ros-$ROS_VERSION-pcl-conversions \
    ros-$ROS_VERSION-pcl-ros

# Initialize ROS.
RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/$ROS_VERSION/setup.bash" >> ~/.bashrc

# To allow building ROS packages from source
RUN pip3 install -U rosinstall vcstools rospkg

# Install IMC Translator.
ENV IMCTRANS_VERSION=0.1.6
RUN pip3 install "imctrans==$IMCTRANS_VERSION"

# Install simulator.
ENV DUNE_URL=http://www.omst.pt/dune/dune-2018.01.00-x86-64bit-linux-glibc-gcc54.tar.bz2
RUN mkdir /opt/lsts && \
    wget -q "$DUNE_URL" -O - | tar -C /opt/lsts -x -j -v -f - && \
    mv /opt/lsts/dune-* /opt/lsts/dune

# Add backseat config
ADD assets/backseat.ini /opt/lsts/dune/etc
