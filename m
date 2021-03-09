Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9EA332CEE
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCIRLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:11:24 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:25244 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhCIRKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615309854; x=1646845854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4kJesLv17XnSJ2OTaBog76bmbTwZDO3KKZKJLq8M99E=;
  b=BuVNIDlMkppZHfVnheIGaOKSz4KXS0BCd9CkmDH2fdVh2hhzlOUe3MFd
   Ebzr23GoTC9r5EL5szzAfrnJKZRTEKYgep1EZkDCuc29DVk3Ce6m5wW8z
   XXQKztgLH0L8rBMm4phHvVVGSevj6EBmpum8t5kndbOZO+F4zW0OCAmdp
   U=;
X-IronPort-AV: E=Sophos;i="5.81,236,1610409600"; 
   d="scan'208";a="917793152"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 09 Mar 2021 17:10:53 +0000
Received: from EX13D28EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 293A0A21B1;
        Tue,  9 Mar 2021 17:10:52 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.161.244) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Mar 2021 17:10:42 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [RFC Patch v1 1/3] net: ena: implement local page cache (LPC) system
Date:   Tue, 9 Mar 2021 19:10:12 +0200
Message-ID: <20210309171014.2200020-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309171014.2200020-1-shayagr@amazon.com>
References: <20210309171014.2200020-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D10UWA001.ant.amazon.com (10.43.160.216) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The page cache holds pages we allocated in the past during napi cycle,
and tracks their availability status using page ref count.

The cache can hold up to 2048 pages. Upon allocating a page, we check
whether the next entry in the cache contains an unused page, and if so
fetch it. If the next page is already used by another entity or if it
belongs to a different NUMA core than the napi routine, we allocate a
page in the regular way (page from a different NUMA core is replaced by
the newly allocated page).

This system can help us reduce the contention between different cores
when allocating page since every cache is unique to a queue.

This patch adds the following ethtool counters:

- lpc_warm_up: If the next page in the cache isn't free, and the
    cache wasn't allocated its maximum possible pages, allocate a new
    page and store it in the cache. This counter increases everytime it
    happens. Its maximum value can be N * 'current queue size'.

- lpc_full: The next entry in the cache contains a page that is
    still used. In such case a page is allocated in the regular way
    (i.e. dev_alloc())

- lpc_wrong_numa: The next entry in the cache contains a page in a
    different NUMA node than the napi routine which allocates the page.
    In this case increase the counter and replace current entry with a
    page from the same NUMA node.

Note that in all three cases a page should be returned to the caller of
the page cache function, and the page would be either from the cache, or
from the Linux memory system.
In case the system is out-of-memory the cache returns NULL. This
scenario doesn't break the cache's correctness.

The page cache is disabled when having less than 16 queues or when XDP
is used.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 337 ++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  30 ++
 3 files changed, 350 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d6cc7aa612b7..fe16b3d5bd73 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -96,6 +96,9 @@ static const struct ena_stats ena_stats_rx_strings[] = {
 	ENA_STAT_RX_ENTRY(xdp_tx),
 	ENA_STAT_RX_ENTRY(xdp_invalid),
 	ENA_STAT_RX_ENTRY(xdp_redirect),
+	ENA_STAT_RX_ENTRY(lpc_warm_up),
+	ENA_STAT_RX_ENTRY(lpc_full),
+	ENA_STAT_RX_ENTRY(lpc_wrong_numa),
 };
 
 static const struct ena_stats ena_stats_ena_com_strings[] = {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 102f2c91fdb8..9f6cc479506f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -49,6 +49,7 @@ static int ena_rss_init_default(struct ena_adapter *adapter);
 static void check_for_admin_com_state(struct ena_adapter *adapter);
 static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
 static int ena_restore_device(struct ena_adapter *adapter);
+static int ena_create_page_caches(struct ena_adapter *adapter);
 
 static void ena_init_io_rings(struct ena_adapter *adapter,
 			      int first_index, int count);
@@ -981,12 +982,162 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 		ena_free_rx_resources(adapter, i);
 }
 
