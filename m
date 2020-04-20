Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A981B07B3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDTLmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:20 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B41218AC;
        Mon, 20 Apr 2020 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382939;
        bh=qCfIoBmFi0W25EXlC0rndYZI8y4yRIOkJmVP75iIUj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1QLLMkchn0MCntnmsay7yWkls6v/1Uigni8IatEhHr4udJyqEoDtIhmk9MMW+dUw
         EwiSmrUhEZ/PFtLDVwCfdNG8bSBdbKt2y5gdiRGLyN71+AoKKTLrakIDV5k1OkL75v
         bVQ6vnFME6dEVKtRWjSawOoP0ijBXu7xzXMLwVdY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 11/24] net/mlx5: Update lag.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:23 +0300
Message-Id: <20200420114136.264924-12-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of lag.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 52 ++++++-------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 5461fbe47c0d..874c70e8cc54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -47,8 +47,7 @@ static DEFINE_SPINLOCK(lag_lock);
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 			       u8 remap_port2)
 {
-	u32   in[MLX5_ST_SZ_DW(create_lag_in)]   = {0};
-	u32   out[MLX5_ST_SZ_DW(create_lag_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
 	void *lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
@@ -56,14 +55,13 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
 	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, create_lag, in);
 }
 
 static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 			       u8 remap_port2)
 {
-	u32   in[MLX5_ST_SZ_DW(modify_lag_in)]   = {0};
-	u32   out[MLX5_ST_SZ_DW(modify_lag_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_lag_in)] = {};
 	void *lag_ctx = MLX5_ADDR_OF(modify_lag_in, in, ctx);
 
 	MLX5_SET(modify_lag_in, in, opcode, MLX5_CMD_OP_MODIFY_LAG);
@@ -72,52 +70,29 @@ static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
 	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-
-static int mlx5_cmd_destroy_lag(struct mlx5_core_dev *dev)
-{
-	u32  in[MLX5_ST_SZ_DW(destroy_lag_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_lag_out)] = {0};
-
-	MLX5_SET(destroy_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_LAG);
-
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_lag, in);
 }
 
 int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev)
 {
-	u32  in[MLX5_ST_SZ_DW(create_vport_lag_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(create_vport_lag_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(create_vport_lag_in)] = {};
 
 	MLX5_SET(create_vport_lag_in, in, opcode, MLX5_CMD_OP_CREATE_VPORT_LAG);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, create_vport_lag, in);
 }
 EXPORT_SYMBOL(mlx5_cmd_create_vport_lag);
 
 int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 {
-	u32  in[MLX5_ST_SZ_DW(destroy_vport_lag_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_vport_lag_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_vport_lag_in)] = {};
 
 	MLX5_SET(destroy_vport_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_VPORT_LAG);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_vport_lag, in);
 }
 EXPORT_SYMBOL(mlx5_cmd_destroy_vport_lag);
 
-static int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
-				       bool reset, void *out, int out_size)
-{
-	u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = { };
-
-	MLX5_SET(query_cong_statistics_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_CONG_STATISTICS);
-	MLX5_SET(query_cong_statistics_in, in, clear, reset);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size);
-}
-
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev)
 {
@@ -232,12 +207,14 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
 	int err;
 
 	ldev->flags &= ~MLX5_LAG_MODE_FLAGS;
 
-	err = mlx5_cmd_destroy_lag(dev0);
+	MLX5_SET(destroy_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_LAG);
+	err = mlx5_cmd_exec_in(dev0, destroy_lag, in);
 	if (err) {
 		if (roce_lag) {
 			mlx5_core_err(dev0,
@@ -783,7 +760,12 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	spin_unlock(&lag_lock);
 
 	for (i = 0; i < num_ports; ++i) {
-		ret = mlx5_cmd_query_cong_counter(mdev[i], false, out, outlen);
+		u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = {};
+
+		MLX5_SET(query_cong_statistics_in, in, opcode,
+			 MLX5_CMD_OP_QUERY_CONG_STATISTICS);
+		ret = mlx5_cmd_exec_inout(mdev[i], query_cong_statistics, in,
+					  out);
 		if (ret)
 			goto free;
 
-- 
2.25.2

