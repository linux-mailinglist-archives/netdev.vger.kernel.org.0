Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE31836281C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhDPSzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236052AbhDPSzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F224613C8;
        Fri, 16 Apr 2021 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599286;
        bh=kaj/3LJAPNFQjrXhTnN89J+AVd2Kz3F0NQkoWttC2Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3TXmRuedPmvd+vzpSyRMxIQo3FgMNCz8Y4/+8ZSeHC9rP9mMaAEFJKoxzYsS14fQ
         ydwnD+PMCMFk11pkRoFgRjLvE4zBaNkyMFq6ceq2stkuTIx6TxCgkERQsNdrTOvmXr
         /5zGwEXvFGuWxXrqVqxJjqePKzWh2Sacd/PoKBDzqmANX2iLtw/CgayOTY3vlpjfk1
         AGSfpndVvnCWidlX2C+ZlITzWRQKRaHHRegUPn10gWma3jQ+c6ayYhlGW1kF2zoElB
         b5GPVeaXiPpg7qdni8sy0KzBiJDwfh5B/fFlO8tTK2cHMV12G7IDZwBGrLQiWNvKGZ
         DmaLigzrCFgFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5: Add helper to initialize 1PPS
Date:   Fri, 16 Apr 2021 11:54:29 -0700
Message-Id: <20210416185430.62584-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Wrap 1PPS initialization in a helper for a cleaner init flow.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 1e7f26b240de..ce696d523493 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -645,16 +645,19 @@ static int mlx5_get_pps_pin_mode(struct mlx5_clock *clock, u8 pin)
 	return PTP_PF_NONE;
 }
 
-static int mlx5_init_pin_config(struct mlx5_clock *clock)
+static void mlx5_init_pin_config(struct mlx5_clock *clock)
 {
 	int i;
 
+	if (!clock->ptp_info.n_pins)
+		return;
+
 	clock->ptp_info.pin_config =
 			kcalloc(clock->ptp_info.n_pins,
 				sizeof(*clock->ptp_info.pin_config),
 				GFP_KERNEL);
 	if (!clock->ptp_info.pin_config)
-		return -ENOMEM;
+		return;
 	clock->ptp_info.enable = mlx5_ptp_enable;
 	clock->ptp_info.verify = mlx5_ptp_verify;
 	clock->ptp_info.pps = 1;
@@ -667,8 +670,6 @@ static int mlx5_init_pin_config(struct mlx5_clock *clock)
 		clock->ptp_info.pin_config[i].func = mlx5_get_pps_pin_mode(clock, i);
 		clock->ptp_info.pin_config[i].chan = 0;
 	}
-
-	return 0;
 }
 
 static void mlx5_get_pps_caps(struct mlx5_core_dev *mdev)
@@ -859,6 +860,17 @@ static void mlx5_init_timer_clock(struct mlx5_core_dev *mdev)
 	}
 }
 
+static void mlx5_init_pps(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+
+	if (!MLX5_PPS_CAP(mdev))
+		return;
+
+	mlx5_get_pps_caps(mdev);
+	mlx5_init_pin_config(clock);
+}
+
 void mlx5_init_clock(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
@@ -876,10 +888,7 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	clock->ptp_info = mlx5_ptp_clock_info;
 
 	/* Initialize 1PPS data structures */
-	if (MLX5_PPS_CAP(mdev))
-		mlx5_get_pps_caps(mdev);
-	if (clock->ptp_info.n_pins)
-		mlx5_init_pin_config(clock);
+	mlx5_init_pps(mdev);
 
 	clock->ptp = ptp_clock_register(&clock->ptp_info,
 					&mdev->pdev->dev);
-- 
2.30.2

