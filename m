Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2434B4B6389
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiBOGdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiBOGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469A4ADFFB
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1982B817E1
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291E3C340F0;
        Tue, 15 Feb 2022 06:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906761;
        bh=Jay4mRLltp+HkEfKZ4BeqyUgmj1oY8giFJkKv9N68Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq9c7X25Ns4sWNzoFMe8MBlI29K3UyW2tD0OVx5hg7PuYQkvz+/eDJqhntJ1GINg2
         d7Ei24+e0Xk7CrZFSoblmbXNecglbBOgpPrfWZnLdtnF6TX8VvLhPahTqzmjC7nj1J
         +sp70P7U9gcjsTOFa0CQUAEgJRSzscNY2fJWFCxYgjehmDgUml+0tvkVDMKeDmAAGO
         HX2GhokPHZXIonxOwiB8qwB3b0rtbZw8R+Doj6D3V8hrejiwfGfXXGr5p0Zs/W1uKe
         LgUlmwvo5MGl5M1to1ZX1mQg4kkDiT+KTp1TS6eAk7MnmbFfxMMxZXAZruy8TTSxYY
         c0FfbTWCl7PbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Use select queue parameters to sync with control flow
Date:   Mon, 14 Feb 2022 22:32:24 -0800
Message-Id: <20220215063229.737960-11-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Start using the select queue parameters introduced in the previous
commit to have proper synchronization with changing the configuration
(such as number of channels and queues). It ensures that the state that
mlx5e_select_queue() sees is always consistent and stays the same while
the function is running. Also it allows mlx5e_select_queue to stop using
data structures that weren't synchronized properly: txq2sq,
channel_tc2realtxq, port_ptp_tc2realtxq. The last two are removed
completely, as they were used only in mlx5e_select_queue.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 --
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 52 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 39 +-------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  5 --
 5 files changed, 32 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e1c2f296867a..e29ac77e9bec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -911,8 +911,6 @@ struct mlx5e_priv {
 	/* priv data path fields - start */
 	struct mlx5e_selq selq;
 	struct mlx5e_txqsq **txq2sq;
-	int **channel_tc2realtxq;
-	int port_ptp_tc2realtxq[MLX5E_MAX_NUM_TC];
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx_dp       dcbx_dp;
 #endif
@@ -955,7 +953,6 @@ struct mlx5e_priv {
 	u16                        drop_rq_q_counter;
 	struct notifier_block      events_nb;
 	struct notifier_block      blocking_events_nb;
-	int                        num_tc_x_num_ch;
 
 	struct udp_tunnel_nic_info nic_info;
 #ifdef CONFIG_MLX5_CORE_EN_DCB
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index ccfc8ae2fa71..9db677e9ca9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -549,11 +549,15 @@ int mlx5e_htb_root_del(struct mlx5e_priv *priv)
 
 	qos_dbg(priv->mdev, "TC_HTB_DESTROY\n");
 
+	/* Wait until real_num_tx_queues is updated for mlx5e_select_queue,
+	 * so that we can safely switch to its non-HTB non-PTP fastpath.
+	 */
+	synchronize_net();
+
 	mlx5e_selq_prepare(&priv->selq, &priv->channels.params, false);
 	mlx5e_selq_apply(&priv->selq);
 
 	WRITE_ONCE(priv->htb.maj_id, 0);
-	synchronize_rcu(); /* Sync with mlx5e_select_htb_queue and TX data path. */
 
 	root = mlx5e_sw_node_find(priv, MLX5E_HTB_CLASSID_ROOT);
 	if (!root) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index 297ba7946753..a0bed47fd392 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -4,6 +4,7 @@
 #include "selq.h"
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/rcupdate.h>
 #include "en.h"
 #include "en/ptp.h"
 
@@ -109,12 +110,13 @@ static int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb)
 }
 #endif
 
-static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
+static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb,
+			      struct mlx5e_selq_params *selq)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	int up = 0;
 
-	if (!netdev_get_num_tc(dev))
+	if (selq->num_tcs <= 1)
 		goto return_txq;
 
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -126,15 +128,15 @@ static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
 			up = skb_vlan_tag_get_prio(skb);
 
 return_txq:
-	return priv->port_ptp_tc2realtxq[up];
+	return selq->num_regular_queues + up;
 }
 
