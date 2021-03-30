Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9077134E025
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhC3E2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhC3E1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F842619A6;
        Tue, 30 Mar 2021 04:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078467;
        bh=0Y8kC4pdOh5yFRfxanSZYE/UNy1XhFSWDXMvVAP7CTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJfhta/Lrk0R9S23IoRIO98yj/Ic2MytG9SRpAtTfVTMFwCG/AQ/ckzKAz/gkfgU1
         WYDmXqwTRsWTVVOnGgEGXSE5ToqDfD4JQicpq8hruifAL1rtq4r7LXbn9aI42f15uP
         NI7Xf+oVPOiDhR2KkHx6wcooNt12W/Eu/VSfQR8HP5t/CK45M+1/A3yH5J8aOrAoJ2
         BjOgPckqKlkcCTAJm56ClZf6j+lVekaJG2F45r/t3igxCv03UpBE+iiSw1vuYC8b/e
         HKZ59F2AavwPhalg4TmqifEJCvWd9R7IUHxwZeWuThSaF6DBKMGx0Q43QaUj7WFQtX
         d3RaTfveB8oBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/12] net/mlx5e: Cleanup Flow Steering level
Date:   Mon, 29 Mar 2021 21:27:36 -0700
Message-Id: <20210330042741.198601-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Flow Steering levels are used to determine the order between the tables.
As of today, each one of these tables follows the TTC table, and hijacks
its traffic, and cannot be combined together for now. Putting them in
the same layer better reflects the situation.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index a16297e7e2ac..3dfec5943a33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -138,10 +138,10 @@ enum {
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
 #ifdef CONFIG_MLX5_EN_TLS
-	MLX5E_ACCEL_FS_TCP_FT_LEVEL,
+	MLX5E_ACCEL_FS_TCP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
-	MLX5E_ARFS_FT_LEVEL,
+	MLX5E_ARFS_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_IPSEC
 	MLX5E_ACCEL_FS_ESP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f5517ea2f6be..d2c0e61527ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,7 +105,7 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {aRFS/accel and esp/esp_err} */
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {aRFS/accel/{esp, esp_err}} */
 #define KERNEL_NIC_PRIO_NUM_LEVELS 7
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
-- 
2.30.2

