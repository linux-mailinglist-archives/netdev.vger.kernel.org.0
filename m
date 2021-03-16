Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249B233E264
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCPXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhCPXvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4544664F18;
        Tue, 16 Mar 2021 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938680;
        bh=77WbTD4Fg0bcQZZBPnJgYzxVLjGnxN64Snf894tWIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYVti7SBIVWg5zTviwBCZwwASRTK5t5eCakTWh4VWei5+PBmpzI4mRo4vPK8uooEq
         xi8SL+IAuBYYWrcWDD1l9UO1xnDZIhj131OUu37PAdGLIWUjXP2RdxzuBZdeNis09Z
         vAgdY2iwr0rbiI9c7SKkN3WZ0bQlcynb3Cr8BUn0KPcNT2s2wEZD8Rr5oBnmferj3q
         NpjYtIxfMdtjZm3Lkn6wzLfpBA7CS/0uSHh2gm4jkVO+ZYJj6uWfu341PlEk4y4/OV
         Ig1VuuBV4cClRyGwA0de0YnIMzmvOm+S4lWWwuwXXGmx73pVpGZfALXwvMzP9JRd+/
         yI0LXYsE0SQhA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Move mlx5e hw resources into a sub object
Date:   Tue, 16 Mar 2021 16:51:07 -0700
Message-Id: <20210316235112.72626-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

This is to separate between resources attributes and other
attributes we will want to use.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  6 ++---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   | 27 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 22 +++++++--------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  |  2 +-
 include/linux/mlx5/driver.h                   | 10 ++++---
 8 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index d57b6f06382f..bb5d108f75d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -174,7 +174,7 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
 	sq->mdev      = mdev;
 	sq->ch_ix     = c->ix;
 	sq->txq_ix    = txq_ix;
-	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
+	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	sq->stats     = &c->priv->port_ptp_stats.sq[tc];
@@ -475,7 +475,7 @@ int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->ix       = 0;
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
 	c->num_tc   = params->num_tc;
 	c->stats    = &priv->port_ptp_stats.ch;
 	c->lag_port = lag_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 37fc1d77ded7..41db93883fea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -84,7 +84,7 @@ static int mlx5e_alloc_trap_rq(struct mlx5e_priv *priv, struct mlx5e_rq_param *r
 	if (err)
 		goto err_free_frags;
 
-	rq->mkey_be = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey.key);
 
 	mlx5e_rq_set_trap_handlers(rq, params);
 
@@ -213,7 +213,7 @@ static int mlx5e_create_trap_direct_rq_tir(struct mlx5_core_dev *mdev, struct ml
 		return -ENOMEM;
 
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_NONE);
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
 	MLX5_SET(tirc, tirc, inline_rqn, rqn);
@@ -266,7 +266,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 	t->tstamp   = &priv->tstamp;
 	t->pdev     = mlx5_core_dma_dev(priv->mdev);
 	t->netdev   = priv->netdev;
-	t->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	t->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
 	t->stats    = &priv->trap_stats.ch;
 
 	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll, 64);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index d06532d0baa4..f7c880edae37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -84,7 +84,7 @@ static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn
 
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 
-	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
 	MLX5_SET(tirc, tirc, indirect_table, rqtn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index a6cf008057b5..8c166ee56d8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -38,15 +38,16 @@
 
 int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 *in)
 {
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 	int err;
 
 	err = mlx5_core_create_tir(mdev, in, &tir->tirn);
 	if (err)
 		return err;
 
-	mutex_lock(&mdev->mlx5e_res.td.list_lock);
-	list_add(&tir->list, &mdev->mlx5e_res.td.tirs_list);
-	mutex_unlock(&mdev->mlx5e_res.td.list_lock);
+	mutex_lock(&res->td.list_lock);
+	list_add(&tir->list, &res->td.tirs_list);
+	mutex_unlock(&res->td.list_lock);
 
 	return 0;
 }
@@ -54,10 +55,12 @@ int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 *in)
 void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 		       struct mlx5e_tir *tir)
 {
-	mutex_lock(&mdev->mlx5e_res.td.list_lock);
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
+
+	mutex_lock(&res->td.list_lock);
 	mlx5_core_destroy_tir(mdev, tir->tirn);
 	list_del(&tir->list);
-	mutex_unlock(&mdev->mlx5e_res.td.list_lock);
+	mutex_unlock(&res->td.list_lock);
 }
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
@@ -99,7 +102,7 @@ static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 {
-	struct mlx5e_resources *res = &mdev->mlx5e_res;
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 	int err;
 
 	err = mlx5_core_alloc_pd(mdev, &res->pdn);
@@ -126,8 +129,8 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 		goto err_destroy_mkey;
 	}
 
-	INIT_LIST_HEAD(&mdev->mlx5e_res.td.tirs_list);
-	mutex_init(&mdev->mlx5e_res.td.list_lock);
+	INIT_LIST_HEAD(&res->td.tirs_list);
+	mutex_init(&res->td.list_lock);
 
 	return 0;
 
