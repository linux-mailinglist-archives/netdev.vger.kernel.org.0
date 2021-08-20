Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11813F2616
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhHTE4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHTE4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8390F60FF2;
        Fri, 20 Aug 2021 04:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435323;
        bh=KYssx4rqXlDQrrOv0/El9+dvwgiFMsUuBQUrdsnqwaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bqmox3/6eYvCGWbLffNB2CZ/VLbNbCDOEzebPgCN2qFq0Y+YAm1MF0uX4rge00jcY
         Cmo3dYfIRnypF3Si9JCV85QnYaHc0cm58YT1XUpLcwvSqTZJg8pPXFkh9qH04fdz+7
         gFLU26f85WDWrGWqvPdM2jwS2nc7BQb7hHG435k5vVVIMd1UorCBX/+/z3f+qXQhzl
         t1o28dKSHhYszpd9C64esNb3UcKKNbzC+NgoO6CVq7MUGm6+Xu7xdh68XbOM769rac
         u0NYwRCuMUwdYVviIQjV4R6Rt9ldnwVBj4FOJJ8ZwWMvGkKqgKgY8jcuZ65b0zjuM4
         oEpJZMZNw9A2A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-08-19
Date:   Thu, 19 Aug 2021 21:55:00 -0700
Message-Id: <20210820045515.265297-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave & Jakub,

This series provides mlx5 support for:

1) TC flow sampling offload for tunneled traffic.
2) devlink QoS rate object groups

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit f444fea7896dbc267249d27f604082a51b8efca2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-08-19 18:09:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-08-19

for you to fetch changes up to 3202ea65f85c5488926e01aa51d73d53dfe17e6e:

  net/mlx5: E-switch, Add QoS tracepoints (2021-08-19 21:50:41 -0700)

----------------------------------------------------------------
mlx5-updates-2021-08-19

This series introduces the support for two new mlx5 features:

1) Sample offload for tunneled traffic
2) devlink rate objects support

1) From Chris Mi: Sample offload for tunneled traffic
=====================================================

Background and solution
-----------------------

Currently the sample offload actions send the encapsulated packet
to software. This series de-capsulates the packet before performing
the sampling and set the tunnel properties on the skb metadata
fields to make the behavior consistent with OVS sFlow.

If de-capsulating first, we can't use the same match like before in
default table. So instantiate a post action instance to continue
processing the action list. If HW can preserve reg_c, also use the
post action instance.

Post action infrastructure
--------------------------

Some tc actions are modeled in hardware using multiple tables
causing a tc action list split. For example, CT action is modeled
by jumping to a ct table which is controlled by nf flow table.
sFlow jumps in hardware to a sample table, which continues to a
"default table" where it should continue processing the action list.

Multi table actions are modeled in hardware using a unique fte_id.
The fte_id is set before jumping to a table. Split actions continue
to a post-action table where the matched fte_id value continues the
execution the tc action list.

This series also introduces post action infrastructure. Both ct and
sample use it.

Sample for tunnel in TC SW
--------------------------

tc filter add dev vxlan1 protocol ip parent ffff: prio 3		\
	flower src_mac 24:25:d0:e1:00:00 dst_mac 02:25:d0:13:01:02	\
	enc_src_ip 192.168.1.14 enc_dst_ip 192.168.1.13			\
	enc_dst_port 4789 enc_key_id 4					\
	action sample rate 1 group 6					\
	action tunnel_key unset						\
	action mirred egress redirect dev enp4s0f0_1

MLX5 sample HW offload
----------------------

For the following typical flow table:

+-------------------------------+
+       original flow table     +
+-------------------------------+
+         original match        +
+-------------------------------+
+ sample action + other actions +
+-------------------------------+

We translate the tc filter with sample action to the following HW model:

        +---------------------+
        + original flow table +
        +---------------------+
        +   original match    +
        +---------------------+
              | set fte_id (if reg_c preserve cap)
              | do decap
              v
+------------------------------------------------+
+                Flow Sampler Object             +
+------------------------------------------------+
+                    sample ratio                +
+------------------------------------------------+
+    sample table id    |    default table id    +
+------------------------------------------------+
           |                            |
           v                            v
+-----------------------------+  +-------------------+
+        sample table         +  +   default table   +
+-----------------------------+  +-------------------+
+ forward to management vport +             |
+-----------------------------+             |
                                    +-------+------+
                                    |              |reg_c preserve cap
                                    |              |or decap action
                                    v              v
                       +-----------------+   +-------------+
                       + per vport table +   + post action +
                       +-----------------+   +-------------+
                       + original match  +
                       +-----------------+
                       + other actions   +
                       +-----------------+

2) From Dmytro Linkin: devlink rate object support for mlx5_core driver
=======================================================================

HIGH-LEVEL OVERVIEW

