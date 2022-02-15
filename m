Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC62C4B6388
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiBOGdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiBOGcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF376B1530
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 827B16151F
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D5C340EC;
        Tue, 15 Feb 2022 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906761;
        bh=v7VcsXmsz30mByOiTKRHdnUHwHr8Ke2ob//WrufEHLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg3JJQ5tRvZwdkeYBn47mIoAIe/bQXEM7PPKCWzNN8LMD5iwL7erOOl19HzRr7ACV
         NXpaTSXil6re0/uhvZwnSjocJ4MtfeQaXAmXKdEQtaP3czDgpo5tl9C2ieuuabTpIb
         X1dvWlXQWnK+g1FDM11Wfy8IR8ra3Zt/C90EA9hOij6Rwi+Avb4VvH594WszMc2Cqj
         0jB1aBtBVZZGfzYE/sj3i2afRTVdCTqSjba7q2/+8LR2DRR6KERNxfHrEPq2sxRoPI
         vBuubb09NxwbgYsFsgJeCLmup41uLJjdjLpR5NiP4y7D+VtXKYNWTwZIOGJu5Mq749
         iIURQoQuX8+4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Move mlx5e_select_queue to en/selq.c
Date:   Mon, 14 Feb 2022 22:32:23 -0800
Message-Id: <20220215063229.737960-10-saeed@kernel.org>
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

This commit moves mlx5e_select_queue and all stuff related to
ndo_select_queue to en/selq.c to put all stuff working with selq into a
separate file.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 112 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/selq.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   2 -
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 111 -----------------
 4 files changed, 117 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index 50ea58a3cc94..297ba7946753 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -5,6 +5,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include "en.h"
+#include "en/ptp.h"
 
 struct mlx5e_selq_params {
 	unsigned int num_regular_queues;
@@ -93,3 +94,114 @@ void mlx5e_selq_cancel(struct mlx5e_selq *selq)
 
 	selq->is_prepared = false;
 }
+
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+static int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb)
+{
+	int dscp_cp = 0;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		dscp_cp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		dscp_cp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
+
+	return priv->dcbx_dp.dscp2prio[dscp_cp];
+}
+#endif
+
+static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	int up = 0;
+
+	if (!netdev_get_num_tc(dev))
+		goto return_txq;
+
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
+		up = mlx5e_get_dscp_up(priv, skb);
+	else
+#endif
+		if (skb_vlan_tag_present(skb))
+			up = skb_vlan_tag_get_prio(skb);
+
+return_txq:
+	return priv->port_ptp_tc2realtxq[up];
+}
+
+static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
+				  u16 htb_maj_id)
+{
+	u16 classid;
+
+	if ((TC_H_MAJ(skb->priority) >> 16) == htb_maj_id)
+		classid = TC_H_MIN(skb->priority);
+	else
+		classid = READ_ONCE(priv->htb.defcls);
+
+	if (!classid)
+		return 0;
+
+	return mlx5e_get_txq_by_classid(priv, classid);
+}
+
+u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
+		       struct net_device *sb_dev)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	int num_tc_x_num_ch;
+	int txq_ix;
+	int up = 0;
+	int ch_ix;
+
+	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
+	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
+	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
+		struct mlx5e_ptp *ptp_channel;
+
+		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
+		u16 htb_maj_id = smp_load_acquire(&priv->htb.maj_id);
+
+		if (unlikely(htb_maj_id)) {
+			txq_ix = mlx5e_select_htb_queue(priv, skb, htb_maj_id);
+			if (txq_ix > 0)
+				return txq_ix;
+		}
+
+		ptp_channel = READ_ONCE(priv->channels.ptp);
+		if (unlikely(ptp_channel &&
+			     test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
+			     mlx5e_use_ptpsq(skb)))
+			return mlx5e_select_ptpsq(dev, skb);
+
+		txq_ix = netdev_pick_tx(dev, skb, NULL);
+		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
+		 * If they are selected, switch to regular queues.
+		 * Driver to select these queues only at mlx5e_select_ptpsq()
+		 * and mlx5e_select_htb_queue().
+		 */
+		if (unlikely(txq_ix >= num_tc_x_num_ch))
+			txq_ix %= num_tc_x_num_ch;
+	} else {
+		txq_ix = netdev_pick_tx(dev, skb, NULL);
+	}
+
+	if (!netdev_get_num_tc(dev))
+		return txq_ix;
+
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
+		up = mlx5e_get_dscp_up(priv, skb);
+	else
+#endif
+		if (skb_vlan_tag_present(skb))
+			up = skb_vlan_tag_get_prio(skb);
+
+	/* Normalize any picked txq_ix to [0, num_channels),
+	 * So we can return a txq_ix that matches the channel and
+	 * packet UP.
+	 */
+	ch_ix = priv->txq2sq[txq_ix]->ch_ix;
+
+	return priv->channel_tc2realtxq[ch_ix][up];
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
index 2648c23e8238..b1c73b509f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
@@ -16,6 +16,8 @@ struct mlx5e_selq {
 };
 
 struct mlx5e_params;
