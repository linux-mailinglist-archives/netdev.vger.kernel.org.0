Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F342D335F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgLHUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgLHUPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:08 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 03/15] net/mlx5e: Allow RQ outside of channel context
Date:   Tue,  8 Dec 2020 11:35:43 -0800
Message-Id: <20201208193555.674504-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In order to be able to create an RQ outside of a channel context, remove
rq->channel direct pointer. This requires adding a direct pointer to:
ICOSQ and priv in order to support RQs that are part of mlx5e_channel.
Use channel_stats from the corresponding CQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  9 ++--
 .../ethernet/mellanox/mlx5/core/en/health.h   |  3 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       | 50 ++++++++++---------
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 22 ++++----
 7 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2d149ab48ce1..3dec0731f4da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -595,7 +595,6 @@ struct mlx5e_rq {
 		u8             map_dir;   /* dma map direction */
 	} buff;
 
-	struct mlx5e_channel  *channel;
 	struct device         *pdev;
 	struct net_device     *netdev;
 	struct mlx5e_rq_stats *stats;
@@ -604,6 +603,8 @@ struct mlx5e_rq {
 	struct mlx5e_page_cache page_cache;
 	struct hwtstamp_config *tstamp;
 	struct mlx5_clock      *clock;
+	struct mlx5e_icosq    *icosq;
+	struct mlx5e_priv     *priv;
 
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 	mlx5e_fp_post_rx_wqes  post_wqes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index c62f5e881377..e8fc535e6f91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -205,21 +205,22 @@ int mlx5e_health_recover_channels(struct mlx5e_priv *priv)
 	return err;
 }
 
-int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel)
+int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq_comp *eq,
+				    struct mlx5e_ch_stats *stats)
 {
 	u32 eqe_count;
 
-	netdev_err(channel->netdev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
+	netdev_err(dev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
 		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
 
 	eqe_count = mlx5_eq_poll_irq_disabled(eq);
 	if (!eqe_count)
 		return -EIO;
 
-	netdev_err(channel->netdev, "Recovered %d eqes on EQ 0x%x\n",
+	netdev_err(dev, "Recovered %d eqes on EQ 0x%x\n",
 		   eqe_count, eq->core.eqn);
 
-	channel->stats->eq_rearm++;
+	stats->eq_rearm++;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index b9aadddfd000..48d0232ce654 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -43,7 +43,8 @@ struct mlx5e_err_ctx {
 };
 
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
-int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel);
+int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq_comp *eq,
+				    struct mlx5e_ch_stats *stats);
 int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
 int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 9913647a1faf..0206e033a271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -146,17 +146,16 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
-	struct mlx5e_icosq *icosq;
 	struct mlx5_eq_comp *eq;
 	struct mlx5e_rq *rq;
 	int err;
 
 	rq = ctx;
-	icosq = &rq->channel->icosq;
 	eq = rq->cq.mcq.eq;
-	err = mlx5e_health_channel_eq_recover(eq, rq->channel);
-	if (err)
-		clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+
+	err = mlx5e_health_channel_eq_recover(rq->netdev, eq, rq->cq.ch_stats);
+	if (err && rq->icosq)
+		clear_bit(MLX5E_SQ_STATE_ENABLED, &rq->icosq->state);
 
 	return err;
 }
@@ -233,21 +232,13 @@ static int mlx5e_reporter_icosq_diagnose(struct mlx5e_icosq *icosq, u8 hw_state,
 static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
-	struct mlx5e_priv *priv = rq->channel->priv;
-	struct mlx5e_icosq *icosq;
-	u8 icosq_hw_state;
 	u16 wqe_counter;
 	int wqes_sz;
 	u8 hw_state;
 	u16 wq_head;
 	int err;
 
-	icosq = &rq->channel->icosq;
-	err = mlx5e_query_rq_state(priv->mdev, rq->rqn, &hw_state);
-	if (err)
-		return err;
-
-	err = mlx5_core_query_sq_state(priv->mdev, icosq->sqn, &icosq_hw_state);
+	err = mlx5e_query_rq_state(rq->mdev, rq->rqn, &hw_state);
 	if (err)
 		return err;
 
@@ -259,7 +250,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
-	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->channel->ix);
+	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->ix);
 	if (err)
 		return err;
 
