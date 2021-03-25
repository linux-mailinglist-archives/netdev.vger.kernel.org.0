Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1E534882F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCYFFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhCYFEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54BB61A21;
        Thu, 25 Mar 2021 05:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648688;
        bh=z0Q9uOnnazOQvnB7ypA18K3SDXkXpOw5XllPE0KEY+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2fjKCkcg3+Hnb1T5x5Ivec6hGPyepRcX4axIswnKiZ6Mf6peiYnb/cnPPopFbTCZ
         /jsqZ3y5Qgr9PR4xmzJBOhR6LJ1yyBe9R5C1ELqybG0j0EdVNoRIGMO9znRp9mv7j7
         t28vaxYo+YiXd9QrXPlCuP757s4snZaDhrOwo98FNfAGEVqxFWlEYbKjVR4DO8aJly
         LfFgJkG0SpiOmnLSIkPmW45jyg4cAlVCtXLSsLiW1yu+eM87eanYrbqO8Oou4MJOdC
         QuxB8209dUKQat4RslAhjXL+9tmUfYLe6jdIuJTDkK86r3E3aCtnUpW9LX5UjOrIVk
         8TeGkpCcpwV0A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Generalize open RQ
Date:   Wed, 24 Mar 2021 22:04:32 -0700
Message-Id: <20210325050438.261511-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Unify RQ creation for different RQ types. For each RQ type add a
separate open helper which initializes the RQ specific values and
trigger a call for generic open RQ function. Avoid passing the
mlx5e_channel pointer to the generic open RQ as a container, since the
RQ may reside under a different type of channel.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c | 170 ++++--------------
 .../mellanox/mlx5/core/en/xsk/setup.c         |  47 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 126 ++++++-------
 4 files changed, 147 insertions(+), 202 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e286a6073db3..3051b653bef7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -960,9 +960,9 @@ struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types
 struct mlx5e_xsk_param;
 
 struct mlx5e_rq_param;
-int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq);
+int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
+		  struct mlx5e_xsk_param *xsk, int node,
+		  struct mlx5e_rq *rq);
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index ba36657cd297..987035346cfc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -30,163 +30,63 @@ static int mlx5e_trap_napi_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static int mlx5e_alloc_trap_rq(struct mlx5e_priv *priv, struct mlx5e_rq_param *rqp,
-			       struct mlx5e_rq_stats *stats, struct mlx5e_params *params,
-			       struct mlx5e_ch_stats *ch_stats,
-			       struct mlx5e_rq *rq)
+static void mlx5e_free_trap_rq(struct mlx5e_rq *rq)
 {
-	void *rqc_wq = MLX5_ADDR_OF(rqc, rqp->rqc, wq);
-	struct mlx5_core_dev *mdev = priv->mdev;
-	struct page_pool_params pp_params = {};
-	int node = dev_to_node(mdev->device);
-	u32 pool_size;
-	int wq_sz;
-	int err;
-	int i;
-
-	rqp->wq.db_numa_node = node;
-
-	rq->wq_type  = params->rq_wq_type;
-	rq->pdev     = mdev->device;
-	rq->netdev   = priv->netdev;
-	rq->mdev     = mdev;
-	rq->priv     = priv;
-	rq->stats    = stats;
-	rq->clock    = &mdev->clock;
-	rq->tstamp   = &priv->tstamp;
-	rq->hw_mtu   = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-
-	xdp_rxq_info_unused(&rq->xdp_rxq);
-
-	rq->buff.map_dir = DMA_FROM_DEVICE;
-	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, NULL);
-	pool_size = 1 << params->log_rq_mtu_frames;
-
-	err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq, &rq->wq_ctrl);
-	if (err)
-		return err;
-
-	rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
-
-	wq_sz = mlx5_wq_cyc_get_size(&rq->wqe.wq);
-
-	rq->wqe.info = rqp->frags_info;
-	rq->buff.frame0_sz = rq->wqe.info.arr[0].frag_stride;
-	rq->wqe.frags =	kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
-						 (wq_sz << rq->wqe.info.log_num_frags)),
-				      GFP_KERNEL, node);
-	if (!rq->wqe.frags) {
-		err = -ENOMEM;
-		goto err_wq_cyc_destroy;
-	}
-
-	err = mlx5e_init_di_list(rq, wq_sz, node);
-	if (err)
-		goto err_free_frags;
-
-	rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey.key);
-
-	mlx5e_rq_set_trap_handlers(rq, params);
-
-	/* Create a page_pool and register it with rxq */
-	pp_params.order     = 0;
-	pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
-	pp_params.pool_size = pool_size;
-	pp_params.nid       = node;
-	pp_params.dev       = mdev->device;
-	pp_params.dma_dir   = rq->buff.map_dir;
-
-	/* page_pool can be used even when there is no rq->xdp_prog,
-	 * given page_pool does not handle DMA mapping there is no
-	 * required state to clear. And page_pool gracefully handle
-	 * elevated refcnt.
-	 */
-	rq->page_pool = page_pool_create(&pp_params);
-	if (IS_ERR(rq->page_pool)) {
-		err = PTR_ERR(rq->page_pool);
-		rq->page_pool = NULL;
-		goto err_free_di_list;
-	}
-	for (i = 0; i < wq_sz; i++) {
-		struct mlx5e_rx_wqe_cyc *wqe =
-			mlx5_wq_cyc_get_wqe(&rq->wqe.wq, i);
-		int f;
-
-		for (f = 0; f < rq->wqe.info.num_frags; f++) {
-			u32 frag_size = rq->wqe.info.arr[f].frag_size |
-				MLX5_HW_START_PADDING;
-
-			wqe->data[f].byte_count = cpu_to_be32(frag_size);
-			wqe->data[f].lkey = rq->mkey_be;
-		}
-		/* check if num_frags is not a pow of two */
-		if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
-			wqe->data[f].byte_count = 0;
-			wqe->data[f].lkey = cpu_to_be32(MLX5_INVALID_LKEY);
-			wqe->data[f].addr = 0;
-		}
-	}
-	return 0;
-
-err_free_di_list:
+	page_pool_destroy(rq->page_pool);
 	mlx5e_free_di_list(rq);