+struct net_device;
+struct sk_buff;
 
 int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock);
 void mlx5e_selq_cleanup(struct mlx5e_selq *selq);
@@ -23,4 +25,7 @@ void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bo
 void mlx5e_selq_apply(struct mlx5e_selq *selq);
 void mlx5e_selq_cancel(struct mlx5e_selq *selq);
 
+u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
+		       struct net_device *sb_dev);
+
 #endif /* __MLX5_EN_SELQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 1c48cfad9dd7..210d23bf3701 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -55,8 +55,6 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
 void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
 
 /* TX */
-u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
-		       struct net_device *sb_dev);
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 726661774979..2dc48406cd08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -53,117 +53,6 @@ static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 	}
 }
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-static inline int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb)
-{
-	int dscp_cp = 0;
-
-	if (skb->protocol == htons(ETH_P_IP))
-		dscp_cp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
-	else if (skb->protocol == htons(ETH_P_IPV6))
-		dscp_cp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
-
-	return priv->dcbx_dp.dscp2prio[dscp_cp];
-}
-#endif
-
-static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	int up = 0;
-
-	if (!netdev_get_num_tc(dev))
-		goto return_txq;
-
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
-		up = mlx5e_get_dscp_up(priv, skb);
-	else
-#endif
-		if (skb_vlan_tag_present(skb))
-			up = skb_vlan_tag_get_prio(skb);
-
-return_txq:
-	return priv->port_ptp_tc2realtxq[up];
-}
-
-static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
-				  u16 htb_maj_id)
-{
-	u16 classid;
-
-	if ((TC_H_MAJ(skb->priority) >> 16) == htb_maj_id)
-		classid = TC_H_MIN(skb->priority);
-	else
-		classid = READ_ONCE(priv->htb.defcls);
-
-	if (!classid)
-		return 0;
-
-	return mlx5e_get_txq_by_classid(priv, classid);
-}
-
-u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
-		       struct net_device *sb_dev)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	int num_tc_x_num_ch;
-	int txq_ix;
-	int up = 0;
-	int ch_ix;
-
-	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
-	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
-	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
-		struct mlx5e_ptp *ptp_channel;
-
-		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
-		u16 htb_maj_id = smp_load_acquire(&priv->htb.maj_id);
-
-		if (unlikely(htb_maj_id)) {
-			txq_ix = mlx5e_select_htb_queue(priv, skb, htb_maj_id);
-			if (txq_ix > 0)
-				return txq_ix;
-		}
-
-		ptp_channel = READ_ONCE(priv->channels.ptp);
-		if (unlikely(ptp_channel &&
-			     test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
-			     mlx5e_use_ptpsq(skb)))
-			return mlx5e_select_ptpsq(dev, skb);
-
-		txq_ix = netdev_pick_tx(dev, skb, NULL);
-		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
-		 * If they are selected, switch to regular queues.
-		 * Driver to select these queues only at mlx5e_select_ptpsq()
-		 * and mlx5e_select_htb_queue().
-		 */
-		if (unlikely(txq_ix >= num_tc_x_num_ch))
-			txq_ix %= num_tc_x_num_ch;
-	} else {
-		txq_ix = netdev_pick_tx(dev, skb, NULL);
-	}
-
-	if (!netdev_get_num_tc(dev))
-		return txq_ix;
-
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
-		up = mlx5e_get_dscp_up(priv, skb);
-	else
-#endif
-		if (skb_vlan_tag_present(skb))
-			up = skb_vlan_tag_get_prio(skb);
-
-	/* Normalize any picked txq_ix to [0, num_channels),
-	 * So we can return a txq_ix that matches the channel and
-	 * packet UP.
-	 */
-	ch_ix = priv->txq2sq[txq_ix]->ch_ix;
-
-	return priv->channel_tc2realtxq[ch_ix][up];
-}
-
 static inline int mlx5e_skb_l2_header_offset(struct sk_buff *skb)
 {
 #define MLX5E_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
-- 
2.34.1

