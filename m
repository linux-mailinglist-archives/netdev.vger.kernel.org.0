Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48E96E6CA1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjDRTFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjDRTFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:05:12 -0400
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2085119A2;
        Tue, 18 Apr 2023 12:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sHG7eKHOGlhbX+itEpVQzN56tSLlKCi9X0wz/QHvjn8=; b=AUJIbTcb31Bg143XQf9i6zbokW
        50VC6dci8gMhb7KFO2bYhdykXkxD/n+6Mo+Mt6AyKJrVetGX9WLiJRi+XbnFEjntuw1y9Gg/p1Vqv
        M59qL7Q+lYjzRGtsni8x7OWOqfk6zwPTWf9/RIJWj4vt2BQGtMCNro7AWbsnNSeBdK0k=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poqdZ-0002eV-8e; Tue, 18 Apr 2023 21:05:09 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 6/6] tsnep: Add XDP socket zero-copy TX support
Date:   Tue, 18 Apr 2023 21:04:59 +0200
Message-Id: <20230418190459.19326-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418190459.19326-1-gerhard@engleder-embedded.com>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send and complete XSK pool frames within TX NAPI context. NAPI context
is triggered by ndo_xsk_wakeup.

Test results with A53 1.2GHz:

xdpsock txonly copy mode:
                   pps            pkts           1.00
tx                 284,409        11,398,144
Two CPUs with 100% and 10% utilization.

xdpsock txonly zero-copy mode:
                   pps            pkts           1.00
tx                 511,929        5,890,368
Two CPUs with 100% and 1% utilization.

