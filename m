Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE552BB12C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgKTRGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgKTRGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:06:22 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E57122252;
        Fri, 20 Nov 2020 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605891982;
        bh=/INFXjbcblAoycPvhGQ002NZFMiDjRHP7HSbLO1dTUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRwGfodnCliDE1wAZYBpRMExh67aM22BdkSF4wwdej4445EApO4QPYV4qtKOj2T8X
         MVqWCmDSfdClGdtBM34V7X5meWklcFrv5nIWjiO1zUNqybV+pgD/jLn8cTjT4tW5vZ
         +9B2qD4VkIOeZzw2AfIlZksIY/81e76mcTPIDSKc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com
Subject: [PATCH net-next 3/3] net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack
Date:   Fri, 20 Nov 2020 18:05:44 +0100
Message-Id: <4dfbab639c10d60c17d6aaca96addccbb2aeb737.1605889259.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605889258.git.lorenzo@kernel.org>
References: <cover.1605889258.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
skb_shared_info area only on the last fragment. Leftover cache miss in
mvneta_swbm_rx_frame will be addressed introducing mb bit in
xdp_buff/xdp_frame struct

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 42 +++++++++++++++------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 17c446b1cb94..b40804e421a7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2278,9 +2278,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
 			    struct xdp_buff *xdp, int *size,
+			    struct skb_shared_info *xdp_sinfo,
 			    struct page *page)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	int data_len, len;
@@ -2298,13 +2298,22 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 				len, dma_dir);
 	rx_desc->buf_phys_addr = 0;
 
-	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
-		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
+	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
+		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
-		sinfo->nr_frags++;
+
+		/* last fragment */
+		if (len == *size) {
+			struct skb_shared_info *sinfo;
+
+			sinfo = xdp_get_shared_info_from_buff(xdp);
+			sinfo->nr_frags = xdp_sinfo->nr_frags;
+			memcpy(sinfo->frags, xdp_sinfo->frags,
+			       sinfo->nr_frags * sizeof(skb_frag_t));
+		}
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
@@ -2348,6 +2357,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rx_proc = 0, rx_todo, refill, size = 0;
 	struct net_device *dev = pp->dev;
+	struct skb_shared_info sinfo;
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	u32 desc_status, frame_sz;
@@ -2357,6 +2367,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	xdp_buf.frame_sz = PAGE_SIZE;
 	xdp_buf.rxq = &rxq->xdp_rxq;
 
+	sinfo.nr_frags = 0;
+
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
@@ -2395,11 +2407,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				rx_desc->buf_phys_addr = 0;
 				page_pool_put_full_page(rxq->page_pool, page,
 							true);
-				continue;
+				goto next;
 			}
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
-						    &size, page);
+						    &size, &sinfo, page);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
@@ -2407,10 +2419,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			continue;
 
 		if (size) {
-			struct skb_shared_info *sinfo;
-
-			sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
 			goto next;
 		}
 
@@ -2421,10 +2430,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-			struct skb_shared_info *sinfo;
 
-			sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
 
 			u64_stats_update_begin(&stats->syncp);
 			stats->es.skb_alloc_error++;
@@ -2441,15 +2448,12 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		napi_gro_receive(napi, skb);
 next:
 		xdp_buf.data_hard_start = NULL;
+		sinfo.nr_frags = 0;
 	}
 	rcu_read_unlock();
 
-	if (xdp_buf.data_hard_start) {
-		struct skb_shared_info *sinfo;
-
-		sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
-		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
-	}
+	if (xdp_buf.data_hard_start)
+		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
 
 	if (ps.xdp_redirect)
 		xdp_do_flush_map();
-- 
2.26.2

