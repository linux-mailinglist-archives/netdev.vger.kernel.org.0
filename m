Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB3A63E0D7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiK3ThY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK3ThT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:37:19 -0500
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2771B8C447
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rSP4FAZ7hlBgt87jcfWI/80+bMqEp/HSxGi0yhRtK7o=; b=tigMiOQ099l1dV5fm7+eqXQtPR
        qfEeWXo+JsLyx3ZyOzsAt3VwlmNkXerhCBCDfCeyadPUrr4ODltW1+Ie/M8zNCK/tn53bC5kcmDVf
        HkSZBPP+SVAO8l12xnKqoAhB3fD8/huETUADrlRYhEUykBN5a2HVJroT40vGUVTn9WfM=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p0StQ-0004tu-9e; Wed, 30 Nov 2022 20:37:16 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 4/4] tsnep: Rework RX buffer allocation
Date:   Wed, 30 Nov 2022 20:37:08 +0100
Message-Id: <20221130193708.70747-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130193708.70747-1-gerhard@engleder-embedded.com>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
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

Refill RX queue in batches of descriptors to improve performance. Refill
is allowed to fail as long as a minimum number of descriptors is active.
Thus, a limited number of failed RX buffer allocations is now allowed
for normal operation. Previously every failed allocation resulted in a
dropped frame.

If the minimum number of active descriptors is reached, then RX buffers
are still reused and frames are dropped. This ensures that the RX queue
never runs empty and always continues to operate.

Prework for future XDP support.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h         |   4 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c    | 203 +++++++++++-------
 3 files changed, 140 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 6bb74dd36544..f93ba48bac3f 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -18,6 +18,8 @@
 #define TSNEP "tsnep"
 
 #define TSNEP_RING_SIZE 256
+#define TSNEP_RING_RX_REFILL 16
+#define TSNEP_RING_RX_REUSE (TSNEP_RING_SIZE - TSNEP_RING_SIZE / 4)
 #define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
 #define TSNEP_RING_PAGE_COUNT (TSNEP_RING_SIZE / TSNEP_RING_ENTRIES_PER_PAGE)
 
