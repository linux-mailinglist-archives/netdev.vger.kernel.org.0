Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CDB1B07D7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDTLnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgDTLnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:43:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD7D21473;
        Mon, 20 Apr 2020 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382987;
        bh=S7EtMEV5NVQ1gb6prsMUp5hKEADwWIoPw4khOuEP8aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKOP//xxRSm0nibKv8NIhiuXfQV982kDOXi3Txw66u28oT2FvXaAy8xqMVSnpV2R1
         9yy5uexu09bQfBSs1OBo7EiAxfG4QljjYZAOqJLNQVdb0cpbYaDXeprGOxxzM0iLOp
         PGCaH0rlEa+5JbpIJ07pEmu49Cu+z70B7l2cE2e4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 24/24] net/mlx5: Update transobj.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:36 +0300
Message-Id: <20200420114136.264924-25-leon@kernel.org>
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

Do mass update of transobj.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c               |  32 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   |   7 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  29 ++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/transobj.c    | 113 +++++++-----------
 include/linux/mlx5/transobj.h                 |  19 +--
 9 files changed, 85 insertions(+), 131 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 12082e19cf08..0f986ce22a96 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1255,7 +1255,7 @@ static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_sq *sq, u32 tdn,
 				    struct ib_pd *pd)
 {
-	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
 	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
 	MLX5_SET(create_tis_in, in, uid, to_mpd(pd)->uid);
@@ -1263,7 +1263,7 @@ static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 	if (qp->flags & MLX5_IB_QP_UNDERLAY)
 		MLX5_SET(tisc, tisc, underlay_qpn, qp->underlay_qpn);
 
-	return mlx5_core_create_tis(dev->mdev, in, sizeof(in), &sq->tisn);
+	return mlx5_core_create_tis(dev->mdev, in, &sq->tisn);
 }
 
 static void destroy_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
@@ -1460,9 +1460,8 @@ static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 
 static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_rq *rq, u32 tdn,
-				    u32 *qp_flags_en,
-				    struct ib_pd *pd,
-				    u32 *out, int outlen)
+				    u32 *qp_flags_en, struct ib_pd *pd,
+				    u32 *out)
 {
 	u8 lb_flag = 0;
 	u32 *in;
@@ -1495,9 +1494,8 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 	}
 
 	MLX5_SET(tirc, tirc, self_lb_block, lb_flag);
-
-	err = mlx5_core_create_tir_out(dev->mdev, in, inlen, out, outlen);
-
+	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
+	err = mlx5_cmd_exec_inout(dev->mdev, create_tir, in, out);
 	rq->tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
 		err = mlx5_ib_enable_lb(dev, false, true);
@@ -1557,9 +1555,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			goto err_destroy_sq;
 
-		err = create_raw_packet_qp_tir(
-			dev, rq, tdn, &qp->flags_en, pd, out,
-			MLX5_ST_SZ_BYTES(create_tir_out));
+		err = create_raw_packet_qp_tir(dev, rq, tdn, &qp->flags_en, pd,
+					       out);
 		if (err)
 			goto err_destroy_rq;
 
@@ -1854,7 +1851,8 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	MLX5_SET(rx_hash_field_select, hfso, selected_fields, selected_fields);
 
 create_tir:
-	err = mlx5_core_create_tir_out(dev->mdev, in, inlen, out, outlen);
+	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
+	err = mlx5_cmd_exec_inout(dev->mdev, create_tir, in, out);
 
 	qp->rss_qp.tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
@@ -2933,7 +2931,7 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
 
-	err = mlx5_core_modify_tis(dev, sq->tisn, in, inlen);
+	err = mlx5_core_modify_tis(dev, sq->tisn, in);
 
 	kvfree(in);
 
@@ -2960,7 +2958,7 @@ static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, lag_tx_port_affinity, tx_affinity);
 
-	err = mlx5_core_modify_tis(dev, sq->tisn, in, inlen);
+	err = mlx5_core_modify_tis(dev, sq->tisn, in);
 
 	kvfree(in);
 
