Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884762D3381
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLHUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:20:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgLHUUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:20:08 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 09/15] net/mlx5e: Add TX port timestamp support
Date:   Tue,  8 Dec 2020 11:35:49 -0800
Message-Id: <20201208193555.674504-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

Transmitted packet timestamping accuracy can be improved when using
timestamp from the port, instead of packet CQE creation timestamp, as
it better reflects the actual time of a packet's transmit.

TX port timestamping is supported starting from ConnectX6-DX hardware.
Although at the original completion, only CQE timestamp can be attached,
we are able to get TX port timestamping via an additional completion over
a special CQ associated with the SQ (in addition to the regular CQ).

Driver to ignore the original packet completion timestamp, and report
back the timestamp of the special CQ completion. If the absolute timestamp

diff between the two completions is greater than 1 / 128 second, ignore
the TX port timestamp as it has a jitter which is too big.
No skb will be generate out of the extra completion.

Allocate additional CQ per ptpsq, to receive the TX port timestamp.

Driver to hold an skb FIFO in order to map between transmitted skb to
the two expected completions. When using ptpsq, hold double refcount on
the skb, to gaurantee it will not get released before both completions
arrive.

Expose dedicated counters of the ptp additional CQ and connect it to the
TX health reporter.

This patch improves TX Hardware timestamping offset to be less than 40ns
at a 100Gbps line rate, compared to 600ns before.

