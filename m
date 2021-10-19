Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C195432C35
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhJSDXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhJSDXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D9DA61354;
        Tue, 19 Oct 2021 03:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613654;
        bh=5jQdjUhvY2lN32EDge1x6lxGT7A0Xh8op9A+Ai+xcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhy3eENeg/ywX/6DaknoIWy7JylYk0RDm4f0wJC133gi8vK8G0E3uAM4F0V1iE6t1
         Q+NcJuLkWXfIzYKZbKdG04mO1KcO57es8xfVqmx67b0ERtq2KlxRDcqWuOaJMDlW7c
         +d3qPBZUBrBbFpscrTg+xHWZnnbOKGJBSZ0JEqFohLaToeB5j3udNwgk5786R7iCt7
         71gk8/4WfqPR4N3A7ar13d3gDRc1zt4udwXAxkg2gS80NC9Kt+zPTEg0ADV/6imXIq
         8+wF4lZU5um2bD32065kCOqjzH3Wjz07xE7iulyOeidkJ4fNoQJ3efaHZRXex8ehtm
         7jEhmytKuLNbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/13] net/mlx5: Lag, use steering to select the affinity port in LAG
Date:   Mon, 18 Oct 2021 20:20:45 -0700
Message-Id: <20211019032047.55660-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Use the steering based solution for select the affinity port
when the LAG mode is based on hash policy and the device support
in port selection flow table.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 92 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  4 +-
 2 files changed, 74 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 17baa254f9ae..6a754c57e7f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -47,16 +47,21 @@
 static DEFINE_SPINLOCK(lag_lock);
 
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
-			       u8 remap_port2, bool shared_fdb)
+			       u8 remap_port2, bool shared_fdb, u8 flags)
 {
 	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
 	void *lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
 
-	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
-	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, shared_fdb);
+	if (!(flags & MLX5_LAG_FLAG_HASH_BASED)) {
+		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
+		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
+	} else {
+		MLX5_SET(lagc, lag_ctx, port_select_mode,
+			 MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT);
+	}
 
 	return mlx5_cmd_exec_in(dev, create_lag, in);
 }
@@ -199,6 +204,15 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 		*port1 = 2;
 }
 
+static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 v2p_port1, u8 v2p_port2)
+{
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+
+	if (ldev->flags & MLX5_LAG_FLAG_HASH_BASED)
+		return mlx5_lag_port_sel_modify(ldev, v2p_port1, v2p_port2);
+	return mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
+}
+
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker)
 {
@@ -211,39 +225,56 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 
 	if (v2p_port1 != ldev->v2p_map[MLX5_LAG_P1] ||
 	    v2p_port2 != ldev->v2p_map[MLX5_LAG_P2]) {
+		err = _mlx5_modify_lag(ldev, v2p_port1, v2p_port2);
+		if (err) {
+			mlx5_core_err(dev0,
+				      "Failed to modify LAG (%d)\n",
+				      err);
+			return;
+		}
 		ldev->v2p_map[MLX5_LAG_P1] = v2p_port1;
 		ldev->v2p_map[MLX5_LAG_P2] = v2p_port2;
-
 		mlx5_core_info(dev0, "modify lag map port 1:%d port 2:%d",
 			       ldev->v2p_map[MLX5_LAG_P1],
 			       ldev->v2p_map[MLX5_LAG_P2]);
-
-		err = mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
-		if (err)
-			mlx5_core_err(dev0,
-				      "Failed to modify LAG (%d)\n",
-				      err);
 	}
 }
 
+static void mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
+				       struct lag_tracker *tracker, u8 *flags)
+{
+	bool roce_lag = !!(*flags & MLX5_LAG_FLAG_ROCE);
+	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
+
+	if (roce_lag ||
+	    !MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) ||
+	    tracker->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return;
+	*flags |= MLX5_LAG_FLAG_HASH_BASED;
+}
+
+static char *get_str_port_sel_mode(u8 flags)
+{
+	if (flags &  MLX5_LAG_FLAG_HASH_BASED)
+		return "hash";
+	return "queue_affinity";
+}
+
 static int mlx5_create_lag(struct mlx5_lag *ldev,
 			   struct lag_tracker *tracker,
-			   bool shared_fdb)
+			   bool shared_fdb, u8 flags)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
 
-	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[MLX5_LAG_P1],
-				       &ldev->v2p_map[MLX5_LAG_P2]);
-
-	mlx5_core_info(dev0, "lag map port 1:%d port 2:%d shared_fdb:%d",
+	mlx5_core_info(dev0, "lag map port 1:%d port 2:%d shared_fdb:%d mode:%s",
 		       ldev->v2p_map[MLX5_LAG_P1], ldev->v2p_map[MLX5_LAG_P2],
-		       shared_fdb);
+		       shared_fdb, get_str_port_sel_mode(flags));
 
 	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map[MLX5_LAG_P1],
-				  ldev->v2p_map[MLX5_LAG_P2], shared_fdb);
+				  ldev->v2p_map[MLX5_LAG_P2], shared_fdb, flags);
 	if (err) {
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
@@ -279,16 +310,32 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	int err;
 
-	err = mlx5_create_lag(ldev, tracker, shared_fdb);
+	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[MLX5_LAG_P1],
+				       &ldev->v2p_map[MLX5_LAG_P2]);
+	mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
+	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
+		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
+					       ldev->v2p_map[MLX5_LAG_P1],
+					       ldev->v2p_map[MLX5_LAG_P2]);
+		if (err) {
+			mlx5_core_err(dev0,
+				      "Failed to create LAG port selection(%d)\n",
+				      err);
+			return err;
+		}
+	}
+
+	err = mlx5_create_lag(ldev, tracker, shared_fdb, flags);
 	if (err) {
-		if (roce_lag) {
+		if (flags & MLX5_LAG_FLAG_HASH_BASED)
+			mlx5_lag_port_sel_destroy(ldev);
+		if (roce_lag)
 			mlx5_core_err(dev0,
 				      "Failed to activate RoCE LAG\n");
-		} else {
+		else
 			mlx5_core_err(dev0,
 				      "Failed to activate VF LAG\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
-		}
 		return err;
 	}
 
@@ -302,6 +349,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
+	u8 flags = ldev->flags;
 	int err;
 
 	ldev->flags &= ~MLX5_LAG_MODE_FLAGS;
@@ -324,6 +372,8 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
+	} else if (flags & MLX5_LAG_FLAG_HASH_BASED) {
+		mlx5_lag_port_sel_destroy(ldev);
 	}
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index f0e8b3412c13..e5d231c31b54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -18,10 +18,12 @@ enum {
 	MLX5_LAG_FLAG_SRIOV  = 1 << 1,
 	MLX5_LAG_FLAG_MULTIPATH = 1 << 2,
 	MLX5_LAG_FLAG_READY = 1 << 3,
+	MLX5_LAG_FLAG_HASH_BASED = 1 << 4,
 };
 
 #define MLX5_LAG_MODE_FLAGS (MLX5_LAG_FLAG_ROCE | MLX5_LAG_FLAG_SRIOV |\
-			     MLX5_LAG_FLAG_MULTIPATH)
+			     MLX5_LAG_FLAG_MULTIPATH | \
+			     MLX5_LAG_FLAG_HASH_BASED)
 
 struct lag_func {
 	struct mlx5_core_dev *dev;
-- 
2.31.1

