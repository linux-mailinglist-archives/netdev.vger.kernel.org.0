Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53E14B6383
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiBOGdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiBOGct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EA4B1506
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC7A61522
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85673C340F1;
        Tue, 15 Feb 2022 06:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906759;
        bh=Zg83C8t7rW3yK3qRsHoq1tnBJ2Z9zK2+F9DGpEszxp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHFx9xx7MBI0d8vbVMzEcr85MBdsBNRa6L1oI1DHtvSBxu1v8Mr0H74kHZN5tDkqf
         m4iAKs2mPqg0dldixOXpZHcXOsuPQD3ALrpfZfguxDD9MJoOH3Tyk7/plYZwV0ePBS
         84FCF8rTZHycQcRStJPY9GwZY4DRlODceiebqTIuKNxQ/couu9jbZnxfsnSiag6ybs
         TSP7i4hO0ZZ5mqmnFk0zMwd4GHxbxeUeQUTgK63IX/0ujQ/xdLgWxpZ864XjN5EF5N
         7Eijfm5napQumuuSsZqJwC3Xo1sDlejpH3qmUBNG6IdSBchXTW+EShv/+Gcso8pClu
         6rAKy8qo9ATQQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Sync txq2sq updates with mlx5e_xmit for HTB queues
Date:   Mon, 14 Feb 2022 22:32:21 -0800
Message-Id: <20220215063229.737960-8-saeed@kernel.org>
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

This commit makes necessary changes to guarantee that txq2sq remains
stable while mlx5e_xmit is running. Proper synchronization is added for
HTB TX queues.

All updates to txq2sq are performed while the corresponding queue is
disabled (i.e. mlx5e_xmit doesn't run on that queue). smp_wmb after each
change guarantees that mlx5e_xmit can see the updated value after the
queue is enabled. Comments explaining this mechanism are added to
mlx5e_xmit.

When an HTB SQ can be deleted (after deleting an HTB node), synchronize
with RCU to wait for mlx5e_select_queue to finish and stop selecting
that queue, before we re-enable it to avoid TX timeout watchdog alarms.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 24 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 13 ++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index c1e07496c89c..ff45840581e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -50,7 +50,6 @@ static int mlx5e_find_unused_qos_qid(struct mlx5e_priv *priv)
 
 struct mlx5e_qos_node {
 	struct hlist_node hnode;
-	struct rcu_head rcu;
 	struct mlx5e_qos_node *parent;
 	u64 rate;
 	u32 bw_share;
@@ -132,7 +131,11 @@ static void mlx5e_sw_node_delete(struct mlx5e_priv *priv, struct mlx5e_qos_node
 		__clear_bit(node->qid, priv->htb.qos_used_qids);
 		mlx5e_update_tx_netdev_queues(priv);
 	}
-	kfree_rcu(node, rcu);
+	/* Make sure this qid is no longer selected by mlx5e_select_queue, so
+	 * that mlx5e_reactivate_qos_sq can safely restart the netdev TX queue.
+	 */
+	synchronize_net();
+	kfree(node);
 }
 
 /* TX datapath API */
@@ -273,10 +276,18 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 static void mlx5e_activate_qos_sq(struct mlx5e_priv *priv, struct mlx5e_qos_node *node)
 {
 	struct mlx5e_txqsq *sq;
+	u16 qid;
 
 	sq = mlx5e_get_qos_sq(priv, node->qid);
 
-	WRITE_ONCE(priv->txq2sq[mlx5e_qid_from_qos(&priv->channels, node->qid)], sq);
+	qid = mlx5e_qid_from_qos(&priv->channels, node->qid);
+
+	/* If it's a new queue, it will be marked as started at this point.
+	 * Stop it before updating txq2sq.
+	 */
+	mlx5e_tx_disable_queue(netdev_get_tx_queue(priv->netdev, qid));
+
+	priv->txq2sq[qid] = sq;
 
 	/* Make the change to txq2sq visible before the queue is started.
 	 * As mlx5e_xmit runs under a spinlock, there is an implicit ACQUIRE,
@@ -299,8 +310,13 @@ static void mlx5e_deactivate_qos_sq(struct mlx5e_priv *priv, u16 qid)
 	qos_dbg(priv->mdev, "Deactivate QoS SQ qid %u\n", qid);
 	mlx5e_deactivate_txqsq(sq);
 
-	/* The queue is disabled, no synchronization with datapath is needed. */
 	priv->txq2sq[mlx5e_qid_from_qos(&priv->channels, qid)] = NULL;
+
+	/* Make the change to txq2sq visible before the queue is started again.
+	 * As mlx5e_xmit runs under a spinlock, there is an implicit ACQUIRE,
+	 * which pairs with this barrier.
+	 */
+	smp_wmb();
 }
 
 static void mlx5e_close_qos_sq(struct mlx5e_priv *priv, u16 qid)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 9c91ef0e1ed2..726661774979 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -691,8 +691,21 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mlx5e_txqsq *sq;
 	u16 pi;
 
+	/* All changes to txq2sq are performed in sync with mlx5e_xmit, when the
+	 * queue being changed is disabled, and smp_wmb guarantees that the
+	 * changes are visible before mlx5e_xmit tries to read from txq2sq. It
+	 * guarantees that the value of txq2sq[qid] doesn't change while
+	 * mlx5e_xmit is running on queue number qid. smb_wmb is paired with
+	 * HARD_TX_LOCK around ndo_start_xmit, which serves as an ACQUIRE.
+	 */
 	sq = priv->txq2sq[skb_get_queue_mapping(skb)];
 	if (unlikely(!sq)) {
+		/* Two cases when sq can be NULL:
+		 * 1. The HTB node is registered, and mlx5e_select_queue
+		 * selected its queue ID, but the SQ itself is not yet created.
+		 * 2. HTB SQ creation failed. Similar to the previous case, but
+		 * the SQ won't be created.
+		 */
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
-- 
2.34.1