@@ -295,9 +286,18 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_icosq_diagnose(icosq, icosq_hw_state, fmsg);
-	if (err)
-		return err;
+	if (rq->icosq) {
+		struct mlx5e_icosq *icosq = rq->icosq;
+		u8 icosq_hw_state;
+
+		err = mlx5_core_query_sq_state(rq->mdev, icosq->sqn, &icosq_hw_state);
+		if (err)
+			return err;
+
+		err = mlx5e_reporter_icosq_diagnose(icosq, icosq_hw_state, fmsg);
+		if (err)
+			return err;
+	}
 
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
@@ -557,25 +557,29 @@ static int mlx5e_rx_reporter_dump(struct devlink_health_reporter *reporter,
 
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 {
-	struct mlx5e_icosq *icosq = &rq->channel->icosq;
-	struct mlx5e_priv *priv = rq->channel->priv;
+	char icosq_str[MLX5E_REPORTER_PER_Q_MAX_LEN] = {};
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_icosq *icosq = rq->icosq;
+	struct mlx5e_priv *priv = rq->priv;
 	struct mlx5e_err_ctx err_ctx = {};
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
 	err_ctx.dump = mlx5e_rx_reporter_dump_rq;
+
+	if (icosq)
+		snprintf(icosq_str, sizeof(icosq_str), "ICOSQ: 0x%x, ", icosq->sqn);
 	snprintf(err_str, sizeof(err_str),
-		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
-		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+		 "RX timeout on channel: %d, %sRQ: 0x%x, CQ: 0x%x",
+		 rq->ix, icosq_str, rq->rqn, rq->cq.mcq.cqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
 
 void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 {
-	struct mlx5e_priv *priv = rq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_priv *priv = rq->priv;
 	struct mlx5e_err_ctx err_ctx = {};
 
 	err_ctx.ctx = rq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 8be6eaa3eeb1..97bfeae17dec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -100,7 +100,7 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	sq = to_ctx->sq;
 	eq = sq->cq.mcq.eq;
 	priv = sq->channel->priv;
-	err = mlx5e_health_channel_eq_recover(eq, sq->channel);
+	err = mlx5e_health_channel_eq_recover(sq->channel->netdev, eq, sq->channel->stats);
 	if (!err) {
 		to_ctx->status = 0; /* this sq recovered */
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fe3d3ff22d0a..68c1497d9506 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -412,9 +412,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->wq_type = params->rq_wq_type;
 	rq->pdev    = c->pdev;
 	rq->netdev  = c->netdev;
+	rq->priv    = c->priv;
 	rq->tstamp  = c->tstamp;
 	rq->clock   = &mdev->clock;
-	rq->channel = c;
+	rq->icosq   = &c->icosq;
 	rq->ix      = c->ix;
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
@@ -617,7 +618,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	int i;
 
 	old_prog = rcu_dereference_protected(rq->xdp_prog,
-					     lockdep_is_held(&rq->channel->priv->state_lock));
+					     lockdep_is_held(&rq->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -717,9 +718,7 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 
 static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 {
-	struct mlx5e_channel *c = rq->channel;
-	struct mlx5e_priv *priv = c->priv;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_core_dev *mdev = rq->mdev;
 
 	void *in;
 	void *rqc;
@@ -748,8 +747,7 @@ static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
-	struct mlx5e_channel *c = rq->channel;
-	struct mlx5_core_dev *mdev = c->mdev;
+	struct mlx5_core_dev *mdev = rq->mdev;
 	void *in;
 	void *rqc;
 	int inlen;
@@ -783,7 +781,6 @@ static void mlx5e_destroy_rq(struct mlx5e_rq *rq)
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 {
 	unsigned long exp_time = jiffies + msecs_to_jiffies(wait_time);
-	struct mlx5e_channel *c = rq->channel;
 
 	u16 min_wqes = mlx5_min_rx_wqes(rq->wq_type, mlx5e_rqwq_get_size(rq));
 
@@ -794,8 +791,8 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 		msleep(20);
 	} while (time_before(jiffies, exp_time));
 
-	netdev_warn(c->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x] wq cur_sz(%d) min_rx_wqes(%d)\n",
-		    c->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
+	netdev_warn(rq->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x] wq cur_sz(%d) min_rx_wqes(%d)\n",
+		    rq->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
 
 	mlx5e_reporter_rx_timeout(rq);
 	return -ETIMEDOUT;
@@ -910,7 +907,7 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	mlx5e_trigger_irq(&rq->channel->icosq);
+	mlx5e_trigger_irq(rq->icosq);
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
@@ -922,7 +919,7 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
-	cancel_work_sync(&rq->channel->icosq.recover_work);
+	cancel_work_sync(&rq->icosq->recover_work);
 	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
@@ -4411,7 +4408,7 @@ static void mlx5e_rq_replace_xdp_prog(struct mlx5e_rq *rq, struct bpf_prog *prog
 	struct bpf_prog *old_prog;
 
 	old_prog = rcu_replace_pointer(rq->xdp_prog, prog,
-				       lockdep_is_held(&rq->channel->priv->state_lock));
+				       lockdep_is_held(&rq->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 08163dca15a0..5c0015024f62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -503,7 +503,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[ix];
 	struct mlx5e_dma_info *dma_info = &wi->umr.dma_info[0];
-	struct mlx5e_icosq *sq = &rq->channel->icosq;
+	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
 	u16 xlt_offset = ix << (MLX5E_LOG_ALIGNED_MPWQE_PPW - 1);
@@ -713,9 +713,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 {
-	struct mlx5e_icosq *sq = &rq->channel->icosq;
 	struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
 	u8  umr_completed = rq->mpwqe.umr_completed;
+	struct mlx5e_icosq *sq = rq->icosq;
 	int alloc_err = 0;
 	u8  missing, i;
 	u16 head;
@@ -1218,11 +1218,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_err_cqe *err_cqe = (struct mlx5_err_cqe *)cqe;
+	struct mlx5e_priv *priv = rq->priv;
 
 	if (cqe_syndrome_needs_recover(err_cqe->syndrome) &&
 	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state)) {
 		mlx5e_dump_error_cqe(&rq->cq, rq->rqn, err_cqe);
-		queue_work(rq->channel->priv->wq, &rq->recover_work);
+		queue_work(priv->wq, &rq->recover_work);
 	}
 }
 
@@ -1771,8 +1772,9 @@ static void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 
 int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool xsk)
 {
+	struct net_device *netdev = rq->netdev;
 	struct mlx5_core_dev *mdev = rq->mdev;
-	struct mlx5e_channel *c = rq->channel;
+	struct mlx5e_priv *priv = rq->priv;
 
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
@@ -1784,15 +1786,15 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 		rq->post_wqes = mlx5e_post_rx_mpwqes;
 		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
 
-		rq->handle_rx_cqe = c->priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
+		rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
 #ifdef CONFIG_MLX5_EN_IPSEC
 		if (MLX5_IPSEC_DEV(mdev)) {
-			netdev_err(c->netdev, "MPWQE RQ with IPSec offload not supported\n");
+			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
 			return -EINVAL;
 		}
 #endif
 		if (!rq->handle_rx_cqe) {
-			netdev_err(c->netdev, "RX handler of MPWQE RQ is not set\n");
+			netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
 			return -EINVAL;
 		}
 		break;
@@ -1807,13 +1809,13 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 		if ((mlx5_fpga_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_DEVICE) &&
-		    c->priv->ipsec)
+		    priv->ipsec)
 			rq->handle_rx_cqe = mlx5e_ipsec_handle_rx_cqe;
 		else
 #endif
-			rq->handle_rx_cqe = c->priv->profile->rx_handlers->handle_rx_cqe;
+			rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe;
 		if (!rq->handle_rx_cqe) {
-			netdev_err(c->netdev, "RX handler of RQ is not set\n");
+			netdev_err(netdev, "RX handler of RQ is not set\n");
 			return -EINVAL;
 		}
 	}
-- 
2.26.2

