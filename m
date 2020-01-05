Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCB0130679
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgAEHOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:50 -0500
Received: from mga05.intel.com ([192.55.52.43]:54705 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgAEHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607357"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] igc: Remove no need declaration of the igc_alloc_mapped_page
Date:   Sat,  4 Jan 2020 23:14:10 -0800
Message-Id: <20200105071420.3778982-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_alloc_mapped_page function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 94 +++++++++++------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1023c9226a8e..4ad06952056b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -63,8 +63,6 @@ static void igc_free_q_vectors(struct igc_adapter *adapter);
 static void igc_irq_disable(struct igc_adapter *adapter);
 static void igc_irq_enable(struct igc_adapter *adapter);
 static void igc_configure_msix(struct igc_adapter *adapter);
-static bool igc_alloc_mapped_page(struct igc_ring *rx_ring,
-				  struct igc_rx_buffer *bi);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -1606,6 +1604,52 @@ static void igc_put_rx_buffer(struct igc_ring *rx_ring,
 	rx_buffer->page = NULL;
 }
 
+static inline unsigned int igc_rx_offset(struct igc_ring *rx_ring)
+{
+	return ring_uses_build_skb(rx_ring) ? IGC_SKB_PAD : 0;
+}
+
+static bool igc_alloc_mapped_page(struct igc_ring *rx_ring,
+				  struct igc_rx_buffer *bi)
+{
+	struct page *page = bi->page;
+	dma_addr_t dma;
+
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
+
+	/* alloc new page for storage */
+	page = dev_alloc_pages(igc_rx_pg_order(rx_ring));
+	if (unlikely(!page)) {
+		rx_ring->rx_stats.alloc_failed++;
+		return false;
+	}
+
+	/* map page for use */
+	dma = dma_map_page_attrs(rx_ring->dev, page, 0,
+				 igc_rx_pg_size(rx_ring),
+				 DMA_FROM_DEVICE,
+				 IGC_RX_DMA_ATTR);
+
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rx_ring->dev, dma)) {
+		__free_page(page);
+
+		rx_ring->rx_stats.alloc_failed++;
+		return false;
+	}
+
+	bi->dma = dma;
+	bi->page = page;
+	bi->page_offset = igc_rx_offset(rx_ring);
+	bi->pagecnt_bias = 1;
+
+	return true;
+}
+
 /**
  * igc_alloc_rx_buffers - Replace used receive buffers; packet split
  * @rx_ring: rx descriptor ring
@@ -1767,52 +1811,6 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	return total_packets;
 }
 
-static inline unsigned int igc_rx_offset(struct igc_ring *rx_ring)
-{
-	return ring_uses_build_skb(rx_ring) ? IGC_SKB_PAD : 0;
-}
-
-static bool igc_alloc_mapped_page(struct igc_ring *rx_ring,
-				  struct igc_rx_buffer *bi)
-{
-	struct page *page = bi->page;
-	dma_addr_t dma;
-
-	/* since we are recycling buffers we should seldom need to alloc */
-	if (likely(page))
-		return true;
-
-	/* alloc new page for storage */
-	page = dev_alloc_pages(igc_rx_pg_order(rx_ring));
-	if (unlikely(!page)) {
-		rx_ring->rx_stats.alloc_failed++;
-		return false;
-	}
-
-	/* map page for use */
-	dma = dma_map_page_attrs(rx_ring->dev, page, 0,
-				 igc_rx_pg_size(rx_ring),
-				 DMA_FROM_DEVICE,
-				 IGC_RX_DMA_ATTR);
-
-	/* if mapping failed free memory back to system since
-	 * there isn't much point in holding memory we can't use
-	 */
-	if (dma_mapping_error(rx_ring->dev, dma)) {
-		__free_page(page);
-
-		rx_ring->rx_stats.alloc_failed++;
-		return false;
-	}
-
-	bi->dma = dma;
-	bi->page = page;
-	bi->page_offset = igc_rx_offset(rx_ring);
-	bi->pagecnt_bias = 1;
-
-	return true;
-}
-
 /**
  * igc_clean_tx_irq - Reclaim resources after transmit completes
  * @q_vector: pointer to q_vector containing needed info
-- 
2.24.1

