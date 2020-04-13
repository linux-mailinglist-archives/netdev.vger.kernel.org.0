Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A1C1A680A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgDMOXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbgDMOXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA8D20776;
        Mon, 13 Apr 2020 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787810;
        bh=sqTvIBlwWezQDcTKwQBuqV+MisCV5y9ByRw9ueYGYqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T21ZNtZuYTPxp0cx/dj+QoVxQ5JtRSGINgDsDr/TlklGfJeTbLWLI8wMIDslEdRyR
         SWeEE+dI6Fr63LeWknGowXrw8o0uYopNdY9sQ8nGPlqR0SiMPxDcmARZW8mbEZY9R5
         wcJecZwbxEWcr8Qr8l2+R2+IGlqcTEiXcSnaH2u8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/13] net/mlx5: Open-code modify QP in the IPoIB module
Date:   Mon, 13 Apr 2020 17:23:01 +0300
Message-Id: <20200413142308.936946-7-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Remove dependency on qp.c from the IPoIB by open coding
modify QP interface.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 76 ++++++++++---------
 1 file changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 8bca11cb1e19..83b198d8e3d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -161,44 +161,54 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5i_priv *ipriv = priv->ppriv;
 	struct mlx5_core_qp *qp = &ipriv->qp;
-	struct mlx5_qp_context *context;
 	int ret;
 
-	/* QP states */
-	context = kzalloc(sizeof(*context), GFP_KERNEL);
-	if (!context)
-		return -ENOMEM;
+	{
+		u32 in[MLX5_ST_SZ_DW(rst2init_qp_in)] = {};
+		u32 *qpc;
 
-	context->flags = cpu_to_be32(MLX5_QP_PM_MIGRATED << 11);
-	context->pri_path.port = 1;
-	context->pri_path.pkey_index = cpu_to_be16(ipriv->pkey_index);
-	context->qkey = cpu_to_be32(IB_DEFAULT_Q_KEY);
+		qpc = MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
 
-	ret = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RST2INIT_QP, 0, context, qp);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed to modify qp RST2INIT, err: %d\n", ret);
-		goto err_qp_modify_to_err;
-	}
-	memset(context, 0, sizeof(*context));
+		MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+		MLX5_SET(qpc, qpc, primary_address_path.pkey_index,
+			 ipriv->pkey_index);
+		MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+		MLX5_SET(qpc, qpc, q_key, IB_DEFAULT_Q_KEY);
 
-	ret = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_INIT2RTR_QP, 0, context, qp);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed to modify qp INIT2RTR, err: %d\n", ret);
-		goto err_qp_modify_to_err;
+		MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+		MLX5_SET(rst2init_qp_in, in, qpn, qp->qpn);
+		ret = mlx5_cmd_exec_in(mdev, rst2init_qp, in);
+		if (ret)
+			goto err_qp_modify_to_err;
 	}
-
-	ret = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RTR2RTS_QP, 0, context, qp);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed to modify qp RTR2RTS, err: %d\n", ret);
-		goto err_qp_modify_to_err;
+	{
+		u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
+
+		MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+		MLX5_SET(init2rtr_qp_in, in, qpn, qp->qpn);
+		ret = mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
+		if (ret)
+			goto err_qp_modify_to_err;
+	}
+	{
+		u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
+
+		MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+		MLX5_SET(rtr2rts_qp_in, in, qpn, qp->qpn);
+		ret = mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
+		if (ret)
+			goto err_qp_modify_to_err;
 	}
-
-	kfree(context);
 	return 0;
 
 err_qp_modify_to_err:
-	mlx5_core_qp_modify(mdev, MLX5_CMD_OP_2ERR_QP, 0, &context, qp);
-	kfree(context);
+	{
+		u32 in[MLX5_ST_SZ_DW(qp_2err_in)] = {};
+
+		MLX5_SET(qp_2err_in, in, opcode, MLX5_CMD_OP_2ERR_QP);
+		MLX5_SET(qp_2err_in, in, qpn, qp->qpn);
+		mlx5_cmd_exec_in(mdev, qp_2err, in);
+	}
 	return ret;
 }
 
@@ -206,13 +216,11 @@ void mlx5i_uninit_underlay_qp(struct mlx5e_priv *priv)
 {
 	struct mlx5i_priv *ipriv = priv->ppriv;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5_qp_context context;
-	int err;
+	u32 in[MLX5_ST_SZ_DW(qp_2rst_in)] = {};
 
-	err = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_2RST_QP, 0, &context,
-				  &ipriv->qp);
-	if (err)
-		mlx5_core_err(mdev, "Failed to modify qp 2RST, err: %d\n", err);
+	MLX5_SET(qp_2rst_in, in, opcode, MLX5_CMD_OP_2RST_QP);
+	MLX5_SET(qp_2rst_in, in, qpn, ipriv->qp.qpn);
+	mlx5_cmd_exec_in(mdev, qp_2rst, in);
 }
 
 #define MLX5_QP_ENHANCED_ULP_STATELESS_MODE 2
-- 
2.25.2