+static void ena_put_unmap_cache_page(struct ena_ring *rx_ring, struct ena_page *ena_page)
+{
+	dma_unmap_page(rx_ring->dev, ena_page->dma_addr, ENA_PAGE_SIZE,
+		       DMA_BIDIRECTIONAL);
+
+	put_page(ena_page->page);
+}
+
+static struct page *ena_alloc_map_page(struct ena_ring *rx_ring, dma_addr_t *dma)
+{
+	struct page *page;
+
+	/* This would allocate the page on the same NUMA node the executing code
+	 * is running on.
+	 */
+	page = dev_alloc_page();
+	if (!page)
+		return NULL;
+
+	/* To enable NIC-side port-mirroring, AKA SPAN port,
+	 * we make the buffer readable from the nic as well
+	 */
+	*dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
+			    DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(rx_ring->dev, *dma))) {
+		ena_increase_stat(&rx_ring->rx_stats.dma_mapping_err, 1,
+				  &rx_ring->syncp);
+		__free_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+
+/* Removes a page from page cache and allocate a new one instead. If an
+ * allocation of a new page fails, the cache entry isn't changed
+ */
+static void ena_replace_cache_page(struct ena_ring *rx_ring,
+				   struct ena_page *ena_page)
+{
+	struct page *new_page;
+	dma_addr_t dma;
+
+	new_page = ena_alloc_map_page(rx_ring, &dma);
+
+	if (likely(new_page)) {
+		ena_put_unmap_cache_page(rx_ring, ena_page);
+
+		ena_page->page = new_page;
+		ena_page->dma_addr = dma;
+	}
+}
+
+/* Fetch the cached page (mark the page as used and pass it to the caller).
+ * If the page belongs to a different NUMA than the current one, free the cache
+ * page and allocate another one instead.
+ */
+static struct page *ena_fetch_cache_page(struct ena_ring *rx_ring,
+					 struct ena_page *ena_page,
+					 dma_addr_t *dma,
+					 int current_nid)
+{
+	/* Remove pages belonging to different node than current_nid from cache */
+	if (unlikely(page_to_nid(ena_page->page) != current_nid)) {
+		ena_increase_stat(&rx_ring->rx_stats.lpc_wrong_numa, 1, &rx_ring->syncp);
+		ena_replace_cache_page(rx_ring, ena_page);
+	}
+
+	/* Make sure no writes are pending for this page */
+	dma_sync_single_for_device(rx_ring->dev, ena_page->dma_addr,
+				   ENA_PAGE_SIZE,
+				   DMA_BIDIRECTIONAL);
+
+	/* Increase refcount to 2 so that the page is returned to the
+	 * cache after being freed
+	 */
+	page_ref_inc(ena_page->page);
+
+	*dma = ena_page->dma_addr;
+
+	return ena_page->page;
+}
+
+static struct page *ena_get_page(struct ena_ring *rx_ring, dma_addr_t *dma,
+				 int current_nid, bool *is_lpc_page)
+{
+	struct ena_page_cache *page_cache = rx_ring->page_cache;
+	u32 head, cache_current_size;
+	struct ena_page *ena_page;
+
+	/* Cache size of zero indicates disabled cache */
+	if (!page_cache) {
+		*is_lpc_page = false;
+		return ena_alloc_map_page(rx_ring, dma);
+	}
+
+	*is_lpc_page = true;
+
+	cache_current_size = page_cache->current_size;
+	head = page_cache->head;
+
+	ena_page = &page_cache->cache[head];
+	/* Warm up phase. We fill the pages for the first time. The
+	 * phase is done in the napi context to improve the chances we
+	 * allocate on the correct NUMA node
+	 */
+	if (unlikely(cache_current_size < page_cache->max_size)) {
+		/* Check if oldest allocated page is free */
+		if (ena_page->page && page_ref_count(ena_page->page) == 1) {
+			page_cache->head = (head + 1) % cache_current_size;
+			return ena_fetch_cache_page(rx_ring, ena_page, dma, current_nid);
+		}
+
+		ena_page = &page_cache->cache[cache_current_size];
+
+		/* Add a new page to the cache */
+		ena_page->page = ena_alloc_map_page(rx_ring, dma);
+		if (unlikely(!ena_page->page))
+			return NULL;
+
+		ena_page->dma_addr = *dma;
+
+		/* Increase refcount to 2 so that the page is returned to the
+		 * cache after being freed
+		 */
+		page_ref_inc(ena_page->page);
+
+		page_cache->current_size++;
+
+		ena_increase_stat(&rx_ring->rx_stats.lpc_warm_up, 1, &rx_ring->syncp);
+
+		return ena_page->page;
+	}
+
+	/* Next page is still in use, so we allocate outside the cache */
+	if (unlikely(page_ref_count(ena_page->page) != 1)) {
+		ena_increase_stat(&rx_ring->rx_stats.lpc_full, 1, &rx_ring->syncp);
+		*is_lpc_page = false;
+		return ena_alloc_map_page(rx_ring, dma);
+	}
+
+	/* The cache has a free page to fetch for the caller. Update the
+	 * page that would be returned the next time this function's called.
+	 */
+	page_cache->head = (head + 1) & (page_cache->max_size - 1);
+
+	return ena_fetch_cache_page(rx_ring, ena_page, dma, current_nid);
+}
+
 static int ena_alloc_rx_page(struct ena_ring *rx_ring,
-				    struct ena_rx_buffer *rx_info, gfp_t gfp)
+			     struct ena_rx_buffer *rx_info, int current_nid)
 {
 	int headroom = rx_ring->rx_headroom;
 	struct ena_com_buf *ena_buf;
 	struct page *page;
+	bool is_lpc_page;
 	dma_addr_t dma;
 
 	/* restore page offset value in case it has been changed by device */
@@ -996,29 +1147,19 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	if (unlikely(rx_info->page))
 		return 0;
 
-	page = alloc_page(gfp);
+	/* We handle DMA here */
+	page = ena_get_page(rx_ring, &dma, current_nid, &is_lpc_page);
 	if (unlikely(!page)) {
 		ena_increase_stat(&rx_ring->rx_stats.page_alloc_fail, 1,
 				  &rx_ring->syncp);
 		return -ENOMEM;
 	}
 
-	/* To enable NIC-side port-mirroring, AKA SPAN port,
-	 * we make the buffer readable from the nic as well
-	 */
-	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
-			   DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
-		ena_increase_stat(&rx_ring->rx_stats.dma_mapping_err, 1,
-				  &rx_ring->syncp);
-
-		__free_page(page);
-		return -EIO;
-	}
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 		  "Allocate page %p, rx_info %p\n", page, rx_info);
 
 	rx_info->page = page;
