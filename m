Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2468A34E01C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhC3E17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhC3E1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F4361985;
        Tue, 30 Mar 2021 04:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078465;
        bh=9rkHlw/CLnHqIcTxtQGxTnmiXhKUKqzRLA9Ozgl8oTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyQe0yPaU7/Hoka5st8lYTPMSFsc3b7eVVM110fvlWo4gn9Ipd8rQoj0wGj81BZWs
         y44TKVKqDL0FNZII0uYM3PUAd95TcZQ9/+A46XD2yjFfIKIfEVVS2z9+htaZevFU/f
         ojCo4vZMp7mdl0MLPu7KfgYPGKCSbl0xPGPLpXzwbFInnxT3kHy/90v7jdKOSEQHxh
         9JCCgy+jz4MuNzOK0iOxK6Kd2qx+7b5Zdf4NnWKUxGtZvTtIccoIZLrXl8n/5Z9Lga
         z58zqadv6ioGQjrIp6F9CIyJ5FzuwYo8TVpNB5sh7gqP7BSWO8Gu7uSs4yR/fyix3i
         e/BaY9TNkCLtw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/12] net/mlx5e: Add states to PTP channel
Date:   Mon, 29 Mar 2021 21:27:30 -0700
Message-Id: <20210330042741.198601-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add PTP TX state to PTP channel, which indicates the corresponding SQ is
available. Further patches in the set extend PTP channel to include RQ.
The PTP channel state will be used for separation and coexistence of RX
and TX PTP. Enhance conditions to verify the TX PTP state is set.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 73 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  6 ++
 .../mellanox/mlx5/core/en/reporter_tx.c       | 12 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 11 ++-
 5 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 92a41b1bcdb0..286bd2345da1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -134,9 +134,11 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 
 	ch_stats->poll++;
 
-	for (i = 0; i < c->num_tc; i++) {
-		busy |= mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
-		busy |= mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (i = 0; i < c->num_tc; i++) {
+			busy |= mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
+			busy |= mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
+		}
 	}
 
 	if (busy) {
@@ -149,9 +151,11 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 
 	ch_stats->arm++;
 
-	for (i = 0; i < c->num_tc; i++) {
-		mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
-		mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (i = 0; i < c->num_tc; i++) {
+			mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
+			mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
+		}
 	}
 
 out:
@@ -422,9 +426,10 @@ static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 	params->num_tc = orig->num_tc;
 
 	/* SQ */
-	params->log_sq_size = orig->log_sq_size;
-
-	mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		params->log_sq_size = orig->log_sq_size;
+		mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
+	}
 }
 
 static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
@@ -432,26 +437,38 @@ static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
 {
 	int err;
 
-	err = mlx5e_ptp_open_cqs(c, cparams);
-	if (err)
-		return err;
-
-	err = mlx5e_ptp_open_txqsqs(c, cparams);
-	if (err)
-		goto close_cqs;
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		err = mlx5e_ptp_open_cqs(c, cparams);
+		if (err)
+			return err;
 
+		err = mlx5e_ptp_open_txqsqs(c, cparams);
+		if (err)
+			goto close_cqs;
+	}
 	return 0;
 
 close_cqs:
-	mlx5e_ptp_close_cqs(c);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state))
+		mlx5e_ptp_close_cqs(c);
 
 	return err;
 }
 
 static void mlx5e_ptp_close_queues(struct mlx5e_ptp *c)
 {
-	mlx5e_ptp_close_txqsqs(c);
-	mlx5e_ptp_close_cqs(c);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		mlx5e_ptp_close_txqsqs(c);
+		mlx5e_ptp_close_cqs(c);
+	}
+}
+
+static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
+{
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_TX_PORT_TS))
+		__set_bit(MLX5E_PTP_STATE_TX, c->state);
+
+	return bitmap_empty(c->state, MLX5E_PTP_STATE_NUM_STATES) ? -EINVAL : 0;
 }
 
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
@@ -479,6 +496,10 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->stats    = &priv->ptp_stats.ch;
 	c->lag_port = lag_port;
 