With that, making our HW compliant with G.8273.2 class C, and allow Linux
systems to be deployed in the 5G telco edge, where this standard is a
must.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 173 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  15 ++
 .../mellanox/mlx5/core/en/reporter_tx.c       |  37 +++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  21 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   8 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  12 +-
 9 files changed, 262 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6864c79d2d9a..a1a81cfeb607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -718,6 +718,7 @@ struct mlx5e_channel_stats {
 struct mlx5e_port_ptp_stats {
 	struct mlx5e_ch_stats ch;
 	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
+	struct mlx5e_ptp_cq_stats cq[MLX5E_MAX_NUM_TC];
 } ____cacheline_aligned_in_smp;
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 70e463712b7f..3959254d4181 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -44,6 +44,7 @@ struct mlx5e_channel_param {
 struct mlx5e_create_sq_param {
 	struct mlx5_wq_ctrl        *wq_ctrl;
 	u32                         cqn;
+	u32                         ts_cqe_to_dest_cqn;
 	u32                         tisn;
 	u8                          tis_lst_sz;
 	u8                          min_inline_mode;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8639b5104df7..351118985a57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -5,6 +5,115 @@
 #include "en/txrx.h"
 #include "lib/clock.h"
 
+struct mlx5e_skb_cb_hwtstamp {
+	ktime_t cqe_hwtstamp;
+	ktime_t port_hwtstamp;
+};
+
+void mlx5e_skb_cb_hwtstamp_init(struct sk_buff *skb)
+{
+	memset(skb->cb, 0, sizeof(struct mlx5e_skb_cb_hwtstamp));
+}
+
+static struct mlx5e_skb_cb_hwtstamp *mlx5e_skb_cb_get_hwts(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct mlx5e_skb_cb_hwtstamp) > sizeof(skb->cb));
+	return (struct mlx5e_skb_cb_hwtstamp *)skb->cb;
+}
+
+static void mlx5e_skb_cb_hwtstamp_tx(struct sk_buff *skb,
+				     struct mlx5e_ptp_cq_stats *cq_stats)
+{
+	struct skb_shared_hwtstamps hwts = {};
+	ktime_t diff;
+
+	diff = abs(mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp -
+		   mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp);
+
+	/* Maximal allowed diff is 1 / 128 second */
+	if (diff > (NSEC_PER_SEC >> 7)) {
+		cq_stats->abort++;
+		cq_stats->abort_abs_diff_ns += diff;
+		return;
+	}
+
+	hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp;
+	skb_tstamp_tx(skb, &hwts);
+}
+
+void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
+				   ktime_t hwtstamp,
+				   struct mlx5e_ptp_cq_stats *cq_stats)
+{
+	switch (hwtstamp_type) {
+	case (MLX5E_SKB_CB_CQE_HWTSTAMP):
+		mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp = hwtstamp;
+		break;
+	case (MLX5E_SKB_CB_PORT_HWTSTAMP):
+		mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp = hwtstamp;
+		break;
+	}
+
+	/* If both CQEs arrive, check and report the port tstamp, and clear skb cb as
+	 * skb soon to be released.
+	 */
+	if (!mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp ||
+	    !mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp)
+		return;
+
+	mlx5e_skb_cb_hwtstamp_tx(skb, cq_stats);
+	memset(skb->cb, 0, sizeof(struct mlx5e_skb_cb_hwtstamp));
+}
+
+static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
+				    struct mlx5_cqe64 *cqe,
+				    int budget)
+{
+	struct sk_buff *skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	ktime_t hwtstamp;
+
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		ptpsq->cq_stats->err_cqe++;
+		goto out;
+	}
+
+	hwtstamp = mlx5_timecounter_cyc2time(ptpsq->txqsq.clock, get_cqe_ts(cqe));
+	mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_PORT_HWTSTAMP,
+				      hwtstamp, ptpsq->cq_stats);
+	ptpsq->cq_stats->cqe++;
+
+out:
+	napi_consume_skb(skb, budget);
+}
+
+static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
+{
+	struct mlx5e_ptpsq *ptpsq = container_of(cq, struct mlx5e_ptpsq, ts_cq);
+	struct mlx5_cqwq *cqwq = &cq->wq;
+	struct mlx5_cqe64 *cqe;
+	int work_done = 0;
+
+	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &ptpsq->txqsq.state)))
+		return false;
+
+	cqe = mlx5_cqwq_get_cqe(cqwq);
+	if (!cqe)
+		return false;
+
+	do {
+		mlx5_cqwq_pop(cqwq);
+
+		mlx5e_ptp_handle_ts_cqe(ptpsq, cqe, budget);
+	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
+
+	mlx5_cqwq_update_db_record(cqwq);
+
+	/* ensure cq space is freed before enabling more cqes */
+	wmb();
+
+	return work_done == budget;
+}
+
 static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct mlx5e_port_ptp *c = container_of(napi, struct mlx5e_port_ptp,
@@ -18,8 +127,10 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 
 	ch_stats->poll++;
 
-	for (i = 0; i < c->num_tc; i++)
+	for (i = 0; i < c->num_tc; i++) {
 		busy |= mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
+		busy |= mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
+	}
 
 	if (busy) {
 		work_done = budget;
@@ -31,8 +142,10 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 
 	ch_stats->arm++;
 
-	for (i = 0; i < c->num_tc; i++)
+	for (i = 0; i < c->num_tc; i++) {
 		mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
+		mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
+	}
 
 out:
 	rcu_read_unlock();
@@ -96,6 +209,37 @@ static void mlx5e_ptp_destroy_sq(struct mlx5_core_dev *mdev, u32 sqn)
 	mlx5_core_destroy_sq(mdev, sqn);
 }
 
+static int mlx5e_ptp_alloc_traffic_db(struct mlx5e_ptpsq *ptpsq, int numa)
+{
+	int wq_sz = mlx5_wq_cyc_get_size(&ptpsq->txqsq.wq);
+
+	ptpsq->skb_fifo.fifo = kvzalloc_node(array_size(wq_sz, sizeof(*ptpsq->skb_fifo.fifo)),
+					     GFP_KERNEL, numa);
+	if (!ptpsq->skb_fifo.fifo)
+		return -ENOMEM;
+
+	ptpsq->skb_fifo.pc   = &ptpsq->skb_fifo_pc;
+	ptpsq->skb_fifo.cc   = &ptpsq->skb_fifo_cc;
+	ptpsq->skb_fifo.mask = wq_sz - 1;
+
+	return 0;
+}
+
+static void mlx5e_ptp_drain_skb_fifo(struct mlx5e_skb_fifo *skb_fifo)
+{
+	while (*skb_fifo->pc != *skb_fifo->cc) {
+		struct sk_buff *skb = mlx5e_skb_fifo_pop(skb_fifo);
+
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static void mlx5e_ptp_free_traffic_db(struct mlx5e_skb_fifo *skb_fifo)
+{
+	mlx5e_ptp_drain_skb_fifo(skb_fifo);
+	kvfree(skb_fifo->fifo);
+}
+
 static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
 				int txq_ix, struct mlx5e_ptp_params *cparams,
 				int tc, struct mlx5e_ptpsq *ptpsq)
@@ -115,11 +259,17 @@ static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
 	csp.cqn             = txqsq->cq.mcq.cqn;
 	csp.wq_ctrl         = &txqsq->wq_ctrl;
 	csp.min_inline_mode = txqsq->min_inline_mode;
+	csp.ts_cqe_to_dest_cqn = ptpsq->ts_cq.mcq.cqn;
 
 	err = mlx5e_create_sq_rdy(c->mdev, sqp, &csp, &txqsq->sqn);
 	if (err)
 		goto err_free_txqsq;
 
+	err = mlx5e_ptp_alloc_traffic_db(ptpsq,
+					 dev_to_node(mlx5_core_dma_dev(c->mdev)));
+	if (err)
+		goto err_free_txqsq;
+
 	return 0;
 
 err_free_txqsq:
@@ -133,6 +283,7 @@ static void mlx5e_ptp_close_txqsq(struct mlx5e_ptpsq *ptpsq)
 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
 	struct mlx5_core_dev *mdev = sq->mdev;
 
+	mlx5e_ptp_free_traffic_db(&ptpsq->skb_fifo);
 	cancel_work_sync(&sq->recover_work);
 	mlx5e_ptp_destroy_sq(mdev, sq->sqn);
 	mlx5e_free_txqsq_descs(sq);
@@ -200,8 +351,23 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c,
 			goto out_err_txqsq_cq;
 	}
 
+	for (tc = 0; tc < params->num_tc; tc++) {
+		struct mlx5e_cq *cq = &c->ptpsq[tc].ts_cq;
+		struct mlx5e_ptpsq *ptpsq = &c->ptpsq[tc];
+
+		err = mlx5e_open_cq(c->priv, ptp_moder, cq_param, &ccp, cq);
+		if (err)
+			goto out_err_ts_cq;
+
+		ptpsq->cq_stats = &c->priv->port_ptp_stats.cq[tc];
+	}
+
 	return 0;
 
+out_err_ts_cq:
+	for (--tc; tc >= 0; tc--)
+		mlx5e_close_cq(&c->ptpsq[tc].ts_cq);
+	tc = params->num_tc;
 out_err_txqsq_cq:
 	for (--tc; tc >= 0; tc--)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
@@ -213,6 +379,9 @@ static void mlx5e_ptp_close_cqs(struct mlx5e_port_ptp *c)
 {
 	int tc;
 
+	for (tc = 0; tc < c->num_tc; tc++)
+		mlx5e_close_cq(&c->ptpsq[tc].ts_cq);
+
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index daa3b6953e3f..28aa5ae118f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -10,6 +10,11 @@
 
 struct mlx5e_ptpsq {
 	struct mlx5e_txqsq       txqsq;
+	struct mlx5e_cq          ts_cq;
+	u16                      skb_fifo_cc;
+	u16                      skb_fifo_pc;
+	struct mlx5e_skb_fifo    skb_fifo;
+	struct mlx5e_ptp_cq_stats *cq_stats;
 };
 
 struct mlx5e_port_ptp {
@@ -45,4 +50,14 @@ void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c);
 void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c);
 
+enum {
+	MLX5E_SKB_CB_CQE_HWTSTAMP  = BIT(0),
+	MLX5E_SKB_CB_PORT_HWTSTAMP = BIT(1),
+};
+
+void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
+				   ktime_t hwtstamp,
+				   struct mlx5e_ptp_cq_stats *cq_stats);
+
+void mlx5e_skb_cb_hwtstamp_init(struct sk_buff *skb);
 #endif /* __MLX5_EN_PTP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index c55a2ad10599..d7275c84313e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -228,9 +228,19 @@ mlx5e_tx_reporter_build_diagnose_output_ptpsq(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg,