Packet rate increases and CPU utilization is reduced.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |   2 +
 drivers/net/ethernet/engleder/tsnep_main.c | 127 +++++++++++++++++++--
 2 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index d0bea605a1d1..11b29f56aaf9 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -70,6 +70,7 @@ struct tsnep_tx_entry {
 	union {
 		struct sk_buff *skb;
 		struct xdp_frame *xdpf;
+		bool zc;
 	};
 	size_t len;
 	DEFINE_DMA_UNMAP_ADDR(dma);
@@ -88,6 +89,7 @@ struct tsnep_tx {
 	int read;
 	u32 owner_counter;
 	int increment_owner_counter;
+	struct xsk_buff_pool *xsk_pool;
 
 	u32 packets;
 	u32 bytes;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 1793ce7ed404..84751bb303a6 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -54,6 +54,8 @@
 #define TSNEP_TX_TYPE_SKB_FRAG	BIT(1)
 #define TSNEP_TX_TYPE_XDP_TX	BIT(2)
 #define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
+#define TSNEP_TX_TYPE_XDP	(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
+#define TSNEP_TX_TYPE_XSK	BIT(4)
 
 #define TSNEP_XDP_TX		BIT(0)
 #define TSNEP_XDP_REDIRECT	BIT(1)
@@ -322,13 +324,47 @@ static void tsnep_tx_init(struct tsnep_tx *tx)
 	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
 }
 
+static void tsnep_tx_enable(struct tsnep_tx *tx)
+{
+	struct netdev_queue *nq;
+
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
+
+	__netif_tx_lock_bh(nq);
+	netif_tx_wake_queue(nq);
+	__netif_tx_unlock_bh(nq);
+}
+
+static void tsnep_tx_disable(struct tsnep_tx *tx, struct napi_struct *napi)
+{
+	struct netdev_queue *nq;
+	u32 val;
+
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
+
+	__netif_tx_lock_bh(nq);
+	netif_tx_stop_queue(nq);
+	__netif_tx_unlock_bh(nq);
+
+	/* wait until TX is done in hardware */
+	readx_poll_timeout(ioread32, tx->addr + TSNEP_CONTROL, val,
+			   ((val & TSNEP_CONTROL_TX_ENABLE) == 0), 10000,
+			   1000000);
+
+	/* wait until TX is also done in software */
+	while (READ_ONCE(tx->read) != tx->write) {
+		napi_schedule(napi);
+		napi_synchronize(napi);
+	}
+}
+
 static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 			      bool last)
 {
 	struct tsnep_tx_entry *entry = &tx->entry[index];
 
 	entry->properties = 0;
-	/* xdpf is union with skb */
+	/* xdpf and zc are union with skb */
 	if (entry->skb) {
 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
@@ -646,10 +682,69 @@ static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
 	return xmit;
 }
 
+static int tsnep_xdp_tx_map_zc(struct xdp_desc *xdpd, struct tsnep_tx *tx)
+{
+	struct tsnep_tx_entry *entry;
+	dma_addr_t dma;
+
+	entry = &tx->entry[tx->write];
+	entry->zc = true;
+
+	dma = xsk_buff_raw_get_dma(tx->xsk_pool, xdpd->addr);
+	xsk_buff_raw_dma_sync_for_device(tx->xsk_pool, dma, xdpd->len);
+
+	entry->type = TSNEP_TX_TYPE_XSK;
+	entry->len = xdpd->len;
+
+	entry->desc->tx = __cpu_to_le64(dma);
+
+	return xdpd->len;
+}
+
+static void tsnep_xdp_xmit_frame_ring_zc(struct xdp_desc *xdpd,
+					 struct tsnep_tx *tx)
+{
+	int length;
+
+	length = tsnep_xdp_tx_map_zc(xdpd, tx);
+
+	tsnep_tx_activate(tx, tx->write, length, true);
+	tx->write = (tx->write + 1) & TSNEP_RING_MASK;
+}
+
+static void tsnep_xdp_xmit_zc(struct tsnep_tx *tx)
+{
+	int desc_available = tsnep_tx_desc_available(tx);
+	struct xdp_desc *descs = tx->xsk_pool->tx_descs;
+	int batch, i;
+
+	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
+	 * will be available for normal TX path and queue is stopped there if
+	 * necessary
+	 */
+	if (desc_available <= (MAX_SKB_FRAGS + 1))
+		return;
+	desc_available -= MAX_SKB_FRAGS + 1;
+
+	batch = xsk_tx_peek_release_desc_batch(tx->xsk_pool, desc_available);
+	for (i = 0; i < batch; i++)
+		tsnep_xdp_xmit_frame_ring_zc(&descs[i], tx);
+
+	if (batch) {
+		/* descriptor properties shall be valid before hardware is
+		 * notified
+		 */
+		dma_wmb();
+
+		tsnep_xdp_xmit_flush(tx);
+	}
+}
+
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
 	struct tsnep_tx_entry *entry;
 	struct netdev_queue *nq;
+	int xsk_frames = 0;
 	int budget = 128;
 	int length;
 	int count;
@@ -676,7 +771,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
 		    skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
-		else if (!(entry->type & TSNEP_TX_TYPE_SKB) &&
+		else if ((entry->type & TSNEP_TX_TYPE_XDP) &&
 			 xdp_frame_has_frags(entry->xdpf))
 			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
 
@@ -705,9 +800,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 		if (entry->type & TSNEP_TX_TYPE_SKB)
 			napi_consume_skb(entry->skb, napi_budget);
-		else
+		else if (entry->type & TSNEP_TX_TYPE_XDP)
 			xdp_return_frame_rx_napi(entry->xdpf);
-		/* xdpf is union with skb */
+		else
+			xsk_frames++;
+		/* xdpf and zc are union with skb */
 		entry->skb = NULL;
 
 		tx->read = (tx->read + count) & TSNEP_RING_MASK;
@@ -718,6 +815,14 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		budget--;
 	} while (likely(budget));
 
+	if (tx->xsk_pool) {
+		if (xsk_frames)
+			xsk_tx_completed(tx->xsk_pool, xsk_frames);
+		if (xsk_uses_need_wakeup(tx->xsk_pool))
+			xsk_set_tx_need_wakeup(tx->xsk_pool);
+		tsnep_xdp_xmit_zc(tx);
+	}
+
 	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
 	    netif_tx_queue_stopped(nq)) {
 		netif_tx_wake_queue(nq);
@@ -765,12 +870,6 @@ static int tsnep_tx_open(struct tsnep_tx *tx)
 
 static void tsnep_tx_close(struct tsnep_tx *tx)
 {
-	u32 val;
-
-	readx_poll_timeout(ioread32, tx->addr + TSNEP_CONTROL, val,
-			   ((val & TSNEP_CONTROL_TX_ENABLE) == 0), 10000,
-			   1000000);
-
 	tsnep_tx_ring_cleanup(tx);
 }
 
@@ -1786,12 +1885,18 @@ static void tsnep_queue_enable(struct tsnep_queue *queue)
 	napi_enable(&queue->napi);
 	tsnep_enable_irq(queue->adapter, queue->irq_mask);
 
+	if (queue->tx)
+		tsnep_tx_enable(queue->tx);
+
 	if (queue->rx)
 		tsnep_rx_enable(queue->rx);
 }
 
 static void tsnep_queue_disable(struct tsnep_queue *queue)
 {
+	if (queue->tx)
+		tsnep_tx_disable(queue->tx, &queue->napi);
+
 	napi_disable(&queue->napi);
 	tsnep_disable_irq(queue->adapter, queue->irq_mask);
 
@@ -1908,6 +2013,7 @@ int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool)
 	if (running)
 		tsnep_queue_disable(queue);
 
+	queue->tx->xsk_pool = pool;
 	queue->rx->xsk_pool = pool;
 
 	if (running) {
@@ -1928,6 +2034,7 @@ void tsnep_disable_xsk(struct tsnep_queue *queue)
 	tsnep_rx_free_zc(queue->rx);
 
 	queue->rx->xsk_pool = NULL;
+	queue->tx->xsk_pool = NULL;
 
 	if (running) {
 		tsnep_rx_reopen(queue->rx);
-- 
2.30.2

