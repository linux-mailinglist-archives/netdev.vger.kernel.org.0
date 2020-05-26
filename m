Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332FE1A6802
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgDMOXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbgDMOXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15C320787;
        Mon, 13 Apr 2020 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787814;
        bh=NsKR61vFRdINssLyQE7FToCMjOivdBaaPtzX+8EA1S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxbPFKrpSbMaSm1pK04YZuLYeDLwt6KdJB4pfy2lm4VQyW2qLfLI0XxzkmDdrl7x8
         zckjT8ARaiBXZkAVsoKiAB9Fo8/fl9/7r9qCsW9L9nwa6pn0pgYWG3+g8qhSqzp7/c
         hbg7gUAle7fioJ6M4eXzHY0yXxS7jd9WyAgk926E=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/13] net/mlx5: Remove extra indirection while storing QPN
Date:   Mon, 13 Apr 2020 17:23:02 +0300
Message-Id: <20200413142308.936946-8-leon@kernel.org>
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

The FPGA, SW steering and IPoIB need to have only QPN from the
mlx5_core_qp struct, so reduce memory footprint by storing QPN
directly.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 23 ++++---
 .../ethernet/mellanox/mlx5/core/fpga/conn.h   |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 60 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |  6 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     | 19 +++---
 .../mellanox/mlx5/core/steering/dr_send.c     | 19 +++---
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 7 files changed, 64 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index b00d834d2dbf..182d3ac3e73f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -165,7 +165,7 @@ static void mlx5_fpga_conn_post_send(struct mlx5_fpga_conn *conn,
 	ctrl->fm_ce_se = MLX5_WQE_CTRL_CQ_UPDATE;
 	ctrl->opmod_idx_opcode = cpu_to_be32(((conn->qp.sq.pc & 0xffff) << 8) |
 					     MLX5_OPCODE_SEND);
-	ctrl->qpn_ds = cpu_to_be32(size | (conn->qp.mqp.qpn << 8));
+	ctrl->qpn_ds = cpu_to_be32(size | (conn->qp.qpn << 8));
 
 	conn->qp.sq.pc++;
 	conn->qp.sq.bufs[ix] = buf;
@@ -588,8 +588,8 @@ static int mlx5_fpga_conn_create_qp(struct mlx5_fpga_conn *conn,
 	if (err)
 		goto err_sq_bufs;
 
-	conn->qp.mqp.qpn = MLX5_GET(create_qp_out, out, qpn);
-	mlx5_fpga_dbg(fdev, "Created QP #0x%x\n", conn->qp.mqp.qpn);
+	conn->qp.qpn = MLX5_GET(create_qp_out, out, qpn);
+	mlx5_fpga_dbg(fdev, "Created QP #0x%x\n", conn->qp.qpn);
 
 	goto out;
 
@@ -644,10 +644,9 @@ static void mlx5_fpga_conn_destroy_qp(struct mlx5_fpga_conn *conn)
 {
 	struct mlx5_core_dev *dev = conn->fdev->mdev;
 	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
-	struct mlx5_core_qp *qp = &conn->qp.mqp;
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
-	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	MLX5_SET(destroy_qp_in, in, qpn, conn->qp.qpn);
 	mlx5_cmd_exec_in(dev, destroy_qp, in);
 
 	mlx5_fpga_conn_free_recv_bufs(conn);
@@ -662,10 +661,10 @@ static int mlx5_fpga_conn_reset_qp(struct mlx5_fpga_conn *conn)
 	struct mlx5_core_dev *mdev = conn->fdev->mdev;
 	u32 in[MLX5_ST_SZ_DW(qp_2rst_in)] = {};
 
-	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to RST\n", conn->qp.mqp.qpn);
+	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to RST\n", conn->qp.qpn);
 
 	MLX5_SET(qp_2rst_in, in, opcode, MLX5_CMD_OP_2RST_QP);
-	MLX5_SET(qp_2rst_in, in, qpn, conn->qp.mqp.qpn);
+	MLX5_SET(qp_2rst_in, in, qpn, conn->qp.qpn);
 
 	return mlx5_cmd_exec_in(mdev, qp_2rst, in);
 }
@@ -677,7 +676,7 @@ static int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
 	struct mlx5_core_dev *mdev = fdev->mdev;
 	u32 *qpc;
 
-	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to INIT\n", conn->qp.mqp.qpn);
+	mlx5_fpga_dbg(conn->fdev, "Modifying QP %u to INIT\n", conn->qp.qpn);
 
 	qpc = MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
 
@@ -691,7 +690,7 @@ static int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET64(qpc, qpc, dbr_addr, conn->qp.wq_ctrl.db.dma);
 
 	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
-	MLX5_SET(rst2init_qp_in, in, qpn, conn->qp.mqp.qpn);
+	MLX5_SET(rst2init_qp_in, in, qpn, conn->qp.qpn);
 
 	return mlx5_cmd_exec_in(mdev, rst2init_qp, in);
 }
@@ -726,7 +725,7 @@ static int mlx5_fpga_conn_rtr_qp(struct mlx5_fpga_conn *conn)
 	       MLX5_FLD_SZ_BYTES(qpc, primary_address_path.rgid_rip));
 
 	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