-err_free_frags:
 	kvfree(rq->wqe.frags);
-err_wq_cyc_destroy:
 	mlx5_wq_destroy(&rq->wq_ctrl);
-
-	return err;
 }
 
-static void mlx5e_free_trap_rq(struct mlx5e_rq *rq)
+static void mlx5e_init_trap_rq(struct mlx5e_trap *t, struct mlx5e_params *params,
+			       struct mlx5e_rq *rq)
 {
-	page_pool_destroy(rq->page_pool);
-	mlx5e_free_di_list(rq);
-	kvfree(rq->wqe.frags);
-	mlx5_wq_destroy(&rq->wq_ctrl);
+	struct mlx5_core_dev *mdev = t->mdev;
+	struct mlx5e_priv *priv = t->priv;
+
+	rq->wq_type      = params->rq_wq_type;
+	rq->pdev         = mdev->device;
+	rq->netdev       = priv->netdev;
+	rq->priv         = priv;
+	rq->clock        = &mdev->clock;
+	rq->tstamp       = &priv->tstamp;
+	rq->mdev         = mdev;
+	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->stats        = &priv->trap_stats.rq;
+	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
+	xdp_rxq_info_unused(&rq->xdp_rxq);
+	mlx5e_rq_set_trap_handlers(rq, params);
 }
 