+	rx_info->is_lpc_page = is_lpc_page;
 	ena_buf = &rx_info->ena_buf;
 	ena_buf->paddr = dma + headroom;
 	ena_buf->len = ENA_PAGE_SIZE - headroom;
@@ -1031,9 +1172,11 @@ static void ena_unmap_rx_buff(struct ena_ring *rx_ring,
 {
 	struct ena_com_buf *ena_buf = &rx_info->ena_buf;
 
-	dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
-		       ENA_PAGE_SIZE,
-		       DMA_BIDIRECTIONAL);
+	/* LPC pages are unmapped at cache destruction */
+	if (!rx_info->is_lpc_page)
+		dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
+			       ENA_PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
 }
 
 static void ena_free_rx_page(struct ena_ring *rx_ring,
@@ -1056,9 +1199,13 @@ static void ena_free_rx_page(struct ena_ring *rx_ring,
 static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 {
 	u16 next_to_use, req_id;
+	int current_nid;
 	u32 i;
 	int rc;
 
+	/* Prefer pages to be allocate on the same NUMA as the CPU */
+	current_nid = numa_mem_id();
+
 	next_to_use = rx_ring->next_to_use;
 
 	for (i = 0; i < num; i++) {
@@ -1068,8 +1215,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 
-		rc = ena_alloc_rx_page(rx_ring, rx_info,
-				       GFP_ATOMIC | __GFP_COMP);
+		rc = ena_alloc_rx_page(rx_ring, rx_info, current_nid);
 		if (unlikely(rc < 0)) {
 			netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
 				   "Failed to allocate buffer for rx queue %d\n",
@@ -1140,12 +1286,51 @@ static void ena_refill_all_rx_bufs(struct ena_adapter *adapter)
 	}
 }
 
+/* Release all pages from the page cache */
+static void ena_free_ring_cache_pages(struct ena_adapter *adapter, int qid)
+{
+	struct ena_ring *rx_ring = &adapter->rx_ring[qid];
+	struct ena_page_cache *page_cache;
+	int i;
+
+	/* Page cache is disabled */
+	if (!rx_ring->page_cache)
+		return;
+
+	page_cache = rx_ring->page_cache;
+
+	/* We check size value to make sure we don't
+	 * free pages that weren't allocated.
+	 */
+	for (i = 0; i < page_cache->current_size; i++) {
+		struct ena_page *ena_page = &page_cache->cache[i];
+
+		WARN_ON(!ena_page->page);
+
+		dma_unmap_page(rx_ring->dev, ena_page->dma_addr,
+			       ENA_PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+
+		/* If the page is also in the rx buffer, then this operation
+		 * would only decrease its reference count
+		 */
+		__free_page(ena_page->page);
+	}
+
+	page_cache->head = page_cache->current_size = 0;
+}
+
 static void ena_free_all_rx_bufs(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		/* The RX SQ's packet should be freed first, since they don't
+		 * unmap pages that belong to the page_cache.
+		 */
 		ena_free_rx_bufs(adapter, i);
+		ena_free_ring_cache_pages(adapter, i);
+	}
 }
 
 static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
@@ -2539,6 +2724,10 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 		if (rc)
 			goto err_create_rx_queues;
 
+		rc = ena_create_page_caches(adapter);
+		if (rc) /* Cache memory is freed in case of failure */
+			goto err_create_rx_queues;
+
 		return 0;
 
 err_create_rx_queues:
@@ -2591,6 +2780,111 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 	}
 }
 
+static void ena_free_ring_page_cache(struct ena_ring *rx_ring)
+{
+	if (!rx_ring->page_cache)
+		return;
+
+	vfree(rx_ring->page_cache);
+	rx_ring->page_cache = NULL;
+}
+
+static bool ena_is_lpc_supported(struct ena_adapter *adapter,
+				 struct ena_ring *rx_ring,
+				 bool error_print)
+{
+	void (*print_log)(const struct net_device *dev, const char *format, ...);
+	int channels_nr = adapter->num_io_queues + adapter->xdp_num_queues;
+
+	print_log = (error_print) ? netdev_err : netdev_info;
+
+	/* LPC is disabled below min number of channels */
+	if (channels_nr < ENA_LPC_MIN_NUM_OF_CHANNELS) {
+		print_log(adapter->netdev,
+			  "Local page cache is disabled for less than %d channels\n",
+			  ENA_LPC_MIN_NUM_OF_CHANNELS);
+
+		return false;
+	}
+
+	/* The driver doesn't support page caches under XDP */
+	if (ena_xdp_present_ring(rx_ring)) {
+		print_log(adapter->netdev,
+			  "Local page cache is disabled when using XDP\n");
+		return false;
+	}
+
+	return true;
+}
+
+/* Calculate the size of the Local Page Cache. If LPC should be disabled, return
+ * a size of 0.
+ */
+static u32 ena_calculate_cache_size(struct ena_adapter *adapter,
+				    struct ena_ring *rx_ring)
+{
+	u32 page_cache_size = adapter->lpc_size;
+
+	/* LPC cache size of 0 means disabled cache */
+	if (page_cache_size == 0)
+		return 0;
+
+	if (!ena_is_lpc_supported(adapter, rx_ring, false))
+		return 0;
+
+	page_cache_size = page_cache_size * ENA_LPC_MULTIPLIER_UNIT;
+	page_cache_size = roundup_pow_of_two(page_cache_size);
+
+	return page_cache_size;
+}
+
+static int ena_create_page_caches(struct ena_adapter *adapter)
+{
+	struct ena_page_cache *cache;
+	u32 page_cache_size;
+	int i;
+
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		struct ena_ring *rx_ring = &adapter->rx_ring[i];
+
+		page_cache_size = ena_calculate_cache_size(adapter, rx_ring);
+
+		if (!page_cache_size)
+			return 0;
+
+		cache = vzalloc(sizeof(struct ena_page_cache) +
+				sizeof(struct ena_page) * page_cache_size);
+		if (!cache)
+			goto err_cache_alloc;
+
+		cache->max_size = page_cache_size;
+		rx_ring->page_cache = cache;
+	}
+
+	return 0;
+err_cache_alloc:
+	netif_err(adapter, ifup, adapter->netdev,
+		  "Failed to initialize local page caches (LPCs)\n");
+	while (--i >= 0) {
+		struct ena_ring *rx_ring = &adapter->rx_ring[i];
+
+		ena_free_ring_page_cache(rx_ring);
+	}
+
+	return -ENOMEM;
+}
+
+static void ena_free_page_caches(struct ena_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		struct ena_ring *rx_ring = &adapter->rx_ring[i];
+
+		ena_free_ring_page_cache(rx_ring);
+	}
+}
+
 static int ena_up(struct ena_adapter *adapter)
 {
 	int io_queue_count, rc, i;
@@ -2641,6 +2935,7 @@ static int ena_up(struct ena_adapter *adapter)
 	return rc;
 
 err_up:
+	ena_free_page_caches(adapter);
 	ena_destroy_all_tx_queues(adapter);
 	ena_free_all_io_tx_resources(adapter);
 	ena_destroy_all_rx_queues(adapter);
@@ -2691,6 +2986,7 @@ static void ena_down(struct ena_adapter *adapter)
 
 	ena_free_all_tx_bufs(adapter);
 	ena_free_all_rx_bufs(adapter);
+	ena_free_page_caches(adapter);
 	ena_free_all_io_tx_resources(adapter);
 	ena_free_all_io_rx_resources(adapter);
 }