@@ -3264,7 +3262,7 @@ static int modify_raw_packet_qp_rq(
 				"RAW PACKET QP counters are not supported on current FW\n");
 	}
 
-	err = mlx5_core_modify_rq(dev->mdev, rq->base.mqp.qpn, in, inlen);
+	err = mlx5_core_modify_rq(dev->mdev, rq->base.mqp.qpn, in);
 	if (err)
 		goto out;
 
@@ -3327,7 +3325,7 @@ static int modify_raw_packet_qp_sq(
 		MLX5_SET(sqc, sqc, packet_pacing_rate_limit_index, rl_index);
 	}
 
-	err = mlx5_core_modify_sq(dev, sq->base.mqp.qpn, in, inlen);
+	err = mlx5_core_modify_sq(dev, sq->base.mqp.qpn, in);
 	if (err) {
 		/* Remove new rate from table if failed */
 		if (new_rate_added)
@@ -6497,7 +6495,7 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 				"Receive WQ counters are not supported on current FW\n");
 	}
 
-	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in, inlen);
+	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in);
 	if (!err)
 		rwq->ibwq.state = (wq_state == MLX5_RQC_STATE_ERR) ? IB_WQS_ERR : wq_state;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 12a61bf82c14..1599b05f3c5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1012,7 +1012,7 @@ int mlx5e_redirect_rqt(struct mlx5e_priv *priv, u32 rqtn, int sz,
 void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
 				    const struct mlx5e_tirc_config *ttconfig,
 				    void *tirc, bool inner);
-void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen);
+void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in);
 struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types tt);
 
 struct mlx5e_xsk_param;
@@ -1102,8 +1102,8 @@ void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv);
 void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv);
 #endif
 
-int mlx5e_create_tir(struct mlx5_core_dev *mdev,
-		     struct mlx5e_tir *tir, u32 *in, int inlen);
+int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir,
+		     u32 *in);
 void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 		       struct mlx5e_tir *tir);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index f7890e0ce96c..af3228b3f303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -36,12 +36,11 @@
  * Global resources are common to all the netdevices crated on the same nic.
  */
 
-int mlx5e_create_tir(struct mlx5_core_dev *mdev,
-		     struct mlx5e_tir *tir, u32 *in, int inlen)
+int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 *in)
 {
 	int err;
 
-	err = mlx5_core_create_tir(mdev, in, inlen, &tir->tirn);
+	err = mlx5_core_create_tir(mdev, in, &tir->tirn);
 	if (err)
 		return err;
 
@@ -167,7 +166,7 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb)
 	mutex_lock(&mdev->mlx5e_res.td.list_lock);
 	list_for_each_entry(tir, &mdev->mlx5e_res.td.tirs_list, list) {
 		tirn = tir->tirn;
-		err = mlx5_core_modify_tir(mdev, tirn, in, inlen);
+		err = mlx5_core_modify_tir(mdev, tirn, in);
 		if (err)
 			goto out;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6d703ddee4e2..de8250820b06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1204,7 +1204,7 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	}
 
 	if (hash_changed)
-		mlx5e_modify_tirs_hash(priv, in, inlen);
+		mlx5e_modify_tirs_hash(priv, in);
 
 	mutex_unlock(&priv->state_lock);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 3bc2ac3d53fc..83c9b2bbc4af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -858,7 +858,7 @@ static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
 		goto out;
 
 	priv->rss_params.rx_hash_fields[tt] = rx_hash_field;
-	mlx5e_modify_tirs_hash(priv, in, inlen);
+	mlx5e_modify_tirs_hash(priv, in);
 
 out:
 	mutex_unlock(&priv->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 30970b405040..05dbe8b9caac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -721,7 +721,7 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 	MLX5_SET(modify_rq_in, in, rq_state, curr_state);
 	MLX5_SET(rqc, rqc, state, next_state);
 
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in, inlen);
+	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
 
 	kvfree(in);
 
