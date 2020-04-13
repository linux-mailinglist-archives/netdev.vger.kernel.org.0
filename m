Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEE11A67FB
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgDMOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbgDMOXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BBCF20776;
        Mon, 13 Apr 2020 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787800;
        bh=XdrsNcO4hTKz4bfW2mqlYnXQk9dMbjWRO2/B5WKgK/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMM996A+a6xGZHqTVfDCHSVvF0vRRP1ttIDjrbJZLZG3JzTaZkfHlt6hYWwE+tmZm
         +hE4guEujcFBXCR99Zn9rr8kh8qZ9/nJuYACnjhNE+XBmUZA1glo9Epsb4KYO35q/A
         A6AiD4JXBlH2WZ+a7uziniMmvhX2vtYnLVNnAUD8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/13] net/mlx5: Open-code create and destroy QP calls
Date:   Mon, 13 Apr 2020 17:22:57 +0300
Message-Id: <20200413142308.936946-3-leon@kernel.org>
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

FPGA, IPoIB and SW steering don't need anything from the
mlx5_core_create_qp() and mlx5_core_destroy_qp() except calls
to mlx5_cmd_exec().

Let's open-code it, so we will be able to move qp.c to mlx5_ib.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 24 ++++++++-------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 30 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_send.c     | 18 +++++++----
 3 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 61021133029e..7c3e7232852e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -534,8 +534,9 @@ static int mlx5_fpga_conn_create_qp(struct mlx5_fpga_conn *conn,
 				    unsigned int tx_size, unsigned int rx_size)
 {
 	struct mlx5_fpga_device *fdev = conn->fdev;
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	struct mlx5_core_dev *mdev = fdev->mdev;
-	u32 temp_qpc[MLX5_ST_SZ_DW(qpc)] = {0};
+	u32 temp_qpc[MLX5_ST_SZ_DW(qpc)] = {};
 	void *in = NULL, *qpc;
 	int err, inlen;
 
@@ -600,10 +601,12 @@ static int mlx5_fpga_conn_create_qp(struct mlx5_fpga_conn *conn,
 	mlx5_fill_page_frag_array(&conn->qp.wq_ctrl.buf,
 				  (__be64 *)MLX5_ADDR_OF(create_qp_in, in, pas));
 
-	err = mlx5_core_create_qp(mdev, &conn->qp.mqp, in, inlen);
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	if (err)
 		goto err_sq_bufs;
 
+	conn->qp.mqp.qpn = MLX5_GET(create_qp_out, out, qpn);
 	conn->qp.mqp.event = mlx5_fpga_conn_event;
 	mlx5_fpga_dbg(fdev, "Created QP #0x%x\n", conn->qp.mqp.qpn);
 
@@ -658,7 +661,14 @@ static void mlx5_fpga_conn_flush_send_bufs(struct mlx5_fpga_conn *conn)
 
 static void mlx5_fpga_conn_destroy_qp(struct mlx5_fpga_conn *conn)
 {
-	mlx5_core_destroy_qp(conn->fdev->mdev, &conn->qp.mqp);
+	struct mlx5_core_dev *dev = conn->fdev->mdev;
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+	struct mlx5_core_qp *qp = &conn->qp.mqp;
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	mlx5_cmd_exec_in(dev, destroy_qp, in);
+
 	mlx5_fpga_conn_free_recv_bufs(conn);
 	mlx5_fpga_conn_flush_send_bufs(conn);
 	kvfree(conn->qp.sq.bufs);
@@ -972,19 +982,11 @@ struct mlx5_fpga_conn *mlx5_fpga_conn_create(struct mlx5_fpga_device *fdev,
 
 void mlx5_fpga_conn_destroy(struct mlx5_fpga_conn *conn)
 {
-	struct mlx5_fpga_device *fdev = conn->fdev;
-	struct mlx5_core_dev *mdev = fdev->mdev;
-	int err = 0;
-
 	conn->qp.active = false;
 	tasklet_disable(&conn->cq.tasklet);
 	synchronize_irq(conn->cq.mcq.irqn);
 
 	mlx5_fpga_destroy_qp(conn->fdev->mdev, conn->fpga_qpn);
-	err = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_2ERR_QP, 0, NULL,
-				  &conn->qp.mqp);
-	if (err)
-		mlx5_fpga_warn(fdev, "qp_modify 2ERR failed: %d\n", err);
 	mlx5_fpga_conn_destroy_qp(conn);
 	mlx5_fpga_conn_destroy_cq(conn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 673aaa815f57..8bca11cb1e19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -219,17 +219,12 @@ void mlx5i_uninit_underlay_qp(struct mlx5e_priv *priv)
 
 int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp)
 {
-	u32 *in = NULL;
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_qp_in)] = {};
 	void *addr_path;
 	int ret = 0;
-	int inlen;
 	void *qpc;
 
-	inlen = MLX5_ST_SZ_BYTES(create_qp_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_UD);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
@@ -240,20 +235,23 @@ int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp
 	MLX5_SET(ads, addr_path, vhca_port_num, 1);
 	MLX5_SET(ads, addr_path, grh, 1);
 
-	ret = mlx5_core_create_qp(mdev, qp, in, inlen);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed creating IPoIB QP err : %d\n", ret);
-		goto out;
-	}
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+	ret = mlx5_cmd_exec_inout(mdev, create_qp, in, out);
+	if (ret)
+		return ret;
 
-out:
-	kvfree(in);
-	return ret;
+	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+
+	return 0;
 }
 
 void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp)
 {
-	mlx5_core_destroy_qp(mdev, qp);
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	mlx5_cmd_exec_in(mdev, destroy_qp, in);
 }
 
 int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index c0ab9cf74929..88bc94a8b8f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -108,6 +108,7 @@ static void dr_qp_event(struct mlx5_core_qp *mqp, int event)
 static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 					 struct dr_qp_init_attr *attr)
 {
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	u32 temp_qpc[MLX5_ST_SZ_DW(qpc)] = {};
 	struct mlx5_wq_param wqp;
 	struct mlx5dr_qp *dr_qp;
@@ -180,13 +181,12 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 				  (__be64 *)MLX5_ADDR_OF(create_qp_in,
 							 in, pas));
 
-	err = mlx5_core_create_qp(mdev, &dr_qp->mqp, in, inlen);
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	dr_qp->mqp.qpn = MLX5_GET(create_qp_out, out, qpn);
 	kfree(in);
-
-	if (err) {
-		mlx5_core_warn(mdev, " Can't create QP\n");
+	if (err)
 		goto err_in;
-	}
 	dr_qp->mqp.event = dr_qp_event;
 	dr_qp->uar = attr->uar;
 
@@ -204,7 +204,13 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 static void dr_destroy_qp(struct mlx5_core_dev *mdev,
 			  struct mlx5dr_qp *dr_qp)
 {
-	mlx5_core_destroy_qp(mdev, &dr_qp->mqp);
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+	struct mlx5_core_qp *qp = &dr_qp->mqp;
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	mlx5_cmd_exec_in(mdev, destroy_qp, in);
+
 	kfree(dr_qp->sq.wqe_head);
 	mlx5_wq_destroy(&dr_qp->wq_ctrl);
 	kfree(dr_qp);
-- 
2.25.2

