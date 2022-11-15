Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2308D629CA3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiKOOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiKOOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:51:27 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E2622500;
        Tue, 15 Nov 2022 06:51:26 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBTdL51DqzmVt7;
        Tue, 15 Nov 2022 22:51:02 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:23 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:23 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mdf@kernel.org>, <romieu@fr.zoreil.com>
CC:     <zhangchangzhong@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 3/3] net: nixge: fix tx queue handling
Date:   Tue, 15 Nov 2022 23:10:24 +0800
Message-ID: <1668525024-38409-4-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the driver check for available space at the beginning of
nixge_start_xmit(), and when there is not enough space for this packet,
it returns NETDEV_TX_OK, which casues packet loss and memory leak.

Instead the queue should be stopped after the packet is added to the BD
when there may not be enough space for next packet. In addition, the
queue should be wakeup only if there is enough space for a packet with
max frags.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 54 +++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 91b7ebc..3776a03 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -457,6 +457,17 @@ static void nixge_tx_skb_unmap(struct nixge_priv *priv,
 	}
 }
 
+static int nixge_check_tx_bd_space(struct nixge_priv *priv,
+				   int num_frag)
+{
+	struct nixge_hw_dma_bd *cur_p;
+
+	cur_p = &priv->tx_bd_v[(priv->tx_bd_tail + num_frag) % TX_BD_NUM];
+	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
+		return NETDEV_TX_BUSY;
+	return 0;
+}
+
 static void nixge_start_xmit_done(struct net_device *ndev)
 {
 	struct nixge_priv *priv = netdev_priv(ndev);
@@ -488,19 +499,13 @@ static void nixge_start_xmit_done(struct net_device *ndev)
 	ndev->stats.tx_packets += packets;
 	ndev->stats.tx_bytes += size;
 
-	if (packets)
-		netif_wake_queue(ndev);
-}
-
-static int nixge_check_tx_bd_space(struct nixge_priv *priv,
-				   int num_frag)
-{
-	struct nixge_hw_dma_bd *cur_p;
+	if (packets) {
+		/* Matches barrier in nixge_start_xmit */
+		smp_mb();
 
-	cur_p = &priv->tx_bd_v[(priv->tx_bd_tail + num_frag) % TX_BD_NUM];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
-		return NETDEV_TX_BUSY;
-	return 0;
+		if (!nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+	}
 }
 
 static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
@@ -518,10 +523,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
 	cur_p = &priv->tx_bd_v[priv->tx_bd_tail];
 	tx_skb = &priv->tx_skb[priv->tx_bd_tail];
 
-	if (nixge_check_tx_bd_space(priv, num_frag + 1)) {
-		if (!netif_queue_stopped(ndev))
-			netif_stop_queue(ndev);
-		return NETDEV_TX_OK;
+	if (unlikely(nixge_check_tx_bd_space(priv, num_frag + 1))) {
+		/* Should not happen as last start_xmit call should have
+		 * checked for sufficient space and queue should only be
+		 * woken when sufficient space is available.
+		 */
+		netif_stop_queue(ndev);
+		if (net_ratelimit())
+			netdev_err(ndev, "BUG! TX Ring full when queue awake!\n");
+		return NETDEV_TX_BUSY;
 	}
 
 	cur_phys = dma_map_single(ndev->dev.parent, skb->data,
@@ -572,6 +582,18 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
 	++priv->tx_bd_tail;
 	priv->tx_bd_tail %= TX_BD_NUM;
 
+	/* Stop queue if next transmit may not have space */
+	if (nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1)) {
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in nixge_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (!nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 frag_err:
 	for (; ii > 0; ii--) {
-- 
2.9.5

