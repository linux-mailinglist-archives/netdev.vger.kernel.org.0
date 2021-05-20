Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E1E38B5D7
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhETSRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:17:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:9099 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233606AbhETSQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:54 -0400
IronPort-SDR: JZhciyluG654ZxJibqwsuCV/99kt61XChpQryjquUBE/jU7zx6rBZadkCip2lvPYApsFR8C3cP
 IsC3O/ip2Lbw==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579461"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579461"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:32 -0700
IronPort-SDR: HVtz7Mw6zlYE9J4ocEhsF/KIZd1boxjUcJLwbhISRIx+u098QyX8DZ0Uu+DrB1MmkYl6/ukd1d
 ySrXebOrLJQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670754"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 6/9] igc: Introduce igc_unmap_tx_buffer() helper
Date:   Thu, 20 May 2021 11:17:41 -0700
Message-Id: <20210520181744.2217191-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In preparation for AF_XDP zero-copy support, encapsulate the code that
unmaps Tx buffers into its own local helper so we can reuse it, avoiding
code duplication.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 49 +++++++----------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 5a262bab9116..ebb57d82e4dd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -171,6 +171,14 @@ static void igc_get_hw_control(struct igc_adapter *adapter)
 	     ctrl_ext | IGC_CTRL_EXT_DRV_LOAD);
 }
 
+static void igc_unmap_tx_buffer(struct device *dev, struct igc_tx_buffer *buf)
+{
+	dma_unmap_single(dev, dma_unmap_addr(buf, dma),
+			 dma_unmap_len(buf, len), DMA_TO_DEVICE);
+
+	dma_unmap_len_set(buf, len, 0);
+}
+
 /**
  * igc_clean_tx_ring - Free Tx Buffers
  * @tx_ring: ring to be cleaned
@@ -188,11 +196,7 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 		else
 			dev_kfree_skb_any(tx_buffer->skb);
 
-		/* unmap skb header data */
-		dma_unmap_single(tx_ring->dev,
-				 dma_unmap_addr(tx_buffer, dma),
-				 dma_unmap_len(tx_buffer, len),
-				 DMA_TO_DEVICE);
+		igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
 		/* check for eop_desc to determine the end of the packet */
 		eop_desc = tx_buffer->next_to_watch;
@@ -211,10 +215,7 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 
 			/* unmap any remaining paged data */
 			if (dma_unmap_len(tx_buffer, len))
-				dma_unmap_page(tx_ring->dev,
-					       dma_unmap_addr(tx_buffer, dma),
-					       dma_unmap_len(tx_buffer, len),
-					       DMA_TO_DEVICE);
+				igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 		}
 
 		/* move us one more past the eop_desc for start of next pkt */
@@ -1219,11 +1220,7 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	/* clear dma mappings for failed tx_buffer_info map */
 	while (tx_buffer != first) {
 		if (dma_unmap_len(tx_buffer, len))
-			dma_unmap_page(tx_ring->dev,
-				       dma_unmap_addr(tx_buffer, dma),
-				       dma_unmap_len(tx_buffer, len),
-				       DMA_TO_DEVICE);
-		dma_unmap_len_set(tx_buffer, len, 0);
+			igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
 		if (i-- == 0)
 			i += tx_ring->count;
@@ -1231,11 +1228,7 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	}
 
 	if (dma_unmap_len(tx_buffer, len))
-		dma_unmap_single(tx_ring->dev,
-				 dma_unmap_addr(tx_buffer, dma),
-				 dma_unmap_len(tx_buffer, len),
-				 DMA_TO_DEVICE);
-	dma_unmap_len_set(tx_buffer, len, 0);
+		igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
 	dev_kfree_skb_any(tx_buffer->skb);
 	tx_buffer->skb = NULL;
@@ -2317,14 +2310,7 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 		else
 			napi_consume_skb(tx_buffer->skb, napi_budget);
 
-		/* unmap skb header data */
-		dma_unmap_single(tx_ring->dev,
-				 dma_unmap_addr(tx_buffer, dma),
-				 dma_unmap_len(tx_buffer, len),
-				 DMA_TO_DEVICE);
-
-		/* clear tx_buffer data */
-		dma_unmap_len_set(tx_buffer, len, 0);
+		igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
 		/* clear last DMA location and unmap remaining buffers */
 		while (tx_desc != eop_desc) {
@@ -2338,13 +2324,8 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 			}
 
 			/* unmap any remaining paged data */
-			if (dma_unmap_len(tx_buffer, len)) {
-				dma_unmap_page(tx_ring->dev,
-					       dma_unmap_addr(tx_buffer, dma),
-					       dma_unmap_len(tx_buffer, len),
-					       DMA_TO_DEVICE);
-				dma_unmap_len_set(tx_buffer, len, 0);
-			}
+			if (dma_unmap_len(tx_buffer, len))
+				igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 		}
 
 		/* move us one more past the eop_desc for start of next pkt */
-- 
2.26.2