-								&ptpsq->txqsq,
-								tc);
+	err = mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg, &ptpsq->txqsq, tc);
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Port TS");
+	if (err)
+		return err;
+
+	err = mlx5e_health_cq_diag_fmsg(&ptpsq->ts_cq, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
@@ -270,6 +280,23 @@ mlx5e_tx_reporter_diagnose_generic_txqsq(struct devlink_fmsg *fmsg,
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
+static int
+mlx5e_tx_reporter_diagnose_generic_tx_port_ts(struct devlink_fmsg *fmsg,
+					      struct mlx5e_ptpsq *ptpsq)
+{
+	int err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Port TS");
+	if (err)
+		return err;
+
+	err = mlx5e_health_cq_common_diag_fmsg(&ptpsq->ts_cq, fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
 static int
 mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *reporter,
 					 struct devlink_fmsg *fmsg)
@@ -301,6 +328,10 @@ mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *reporte
 	if (err)
 		return err;
 
+	err = mlx5e_tx_reporter_diagnose_generic_tx_port_ts(fmsg, generic_ptpsq);
+	if (err)
+		return err;
+
 	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3b68e31d201f..3275c4e7cbdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1206,6 +1206,7 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 	MLX5_SET(sqc,  sqc, tis_lst_sz, csp->tis_lst_sz);
 	MLX5_SET(sqc,  sqc, tis_num_0, csp->tisn);
 	MLX5_SET(sqc,  sqc, cqn, csp->cqn);
+	MLX5_SET(sqc,  sqc, ts_cqe_to_dest_cqn, csp->ts_cqe_to_dest_cqn);
 
 	if (MLX5_CAP_ETH(mdev, wqe_inline_mode) == MLX5_CAP_INLINE_MODE_VPORT_CONTEXT)
 		MLX5_SET(sqc,  sqc, min_wqe_inline_mode, csp->min_inline_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 9d57dc94c767..2cf2042b37c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1733,6 +1733,13 @@ static const struct counter_desc ptp_ch_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, eq_rearm) },
 };
 
+static const struct counter_desc ptp_cq_stats_desc[] = {
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, err_cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
+};
+
 #define NUM_RQ_STATS			ARRAY_SIZE(rq_stats_desc)
 #define NUM_SQ_STATS			ARRAY_SIZE(sq_stats_desc)
 #define NUM_XDPSQ_STATS			ARRAY_SIZE(xdpsq_stats_desc)
@@ -1742,11 +1749,13 @@ static const struct counter_desc ptp_ch_stats_desc[] = {
 #define NUM_CH_STATS			ARRAY_SIZE(ch_stats_desc)
 #define NUM_PTP_SQ_STATS		ARRAY_SIZE(ptp_sq_stats_desc)
 #define NUM_PTP_CH_STATS		ARRAY_SIZE(ptp_ch_stats_desc)
+#define NUM_PTP_CQ_STATS		ARRAY_SIZE(ptp_cq_stats_desc)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
 {
 	return priv->port_ptp_opened ?
-	       NUM_PTP_CH_STATS + (NUM_PTP_SQ_STATS * priv->max_opened_tc) :
+	       NUM_PTP_CH_STATS +
+	       ((NUM_PTP_SQ_STATS + NUM_PTP_CQ_STATS) * priv->max_opened_tc) :
 	       0;
 }
 
@@ -1766,6 +1775,10 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
 				ptp_sq_stats_desc[i].format, tc);
 
+	for (tc = 0; tc < priv->max_opened_tc; tc++)
+		for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				ptp_cq_stats_desc[i].format, tc);
 	return idx;
 }
 
