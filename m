Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031812D8510
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 07:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438360AbgLLGNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 01:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgLLGNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 01:13:30 -0500
From:   Saeed Mahameed <saeed@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Saeed Mahameed <saeed@kernel.org>
Subject: [net-next v3 00/14] Add mlx5 subfunction support
Date:   Fri, 11 Dec 2020 22:12:11 -0800
Message-Id: <20201212061225.617337-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub, Jason,

This series form Parav was the theme of this mlx5 release cycle,
we've been waiting anxiously for the auxbus infrastructure to make it into
the kernel, and now as the auxbus is in and all the stars are aligned, I
can finally submit this V2 of the devlink and mlx5 subfunction support.

Subfunctions came to solve the scaling issue of virtualization
and switchdev environments, where SRIOV failed to deliver and users ran
out of VFs very quickly as SRIOV demands huge amount of physical resources
in both of the servers and the NIC.

Subfunction provide the same functionality as SRIOV but in a very
lightweight manner, please see the thorough and detailed
documentation from Parav below, in the commit messages and the
Networking documentation patches at the end of this series.

Sending V2/V3 as a continuation to V1 that was sent Last month [0],
[0] https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidia.com/

---
Changelog:
v1->v2:
 - added documentation for subfunction and its mlx5 implementation
 - add MLX5_SF config option documentation
 - rebased
 - dropped devlink global lock improvement patch as mlx5 doesn't support
   reload while SFs are allocated
 - dropped devlink reload lock patch as mlx5 doesn't support reload
   when SFs are allocated
 - using updated vhca event from device to add remove auxiliary device
 - split sf devlink port allocation and sf hardware context allocation

v2->v3:
 - added header file sf/priv.h to cmd.c to avoid missing prototype warning
 - made mlx5_sf_table_disable as static function as its used only in one file

Parav Pandit Says:
=================

This patchset introduces support for mlx5 subfunction (SF).

A subfunction is a lightweight function that has a parent PCI function on
which it is deployed. mlx5 subfunction has its own function capabilities
and its own resources. This means a subfunction has its own dedicated
queues(txq, rxq, cq, eq). These queues are neither shared nor stealed from
the parent PCI function.

When subfunction is RDMA capable, it has its own QP1, GID table and rdma
resources neither shared nor stealed from the parent PCI function.

A subfunction has dedicated window in PCI BAR space that is not shared
with ther other subfunctions or parent PCI function. This ensures that all
class devices of the subfunction accesses only assigned PCI BAR space.

A Subfunction supports eswitch representation through which it supports tc
offloads. User must configure eswitch to send/receive packets from/to
subfunction port.

Subfunctions share PCI level resources such as PCI MSI-X IRQs with
their other subfunctions and/or with its parent PCI function.

Patch summary:
--------------
Patch 1 to 4 prepares devlink
patch 5 to 7 mlx5 adds SF device support
Patch 8 to 11 mlx5 adds SF devlink port support
Patch 12 and 14 adds documentation

Patch-1 prepares code to handle multiple port function attributes
Patch-2 introduces devlink pcisf port flavour similar to pcipf and pcivf
Patch-3 adds port add and delete driver callbacks
Patch-4 adds port function state get and set callbacks
Patch-5 mlx5 vhca event notifier support to distribute subfunction
        state change notification
Patch-6 adds SF auxiliary device
Patch-7 adds SF auxiliary driver
Patch-8 prepares eswitch to handler SF vport
Patch-9 adds eswitch helpers to add/remove SF vport
Patch-10 implements devlink port add/del callbacks
Patch-11 implements devlink port function get/set callbacks
Patch-12 to 14 adds documentation
Patch-12 added mlx5 port function documentation
Patch-13 adds subfunction documentation
Patch-14 adds mlx5 subfunction documentation

Subfunction support is discussed in detail in RFC [1] and [2].
RFC [1] and extension [2] describes requirements, design and proposed
plumbing using devlink, auxiliary bus and sysfs for systemd/udev
support. Functionality of this patchset is best explained using real
examples further below.

overview:
--------
A subfunction can be created and deleted by a user using devlink port
add/delete interface.

A subfunction can be configured using devlink port function attribute
before its activated.

When a subfunction is activated, it results in an auxiliary device on
the host PCI device where it is deployed. A driver binds to the
auxiliary device that further creates supported class devices.

example subfunction usage sequence:
-----------------------------------
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
127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
    altname enp6s0f0np0
129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff

$ rdma dev show
43: rdmap6s0f0: node_type ca fw 16.29.0550 node_guid 248a:0703:00b3:d112 sys_image_guid 248a:0703:00b3:d112
44: mlx5_0: node_type ca fw 16.29.0550 node_guid 0000:00ff:fe00:8888 sys_image_guid 248a:0703:00b3:d112

After use inactivate the function:
$ devlink port function set ens2f0npf0sf88 state inactive

Now delete the subfunction port:
$ devlink port del ens2f0npf0sf88

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://marc.info/?l=linux-netdev&m=158555928517777&w=2

=================

Parav Pandit (13):
  devlink: Prepare code to fill multiple port function attributes
  devlink: Introduce PCI SF port flavour and port attribute
  devlink: Support add and delete devlink port
  devlink: Support get and set state of port function
  net/mlx5: Introduce vhca state event notifier
  net/mlx5: SF, Add auxiliary device support
  net/mlx5: SF, Add auxiliary device driver
  net/mlx5: E-switch, Add eswitch helpers for SF vport
  net/mlx5: SF, Add port add delete functionality
  net/mlx5: SF, Port function state change support
  devlink: Add devlink port documentation
  devlink: Extend devlink port documentation for subfunctions
  net/mlx5: Add devlink subfunction port documentation

Vu Pham (1):
  net/mlx5: E-switch, Prepare eswitch to handle SF vport

 Documentation/driver-api/auxiliary_bus.rst    |   2 +
 .../device_drivers/ethernet/mellanox/mlx5.rst | 209 +++++++
 .../networking/devlink/devlink-port.rst       | 199 +++++++
 Documentation/networking/devlink/index.rst    |   1 +
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  19 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   8 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  19 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   5 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |   2 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |  41 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  48 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  78 +++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  47 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  |   7 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  60 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  12 +
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  20 +
 .../net/ethernet/mellanox/mlx5/core/sf/cmd.c  |  49 ++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 271 +++++++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  55 ++
 .../mellanox/mlx5/core/sf/dev/driver.c        | 101 ++++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 552 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 233 ++++++++
 .../mlx5/core/sf/mlx5_ifc_vhca_event.h        |  82 +++
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |  21 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  92 +++
 .../mellanox/mlx5/core/sf/vhca_event.c        | 189 ++++++
 .../mellanox/mlx5/core/sf/vhca_event.h        |  57 ++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |   3 +-
 include/linux/mlx5/driver.h                   |  16 +-
 include/net/devlink.h                         |  79 +++
 include/uapi/linux/devlink.h                  |  26 +
 net/core/devlink.c                            | 266 ++++++++-
 34 files changed, 2831 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h

-- 
2.26.2

