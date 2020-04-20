Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6CF1B079F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDTLlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:41:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD83214AF;
        Mon, 20 Apr 2020 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382909;
        bh=M28JL1PIiAYVz/D1BuDZ7J1lp5xsAYt1Kywfml1B9Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPBzMdkXC69bOk2mlJERPjpQEbvGF6PSOPmK0AZ1OkIdLqs9KD1bJTCLMxIqcDRZw
         SBIJs36d6Vrc+iTTxP7x7iRm4GpNkcpMcUNFcXF6hv8UGRO6a7D2+ODUL+T/LBUL+X
         Hy6PQAvSdJo1jxkUkHiCyCkSJb1KirRu8Q2KGPPk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/24] net/mlx5: Update cq.c to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:14 +0300
Message-Id: <20200420114136.264924-3-leon@kernel.org>
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

Do mass update of cq.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  | 24 +++++++------------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  2 +-
 include/linux/mlx5/cq.h                       |  2 +-
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 4477a590b308..1a6f1f14da97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -90,8 +90,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen, u32 *out, int outlen)
 {
 	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), c_eqn);
-	u32 dout[MLX5_ST_SZ_DW(destroy_cq_out)];
-	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)];
+	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
 	struct mlx5_eq_comp *eq;
 	int err;
 
@@ -141,20 +140,17 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 err_cq_add:
 	mlx5_eq_del_cq(&eq->core, cq);
 err_cmd:
-	memset(din, 0, sizeof(din));
-	memset(dout, 0, sizeof(dout));
 	MLX5_SET(destroy_cq_in, din, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, din, cqn, cq->cqn);
 	MLX5_SET(destroy_cq_in, din, uid, cq->uid);
-	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
+	mlx5_cmd_exec_in(dev, destroy_cq, din);
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_create_cq);
 
 int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_cq_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
 	int err;
 
 	mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
@@ -163,7 +159,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
 	MLX5_SET(destroy_cq_in, in, uid, cq->uid);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_in(dev, destroy_cq, in);
 	if (err)
 		return err;
 
@@ -178,24 +174,22 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 EXPORT_SYMBOL(mlx5_core_destroy_cq);
 
 int mlx5_core_query_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-		       u32 *out, int outlen)
+		       u32 *out)
 {
-	u32 in[MLX5_ST_SZ_DW(query_cq_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_cq_in)] = {};
 
 	MLX5_SET(query_cq_in, in, opcode, MLX5_CMD_OP_QUERY_CQ);
 	MLX5_SET(query_cq_in, in, cqn, cq->cqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec_inout(dev, query_cq, in, out);
 }
 EXPORT_SYMBOL(mlx5_core_query_cq);
 
 int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {0};
-
 	MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
 	MLX5_SET(modify_cq_in, in, uid, cq->uid);
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_cq, in);
 }
 EXPORT_SYMBOL(mlx5_core_modify_cq);
 
@@ -204,7 +198,7 @@ int mlx5_core_modify_cq_moderation(struct mlx5_core_dev *dev,
 				   u16 cq_period,
 				   u16 cq_max_count)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_cq_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_cq_in)] = {};
 	void *cqc;
 
 	MLX5_SET(modify_cq_in, in, cqn, cq->cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 65fef5a86644..c05e6a2c9126 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -333,7 +333,7 @@ static u64 cq_read_field(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	if (!out)
 		return param;
 
-	err = mlx5_core_query_cq(dev, cq, out, outlen);
+	err = mlx5_core_query_cq(dev, cq, out);
 	if (err) {
 		mlx5_core_warn(dev, "failed to query cq\n");
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 3a199a03d929..7283443868f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -43,7 +43,7 @@ int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 	void *cqc;
 	int err;
 
-	err = mlx5_core_query_cq(priv->mdev, &cq->mcq, out, sizeof(out));
+	err = mlx5_core_query_cq(priv->mdev, &cq->mcq, out);
 	if (err)
 		return err;
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 40748fc1b11b..b5a9399e07ee 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -188,7 +188,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen, u32 *out, int outlen);
 int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq);
 int mlx5_core_query_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-		       u32 *out, int outlen);
+		       u32 *out);
 int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen);
 int mlx5_core_modify_cq_moderation(struct mlx5_core_dev *dev,
-- 
2.25.2

