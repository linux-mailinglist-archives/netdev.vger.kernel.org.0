Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A319B3A226E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFJDAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJDAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FCF660D07;
        Thu, 10 Jun 2021 02:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293898;
        bh=kdt+QYuMaZXz6rKgJk7k0EL6lSdCYikbMUi6742Ldfg=;
        h=From:To:Cc:Subject:Date:From;
        b=Gxhx9oy0RXQUliDPe2dGhvw7N1dqQa5McQTNMR40YpuXdU2pMADvXlpKwAf2n30yv
         oXOslMcGHyjOCY7SHxrTqI13YBLRGhtHgKT+z+sBX4zCpsX9Zy/UU8S3kDUXOTLmws
         M/M2XnRECA6ZEAwV/030xKk/eX3AiPJSdScz35Ajuw5SRfTrsUqjl6/V0eiG0hmV9U
         Bpahhc7mwYS66ZeoQPcW78x/Craw0T5wzjDoFZztX6blF07Fz6kS6H0BeIwoWoGHSW
         zaR7rkD/GJqTuYVaIXbm7pskYa5qoQJsgyjjd/FgYJ6a80th4grTwSdqacvmAd1DqX
         k2DZ0w08wufrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2021-06-09
Date:   Wed,  9 Jun 2021 19:57:58 -0700
Message-Id: <20210610025814.274607-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series introduces insert/remove header support
for sw steering and switchdev bridge offloads support.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 0d155170d6eebbd6c50e16bc928c31b3f5473025:

  Merge branch 'ipa-mem-1' (2021-06-09 15:59:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-06-09

for you to fetch changes up to 9724fd5d9c2a0d3686b799ed5ca90cb9378ca4f2:

  net/mlx5: Bridge, add tracepoints (2021-06-09 18:36:12 -0700)

----------------------------------------------------------------
mlx5-updates-2021-06-09

Introduce steering header insert/remove and switchdev bridge offloads

1) From Yevgeny, Steering header insert/remove support

ConnectX supports offloading of various encapsulations and decapsulations
(e.g. VXLAN), which are performed by 'Packet Reformat' action.
Starting with ConnectX-6 DX, a new reformat type is supported - INSERT_HEADER.
This reformat allows inserting an arbitrary size buffer at a selected location
in the packet on RX flows.

The insert/remove header support are needed as a prerequisite for the
bridge offloads vlan pop/push supprt, see below.

2) From Vlad, Support for bridge offloads for switchdev mode

This change implements bridge offloads with VLAN-support that works on top
of mlx5 representors in switchdev mode.

HIGH-LEVEL OVERVIEW

Hardware supported by mlx5 driver doesn't provide dynamic learning or aging
functionality and requires the driver to emulate all switch-like behavior
in software. As such, all packets by default go through miss path, appear
on representor and get to software bridge, if it is the upper device of the
representor. This causes bridge to process packet in software, learn the
MAC address to FDB and send SWITCHDEV_FDB_ADD_TO_DEVICE event to all
subscribers. Upon reception of SWITCHDEV_FDB_ADD_TO_DEVICE notification
mlx5 bridge offloads the FDB to hardware and sends back
SWITCHDEV_FDB_ADD_TO_BRIDGE notification to prevent such entries from being
aged out by kernel bridge. Leaving aging to kernel bridge would result
deletion of offloaded dynamic FDB entries every aging_time period due to
packets being processed by hardware and, consecutively, 'used' timestamp
for FDB entry not being updated. Hardware aging is emulated in driver by
running periodic workqueue task that manually updates the rules according
to their hardware counter:

- If hardware counter has changed since last update, the handler updates
'used' timestamp in kernel bridge dynamic entry by sending
SWITCHDEV_FDB_ADD_TO_BRIDGE notification for the entry.

