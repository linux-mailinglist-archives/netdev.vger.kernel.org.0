Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A242B0DDA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgKLTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:48 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11869 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgKLTYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8bfa0000>; Thu, 12 Nov 2020 11:24:42 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:41 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 00/13] Add mlx5 subfunction support
Date:   Thu, 12 Nov 2020 21:24:10 +0200
Message-ID: <20201112192424.2742-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209082; bh=Yc7XZ1jHw1TzHoFdNPkFw+cZmxXRKjM6sWLX1SivM5g=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=YiYwTKYeVSqBkD9g16Ee4B+TBb+Th1vtk/vAb+SqobhU5rgtYEcNpYrfcfV8xDglG
         c35ylV8JRcM9T674jx0icFTGYtpMeekJzAaQuRCfeaqsKXos9HYf6nETPr/WU+D8aX
         OhODxcXJKyGvM2shRnPLJ1E3RlCjT4QhHRQJEtYA6pNAFft864uD0pLXksCdRIXpY9
         mtMR6KdXJVNyjgz0+Ez0vpGe5+wLlQFr7K+RipyzzAt2+EcaP94UpMdSZZGliHCana
         PuZES7ru5K5pG/jU9lhEsRBaL17OGto+0lg+coA7bijh36IAkKc5i493ayMoj4/C0z
         2/5gJDvj1DJVw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub, Greg,

This series introduces support for mlx5 subfunction (SF).
A subfunction is a portion of a PCI device that supports multiple
classes of devices such as netdev, RDMA and more.

This patchset is based on Leon's series [3].
It is a third user of proposed auxiliary bus [4].

Subfunction support is discussed in detail in RFC [1] and [2].
RFC [1] and extension [2] describes requirements, design, and proposed
plumbing using devlink, auxiliary bus and sysfs for systemd/udev
support.

Patch summary:
--------------
Patch 1 to 6 prepares devlink:
Patch-1 prepares code to handle multiple port function attributes
Patch-2 introduces devlink pcisf port flavour similar to pcipf and pcivf
Patch-3 adds port add and delete driver callbacks
Patch-4 adds port function state get and set callbacks
Patch-5 refactors devlink to avoid using global mutext
Patch-6 uses refcount to allow creating devlink instance from existing
one
Patch 7 to 13 implements mlx5 pieces for SF support.
Patch-7 adds SF auxiliary device
Patch-8 adds SF auxiliary driver
Patch-9 prepares eswitch to handler SF vport
PAtch-10 adds eswitch helpers to add/remove SF vport
Patch-11 adds SF device configuration commands
Patch-12 implements devlink port add/del callbacks
Patch-13 implements devlink port function get/set callbacks

More on SF plumbing below.

overview:
--------
A subfunction can be created and deleted by a user using devlink port
add/delete interface.

A subfunction can be configured using devlink port function attributes
before its activated.

When a subfunction is activated, it results in an auxiliary device.
A driver binds to the auxiliary device that further creates supported
class devices.

short example sequence:
-----------------------
Change device to switchdev mode:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

Add a devlink port of subfunction flaovur:
$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

Configure mac address of the port function:
$ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88

Now activate the function:
$ devlink port function set ens2f0npf0sf88 state active

Now use the auxiliary device and class devices:
$ devlink dev show
pci/0000:06:00.0
auxiliary/mlx5_core.sf.4

$ ip link show
127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT group default qlen 1000
    link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
    altname enp6s0f0np0
129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFA=
ULT group default qlen 1000
    link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff

$ rdma dev show
43: rdmap6s0f0: node_type ca fw 16.28.1002 node_guid 248a:0703:00b3:d112 sy=
s_image_guid 248a:0703:00b3:d112
44: mlx5_0: node_type ca fw 16.28.1002 node_guid 0000:00ff:fe00:8888 sys_im=
age_guid 248a:0703:00b3:d112

subfunction (SF) in detail:
---------------------------
- A sub-function is a portion of the PCI device which supports multiple
  classes of devices such as netdev, RDMA and more.
- A SF netdev has its own dedicated queues(txq, rxq).
- A SF RDMA device has its own QP1, GID table and other RDMA resources.
- A SF supports eswitch representation and tc offload support similar
  to existing PF and VF representors.
- User must configure eswitch to send/receive SF's packets.
- A SF shares PCI level resources with other SFs and/or with its
  parent PCI function.
  For example, an SF shares IRQ vectors with other SFs and its
  PCI function.
  In future it may have dedicated IRQ vector per SF.
  A SF has dedicated window in PCI BAR space that is not shared
  with other SFs or PF. This ensures that when a SF is assigned to
  an application, only that application can access device resources.
- SF's auxiliary device exposes sfnum sysfs attribute. This will be
  used by systemd/udev to deterministic names for its netdev and
  RDMA device.

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://marc.info/?l=3Dlinux-netdev&m=3D158555928517777&w=3D2
[3] https://lists.linuxfoundation.org/pipermail/virtualization/2020-Novembe=
r/050473.html
[4] https://lore.kernel.org/linux-rdma/20201023003338.1285642-2-david.m.ert=
man@intel.com/

Parav Pandit (11):
  devlink: Prepare code to fill multiple port function attributes
  devlink: Introduce PCI SF port flavour and port attribute
  devlink: Support add and delete devlink port
  devlink: Support get and set state of port function
  devlink: Avoid global devlink mutex, use per instance reload lock
  devlink: Introduce devlink refcount to reduce scope of global
    devlink_mutex
  net/mlx5: SF, Add auxiliary device support
  net/mlx5: SF, Add auxiliary device driver
  net/mlx5: E-switch, Add eswitch helpers for SF vport
  net/mlx5: SF, Add port add delete functionality
  net/mlx5: SF, Port function state change support

Vu Pham (2):
  net/mlx5: E-switch, Prepare eswitch to handle SF vport
  net/mlx5: SF, Add SF configuration hardware commands

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  19 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |   2 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |  41 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  46 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  82 +++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  47 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  48 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  10 +
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  20 +
 .../net/ethernet/mellanox/mlx5/core/sf/cmd.c  |  48 ++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 213 ++++++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  68 +++
 .../mellanox/mlx5/core/sf/dev/driver.c        | 105 ++++
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |  14 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.c   | 498 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  59 +++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |   3 +-
 include/linux/mlx5/driver.h                   |  12 +-
 include/net/devlink.h                         |  82 +++
 include/uapi/linux/devlink.h                  |  26 +
 net/core/devlink.c                            | 362 +++++++++++--
 25 files changed, 1754 insertions(+), 73 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h

--=20
2.26.2

