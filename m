Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF76F5ECD73
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiI0T72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiI0T66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:58 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523FD326F5;
        Tue, 27 Sep 2022 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n1s8hqyifdPC7N0Zubm2N8vcr8Qm5zqyKnmMfEsg5gg=; b=S1he1hOlQSDcQ/V+LtC/TqKywo
        76XF8NMCKYUSmJjwCg0MnbQiAoKGaQu5oFD69si/+mOFFRRz8Zo+FD2K1jzcFNsl+1sw9Ob9TOuRf
        erABjZ2pbEO6ZuiX5mjsdyyVTjOY6/wAyz+XVzfe/o7Pek0x0+K+itLxvhRaKAqKp9mc=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGjB-0005u7-9U; Tue, 27 Sep 2022 21:58:49 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 6/6] tsnep: Use page pool for RX
Date:   Tue, 27 Sep 2022 21:58:42 +0200
Message-Id: <20220927195842.44641-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
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

Use page pool for RX buffer handling. Makes RX path more efficient and
is required prework for future XDP support.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/Kconfig      |   1 +
 drivers/net/ethernet/engleder/tsnep.h      |   5 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 162 ++++++++++++---------
 3 files changed, 100 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/engleder/Kconfig b/drivers/net/ethernet/engleder/Kconfig
index f4e2b1102d8f..3df6bf476ae7 100644
--- a/drivers/net/ethernet/engleder/Kconfig
+++ b/drivers/net/ethernet/engleder/Kconfig
@@ -21,6 +21,7 @@ config TSNEP
 	depends on HAS_IOMEM && HAS_DMA
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLIB
+	select PAGE_POOL
 	help
 	  Support for the Engleder TSN endpoint Ethernet MAC IP Core.
 
diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 2ca34ae9b55a..09a723b827c7 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -96,9 +96,9 @@ struct tsnep_rx_entry {
 
 	u32 properties;
 
-	struct sk_buff *skb;
+	struct page *page;
 	size_t len;
-	DEFINE_DMA_UNMAP_ADDR(dma);
+	dma_addr_t dma;
 };
 
 struct tsnep_rx {
@@ -113,6 +113,7 @@ struct tsnep_rx {
 	int read;
 	u32 owner_counter;
 	int increment_owner_counter;
+	struct page_pool *page_pool;
 
 	u32 packets;
 	u32 bytes;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index a6b81f32d76b..8a93d0aa7faa 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -27,10 +27,10 @@
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 
-#define RX_SKB_LENGTH (round_up(TSNEP_RX_INLINE_METADATA_SIZE + ETH_HLEN + \
-				TSNEP_MAX_FRAME_SIZE + ETH_FCS_LEN, 4))
-#define RX_SKB_RESERVE ((16 - TSNEP_RX_INLINE_METADATA_SIZE) + NET_IP_ALIGN)
-#define RX_SKB_ALLOC_LENGTH (RX_SKB_RESERVE + RX_SKB_LENGTH)
+#define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
+#define TSNEP_HEADROOM ALIGN(TSNEP_SKB_PAD, 4)
+#define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
+			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 #define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
@@ -587,14 +587,15 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
-		if (dma_unmap_addr(entry, dma))
-			dma_unmap_single(dmadev, dma_unmap_addr(entry, dma),
-					 dma_unmap_len(entry, len),
-					 DMA_FROM_DEVICE);
-		if (entry->skb)
-			dev_kfree_skb(entry->skb);
+		if (entry->page)
+			page_pool_put_full_page(rx->page_pool, entry->page,
+						false);
+		entry->page = NULL;
 	}
 
+	if (rx->page_pool)
+		page_pool_destroy(rx->page_pool);
+
 	memset(rx->entry, 0, sizeof(rx->entry));
 
 	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
@@ -607,31 +608,19 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_alloc_and_map_skb(struct tsnep_rx *rx,
-				      struct tsnep_rx_entry *entry)
+static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx,
+				 struct tsnep_rx_entry *entry)
 {
-	struct device *dmadev = rx->adapter->dmadev;
-	struct sk_buff *skb;
-	dma_addr_t dma;
+	struct page *page;
 
-	skb = __netdev_alloc_skb(rx->adapter->netdev, RX_SKB_ALLOC_LENGTH,
-				 GFP_ATOMIC | GFP_DMA);
-	if (!skb)
+	page = page_pool_dev_alloc_pages(rx->page_pool);
+	if (unlikely(!page))
 		return -ENOMEM;
 
-	skb_reserve(skb, RX_SKB_RESERVE);
-
-	dma = dma_map_single(dmadev, skb->data, RX_SKB_LENGTH,
-			     DMA_FROM_DEVICE);
-	if (dma_mapping_error(dmadev, dma)) {
-		dev_kfree_skb(skb);
-		return -ENOMEM;
-	}
-
-	entry->skb = skb;
-	entry->len = RX_SKB_LENGTH;
-	dma_unmap_addr_set(entry, dma, dma);
-	entry->desc->rx = __cpu_to_le64(dma);
+	entry->page = page;
+	entry->len = TSNEP_MAX_RX_BUF_SIZE;
+	entry->dma = page_pool_get_dma_addr(entry->page);
+	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
 
 	return 0;
 }
@@ -640,6 +629,7 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	struct tsnep_rx_entry *entry;
+	struct page_pool_params pp_params = { 0 };
 	struct tsnep_rx_entry *next_entry;
 	int i, j;
 	int retval;