- If FDB entry wasn't updated for user-controllable aging_time period,
then the FDB entry is unoffloaded from hardware and corresponding
SWITCHDEV_FDB_DEL_TO_BRIDGE notification is sent to kernel bridge.

The mlx5 bridge offload implementation fully supports port VLAN objects,
including PVID (vlan push) and "Egress Untagged" (vlan pop).

SOFTWARE ARCHITECTURE

Mlx5_eswitch is extended with pointer to new mlx5_esw_bridge_offloads
structure which has a linked list of mlx5_esw_bridge objects. Struct
mlx5_esw_bridge is the main switch object in mlx5 that holds all data for
offloaded FDB entries and metadata for bridge ports and their vlans. The
mlx5_esw_bridge object is created when first representor of eswitch vport
is added to bridge and deleted when the last representor is detached from
it. Bridge FDB entries are saved in linked list (to iterate over all FDB
entries in aging workqueue task) and also in hashtable for quick lookup by
MAC+VLAN tuple. Bridge FDB entries are saved in linked list (to iterate
over all FDB entries in aging workqueue task) and in hashtable for quick
lookup by MAC+VLAN tuple. Port metadata is stored in struct
mlx5_esw_bridge_port that is saved in xarray to allow quick lookup by vport
number. Part of the port metadata is the set of port vlans that are
represented by mlx5_esw_bridge_vlan structure. The vlan structure points to
all FDBs on vlan/port via fdb_list linked list.

Simplified diagram of mlx5 bridge objects:

                      +------------------+
                      |  mxl5_eswitch    |
                      |                  |
                      |  br_offloads     |
                      +--------+---------+
                               |
                      +--------v-------------------+
                      |  mlx5_esw_bridge_offloads  |
                      |                            |
                   +-->  bridges                   |
                   |  +-------+--------------------+
                   |          |
                   |          |
                   |      +---v---------------+
                   |      | mlx5_esw_bridge   |
                   |      |                   |
                   |      | vports            |
                   |      |                   |
                   |      | fdb_ht            |
                   |      +---+---------------+
                   |          |
                   |      +---v---------------+
                   +------+ mlx5_esw_bridge   |
                          |                   |
+-------------------------+ vports            |
|                         |                   |
|                         | fdb_ht            +------------------------------------------+
|                         +-------------------+                                          |
|                                                                                        |
|                                                                                        |
| +----------------------+                                 +---------------------------+ |
+-> mlx5_esw_bridge_port |                              +--> mlx5_esw_bridge_fdb_entry <-+
| |                      |    +----------------------+  |  +--+------------------------+ |
| | vlans                +--+-> mlx5_esw_bridge_vlan |  |     |                          |
| |                      |  | |                      |  |  +--v------------------------+ |
| +----------------------+  | | fdb_list             +--+  | mlx5_esw_bridge_fdb_entry <-+
|                           | +-------^--------------+     +--+------------------------+ |
| +----------------------+  |         |                       |                          |
+-> mlx5_esw_bridge_port |  |         +-----------------------+                          |
  |                      |  |                                                            |
  | vlans                |  | -----------------------+                                   |
  |                      |  +-> mlx5_esw_bridge_vlan |                                   |
  +----------------------+    |                      |     +---------------------------+ |
                              | fdb_list             +-----> mlx5_esw_bridge_fdb_entry <-+
                              +-------^--------------+     +--+------------------------+
                                      |                       |
                                      +-----------------------+

HARDWARE REPRESENTATION

In order to adhere to kernel software datapath model bridge offloads must
come after TC and NF FDBs. However, since netfilter offload in mlx5 is
implemented with unmanaged tables, its miss path is not automatically
connected to next priority and requires the code to manually connect with
slow table. To keep bridge offloads encapsulated and not mix it with
eswitch offloads new FDB_TC_MISS priority is created between FDB_FT_OFFLOAD
and FDB_SLOW_PATH which allows bridge offloads to be created without
exposing its internal tables to any other modules since miss path of
managed TC-miss table is automatically wired to next priority.

