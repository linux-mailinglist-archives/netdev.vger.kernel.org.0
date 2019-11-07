Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D19AF341A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfKGQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:05:22 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53064 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730149AbfKGQFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:05:22 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:05:14 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G5BGo016782;
        Thu, 7 Nov 2019 18:05:12 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Date:   Thu,  7 Nov 2019 10:04:48 -0600
Message-Id: <20191107160448.20962-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jiri, Alex,

This series adds the support for mlx5 sub function devices using
mediated device with eswitch switchdev mode.

This series is currently on top of [1], but once [1] is merged to
net-next tree, this series should be resend through usual Saeed's
net-next tree or to netdev net-next.

Mdev alias support patches are already reviewed at vfio/kvm's mailing
list in past. Since mlx5_core driver is first user of the
mdev alias API, those patches are part of this series to merge via
net-next tree.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/log/?h=net-next-mlx5

Also, once Jason Wang's series [9] is merged, mlx5_core driver will be enhanced to
use class id based matching support for mdev devices.

Abstract:
---------

Mellanox ConnectX device supports dynamic creation of sub function which
are equivalent to a PCI function handled by mlx5_core and mlx5_ib drivers.
It has few few differences to PCI function. They are described below in
overview section.

Mellanox sub function capability allows users to create several hundreds
of networking and/or rdma devices without depending on PCI SR-IOV support.

Motivation:
-----------
User wants to use multiple netdevices and rdma devices in a system
without enabling SR-IOV, possibly more number of devices than what
mellanox ConnectX device supports using SR-IOV.

Such devices will have most if not all of the acceleration and offload
capabilities of mlx5, while they are still light weight and don't demand
any dedicated physical resources such as (pci function, MSIX vectors).

Provision such netdevice and/or rdma device to use in bare-metal
server or provision to a container.

In future, map such sub function device to a VM once ConnectX device
supports it. In such case, it should be able to reuse existing
mediated device (mdev) [2] framework of kernel.

Regardless of how a sub function is used, it is desired to lifecycle
such device in unified way, such as using mdev [2].

User wants to have same level of control, visibility, offloads support
as that of current SR-IOV VFs using eswitch switchdev mode for
Ethernet devices.

Overview:
---------
Mellanox ConnectX sub functions are exposed to user as a mediated
device (mdev) [2] as discussed in RFC [3] and further during
netdevconf0x13 at [4].

mlx5 mediated device (mdev) enables users to create multiple netdevices
and/or RDMA devices from single PCI function.

Each mdev maps to a mlx5 sub function.
mlx5 sub function is similar to PCI VF. However it doesn't have its own
PCI function and MSI-X vectors.

mlx5 mdevs share common PCI resources such as PCI BAR region,
MSI-X interrupts.

Each mdev has its own window in the PCI BAR region, which is
accessible only to that mdev and applications using it.

Each mlx5 sub function has its own resource namespace for RDMA resources.

mdevs are supported when eswitch mode of the devlink instance
is in switchdev mode described in devlink documentation [5].

mdev is identified using a UUID defined by RFC 4122.

Each created mdev has unique 12 letters alias. This alias is used to
derive phys_port_name attribute of the corresponding representor
netdevice. This establishes clear link between mdev device, eswitch
port and eswitch representor netdevice.

systemd udev [6] will be enhanced post this work to have predictable
netdevice names based on the unique and predicable mdev alias of the
mdev device.

For example, an Ethernet netdevice of an mdev device having alias
'aliasfoo123' will be persistently named as enmaliasfoo123, where:
<en> for Ethernet
m = mediated device bus
<alias> = unique mdev alias

Design decisions:
-----------------
1. mdev device (and bus) instead of any new subdevice bus is used
after concluding discussion at [7]. This simplifies and eliminates the
need of new bus, also eliminates any vendor specific bus.

2. mdev device is also chosen to not create multiple tools for creating
netdevice, rdma device, devlink port, its representor netdevice and
representor rdma port.

3. mdev device support in eswitch switchdev mode, gives rich isolation
and reuses existing offload infrastructure of iproute2/tc.

4. mdev device also enjoys existing devlink health reporting infrastructure
uniformely for PF, VF and mdev.

5. Persistent naming of mdev's netdevice scheme is discussed and concluded
at [8] using systemwide unique, predicable mdev alias.

6. Unique eswitch port phys_port_name derivation from the mdev alias usage
is concluded at [8].

User commands examples:
-----------------------

- Set eswitch mode as switchdev mode
    $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

- Create a mdev
    Generate a UUID
    $ UUID=$(uuidgen)
    Create the mdev using UUID
    $ echo $UUID > /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/create

- Unbind a mdev from vfio_mdev driver
    $ echo $UUID > /sys/bus/mdev/drivers/vfio_mdev/unbind

- Bind a mdev to mlx5_core driver
    $ echo $UUID > /sys/bus/mdev/drivers/mlx5_core/bind

- View netdevice and (optionally) RDMA device in sysfs tree
    $ ls -l /sys/bus/mdev/devices/$UUID/net/
    $ ls -l /sys/bus/mdev/devices/$UUID/infiniband/

- View netdevice and (optionally) RDMA device using iproute2 tools
    $ ip link show
    $ rdma dev show

- Query maximum number of mdevs that can be created
    $ cat /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/max_mdevs

- Query remaining number of mdevs that can be created
    $ cat /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/available_instances

- Query an alias of the mdev
    $ cat /sys/bus/mdev/devices/$UUID/alias

Security model:
--------------
This section covers security aspects of mlx5 mediated devices at
host level and at network level.

