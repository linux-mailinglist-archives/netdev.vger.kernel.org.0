Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33A33EE052
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhHPXXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhHPXXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAE2B60EBD;
        Mon, 16 Aug 2021 23:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156149;
        bh=CH23DsHX/maIqLmtCdJRf9qrVjvoL0tdxW8A0YGUTWA=;
        h=From:To:Cc:Subject:Date:From;
        b=Xw/jPjikC2WySQMhLoeP6kQZiSgadaJCsLFzhcsw4SeRtj5L/AdoeaGx29qCxnLf2
         nfmjZOFTlR/GZ7AcQKOl8q0YYCB3MOenk/NcgWQh3JZ0c6zfhq8lieQPCu4vOV5P57
         /V2Pv4tBuKuNJ7A0ZsobVBn6qhuYUQYolXak1s6zA23gwe6q+0liscxC2FQv+a2bj/
         zDx5o3ypNXCLkVRuVR1ClRCwXV31CW3HDP6YMh467T7/q9oe36quekYfGB9BQbju/7
         YbQKqgfx13pd3ctgVvAjo2iTAY4Lt3HR1wM1OjyhB5my14QG1fgwN9YsBC7wpVF4A7
         9fb77mUnrL9zw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/17] mlx5 updates 2021-08-16
Date:   Mon, 16 Aug 2021 16:22:02 -0700
Message-Id: <20210816232219.557083-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series adds the support for TC MQPRIO channel mode and Lag mode for
mlx5 bridge offloads.

v1->v2:
 - Fix variable ‘priv’ set but not used, patch #16.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1b3f78df6a80932d7deb0155d8b0871e8d3e4bca:

  bonding: improve nl error msg when device can't be enslaved because of IFF_MASTER (2021-08-16 14:03:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-08-16

for you to fetch changes up to ff9b7521468bc2909293c1cda66a245a49688f6f:

  net/mlx5: Bridge, support LAG (2021-08-16 16:17:32 -0700)

----------------------------------------------------------------
mlx5-updates-2021-08-16

The following patchset provides two separate mlx5 updates
1) Ethtool RSS context and MQPRIO channel mode support:
  1.1) enable mlx5e netdev driver to allow creating Transport Interface RX
       (TIRs) objects on the fly to be used for ethtool RSS contexts and
       TX MQPRIO channel mode
  1.2) Introduce mlx5e_rss object to manage such TIRs.
  1.3) Ethtool support for RSS context
  1.4) Support MQPRIO channel mode

2) Bridge offloads Lag support:
   to allow adding bond net devices to mlx5 bridge
  2.1) Address bridge port by (vport_num, esw_owner_vhca_id) pair
       since vport_num is only unique per eswitch and in lag mode we
       need to manage ports from both eswitches.
  2.2) Allow connectivity between representors of different eswitch
       instances that are attached to same bridge
  2.3) Bridge LAG, Require representors to be in shared FDB mode and
       introduce local and peer ports representors,
       match on paired eswitch metadata in peer FDB entries,
       And finally support addition/deletion and aging of peer flows.

----------------------------------------------------------------
Tariq Toukan (11):
      net/mlx5e: Do not try enable RSS when resetting indir table
      net/mlx5e: Introduce TIR create/destroy API in rx_res
      net/mlx5e: Introduce abstraction of RSS context
      net/mlx5e: Convert RSS to a dedicated object
      net/mlx5e: Dynamically allocate TIRs in RSS contexts
      net/mlx5e: Support multiple RSS contexts
      net/mlx5e: Support flow classification into RSS contexts
      net/mlx5e: Abstract MQPRIO params
      net/mlx5e: Maintain MQPRIO mode parameter
      net/mlx5e: Handle errors of netdev_set_num_tc()
      net/mlx5e: Support MQPRIO channel mode

Vlad Buslov (6):
      net/mlx5: Bridge, release bridge in same function where it is taken
      net/mlx5: Bridge, obtain core device from eswitch instead of priv
      net/mlx5: Bridge, identify port by vport_num+esw_owner_vhca_id pair
      net/mlx5: Bridge, extract FDB delete notification to function
      net/mlx5: Bridge, allow merged eswitch connectivity
      net/mlx5: Bridge, support LAG

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    | 329 +++++++----
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   | 588 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h   |  49 ++
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    | 603 ++++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  71 ++-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  99 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 176 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   | 359 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |  46 +-
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   9 +
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 -
 19 files changed, 1696 insertions(+), 716 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h
