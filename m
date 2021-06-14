Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E13A6704
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhFNMwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhFNMwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 319E561283;
        Mon, 14 Jun 2021 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675051;
        bh=Nj35GSzUbIa7ljLgxeLcoq0EpeKH57VzntxLbVOg0Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj1YqgITtHxpoVUP0a7EUrh+oWAc7F/zAsikRT6Dhyp3JDN2cz9d0UOBIuIRZH3a5
         OpNRTMCP35yKF4AVrTuKWgw8kiBvpMaWNjX8UJvA0STQJR8MQGu30Tm33q4Ib3UhoX
         8DNQ629ZTB6SX80hRXFBXvfMfpDVbjr46xNs2NDItqqyZckMRU/mnFnc2wUZFYMSFd
         Hev/c/qGkpiYgitxNiasDE4Tl5YOW9k2Zm/uER1lx63dPikpIM96vwwAWKLWNzvbhA
         XEs1I/igwbr0FuVS70hn4u/xWVIUihlVXQJIzUMlWwU6+zTrDBPQgNerd3mubDpjCr
         AU1G4QZcBmY2g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 04/14] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Mon, 14 Jun 2021 14:49:42 +0200
Message-Id: <e444d31ca2c691e7573289064d007c3b7a1bca10.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
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
 include/net/xdp.h | 18 ++++++++++++++--
 net/core/xdp.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index de11d981fa44..935a6f83115f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -275,10 +275,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
 static inline void xdp_release_frame(struct xdp_frame *xdpf)
 {
 	struct xdp_mem_info *mem = &xdpf->mem;
+	struct skb_shared_info *sinfo;
+	int i;
 
 	/* Curr only page_pool needs this */
-	if (mem->type == MEM_TYPE_PAGE_POOL)
-		__xdp_release_frame(xdpf->data, mem);
+	if (mem->type != MEM_TYPE_PAGE_POOL)
+		return;
+
+	if (likely(!xdp_frame_is_mb(xdpf)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_release_frame(page_address(page), mem);
+	}
+out:
+	__xdp_release_frame(xdpf->data, mem);
 }
 
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 725d20f1b100..f61c63115c95 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -375,12 +375,38 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdp_frame_is_mb(xdpf)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, false, NULL);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdp_frame_is_mb(xdpf)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, true, NULL);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
@@ -416,7 +442,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 	struct xdp_mem_allocator *xa;
 
 	if (mem->type != MEM_TYPE_PAGE_POOL) {
-		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
+		xdp_return_frame(xdpf);
 		return;
 	}
 
@@ -435,12 +461,38 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 	}
 
+	if (unlikely(xdp_frame_is_mb(xdpf))) {
+		struct skb_shared_info *sinfo;
+		int i;
+
+		sinfo = xdp_get_shared_info_from_frame(xdpf);
+		for (i = 0; i < sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+
+			bq->q[bq->count++] = skb_frag_address(frag);
+			if (bq->count == XDP_BULK_QUEUE_SIZE)
+				xdp_flush_frame_bulk(bq);
+		}
+	}
 	bq->q[bq->count++] = xdpf->data;
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdp_buff_is_mb(xdp)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdp->rxq->mem, true, xdp);
+	}
+out:
 	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
 }
 
-- 
2.31.1