@@ -752,7 +752,7 @@ static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 	MLX5_SET(rqc, rqc, scatter_fcs, enable);
 	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RDY);
 
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in, inlen);
+	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
 
 	kvfree(in);
 
@@ -781,7 +781,7 @@ static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 	MLX5_SET(rqc, rqc, vsd, vsd);
 	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RDY);
 
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in, inlen);
+	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
 
 	kvfree(in);
 
@@ -1259,7 +1259,7 @@ int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		MLX5_SET(sqc,  sqc, packet_pacing_rate_limit_index, p->rl_index);
 	}
 
-	err = mlx5_core_modify_sq(mdev, sqn, in, inlen);
+	err = mlx5_core_modify_sq(mdev, sqn, in);
 
 	kvfree(in);
 
@@ -2698,7 +2698,7 @@ static void mlx5e_update_rx_hash_fields(struct mlx5e_tirc_config *ttconfig,
 	ttconfig->rx_hash_fields = rx_hash_fields;
 }
 
-void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen)
+void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 {
 	void *tirc = MLX5_ADDR_OF(modify_tir_in, in, ctx);
 	struct mlx5e_rss_params *rss = &priv->rss_params;
@@ -2714,7 +2714,7 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, false);
-		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in, inlen);
+		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
 	}
 
 	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
@@ -2725,8 +2725,7 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, true);
-		mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in,
-				     inlen);
+		mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
 	}
 }
 
@@ -2752,15 +2751,13 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 	mlx5e_build_tir_ctx_lro(&priv->channels.params, tirc);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in,
-					   inlen);
+		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
 		if (err)
 			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5_core_modify_tir(mdev, priv->direct_tir[ix].tirn,
-					   in, inlen);
+		err = mlx5_core_modify_tir(mdev, priv->direct_tir[ix].tirn, in);
 		if (err)
 			goto free_in;
 	}
@@ -3214,7 +3211,7 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
 
-	return mlx5_core_create_tis(mdev, in, MLX5_ST_SZ_BYTES(create_tis_in), tisn);
+	return mlx5_core_create_tis(mdev, in, tisn);
 }
 
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn)
@@ -3332,7 +3329,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		tir = &priv->indir_tir[tt];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_indir_tir_ctx(priv, tt, tirc);
-		err = mlx5e_create_tir(priv->mdev, tir, in, inlen);
+		err = mlx5e_create_tir(priv->mdev, tir, in);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "create indirect tirs failed, %d\n", err);
 			goto err_destroy_inner_tirs;
@@ -3347,7 +3344,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		tir = &priv->inner_indir_tir[i];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_inner_indir_tir_ctx(priv, i, tirc);
-		err = mlx5e_create_tir(priv->mdev, tir, in, inlen);
+		err = mlx5e_create_tir(priv->mdev, tir, in);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "create inner indirect tirs failed, %d\n", err);
 			goto err_destroy_inner_tirs;
