Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6F406F67
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhIJQQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233559AbhIJQQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 825156124F;
        Fri, 10 Sep 2021 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290504;
        bh=Pnw9BwkXJDP7oJrFD/r/oGqS802iVmEru0VedR4zESk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7kug6zCCJq9SKn+xrvlg/55FWcHq8zC/UGAi2e8v/Z+IXDg1g2VYLRXZZOPSThVx
         IsH4CDji+DXHxdMWIfsKyT+5qt68AehPu8ixiGz7RHgMEegMBAeuS8xS4Mv2Awlf8R
         UadRCyvWMPlqsOZkqN2pKEJXBvG+SNY6t8sBXanpYwN313EaepusjzKWg9tR2gw4yq
         sTYi5GZg6GrtbAK3Eua6fMo3yPL6WuX1H5+L52mZfyVjgHz2YpKBFgirrReRTg2MPX
         7q6GTJmtR/p1nTRR2coP+1Vzm+8/Sw4wdfh3+kn1wH55ovau6HKY/Iul614fcv97rj
         lHUCvdUe780AQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 04/18] net: mvneta: simplify mvneta_swbm_add_rx_fragment management
Date:   Fri, 10 Sep 2021 18:14:10 +0200
Message-Id: <a808a51e43a7335bad4c0712d41301cc858a23e0.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relying on xdp mb bit, remove skb_shared_info structure allocated on the
stack in mvneta_rx_swbm routine and simplify mvneta_swbm_add_rx_fragment
accessing skb_shared_info in the xdp_buff structure directly. There is no
performance penalty in this approach since mvneta_swbm_add_rx_fragment
is run just for multi-buff use-case.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 42 ++++++++++-----------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0c7b84ca6efc..99976679c6e5 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2032,9 +2032,9 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 
 static void
 mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
-		    struct xdp_buff *xdp, struct skb_shared_info *sinfo,
-		    int sync_len)
+		    struct xdp_buff *xdp, int sync_len)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i;
 
 	if (likely(!xdp_buff_is_mb(xdp)))
@@ -2182,7 +2182,6 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp,
 	       u32 frame_sz, struct mvneta_stats *stats)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	unsigned int len, data_len, sync;
 	u32 ret, act;
 
@@ -2203,7 +2202,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (unlikely(err)) {
-			mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
+			mvneta_xdp_put_buff(pp, rxq, xdp, sync);
 			ret = MVNETA_XDP_DROPPED;
 		} else {
 			ret = MVNETA_XDP_REDIR;
@@ -2214,7 +2213,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
-			mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
+			mvneta_xdp_put_buff(pp, rxq, xdp, sync);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2223,7 +2222,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-		mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
+		mvneta_xdp_put_buff(pp, rxq, xdp, sync);
 		ret = MVNETA_XDP_DROPPED;
 		stats->xdp_drop++;
 		break;
@@ -2275,9 +2274,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
 			    struct xdp_buff *xdp, int *size,
-			    struct skb_shared_info *xdp_sinfo,
 			    struct page *page)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	int data_len, len;
@@ -2295,8 +2294,11 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 				len, dma_dir);
 	rx_desc->buf_phys_addr = 0;
 
-	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
-		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
+	if (!xdp_buff_is_mb(xdp))
+		sinfo->nr_frags = 0;
+
+	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
+		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags++];
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
@@ -2307,16 +2309,6 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
-
-	/* last fragment */
-	if (len == *size) {
-		struct skb_shared_info *sinfo;
-
-		sinfo = xdp_get_shared_info_from_buff(xdp);
-		sinfo->nr_frags = xdp_sinfo->nr_frags;
-		memcpy(sinfo->frags, xdp_sinfo->frags,
-		       sinfo->nr_frags * sizeof(skb_frag_t));
-	}
 	*size -= len;
 }
 
@@ -2364,7 +2356,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rx_proc = 0, rx_todo, refill, size = 0;
 	struct net_device *dev = pp->dev;
-	struct skb_shared_info sinfo;
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	u32 desc_status, frame_sz;
@@ -2373,8 +2364,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	xdp_init_buff(&xdp_buf, PAGE_SIZE, &rxq->xdp_rxq);
 	xdp_buf.data_hard_start = NULL;
 
-	sinfo.nr_frags = 0;
-
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
@@ -2416,7 +2405,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			}
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
-						    &size, &sinfo, page);
+						    &size, page);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
@@ -2424,7 +2413,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			continue;
 
 		if (size) {
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1);
 			goto next;
 		}
 
@@ -2436,7 +2425,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1);
 
 			u64_stats_update_begin(&stats->syncp);
 			stats->es.skb_alloc_error++;
@@ -2453,11 +2442,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		napi_gro_receive(napi, skb);
 next:
 		xdp_buf.data_hard_start = NULL;
-		sinfo.nr_frags = 0;
 	}
 
 	if (xdp_buf.data_hard_start)
-		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
+		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1);
 
 	if (ps.xdp_redirect)
 		xdp_do_flush_map();
-- 
2.31.1