Devlink leaf rate objects created per vport (VF/SF, and PF on BlueField)
in switchdev mode on devlink port registration.
Implement devlink ops callbacks to create/destroy rate groups, set TX
rate values of the vport/group, assign vport to the group.
Driver accepts TX rate values as fraction of 1Mbps.

Refactor existing eswitch QoS infrastructure to be accessible by legacy
NDO rate API and new devlink rate API. NDO rate API is not
removed/disabled in switchdev mode to not break existing users. Rate
values configured with NDO rate API are not visible for devlink
infrastructure, therefore APIs should not be used simultaneously.

IMPLEMENTATION DETAILS

Driver provide two level rate hierarchy to manage bandwidth - group
level and vport level. Initially each vport added to internal unlimited
group created by default. Each rate element (vport or group) receive
bandwidth relative to its parent element (for groups the parent is a
physical link itself) in a Round Robin manner, where element get
bandwidth value according to its weight. Example:

Created four rate groups with tx_share limits:

$ devlink port function rate add \
    pci/0000:06:00.0/group_1 tx_share 30gbit
$ devlink port function rate add \
    pci/0000:06:00.0/group_2 tx_share 20gbit
$ devlink port function rate add \
    pci/0000:06:00.0/group_3 tx_share 20gbit
$ devlink port function rate add \
    pci/0000:06:00.0/group_4 tx_share 10gbit

Weights created in HW for each group are relative to the bigest tx_share
value, which is 30gbit:

<group_1> 1.0
<group_2> 0.67
<group_3> 0.67
<group_4> 0.33

Assuming link speed is 50 Gbit/sec and each group can sustain such
amount of traffic, maximum bandwidth is 50 / (1.0 + 0.67 + 0.67 + 0.33)
 = ~18.75 Gbit/sec. Normilized bandwidth values for groups:

<group_1> 18.75 * 1.0  = 18.75 Gbit/sec
<group_2> 18.75 * 0.67 = 12.5 Gbit/sec
<group_3> 18.75 * 0.67 = 12.5 Gbit/sec
<group_4> 18.75 * 0.33 = 6.25 Gbit/sec

If in example above group_1 doesn't produce any traffic, then maximum
bandwidth becomes 50 / (0.67 + 0.67 + 0.33) = ~30.0 Gbit/sec. Normalized
values:

<group_2> 30.0 * 0.67 = 20.0 Gbit/sec
<group_3> 30.0 * 0.67 = 20.0 Gbit/sec
<group_4> 30.0 * 0.33 = 10.0 Gbit/sec

Same normalization applied to each vport in the group.

Normalized values are internal, therefore driver provides QoS
tracepoints for next events:

* vport rate element creation/deletion:
* vport rate element configuration;
* group rate element creation/deletion;
* group rate element configuration.

PATCHES OVERVIEW

1 - Moving and isolation of eswitch QoS logic in separate file;

2 - Implement devlink leaf rate object support for vports;

3 - Implement rate groups creation/deletion;

4 - Implement TX rate management for the groups;

5 - Implement parent set for vports;

6 - Eswitch QoS tracepoints.

----------------------------------------------------------------
Chris Mi (8):
      net/mlx5e: Move esw/sample to en/tc/sample
      net/mlx5e: Move sample attribute to flow attribute
      net/mlx5e: CT, Use xarray to manage fte ids
      net/mlx5e: Introduce post action infrastructure
      net/mlx5e: Refactor ct to use post action infrastructure
      net/mlx5e: TC, Remove CONFIG_NET_TC_SKB_EXT dependency when restoring tunnel
      net/mlx5e: TC, Restore tunnel info for sample offload
      net/mlx5e: TC, Support sample offload action for tunneled traffic

Dmytro Linkin (6):
      net/mlx5: E-switch, Move QoS related code to dedicated file
      net/mlx5: E-switch, Enable devlink port tx_{share|max} rate control
      net/mlx5: E-switch, Introduce rate limiting groups API
      net/mlx5: E-switch, Allow setting share/max tx rate limits of rate groups
      net/mlx5: E-switch, Allow to add vports to rate groups
      net/mlx5: E-switch, Add QoS tracepoints

Saeed Mahameed (1):
      net/mlx5e: Remove mlx5e dependency from E-Switch sample

 .../device_drivers/ethernet/mellanox/mlx5.rst      |  44 ++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  48 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   | 164 ++++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |  35 +
 .../mellanox/mlx5/core/{esw => en/tc}/sample.c     | 474 +++++++----
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |  41 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 154 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  57 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   1 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  26 +
 .../mellanox/mlx5/core/esw/diag/qos_tracepoint.h   | 123 +++
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |  20 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  | 869 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h  |  41 +
 .../net/ethernet/mellanox/mlx5/core/esw/sample.h   |  42 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 310 +-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  21 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  11 +-
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 24 files changed, 1815 insertions(+), 703 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{esw => en/tc}/sample.c (53%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