-static int mlx5e_open_trap_rq(struct mlx5e_priv *priv, struct napi_struct *napi,
-			      struct mlx5e_rq_stats *stats, struct mlx5e_params *params,
-			      struct mlx5e_rq_param *rq_param,
-			      struct mlx5e_ch_stats *ch_stats,
-			      struct mlx5e_rq *rq)
+static int mlx5e_open_trap_rq(struct mlx5e_priv *priv, struct mlx5e_trap *t)
 {
+	struct mlx5e_rq_param *rq_param = &t->rq_param;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_create_cq_param ccp = {};
 	struct dim_cq_moder trap_moder = {};
-	struct mlx5e_cq *cq = &rq->cq;
+	struct mlx5e_rq *rq = &t->rq;
+	int node;
 	int err;
 
-	ccp.node     = dev_to_node(mdev->device);
-	ccp.ch_stats = ch_stats;
-	ccp.napi     = napi;
+	node = dev_to_node(mdev->device);
+
+	ccp.node     = node;
+	ccp.ch_stats = t->stats;
+	ccp.napi     = &t->napi;
 	ccp.ix       = 0;
-	err = mlx5e_open_cq(priv, trap_moder, &rq_param->cqp, &ccp, cq);
+	err = mlx5e_open_cq(priv, trap_moder, &rq_param->cqp, &ccp, &rq->cq);
 	if (err)
 		return err;
 
-	err = mlx5e_alloc_trap_rq(priv, rq_param, stats, params, ch_stats, rq);
+	mlx5e_init_trap_rq(t, &t->params, rq);
+	err = mlx5e_open_rq(&t->params, rq_param, NULL, node, rq);
 	if (err)
 		goto err_destroy_cq;
 
-	err = mlx5e_create_rq(rq, rq_param);
-	if (err)
-		goto err_free_rq;
-
-	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
-	if (err)
-		goto err_destroy_rq;
-
 	return 0;
 
-err_destroy_rq:
-	mlx5e_destroy_rq(rq);
-	mlx5e_free_rx_descs(rq);
-err_free_rq:
-	mlx5e_free_trap_rq(rq);
 err_destroy_cq:
-	mlx5e_close_cq(cq);
+	mlx5e_close_cq(&rq->cq);
 
 	return err;
 }
@@ -273,11 +173,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 
 	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll, 64);
 
-	err = mlx5e_open_trap_rq(priv, &t->napi,
-				 &priv->trap_stats.rq,
-				 &t->params, &t->rq_param,
-				 &priv->trap_stats.ch,
-				 &t->rq);
+	err = mlx5e_open_trap_rq(priv, t);
 	if (unlikely(err))
 		goto err_napi_del;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 313a708e351b..a8315f166696 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -45,6 +45,51 @@ static void mlx5e_build_xsk_cparam(struct mlx5_core_dev *mdev,
 	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
 }
 
+static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
+			     struct mlx5e_params *params,
+			     struct xsk_buff_pool *pool,
+			     struct mlx5e_xsk_param *xsk,
+			     struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev = c->mdev;
+	int rq_xdp_ix;
+	int err;
+
+	rq->wq_type      = params->rq_wq_type;
+	rq->pdev         = c->pdev;
+	rq->netdev       = c->netdev;
+	rq->priv         = c->priv;
+	rq->tstamp       = c->tstamp;
+	rq->clock        = &mdev->clock;
+	rq->icosq        = &c->icosq;
+	rq->ix           = c->ix;
+	rq->mdev         = mdev;
+	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->xdpsq        = &c->rq_xdpsq;
+	rq->xsk_pool     = pool;
+	rq->stats        = &c->priv->channel_stats[c->ix].xskrq;
+	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
+	rq_xdp_ix        = c->ix + params->num_channels * MLX5E_RQ_GROUP_XSK;
+	err = mlx5e_rq_set_handlers(rq, params, xsk);
+	if (err)
+		return err;
+
+	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+}
+
+static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
+			     struct mlx5e_rq_param *rq_params, struct xsk_buff_pool *pool,
+			     struct mlx5e_xsk_param *xsk)
+{
+	int err;
+
+	err = mlx5e_init_xsk_rq(c, params, pool, xsk, &c->xskrq);
+	if (err)
+		return err;
+
+	return mlx5e_open_rq(params, rq_params, xsk, cpu_to_node(c->cpu), &c->xskrq);
+}
+
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
@@ -69,7 +114,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_free_cparam;
 
-	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, pool, &c->xskrq);
+	err = mlx5e_open_xsk_rq(c, params, &cparam->rq, pool, xsk);
 	if (unlikely(err))
 		goto err_close_rx_cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72aef60c4efc..638449f2d7ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -373,56 +373,53 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 	 __free_page(rq->wqe_overflow.page);
 }
 
