Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A549456C2A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfFZOg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:29 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59944 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727437AbfFZOgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:23 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY9027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 11/16] net/mlx5e: Share the XDP SQ for XDP_TX between RQs
Date:   Wed, 26 Jun 2019 17:35:33 +0300
Message-Id: <1561559738-4213-12-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Put the XDP SQ that is used for XDP_TX into the channel. It used to be a
part of the RQ, but with introduction of AF_XDP there will be one more
RQ that could share the same XDP SQ. This patch is a preparation for
that change.

Separate XDP_TX statistics per RQ were implemented in one of the previous
patches.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  | 20 ++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 26 +++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |  4 ++--
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b3c2d7ef1287..010140753e73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -432,6 +432,7 @@ struct mlx5e_xdp_info {
 			dma_addr_t dma_addr;
 		} frame;
 		struct {
+			struct mlx5e_rq *rq;
 			struct mlx5e_dma_info di;
 		} page;
 	};
@@ -644,7 +645,7 @@ struct mlx5e_rq {
 
 	/* XDP */
 	struct bpf_prog       *xdp_prog;
-	struct mlx5e_xdpsq     xdpsq;
+	struct mlx5e_xdpsq    *xdpsq;
 	DECLARE_BITMAP(flags, 8);
 	struct page_pool      *page_pool;
 
@@ -663,6 +664,7 @@ struct mlx5e_rq {
 struct mlx5e_channel {
 	/* data path */
 	struct mlx5e_rq            rq;
+	struct mlx5e_xdpsq         rq_xdpsq;
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
 	bool                       xdp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 89f6eb1109cf..b3e118fc4521 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -54,8 +54,8 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
 }
 
 static inline bool
-mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_dma_info *di,
-		    struct xdp_buff *xdp)
+mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
+		    struct mlx5e_dma_info *di, struct xdp_buff *xdp)
 {
 	struct mlx5e_xdp_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
@@ -75,6 +75,7 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
 	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
 
 	xdptxd.dma_addr = dma_addr;
+	xdpi.page.rq = rq;
 	xdpi.page.di = *di;
 
 	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi);
@@ -105,7 +106,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		*len = xdp.data_end - xdp.data;
 		return false;
 	case XDP_TX:
-		if (unlikely(!mlx5e_xmit_xdp_buff(&rq->xdpsq, di, &xdp)))
+		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, di, &xdp)))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 		return true;
@@ -287,7 +288,6 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 
 static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  struct mlx5e_xdp_wqe_info *wi,
-				  struct mlx5e_rq *rq,
 				  bool recycle)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
@@ -305,7 +305,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX */
-			mlx5e_page_release(rq, &xdpi.page.di, recycle);
+			mlx5e_page_release(xdpi.page.rq, &xdpi.page.di, recycle);
 			break;
 		default:
 			WARN_ON_ONCE(true);
@@ -313,7 +313,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 	}
 }
 
-bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
+bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_xdpsq *sq;
 	struct mlx5_cqe64 *cqe;
@@ -358,7 +358,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
 
 			sqcc += wi->num_wqebbs;
 
-			mlx5e_free_xdpsq_desc(sq, wi, rq, true);
+			mlx5e_free_xdpsq_desc(sq, wi, true);
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
@@ -373,7 +373,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
 	return (i == MLX5E_TX_CQ_POLL_BUDGET);
 }
 
-void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq)
+void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 {
 	while (sq->cc != sq->pc) {
 		struct mlx5e_xdp_wqe_info *wi;
@@ -384,7 +384,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq)
 
 		sq->cc += wi->num_wqebbs;
 
-		mlx5e_free_xdpsq_desc(sq, wi, rq, false);
+		mlx5e_free_xdpsq_desc(sq, wi, false);
 	}
 }
 
@@ -450,7 +450,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq)
 {
-	struct mlx5e_xdpsq *xdpsq = &rq->xdpsq;
+	struct mlx5e_xdpsq *xdpsq = rq->xdpsq;
 
 	if (xdpsq->mpwqe.wqe)
 		mlx5e_xdp_mpwqe_complete(xdpsq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 2a5158993349..86db5ad49a42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -42,8 +42,8 @@
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      void *va, u16 *rx_headroom, u32 *len);
-bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq);
-void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq);
+bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
+void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
 void mlx5e_set_xmit_fp(struct mlx5e_xdpsq *sq, bool is_mpw);
 void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 837a973b3507..abc1d0f6cf53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -418,6 +418,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->stats   = &c->priv->channel_stats[c->ix].rq;
