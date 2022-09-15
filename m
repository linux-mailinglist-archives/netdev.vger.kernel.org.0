Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B37F5BA1DD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiIOUhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIOUgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:36:53 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DF56173B
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/a6MbxbT9FbR5Pbq6vt3oyK12268O7KnyMwsoOYJmPs=; b=xgCo5exCpYoBcTrs7hOk3dpQqf
        1DIZVcJH47GXmoshsprEjUouypcbF2qoWovcMr7BtOd058gEiVV5c0xcDr7IOyUCvXJXlRzh7AVUr
        eIhzy/saht8U9+SA4Kdui6q0Mribsz8nHcq0q9ID/olDX5QiR/lEVOxNut84Qr9nVtRs=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oYvbM-00086K-9z; Thu, 15 Sep 2022 22:36:48 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 7/7] tsnep: Rework RX buffer allocation
Date:   Thu, 15 Sep 2022 22:36:37 +0200
Message-Id: <20220915203638.42917-8-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220915203638.42917-1-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
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

Try to refill RX queue continously instead of dropping frames if
allocation fails. This seems to be the more common pattern for network
drivers and makes future XDP support simpler.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h         |   2 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c    | 143 ++++++++++--------
 3 files changed, 85 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 09a723b827c7..48811f361523 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -110,6 +110,7 @@ struct tsnep_rx {
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
 
 	struct tsnep_rx_entry entry[TSNEP_RING_SIZE];
+	int write;
 	int read;
 	u32 owner_counter;
 	int increment_owner_counter;
@@ -119,6 +120,7 @@ struct tsnep_rx {
 	u32 bytes;
 	u32 dropped;
 	u32 multicast;
+	u32 alloc_failed;
 };
 
 struct tsnep_queue {
diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index b9c4c45db052..8fb00fe2be8c 100644
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
index 444a6c4a7be4..61e958cf9aee 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -608,23 +608,6 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
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
@@ -671,10 +654,6 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 		entry = &rx->entry[i];
 		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
 		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
-
-		retval = tsnep_rx_alloc_buffer(rx, entry);
-		if (retval)
-			goto failed;
 	}
 
 	return 0;
@@ -684,6 +663,31 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
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
+static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+	struct page *page;
+
+	page = page_pool_dev_alloc_pages(rx->page_pool);
+	if (unlikely(!page))
+		return -ENOMEM;
+
+	entry->page = page;
+	entry->len = TSNEP_MAX_RX_BUF_SIZE;
+	entry->dma = page_pool_get_dma_addr(entry->page);
+	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+
+	return 0;
+}
+
 static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 {
 	struct tsnep_rx_entry *entry = &rx->entry[index];
@@ -711,6 +715,40 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 	entry->desc->properties = __cpu_to_le32(entry->properties);
 }
 
+static void tsnep_rx_refill(struct tsnep_rx *rx)
+{
+	int count = tsnep_rx_desc_available(rx);
+	int index;
+	bool enable = false;
+	int i;
+	int retval;
+
+	for (i = 0; i < count; i++) {
+		index = (rx->write + i) % TSNEP_RING_SIZE;
+
+		retval = tsnep_rx_alloc_buffer(rx, index);
+		if (unlikely(retval)) {
+			rx->alloc_failed++;
+			break;
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
+}
+
 static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 				       int length)
 {
@@ -749,15 +787,12 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	int done = 0;
 	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
-	struct page *page;
 	struct sk_buff *skb;
 	int length;
-	bool enable = false;
-	int retval;
 
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
 
-	while (likely(done < budget)) {
+	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
 		if ((__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
@@ -774,49 +809,30 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
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
-
-				rx->dropped++;
-			}
-			done++;
+		skb = tsnep_build_skb(rx, entry->page, length);
+		if (skb) {
+			page_pool_release_page(rx->page_pool, entry->page);
+
+			rx->packets++;
+			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+			if (skb->pkt_type == PACKET_MULTICAST)
+				rx->multicast++;
+
+			napi_gro_receive(napi, skb);
 		} else {
+			page_pool_recycle_direct(rx->page_pool, entry->page);
+
 			rx->dropped++;
 		}
+		entry->page = NULL;
 
-		tsnep_rx_activate(rx, rx->read);
-
-		enable = true;
+		done++;
 
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 	}
 
-	if (enable) {
-		/* descriptor properties shall be valid before hardware is
-		 * notified
-		 */
-		dma_wmb();
-
-		iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
-	}
+	tsnep_rx_refill(rx);
 
 	return done;
 }
@@ -825,7 +841,6 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 int queue_index, struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
-	int i;
 	int retval;
 
 	memset(rx, 0, sizeof(*rx));
@@ -843,13 +858,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	rx->owner_counter = 1;
 	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
 
-	for (i = 0; i < TSNEP_RING_SIZE; i++)
-		tsnep_rx_activate(rx, i);
-
-	/* descriptor properties shall be valid before hardware is notified */
-	dma_wmb();
-
-	iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+	tsnep_rx_refill(rx);
 
 	return 0;
 }
-- 
2.30.2