-	MLX5_SET(init2rtr_qp_in, in, qpn, conn->qp.mqp.qpn);
+	MLX5_SET(init2rtr_qp_in, in, qpn, conn->qp.qpn);
 
 	return mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 }
@@ -751,7 +750,7 @@ static int mlx5_fpga_conn_rts_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET(qpc, qpc, rnr_retry, 7); /* Infinite retry if RNR NACK */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
-	MLX5_SET(rtr2rts_qp_in, in, qpn, conn->qp.mqp.qpn);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, conn->qp.qpn);
 	MLX5_SET(rtr2rts_qp_in, in, opt_param_mask, MLX5_QP_OPTPAR_RNR_TIMEOUT);
 
 	return mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
@@ -894,7 +893,7 @@ struct mlx5_fpga_conn *mlx5_fpga_conn_create(struct mlx5_fpga_device *fdev,
 	MLX5_SET(fpga_qpc, conn->fpga_qpc, next_rcv_psn, 1);
 	MLX5_SET(fpga_qpc, conn->fpga_qpc, next_send_psn, 0);
 	MLX5_SET(fpga_qpc, conn->fpga_qpc, pkey, MLX5_FPGA_PKEY);
-	MLX5_SET(fpga_qpc, conn->fpga_qpc, remote_qpn, conn->qp.mqp.qpn);
+	MLX5_SET(fpga_qpc, conn->fpga_qpc, remote_qpn, conn->qp.qpn);
 	MLX5_SET(fpga_qpc, conn->fpga_qpc, rnr_retry, 7);
 	MLX5_SET(fpga_qpc, conn->fpga_qpc, retry_count, 7);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.h
index 634ae10e287b..5116e869a6e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.h
@@ -65,7 +65,7 @@ struct mlx5_fpga_conn {
 		int sgid_index;
 		struct mlx5_wq_qp wq;
 		struct mlx5_wq_ctrl wq_ctrl;
-		struct mlx5_core_qp mqp;
+		u32 qpn;
 		struct {
 			spinlock_t lock; /* Protects all SQ state */
 			unsigned int pc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 83b198d8e3d6..068578be00f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -160,7 +160,6 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5i_priv *ipriv = priv->ppriv;
-	struct mlx5_core_qp *qp = &ipriv->qp;
 	int ret;
 
 	{
@@ -176,7 +175,7 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 		MLX5_SET(qpc, qpc, q_key, IB_DEFAULT_Q_KEY);
 
 		MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
-		MLX5_SET(rst2init_qp_in, in, qpn, qp->qpn);
+		MLX5_SET(rst2init_qp_in, in, qpn, ipriv->qpn);
 		ret = mlx5_cmd_exec_in(mdev, rst2init_qp, in);
 		if (ret)
 			goto err_qp_modify_to_err;
@@ -185,7 +184,7 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 		u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
 
 		MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
-		MLX5_SET(init2rtr_qp_in, in, qpn, qp->qpn);
+		MLX5_SET(init2rtr_qp_in, in, qpn, ipriv->qpn);
 		ret = mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 		if (ret)
 			goto err_qp_modify_to_err;
@@ -194,7 +193,7 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 		u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
 
 		MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
-		MLX5_SET(rtr2rts_qp_in, in, qpn, qp->qpn);
+		MLX5_SET(rtr2rts_qp_in, in, qpn, ipriv->qpn);
 		ret = mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
 		if (ret)
 			goto err_qp_modify_to_err;
@@ -206,7 +205,7 @@ int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 		u32 in[MLX5_ST_SZ_DW(qp_2err_in)] = {};
 
 		MLX5_SET(qp_2err_in, in, opcode, MLX5_CMD_OP_2ERR_QP);
-		MLX5_SET(qp_2err_in, in, qpn, qp->qpn);
+		MLX5_SET(qp_2err_in, in, qpn, ipriv->qpn);
 		mlx5_cmd_exec_in(mdev, qp_2err, in);
 	}
 	return ret;
@@ -219,16 +218,17 @@ void mlx5i_uninit_underlay_qp(struct mlx5e_priv *priv)
 	u32 in[MLX5_ST_SZ_DW(qp_2rst_in)] = {};
 
 	MLX5_SET(qp_2rst_in, in, opcode, MLX5_CMD_OP_2RST_QP);
-	MLX5_SET(qp_2rst_in, in, qpn, ipriv->qp.qpn);
+	MLX5_SET(qp_2rst_in, in, qpn, ipriv->qpn);
 	mlx5_cmd_exec_in(mdev, qp_2rst, in);
 }
 
 #define MLX5_QP_ENHANCED_ULP_STATELESS_MODE 2
 
-int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp)
+int mlx5i_create_underlay_qp(struct mlx5e_priv *priv)
 {
 	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_qp_in)] = {};