+	err = mlx5e_ptp_set_state(c, params);
+	if (err)
+		goto err_free;
+
 	netif_napi_add(netdev, &c->napi, mlx5e_ptp_napi_poll, 64);
 
 	mlx5e_ptp_build_params(c, cparams, params);
@@ -495,7 +516,7 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 
 err_napi_del:
 	netif_napi_del(&c->napi);
-
+err_free:
 	kvfree(cparams);
 	kvfree(c);
 	return err;
@@ -515,16 +536,20 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 
 	napi_enable(&c->napi);
 
-	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (tc = 0; tc < c->num_tc; tc++)
+			mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
+	}
 }
 
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
 {
 	int tc;
 
-	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (tc = 0; tc < c->num_tc; tc++)
+			mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+	}
 
 	napi_disable(&c->napi);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 937530afaf14..36c46274a46a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -16,6 +16,11 @@ struct mlx5e_ptpsq {
 	struct mlx5e_ptp_cq_stats *cq_stats;
 };
 
+enum {
+	MLX5E_PTP_STATE_TX,
+	MLX5E_PTP_STATE_NUM_STATES,
+};
+
 struct mlx5e_ptp {
 	/* data path */
 	struct mlx5e_ptpsq         ptpsq[MLX5E_MAX_NUM_TC];
@@ -33,6 +38,7 @@ struct mlx5e_ptp {
 	struct mlx5e_priv         *priv;
 	struct mlx5_core_dev      *mdev;
 	struct hwtstamp_config    *tstamp;
+	DECLARE_BITMAP(state, MLX5E_PTP_STATE_NUM_STATES);
 };
 
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index e107801adf48..1a0505bd1e9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -304,6 +304,7 @@ mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *reporte
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_txqsq *generic_sq = priv->txq2sq[0];
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 	struct mlx5e_ptpsq *generic_ptpsq;
 	int err;
 
@@ -315,12 +316,11 @@ mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *reporte
 	if (err)
 		return err;
 
-	generic_ptpsq = priv->channels.ptp ?
-			&priv->channels.ptp->ptpsq[0] :
-			NULL;
-	if (!generic_ptpsq)
+	if (!ptp_ch || !test_bit(MLX5E_PTP_STATE_TX, ptp_ch->state))
 		goto out;
 
+	generic_ptpsq = &ptp_ch->ptpsq[0];
+
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "PTP");
 	if (err)
 		return err;
@@ -375,7 +375,7 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 		}
 	}
 
-	if (!ptp_ch)
+	if (!ptp_ch || !test_bit(MLX5E_PTP_STATE_TX, ptp_ch->state))
 		goto close_sqs_nest;
 
 	for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
@@ -497,7 +497,7 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (ptp_ch) {
+	if (ptp_ch && test_bit(MLX5E_PTP_STATE_TX, ptp_ch->state)) {
 		for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
 			struct mlx5e_txqsq *sq = &ptp_ch->ptpsq[tc].txqsq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 40a62d2e9558..458dd079ca89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2759,6 +2759,9 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 	if (!priv->channels.ptp)
 		return;
 
+	if (!test_bit(MLX5E_PTP_STATE_TX, priv->channels.ptp->state))
+		return;
+
 	for (tc = 0; tc < num_tc; tc++) {
 		struct mlx5e_ptp *c = priv->channels.ptp;
 		struct mlx5e_txqsq *sq = &c->ptpsq[tc].txqsq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index cfb6ffd7df54..8ba62671f5f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -133,6 +133,8 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
 	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
 	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
+		struct mlx5e_ptp *ptp_channel;
+
 		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
 		u16 htb_maj_id = smp_load_acquire(&priv->htb.maj_id);
 
@@ -142,10 +144,11 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 				return txq_ix;
 		}
 
-		if (unlikely(priv->channels.ptp))
-			if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-			    mlx5e_use_ptpsq(skb))
-				return mlx5e_select_ptpsq(dev, skb);
+		ptp_channel = READ_ONCE(priv->channels.ptp);
+		if (unlikely(ptp_channel) &&
+		    test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
+		    mlx5e_use_ptpsq(skb))
+			return mlx5e_select_ptpsq(dev, skb);
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
 		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
-- 
2.30.2

