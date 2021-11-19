Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699B2457773
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhKSUBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234722AbhKSUBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 313CE61B51;
        Fri, 19 Nov 2021 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351900;
        bh=H0iiCrtuHQV0/i2rtlendt8icljjvGGO++YKlunkA0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNBrfYQq5xzANHiRwCnv5XiDOPfRywhl84FQy4ymwOJQyYV11UsMfJ/SPsxP/6LwP
         maUT6Y0cPrawDj0Mak8jATb5bPx5Uki71ZXe6ZA94g0uqf8WtfswkT6u8gBFfK0Ow/
         2ChEf6QM33pgCVIECrxxxeZvf9ZvrJr1/JO8VoiM1jYr1wHzFKijv1roLIOBk3zHw4
         FEitE2shss92V1Lkp8VaExMU2H3VTBspMaoKPfk3ZJldlkhd1bh881oZLofEbehCIs
         WDD9XqAczVKDTibA0MSee+9K2gGD/P+A+ZjhfExr4fAsxkV/K7RNJwRycotmE3ahQ2
         3fUtX0hjnAIOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/10] net/mlx5: Fix access to a non-supported register
Date:   Fri, 19 Nov 2021 11:58:07 -0800
Message-Id: <20211119195813.739586-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Validate MRTC register is supported before triggering a delayed work
which accesses it.

Fixes: 5a1023deeed0 ("net/mlx5: Add periodic update of host time to firmware")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c   | 8 +++-----
 include/linux/mlx5/mlx5_ifc.h                    | 5 ++++-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 380f50d5462d..3ca998874c50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -836,7 +836,7 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev)
 	health->timer.expires = jiffies + msecs_to_jiffies(poll_interval_ms);
 	add_timer(&health->timer);
 
-	if (mlx5_core_is_pf(dev))
+	if (mlx5_core_is_pf(dev) && MLX5_CAP_MCAM_REG(dev, mrtc))
 		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a92a92a52346..990a0c2bd51d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1075,18 +1075,16 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 
 	mlx5_set_driver_version(dev);
 
-	mlx5_start_health_poll(dev);
-
 	err = mlx5_query_hca_caps(dev);
 	if (err) {
 		mlx5_core_err(dev, "query hca failed\n");
-		goto stop_health;
+		goto reclaim_boot_pages;
 	}
 
+	mlx5_start_health_poll(dev);
+
 	return 0;
 
-stop_health:
-	mlx5_stop_health_poll(dev, boot);
 reclaim_boot_pages:
 	mlx5_reclaim_startup_pages(dev);
 err_disable_hca:
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3636df90899a..fbaab440a484 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9698,7 +9698,10 @@ struct mlx5_ifc_mcam_access_reg_bits {
 	u8         regs_84_to_68[0x11];
 	u8         tracer_registers[0x4];
 
-	u8         regs_63_to_32[0x20];
+	u8         regs_63_to_46[0x12];
+	u8         mrtc[0x1];
+	u8         regs_44_to_32[0xd];
+
 	u8         regs_31_to_0[0x20];
 };
 
-- 
2.31.1

