Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF647CBA2
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbhLVDQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242110AbhLVDQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DABC061748
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 19:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76A046185F
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718AFC36AE9;
        Wed, 22 Dec 2021 03:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142977;
        bh=zraTOYqjEZNYfRRwIbFk1NjQ3hWaVcsjucaVX7dH7yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTBdIsXw8L5vp/VZ3vIk21GCGxmCNnWsN4T+g1cD2JZDiOiDxJP4Ova+37vspeN3d
         wwI3T2qChqPQodrU/mcxyX4dykVINn4gX6ZXEpsiGOnPl4TnBzDns7JAY3v43BcczW
         jCuWXprSbP7J3UgYhvBrX4wuuFQAn5rlgCxB5UzycyreAj2RI9wb5MI0w5/iDcfQEO
         QspqM5O3gx8fMD+PBXhxvjTBCukSxZRjn6T+X4cnfYLYplAphtpWHBhk6Kg6FEesSi
         Ujn4WJBIlCDIj1NyGuDg4wEJTLh2NgxZHBgspqmgfZy5tPfAgP9/gt/Nn2ax4l9uYl
         LAwr9JBqsOXyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 12/14] net/mlx5e: Use dynamic per-channel allocations in stats
Date:   Tue, 21 Dec 2021 19:16:02 -0800
Message-Id: <20211222031604.14540-13-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Make stats array an array of pointer. This patch comes in to prepare for
the next patch where allocations of the stats are to be performed
dynamically on first usage.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../mellanox/mlx5/core/en/hv_vhca_stats.c     |  2 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 16 +++++------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 9 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c2812513434a..33679467c63a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -906,7 +906,7 @@ struct mlx5e_priv {
 	struct net_device         *netdev;
 	struct mlx5e_trap         *en_trap;
 	struct mlx5e_stats         stats;
-	struct mlx5e_channel_stats *channel_stats;
+	struct mlx5e_channel_stats **channel_stats;
 	struct mlx5e_channel_stats trap_stats;
 	struct mlx5e_ptp_stats     ptp_stats;
 	u16                        stats_nch;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index d290d7276b8d..074ffa4fa5af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -20,7 +20,7 @@ mlx5e_hv_vhca_fill_ring_stats(struct mlx5e_priv *priv, int ch,
 	struct mlx5e_channel_stats *stats;
 	int tc;
 
-	stats = &priv->channel_stats[ch];
+	stats = priv->channel_stats[ch];
 	data->rx_packets = stats->rq.packets;
 	data->rx_bytes   = stats->rq.bytes;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 538bc2419bd8..5f2b67b9c189 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -67,7 +67,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
 	rq->xsk_pool     = pool;
-	rq->stats        = &c->priv->channel_stats[c->ix].xskrq;
+	rq->stats        = &c->priv->channel_stats[c->ix]->xskrq;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
 	rq_xdp_ix        = c->ix + params->num_channels * MLX5E_RQ_GROUP_XSK;
 	err = mlx5e_rq_set_handlers(rq, params, xsk);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 15711814d2d2..96064a2033f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -611,7 +611,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
 
-	priv_rx->rq_stats = &priv->channel_stats[rxq].rq;
+	priv_rx->rq_stats = &priv->channel_stats[rxq]->rq;
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index fe5d82fa6e92..49cca6bd49a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -556,7 +556,7 @@ static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		priv->channel_stats[arfs_rule->rxq].rq.arfs_err++;
+		priv->channel_stats[arfs_rule->rxq]->rq.arfs_err++;
 		mlx5e_dbg(HW, priv,
 			  "%s: add rule(filter id=%d, rq idx=%d, ip proto=0x%x) failed,err=%d\n",
 			  __func__, arfs_rule->filter_id, arfs_rule->rxq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e4a79ba031e9..504844097d20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -479,7 +479,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
-	rq->stats        = &c->priv->channel_stats[c->ix].rq;
+	rq->stats        = &c->priv->channel_stats[c->ix]->rq;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
 	err = mlx5e_rq_set_handlers(rq, params, NULL);
 	if (err)
@@ -1161,10 +1161,10 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-		&c->priv->channel_stats[c->ix].xsksq :
+		&c->priv->channel_stats[c->ix]->xsksq :
 		is_redirect ?
-			&c->priv->channel_stats[c->ix].xdpsq :
-			&c->priv->channel_stats[c->ix].rq_xdpsq;
+			&c->priv->channel_stats[c->ix]->xdpsq :
+			&c->priv->channel_stats[c->ix]->rq_xdpsq;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1928,7 +1928,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
 				       params, &cparam->txq_sq, &c->sq[tc], tc,
 				       qos_queue_group_id,
-				       &c->priv->channel_stats[c->ix].sq[tc]);
+				       &c->priv->channel_stats[c->ix]->sq[tc]);
 		if (err)
 			goto err_close_sqs;
 	}