@@ -110,6 +112,7 @@ struct tsnep_rx {
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
 
 	struct tsnep_rx_entry entry[TSNEP_RING_SIZE];
+	int write;
 	int read;
 	u32 owner_counter;
 	int increment_owner_counter;
@@ -119,6 +122,7 @@ struct tsnep_rx {
 	u32 bytes;
 	u32 dropped;
 	u32 multicast;
+	u32 alloc_failed;
 };
 
 struct tsnep_queue {
diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index b97ba3544708..716815dad7d2 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -8,6 +8,7 @@ static const char tsnep_stats_strings[][ETH_GSTRING_LEN] = {
 	"rx_bytes",
 	"rx_dropped",
 	"rx_multicast",
+	"rx_alloc_failed",
 	"rx_phy_errors",
 	"rx_forwarded_phy_errors",
 	"rx_invalid_frame_errors",
@@ -21,6 +22,7 @@ struct tsnep_stats {
 	u64 rx_bytes;
 	u64 rx_dropped;
 	u64 rx_multicast;
+	u64 rx_alloc_failed;
 	u64 rx_phy_errors;
 	u64 rx_forwarded_phy_errors;
 	u64 rx_invalid_frame_errors;
@@ -36,6 +38,7 @@ static const char tsnep_rx_queue_stats_strings[][ETH_GSTRING_LEN] = {
 	"rx_%d_bytes",
 	"rx_%d_dropped",
 	"rx_%d_multicast",
+	"rx_%d_alloc_failed",
 	"rx_%d_no_descriptor_errors",
 	"rx_%d_buffer_too_small_errors",
 	"rx_%d_fifo_overflow_errors",
@@ -47,6 +50,7 @@ struct tsnep_rx_queue_stats {
 	u64 rx_bytes;
 	u64 rx_dropped;
 	u64 rx_multicast;
+	u64 rx_alloc_failed;
 	u64 rx_no_descriptor_errors;
 	u64 rx_buffer_too_small_errors;
 	u64 rx_fifo_overflow_errors;
@@ -178,6 +182,7 @@ static void tsnep_ethtool_get_ethtool_stats(struct net_device *netdev,
 		tsnep_stats.rx_bytes += adapter->rx[i].bytes;
 		tsnep_stats.rx_dropped += adapter->rx[i].dropped;
 		tsnep_stats.rx_multicast += adapter->rx[i].multicast;
+		tsnep_stats.rx_alloc_failed += adapter->rx[i].alloc_failed;
 	}
 	reg = ioread32(adapter->addr + ECM_STAT);
 	tsnep_stats.rx_phy_errors =
@@ -200,6 +205,8 @@ static void tsnep_ethtool_get_ethtool_stats(struct net_device *netdev,
 		tsnep_rx_queue_stats.rx_bytes = adapter->rx[i].bytes;
 		tsnep_rx_queue_stats.rx_dropped = adapter->rx[i].dropped;
 		tsnep_rx_queue_stats.rx_multicast = adapter->rx[i].multicast;
+		tsnep_rx_queue_stats.rx_alloc_failed =
+			adapter->rx[i].alloc_failed;
 		reg = ioread32(adapter->addr + TSNEP_QUEUE(i) +
 			       TSNEP_RX_STATISTIC);
 		tsnep_rx_queue_stats.rx_no_descriptor_errors =
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 5e0d23dd2d42..bf0190e1d2ea 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -660,23 +660,6 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx,
-				 struct tsnep_rx_entry *entry)
-{
-	struct page *page;
-
-	page = page_pool_dev_alloc_pages(rx->page_pool);
-	if (unlikely(!page))
-		return -ENOMEM;
-
-	entry->page = page;
-	entry->len = TSNEP_MAX_RX_BUF_SIZE;
-	entry->dma = page_pool_get_dma_addr(entry->page);
-	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
-
-	return 0;
-}
-
 static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
@@ -723,10 +706,6 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 		entry = &rx->entry[i];
 		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
 		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
-
-		retval = tsnep_rx_alloc_buffer(rx, entry);
-		if (retval)
-			goto failed;
 	}
 
 	return 0;
@@ -736,6 +715,45 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 	return retval;
 }
 
+static int tsnep_rx_desc_available(struct tsnep_rx *rx)
+{
+	if (rx->read <= rx->write)
+		return TSNEP_RING_SIZE - rx->write + rx->read - 1;
+	else
+		return rx->read - rx->write - 1;
+}
+
+static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
+			      struct page *page)
+{
+	entry->page = page;
+	entry->len = TSNEP_MAX_RX_BUF_SIZE;
+	entry->dma = page_pool_get_dma_addr(entry->page);
+	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+}
+
+static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+	struct page *page;
+
+	page = page_pool_dev_alloc_pages(rx->page_pool);
+	if (unlikely(!page))
+		return -ENOMEM;
+	tsnep_rx_set_page(rx, entry, page);
+
+	return 0;
+}
+
+static void tsnep_rx_reuse_buffer(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+	struct tsnep_rx_entry *read = &rx->entry[rx->read];
+
+	tsnep_rx_set_page(rx, entry, read->page);
+	read->page = NULL;
+}
+
 static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 {
 	struct tsnep_rx_entry *entry = &rx->entry[index];
@@ -763,6 +781,48 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 	entry->desc->properties = __cpu_to_le32(entry->properties);
 }
 
+static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
+{
+	int index;
+	bool alloc_failed = false;
+	bool enable = false;
+	int i;
+	int retval;
+
+	for (i = 0; i < count && !alloc_failed; i++) {
+		index = (rx->write + i) % TSNEP_RING_SIZE;
+
+		retval = tsnep_rx_alloc_buffer(rx, index);
+		if (unlikely(retval)) {
+			rx->alloc_failed++;
+			alloc_failed = true;
+
+			/* reuse only if no other allocation was successful */
+			if (i == 0 && reuse)
+				tsnep_rx_reuse_buffer(rx, index);
+			else
+				break;
+		}
+
+		tsnep_rx_activate(rx, index);
+
+		enable = true;
+	}
+
+	if (enable) {
+		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
+
+		/* descriptor properties shall be valid before hardware is
+		 * notified
+		 */
+		dma_wmb();
+
+		iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+	}
+
+	return i;
+}
+
 static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 				       int length)
 {
@@ -798,23 +858,42 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
 	struct device *dmadev = rx->adapter->dmadev;
+	int desc_available;
 	int done = 0;
 	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
-	struct page *page;
 	struct sk_buff *skb;
 	int length;
-	bool enable = false;
-	int retval;
 
+	desc_available = tsnep_rx_desc_available(rx);
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
 
-	while (likely(done < budget)) {
+	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
 		if ((__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
 		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
 			break;
+		done++;
+
+		if (desc_available >= TSNEP_RING_RX_REFILL) {
+			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
+
+			desc_available -= tsnep_rx_refill(rx, desc_available,
+							  reuse);
+			if (!entry->page) {
+				/* buffer has been reused for refill to prevent
+				 * empty RX ring, thus buffer cannot be used for
+				 * RX processing
+				 */
+				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+				desc_available++;
+
+				rx->dropped++;
+
+				continue;
+			}
+		}
 
 		/* descriptor properties shall be read first, because valid data
 		 * is signaled there
@@ -826,49 +905,30 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 TSNEP_DESC_LENGTH_MASK;
 		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
 					      length, dma_dir);
-		page = entry->page;
 
-		/* forward skb only if allocation is successful, otherwise
-		 * page is reused and frame dropped
-		 */
-		retval = tsnep_rx_alloc_buffer(rx, entry);
-		if (!retval) {
-			skb = tsnep_build_skb(rx, page, length);
-			if (skb) {
-				page_pool_release_page(rx->page_pool, page);
-
-				rx->packets++;
-				rx->bytes += length -
-					     TSNEP_RX_INLINE_METADATA_SIZE;
-				if (skb->pkt_type == PACKET_MULTICAST)
-					rx->multicast++;
-
-				napi_gro_receive(napi, skb);
-			} else {
-				page_pool_recycle_direct(rx->page_pool, page);
+		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+		desc_available++;
 
-				rx->dropped++;
-			}
-			done++;
-		} else {
-			rx->dropped++;
-		}
+		skb = tsnep_build_skb(rx, entry->page, length);
+		if (skb) {
+			page_pool_release_page(rx->page_pool, entry->page);
 
-		tsnep_rx_activate(rx, rx->read);
+			rx->packets++;
+			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+			if (skb->pkt_type == PACKET_MULTICAST)
+				rx->multicast++;
 
-		enable = true;
+			napi_gro_receive(napi, skb);
+		} else {
+			page_pool_recycle_direct(rx->page_pool, entry->page);
 
-		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+			rx->dropped++;
+		}
+		entry->page = NULL;
 	}
 
-	if (enable) {
-		/* descriptor properties shall be valid before hardware is
-		 * notified
-		 */
-		dma_wmb();
-
-		iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
-	}
+	if (desc_available)
+		tsnep_rx_refill(rx, desc_available, false);
 
 	return done;
 }
@@ -877,11 +937,13 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 {
 	struct tsnep_rx_entry *entry;
 
-	entry = &rx->entry[rx->read];
-	if ((__le32_to_cpu(entry->desc_wb->properties) &
-	     TSNEP_DESC_OWNER_COUNTER_MASK) ==
-	    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
-		return true;
+	if (rx->read != rx->write) {
+		entry = &rx->entry[rx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_DESC_OWNER_COUNTER_MASK) ==
+		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
+			return true;
+	}
 
 	return false;
 }
@@ -890,7 +952,6 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 int queue_index, struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
-	int i;
 	int retval;
 
 	memset(rx, 0, sizeof(*rx));
@@ -908,13 +969,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	rx->owner_counter = 1;
 	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
 
-	for (i = 0; i < TSNEP_RING_SIZE; i++)
-		tsnep_rx_activate(rx, i);
-
-	/* descriptor properties shall be valid before hardware is notified */
-	dma_wmb();
-
-	iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+	tsnep_rx_refill(rx, tsnep_rx_desc_available(rx), false);
 
 	return 0;
 }
-- 
2.30.2

