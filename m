Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED88739FBA9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhFHQFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:05:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:37595 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFHQFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168236; x=1654704236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BvMA/TMI7LU7a/k/t+t5v+DBoW7t5gNLXtbL6O9+1iE=;
  b=AkJVY2HtyJSjmrwtQM4vhQ+FtYTUsxG35roGs9DW5J8aO26yfsiiqaGj
   qZLRM0tbYRG/c4UyXRigF160AEgPaMkcXGmvsr0gTo2YBj2y8P+uOlcEg
   dGR6PejF0S6JAn2i0Jblfn8Vu1f/T0uFn4QwXsFLeMpQxSuQp5bOuPvfM
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="129862618"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 16:03:55 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 413D9A2269;
        Tue,  8 Jun 2021 16:03:54 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.93) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:03:46 +0000
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
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 09/10] net: ena: Use dev_alloc() in RX buffer allocation
Date:   Tue, 8 Jun 2021 19:01:17 +0300
Message-ID: <20210608160118.3767932-10-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D43UWC003.ant.amazon.com (10.43.162.16) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_alloc() when allocating RX buffers instead of specifying the
allocation flags explicitly. This result in same behaviour with less
code.

Also move the page allocation and its DMA mapping into a function. This
creates a logical block, which may help understanding the code.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 58 ++++++++++++--------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 37c839401c6c..261680aba33c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -975,8 +975,37 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 		ena_free_rx_resources(adapter, i);
 }
 
-static int ena_alloc_rx_page(struct ena_ring *rx_ring,
-				    struct ena_rx_buffer *rx_info, gfp_t gfp)
+struct page *ena_alloc_map_page(struct ena_ring *rx_ring, dma_addr_t *dma)
+{
+	struct page *page;
+
+	/* This would allocate the page on the same NUMA node the executing code
+	 * is running on.
+	 */
+	page = dev_alloc_page();
+	if (!page) {
+		ena_increase_stat(&rx_ring->rx_stats.page_alloc_fail, 1,
+				  &rx_ring->syncp);
+		return ERR_PTR(-ENOSPC);
+	}
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
+		return ERR_PTR(-EIO);
+	}
+
+	return page;
+}
+
+static int ena_alloc_rx_buffer(struct ena_ring *rx_ring,
+			       struct ena_rx_buffer *rx_info)
 {
 	int headroom = rx_ring->rx_headroom;
 	struct ena_com_buf *ena_buf;
@@ -991,25 +1020,11 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	if (unlikely(rx_info->page))
 		return 0;
 
-	page = alloc_page(gfp);
-	if (unlikely(!page)) {
-		ena_increase_stat(&rx_ring->rx_stats.page_alloc_fail, 1,
-				  &rx_ring->syncp);
-		return -ENOMEM;
-	}
-
-	/* To enable NIC-side port-mirroring, AKA SPAN port,
-	 * we make the buffer readable from the nic as well
-	 */
-	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
-			   DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
-		ena_increase_stat(&rx_ring->rx_stats.dma_mapping_err, 1,
-				  &rx_ring->syncp);
+	/* We handle DMA here */
+	page = ena_alloc_map_page(rx_ring, &dma);
+	if (unlikely(IS_ERR(page)))
+		return PTR_ERR(page);
 
-		__free_page(page);
-		return -EIO;
-	}
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 		  "Allocate page %p, rx_info %p\n", page, rx_info);
 
@@ -1065,8 +1080,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 
-		rc = ena_alloc_rx_page(rx_ring, rx_info,
-				       GFP_ATOMIC | __GFP_COMP);
+		rc = ena_alloc_rx_buffer(rx_ring, rx_info);
 		if (unlikely(rc < 0)) {
 			netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
 				   "Failed to allocate buffer for rx queue %d\n",
-- 
2.25.1