@@ -661,12 +651,28 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 			entry->desc_dma = rx->page_dma[i] + TSNEP_DESC_SIZE * j;
 		}
 	}
+
+	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.order = 0;
+	pp_params.pool_size = TSNEP_RING_SIZE;
+	pp_params.nid = dev_to_node(dmadev);
+	pp_params.dev = dmadev;
+	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.max_len = TSNEP_MAX_RX_BUF_SIZE;
+	pp_params.offset = TSNEP_SKB_PAD;
+	rx->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rx->page_pool)) {
+		retval = PTR_ERR(rx->page_pool);
+		rx->page_pool = NULL;
+		goto failed;
+	}
+
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
 		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
 		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
 
-		retval = tsnep_rx_alloc_and_map_skb(rx, entry);
+		retval = tsnep_rx_alloc_buffer(rx, entry);
 		if (retval)
 			goto failed;
 	}
@@ -682,7 +688,7 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 {
 	struct tsnep_rx_entry *entry = &rx->entry[index];
 
-	/* RX_SKB_LENGTH is a multiple of 4 */
+	/* TSNEP_MAX_RX_BUF_SIZE is a multiple of 4 */
 	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
 	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
 	if (index == rx->increment_owner_counter) {
@@ -705,19 +711,52 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 	entry->desc->properties = __cpu_to_le32(entry->properties);
 }
 
+static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
+				       int length)
+{
+	struct sk_buff *skb;
+
+	skb = napi_build_skb(page_address(page), PAGE_SIZE);
+	if (unlikely(!skb))
+		return NULL;
+
+	/* update pointers within the skb to store the data */
+	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
+	__skb_put(skb, length - TSNEP_RX_INLINE_METADATA_SIZE - ETH_FCS_LEN);
+
+	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
+		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+		struct tsnep_rx_inline *rx_inline =
+			(struct tsnep_rx_inline *)(page_address(page) +
+						   TSNEP_SKB_PAD);
+
+		skb_shinfo(skb)->tx_flags |=
+			SKBTX_HW_TSTAMP_NETDEV;
+		memset(hwtstamps, 0, sizeof(*hwtstamps));
+		hwtstamps->netdev_data = rx_inline;
+	}
+
+	skb_record_rx_queue(skb, rx->queue_index);
+	skb->protocol = eth_type_trans(skb, rx->adapter->netdev);
+
+	return skb;
+}
+
 static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	int done = 0;
+	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
+	struct page *page;
 	struct sk_buff *skb;
-	size_t len;
-	dma_addr_t dma;
 	int length;
 	bool enable = false;
 	int retval;
 
+	dma_dir = page_pool_get_dma_dir(rx->page_pool);
+
 	while (likely(done < budget)) {
 		entry = &rx->entry[rx->read];
 		if ((__le32_to_cpu(entry->desc_wb->properties) &
@@ -730,43 +769,34 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		 */
 		dma_rmb();
 
-		skb = entry->skb;
-		len = dma_unmap_len(entry, len);
-		dma = dma_unmap_addr(entry, dma);
+		prefetch(page_address(entry->page) + TSNEP_SKB_PAD);
+		length = __le32_to_cpu(entry->desc_wb->properties) &
+			 TSNEP_DESC_LENGTH_MASK;
+		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
+					      length, dma_dir);
+		page = entry->page;
 
 		/* forward skb only if allocation is successful, otherwise
-		 * skb is reused and frame dropped
+		 * page is reused and frame dropped
 		 */
-		retval = tsnep_rx_alloc_and_map_skb(rx, entry);
+		retval = tsnep_rx_alloc_buffer(rx, entry);
 		if (!retval) {
-			dma_unmap_single(dmadev, dma, len, DMA_FROM_DEVICE);
-
-			length = __le32_to_cpu(entry->desc_wb->properties) &
-				 TSNEP_DESC_LENGTH_MASK;
-			skb_put(skb, length - ETH_FCS_LEN);
-			if (rx->adapter->hwtstamp_config.rx_filter ==
-			    HWTSTAMP_FILTER_ALL) {
-				struct skb_shared_hwtstamps *hwtstamps =
-					skb_hwtstamps(skb);
-				struct tsnep_rx_inline *rx_inline =
-					(struct tsnep_rx_inline *)skb->data;
-
-				skb_shinfo(skb)->tx_flags |=
-					SKBTX_HW_TSTAMP_NETDEV;
-				memset(hwtstamps, 0, sizeof(*hwtstamps));
-				hwtstamps->netdev_data = rx_inline;
-			}
-			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
-			skb_record_rx_queue(skb, rx->queue_index);
-			skb->protocol = eth_type_trans(skb,
-						       rx->adapter->netdev);
+			skb = tsnep_build_skb(rx, page, length);
+			if (skb) {
+				page_pool_release_page(rx->page_pool, page);
+
+				rx->packets++;
+				rx->bytes += length -
+					     TSNEP_RX_INLINE_METADATA_SIZE;
+				if (skb->pkt_type == PACKET_MULTICAST)
+					rx->multicast++;
 
-			rx->packets++;
-			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
-			if (skb->pkt_type == PACKET_MULTICAST)
-				rx->multicast++;
+				napi_gro_receive(napi, skb);
+			} else {
+				page_pool_recycle_direct(rx->page_pool, page);
 
-			napi_gro_receive(napi, skb);
+				rx->dropped++;
+			}
 			done++;
 		} else {
 			rx->dropped++;
-- 
2.30.2