+	struct mlx5i_priv *ipriv = priv->ppriv;
 	void *addr_path;
 	int ret = 0;
 	void *qpc;
@@ -244,21 +244,21 @@ int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp
 	MLX5_SET(ads, addr_path, grh, 1);
 
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
-	ret = mlx5_cmd_exec_inout(mdev, create_qp, in, out);
+	ret = mlx5_cmd_exec_inout(priv->mdev, create_qp, in, out);
 	if (ret)
 		return ret;
 
-	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+	ipriv->qpn = MLX5_GET(create_qp_out, out, qpn);
 
 	return 0;
 }
 
-void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp)
+void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, u32 qpn)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
-	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	MLX5_SET(destroy_qp_in, in, qpn, qpn);
 	mlx5_cmd_exec_in(mdev, destroy_qp, in);
 }
 
@@ -279,13 +279,13 @@ static int mlx5i_init_tx(struct mlx5e_priv *priv)
 	struct mlx5i_priv *ipriv = priv->ppriv;
 	int err;
 
-	err = mlx5i_create_underlay_qp(priv->mdev, &ipriv->qp);
+	err = mlx5i_create_underlay_qp(priv);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "create underlay QP failed, %d\n", err);
 		return err;
 	}
 
-	err = mlx5i_create_tis(priv->mdev, ipriv->qp.qpn, &priv->tisn[0][0]);
+	err = mlx5i_create_tis(priv->mdev, ipriv->qpn, &priv->tisn[0][0]);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "create tis failed, %d\n", err);
 		goto err_destroy_underlay_qp;
@@ -294,7 +294,7 @@ static int mlx5i_init_tx(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_underlay_qp:
-	mlx5i_destroy_underlay_qp(priv->mdev, &ipriv->qp);
+	mlx5i_destroy_underlay_qp(priv->mdev, ipriv->qpn);
 	return err;
 }
 