@@ -3390,7 +3387,7 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 		tir = &tirs[ix];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_direct_tir_ctx(priv, tir->rqt.rqtn, tirc);
-		err = mlx5e_create_tir(priv->mdev, tir, in, inlen);
+		err = mlx5e_create_tir(priv->mdev, tir, in);
 		if (unlikely(err))
 			goto err_destroy_ch_tirs;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 438128dde187..88c0e460e995 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -568,7 +568,7 @@ struct mlx5_core_dev *mlx5e_hairpin_get_mdev(struct net *net, int ifindex)
 
 static int mlx5e_hairpin_create_transport(struct mlx5e_hairpin *hp)
 {
-	u32 in[MLX5_ST_SZ_DW(create_tir_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(create_tir_in)] = {};
 	void *tirc;
 	int err;
 
@@ -582,7 +582,7 @@ static int mlx5e_hairpin_create_transport(struct mlx5e_hairpin *hp)
 	MLX5_SET(tirc, tirc, inline_rqn, hp->pair->rqn[0]);
 	MLX5_SET(tirc, tirc, transport_domain, hp->tdn);
 
-	err = mlx5_core_create_tir(hp->func_mdev, in, MLX5_ST_SZ_BYTES(create_tir_in), &hp->tirn);
+	err = mlx5_core_create_tir(hp->func_mdev, in, &hp->tirn);
 	if (err)
 		goto create_tir_err;
 
@@ -666,7 +666,7 @@ static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 		mlx5e_build_indir_tir_ctx_hash(&priv->rss_params, &ttconfig, tirc, false);
 
 		err = mlx5_core_create_tir(hp->func_mdev, in,
-					   MLX5_ST_SZ_BYTES(create_tir_in), &hp->indir_tirn[tt]);
+					   &hp->indir_tirn[tt]);
 		if (err) {
 			mlx5_core_warn(hp->func_mdev, "create indirect tirs failed, %d\n", err);
 			goto err_destroy_tirs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index b1068500f1df..01cc00ad8acf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -36,14 +36,14 @@
 
 int mlx5_core_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn)
 {
-	u32 in[MLX5_ST_SZ_DW(alloc_transport_domain_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(alloc_transport_domain_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_transport_domain_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_transport_domain_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_transport_domain_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_TRANSPORT_DOMAIN);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, alloc_transport_domain, in, out);
 	if (!err)
 		*tdn = MLX5_GET(alloc_transport_domain_out, out,
 				transport_domain);
@@ -54,19 +54,18 @@ EXPORT_SYMBOL(mlx5_core_alloc_transport_domain);
 
 void mlx5_core_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn)
 {
-	u32 in[MLX5_ST_SZ_DW(dealloc_transport_domain_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(dealloc_transport_domain_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_transport_domain_in)] = {};
 
 	MLX5_SET(dealloc_transport_domain_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_TRANSPORT_DOMAIN);
 	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, dealloc_transport_domain, in);
 }
 EXPORT_SYMBOL(mlx5_core_dealloc_transport_domain);
 
 int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *rqn)
 {
-	u32 out[MLX5_ST_SZ_DW(create_rq_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_rq_out)] = {};
 	int err;
 
 	MLX5_SET(create_rq_in, in, opcode, MLX5_CMD_OP_CREATE_RQ);
@@ -78,44 +77,39 @@ int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *rqn)
 }
 EXPORT_SYMBOL(mlx5_core_create_rq);
 
-int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen)
+int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_rq_out)];
-
 	MLX5_SET(modify_rq_in, in, rqn, rqn);
 	MLX5_SET(modify_rq_in, in, opcode, MLX5_CMD_OP_MODIFY_RQ);
 
-	memset(out, 0, sizeof(out));
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_rq, in);
 }
 EXPORT_SYMBOL(mlx5_core_modify_rq);
 
 void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_rq_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)] = {};
 
 	MLX5_SET(destroy_rq_in, in, opcode, MLX5_CMD_OP_DESTROY_RQ);
 	MLX5_SET(destroy_rq_in, in, rqn, rqn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, destroy_rq, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_rq);
 
 int mlx5_core_query_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *out)
 {
-	u32 in[MLX5_ST_SZ_DW(query_rq_in)] = {0};
-	int outlen = MLX5_ST_SZ_BYTES(query_rq_out);
+	u32 in[MLX5_ST_SZ_DW(query_rq_in)] = {};
 
 	MLX5_SET(query_rq_in, in, opcode, MLX5_CMD_OP_QUERY_RQ);
 	MLX5_SET(query_rq_in, in, rqn, rqn);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec_inout(dev, query_rq, in, out);
 }
 EXPORT_SYMBOL(mlx5_core_query_rq);
 
 int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *sqn)
 {
-	u32 out[MLX5_ST_SZ_DW(create_sq_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_sq_out)] = {};
 	int err;
 
 	MLX5_SET(create_sq_in, in, opcode, MLX5_CMD_OP_CREATE_SQ);
@@ -126,34 +120,30 @@ int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *sqn)
 	return err;
 }
 
