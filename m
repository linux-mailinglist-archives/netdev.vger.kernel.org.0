Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40535453AE3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhKPU0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhKPU0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E1361B30;
        Tue, 16 Nov 2021 20:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094216;
        bh=wWq3tHP6SGsmOcIk1wzQRRuIAzk4RHoAC4bdsju47Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1TJY1mLk9QzETBVIdztdcVQWLqF0cfm08gFrNHWRSnQGp+lqg7TP1+qDut9yV656
         2dQW3jg3O/7Xm/IjYiBXFiAVFWeIbeo1T7xNBJXr8ow/479tcGH6Y/oRNnrlahT9oM
         N6C+6HiSDS8Ma3hZy/+7ego/o3e64sXL+UxxrMiE2+ZLOX+UrdRHrqH13FZj0+goTw
         LMq77KFPUkJQPZ3tSL5AVpOtW+CU93UHFjuOzk+z7WFPGnoTg9/NnjvUF4GHHuJt0i
         Qz+7M66spQPbe5emLLUR5I+o80XcFZUhybyrHPKsuQ0JuaBO44GP/BhD9nAYHRnOwT
         91ZWTpuvT+qtA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/12] net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev
Date:   Tue, 16 Nov 2021 12:23:12 -0800
Message-Id: <20211116202321.283874-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

E-Switch encap mode is relevant only when in switchdev mode.
The RDMA driver can query the encap configuration via
mlx5_eswitch_get_encap_mode(). Make sure it returns the currently
used mode and not the set one.

This reverts the cited commit which reset the encap mode
on entering switchdev and fixes the original issue properly.

Fixes: 9a64144d683a ("net/mlx5: E-Switch, Fix default encap mode")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c        | 9 +++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 7 -------
 include/linux/mlx5/eswitch.h                             | 4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ec136b499204..5872cc8bf953 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1572,6 +1572,11 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->enabled_vports = 0;
 	esw->mode = MLX5_ESWITCH_NONE;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
+	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
+	else
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
@@ -1934,7 +1939,7 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 	return err;
 }
 
-u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
+u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
@@ -1948,7 +1953,7 @@ mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
 	struct mlx5_eswitch *esw;
 
 	esw = dev->priv.eswitch;
-	return mlx5_esw_allowed(esw) ? esw->offloads.encap :
+	return (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)  ? esw->offloads.encap :
 		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f4eaa5893886..80fa76f60e1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3183,12 +3183,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	u64 mapping_id;
 	int err;
 
-	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
-	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
-	else
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 
@@ -3286,7 +3280,6 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_metadata_uninit(esw);
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
-	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 
 static int esw_mode_from_devlink(u16 mode, u16 *mlx5_mode)
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 97afcea39a7b..8b18fe9771f9 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -145,13 +145,13 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 	GENMASK(31 - ESW_TUN_ID_BITS - ESW_RESERVED_BITS, \
 		ESW_TUN_OPTS_OFFSET + 1)
 
-u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
+u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev);
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw);
 
 #else  /* CONFIG_MLX5_ESWITCH */
 
-static inline u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
+static inline u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
 	return MLX5_ESWITCH_NONE;
 }
-- 
2.31.1

