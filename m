Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97E02D161B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgLGQeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgLGQeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:16 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 05/14] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Mon,  7 Dec 2020 17:32:34 +0100
Message-Id: <662d5db543dba3b933ed604c5cf7944d0df65c38.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account if the received xdp_buff/xdp_frame is non-linear
recycling/returning the frame memory to the allocator or into
xdp_frame_bulk.
Introduce xdp_return_num_frags_from_buff to return a given number of
fragments from a xdp multi-buff starting from the tail.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 19 ++++++++++--
 net/core/xdp.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 614f66d35ee8..d0e90d729023 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -258,6 +258,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
 void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
 void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 			   struct xdp_frame_bulk *bq);
+void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
@@ -268,10 +269,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
 static inline void xdp_release_frame(struct xdp_frame *xdpf)
 {
 	struct xdp_mem_info *mem = &xdpf->mem;
+	struct xdp_shared_info *xdp_sinfo;
+	int i;
 
 	/* Curr only page_pool needs this */
-	if (mem->type == MEM_TYPE_PAGE_POOL)
-		__xdp_release_frame(xdpf->data, mem);
+	if (mem->type != MEM_TYPE_PAGE_POOL)
+		return;
+
+	if (likely(!xdpf->mb))
+		goto out;
+
+	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
+
+		__xdp_release_frame(page_address(page), mem);
+	}
+out:
+	__xdp_release_frame(xdpf->data, mem);
 }
 
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 79dd45234e4d..6c8e743ad03a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -371,12 +371,38 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
+	struct xdp_shared_info *xdp_sinfo;
+	int i;
+
+	if (likely(!xdpf->mb))
+		goto out;
+
+	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, false);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, false);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
+	struct xdp_shared_info *xdp_sinfo;
+	int i;
+
+	if (likely(!xdpf->mb))
+		goto out;
+
+	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, true);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, true);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
@@ -412,7 +438,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 	struct xdp_mem_allocator *xa;
 
 	if (mem->type != MEM_TYPE_PAGE_POOL) {
-		__xdp_return(xdpf->data, &xdpf->mem, false);
+		xdp_return_frame(xdpf);
 		return;
 	}
 
@@ -431,15 +457,63 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 	}
 
+	if (unlikely(xdpf->mb)) {
+		struct xdp_shared_info *xdp_sinfo;
+		int i;
+
+		xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+		for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &xdp_sinfo->frags[i];
+
+			bq->q[bq->count++] = xdp_get_frag_address(frag);
+			if (bq->count == XDP_BULK_QUEUE_SIZE)
+				xdp_flush_frame_bulk(bq);
+		}
+	}
 	bq->q[bq->count++] = xdpf->data;
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
+	struct xdp_shared_info *xdp_sinfo;
+	int i;
+
+	if (likely(!xdp->mb))
+		goto out;
+
+	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
+	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdp->rxq->mem, true);
+	}
+out:
 	__xdp_return(xdp->data, &xdp->rxq->mem, true);
 }
 
+void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags)
+{
+	struct xdp_shared_info *xdp_sinfo;
+	int i;
+
+	if (unlikely(!xdp->mb))
+		return;
+
+	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
+	num_frags = min_t(u16, num_frags, xdp_sinfo->nr_frags);
+	for (i = 1; i <= num_frags; i++) {
+		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags - i];
+		struct page *page = xdp_get_frag_page(frag);
+
+		xdp_sinfo->data_length -= xdp_get_frag_size(frag);
+		__xdp_return(page_address(page), &xdp->rxq->mem, false);
+	}
+	xdp_sinfo->nr_frags -= num_frags;
+	xdp->mb = !!xdp_sinfo->nr_frags;
+}
+EXPORT_SYMBOL_GPL(xdp_return_num_frags_from_buff);
+
 /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
 void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
 {
-- 
2.28.0

