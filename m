Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9568134E01D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhC3E2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhC3E1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB9D6044F;
        Tue, 30 Mar 2021 04:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078464;
        bh=e4nM6kOX8Y9ZvnxdisT3+XF786JAWbgaHbAolewK3OM=;
        h=From:To:Cc:Subject:Date:From;
        b=Yh7nH/drfKiRuWRSQhoRxUellqHaxOB2tSik9iyJUbjUM/xHpnPuSfNHPeh4BTfDa
         4Q3U86QWNNSCf+tHxXy+5qMjcONb1DvMYGnWZMBZy4moBZ//1ZItMbDyQ8IqC1CACw
         8ycofTIgQazTFqjFjBqHqkQK6HOpa/murxizf2Sic83Q2h8F+F62pyAaMhnRjvl/l9
         V+wgbIf/11nMKIq5lvpZ8CxzE/4LeF6u6oSbLg3RkyL+FrouYQJCOP/FzP0ENlwXWr
         VGgm0dCrfIhTGGDZSONNL0O5QJNYhptRDd6658Gc+cqH1NfGqs7tmOKtE+ITBbINEA
         hSgYkI5L8/OCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/12] mlx5 updates 2021-03-29
Date:   Mon, 29 Mar 2021 21:27:29 -0700
Message-Id: <20210330042741.198601-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series removes the mlx5 netdev restriction of enabling both 
PTP time-stamping and CQE-Compression features.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit d0922bf7981799fd86e248de330fb4152399d6c2:

  hv_netvsc: Add error handling while switching data path (2021-03-29 16:35:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-29

for you to fetch changes up to 885b8cfb161ed3d8f41e7b37e14d35bd8d3aaf6b:

  net/mlx5e: Update ethtool setting of CQE compression (2021-03-29 21:21:54 -0700)

----------------------------------------------------------------
mlx5-updates-2021-03-29

Coexistence of CQE compression and HW PTP time-stamp:

From Aya this series improves mlx5 netdev driver to allow
both mlx5 CQE compression (RX descriptor compression, that saves on PCI
transactions) and HW time-stamp PTP to co-exist.

Prior to this series both features were mutually exclusive due to the
nature of CQE compression which reduces the size of RX descriptor for
the price of trimming some data, such as the time-stamp.

In order to allow CQE compression when PTP time stamping is enabled,
We enable it on the regular performance critical RX queues which will
service all the data path traffic that is not PTP.

PTP traffic will be re-directed to dedicated RX queues on which we will
not enable CQE compression and thus keep the time-stamp intact.

Having both features is critical for systems with low PCI BW, e.g.
Multi-Host.

The series will be adding:
1) Infrastructure to create a dedicated RX queue to service the PTP traffic
2) Flow steering plumbing to capture PTP traffic both UDP packets with
 destination port 319 and L2 packets with ethertype 0x88F7
3) Steer PTP traffic to the dedicated RX queue.
4) The feature will be enabled when PTP is being configured via the
   already existing PTP IOCTL when CQE compression is active, otherwise
   no change to the driver flow.

----------------------------------------------------------------
Aya Levin (12):
      net/mlx5e: Add states to PTP channel
      net/mlx5e: Add RQ to PTP channel
      net/mlx5e: Add PTP-RX statistics
      net:mlx5e: Add PTP-TIR and PTP-RQT
      net/mlx5e: Refactor RX reporter diagnostics
      net/mlx5e: Add PTP RQ to RX reporter
      net/mlx5e: Cleanup Flow Steering level
      net/mlx5e: Introduce Flow Steering UDP API
      net/mlx5e: Introduce Flow Steering ANY API
      net/mlx5e: Add PTP Flow Steering support
      net/mlx5e: Allow coexistence of CQE compression and HW TS PTP
      net/mlx5e: Update ethtool setting of CQE compression

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  13 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         | 605 +++++++++++++++++++++
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |  26 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 331 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  12 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 172 ++++--
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  93 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 114 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   1 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   1 +
 19 files changed, 1298 insertions(+), 128 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
