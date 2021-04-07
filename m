Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364DF3562B7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbhDGEyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhDGEyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B58613C6;
        Wed,  7 Apr 2021 04:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771275;
        bh=YcXjT6JpLoFSzsN8f8t3KPi3MDgmWmUNVU/MTQ3zOXY=;
        h=From:To:Cc:Subject:Date:From;
        b=XFSZNtwVgn+hgeWIZkWQek6zT8fU/Is5KDwHFabIG58H247EH5sTSEwWjC81BXEuD
         JtZ/te8WYcXwNh5pQ2KdP+0pSPKp0ZQonUqfq11bf2Ub4e7gWvb6S//fx2Kz8fW1vS
         7LbkHJnzTfOAkgxQfjp7y4Oma9OXbJ1ovikEN0r2NST9sIUpR1DAN7xBzaa/mcZhDd
         05arYYhGvaLvlSTlm6CIRZzvO2i1PiqOV29R/g6rgiMwnC7XeFwwuy1wV0REKJAUiB
         lWxAdIZtCotTauwfXrvf6NNS4JSZSnpf4lonrAU3OTxlKAARC4ZVx6BU22g+MGI2u3
         SPsdmzyosan2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/13] mlx5 updates 2021-04-06
Date:   Tue,  6 Apr 2021 21:54:08 -0700
Message-Id: <20210407045421.148987-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series From Chris adds the support for TC psample offloads
to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 0b35e0deb5bee7d4882356d6663522c1562a8321:

  docs: ethtool: correct quotes (2021-04-06 16:56:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-06

for you to fetch changes up to f94d6389f6a8abd04760dcd015d14961260a8000:

  net/mlx5e: TC, Add support to offload sample action (2021-04-06 21:36:05 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-06

Introduce TC sample offload

Background
----------

The tc sample action allows user to sample traffic matched by tc
classifier. The sampling consists of choosing packets randomly and
sampling them using psample module.

The tc sample parameters include group id, sampling rate and packet's
truncation (to save kernel-user traffic).

Sample in TC SW
---------------

User must specify rate and group id for sample action, truncate is
optional.

tc filter add dev enp4s0f0_0 ingress protocol ip prio 1 flower	\
	src_mac 02:25:d0:14:01:02 dst_mac 02:25:d0:14:01:03	\
	action sample rate 10 group 5 trunc 60			\
	action mirred egress redirect dev enp4s0f0_1

The tc sample action kernel module 'act_sample' will call another
kernel module 'psample' to send sampled packets to userspace.

MLX5 sample HW offload - MLX5 driver patches
--------------------------------------------

The sample action is translated to a goto flow table object
destination which samples packets according to the provided
sample ratio. Sampled packets are duplicated. One copy is
processed by a termination table, named the sample table,
which sends the packet to the eswitch manager port (that will
be processed by software).

The second copy is processed by the default table which executes
the subsequent actions. The default table is created per <vport,
chain, prio> tuple as rules with different prios and chains may
overlap.

For example, for the following typical flow table:

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
                   |
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
+-----------------------------+  +----------------------------------------+
+        sample table         +  + default table per <vport, chain, prio> +
+-----------------------------+  +----------------------------------------+
+ forward to management vport +  +            original match              +
+-----------------------------+  +----------------------------------------+
                                 +            other actions               +
                                 +----------------------------------------+

Flow sampler object
-------------------

Hardware introduces flow sampler object to do sample. It is a new
destination type. Driver needs to specify two flow table ids in it.
One is sample table id. The other one is the default table id.
Sample table samples the packets according to the sample rate and
forward the sampled packets to eswitch manager port. Default table
finishes the subsequent actions.

Group id and reg_c0
-------------------

Userspace program will take different actions for sampled packets
according to tc sample action group id. So hardware must pass group
id to software for each sampled packets. In Paul Blakey's "Introduce
connection tracking offload" patch set, reg_c0 lower 16 bits are used
for miss packet chain id restore. We convert reg_c0 lower 16 bits to
a common object pool, so other features can also use it.

Since sample group id is 32 bits, create a 16 bits object id to map
the group id and write the object id to reg_c0 lower 16 bits. reg_c0
can only be used for matching. Write reg_c0 to flow_tag, so software
can get the object id via flow_tag and find group id via the common
object pool.

Sampler restore handle
----------------------

Use common object pool to create an object id to map sample parameters.
Allocate a modify header action to write the object id to reg_c0 lower
16 bits. Create a restore rule to pass the object id to software. So
software can identify sampled packets via the object id and send it to
userspace.

Aggregate the modify header action, restore rule and object id to a
sample restore handle. Re-use identical sample restore handle for
the same object id.

Send sampled packets to userspace
---------------------------------

The destination for sampled packets is eswitch manager port, so
representors can receive sampled packets together with the group id.
Driver will send sampled packets and group id to userspace via psample.

----------------------------------------------------------------
Chris Mi (13):
      net/mlx5: E-switch, Move vport table functions to a new file
      net/mlx5: E-switch, Rename functions to follow naming convention.
      net/mlx5: E-switch, Generalize per vport table API
      net/mlx5: E-switch, Set per vport table default group number
      net/mlx5: Map register values to restore objects
      net/mlx5: Instantiate separate mapping objects for FDB and NIC tables
      net/mlx5e: TC, Parse sample action
      net/mlx5e: TC, Add sampler termination table API
      net/mlx5e: TC, Add sampler object API
      net/mlx5e: TC, Add sampler restore handle API
      net/mlx5e: TC, Refactor tc update skb function
      net/mlx5e: TC, Handle sampled packets
      net/mlx5e: TC, Add support to offload sample action

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  12 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  77 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  95 +++-
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c   | 585 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/sample.h   |  42 ++
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c | 140 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  45 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 310 ++++-------
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  52 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |   6 +-
 include/linux/mlx5/eswitch.h                       |   9 +-
 15 files changed, 1101 insertions(+), 283 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