@@ -4296,6 +4592,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
 
 	adapter->num_io_queues = max_num_io_queues;
+	adapter->lpc_size = ENA_LPC_DEFAULT_MULTIPLIER;
 	adapter->max_num_io_queues = max_num_io_queues;
 	adapter->last_monitored_tx_qid = 0;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 74af15d62ee1..242c9ce4a782 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -194,6 +194,7 @@ struct ena_rx_buffer {
 	struct page *page;
 	u32 page_offset;
 	struct ena_com_buf ena_buf;
+	bool is_lpc_page;
 } ____cacheline_aligned;
 
 struct ena_stats_tx {
@@ -234,8 +235,33 @@ struct ena_stats_rx {
 	u64 xdp_tx;
 	u64 xdp_invalid;
 	u64 xdp_redirect;
+	u64 lpc_warm_up;
+	u64 lpc_full;
+	u64 lpc_wrong_numa;
 };
 
+/* LPC definitions */
+#define ENA_LPC_DEFAULT_MULTIPLIER 2
+#define ENA_LPC_MULTIPLIER_UNIT 1024
+#define ENA_LPC_MIN_NUM_OF_CHANNELS 16
+
+/* Store DMA address along with the page */
+struct ena_page {
+	struct page *page;
+	dma_addr_t dma_addr;
+};
+
+struct ena_page_cache {
+	/* How many pages are produced */
+	u32 head;
+	/* How many of the entries were initialized */
+	u32 current_size;
+	/* Maximum number of pages the cache can hold */
+	u32 max_size;
+
+	struct ena_page cache[0];
+} ____cacheline_aligned;
+
 struct ena_ring {
 	/* Holds the empty requests for TX/RX
 	 * out of order completions
@@ -252,6 +278,7 @@ struct ena_ring {
 	struct pci_dev *pdev;
 	struct napi_struct *napi;
 	struct net_device *netdev;
+	struct ena_page_cache *page_cache;
 	struct ena_com_dev *ena_dev;
 	struct ena_adapter *adapter;
 	struct ena_com_io_cq *ena_com_io_cq;
@@ -333,6 +360,9 @@ struct ena_adapter {
 	u32 num_io_queues;
 	u32 max_num_io_queues;
 
+	/* Local page cache size */
+	u32 lpc_size;
+
 	int msix_vecs;
 
 	u32 missing_tx_completion_threshold;
-- 
2.25.1

