Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84465614CB
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGGLyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:54:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58952 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727013AbfGGLyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:54:01 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:20 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJM5031039;
        Sun, 7 Jul 2019 14:53:20 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 16/16] net/mlx5e: Recover from CQE with error on RQ
Date:   Sun,  7 Jul 2019 14:53:08 +0300
Message-Id: <1562500388-16847-17-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for recovery from error on completion on RQ by setting
the queue back to ready state. Handle only errors with a syndrome
indicating the RQ might enter error state and could be recovered.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  3 +
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  9 +++
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 65 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 10 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 11 ++++
 5 files changed, 98 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 648641e68de2..bf39ce19303d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -303,6 +303,7 @@ struct mlx5e_dcbx_dp {
 
 enum {
 	MLX5E_RQ_STATE_ENABLED,
+	MLX5E_RQ_STATE_RECOVERING,
 	MLX5E_RQ_STATE_AM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 };
@@ -675,6 +676,8 @@ struct mlx5e_rq {
 	struct zero_copy_allocator zca;
 	struct xdp_umem       *umem;
 
+	struct work_struct     recover_work;
+
 	/* control */
 	struct mlx5_wq_ctrl    wq_ctrl;
 	__be32                 mkey_be;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 435e31ad1cfb..198ef625005c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -8,6 +8,14 @@
 
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
 
+static inline bool cqe_syndrome_needs_recover(u8 syndrome)
+{
+	return syndrome == MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR ||
+	       syndrome == MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
+	       syndrome == MLX5_CQE_SYNDROME_LOCAL_PROT_ERR ||
+	       syndrome == MLX5_CQE_SYNDROME_WR_FLUSH_ERR;
+}
+
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
@@ -21,6 +29,7 @@
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq);
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
 
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 7e7dba129330..2f48321d14d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -109,6 +109,71 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
 
+static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+{
+	struct net_device *dev = rq->netdev;
+	int err;
+
+	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
+		return err;
+	}
+	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
+		return err;
+	}
+
+	return 0;
+}
+
+static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
+{
+	struct mlx5e_rq *rq = (struct mlx5e_rq *)ctx;
+	struct mlx5_core_dev *mdev = rq->mdev;
+	struct net_device *dev = rq->netdev;
+	u8 state;
+	int err;
+
+	err = mlx5e_query_rq_state(mdev, rq->rqn, &state);
+	if (err) {
+		netdev_err(dev, "Failed to query RQ 0x%x state. err = %d\n",
+			   rq->rqn, err);
+		return err;
+	}
+
+	if (state != MLX5_RQC_STATE_ERR)
+		return 0;
+
+	mlx5e_deactivate_rq(rq);
+	mlx5e_free_rx_descs(rq);
+
+	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	if (err)
+		goto out;
+
+	mlx5e_activate_rq(rq);
+	rq->stats->recover++;
+
+out:
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
+	return err;
+}
+
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
+{
+	struct mlx5e_priv *priv = rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = rq;
+	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
+	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5e_rq *rq = (struct mlx5e_rq *)ctx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1ebdeccf395d..c1f12f2e3a1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -363,6 +363,13 @@ static void mlx5e_free_di_list(struct mlx5e_rq *rq)
 	kvfree(rq->wqe.di);
 }
 
+static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_rq *rq = container_of(recover_work, struct mlx5e_rq, recover_work);
+
+	mlx5e_reporter_rq_cqe_err(rq);
+}
+
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
@@ -399,6 +406,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
+	INIT_WORK(&rq->recover_work, mlx5e_rq_err_cqe_work);
 
 	rq->xdp_prog = params->xdp_prog ? bpf_prog_inc(params->xdp_prog) : NULL;
 	if (IS_ERR(rq->xdp_prog)) {
@@ -891,6 +899,7 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &rq->state);
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 	mlx5e_trigger_irq(&rq->channel->icosq);
 }
@@ -905,6 +914,7 @@ void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
 	cancel_work_sync(&rq->channel->icosq.recover_work);
+	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
 	mlx5e_free_rq(rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3b730d3436e6..2b486863038e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1123,6 +1123,15 @@ struct sk_buff *
 	return skb;
 }
 
+static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	struct mlx5_err_cqe *err_cqe = (struct mlx5_err_cqe *)cqe;
+
+	if (cqe_syndrome_needs_recover(err_cqe->syndrome) &&
+	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state))
+		queue_work(rq->channel->priv->wq, &rq->recover_work);
+}
+
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
@@ -1136,6 +1145,7 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
 		rq->stats->wqe_err++;
 		goto free_wqe;
 	}
@@ -1321,6 +1331,7 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi->consumed_strides += cstrides;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
 		rq->stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
-- 
1.8.3.1

