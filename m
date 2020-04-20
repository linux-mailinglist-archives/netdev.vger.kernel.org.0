Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16E1B07BD
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgDTLmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C0421473;
        Mon, 20 Apr 2020 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382954;
        bh=URm1wVZfx5soezZ8amTR4/CBi/5tj5jaeApIkAQkA68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFR7IT6P+NEjoOuXjjKD2/s6HJVXK//2K/wpAEvVmAI7JCd2HN0pMnTyFxoGzRdXv
         wFCFj1Gl20PcPN2YhC7w47nSfWNIdnF+sj6MhAPTzpTJorVFRSyZdq62OlcU2+RAzI
         YRsz9VonG/8fjm7EKo9Q1fjTUYtubadrBSbuWCtw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 15/24] net/mlx5: Update main.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:27 +0300
Message-Id: <20200420114136.264924-16-leon@kernel.org>
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

Do mass update of main.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 35 +++++++------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0044aa5cc676..061b69ea9cc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -206,8 +206,7 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 {
 	int driver_ver_sz = MLX5_FLD_SZ_BYTES(set_driver_version_in,
 					      driver_version);
-	u8 in[MLX5_ST_SZ_BYTES(set_driver_version_in)] = {0};
-	u8 out[MLX5_ST_SZ_BYTES(set_driver_version_out)] = {0};
+	u8 in[MLX5_ST_SZ_BYTES(set_driver_version_in)] = {};
 	int remaining_size = driver_ver_sz;
 	char *string;
 
@@ -234,7 +233,7 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	MLX5_SET(set_driver_version_in, in, opcode,
 		 MLX5_CMD_OP_SET_DRIVER_VERSION);
 
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, set_driver_version, in);
 }
 
 static int set_dma_caps(struct pci_dev *pdev)
@@ -366,7 +365,7 @@ static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, out_sz);
+	err = mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 	if (err) {
 		mlx5_core_warn(dev,
 			       "QUERY_HCA_CAP : type(%x) opmode(%x) Failed(%d)\n",
@@ -409,12 +408,9 @@ int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type)
 
 static int set_caps(struct mlx5_core_dev *dev, void *in, int opmod)
 {
-	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)] = {};
-
 	MLX5_SET(set_hca_cap_in, in, opcode, MLX5_CMD_OP_SET_HCA_CAP);
 	MLX5_SET(set_hca_cap_in, in, op_mod, opmod << 1);
-	return mlx5_cmd_exec(dev, in, MLX5_ST_SZ_BYTES(set_hca_cap_in), out,
-			     sizeof(out));
+	return mlx5_cmd_exec_in(dev, set_hca_cap, in);
 }
 
 static int handle_hca_cap_atomic(struct mlx5_core_dev *dev, void *set_ctx)
@@ -653,26 +649,24 @@ static int mlx5_core_set_hca_defaults(struct mlx5_core_dev *dev)
 
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
 {
-	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] = {};
 
 	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
 	MLX5_SET(enable_hca_in, in, function_id, func_id);
 	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
 		 dev->caps.embedded_cpu);
-	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, enable_hca, in);
 }
 
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
 {
-	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] = {};
 
 	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
 	MLX5_SET(disable_hca_in, in, function_id, func_id);
 	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
 		 dev->caps.embedded_cpu);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, disable_hca, in);
 }
 
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
@@ -697,14 +691,13 @@ u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
 
 static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 {
-	u32 query_in[MLX5_ST_SZ_DW(query_issi_in)]   = {0};
-	u32 query_out[MLX5_ST_SZ_DW(query_issi_out)] = {0};
+	u32 query_out[MLX5_ST_SZ_DW(query_issi_out)] = {};
+	u32 query_in[MLX5_ST_SZ_DW(query_issi_in)] = {};
 	u32 sup_issi;
 	int err;
 
 	MLX5_SET(query_issi_in, query_in, opcode, MLX5_CMD_OP_QUERY_ISSI);
-	err = mlx5_cmd_exec(dev, query_in, sizeof(query_in),
-			    query_out, sizeof(query_out));
+	err = mlx5_cmd_exec_inout(dev, query_issi, query_in, query_out);
 	if (err) {
 		u32 syndrome;
 		u8 status;
@@ -724,13 +717,11 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 	sup_issi = MLX5_GET(query_issi_out, query_out, supported_issi_dw0);
 
 	if (sup_issi & (1 << 1)) {
-		u32 set_in[MLX5_ST_SZ_DW(set_issi_in)]   = {0};
-		u32 set_out[MLX5_ST_SZ_DW(set_issi_out)] = {0};
+		u32 set_in[MLX5_ST_SZ_DW(set_issi_in)] = {};
 
 		MLX5_SET(set_issi_in, set_in, opcode, MLX5_CMD_OP_SET_ISSI);
 		MLX5_SET(set_issi_in, set_in, current_issi, 1);
-		err = mlx5_cmd_exec(dev, set_in, sizeof(set_in),
-				    set_out, sizeof(set_out));
+		err = mlx5_cmd_exec_in(dev, set_issi, set_in);
 		if (err) {
 			mlx5_core_err(dev, "Failed to set ISSI to 1 err(%d)\n",
 				      err);
-- 
2.25.2