The bridge tables are created with new priority FDB_BR_OFFLOAD in FDB
namespace. The new priority is between tc-miss and slow path priorities.
Priority consist of two levels: the ingress table that is global per
eswitch and matches incoming packets by src_mac/vid and redirects them to
next level (egress table) that is chosen according to ingress port bridge
membership and matches on dst_mac/vid in order to redirect packet to vport
according to the following diagram:

                +
                |
      +---------v----------+
      |                    |
      |   FDB_TC_OFFLOAD   |
      |                    |
      +---------+----------+
                |
                |
      +---------v----------+
      |                    |
      |   FDB_FT_OFFLOAD   |
      |                    |
      +---------+----------+
                |
                |
      +---------v----------+
      |                    |
      |    FDB_TC_MISS     |
      |                    |
      +---------+----------+
                |
+--------------------------------------+
|               |                      |
|        +------+                      |
|        |                             |
| +------v--------+   FDB_BR_OFFLOAD   |
| | INGRESS_TABLE |                    |
| +------+---+----+                    |
|        |   |      match              |
|        |   +---------+               |
|        |             |               |    +-------+
|        |     +-------v-------+ match |    |       |
|        |     | EGRESS_TABLE  +------------> vport |
|        |     +-------+-------+       |    |       |
|        |             |               |    +-------+
|        |    miss     |               |
|        +------+------+               |
|               |                      |
+--------------------------------------+
                |
                |
      +---------v----------+
      |                    |
      |   FDB_SLOW_PATH    |
      |                    |
      +---------+----------+
                |
                v

PATCHES OVERVIEW

1-3 - Miscellaneous refactorings and infrastructure changes.

4 - Mlx5 bridge offload infrastructure and dedicated fs_core
namespace/tables implementation.

5 - FDB entry offload.

6 - Dynamic FDB entry aging.

7-10 - VLAN filtering offload.

11 - Tracepoints for main mlx5 bridge offload events (FDB entry
offload/unoffload, VLAN add/delete, etc.)

--

----------------------------------------------------------------
Vlad Buslov (10):
      net/mlx5: Create TC-miss priority and table
      net/mlx5e: Refactor mlx5e_eswitch_{*}rep() helpers
      net/mlx5: Bridge, add offload infrastructure
      net/mlx5: Bridge, handle FDB events
      net/mlx5: Bridge, dynamic entry ageing
      net/mlx5: Bridge, implement infrastructure for vlans
      net/mlx5: Bridge, match FDB entry vlan tag
      net/mlx5: Bridge, support pvid and untagged vlan configurations
      net/mlx5: Bridge, filter tagged packets that didn't match tagged fg
      net/mlx5: Bridge, add tracepoints

Yevgeny Kliteynik (6):
      net/mlx5: mlx5_ifc support for header insert/remove
      net/mlx5: DR, Split reformat state to Encap and Decap
      net/mlx5: DR, Allow encap action for RX for supporting devices
      net/mlx5: Added new parameters to reformat context
      net/mlx5: DR, Added support for INSERT_HEADER reformat type
      net/mlx5: DR, Support EMD tag in modify header for STEv1

 .../device_drivers/ethernet/mellanox/mlx5.rst      |   88 ++
 drivers/infiniband/hw/mlx5/fs.c                    |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    1 +
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  424 +++++++
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.h    |   21 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   38 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   | 1299 ++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   53 +
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   53 +
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |  113 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    7 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   29 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    6 +
 .../mellanox/mlx5/core/steering/dr_action.c        |  187 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    7 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |    1 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |    5 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  120 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   22 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   20 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    3 +
 include/linux/mlx5/device.h                        |   10 +
 include/linux/mlx5/fs.h                            |   14 +-
 include/linux/mlx5/mlx5_ifc.h                      |   40 +-
 31 files changed, 2523 insertions(+), 131 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
