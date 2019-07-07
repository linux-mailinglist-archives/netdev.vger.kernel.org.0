Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91694614C2
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfGGLxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58881 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbfGGLx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:29 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:20 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJM2031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 13/16] net/mlx5e: Recover from CQE error on ICOSQ
Date:   Sun,  7 Jul 2019 14:53:05 +0300
Message-Id: <1562500388-16847-14-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for recovery from error on completion on ICOSQ. Deactivate
RQ and flush, then deactivate ICOSQ. Set the queue back to ready state
(firmware) and reset the ICOSQ and the RQ (software resources). Finally,
activate the ICOSQ and the RQ.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   8 ++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 103 ++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  23 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 7 files changed, 135 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f7c5cf7a7064..648641e68de2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -554,6 +554,8 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+
+	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_wqe_frag_info {
@@ -1027,6 +1029,12 @@ void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params,
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 			       struct mlx5e_params *params);
+int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
+void mlx5e_activate_rq(struct mlx5e_rq *rq);
+void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
+void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
+void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
+void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 7829ea229914..e8c5d3bd86f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -18,6 +18,7 @@
 
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
 
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index b24bdff473b0..c47e9a53bd53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -27,6 +27,103 @@ static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 	return err;
 }
 
+static int mlx5e_wait_for_icosq_flush(struct mlx5e_icosq *icosq)
+{
+	unsigned long exp_time = jiffies + msecs_to_jiffies(2000);
+
+	while (time_before(jiffies, exp_time)) {
+		if (icosq->cc == icosq->pc)
+			return 0;
+
+		msleep(20);
+	}
+
+	netdev_err(icosq->channel->netdev,
+		   "Wait for ICOSQ 0x%x flush timeout (cc = 0x%x, pc = 0x%x)\n",
+		   icosq->sqn, icosq->cc, icosq->pc);
+
+	return -ETIMEDOUT;
+}
+
+static void mlx5e_reset_icosq_cc_pc(struct mlx5e_icosq *icosq)
+{
+	WARN_ONCE(icosq->cc != icosq->pc, "ICOSQ 0x%x: cc (0x%x) != pc (0x%x)\n",
+		  icosq->sqn, icosq->cc, icosq->pc);
+	icosq->cc = 0;
+	icosq->pc = 0;
+}
+
+static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
+{
+	struct mlx5e_icosq *icosq = (struct mlx5e_icosq *)ctx;
+	struct mlx5_core_dev *mdev = icosq->channel->mdev;
+	struct net_device *dev = icosq->channel->netdev;
+	struct mlx5e_rq *rq = &icosq->channel->rq;
+	u8 state;
+	int err;
+
+	err = mlx5_core_query_sq_state(mdev, icosq->sqn, &state);
+	if (err) {
+		netdev_err(dev, "Failed to query ICOSQ 0x%x state. err = %d\n",
+			   icosq->sqn, err);
+		return err;
+	}
+
+	if (state != MLX5_SQC_STATE_ERR)
+		return 0;
+
+	mlx5e_deactivate_rq(rq);
+	err = mlx5e_wait_for_icosq_flush(icosq);
+	if (err)
+		goto out;
+
+	mlx5e_deactivate_icosq(icosq);
+
+	/* At this point, both the rq and the icosq are disabled */
+
+	err = mlx5e_health_sq_to_ready(icosq->channel, icosq->sqn);
+	if (err)
+		goto out;
+
+	mlx5e_reset_icosq_cc_pc(icosq);
+	mlx5e_free_rx_descs(rq);
+	mlx5e_activate_icosq(icosq);
+	mlx5e_activate_rq(rq);
+
+	rq->stats->recover++;
+out:
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
+	return err;
+}
+
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_priv *priv = icosq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = icosq;
+	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
+	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
+{
+	return err_ctx->recover(err_ctx->ctx);
+}
+
+static int mlx5e_rx_reporter_recover(struct devlink_health_reporter *reporter,
+				     void *context)
+{
+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	struct mlx5e_err_ctx *err_ctx = context;
+
+	return err_ctx ? mlx5e_rx_reporter_recover_from_ctx(err_ctx) :
+			 mlx5e_health_recover_channels(priv);
+}
+
 static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