-static int mlx5e_alloc_rq(struct mlx5e_channel *c,
-			  struct mlx5e_params *params,
+static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
+			     struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev = c->mdev;
+	int err;
+
+	rq->wq_type      = params->rq_wq_type;
+	rq->pdev         = c->pdev;
+	rq->netdev       = c->netdev;
+	rq->priv         = c->priv;
+	rq->tstamp       = c->tstamp;
+	rq->clock        = &mdev->clock;
+	rq->icosq        = &c->icosq;
+	rq->ix           = c->ix;
+	rq->mdev         = mdev;
+	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->xdpsq        = &c->rq_xdpsq;
+	rq->stats        = &c->priv->channel_stats[c->ix].rq;
+	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
+	err = mlx5e_rq_set_handlers(rq, params, NULL);
+	if (err)
+		return err;
+
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, 0);
+}
+
+static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
-			  struct xsk_buff_pool *xsk_pool,
 			  struct mlx5e_rq_param *rqp,
-			  struct mlx5e_rq *rq)
+			  int node, struct mlx5e_rq *rq)
 {
 	struct page_pool_params pp_params = { 0 };
-	struct mlx5_core_dev *mdev = c->mdev;
+	struct mlx5_core_dev *mdev = rq->mdev;
 	void *rqc = rqp->rqc;
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
-	u32 rq_xdp_ix;
 	u32 pool_size;
 	int wq_sz;
 	int err;
 	int i;
 
-	rqp->wq.db_numa_node = cpu_to_node(c->cpu);
-
-	rq->wq_type = params->rq_wq_type;
-	rq->pdev    = c->pdev;
-	rq->netdev  = c->netdev;
-	rq->priv    = c->priv;
-	rq->tstamp  = c->tstamp;
-	rq->clock   = &mdev->clock;
-	rq->icosq   = &c->icosq;
-	rq->ix      = c->ix;
-	rq->mdev    = mdev;
-	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	rq->xdpsq   = &c->rq_xdpsq;
-	rq->xsk_pool = xsk_pool;
-	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
-
-	if (rq->xsk_pool)
-		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
-	else
-		rq->stats = &c->priv->channel_stats[c->ix].rq;
+	rqp->wq.db_numa_node = node;
 	INIT_WORK(&rq->recover_work, mlx5e_rq_err_cqe_work);
 
 	if (params->xdp_prog)
 		bpf_prog_inc(params->xdp_prog);
 	RCU_INIT_POINTER(rq->xdp_prog, params->xdp_prog);
 
-	rq_xdp_ix = rq->ix;
-	if (xsk)
-		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
-	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
-	if (err < 0)
-		goto err_rq_xdp_prog;
-
 	rq->buff.map_dir = params->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
 	pool_size = 1 << params->log_rq_mtu_frames;
@@ -432,7 +429,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
 					&rq->wq_ctrl);
 		if (err)
-			goto err_rq_xdp;
+			goto err_rq_xdp_prog;
 
 		err = mlx5e_alloc_mpwqe_rq_drop_page(rq);
 		if (err)
@@ -456,7 +453,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_rq_drop_page;
 		rq->mkey_be = cpu_to_be32(rq->umr_mkey.key);
 
-		err = mlx5e_rq_alloc_mpwqe_info(rq, cpu_to_node(c->cpu));
+		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
 		if (err)
 			goto err_rq_mkey;
 		break;
@@ -464,7 +461,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq,
 					 &rq->wq_ctrl);
 		if (err)
-			goto err_rq_xdp;
+			goto err_rq_xdp_prog;
 
 		rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
 
@@ -476,23 +473,19 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->wqe.frags =
 			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
 					(wq_sz << rq->wqe.info.log_num_frags)),
-				      GFP_KERNEL, cpu_to_node(c->cpu));
+				      GFP_KERNEL, node);
 		if (!rq->wqe.frags) {
 			err = -ENOMEM;
 			goto err_rq_wq_destroy;
 		}
 
