Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5711A680D
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgDMOX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbgDMOXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A4920774;
        Mon, 13 Apr 2020 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787817;
        bh=52LiirNRc7bk8VDyikvApReD2goqQm2EWa9vSAQw+Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2taxUPagQ5JmiYp3pIoADsRDZGeOPIcRBaxnC4bgy8RZuLqqU7NtyQxvlT8j1vjc3
         WYeIj6cDItZi3ZAdCDp7N4LGKVjJbSPHYiioO9SFbKXjF//pwr3444hN6BcJJpxij+
         LxGmD1lQw9kKjQBohXD5tMJNZSPC7gvO5Z3v6YEE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/13] net/mlx5: Replace hand written QP context struct with automatic getters
Date:   Mon, 13 Apr 2020 17:23:03 +0300
Message-Id: <20200413142308.936946-9-leon@kernel.org>
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

By changing debugfs to not use any QP related API, convert the debugfs
code to use MLX5_GET() directly to access QP context instead of hand
written struct.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 51 ++++++++-----------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 04854e5fbcd7..d40c3d5bd496 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -202,42 +202,37 @@ void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 			 int index, int *is_str)
 {
-	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
-	struct mlx5_qp_context *ctx;
+	u32 out[MLX5_ST_SZ_BYTES(query_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
 	u64 param = 0;
-	u32 *out;
+	int state;
+	u32 *qpc;
 	int err;
-	int no_sq;
 
-	out = kzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return param;
-
-	err = mlx5_core_qp_query(dev, qp, out, outlen);
-	if (err) {
-		mlx5_core_warn(dev, "failed to query qp err=%d\n", err);
-		goto out;
-	}
+	MLX5_SET(query_qp_in, in, opcode, MLX5_CMD_OP_QUERY_QP);
+	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
+	err = mlx5_cmd_exec_inout(dev, query_qp, in, out);
+	if (err)
+		return 0;
 
 	*is_str = 0;
 
-	/* FIXME: use MLX5_GET rather than mlx5_qp_context manual struct */
-	ctx = (struct mlx5_qp_context *)MLX5_ADDR_OF(query_qp_out, out, qpc);
-
+	qpc = MLX5_ADDR_OF(query_qp_out, out, qpc);
 	switch (index) {
 	case QP_PID:
 		param = qp->pid;
 		break;
 	case QP_STATE:
-		param = (unsigned long)mlx5_qp_state_str(be32_to_cpu(ctx->flags) >> 28);
+		state = MLX5_GET(qpc, qpc, state);
+		param = (unsigned long)mlx5_qp_state_str(state);
 		*is_str = 1;
 		break;
 	case QP_XPORT:
-		param = (unsigned long)mlx5_qp_type_str((be32_to_cpu(ctx->flags) >> 16) & 0xff);
+		param = (unsigned long)mlx5_qp_type_str(MLX5_GET(qpc, qpc, st));
 		*is_str = 1;
 		break;
 	case QP_MTU:
-		switch (ctx->mtu_msgmax >> 5) {
+		switch (MLX5_GET(qpc, qpc, mtu)) {
 		case IB_MTU_256:
 			param = 256;
 			break;
@@ -258,29 +253,23 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		}
 		break;
 	case QP_N_RECV:
-		param = 1 << ((ctx->rq_size_stride >> 3) & 0xf);
+		param = 1 << MLX5_GET(qpc, qpc, log_rq_size);
 		break;
 	case QP_RECV_SZ:
-		param = 1 << ((ctx->rq_size_stride & 7) + 4);
+		param = 1 << (MLX5_GET(qpc, qpc, log_rq_stride) + 4);
 		break;
 	case QP_N_SEND:
-		no_sq = be16_to_cpu(ctx->sq_crq_size) >> 15;
-		if (!no_sq)
-			param = 1 << (be16_to_cpu(ctx->sq_crq_size) >> 11);
-		else
-			param = 0;
+		if (!MLX5_GET(qpc, qpc, no_sq))
+			param = 1 << MLX5_GET(qpc, qpc, log_sq_size);
 		break;
 	case QP_LOG_PG_SZ:
-		param = (be32_to_cpu(ctx->log_pg_sz_remote_qpn) >> 24) & 0x1f;
-		param += 12;
+		param = MLX5_GET(qpc, qpc, log_page_size) + 12;
 		break;
 	case QP_RQPN:
-		param = be32_to_cpu(ctx->log_pg_sz_remote_qpn) & 0xffffff;
+		param = MLX5_GET(qpc, qpc, remote_qpn);
 		break;
 	}
 
-out:
-	kfree(out);
 	return param;
 }
 
-- 
2.25.2