@@ -165,9 +262,12 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 
 static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 		.name = "rx",
+		.recover = mlx5e_rx_reporter_recover,
 		.diagnose = mlx5e_rx_reporter_diagnose,
 };
 
+#define MLX5E_REPORTER_RX_GRACEFUL_PERIOD 500
+
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
@@ -176,7 +276,8 @@ int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 
 	reporter =
 		devlink_health_reporter_create(devlink, &mlx5_rx_reporter_ops,
-					       0, false, priv);
+					       MLX5E_REPORTER_RX_GRACEFUL_PERIOD,
+					       true, priv);
 	if (IS_ERR(reporter))
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7e6ac1e7bdd1..2d57611ac579 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -701,8 +701,7 @@ static int mlx5e_create_rq(struct mlx5e_rq *rq,
 	return err;
 }
 
-static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state,
-				 int next_state)
+int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
 
@@ -813,7 +812,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 	return -ETIMEDOUT;
 }
 
-static void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
+void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 {
 	__be16 wqe_ix_be;
 	u16 wqe_ix;
@@ -889,7 +888,7 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	return err;
 }
 
-static void mlx5e_activate_rq(struct mlx5e_rq *rq)
+void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 	mlx5e_trigger_irq(&rq->channel->icosq);
@@ -904,6 +903,7 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
+	cancel_work_sync(&rq->channel->icosq.recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
 	mlx5e_free_rq(rq);
@@ -1020,6 +1020,14 @@ static int mlx5e_alloc_icosq_db(struct mlx5e_icosq *sq, int numa)
 	return 0;
 }
 
+static void mlx5e_icosq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_icosq *sq = container_of(recover_work, struct mlx5e_icosq,
+					      recover_work);
+
+	mlx5e_reporter_icosq_cqe_err(sq);
+}
+
 static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 			     struct mlx5e_sq_param *param,
 			     struct mlx5e_icosq *sq)
@@ -1042,6 +1050,8 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	if (err)
 		goto err_sq_wq_destroy;
 
+	INIT_WORK(&sq->recover_work, mlx5e_icosq_err_cqe_work);
+
 	return 0;
 
 err_sq_wq_destroy:
@@ -1385,12 +1395,13 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	return err;
 }
 
-static void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
+void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 {
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
 }
 
-static void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
 	struct mlx5e_channel *c = icosq->channel;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 56a2f4666c47..4173679254bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -615,6 +615,8 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
 			netdev_WARN_ONCE(cq->channel->netdev,
 					 "Bad OP in ICOSQ CQE: 0x%x\n", get_cqe_opcode(cqe));
+			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
+				queue_work(cq->channel->priv->wq, &sq->recover_work);
 			break;
 		}
 		do {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 539b4d3656da..7de3d87dc434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -107,6 +107,7 @@
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_waive) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_arm) },
@@ -217,6 +218,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->rx_cache_waive += rq_stats->cache_waive;
 		s->rx_congst_umr  += rq_stats->congst_umr;
 		s->rx_arfs_err    += rq_stats->arfs_err;
+		s->rx_recover     += rq_stats->recover;
 		s->ch_events      += ch_stats->events;
 		s->ch_poll        += ch_stats->poll;
 		s->ch_arm         += ch_stats->arm;
@@ -1294,6 +1296,7 @@ static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_waive) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 76ac111e14d0..a50caa70453c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -114,6 +114,7 @@ struct mlx5e_sw_stats {
 	u64 rx_cache_waive;
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
+	u64 rx_recover;
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -247,6 +248,7 @@ struct mlx5e_rq_stats {
 	u64 cache_waive;
 	u64 congst_umr;
 	u64 arfs_err;
+	u64 recover;
 };
 
 struct mlx5e_sq_stats {
-- 
1.8.3.1

