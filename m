Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23A765DD06
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbjADTmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbjADTlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:45 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D809F6
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cBZjRyHfd+iOLYnFr+PgmWyWmg/hmrC3i+Ir0vFgflc=; b=ryDpqo0FoBBVQbnXClG/lCwCG4
        8Jtt2K0Kk/3y/LLKDlii2O8u2TiVOFcdjK7TT9tljT2z1dsexitYxMm80FpKw8VmAlqO/LeSYZxOg
        prEFGaMjrXtyHbH404kKiBAQDbApLbeiJAfZ6S4YJJj8HRMFsZSN4jbiStIlTtI0cq6U=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9dv-0003c2-2c; Wed, 04 Jan 2023 20:41:43 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net-next v3 8/9] tsnep: Add RX queue info for XDP support
Date:   Wed,  4 Jan 2023 20:41:31 +0100
Message-Id: <20230104194132.24637-9-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230104194132.24637-1-gerhard@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
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
 drivers/net/ethernet/engleder/tsnep.h      |  6 ++--
 drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 0e7fc36a64e1..0210dab90f71 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -133,17 +133,19 @@ struct tsnep_rx {
 	u32 dropped;
 	u32 multicast;
 	u32 alloc_failed;
+
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct tsnep_queue {
 	struct tsnep_adapter *adapter;
 	char name[IFNAMSIZ + 9];
 
+	struct napi_struct napi;
+
 	struct tsnep_tx *tx;
 	struct tsnep_rx *rx;
 
-	struct napi_struct napi;
-
 	int irq;
 	u32 irq_mask;
 	void __iomem *irq_delay_addr;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index b24a00782f27..6a30f3bf73a6 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -802,6 +802,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 		entry->page = NULL;
 	}
 
+	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
+		xdp_rxq_info_unreg(&rx->xdp_rxq);
+
 	if (rx->page_pool)
 		page_pool_destroy(rx->page_pool);
 
@@ -817,7 +820,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_ring_init(struct tsnep_rx *rx)
+static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	struct tsnep_rx_entry *entry;
@@ -860,6 +863,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
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
@@ -1115,7 +1127,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 }
 
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 int queue_index, struct tsnep_rx *rx)
+			 unsigned int napi_id, int queue_index,
+			 struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
 	int retval;
@@ -1125,7 +1138,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	rx->addr = addr;
 	rx->queue_index = queue_index;
 
-	retval = tsnep_rx_ring_init(rx);
+	retval = tsnep_rx_ring_init(rx, napi_id);
 	if (retval)
 		return retval;
 
@@ -1253,6 +1266,7 @@ int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
+	unsigned int napi_id;
 	void __iomem *addr;
 	int tx_queue_index = 0;
 	int rx_queue_index = 0;
@@ -1260,6 +1274,11 @@ int tsnep_netdev_open(struct net_device *netdev)
 
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
@@ -1270,7 +1289,7 @@ int tsnep_netdev_open(struct net_device *netdev)
 		}
 		if (adapter->queue[i].rx) {
 			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
-			retval = tsnep_rx_open(adapter, addr,
+			retval = tsnep_rx_open(adapter, addr, napi_id,
 					       rx_queue_index,
 					       adapter->queue[i].rx);
 			if (retval)
@@ -1302,8 +1321,6 @@ int tsnep_netdev_open(struct net_device *netdev)
 		goto phy_failed;
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
-			       tsnep_poll);
 		napi_enable(&adapter->queue[i].napi);
 
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
@@ -1326,6 +1343,8 @@ int tsnep_netdev_open(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 	return retval;
 }
@@ -1348,7 +1367,6 @@ int tsnep_netdev_close(struct net_device *netdev)
 		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
 
 		napi_disable(&adapter->queue[i].napi);
-		netif_napi_del(&adapter->queue[i].napi);
 
 		tsnep_free_irq(&adapter->queue[i], i == 0);
 
@@ -1356,6 +1374,8 @@ int tsnep_netdev_close(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 
 	return 0;
-- 
2.30.2

