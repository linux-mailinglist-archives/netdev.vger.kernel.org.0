Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FFD3EE05B
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhHPXXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhHPXXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41EC560EBD;
        Mon, 16 Aug 2021 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156153;
        bh=X0uHocF8NYQBE5zuZZ4LdBgEqItyopXIOJLyLNtSXr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQuAqSsYLoD9cgbihUupJbJh9XL40fTPTXQYZHGLuKeKA2QZPNP3a6Mw21cbEH0Tq
         Rw+KV4dqq7KOENrMwnhT3jNHNmPlpoU/dInRxjGn/1HCRLzSvtFV2MZeGjCInHULzJ
         O+YIm5htLuSv8EHYtK1YeER3Z0E7HSy7mQA1EIFXWM3sAsTLvTsq6Pq4k3UfitdcMY
         00Tr7kmqDh0bmCOSKao0xSXpTxMdu5r24YTUlMz38PGGVp9kQRekB6G48ZkUXRSZET
         lC9Efgx04zRNTnPufTlzqV+r0EzINF2uJI1we04FgeXx9c2eG0QDUPh7cjyQpVod44
         U66A53QdMVLlw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/17] net/mlx5e: Abstract MQPRIO params
Date:   Mon, 16 Aug 2021 16:22:10 -0700
Message-Id: <20210816232219.557083-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Abstract the MQPRIO params into a struct.
Use a getter for DCB mode num_tcs.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  9 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 18 ++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  5 +++--
 6 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4f6897c1ea8d..1ddf320af831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -248,7 +248,9 @@ struct mlx5e_params {
 	u8  rq_wq_type;
 	u8  log_rq_mtu_frames;
 	u16 num_channels;
-	u8  num_tc;
+	struct {
+		u8 num_tc;
+	} mqprio;
 	bool rx_cqe_compress_def;
 	bool tunneled_offload_en;
 	struct dim_cq_moder rx_cq_moderation;
@@ -268,6 +270,11 @@ struct mlx5e_params {
 	bool ptp_rx;
 };
 
+static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
+{
+	return params->mqprio.num_tc;
+}
+
 enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_RECOVERING,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index f479ef31ca40..ee688dec67a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -326,13 +326,14 @@ static int mlx5e_ptp_open_txqsqs(struct mlx5e_ptp *c,
 				 struct mlx5e_ptp_params *cparams)
 {
 	struct mlx5e_params *params = &cparams->params;
+	u8 num_tc = mlx5e_get_dcb_num_tc(params);
 	int ix_base;
 	int err;
 	int tc;
 
-	ix_base = params->num_tc * params->num_channels;
+	ix_base = num_tc * params->num_channels;
 
-	for (tc = 0; tc < params->num_tc; tc++) {
+	for (tc = 0; tc < num_tc; tc++) {
 		int txq_ix = ix_base + tc;
 
 		err = mlx5e_ptp_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
@@ -365,9 +366,12 @@ static int mlx5e_ptp_open_tx_cqs(struct mlx5e_ptp *c,
 	struct mlx5e_create_cq_param ccp = {};
 	struct dim_cq_moder ptp_moder = {};
 	struct mlx5e_cq_param *cq_param;
+	u8 num_tc;
 	int err;
 	int tc;
 
+	num_tc = mlx5e_get_dcb_num_tc(params);
+
 	ccp.node     = dev_to_node(mlx5_core_dma_dev(c->mdev));
 	ccp.ch_stats = c->stats;
 	ccp.napi     = &c->napi;
@@ -375,7 +379,7 @@ static int mlx5e_ptp_open_tx_cqs(struct mlx5e_ptp *c,
 
 	cq_param = &cparams->txq_sq_param.cqp;
 
-	for (tc = 0; tc < params->num_tc; tc++) {
+	for (tc = 0; tc < num_tc; tc++) {
 		struct mlx5e_cq *cq = &c->ptpsq[tc].txqsq.cq;
 
 		err = mlx5e_open_cq(c->priv, ptp_moder, cq_param, &ccp, cq);
@@ -383,7 +387,7 @@ static int mlx5e_ptp_open_tx_cqs(struct mlx5e_ptp *c,
 			goto out_err_txqsq_cq;
 	}
 
-	for (tc = 0; tc < params->num_tc; tc++) {
+	for (tc = 0; tc < num_tc; tc++) {
 		struct mlx5e_cq *cq = &c->ptpsq[tc].ts_cq;
 		struct mlx5e_ptpsq *ptpsq = &c->ptpsq[tc];
 
@@ -399,7 +403,7 @@ static int mlx5e_ptp_open_tx_cqs(struct mlx5e_ptp *c,
 out_err_ts_cq:
 	for (--tc; tc >= 0; tc--)
 		mlx5e_close_cq(&c->ptpsq[tc].ts_cq);
-	tc = params->num_tc;
+	tc = num_tc;
 out_err_txqsq_cq:
 	for (--tc; tc >= 0; tc--)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
@@ -475,7 +479,7 @@ static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 	params->num_channels = orig->num_channels;
 	params->hard_mtu = orig->hard_mtu;
 	params->sw_mtu = orig->sw_mtu;
-	params->num_tc = orig->num_tc;
+	params->mqprio = orig->mqprio;
 
 	/* SQ */
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
@@ -680,7 +684,7 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
-	c->num_tc   = params->num_tc;
+	c->num_tc   = mlx5e_get_dcb_num_tc(params);
 	c->stats    = &priv->ptp_stats.ch;
 	c->lag_port = lag_port;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 5efe3278b0f6..c9ac69f62f21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -132,7 +132,7 @@ static u16 mlx5e_qid_from_qos(struct mlx5e_channels *chs, u16 qid)
 	 */
 	bool is_ptp = MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS);
 
-	return (chs->params.num_channels + is_ptp) * chs->params.num_tc + qid;
+	return (chs->params.num_channels + is_ptp) * mlx5e_get_dcb_num_tc(&chs->params) + qid;
 }
 
 int mlx5e_get_txq_by_classid(struct mlx5e_priv *priv, u16 classid)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9d361efd5ff7..bb682fd751c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -372,7 +372,7 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	for (i = 0; i < priv->channels.num; i++) {
 		struct mlx5e_channel *c = priv->channels.c[i];
 
-		for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
+		for (tc = 0; tc < mlx5e_get_dcb_num_tc(&priv->channels.params); tc++) {
 			struct mlx5e_txqsq *sq = &c->sq[tc];
 
 			err = mlx5e_tx_reporter_build_diagnose_output(fmsg, sq, tc);
@@ -384,7 +384,7 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (!ptp_ch || !test_bit(MLX5E_PTP_STATE_TX, ptp_ch->state))
 		goto close_sqs_nest;
 
-	for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
+	for (tc = 0; tc < mlx5e_get_dcb_num_tc(&priv->channels.params); tc++) {
 		err = mlx5e_tx_reporter_build_diagnose_output_ptpsq(fmsg,
 								    &ptp_ch->ptpsq[tc],
 								    tc);
@@ -494,7 +494,7 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 	for (i = 0; i < priv->channels.num; i++) {
 		struct mlx5e_channel *c = priv->channels.c[i];
 
-		for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
+		for (tc = 0; tc < mlx5e_get_dcb_num_tc(&priv->channels.params); tc++) {
 			struct mlx5e_txqsq *sq = &c->sq[tc];
 
 			err = mlx5e_health_queue_dump(priv, fmsg, sq->sqn, "SQ");
@@ -504,7 +504,7 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 	}
 
 	if (ptp_ch && test_bit(MLX5E_PTP_STATE_TX, ptp_ch->state)) {
-		for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
+		for (tc = 0; tc < mlx5e_get_dcb_num_tc(&priv->channels.params); tc++) {
 			struct mlx5e_txqsq *sq = &ptp_ch->ptpsq[tc].txqsq;
 
 			err = mlx5e_health_queue_dump(priv, fmsg, sq->sqn, "PTP SQ");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e559afc70bff..b2f95cd34622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1711,7 +1711,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 {
 	int err, tc;
 
-	for (tc = 0; tc < params->num_tc; tc++) {
+	for (tc = 0; tc < mlx5e_get_dcb_num_tc(params); tc++) {
 		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
@@ -1992,7 +1992,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
-	c->num_tc   = params->num_tc;
+	c->num_tc   = mlx5e_get_dcb_num_tc(params);
 	c->xdp      = !!params->xdp_prog;
 	c->stats    = &priv->channel_stats[ix].ch;
 	c->aff_mask = irq_get_effective_affinity_mask(irq);
@@ -2288,7 +2288,7 @@ int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 	qos_queues = mlx5e_qos_cur_leaf_nodes(priv);
 
 	nch = priv->channels.params.num_channels;
-	ntc = priv->channels.params.num_tc;
+	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	num_txqs = nch * ntc + qos_queues;
 	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS))
 		num_txqs += ntc;
@@ -2312,7 +2312,7 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	old_ntc = netdev->num_tc ? : 1;
 
 	nch = priv->channels.params.num_channels;
-	ntc = priv->channels.params.num_tc;
+	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	num_rxqs = nch * priv->profile->rq_groups;
 
 	mlx5e_netdev_set_tcs(netdev, nch, ntc);
@@ -2387,7 +2387,7 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 	int i, ch, tc, num_tc;
 
 	ch = priv->channels.num;
-	num_tc = priv->channels.params.num_tc;
+	num_tc = mlx5e_get_dcb_num_tc(&priv->channels.params);
 
 	for (i = 0; i < ch; i++) {
 		for (tc = 0; tc < num_tc; tc++) {
@@ -2418,7 +2418,7 @@ static void mlx5e_update_num_tc_x_num_ch(struct mlx5e_priv *priv)
 {
 	/* Sync with mlx5e_select_queue. */
 	WRITE_ONCE(priv->num_tc_x_num_ch,
-		   priv->channels.params.num_tc * priv->channels.num);
+		   mlx5e_get_dcb_num_tc(&priv->channels.params) * priv->channels.num);
 }
 
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
@@ -2870,14 +2870,14 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	}
 
 	new_params = priv->channels.params;
-	new_params.num_tc = tc ? tc : 1;
+	new_params.mqprio.num_tc = tc ? tc : 1;
 
 	err = mlx5e_safe_switch_params(priv, &new_params,
 				       mlx5e_num_channels_changed_ctx, NULL, true);
 
 out:
 	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
-				    priv->channels.params.num_tc);
+				    mlx5e_get_dcb_num_tc(&priv->channels.params));
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
@@ -4093,12 +4093,12 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	params->hard_mtu = MLX5E_ETH_HARD_MTU;
 	params->num_channels = min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
 				     priv->max_nch);
-	params->num_tc       = 1;
+	params->mqprio.num_tc = 1;
 
 	/* Set an initial non-zero value, so that mlx5e_select_queue won't
 	 * divide by zero if called before first activating channels.
 	 */
-	priv->num_tc_x_num_ch = params->num_channels * params->num_tc;
+	priv->num_tc_x_num_ch = params->num_channels * params->mqprio.num_tc;
 
 	/* SQ */
 	params->log_sq_size = is_kdump_kernel() ?
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c54aaef521b7..eb83f27850c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -394,7 +394,8 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 	int err = -ENOMEM;
 	u32 *sqs;
 
-	sqs = kcalloc(priv->channels.num * priv->channels.params.num_tc, sizeof(*sqs), GFP_KERNEL);
+	sqs = kcalloc(priv->channels.num * mlx5e_get_dcb_num_tc(&priv->channels.params),
+		      sizeof(*sqs), GFP_KERNEL);
 	if (!sqs)
 		goto out;
 
@@ -611,7 +612,7 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->rx_dim_enabled = MLX5_CAP_GEN(mdev, cq_moderation);
 	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
 
-	params->num_tc                = 1;
+	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
 
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
-- 
2.31.1