-static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
-				  u16 htb_maj_id)
+static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb)
 {
 	u16 classid;
 
-	if ((TC_H_MAJ(skb->priority) >> 16) == htb_maj_id)
+	/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
+	if ((TC_H_MAJ(skb->priority) >> 16) == smp_load_acquire(&priv->htb.maj_id))
 		classid = TC_H_MIN(skb->priority);
 	else
 		classid = READ_ONCE(priv->htb.defcls);
@@ -149,30 +151,28 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	int num_tc_x_num_ch;
+	struct mlx5e_selq_params *selq;
 	int txq_ix;
 	int up = 0;
-	int ch_ix;
 
-	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
-	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
-	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
-		struct mlx5e_ptp *ptp_channel;
+	selq = rcu_dereference_bh(priv->selq.active);
 
-		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
-		u16 htb_maj_id = smp_load_acquire(&priv->htb.maj_id);
+	/* This is a workaround needed only for the mlx5e_netdev_change_profile
+	 * flow that zeroes out the whole priv without unregistering the netdev
+	 * and without preventing ndo_select_queue from being called.
+	 */
+	if (unlikely(!selq))
+		return 0;
 
-		if (unlikely(htb_maj_id)) {
-			txq_ix = mlx5e_select_htb_queue(priv, skb, htb_maj_id);
+	if (unlikely(selq->is_ptp || selq->is_htb)) {
+		if (unlikely(selq->is_htb)) {
+			txq_ix = mlx5e_select_htb_queue(priv, skb);
 			if (txq_ix > 0)
 				return txq_ix;
 		}
 
-		ptp_channel = READ_ONCE(priv->channels.ptp);
-		if (unlikely(ptp_channel &&
-			     test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
-			     mlx5e_use_ptpsq(skb)))
-			return mlx5e_select_ptpsq(dev, skb);
+		if (unlikely(selq->is_ptp && mlx5e_use_ptpsq(skb)))
+			return mlx5e_select_ptpsq(dev, skb, selq);
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
 		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
@@ -180,13 +180,13 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		 * Driver to select these queues only at mlx5e_select_ptpsq()
 		 * and mlx5e_select_htb_queue().
 		 */
-		if (unlikely(txq_ix >= num_tc_x_num_ch))
-			txq_ix %= num_tc_x_num_ch;
+		if (unlikely(txq_ix >= selq->num_regular_queues))
+			txq_ix %= selq->num_regular_queues;
 	} else {
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
 	}
 
-	if (!netdev_get_num_tc(dev))
+	if (selq->num_tcs <= 1)
 		return txq_ix;
 
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -201,7 +201,5 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	 * So we can return a txq_ix that matches the channel and
 	 * packet UP.
 	 */
-	ch_ix = priv->txq2sq[txq_ix]->ch_ix;
-
-	return priv->channel_tc2realtxq[ch_ix][up];
+	return txq_ix % selq->num_channels + up * selq->num_channels;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 02f0ad653ece..b157c7aac4ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2683,7 +2683,6 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 			struct mlx5e_txqsq *sq = &c->sq[tc];
 
 			priv->txq2sq[sq->txq_ix] = sq;
-			priv->channel_tc2realtxq[i][tc] = i + tc * ch;
 		}
 	}
 
@@ -2698,7 +2697,6 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 		struct mlx5e_txqsq *sq = &c->ptpsq[tc].txqsq;
 
 		priv->txq2sq[sq->txq_ix] = sq;
-		priv->port_ptp_tc2realtxq[tc] = priv->num_tc_x_num_ch + tc;
 	}
 
 out:
@@ -2709,16 +2707,8 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 	smp_wmb();
 }
 
-static void mlx5e_update_num_tc_x_num_ch(struct mlx5e_priv *priv)
-{
-	/* Sync with mlx5e_select_queue. */
-	WRITE_ONCE(priv->num_tc_x_num_ch,
-		   mlx5e_get_dcb_num_tc(&priv->channels.params) * priv->channels.num);
-}
-
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
-	mlx5e_update_num_tc_x_num_ch(priv);
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_qos_activate_queues(priv);
@@ -4673,11 +4663,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 				     priv->max_nch);
 	mlx5e_params_mqprio_reset(params);
 
-	/* Set an initial non-zero value, so that mlx5e_select_queue won't
-	 * divide by zero if called before first activating channels.
-	 */
-	priv->num_tc_x_num_ch = params->num_channels * params->mqprio.num_tc;
-
 	/* SQ */
 	params->log_sq_size = is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE :
@@ -5230,7 +5215,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    struct net_device *netdev,
 		    struct mlx5_core_dev *mdev)
 {
-	int nch, num_txqs, node, i;
+	int nch, num_txqs, node;
 	int err;
 
 	num_txqs = netdev->num_tx_queues;
@@ -5271,30 +5256,13 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (!priv->tx_rates)
 		goto err_free_txq2sq;
 
-	priv->channel_tc2realtxq =
-		kcalloc_node(nch, sizeof(*priv->channel_tc2realtxq), GFP_KERNEL, node);
-	if (!priv->channel_tc2realtxq)
-		goto err_free_tx_rates;
-
-	for (i = 0; i < nch; i++) {
-		priv->channel_tc2realtxq[i] =
-			kcalloc_node(profile->max_tc, sizeof(**priv->channel_tc2realtxq),
-				     GFP_KERNEL, node);
-		if (!priv->channel_tc2realtxq[i])
-			goto err_free_channel_tc2realtxq;
-	}
-
 	priv->channel_stats =
 		kcalloc_node(nch, sizeof(*priv->channel_stats), GFP_KERNEL, node);
 	if (!priv->channel_stats)
-		goto err_free_channel_tc2realtxq;
+		goto err_free_tx_rates;
 
 	return 0;
 
-err_free_channel_tc2realtxq:
-	while (--i >= 0)
-		kfree(priv->channel_tc2realtxq[i]);
-	kfree(priv->channel_tc2realtxq);
 err_free_tx_rates:
 	kfree(priv->tx_rates);
 err_free_txq2sq:
@@ -5319,9 +5287,6 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	for (i = 0; i < priv->stats_nch; i++)
 		kvfree(priv->channel_stats[i]);
 	kfree(priv->channel_stats);
-	for (i = 0; i < priv->max_nch; i++)
-		kfree(priv->channel_tc2realtxq[i]);
-	kfree(priv->channel_tc2realtxq);
 	kfree(priv->tx_rates);
 	kfree(priv->txq2sq);
 	destroy_workqueue(priv->wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 06d1f46f1688..a3f257623af4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -632,11 +632,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
 
-	/* Set an initial non-zero value, so that mlx5e_select_queue won't
-	 * divide by zero if called before first activating channels.
-	 */
-	priv->num_tc_x_num_ch = params->num_channels * params->mqprio.num_tc;
-
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 }
 
-- 
2.34.1

