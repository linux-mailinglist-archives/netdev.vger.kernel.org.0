Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF6327ED96
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgI3Pmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbgI3Pmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:42:36 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D35B520738;
        Wed, 30 Sep 2020 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601480555;
        bh=eKPJVzu6E5/S5wENfNGlIxA6X+/VOWn+imBWPRph7Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amWYgM4RMH0spzqabcGmncwJmv6YRYnhBBsN+xvxOrT2yjThaD+CfqACQFOSGZ6To
         dGDABoZr3vdAbPcqcgd0WrdCxYFfFegG2v+44XRQ3T9ArbWHYE7ZPm3AmTEO6XqiEM
         2lxtSTMy8cDyIXfMtdBLc11CDA+wLS6rjJBloDzk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 net-next 03/12] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Wed, 30 Sep 2020 17:41:54 +0200
Message-Id: <381e1fa2fb5c091780677a9b4f2518a2b3c591a0.1601478613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer. Access
skb_shared_info only if xdp_buff mb is set

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 42 +++++++++++++++++----------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index d095718355d3..a431e8478297 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2027,12 +2027,17 @@ static void
 mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		    struct xdp_buff *xdp, int sync_len, bool napi)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	struct skb_shared_info *sinfo;
 	int i;
 
+	if (likely(!xdp->mb))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
 	for (i = 0; i < sinfo->nr_frags; i++)
 		page_pool_put_full_page(rxq->page_pool,
 					skb_frag_page(&sinfo->frags[i]), napi);
+out:
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
 			   sync_len, napi);
 }
@@ -2234,7 +2239,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	struct skb_shared_info *sinfo;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2259,9 +2263,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	sinfo->nr_frags = 0;
 }
 
 static void
@@ -2272,9 +2273,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct page *page)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int data_len, len, nfrags = xdp->mb ? sinfo->nr_frags : 0;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	int data_len, len;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2288,17 +2289,21 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
-	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
-		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
+	if (data_len > 0 && nfrags < MAX_SKB_FRAGS) {
+		skb_frag_t *frag = &sinfo->frags[nfrags];
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
-		sinfo->nr_frags++;
-
-		rx_desc->buf_phys_addr = 0;
+		nfrags++;
+	} else {
+		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
+
+	rx_desc->buf_phys_addr = 0;
+	sinfo->nr_frags = nfrags;
 	*size -= len;
+	xdp->mb = 1;
 }
 
 static struct sk_buff *
@@ -2306,7 +2311,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
+	int i, num_frags = xdp->mb ? sinfo->nr_frags : 0;
 	struct sk_buff *skb;
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
@@ -2319,6 +2324,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	skb_put(skb, xdp->data_end - xdp->data);
 	mvneta_rx_csum(pp, desc_status, skb);
 
+	if (likely(!xdp->mb))
+		return skb;
+
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
 
@@ -2338,13 +2346,14 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
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
+
+	xdp_buf.data_hard_start = NULL;
+	xdp_buf.frame_sz = PAGE_SIZE;
+	xdp_buf.rxq = &rxq->xdp_rxq;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -2377,6 +2386,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_status;
 
+			xdp_buf.mb = 0;
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
 		} else {
-- 
2.26.2