@@ -303,7 +303,7 @@ static void mlx5i_cleanup_tx(struct mlx5e_priv *priv)
 	struct mlx5i_priv *ipriv = priv->ppriv;
 
 	mlx5e_destroy_tis(priv->mdev, priv->tisn[0][0]);
-	mlx5i_destroy_underlay_qp(priv->mdev, &ipriv->qp);
+	mlx5i_destroy_underlay_qp(priv->mdev, ipriv->qpn);
 }
 
 static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
@@ -506,12 +506,12 @@ int mlx5i_dev_init(struct net_device *dev)
 	struct mlx5i_priv    *ipriv  = priv->ppriv;
 
 	/* Set dev address using underlay QP */
-	dev->dev_addr[1] = (ipriv->qp.qpn >> 16) & 0xff;
-	dev->dev_addr[2] = (ipriv->qp.qpn >>  8) & 0xff;
-	dev->dev_addr[3] = (ipriv->qp.qpn) & 0xff;
+	dev->dev_addr[1] = (ipriv->qpn >> 16) & 0xff;
+	dev->dev_addr[2] = (ipriv->qpn >>  8) & 0xff;
+	dev->dev_addr[3] = (ipriv->qpn) & 0xff;
 
 	/* Add QPN to net-device mapping to HT */
-	mlx5i_pkey_add_qpn(dev ,ipriv->qp.qpn);
+	mlx5i_pkey_add_qpn(dev, ipriv->qpn);
 
 	return 0;
 }
@@ -538,7 +538,7 @@ void mlx5i_dev_cleanup(struct net_device *dev)
 	mlx5i_uninit_underlay_qp(priv);
 
 	/* Delete QPN to net-device mapping from HT */
-	mlx5i_pkey_del_qpn(dev, ipriv->qp.qpn);
+	mlx5i_pkey_del_qpn(dev, ipriv->qpn);
 }
 
 static int mlx5i_open(struct net_device *netdev)
@@ -558,7 +558,7 @@ static int mlx5i_open(struct net_device *netdev)
 		goto err_clear_state_opened_flag;
 	}
 
-	err = mlx5_fs_add_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	err = mlx5_fs_add_rx_underlay_qpn(mdev, ipriv->qpn);
 	if (err) {
 		mlx5_core_warn(mdev, "attach underlay qp to ft failed, %d\n", err);
 		goto err_reset_qp;
@@ -575,7 +575,7 @@ static int mlx5i_open(struct net_device *netdev)
 	return 0;
 
 err_remove_fs_underlay_qp:
-	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qpn);
 err_reset_qp:
 	mlx5i_uninit_underlay_qp(epriv);
 err_clear_state_opened_flag:
@@ -601,7 +601,7 @@ static int mlx5i_close(struct net_device *netdev)
 	clear_bit(MLX5E_STATE_OPENED, &epriv->state);
 
 	netif_carrier_off(epriv->netdev);
-	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qpn);
 	mlx5e_deactivate_priv_channels(epriv);
 	mlx5e_close_channels(&epriv->channels);
 	mlx5i_uninit_underlay_qp(epriv);