@@ -2207,7 +2207,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey);
 	c->num_tc   = mlx5e_get_dcb_num_tc(params);
 	c->xdp      = !!params->xdp_prog;
-	c->stats    = &priv->channel_stats[ix].ch;
+	c->stats    = &priv->channel_stats[ix]->ch;
 	c->aff_mask = irq_get_effective_affinity_mask(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
@@ -3371,7 +3371,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 	int i;
 
 	for (i = 0; i < priv->stats_nch; i++) {
-		struct mlx5e_channel_stats *channel_stats = &priv->channel_stats[i];
+		struct mlx5e_channel_stats *channel_stats = priv->channel_stats[i];
 		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
 		int j;
@@ -5196,8 +5196,20 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (!priv->channel_stats)
 		goto err_free_channel_tc2realtxq;
 
+	for (i = 0; i < priv->stats_nch; i++) {
+		priv->channel_stats[i] = kvzalloc_node(sizeof(**priv->channel_stats),
+						       GFP_KERNEL, node);
+		if (!priv->channel_stats[i])
+			goto err_free_channel_stats;
+	}
+
 	return 0;
 
+err_free_channel_stats:
+	while (--i >= 0)
+		kvfree(priv->channel_stats[i]);
+	kfree(priv->channel_stats);
+	i = nch;
 err_free_channel_tc2realtxq:
 	while (--i >= 0)
 		kfree(priv->channel_tc2realtxq[i]);
@@ -5221,6 +5233,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	if (!priv->mdev)
 		return;
 
+	for (i = 0; i < priv->stats_nch; i++)
+		kvfree(priv->channel_stats[i]);
 	kfree(priv->channel_stats);
 	for (i = 0; i < priv->max_nch; i++)
 		kfree(priv->channel_tc2realtxq[i]);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7e05d7592bce..f09b57c31ed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2189,7 +2189,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	priv = mlx5i_epriv(netdev);
 	tstamp = &priv->tstamp;
-	stats = &priv->channel_stats[rq->ix].rq;
+	stats = rq->stats;
 
 	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
 	g = (flags_rqpn >> 28) & 3;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 3c91a11e27ad..73fcd9fb17dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -463,7 +463,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 
 	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
-			&priv->channel_stats[i];
+			priv->channel_stats[i];
 		int j;
 
 		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &channel_stats->rq);
@@ -2197,21 +2197,21 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channels)
 	for (i = 0; i < max_nch; i++)
 		for (j = 0; j < NUM_CH_STATS; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].ch,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->ch,
 						     ch_stats_desc, j);
 
 	for (i = 0; i < max_nch; i++) {
 		for (j = 0; j < NUM_RQ_STATS; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].rq,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->rq,
 						     rq_stats_desc, j);
 		for (j = 0; j < NUM_XSKRQ_STATS * is_xsk; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xskrq,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->xskrq,
 						     xskrq_stats_desc, j);
 		for (j = 0; j < NUM_RQ_XDPSQ_STATS; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].rq_xdpsq,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->rq_xdpsq,
 						     rq_xdpsq_stats_desc, j);
 	}
 
@@ -2219,17 +2219,17 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channels)
 		for (i = 0; i < max_nch; i++)
 			for (j = 0; j < NUM_SQ_STATS; j++)
 				data[idx++] =
-					MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].sq[tc],
+					MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->sq[tc],
 							     sq_stats_desc, j);
 
 	for (i = 0; i < max_nch; i++) {
 		for (j = 0; j < NUM_XSKSQ_STATS * is_xsk; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xsksq,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->xsksq,
 						     xsksq_stats_desc, j);
 		for (j = 0; j < NUM_XDPSQ_STATS; j++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xdpsq,
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i]->xdpsq,
 						     xdpsq_stats_desc, j);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1b082576a63a..0a99a020a3b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -117,7 +117,7 @@ static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 		struct mlx5e_channel_stats *channel_stats;
 		struct mlx5e_rq_stats *rq_stats;
 
-		channel_stats = &priv->channel_stats[i];
+		channel_stats = priv->channel_stats[i];
 		rq_stats = &channel_stats->rq;
 
 		s.rx_packets += rq_stats->packets;
-- 
2.33.1