-int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen)
+int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_sq_out)] = {0};
-
 	MLX5_SET(modify_sq_in, in, sqn, sqn);
 	MLX5_SET(modify_sq_in, in, opcode, MLX5_CMD_OP_MODIFY_SQ);
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_sq, in);
 }
 EXPORT_SYMBOL(mlx5_core_modify_sq);
 
 void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_sq_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)] = {};
 
 	MLX5_SET(destroy_sq_in, in, opcode, MLX5_CMD_OP_DESTROY_SQ);
 	MLX5_SET(destroy_sq_in, in, sqn, sqn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, destroy_sq, in);
 }
 
 int mlx5_core_query_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *out)
 {
-	u32 in[MLX5_ST_SZ_DW(query_sq_in)] = {0};
-	int outlen = MLX5_ST_SZ_BYTES(query_sq_out);
+	u32 in[MLX5_ST_SZ_DW(query_sq_in)] = {};
 
 	MLX5_SET(query_sq_in, in, opcode, MLX5_CMD_OP_QUERY_SQ);
 	MLX5_SET(query_sq_in, in, sqn, sqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec_inout(dev, query_sq, in, out);
 }
 EXPORT_SYMBOL(mlx5_core_query_sq);
 
@@ -182,24 +172,13 @@ int mlx5_core_query_sq_state(struct mlx5_core_dev *dev, u32 sqn, u8 *state)
 }
 EXPORT_SYMBOL_GPL(mlx5_core_query_sq_state);
 
-int mlx5_core_create_tir_out(struct mlx5_core_dev *dev,
-			     u32 *in, int inlen,
-			     u32 *out, int outlen)
-{
-	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
-
-	return mlx5_cmd_exec(dev, in, inlen, out, outlen);
-}
-EXPORT_SYMBOL(mlx5_core_create_tir_out);
-
-int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tirn)
+int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, u32 *tirn)
 {
 	u32 out[MLX5_ST_SZ_DW(create_tir_out)] = {};
 	int err;
 
-	err = mlx5_core_create_tir_out(dev, in, inlen,
-				       out, sizeof(out));
+	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
+	err = mlx5_cmd_exec_inout(dev, create_tir, in, out);
 	if (!err)
 		*tirn = MLX5_GET(create_tir_out, out, tirn);
 
@@ -207,35 +186,30 @@ int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 }
 EXPORT_SYMBOL(mlx5_core_create_tir);
 
-int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
-			 int inlen)
+int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_tir_out)] = {0};
-
 	MLX5_SET(modify_tir_in, in, tirn, tirn);
 	MLX5_SET(modify_tir_in, in, opcode, MLX5_CMD_OP_MODIFY_TIR);
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_tir, in);
 }
 
 void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_tir_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_tir_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_tir_in)] = {};
 
 	MLX5_SET(destroy_tir_in, in, opcode, MLX5_CMD_OP_DESTROY_TIR);
 	MLX5_SET(destroy_tir_in, in, tirn, tirn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, destroy_tir, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_tir);
 
-int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tisn)
+int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, u32 *tisn)
 {
-	u32 out[MLX5_ST_SZ_DW(create_tis_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_tis_out)] = {};
 	int err;
 
 	MLX5_SET(create_tis_in, in, opcode, MLX5_CMD_OP_CREATE_TIS);
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, create_tis, in, out);
 	if (!err)
 		*tisn = MLX5_GET(create_tis_out, out, tisn);
 
@@ -243,33 +217,29 @@ int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 }
 EXPORT_SYMBOL(mlx5_core_create_tis);
 
