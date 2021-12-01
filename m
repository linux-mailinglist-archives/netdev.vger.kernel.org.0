Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17325464747
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347002AbhLAGlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346969AbhLAGku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901B0C061759
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D87ECCE1A7B
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CBAC53FD0;
        Wed,  1 Dec 2021 06:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340647;
        bh=7RSF23F3VH5AhPKy0WIaUa53VU27exhQr2o59yXZqvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPVogZpWgH9/rTu7HTnV6BSq82Dv4wiO/XgooHkpgo7IxyOcteU20A5T1R61nh2iU
         7aIdeT2ZKuKr1+MuTagoqUhUntXUdBrRiooEOaSjkbr2p+lpIs/B5euVQI2YkWiDcW
         R+84zsnvfKWb8EJOG/F2ac30RzjetWx5heU3d+abB9K3ovYsAPi9XWRcOOJJLc5Pb3
         5TE89Pj/u83T46g9YwpdC2UGxTdxZhVV1S0Uavq4rGW4zcXJ4Ij17ie2fCNxh5O4TF
         BZViDn8DsHUDIyEfdZXEcXwForjEVRS3C1Sy+QSp1K9mT+X4v43UMRA5BrSqfTcAl9
         D4d5MEY5vtiKA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/13] net/mlx5: Fix access to a non-supported register
Date:   Tue, 30 Nov 2021 22:37:08 -0800
Message-Id: <20211201063709.229103-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
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
index e127c0530b3a..7df9c7f8d9c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1071,18 +1071,16 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 
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

