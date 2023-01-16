Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B5A66D028
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbjAPUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbjAPUZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:18 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2C27D57
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SWtVsZlK7rr7TnwT52Q8IscGuQrcfZFDq2noH7/T/Ro=; b=ctFf3LUp9MFFrtq9UtgEzuOYZs
        lhT+YmvSB5Kreig661dI2P++cMdUTn780T7UjXIFUSKaVcVL1yKRPIH5FUzCKJOJlODGlTJp6jQAr
        J6bUTIN5MVOx0VwWKqQqHdOgcR6bzhHy6dozv4J/uKAWzENEZibCqdsBccvu2lG9hsC4=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2b-00018Q-BJ; Mon, 16 Jan 2023 21:25:13 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 7/9] tsnep: Add RX queue info for XDP support
Date:   Mon, 16 Jan 2023 21:24:56 +0100
Message-Id: <20230116202458.56677-8-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register xdp_rxq_info with page_pool memory model. This is needed for
XDP buffer handling.

Additionally fix error path by removing call of tsnep_phy_close() after
failed tsnep_phy_open().

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  2 +
 drivers/net/ethernet/engleder/tsnep_main.c | 74 ++++++++++++++++------
 2 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index bd0fbddd3a75..c9bfe6ff3add 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -125,6 +125,8 @@ struct tsnep_rx {
 	u32 dropped;
 	u32 multicast;
 	u32 alloc_failed;
+
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct tsnep_queue {
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 45e576e74510..90dda7ca033b 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1205,17 +1205,64 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
 	memset(queue->name, 0, sizeof(queue->name));
 }
 
+static void tsnep_queue_close(struct tsnep_queue *queue, bool first)
+{
+	struct tsnep_rx *rx = queue->rx;
+
+	tsnep_free_irq(queue, first);
+
+	if (rx && xdp_rxq_info_is_reg(&rx->xdp_rxq))
+		xdp_rxq_info_unreg(&rx->xdp_rxq);
+
+	netif_napi_del(&queue->napi);
+}
+
+static int tsnep_queue_open(struct tsnep_adapter *adapter,
+			    struct tsnep_queue *queue, bool first)
+{
+	struct tsnep_rx *rx = queue->rx;
+	int retval;
+
+	queue->adapter = adapter;
+
+	netif_napi_add(adapter->netdev, &queue->napi, tsnep_poll);
+
+	if (rx) {
+		retval = xdp_rxq_info_reg(&rx->xdp_rxq, adapter->netdev,
+					  rx->queue_index, queue->napi.napi_id);
+		if (retval)
+			goto failed;
+		retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq,
+						    MEM_TYPE_PAGE_POOL,
+						    rx->page_pool);
+		if (retval)
+			goto failed;
+	}
+
+	retval = tsnep_request_irq(queue, first);
+	if (retval) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "can't get assigned irq %d.\n", queue->irq);
+		goto failed;
+	}
+
+	return 0;
+
+failed:
+	tsnep_queue_close(queue, first);
+
+	return retval;
+}
+
 static int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
-	int i;
-	void __iomem *addr;
 	int tx_queue_index = 0;
 	int rx_queue_index = 0;
-	int retval;
+	void __iomem *addr;
+	int i, retval;
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		adapter->queue[i].adapter = adapter;
 		if (adapter->queue[i].tx) {
 			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
 			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
@@ -1226,21 +1273,16 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		}
 		if (adapter->queue[i].rx) {
 			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
-			retval = tsnep_rx_open(adapter, addr,
-					       rx_queue_index,
+			retval = tsnep_rx_open(adapter, addr, rx_queue_index,
 					       adapter->queue[i].rx);
 			if (retval)
 				goto failed;
 			rx_queue_index++;
 		}
 
-		retval = tsnep_request_irq(&adapter->queue[i], i == 0);
-		if (retval) {
-			netif_err(adapter, drv, adapter->netdev,
-				  "can't get assigned irq %d.\n",
-				  adapter->queue[i].irq);
+		retval = tsnep_queue_open(adapter, &adapter->queue[i], i == 0);
+		if (retval)
 			goto failed;
-		}
 	}
 
 	retval = netif_set_real_num_tx_queues(adapter->netdev,
@@ -1258,8 +1300,6 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		goto phy_failed;
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
-			       tsnep_poll);
 		napi_enable(&adapter->queue[i].napi);
 
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
@@ -1269,10 +1309,9 @@ static int tsnep_netdev_open(struct net_device *netdev)
 
 phy_failed:
 	tsnep_disable_irq(adapter, ECM_INT_LINK);
-	tsnep_phy_close(adapter);
 failed:
 	for (i = 0; i < adapter->num_queues; i++) {
-		tsnep_free_irq(&adapter->queue[i], i == 0);
+		tsnep_queue_close(&adapter->queue[i], i == 0);
 
 		if (adapter->queue[i].rx)
 			tsnep_rx_close(adapter->queue[i].rx);
@@ -1294,9 +1333,8 @@ static int tsnep_netdev_close(struct net_device *netdev)
 		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
 
 		napi_disable(&adapter->queue[i].napi);
-		netif_napi_del(&adapter->queue[i].napi);
 
-		tsnep_free_irq(&adapter->queue[i], i == 0);
+		tsnep_queue_close(&adapter->queue[i], i == 0);
 
 		if (adapter->queue[i].rx)
 			tsnep_rx_close(adapter->queue[i].rx);
-- 
2.30.2