-int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
-			 int inlen)
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_tis_out)] = {0};
-
 	MLX5_SET(modify_tis_in, in, tisn, tisn);
 	MLX5_SET(modify_tis_in, in, opcode, MLX5_CMD_OP_MODIFY_TIS);
 
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_tis, in);
 }
 EXPORT_SYMBOL(mlx5_core_modify_tis);
 
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_tis_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)] = {};
 
 	MLX5_SET(destroy_tis_in, in, opcode, MLX5_CMD_OP_DESTROY_TIS);
 	MLX5_SET(destroy_tis_in, in, tisn, tisn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, destroy_tis, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_tis);
 
 int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rqtn)
 {
-	u32 out[MLX5_ST_SZ_DW(create_rqt_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_rqt_out)] = {};
 	int err;
 
 	MLX5_SET(create_rqt_in, in, opcode, MLX5_CMD_OP_CREATE_RQT);
@@ -284,7 +254,7 @@ EXPORT_SYMBOL(mlx5_core_create_rqt);
 int mlx5_core_modify_rqt(struct mlx5_core_dev *dev, u32 rqtn, u32 *in,
 			 int inlen)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_rqt_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(modify_rqt_out)] = {};
 
 	MLX5_SET(modify_rqt_in, in, rqtn, rqtn);
 	MLX5_SET(modify_rqt_in, in, opcode, MLX5_CMD_OP_MODIFY_RQT);
@@ -293,12 +263,11 @@ int mlx5_core_modify_rqt(struct mlx5_core_dev *dev, u32 rqtn, u32 *in,
 
 void mlx5_core_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_rqt_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_rqt_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_rqt_in)] = {};
 
 	MLX5_SET(destroy_rqt_in, in, opcode, MLX5_CMD_OP_DESTROY_RQT);
 	MLX5_SET(destroy_rqt_in, in, rqtn, rqtn);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, destroy_rqt, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_rqt);
 
@@ -383,7 +352,7 @@ static int mlx5_hairpin_modify_rq(struct mlx5_core_dev *func_mdev, u32 rqn,
 				  int curr_state, int next_state,
 				  u16 peer_vhca, u32 peer_sq)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_rq_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_rq_in)] = {};
 	void *rqc;
 
 	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
@@ -396,8 +365,7 @@ static int mlx5_hairpin_modify_rq(struct mlx5_core_dev *func_mdev, u32 rqn,
 	MLX5_SET(modify_rq_in, in, rq_state, curr_state);
 	MLX5_SET(rqc, rqc, state, next_state);
 
-	return mlx5_core_modify_rq(func_mdev, rqn,
-				   in, MLX5_ST_SZ_BYTES(modify_rq_in));
+	return mlx5_core_modify_rq(func_mdev, rqn, in);
 }
 
 static int mlx5_hairpin_modify_sq(struct mlx5_core_dev *peer_mdev, u32 sqn,
@@ -417,8 +385,7 @@ static int mlx5_hairpin_modify_sq(struct mlx5_core_dev *peer_mdev, u32 sqn,
 	MLX5_SET(modify_sq_in, in, sq_state, curr_state);
 	MLX5_SET(sqc, sqc, state, next_state);
 
-	return mlx5_core_modify_sq(peer_mdev, sqn,
-				   in, MLX5_ST_SZ_BYTES(modify_sq_in));
+	return mlx5_core_modify_sq(peer_mdev, sqn, in);
 }
 
 static int mlx5_hairpin_pair_queues(struct mlx5_hairpin *hp)
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
index dc6b1e7cb8c4..028f442530cf 100644
--- a/include/linux/mlx5/transobj.h
+++ b/include/linux/mlx5/transobj.h
@@ -39,27 +39,20 @@ int mlx5_core_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn);
 void mlx5_core_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn);
 int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			u32 *rqn);
-int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen);
+int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in);
 void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn);
 int mlx5_core_query_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *out);
 int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			u32 *sqn);
-int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen);
+int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in);
 void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn);
 int mlx5_core_query_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *out);
 int mlx5_core_query_sq_state(struct mlx5_core_dev *dev, u32 sqn, u8 *state);
-int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tirn);
-int mlx5_core_create_tir_out(struct mlx5_core_dev *dev,
-			     u32 *in, int inlen,
-			     u32 *out, int outlen);
-int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
-			 int inlen);
+int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, u32 *tirn);
+int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in);
 void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
-int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tisn);
-int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
-			 int inlen);
+int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, u32 *tisn);
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in);
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn);
 int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rqtn);
-- 
2.25.2