@@ -620,11 +620,12 @@ static int mlx5i_attach_mcast(struct net_device *netdev, struct ib_device *hca,
 	struct mlx5i_priv    *ipriv = epriv->ppriv;
 	int err;
 
-	mlx5_core_dbg(mdev, "attaching QPN 0x%x, MGID %pI6\n", ipriv->qp.qpn, gid->raw);
-	err = mlx5_core_attach_mcg(mdev, gid, ipriv->qp.qpn);
+	mlx5_core_dbg(mdev, "attaching QPN 0x%x, MGID %pI6\n", ipriv->qpn,
+		      gid->raw);
+	err = mlx5_core_attach_mcg(mdev, gid, ipriv->qpn);
 	if (err)
 		mlx5_core_warn(mdev, "failed attaching QPN 0x%x, MGID %pI6\n",
-			       ipriv->qp.qpn, gid->raw);
+			       ipriv->qpn, gid->raw);
 
 	if (set_qkey) {
 		mlx5_core_dbg(mdev, "%s setting qkey 0x%x\n",
@@ -643,12 +644,13 @@ static int mlx5i_detach_mcast(struct net_device *netdev, struct ib_device *hca,
 	struct mlx5i_priv    *ipriv = epriv->ppriv;
 	int err;
 
-	mlx5_core_dbg(mdev, "detaching QPN 0x%x, MGID %pI6\n", ipriv->qp.qpn, gid->raw);
+	mlx5_core_dbg(mdev, "detaching QPN 0x%x, MGID %pI6\n", ipriv->qpn,
+		      gid->raw);
 
-	err = mlx5_core_detach_mcg(mdev, gid, ipriv->qp.qpn);
+	err = mlx5_core_detach_mcg(mdev, gid, ipriv->qpn);
 	if (err)
 		mlx5_core_dbg(mdev, "failed detaching QPN 0x%x, MGID %pI6\n",
-			      ipriv->qp.qpn, gid->raw);
+			      ipriv->qpn, gid->raw);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index de7e01a027bb..3483ba642cfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -51,7 +51,7 @@ extern const struct ethtool_ops mlx5i_pkey_ethtool_ops;
 /* ipoib rdma netdev's private data structure */
 struct mlx5i_priv {
 	struct rdma_netdev rn; /* keep this first */
-	struct mlx5_core_qp qp;
+	u32 qpn;
 	bool   sub_interface;
 	u32    qkey;
 	u16    pkey_index;
@@ -62,8 +62,8 @@ struct mlx5i_priv {
 int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn);
 
 /* Underlay QP create/destroy functions */
-int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp);
-void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp);
+int mlx5i_create_underlay_qp(struct mlx5e_priv *priv);
+void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, u32 qpn);
 
 /* Underlay QP state modification init/uninit functions */
 int mlx5i_init_underlay_qp(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 96e64187c089..b9af37ad40bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -204,13 +204,13 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 		goto err_release_lock;
 	}
 
-	err = mlx5_fs_add_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	err = mlx5_fs_add_rx_underlay_qpn(mdev, ipriv->qpn);
 	if (err) {
 		mlx5_core_warn(mdev, "attach child underlay qp to ft failed, %d\n", err);
 		goto err_unint_underlay_qp;
 	}
 
-	err = mlx5i_create_tis(mdev, ipriv->qp.qpn, &epriv->tisn[0][0]);
+	err = mlx5i_create_tis(mdev, ipriv->qpn, &epriv->tisn[0][0]);
 	if (err) {
 		mlx5_core_warn(mdev, "create child tis failed, %d\n", err);
 		goto err_remove_rx_uderlay_qp;
@@ -230,7 +230,7 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 err_clear_state_opened_flag:
 	mlx5e_destroy_tis(mdev, epriv->tisn[0][0]);
 err_remove_rx_uderlay_qp:
-	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qpn);
 err_unint_underlay_qp:
 	mlx5i_uninit_underlay_qp(epriv);
 err_release_lock:
@@ -253,7 +253,7 @@ static int mlx5i_pkey_close(struct net_device *netdev)
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	netif_carrier_off(priv->netdev);
-	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
+	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qpn);
 	mlx5i_uninit_underlay_qp(priv);
 	mlx5e_deactivate_priv_channels(priv);
 	mlx5e_close_channels(&priv->channels);
@@ -307,23 +307,20 @@ static void mlx5i_pkey_cleanup(struct mlx5e_priv *priv)
 
 static int mlx5i_pkey_init_tx(struct mlx5e_priv *priv)
 {
-	struct mlx5i_priv *ipriv = priv->ppriv;
 	int err;
 
-	err = mlx5i_create_underlay_qp(priv->mdev, &ipriv->qp);
-	if (err) {
+	err = mlx5i_create_underlay_qp(priv);
+	if (err)
 		mlx5_core_warn(priv->mdev, "create child underlay QP failed, %d\n", err);
-		return err;
-	}
 
-	return 0;
+	return err;
 }
 
 static void mlx5i_pkey_cleanup_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5i_priv *ipriv = priv->ppriv;
 
