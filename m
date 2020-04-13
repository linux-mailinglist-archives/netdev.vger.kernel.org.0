Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89921A6810
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgDMOX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730684AbgDMOXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 386FC20787;
        Mon, 13 Apr 2020 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787829;
        bh=Yrvl7cVyjVF4MZ07IGEe7wpgNTEJp46zk74gw7arUWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/pbAtikiBtSf3QBMBo3ZvvLFMunRfeqC6YjdYrtf/KMG3F31RO0EhHLarGZaU59R
         Wq8AF/ufwmG1K72oBqE2FIfPmmx+mZt8wQqxQcTlhHzyJAF/tYMtFPuEH9IeU2c+u4
         1P3TDzlepBLSFTMv0Hk22qAZNWRI3mjkyLxNJY+E=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/13] net/mlx5: Open-code modify QP in the FPGA module
Date:   Mon, 13 Apr 2020 17:23:00 +0300
Message-Id: <20200413142308.936946-6-leon@kernel.org>
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

Remove dependency on qp.c from the FPGA by open coding
modify QP interface.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 84 +++++++------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 1d49894399af..b00d834d2dbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -657,30 +657,29 @@ static void mlx5_fpga_conn_destroy_qp(struct mlx5_fpga_conn *conn)
 	mlx5_wq_destroy(&conn->qp.wq_ctrl);
 }
 
-static inline int mlx5_fpga_conn_reset_qp(struct mlx5_fpga_conn *conn)
+static int mlx5_fpga_conn_reset_qp(struct mlx5_fpga_conn *conn)
 {
 	struct mlx5_core_dev *mdev = conn->fdev->mdev;
+	u32 in[MLX5_ST_SZ_DW(qp_2rst_in)] = {};
 
 	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to RST\n", conn->qp.mqp.qpn);
 
-	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_2RST_QP, 0, NULL,
-				   &conn->qp.mqp);
+	MLX5_SET(qp_2rst_in, in, opcode, MLX5_CMD_OP_2RST_QP);
+	MLX5_SET(qp_2rst_in, in, qpn, conn->qp.mqp.qpn);
+
+	return mlx5_cmd_exec_in(mdev, qp_2rst, in);
 }
 
-static inline int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
+static int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
 {
+	u32 in[MLX5_ST_SZ_DW(rst2init_qp_in)] = {};
 	struct mlx5_fpga_device *fdev = conn->fdev;
 	struct mlx5_core_dev *mdev = fdev->mdev;
-	u32 *qpc = NULL;
-	int err;
+	u32 *qpc;
 
 	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to INIT\n", conn->qp.mqp.qpn);
 
-	qpc = kzalloc(MLX5_ST_SZ_BYTES(qpc), GFP_KERNEL);
-	if (!qpc) {
-		err = -ENOMEM;
-		goto out;
-	}
+	qpc = MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_RC);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
@@ -691,32 +690,22 @@ static inline int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET(qpc, qpc, cqn_rcv, conn->cq.mcq.cqn);
 	MLX5_SET64(qpc, qpc, dbr_addr, conn->qp.wq_ctrl.db.dma);
 
-	err = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RST2INIT_QP, 0, qpc,
-				  &conn->qp.mqp);
-	if (err) {
-		mlx5_fpga_warn(fdev, "qp_modify RST2INIT failed: %d\n", err);
-		goto out;
-	}
+	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+	MLX5_SET(rst2init_qp_in, in, qpn, conn->qp.mqp.qpn);
 
-out:
-	kfree(qpc);
-	return err;
+	return mlx5_cmd_exec_in(mdev, rst2init_qp, in);
 }
 
-static inline int mlx5_fpga_conn_rtr_qp(struct mlx5_fpga_conn *conn)
+static int mlx5_fpga_conn_rtr_qp(struct mlx5_fpga_conn *conn)
 {
+	u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
 	struct mlx5_fpga_device *fdev = conn->fdev;
 	struct mlx5_core_dev *mdev = fdev->mdev;
-	u32 *qpc = NULL;
-	int err;
+	u32 *qpc;
 
 	mlx5_fpga_dbg(conn->fdev, "QP RTR\n");
 
-	qpc = kzalloc(MLX5_ST_SZ_BYTES(qpc), GFP_KERNEL);
-	if (!qpc) {
-		err = -ENOMEM;
-		goto out;
-	}
+	qpc = MLX5_ADDR_OF(init2rtr_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, mtu, MLX5_QPC_MTU_1K_BYTES);
 	MLX5_SET(qpc, qpc, log_msg_max, (u8)MLX5_CAP_GEN(mdev, log_max_msg));
@@ -736,33 +725,22 @@ static inline int mlx5_fpga_conn_rtr_qp(struct mlx5_fpga_conn *conn)
 	       MLX5_ADDR_OF(fpga_qpc, conn->fpga_qpc, fpga_ip),
 	       MLX5_FLD_SZ_BYTES(qpc, primary_address_path.rgid_rip));
 
-	err = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_INIT2RTR_QP, 0, qpc,
-				  &conn->qp.mqp);
-	if (err) {
-		mlx5_fpga_warn(fdev, "qp_modify RST2INIT failed: %d\n", err);
-		goto out;
-	}
+	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+	MLX5_SET(init2rtr_qp_in, in, qpn, conn->qp.mqp.qpn);
 
-out:
-	kfree(qpc);
-	return err;
+	return mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 }
 
-static inline int mlx5_fpga_conn_rts_qp(struct mlx5_fpga_conn *conn)
+static int mlx5_fpga_conn_rts_qp(struct mlx5_fpga_conn *conn)
 {
 	struct mlx5_fpga_device *fdev = conn->fdev;
+	u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
 	struct mlx5_core_dev *mdev = fdev->mdev;
-	u32 *qpc = NULL;
-	u32 opt_mask;
-	int err;
+	u32 *qpc;
 
 	mlx5_fpga_dbg(conn->fdev, "QP RTS\n");
 
-	qpc = kzalloc(MLX5_ST_SZ_BYTES(qpc), GFP_KERNEL);
-	if (!qpc) {
-		err = -ENOMEM;
-		goto out;
-	}
+	qpc = MLX5_ADDR_OF(rtr2rts_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, log_ack_req_freq, 8);
 	MLX5_SET(qpc, qpc, min_rnr_nak, 0x12);
@@ -772,17 +750,11 @@ static inline int mlx5_fpga_conn_rts_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET(qpc, qpc, retry_count, 7);
 	MLX5_SET(qpc, qpc, rnr_retry, 7); /* Infinite retry if RNR NACK */
 
-	opt_mask = MLX5_QP_OPTPAR_RNR_TIMEOUT;
-	err = mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RTR2RTS_QP, opt_mask, qpc,
-				  &conn->qp.mqp);
-	if (err) {
-		mlx5_fpga_warn(fdev, "qp_modify RST2INIT failed: %d\n", err);
-		goto out;
-	}
+	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, conn->qp.mqp.qpn);
+	MLX5_SET(rtr2rts_qp_in, in, opt_param_mask, MLX5_QP_OPTPAR_RNR_TIMEOUT);
 
-out:
-	kfree(qpc);
-	return err;
+	return mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
 }
 
 static int mlx5_fpga_conn_connect(struct mlx5_fpga_conn *conn)
-- 
2.25.2

