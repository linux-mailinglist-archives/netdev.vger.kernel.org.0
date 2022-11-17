Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23662E85E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiKQWZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiKQWZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E92A8223B
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723900; x=1700259900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nGUKxjEtNjCjOhTfXq6zDL26aekQ3wU8rxVjDWp2/oc=;
  b=lIF6u8pRnBcLhgyXaOuIvrrN8aGaj3UFyGbrHKCc/YUDFZoKmrdvNh2L
   oN/L2W+N653YcfsLEP132PGvRTkwcn2WV9ngOf8+J+NbxUbdVNXz1WKmT
   iNE4ZwjL6/QUCwNrkEAcEM8CeToZXTTe0XHt4xY+hkuOwt5/MImZzcpKm
   BlC4dz7S3sC2X8Y/pxQM0sBFpX33g2hudfi85ga0WdF3AQXi2K5lvd/C1
   eXOEZR/wGpNuaShjZ2jnmGiVdt36+MU12BoXSDa5D9mVTtNayr9F5pz9r
   sBEgey0DDb8cWJtQ5+fMbmBd+rYltf5G/Rm9JSHDNpiJnZQYcGgqv66+x
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826324"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826324"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055466"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055466"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:59 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH net-next 3/5] cassini: Remove unnecessary use of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:55 -0800
Message-Id: <20221117222557.2196195-4-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pages for Rx buffers are allocated in cas_page_alloc() using either
GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC
can't come from highmem and so there's no need to kmap() them. Just use
page_address() instead.

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 drivers/net/ethernet/sun/cassini.c | 34 ++++++++++--------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 0aca193..2f66cfc 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1915,7 +1915,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 	int off, swivel = RX_SWIVEL_OFF_VAL;
 	struct cas_page *page;
 	struct sk_buff *skb;
-	void *addr, *crcaddr;
+	void *crcaddr;
 	__sum16 csum;
 	char *p;
 
@@ -1936,7 +1936,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 	skb_reserve(skb, swivel);
 
 	p = skb->data;
-	addr = crcaddr = NULL;
+	crcaddr = NULL;
 	if (hlen) { /* always copy header pages */
 		i = CAS_VAL(RX_COMP2_HDR_INDEX, words[1]);
 		page = cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)][CAS_VAL(RX_INDEX_NUM, i)];
@@ -1948,12 +1948,10 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			i += cp->crc_size;
 		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr + off,
 					i, DMA_FROM_DEVICE);
-		addr = cas_page_map(page->buffer);
-		memcpy(p, addr + off, i);
+		memcpy(p, page_address(page->buffer) + off, i);
 		dma_sync_single_for_device(&cp->pdev->dev,
 					   page->dma_addr + off, i,
 					   DMA_FROM_DEVICE);
-		cas_page_unmap(addr);
 		RX_USED_ADD(page, 0x100);
 		p += hlen;
 		swivel = 0;
@@ -1984,12 +1982,11 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		/* make sure we always copy a header */
 		swivel = 0;
 		if (p == (char *) skb->data) { /* not split */
-			addr = cas_page_map(page->buffer);
-			memcpy(p, addr + off, RX_COPY_MIN);
+			memcpy(p, page_address(page->buffer) + off,
+			       RX_COPY_MIN);
 			dma_sync_single_for_device(&cp->pdev->dev,
 						   page->dma_addr + off, i,
 						   DMA_FROM_DEVICE);
-			cas_page_unmap(addr);
 			off += RX_COPY_MIN;
 			swivel = RX_COPY_MIN;
 			RX_USED_ADD(page, cp->mtu_stride);
@@ -2036,10 +2033,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			RX_USED_ADD(page, hlen + cp->crc_size);
 		}
 
-		if (cp->crc_size) {
-			addr = cas_page_map(page->buffer);
-			crcaddr  = addr + off + hlen;
-		}
+		if (cp->crc_size)
+			crcaddr = page_address(page->buffer) + off + hlen;
 
 	} else {
 		/* copying packet */
@@ -2061,12 +2056,10 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			i += cp->crc_size;
 		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr + off,
 					i, DMA_FROM_DEVICE);
-		addr = cas_page_map(page->buffer);
-		memcpy(p, addr + off, i);
+		memcpy(p, page_address(page->buffer) + off, i);
 		dma_sync_single_for_device(&cp->pdev->dev,
 					   page->dma_addr + off, i,
 					   DMA_FROM_DEVICE);
-		cas_page_unmap(addr);
 		if (p == (char *) skb->data) /* not split */
 			RX_USED_ADD(page, cp->mtu_stride);
 		else
@@ -2081,20 +2074,17 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 						page->dma_addr,
 						dlen + cp->crc_size,
 						DMA_FROM_DEVICE);
-			addr = cas_page_map(page->buffer);
-			memcpy(p, addr, dlen + cp->crc_size);
+			memcpy(p, page_address(page->buffer), dlen + cp->crc_size);
 			dma_sync_single_for_device(&cp->pdev->dev,
 						   page->dma_addr,
 						   dlen + cp->crc_size,
 						   DMA_FROM_DEVICE);
-			cas_page_unmap(addr);
 			RX_USED_ADD(page, dlen + cp->crc_size);
 		}
 end_copy_pkt:
-		if (cp->crc_size) {
-			addr    = NULL;
+		if (cp->crc_size)
 			crcaddr = skb->data + alloclen;
-		}
+
 		skb_put(skb, alloclen);
 	}
 
@@ -2103,8 +2093,6 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		/* checksum includes FCS. strip it out. */
 		csum = csum_fold(csum_partial(crcaddr, cp->crc_size,
 					      csum_unfold(csum)));
-		if (addr)
-			cas_page_unmap(addr);
 	}
 	skb->protocol = eth_type_trans(skb, cp->dev);
 	if (skb->protocol == htons(ETH_P_IP)) {
-- 
2.37.2

