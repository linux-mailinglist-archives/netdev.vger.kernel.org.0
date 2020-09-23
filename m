Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EBB27641D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWWsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWWsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:36 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA1A208E4;
        Wed, 23 Sep 2020 22:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901315;
        bh=nPPi5hUt89eRIJEHn2NULKtpqHxhFoc/Ln2e1dstRBw=;
        h=From:To:Cc:Subject:Date:From;
        b=o4AsmmHnzBggw04w7B5nkwVr5sOcIiqqfQ3XCFbFanIvjQKfEbHgfztIOdBT22wJ7
         4NAjiEn4LRZpvKStc+h0iLLZFC2M6OjjqbVhh53Tres9A0KuUhJ4+GpG6jReQUlkgL
         oblPC9QGzOHYDtPoOSwFZYvpym+5eCliXfZeL2J0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/15] mlx5 Connection Tracking in NIC mode 
Date:   Wed, 23 Sep 2020 15:48:09 -0700
Message-Id: <20200923224824.67340-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series adds the support for connection tracking in NIC mode,
and attached to this series some trivial cleanup patches.
v1->v2:
 - Remove "fixup!" comment from commit message (Jakub)
 - More information and use case description in the tag message
   (Cover-letter) (Jakub)

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---

The following changes since commit 748d1c8a425ec529d541f082ee7a81f6a51fa120:

  Merge branch 'devlink-Use-nla_policy-to-validate-range' (2020-09-22 17:38:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-22

for you to fetch changes up to 987cd5f049a2b5ed46901f6a874040a08d21d31f:

  net/mlx5: remove unreachable return (2020-09-23 15:44:39 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-22

This series includes mlx5 updates

1) Add support for Connection Tracking offload in NIC mode.
   Supporting CT offload in NIC mode on Mellanox cards is useful for
   scenarios where the dual port NIC serves as a gateway between 2
   networks and forwards traffic between these networks.

   Since the traffic is not terminated on the host in this case,
   no use of SRIOV VFs and/or switchdev mode is required.

   Today Mellanox NIC cards already support offloading of packet forwarding
   between physical ports without going to the host so combining it with CT
   offloading allows users to create a gateway with forwarding and CT
   (Including NAT) offloading capabilities in non-switchdev mode.

   To support connection tracking in non-Switchdev mode (Single NIC mode),
   we need to make use of the current Connection tracking infrastructure
   implemented on top of E-Switch and the mlx5 generic flow table chains
   APIs, to make it work on non-Eswitch steering domain e.g. NIC RX domain,
   the following was performed:

 1.1) Refactor current flow steering chains infrastructure and
      updates TC nic mode implementation to use flow table chains.
 1.2) Refactor current Connection Tracking (CT) infrastructure to not
      assume E-switch backend, and make the CT layer agnostic to
      underlying steering mode (E-Switch/NIC)
 1.3) Plumbing to support CT offload in NIC mode.

2) Trivial code cleanups.

----------------------------------------------------------------
Ariel Levkovich (9):
      net/mlx5: Refactor multi chains and prios support
      net/mlx5: Allow ft level ignore for nic rx tables
      net/mlx5e: Tc nic flows to use mlx5_chains flow tables
      net/mlx5e: Split nic tc flow allocation and creation
      net/mlx5: Refactor tc flow attributes structure
      net/mlx5e: Add tc chains offload support for nic flows
      net/mlx5e: rework ct offload init messages
      net/mlx5e: Support CT offload for tc nic flows
      net/mlx5e: Keep direct reference to mlx5_core_dev in tc ct

Denis Efremov (2):
      net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
      net/mlx5e: Use kfree() to free fd->g in accel_fs_tcp_create_groups()

Oz Shlomo (1):
      net/mlx5e: CT: Use the same counter for both directions

Pavel Machek (CIP) (1):
      net/mlx5: remove unreachable return

Qinglang Miao (1):
      net/mlx5: simplify the return expression of mlx5_ec_init()

Saeed Mahameed (1):
      net/mlx5e: TC: Remove unused parameter from mlx5_tc_ct_add_no_trk_match()

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 525 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  75 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 865 +++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  97 +++
 .../net/ethernet/mellanox/mlx5/core/esw/chains.c   | 944 ---------------------
 .../net/ethernet/mellanox/mlx5/core/esw/chains.h   |  68 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  39 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 309 +++++--
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 -
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 911 ++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |  93 ++
 21 files changed, 2339 insertions(+), 1658 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
