Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30AA42F1D0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhJONMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239297AbhJONME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C4F611C8;
        Fri, 15 Oct 2021 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303398;
        bh=NbNZG6b0deKYfB3Y2tjK2qrfrYatTreH3lXdTKRRQtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4rzuEX5n/OsynMytiwUjUvOpT2aF+vW97DYek4KK2lo0k1No62gJssqEylruVbJc
         WW29lkRHfxW34HODdSn0810Z5ZCtgMzKYNcfj44EdyZ2V7A1N5Bn8NsuQpHds1Z0i9
         gVhDhYT4wQLL6x9r980rAl+6L2D7rqC0jWpJ/rm+EATpQAVUy5buxhsPVOeluJwdzt
         jUd9T8EiZHbuxEqKUfrGIZBCnKrC4hTQIcfgzmlDjNGalev1vB4ZlM6BH5auQTTNa9
         19M97l23HSGgaioAcjfaZSZ9l2e7Sxe/oblVbkfKcybUXR4Lmj1QE0KWDjCV9stbsk
         keZYRhB/xODSQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 07/20] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Fri, 15 Oct 2021 15:08:44 +0200
Message-Id: <ede20bbe1ad9f51c1733a4646c097196ef0addd2.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account if the received xdp_buff/xdp_frame is non-linear
recycling/returning the frame memory to the allocator or into
xdp_frame_bulk.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 18 ++++++++++++++--
 net/core/xdp.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index e594016eb193..798b84d86d97 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -306,10 +306,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
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
index adfafd533d35..6cdb7d50ef90 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -376,12 +376,38 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 
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
@@ -417,7 +443,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 	struct xdp_mem_allocator *xa;
 
 	if (mem->type != MEM_TYPE_PAGE_POOL) {
-		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
+		xdp_return_frame(xdpf);
 		return;
 	}
 
@@ -436,12 +462,38 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
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

