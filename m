Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE61325CBA2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgICU73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbgICU72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:28 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324CE20797;
        Thu,  3 Sep 2020 20:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166767;
        bh=7yi9bTxOu1iS+VDXVy6aMdGtvip+lRfsQez7FElZpDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWyplRlSR1WYqdJTVZfhdXLUGCD4JGGhOr+lK+/09JELEhGRnROrqKe5WTjxJe7AH
         wLo4lVYYJy6EH4ngB8d6Cqzs8bEx+FeI3REqP+kBj7uMy7RzK+G5lVA9zRxic9cLjM
         qQLfxGSheW39Qg3BzmM1WgGFGkRxjnRBw+G9N1QU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 3/9] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Thu,  3 Sep 2020 22:58:47 +0200
Message-Id: <25198d8424778abe9ee3fe25bba542143201b030.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer. Access
skb_shared_info only if xdp_buff mb is set

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 37 +++++++++++++++------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 832bbb8b05c8..4f745a2b702a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2027,11 +2027,11 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		    struct xdp_buff *xdp, int sync_len, bool napi)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i;
+	int i, num_frames = xdp->mb ? sinfo->nr_frags : 0;
 
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
 			   sync_len, napi);
-	for (i = 0; i < sinfo->nr_frags; i++)
+	for (i = 0; i < num_frames; i++)
 		page_pool_put_full_page(rxq->page_pool,
 					skb_frag_page(&sinfo->frags[i]), napi);
 }
@@ -2175,6 +2175,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
 	data_len = xdp->data_end - xdp->data;
+
 	act = bpf_prog_run_xdp(prog, xdp);
 
 	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
@@ -2234,7 +2235,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	struct skb_shared_info *sinfo;
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2256,9 +2256,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	sinfo->nr_frags = 0;
+	xdp->mb = 0;
 
 	*size = rx_desc->data_size - len;
 	rx_desc->buf_phys_addr = 0;
@@ -2269,7 +2267,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
 			    struct xdp_buff *xdp, int *size,
-			    struct page *page)
+			    int *nfrags, struct page *page)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct net_device *dev = pp->dev;
@@ -2288,13 +2286,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
-	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
-		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
+	if (data_len > 0 && *nfrags < MAX_SKB_FRAGS) {
+		skb_frag_t *frag = &sinfo->frags[*nfrags];
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
-		sinfo->nr_frags++;
+		*nfrags = *nfrags + 1;
+
+		if (rx_desc->status & MVNETA_RXD_LAST_DESC) {
+			sinfo->nr_frags = *nfrags;
+			xdp->mb = true;
+		}
 
 		rx_desc->buf_phys_addr = 0;
 	}
@@ -2306,7 +2309,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
+	int i, num_frags = xdp->mb ? sinfo->nr_frags : 0;
 	skb_frag_t frags[MAX_SKB_FRAGS];
 	struct sk_buff *skb;
 
@@ -2341,13 +2344,14 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rx_proc = 0, rx_todo, refill, size = 0;
 	struct net_device *dev = pp->dev;
-	struct xdp_buff xdp_buf = {
-		.frame_sz = PAGE_SIZE,
-		.rxq = &rxq->xdp_rxq,
-	};
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	u32 desc_status, frame_sz;
+	struct xdp_buff xdp_buf;
+	int nfrags;
+
+	xdp_buf.frame_sz = PAGE_SIZE;
+	xdp_buf.rxq = &rxq->xdp_rxq;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -2379,6 +2383,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			size = rx_desc->data_size;
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_desc->status;
+			nfrags = 0;
 
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page, &ps);
@@ -2387,7 +2392,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				continue;
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
-						    &size, page);
+						    &size, &nfrags, page);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
-- 
2.26.2