-		err = mlx5e_init_di_list(rq, wq_sz, cpu_to_node(c->cpu));
+		err = mlx5e_init_di_list(rq, wq_sz, node);
 		if (err)
 			goto err_rq_frags;
 
-		rq->mkey_be = c->mkey_be;
+		rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey.key);
 	}
 
-	err = mlx5e_rq_set_handlers(rq, params, xsk);
-	if (err)
-		goto err_free_by_rq_type;
-
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
@@ -502,8 +495,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		pp_params.order     = 0;
 		pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
 		pp_params.pool_size = pool_size;
-		pp_params.nid       = cpu_to_node(c->cpu);
-		pp_params.dev       = c->pdev;
+		pp_params.nid       = node;
+		pp_params.dev       = rq->pdev;
 		pp_params.dma_dir   = rq->buff.map_dir;
 
 		/* page_pool can be used even when there is no rq->xdp_prog,
@@ -587,8 +580,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 err_rq_wq_destroy:
 	mlx5_wq_destroy(&rq->wq_ctrl);
-err_rq_xdp:
-	xdp_rxq_info_unreg(&rq->xdp_rxq);
 err_rq_xdp_prog:
 	if (params->xdp_prog)
 		bpf_prog_put(params->xdp_prog);
@@ -840,13 +831,14 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 
 }
 
-int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq)
+int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
+		  struct mlx5e_xsk_param *xsk, int node,
+		  struct mlx5e_rq *rq)
 {
+	struct mlx5_core_dev *mdev = rq->mdev;
 	int err;
 
-	err = mlx5e_alloc_rq(c, params, xsk, xsk_pool, param, rq);
+	err = mlx5e_alloc_rq(params, xsk, param, node, rq);
 	if (err)
 		return err;
 
@@ -858,28 +850,28 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	if (err)
 		goto err_destroy_rq;
 
-	if (mlx5e_is_tls_on(c->priv) && !mlx5_accel_is_ktls_device(c->mdev))
-		__set_bit(MLX5E_RQ_STATE_FPGA_TLS, &c->rq.state); /* must be FPGA */
+	if (mlx5e_is_tls_on(rq->priv) && !mlx5_accel_is_ktls_device(mdev))
+		__set_bit(MLX5E_RQ_STATE_FPGA_TLS, &rq->state); /* must be FPGA */
 
-	if (MLX5_CAP_ETH(c->mdev, cqe_checksum_full))
-		__set_bit(MLX5E_RQ_STATE_CSUM_FULL, &c->rq.state);
+	if (MLX5_CAP_ETH(mdev, cqe_checksum_full))
+		__set_bit(MLX5E_RQ_STATE_CSUM_FULL, &rq->state);
 
 	if (params->rx_dim_enabled)
-		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
+		__set_bit(MLX5E_RQ_STATE_AM, &rq->state);
 
 	/* We disable csum_complete when XDP is enabled since
 	 * XDP programs might manipulate packets which will render
 	 * skb->checksum incorrect.
 	 */
-	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE) || c->xdp)
-		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE) || params->xdp_prog)
+		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state);
 
 	/* For CQE compression on striding RQ, use stride index provided by
 	 * HW if capability is supported.
 	 */
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) &&
-	    MLX5_CAP_GEN(c->mdev, mini_cqe_resp_stride_index))
-		__set_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &c->rq.state);
+	    MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index))
+		__set_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &rq->state);
 
 	return 0;
 
@@ -1810,6 +1802,18 @@ static int mlx5e_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 	return err;
 }
 
+static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
+			     struct mlx5e_rq_param *rq_params)
+{
+	int err;
+
+	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	if (err)
+		return err;
+
+	return mlx5e_open_rq(params, rq_params, NULL, cpu_to_node(c->cpu), &c->rq);
+}
+
 static int mlx5e_open_queues(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
@@ -1870,7 +1874,7 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 			goto err_close_sqs;
 	}
 
-	err = mlx5e_open_rq(c, params, &cparam->rq, NULL, NULL, &c->rq);
+	err = mlx5e_open_rxq_rq(c, params, &cparam->rq);
 	if (err)
 		goto err_close_xdp_sq;
 
-- 
2.30.2

