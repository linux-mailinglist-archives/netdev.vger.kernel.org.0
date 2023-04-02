Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3566D3A07
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 21:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDBTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBTix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 15:38:53 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C55A26C;
        Sun,  2 Apr 2023 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v8N64DTYvo2DcqUnz3trG46nswj1D3Ugrl0sqOlbXIw=; b=Xhw3VnusDfNE+VjQ4xhMMZ9R6Y
        R13AmW24lyN5Us2ZFRqYqMDRmEbZe6c9Xd2910Wj+bbS6OUyHkwqpiKm5naQ4ZSDEAaRHxCHksAye
        5FBZh/KvAYbGJDC9LN+929j90CR9cmkA+THRG7IzORzwJr/zdcKg4toGb6XWwWIPYb/I=;
Received: from 88-117-56-218.adsl.highway.telekom.at ([88.117.56.218] helo=hornet.engleder.at)
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pj3XO-0007Gn-ID; Sun, 02 Apr 2023 21:38:50 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/5] tsnep: Rework TX/RX queue initialization
Date:   Sun,  2 Apr 2023 21:38:34 +0200
Message-Id: <20230402193838.54474-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230402193838.54474-1-gerhard@engleder-embedded.com>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 drivers/net/ethernet/engleder/tsnep_main.c | 90 ++++++++++++----------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index ed1b6102cfeb..f2162a25e97c 100644
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
 
@@ -1377,27 +1382,18 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
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
@@ -1798,7 +1794,13 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 	adapter->num_queues = 1;
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
@@ -1822,7 +1824,13 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 		adapter->num_queues++;
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