@@ -1787,6 +1800,12 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
 				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.sq[tc],
 						     ptp_sq_stats_desc, i);
 
+	for (tc = 0; tc < priv->max_opened_tc; tc++)
+		for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+			data[idx++] =
+				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.cq[tc],
+						     ptp_cq_stats_desc, i);
+
 	return idx;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 98ffebcc93b9..e41fc11f2ce7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -53,6 +53,7 @@
 
 #define MLX5E_DECLARE_PTP_TX_STAT(type, fld) "ptp_tx%d_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_PTP_CH_STAT(type, fld) "ptp_ch_"#fld, offsetof(type, fld)
+#define MLX5E_DECLARE_PTP_CQ_STAT(type, fld) "ptp_cq%d_"#fld, offsetof(type, fld)
 
 struct counter_desc {
 	char		format[ETH_GSTRING_LEN];
@@ -401,6 +402,13 @@ struct mlx5e_ch_stats {
 	u64 eq_rearm;
 };
 
+struct mlx5e_ptp_cq_stats {
+	u64 cqe;
+	u64 err_cqe;
+	u64 abort;
+	u64 abort_abs_diff_ns;
+};
+
 struct mlx5e_stats {
 	struct mlx5e_sw_stats sw;
 	struct mlx5e_qcounter_stats qcnt;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 74f25293499a..e47e2a0059d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -463,6 +463,12 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	mlx5e_tx_check_stop(sq);
 
+	if (unlikely(sq->ptpsq)) {
+		mlx5e_skb_cb_hwtstamp_init(skb);
+		mlx5e_skb_fifo_push(&sq->ptpsq->skb_fifo, skb);
+		skb_get(skb);
+	}
+
 	send_doorbell = __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_more);
 	if (send_doorbell)
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
@@ -768,7 +774,11 @@ static void mlx5e_consume_skb(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		u64 ts = get_cqe_ts(cqe);
 
 		hwts.hwtstamp = mlx5_timecounter_cyc2time(sq->clock, ts);
-		skb_tstamp_tx(skb, &hwts);
+		if (sq->ptpsq)
+			mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_CQE_HWTSTAMP,
+						      hwts.hwtstamp, sq->ptpsq->cq_stats);
+		else
+			skb_tstamp_tx(skb, &hwts);
 	}
 
 	napi_consume_skb(skb, napi_budget);
-- 
2.26.2

