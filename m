Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDE16652C3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjAKEW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjAKEWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FF0DFC6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VCC7zk0y8ZK0ii1fcA4LBC62+hbVnPqfAL8JxgfRigk=; b=YqJ/crgQ+MgBIm7HmucCZhNYCi
        zospNW1BkE5uD79CZxLj0VVa58ju6lr28cZoOsOudE3WL3ikt+lurEPL/aW1gnbLmpQLjmrioxIjh
        CVAlFd8+hDvvoIrMd+WrGd7sySH6k+BkKk2ASVrcHtEsdpreuKt8o4rqvtJswyc6/9hPJdPq5sGtQ
        rXR1S/Hzzieo69yFT42iUT/TsAVO/jHk0aFC+3uOfLPcJq20vz3F+RcWm8CxlXADoCzSsyjZUbTdG
        LtsQpwzq8uIEizS6dhQcpxX55tUc89Kv9APkHEuIXhLeki7p/2x97HNvywgsJBsb3OkudCQMnnovg
        58IgkTpA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFSd0-003nzI-D3; Wed, 11 Jan 2023 04:22:18 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 24/26] mvneta: Convert to netmem
Date:   Wed, 11 Jan 2023 04:22:12 +0000
Message-Id: <20230111042214.907030-25-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the netmem APIs instead of the page APIs.  Improves type-safety.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 48 +++++++++++++--------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f8925cac61e4..6177d2ffd33c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1931,15 +1931,15 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 			    gfp_t gfp_mask)
 {
 	dma_addr_t phys_addr;
-	struct page *page;
+	struct netmem *nmem;
 
-	page = page_pool_alloc_pages(rxq->page_pool,
+	nmem = page_pool_alloc_netmem(rxq->page_pool,
 				     gfp_mask | __GFP_NOWARN);
-	if (!page)
+	if (!nmem)
 		return -ENOMEM;
 
-	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
-	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
+	phys_addr = netmem_get_dma_addr(nmem) + pp->rx_offset_correction;
+	mvneta_rx_desc_fill(rx_desc, phys_addr, nmem, rxq);
 
 	return 0;
 }
@@ -2006,7 +2006,7 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 		if (!data || !(rx_desc->buf_phys_addr))
 			continue;
 
-		page_pool_put_full_page(rxq->page_pool, data, false);
+		page_pool_put_full_netmem(rxq->page_pool, data, false);
 	}
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
@@ -2072,11 +2072,11 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		goto out;
 
 	for (i = 0; i < sinfo->nr_frags; i++)
-		page_pool_put_full_page(rxq->page_pool,
-					skb_frag_page(&sinfo->frags[i]), true);
+		page_pool_put_full_netmem(rxq->page_pool,
+				skb_frag_netmem(&sinfo->frags[i]), true);
 
 out:
-	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
+	page_pool_put_netmem(rxq->page_pool, virt_to_netmem(xdp->data),
 			   sync_len, true);
 }
 
@@ -2088,7 +2088,6 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	struct device *dev = pp->dev->dev.parent;
 	struct mvneta_tx_desc *tx_desc;
 	int i, num_frames = 1;
-	struct page *page;
 
 	if (unlikely(xdp_frame_has_frags(xdpf)))
 		num_frames += sinfo->nr_frags;
@@ -2123,9 +2122,10 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 
 			buf->type = MVNETA_TYPE_XDP_NDO;
 		} else {
-			page = unlikely(frag) ? skb_frag_page(frag)
-					      : virt_to_page(xdpf->data);
-			dma_addr = page_pool_get_dma_addr(page);
+			struct netmem *nmem = unlikely(frag) ?
+						skb_frag_netmem(frag) :
+						virt_to_netmem(xdpf->data);
+			dma_addr = netmem_get_dma_addr(nmem);
 			if (unlikely(frag))
 				dma_addr += skb_frag_off(frag);
 			else
@@ -2308,9 +2308,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp, int *size,
-		     struct page *page)
+		     struct netmem *nmem)
 {
-	unsigned char *data = page_address(page);
+	unsigned char *data = netmem_to_virt(nmem);
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
@@ -2343,7 +2343,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
 			    struct xdp_buff *xdp, int *size,
-			    struct page *page)
+			    struct netmem *nmem)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct net_device *dev = pp->dev;
@@ -2371,16 +2371,16 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
-		__skb_frag_set_page(frag, page);
+		__skb_frag_set_netmem(frag, nmem);
 
 		if (!xdp_buff_has_frags(xdp)) {
 			sinfo->xdp_frags_size = *size;
 			xdp_buff_set_frags_flag(xdp);
 		}
-		if (page_is_pfmemalloc(page))
+		if (netmem_is_pfmemalloc(nmem))
 			xdp_buff_set_frag_pfmemalloc(xdp);
 	} else {
-		page_pool_put_full_page(rxq->page_pool, page, true);
+		page_pool_put_full_netmem(rxq->page_pool, nmem, true);
 	}
 	*size -= len;
 }
@@ -2440,10 +2440,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
 		u32 rx_status, index;
 		struct sk_buff *skb;
-		struct page *page;
+		struct netmem *nmem;
 
 		index = rx_desc - rxq->descs;
-		page = (struct page *)rxq->buf_virt_addr[index];
+		nmem = rxq->buf_virt_addr[index];
 
 		rx_status = rx_desc->status;
 		rx_proc++;
@@ -2461,17 +2461,17 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			desc_status = rx_status;
 
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-					     &size, page);
+					     &size, nmem);
 		} else {
 			if (unlikely(!xdp_buf.data_hard_start)) {
 				rx_desc->buf_phys_addr = 0;
-				page_pool_put_full_page(rxq->page_pool, page,
+				page_pool_put_full_netmem(rxq->page_pool, nmem,
 							true);
 				goto next;
 			}
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
-						    &size, page);
+						    &size, nmem);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
-- 
2.35.1