-	mlx5i_destroy_underlay_qp(priv->mdev, &ipriv->qp);
+	mlx5i_destroy_underlay_qp(priv->mdev, ipriv->qpn);
 }
 
 static int mlx5i_pkey_init_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 266b913d2f9a..c4ed25bb9ac8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -178,7 +178,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
-	dr_qp->mqp.qpn = MLX5_GET(create_qp_out, out, qpn);
+	dr_qp->qpn = MLX5_GET(create_qp_out, out, qpn);
 	kfree(in);
 	if (err)
 		goto err_in;
@@ -199,10 +199,9 @@ static void dr_destroy_qp(struct mlx5_core_dev *mdev,
 			  struct mlx5dr_qp *dr_qp)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
-	struct mlx5_core_qp *qp = &dr_qp->mqp;
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
-	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	MLX5_SET(destroy_qp_in, in, qpn, dr_qp->qpn);
 	mlx5_cmd_exec_in(mdev, destroy_qp, in);
 
 	kfree(dr_qp->sq.wqe_head);
@@ -242,7 +241,7 @@ static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
 		MLX5_WQE_CTRL_CQ_UPDATE : 0;
 	wq_ctrl->opmod_idx_opcode = cpu_to_be32(((dr_qp->sq.pc & 0xffff) << 8) |
 						opcode);
-	wq_ctrl->qpn_ds = cpu_to_be32(size | dr_qp->mqp.qpn << 8);
+	wq_ctrl->qpn_ds = cpu_to_be32(size | dr_qp->qpn << 8);
 	wq_raddr = (void *)(wq_ctrl + 1);
 	wq_raddr->raddr = cpu_to_be64(remote_addr);
 	wq_raddr->rkey = cpu_to_be32(rkey);
@@ -586,7 +585,7 @@ static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, rwe, 1);
 
 	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
-	MLX5_SET(rst2init_qp_in, in, qpn, dr_qp->mqp.qpn);
+	MLX5_SET(rst2init_qp_in, in, qpn, dr_qp->qpn);
 
 	return mlx5_cmd_exec_in(mdev, rst2init_qp, in);
 }
@@ -600,13 +599,13 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	qpc  = MLX5_ADDR_OF(rtr2rts_qp_in, in, qpc);
 
-	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->mqp.qpn);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
-	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->mqp.qpn);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
 
 	return mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
 }
@@ -620,7 +619,7 @@ static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
 
 	qpc = MLX5_ADDR_OF(init2rtr_qp_in, in, qpc);
 
-	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->mqp.qpn);
+	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->qpn);
 
 	MLX5_SET(qpc, qpc, mtu, attr->mtu);
 	MLX5_SET(qpc, qpc, log_msg_max, DR_CHUNK_SIZE_MAX - 1);
@@ -640,7 +639,7 @@ static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, min_rnr_nak, 1);
 
 	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
-	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->mqp.qpn);
+	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->qpn);
 
 	return mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 }
@@ -668,7 +667,7 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 		return ret;
 
 	rtr_attr.mtu		= mtu;
-	rtr_attr.qp_num		= dr_qp->mqp.qpn;
+	rtr_attr.qp_num		= dr_qp->qpn;
 	rtr_attr.min_rnr_timer	= 12;
 	rtr_attr.port_num	= port;
 	rtr_attr.sgid_index	= gid_index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3fa739951b34..984783238baa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -990,7 +990,7 @@ struct mlx5dr_qp {
 	struct mlx5_wq_qp wq;
 	struct mlx5_uars_page *uar;
 	struct mlx5_wq_ctrl wq_ctrl;
-	struct mlx5_core_qp mqp;
+	u32 qpn;
 	struct {
 		unsigned int pc;
 		unsigned int cc;
-- 
2.25.2