Host side:
- At present mlx5 mdev is meant to be used only in a host.
It is not meant to be mapped to a VM or access by userspace application
using VFIO framework.
Hence, mlx5_core driver doesn't implement any of the VFIO device specific
callback routines.
Hence, mlx5 mediated device cannot be mapped to a VM or to a userspace
application via VFIO framework.

- At present an mlx5 mdev can be accessed by an application through
its netdevice and/or RDMA device.

- mlx5 mdev does not share PCI BAR with its parent PCI function.

- All mlx5 mdevs of a given parent device share a single PCI BAR.
However each mdev device has a small dedicated window of the PCI BAR.
Hence, one mdev device cannot access PCI BAR or any of the resources
of another mdev device.

- Each mlx5 mdev has its own dedicated event queue through which interrupt
notifications are delivered. Hence, one mlx5 mdev cannot enable/disable
interrupts of other mlx5 mdev. mlx5 mdev cannot enable/disable interrupts
of the parent PCI function.

Network side:
- By default the netdevice and the rdma device of mlx5 mdev cannot send or
receive any packets over the network or to any other mlx5 mdev.

- mlx5 mdev follows devlink eswitch and vport model of PCI SR-IOV PF and VFs.
All traffic is dropped by default in this eswitch model.

- Each mlx5 mdev has one eswitch vport representor netdevice and rdma port.
The user must do necessary configuration through such representor to enable
mlx5 mdev to send and/or receive packets.

Patchset summary:
-----------------
Patch 1 to 6 prepare mlx5 core driver to create mdev.

Patch-1 Moves mlx5 devlink port close to eswitch port
Patch-2 implements sub function vport representor handling
Patch-3,4 Introduces mlx5 sub function lifecycle routines
Patch-5 Extended mlx5 eswitch to enable/disable sub function vports
Patch-6 Registers mlx5 driver with mdev subsystem for mdev lifecycle

Patch-7 to 10 enhances mdev subsystem for unique alias generation

Patch-7 introduces sha1 based mdev alias
Patch-8 Ensures mdev alias is unique amlong all mdev devices
Patch-9 Exposes mdev alias in sysfs file for systemd/udev usage
Patch-10 Introduces mdev alias API to be used by vendor driver
Patch-11 Improves mdev to avoid nested locking with mlx5_core driver
and devlink subsystem

Patch-12 Introduces new devlink mdev port flavour
Patch-13 Registers devlink eswitch port for a sub function

Patch-14 to 17 implements mdev driver by reusing most of the mlx5_core
driver
Patch-14 implements sharing IRQ between sub function and parent PCI device
Patch-15 implements load, unload routine for sub function
Patch-16 implements dma ops for mediated device
Patch-17 implements mdev driver to bind to mdev device

Patch-18 Adds documentation for mdev overview, example and security model
Patch-19 extends sample mtty driver for mdev alias generation

[1] https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/log/?h=net-next-mlx5
[2] https://www.kernel.org/doc/Documentation/vfio-mediated-device.txt
[3] https://lkml.org/lkml/2019/3/8/819
[4] https://netdevconf.org/0x13/session.html?workshop-hardware-offload
[5] http://man7.org/linux/man-pages/man8/devlink-dev.8.html.
[6] https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c
[7] https://lkml.org/lkml/2019/3/7/696
[8] https://lkml.org/lkml/2019/8/23/146
[9] https://patchwork.ozlabs.org/patch/1190425


Parav Pandit (14):
  net/mlx5: E-switch, Move devlink port close to eswitch port
  net/mlx5: Introduce SF life cycle APIs to allocate/free
  vfio/mdev: Introduce sha1 based mdev alias
  vfio/mdev: Make mdev alias unique among all mdevs
  vfio/mdev: Expose mdev alias in sysfs tree
  vfio/mdev: Introduce an API mdev_alias
  vfio/mdev: Improvise mdev life cycle and parent removal scheme
  devlink: Introduce mdev port flavour
  net/mlx5: Register SF devlink port
  net/mlx5: Add load/unload routines for SF driver binding
  net/mlx5: Implement dma ops and params for mediated device
  net/mlx5: Add mdev driver to bind to mdev devices
  Documentation: net: mlx5: Add mdev usage documentation
  mtty: Optionally support mtty alias

Vu Pham (4):
  net/mlx5: E-Switch, Add SF vport, vport-rep support
  net/mlx5: Introduce SF table framework
  net/mlx5: E-Switch, Enable/disable SF's vport during SF life cycle
  net/mlx5: Add support for mediated devices in switchdev mode

Yuval Avnery (1):
  net/mlx5: Share irqs between SFs and parent PCI device

 .../driver-api/vfio-mediated-device.rst       |   9 +
 .../device_drivers/mellanox/mlx5.rst          | 122 +++++
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  17 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  69 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   8 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  94 +---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  24 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  85 ++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 147 +++++-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  80 +++-
 .../ethernet/mellanox/mlx5/core/meddev/mdev.c | 212 +++++++++
 .../mellanox/mlx5/core/meddev/mdev_driver.c   |  50 +++
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 425 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   |  73 +++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  54 +++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  12 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |   4 +-
 drivers/vfio/mdev/mdev_core.c                 | 198 +++++++-
 drivers/vfio/mdev/mdev_private.h              |   8 +-
 drivers/vfio/mdev/mdev_sysfs.c                |  26 +-
 include/linux/mdev.h                          |   5 +
 include/linux/mlx5/driver.h                   |   8 +-
 include/net/devlink.h                         |   9 +
 include/uapi/linux/devlink.h                  |   5 +
 net/core/devlink.c                            |  32 ++
 samples/vfio-mdev/mtty.c                      |  13 +
 32 files changed, 1678 insertions(+), 143 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev_driver.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h

-- 
2.19.2