+	rq->xdpsq   = &c->rq_xdpsq;
 
 	rq->xdp_prog = params->xdp_prog ? bpf_prog_inc(params->xdp_prog) : NULL;
 	if (IS_ERR(rq->xdp_prog)) {
@@ -1438,7 +1439,7 @@ static int mlx5e_open_xdpsq(struct mlx5e_channel *c,
 	return err;
 }
 
-static void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq)
+static void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
@@ -1446,7 +1447,7 @@ static void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq)
 	napi_synchronize(&c->napi);
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
-	mlx5e_free_xdpsq_descs(sq, rq);
+	mlx5e_free_xdpsq_descs(sq);
 	mlx5e_free_xdpsq(sq);
 }
 
@@ -1825,7 +1826,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 
 	/* XDP SQ CQ params are same as normal TXQ sq CQ params */
 	err = c->xdp ? mlx5e_open_cq(c, params->tx_cq_moderation,
-				     &cparam->tx_cq, &c->rq.xdpsq.cq) : 0;
+				     &cparam->tx_cq, &c->rq_xdpsq.cq) : 0;
 	if (err)
 		goto err_close_rx_cq;
 
@@ -1839,9 +1840,12 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (err)
 		goto err_close_icosq;
 
-	err = c->xdp ? mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, &c->rq.xdpsq, false) : 0;
-	if (err)
-		goto err_close_sqs;
+	if (c->xdp) {
+		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq,
+				       &c->rq_xdpsq, false);
+		if (err)
+			goto err_close_sqs;
+	}
 
 	err = mlx5e_open_rq(c, params, &cparam->rq, &c->rq);
 	if (err)
@@ -1860,7 +1864,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 
 err_close_xdp_sq:
 	if (c->xdp)
-		mlx5e_close_xdpsq(&c->rq.xdpsq, &c->rq);
+		mlx5e_close_xdpsq(&c->rq_xdpsq);
 
 err_close_sqs:
 	mlx5e_close_sqs(c);
@@ -1871,7 +1875,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 err_disable_napi:
 	napi_disable(&c->napi);
 	if (c->xdp)
-		mlx5e_close_cq(&c->rq.xdpsq.cq);
+		mlx5e_close_cq(&c->rq_xdpsq.cq);
 
 err_close_rx_cq:
 	mlx5e_close_cq(&c->rq.cq);
@@ -1916,15 +1920,15 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 
 static void mlx5e_close_channel(struct mlx5e_channel *c)
 {
-	mlx5e_close_xdpsq(&c->xdpsq, NULL);
+	mlx5e_close_xdpsq(&c->xdpsq);
 	mlx5e_close_rq(&c->rq);
 	if (c->xdp)
-		mlx5e_close_xdpsq(&c->rq.xdpsq, &c->rq);
+		mlx5e_close_xdpsq(&c->rq_xdpsq);
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
 	napi_disable(&c->napi);
 	if (c->xdp)
-		mlx5e_close_cq(&c->rq.xdpsq.cq);
+		mlx5e_close_cq(&c->rq_xdpsq.cq);
 	mlx5e_close_cq(&c->rq.cq);
 	mlx5e_close_cq(&c->xdpsq.cq);
 	mlx5e_close_tx_cqs(c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index de4d5ae431af..d2b8ce5df59c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -97,10 +97,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	for (i = 0; i < c->num_tc; i++)
 		busy |= mlx5e_poll_tx_cq(&c->sq[i].cq, budget);
 
-	busy |= mlx5e_poll_xdpsq_cq(&c->xdpsq.cq, NULL);
+	busy |= mlx5e_poll_xdpsq_cq(&c->xdpsq.cq);
 
 	if (c->xdp)
-		busy |= mlx5e_poll_xdpsq_cq(&rq->xdpsq.cq, rq);
+		busy |= mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
 
 	if (likely(budget)) { /* budget=0 means: don't poll rx rings */
 		work_done = mlx5e_poll_rx_cq(&rq->cq, budget);
-- 
1.8.3.1

