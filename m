Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21ED636B9B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiKWUvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiKWUvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47636BDF3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236674; x=1700772674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ED1M1kq/YLs3tO8iY0cVBj6iLOgVN3mxVZze6U7DGKw=;
  b=cn9csYvr5f7hJED8cVQ6b0j1asvDKXJIR3OoRFlXt4duQPpPlMtAuap/
   VzHOG4u5u9JioE+RevsM2c1XoUcBUNo4nW2h4t6oyxDSu8d5KgQd5fyz7
   r8dtAuzHRbDhZP+vvX5Ia5NTUqN3zJ+qD6V/136Rm4911e9PFvBgHZvMu
   hZxdaKmD4A0FLp+xYL1/zP2NlF/khydNROo9pl7XiwoSHHN9mhahGf1DG
   HwhPZjt1RcRMkneFw0zfREfJhXeZID9aiNM7U+jTDAdjU+B18E701GO07
   TgOGqGMFZCcTNwh4Nl1UMD8sJFq0B6XsLbctyXozG9xDe2hX0404yHe7o
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862669"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862669"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947698"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947698"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:12 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 net-next 3/6] cassini: Use page_address() instead of kmap_atomic()
Date:   Wed, 23 Nov 2022 12:52:16 -0800
Message-Id: <20221123205219.31748-4-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pages for Rx buffers are allocated in cas_page_alloc() using either
GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC can't
come from highmem and so there's no need to kmap() them. Just use
page_address() instead. This makes the variable 'addr' unnecessary, so
remove it too.

Note that kmap_atomic() disables preemption and page-fault processing,
but page_address() doesn't. When removing uses of kmap_atomic(), one has to
check if the code being executed between the map/unmap implicitly depends
on page-faults and/or preemption being disabled. If yes, then code to
disable page-faults and/or preemption should also be added for functional
correctness. That however doesn't appear to be the case here, so just
page_address() is used.

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
v1 -> v2: Update commit message
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

