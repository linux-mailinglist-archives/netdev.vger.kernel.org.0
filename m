Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64856E31EB
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDOOnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjDOOnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:43:05 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C972D56;
        Sat, 15 Apr 2023 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7BkLL9a3OK4TKMdRSUMi9WqIatgstE4uD+RtocXQFuA=; b=sLNpXQwSo67m2FNPuVce8Y/XZE
        4bHSf0GB4anm6Q9F2W6NdpCUxduHAse4az74o9QMm1BH4RlItflos3HfCh8BDjWjGt59Gm3rb1sAw
        Y+Lx/FR5kkIJCGu6/NmfwwM770CArXccK05Z2UCA48UuKxkD1pvXKNqsL0oBWVTqwGYM=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pnh7E-0003zN-4C; Sat, 15 Apr 2023 16:43:00 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 2/6] tsnep: Rework TX/RX queue initialization
Date:   Sat, 15 Apr 2023 16:42:52 +0200
Message-Id: <20230415144256.27884-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230415144256.27884-1-gerhard@engleder-embedded.com>
References: <20230415144256.27884-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make initialization of TX and RX queues less dynamic by moving some
initialization from netdev open/close to device probing.

Additionally, move some initialization code to separate functions to
enable future use in other execution paths.

This is done as preparation for queue reconfigure at runtime, which is
necessary for XSK zero-copy support.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 94 ++++++++++++----------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 3d15e673894a..095d36e953fc 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -265,7 +265,7 @@ static void tsnep_tx_ring_cleanup(struct tsnep_tx *tx)
 	}
 }
 
-static int tsnep_tx_ring_init(struct tsnep_tx *tx)
+static int tsnep_tx_ring_create(struct tsnep_tx *tx)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
@@ -288,6 +288,7 @@ static int tsnep_tx_ring_init(struct tsnep_tx *tx)
 			entry->desc = (struct tsnep_tx_desc *)
 				(((u8 *)entry->desc_wb) + TSNEP_DESC_OFFSET);
 			entry->desc_dma = tx->page_dma[i] + TSNEP_DESC_SIZE * j;
+			entry->owner_user_flag = false;
 		}
 	}
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
@@ -303,6 +304,19 @@ static int tsnep_tx_ring_init(struct tsnep_tx *tx)
 	return retval;
 }
 
+static void tsnep_tx_init(struct tsnep_tx *tx)
+{
+	dma_addr_t dma;
+
+	dma = tx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
+	iowrite32(DMA_ADDR_LOW(dma), tx->addr + TSNEP_TX_DESC_ADDR_LOW);
+	iowrite32(DMA_ADDR_HIGH(dma), tx->addr + TSNEP_TX_DESC_ADDR_HIGH);
+	tx->write = 0;
+	tx->read = 0;
+	tx->owner_counter = 1;
+	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+}
+
 static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 			      bool last)
 {
@@ -731,26 +745,15 @@ static bool tsnep_tx_pending(struct tsnep_tx *tx)
 	return pending;
 }
 
-static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 int queue_index, struct tsnep_tx *tx)
+static int tsnep_tx_open(struct tsnep_tx *tx)
 {
-	dma_addr_t dma;
 	int retval;
 
-	memset(tx, 0, sizeof(*tx));
-	tx->adapter = adapter;
-	tx->addr = addr;
-	tx->queue_index = queue_index;
-
-	retval = tsnep_tx_ring_init(tx);
+	retval = tsnep_tx_ring_create(tx);
 	if (retval)
 		return retval;
 
-	dma = tx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
-	iowrite32(DMA_ADDR_LOW(dma), tx->addr + TSNEP_TX_DESC_ADDR_LOW);
-	iowrite32(DMA_ADDR_HIGH(dma), tx->addr + TSNEP_TX_DESC_ADDR_HIGH);
-	tx->owner_counter = 1;
-	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+	tsnep_tx_init(tx);
 
 	return 0;
 }
@@ -795,7 +798,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_ring_init(struct tsnep_rx *rx)
+static int tsnep_rx_ring_create(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	struct tsnep_rx_entry *entry;
@@ -850,6 +853,19 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 	return retval;
 }
 
+static void tsnep_rx_init(struct tsnep_rx *rx)
+{
+	dma_addr_t dma;
+
+	dma = rx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
+	iowrite32(DMA_ADDR_LOW(dma), rx->addr + TSNEP_RX_DESC_ADDR_LOW);
+	iowrite32(DMA_ADDR_HIGH(dma), rx->addr + TSNEP_RX_DESC_ADDR_HIGH);
+	rx->write = 0;
+	rx->read = 0;
+	rx->owner_counter = 1;
+	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+}
+
 static int tsnep_rx_desc_available(struct tsnep_rx *rx)
 {
 	if (rx->read <= rx->write)
@@ -1181,26 +1197,15 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 	return false;
 }
 
