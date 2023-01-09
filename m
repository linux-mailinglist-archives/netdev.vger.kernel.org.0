Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8D663022
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbjAITPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbjAITPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:34 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D7B6586
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4lSEEZgvezluv7THt4tyd4eda3/RENr7f7buua+5xjg=; b=NkRkvOrOUk1HseqezenMELSSvd
        G2xdReHHgkFCJVIqQiCHSxo7zwxn508PQTaATA1yVBLN5NlDWyALz9eFvQul1rtfRJeJrlmSE6lUm
        pX12C9E40gqdHVw9DmYslOFOonLI88TK2xMdpLGF9bJNNS97ZTrERgBD0P820u0U1984=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcK-0007WQ-8X; Mon, 09 Jan 2023 20:15:32 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net-next v4 08/10] tsnep: Add RX queue info for XDP support
Date:   Mon,  9 Jan 2023 20:15:21 +0100
Message-Id: <20230109191523.12070-9-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register xdp_rxq_info with page_pool memory model. This is needed for
XDP buffer handling.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep.h      |  2 ++
 drivers/net/ethernet/engleder/tsnep_main.c | 39 ++++++++++++++++------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 855738d31d73..2268ff793edf 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -134,6 +134,8 @@ struct tsnep_rx {
 	u32 dropped;
 	u32 multicast;
 	u32 alloc_failed;
+
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct tsnep_queue {
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 0c9669edb2dd..451ad1849b9d 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -792,6 +792,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 		entry->page = NULL;
 	}
 
+	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
+		xdp_rxq_info_unreg(&rx->xdp_rxq);
+
 	if (rx->page_pool)
 		page_pool_destroy(rx->page_pool);
 
@@ -807,7 +810,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_ring_init(struct tsnep_rx *rx)
+static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	struct tsnep_rx_entry *entry;
@@ -850,6 +853,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 		goto failed;
 	}
 
+	retval = xdp_rxq_info_reg(&rx->xdp_rxq, rx->adapter->netdev,
+				  rx->queue_index, napi_id);
+	if (retval)
+		goto failed;
+	retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					    rx->page_pool);
+	if (retval)
+		goto failed;
+
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
 		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
@@ -1104,7 +1116,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 }
 
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 int queue_index, struct tsnep_rx *rx)
+			 unsigned int napi_id, int queue_index,
+			 struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
 	int retval;
@@ -1118,7 +1131,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	else
 		rx->offset = TSNEP_SKB_PAD;
 
-	retval = tsnep_rx_ring_init(rx);
+	retval = tsnep_rx_ring_init(rx, napi_id);
 	if (retval)
 		return retval;
 
@@ -1245,14 +1258,19 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
 static int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
-	int i;
-	void __iomem *addr;
 	int tx_queue_index = 0;
 	int rx_queue_index = 0;
-	int retval;
+	unsigned int napi_id;
+	void __iomem *addr;
+	int i, retval;
 
 	for (i = 0; i < adapter->num_queues; i++) {
 		adapter->queue[i].adapter = adapter;
+
+		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
+			       tsnep_poll);
+		napi_id = adapter->queue[i].napi.napi_id;
+
 		if (adapter->queue[i].tx) {
 			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
 			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
@@ -1263,7 +1281,7 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		}
 		if (adapter->queue[i].rx) {
 			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
-			retval = tsnep_rx_open(adapter, addr,
+			retval = tsnep_rx_open(adapter, addr, napi_id,
 					       rx_queue_index,
 					       adapter->queue[i].rx);
 			if (retval)
@@ -1295,8 +1313,6 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		goto phy_failed;
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
-			       tsnep_poll);
 		napi_enable(&adapter->queue[i].napi);
 
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
@@ -1317,6 +1333,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 	return retval;
 }
@@ -1335,7 +1353,6 @@ static int tsnep_netdev_close(struct net_device *netdev)
 		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
 
 		napi_disable(&adapter->queue[i].napi);
-		netif_napi_del(&adapter->queue[i].napi);
 
 		tsnep_free_irq(&adapter->queue[i], i == 0);
 
@@ -1343,6 +1360,8 @@ static int tsnep_netdev_close(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 
 	return 0;
-- 
2.30.2

