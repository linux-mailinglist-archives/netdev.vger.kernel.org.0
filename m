Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354C02FC0E3
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbhASUYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbhASUWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF79323119;
        Tue, 19 Jan 2021 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087647;
        bh=xpdKrm8ZcTc0HwbnQvHlKBZmoqejubUtzFtDYJ82BdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0+hSu4mV3DvlS6bIAyIR1RCM4FyszhhkgkeFoTIluuTPzz3HxNWKKaFFKNK4r7hm
         8IN7vnHSVyoYyygVHvtctxgqHtDM2Fn1kqfXsTHvCN2Eg4QDwE8MSixhK56zZI6UcR
         iCDQ9jEmbEs3vqLIyB4Od2IL1Oh31splpI0ifV1IbbVSKHtcCOE7M+exAPLH63NsmM
         1W7/kFI34pdhLC3m6TuC8MNOmCXZ9QcuZwbrjyQKCgtwdlYZtrVjX0IK1KUO6+MSNL
         VAtnU859OPvW6V9TnBby1Esn59C5NEM1TnFMX8+NJzpbX+tfwysY7PMoUaUEMmZnY4
         YzXor2U3EVzig==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 4/8] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Tue, 19 Jan 2021 21:20:10 +0100
Message-Id: <1542d03761990429276d72fcb94f7e91d63e7e1f.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
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
index ca7c4fb30b4e..a2e09031b346 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -286,6 +286,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
 void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
 void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 			   struct xdp_frame_bulk *bq);
+void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
@@ -296,10 +297,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
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
index 0d2630a35c3e..af9b9c1194fc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -374,12 +374,38 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 
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
+		__xdp_return(page_address(page), &xdpf->mem, false, NULL);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
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
+		__xdp_return(page_address(page), &xdpf->mem, true, NULL);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
@@ -415,7 +441,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 	struct xdp_mem_allocator *xa;
 
 	if (mem->type != MEM_TYPE_PAGE_POOL) {
-		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
+		xdp_return_frame(xdpf);
 		return;
 	}
 
@@ -434,15 +460,63 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
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
+		__xdp_return(page_address(page), &xdp->rxq->mem, true, xdp);
+	}
+out:
 	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
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
+		__xdp_return(page_address(page), &xdp->rxq->mem, false, NULL);
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
2.29.2

