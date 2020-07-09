Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0EE21A42A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgGIP5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgGIP5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:57:41 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C912077D;
        Thu,  9 Jul 2020 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594310260;
        bh=F6NlgJdtnedy/2+eR4MjbaifyV3gRMJMaoyd/IRuuBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2wjSR7b8LQF73T8jRn6YNbHKz8dEzsS3SS5R/oCRCiQKKAUllwJFZJFFlhq5kBjH
         +F2DZ9q5GuPNh0jT0NwTsPNyPbIGlfsXFFaOMEYL06ZBLtp3ZxzRANq02doTTwciQb
         8Sca5BBA3a4cjRLt8XTiUoAFQz46bjpW9LwSufdM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH 2/6] net: mvneta: move skb build after descriptors processing
Date:   Thu,  9 Jul 2020 17:57:19 +0200
Message-Id: <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594309075.git.lorenzo@kernel.org>
References: <cover.1594309075.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move skb build after all descriptors processing. This is a preliminary
patch to enable multi-buffers and JUMBO frames support for XDP.
Introduce mvneta_xdp_put_buff routine to release all pages used by a
XDP multi-buffer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 157 ++++++++++++++++----------
 1 file changed, 100 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 37b9c75a5a60..678f90ccf271 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2026,6 +2026,21 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 	return i;
 }
 
+static void
+mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
+		    struct xdp_buff *xdp, int sync_len, bool napi)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	struct page *page = virt_to_head_page(xdp->data);
+	int i, size = sync_len > 0 ? sync_len : -1;
+
+	page_pool_put_page(rxq->page_pool, page, size, napi);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		page = sinfo->frags[i].bv_page;
+		page_pool_put_page(rxq->page_pool, page, size, napi);
+	}
+}
+
 static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 			struct xdp_frame *xdpf, bool dma_map)
@@ -2229,6 +2244,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
+	struct skb_shared_info *sinfo;
 	int ret = 0;
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
@@ -2252,35 +2268,13 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp->data_end = xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
 
-	if (xdp_prog) {
-		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp, stats);
-		if (ret)
-			goto out;
-	}
-
-	rxq->skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
-	if (unlikely(!rxq->skb)) {
-		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-
-		netdev_err(dev, "Can't allocate skb on queue %d\n", rxq->id);
-
-		u64_stats_update_begin(&stats->syncp);
-		stats->es.skb_alloc_error++;
-		stats->rx_dropped++;
-		u64_stats_update_end(&stats->syncp);
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	sinfo->nr_frags = 0;
 
-		return -ENOMEM;
-	}
-	page_pool_release_page(rxq->page_pool, page);
-
-	skb_reserve(rxq->skb,
-		    xdp->data - xdp->data_hard_start);
-	skb_put(rxq->skb, xdp->data_end - xdp->data);
-	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
+	if (xdp_prog)
+		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp, stats);
 
 	rxq->left_size = rx_desc->data_size - len;
-
-out:
 	rx_desc->buf_phys_addr = 0;
 
 	return ret;
@@ -2290,8 +2284,10 @@ static void
 mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
+			    struct xdp_buff *xdp,
 			    struct page *page)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	int data_len, len;
@@ -2307,18 +2303,51 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	dma_sync_single_for_cpu(dev->dev.parent,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
-	if (data_len > 0) {
-		/* refill descriptor with new buffer later */
-		skb_add_rx_frag(rxq->skb,
-				skb_shinfo(rxq->skb)->nr_frags,
-				page, pp->rx_offset_correction, data_len,
-				PAGE_SIZE);
-	}
-	page_pool_release_page(rxq->page_pool, page);
-	rx_desc->buf_phys_addr = 0;
+
+	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
+		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
+
+		frag->bv_offset = pp->rx_offset_correction;
+		skb_frag_size_set(frag, data_len);
+		frag->bv_page = page;
+		sinfo->nr_frags++;
+
+		rx_desc->buf_phys_addr = 0;
+	}
 	rxq->left_size -= len;
 }
 