-static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 int queue_index, struct tsnep_rx *rx)
+static int tsnep_rx_open(struct tsnep_rx *rx)
 {
-	dma_addr_t dma;
 	int retval;
 
-	memset(rx, 0, sizeof(*rx));
-	rx->adapter = adapter;
-	rx->addr = addr;
-	rx->queue_index = queue_index;
-
-	retval = tsnep_rx_ring_init(rx);
+	retval = tsnep_rx_ring_create(rx);
 	if (retval)
 		return retval;
 
-	dma = rx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
-	iowrite32(DMA_ADDR_LOW(dma), rx->addr + TSNEP_RX_DESC_ADDR_LOW);
-	iowrite32(DMA_ADDR_HIGH(dma), rx->addr + TSNEP_RX_DESC_ADDR_HIGH);
-	rx->owner_counter = 1;
-	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+	tsnep_rx_init(rx);
 
 	tsnep_rx_refill(rx, tsnep_rx_desc_available(rx), false);
 
@@ -1335,8 +1340,6 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 	struct tsnep_tx *tx = queue->tx;
 	int retval;
 
-	queue->adapter = adapter;
-
 	netif_napi_add(adapter->netdev, &queue->napi, tsnep_poll);
 
 	if (rx) {
@@ -1377,27 +1380,18 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 static int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
-	int tx_queue_index = 0;
-	int rx_queue_index = 0;
-	void __iomem *addr;
 	int i, retval;
 
 	for (i = 0; i < adapter->num_queues; i++) {
 		if (adapter->queue[i].tx) {
-			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
-			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
-					       adapter->queue[i].tx);
+			retval = tsnep_tx_open(adapter->queue[i].tx);
 			if (retval)
 				goto failed;
-			tx_queue_index++;
 		}
 		if (adapter->queue[i].rx) {
-			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
-			retval = tsnep_rx_open(adapter, addr, rx_queue_index,
-					       adapter->queue[i].rx);
+			retval = tsnep_rx_open(adapter->queue[i].rx);
 			if (retval)
 				goto failed;
-			rx_queue_index++;
 		}
 
 		retval = tsnep_queue_open(adapter, &adapter->queue[i], i == 0);
@@ -1796,9 +1790,16 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 	adapter->num_tx_queues = 1;
 	adapter->num_rx_queues = 1;
 	adapter->num_queues = 1;
+	adapter->queue[0].adapter = adapter;
 	adapter->queue[0].irq = retval;
 	adapter->queue[0].tx = &adapter->tx[0];
+	adapter->queue[0].tx->adapter = adapter;
+	adapter->queue[0].tx->addr = adapter->addr + TSNEP_QUEUE(0);
+	adapter->queue[0].tx->queue_index = 0;
 	adapter->queue[0].rx = &adapter->rx[0];
+	adapter->queue[0].rx->adapter = adapter;
+	adapter->queue[0].rx->addr = adapter->addr + TSNEP_QUEUE(0);
+	adapter->queue[0].rx->queue_index = 0;
 	adapter->queue[0].irq_mask = irq_mask;
 	adapter->queue[0].irq_delay_addr = adapter->addr + ECM_INT_DELAY;
 	retval = tsnep_set_irq_coalesce(&adapter->queue[0],
@@ -1820,9 +1821,16 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 		adapter->num_tx_queues++;
 		adapter->num_rx_queues++;
 		adapter->num_queues++;
+		adapter->queue[i].adapter = adapter;
 		adapter->queue[i].irq = retval;
 		adapter->queue[i].tx = &adapter->tx[i];
+		adapter->queue[i].tx->adapter = adapter;
+		adapter->queue[i].tx->addr = adapter->addr + TSNEP_QUEUE(i);
+		adapter->queue[i].tx->queue_index = i;
 		adapter->queue[i].rx = &adapter->rx[i];
+		adapter->queue[i].rx->adapter = adapter;
+		adapter->queue[i].rx->addr = adapter->addr + TSNEP_QUEUE(i);
+		adapter->queue[i].rx->queue_index = i;
 		adapter->queue[i].irq_mask =
 			irq_mask << (ECM_INT_TXRX_SHIFT * i);
 		adapter->queue[i].irq_delay_addr =
-- 
2.30.2