@@ -142,7 +145,7 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 {
-	struct mlx5e_resources *res = &mdev->mlx5e_res;
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 
 	mlx5_free_bfreg(mdev, &res->bfreg);
 	mlx5_core_destroy_mkey(mdev, &res->mkey);
@@ -180,8 +183,8 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 
 	MLX5_SET(modify_tir_in, in, bitmask.self_lb_en, 1);
 
-	mutex_lock(&mdev->mlx5e_res.td.list_lock);
-	list_for_each_entry(tir, &mdev->mlx5e_res.td.tirs_list, list) {
+	mutex_lock(&mdev->mlx5e_res.hw_objs.td.list_lock);
+	list_for_each_entry(tir, &mdev->mlx5e_res.hw_objs.td.tirs_list, list) {
 		tirn = tir->tirn;
 		err = mlx5_core_modify_tir(mdev, tirn, in);
 		if (err)
@@ -192,7 +195,7 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 	kvfree(in);
 	if (err)
 		netdev_err(priv->netdev, "refresh tir(0x%x) failed, %d\n", tirn, err);
-	mutex_unlock(&mdev->mlx5e_res.td.list_lock);
+	mutex_unlock(&mdev->mlx5e_res.hw_objs.td.list_lock);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e8434dcc1df..2f961bd9e528 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -302,7 +302,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
 	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.pdn);
+	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 MLX5_MTT_OCTW(npages));
@@ -1019,7 +1019,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->pdev      = c->pdev;
 	sq->mkey_be   = c->mkey_be;
 	sq->channel   = c;
-	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
+	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	sq->xsk_pool  = xsk_pool;
@@ -1090,7 +1090,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	int err;
 
 	sq->channel   = c;
-	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
+	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1174,7 +1174,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->priv      = c->priv;
 	sq->ch_ix     = c->ix;
 	sq->txq_ix    = txq_ix;
-	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
+	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
@@ -1257,7 +1257,7 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 	MLX5_SET(sqc,  sqc, flush_in_error_en, 1);
 
 	MLX5_SET(wq,   wq, wq_type,       MLX5_WQ_TYPE_CYCLIC);
-	MLX5_SET(wq,   wq, uar_page,      mdev->mlx5e_res.bfreg.index);
+	MLX5_SET(wq,   wq, uar_page,      mdev->mlx5e_res.hw_objs.bfreg.index);
 	MLX5_SET(wq,   wq, log_wq_pg_sz,  csp->wq_ctrl->buf.page_shift -
 					  MLX5_ADAPTER_PAGE_SHIFT);
 	MLX5_SET64(wq, wq, dbr_addr,      csp->wq_ctrl->db.dma);
@@ -2032,7 +2032,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->cpu      = cpu;
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
 	c->num_tc   = params->num_tc;
 	c->xdp      = !!params->xdp_prog;
 	c->stats    = &priv->channel_stats[ix].ch;
@@ -2217,7 +2217,7 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
 	MLX5_SET(wq, wq, log_wq_stride,
 		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
-	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.pdn);
+	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET(rqc, rqc, counter_set_id, priv->q_counter);
 	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
@@ -2248,7 +2248,7 @@ void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
 	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
-	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.pdn);
+	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.hw_objs.pdn);
 
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
 }
@@ -3421,10 +3421,10 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 {
 	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
-	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
 
 	if (MLX5_GET(tisc, tisc, tls_en))
-		MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.pdn);
+		MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.hw_objs.pdn);
 
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
@@ -3494,7 +3494,7 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 static void mlx5e_build_indir_tir_ctx_common(struct mlx5e_priv *priv,
 					     u32 rqtn, u32 *tirc)
 {
-	MLX5_SET(tirc, tirc, transport_domain, priv->mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tirc, tirc, transport_domain, priv->mdev->mlx5e_res.hw_objs.td.tdn);
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
 	MLX5_SET(tirc, tirc, indirect_table, rqtn);
 	MLX5_SET(tirc, tirc, tunneled_offload_en,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1eeca45cfcdf..0fc055cdf221 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -708,7 +708,7 @@ static void mlx5_rdma_netdev_free(struct net_device *netdev)
 
 static bool mlx5_is_sub_interface(struct mlx5_core_dev *mdev)
 {
-	return mdev->mlx5e_res.pdn != 0;
+	return mdev->mlx5e_res.hw_objs.pdn != 0;
 }
 
 static const struct mlx5e_profile *mlx5_get_profile(struct mlx5_core_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 57eb91bcbca7..e995f8378df7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -46,7 +46,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
-	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.pdn);
+	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.hw_objs.pdn);
 
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 53b89631a1d9..9887181dea5f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -644,10 +644,12 @@ struct mlx5_td {
 };
 
 struct mlx5e_resources {
-	u32                        pdn;
-	struct mlx5_td             td;
-	struct mlx5_core_mkey      mkey;
-	struct mlx5_sq_bfreg       bfreg;
+	struct mlx5e_hw_objs {
+		u32                        pdn;
+		struct mlx5_td             td;
+		struct mlx5_core_mkey      mkey;
+		struct mlx5_sq_bfreg       bfreg;
+	} hw_objs;
 };
 
 enum mlx5_sw_icm_type {
-- 
2.30.2