+static struct sk_buff *
+mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
+		      struct xdp_buff *xdp, u32 desc_status)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int i, num_frags = sinfo->nr_frags;
+	skb_frag_t frags[MAX_SKB_FRAGS];
+	struct sk_buff *skb;
+
+	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
+
+	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
+
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	skb_put(skb, xdp->data_end - xdp->data);
+	mvneta_rx_csum(pp, desc_status, skb);
+
+	for (i = 0; i < num_frags; i++) {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				frags[i].bv_page, frags[i].bv_offset,
+				skb_frag_size(&frags[i]), PAGE_SIZE);
+		page_pool_release_page(rxq->page_pool, frags[i].bv_page);
+	}
+
+	return skb;
+}
+
 /* Main rx processing when using software buffer management */
 static int mvneta_rx_swbm(struct napi_struct *napi,
 			  struct mvneta_port *pp, int budget,
@@ -2326,22 +2355,25 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rx_proc = 0, rx_todo, refill;
 	struct net_device *dev = pp->dev;
+	struct xdp_buff xdp_buf = {
+		.frame_sz = PAGE_SIZE,
+		.rxq = &rxq->xdp_rxq,
+	};
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
-	struct xdp_buff xdp_buf;
+	u32 desc_status;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(pp->xdp_prog);
-	xdp_buf.rxq = &rxq->xdp_rxq;
-	xdp_buf.frame_sz = PAGE_SIZE;
 
 	/* Fairness NAPI loop */
 	while (rx_proc < budget && rx_proc < rx_todo) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
 		u32 rx_status, index;
+		struct sk_buff *skb;
 		struct page *page;
 
 		index = rx_desc - rxq->descs;
@@ -2357,21 +2389,21 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			/* Check errors only for FIRST descriptor */
 			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
-				/* leave the descriptor untouched */
-				continue;
+				goto next;
 			}
 
 			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 						   xdp_prog, page, &ps);
 			if (err)
 				continue;
+
+			desc_status = rx_desc->status;
 		} else {
-			if (unlikely(!rxq->skb)) {
-				pr_debug("no skb for rx_status 0x%x\n",
-					 rx_status);
+			if (unlikely(!xdp_buf.data_hard_start))
 				continue;
-			}
-			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, page);
+
+			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
+						    page);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
@@ -2379,27 +2411,38 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			continue;
 
 		if (rxq->left_size) {
-			pr_err("get last desc, but left_size (%d) != 0\n",
-			       rxq->left_size);
-			dev_kfree_skb_any(rxq->skb);
 			rxq->left_size = 0;
-			rxq->skb = NULL;
-			continue;
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+			goto next;
 		}
 
-		ps.rx_bytes += rxq->skb->len;
-		ps.rx_packets++;
+		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
+		if (IS_ERR(skb)) {
+			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
-		/* Linux processing */
-		rxq->skb->protocol = eth_type_trans(rxq->skb, dev);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+
+			u64_stats_update_begin(&stats->syncp);
+			stats->es.skb_alloc_error++;
+			stats->rx_dropped++;
+			u64_stats_update_end(&stats->syncp);
+
+			goto next;
+		}
 
-		napi_gro_receive(napi, rxq->skb);
+		ps.rx_bytes += skb->len;
+		ps.rx_packets++;
 
-		/* clean uncomplete skb pointer in queue */
-		rxq->skb = NULL;
+		skb->protocol = eth_type_trans(skb, dev);
+		napi_gro_receive(napi, skb);
+next:
+		xdp_buf.data_hard_start = NULL;
 	}
 	rcu_read_unlock();
 
+	if (xdp_buf.data_hard_start)
+		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+
 	if (ps.xdp_redirect)
 		xdp_do_flush_map();
 
-- 
2.26.2

