Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB64B3D8AD4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhG1JjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235675AbhG1JjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A68D60F9E;
        Wed, 28 Jul 2021 09:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465159;
        bh=4egFTZCKZVcn22BotCe1jAvf3Uk0dgUZkZCLUZqHBxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0fVBb9kqbFsE7Zzy11PJQzZN/VrsfnJPuXCAuVlvFYAtXIO+eN9KuRMUL4O0KhvU
         x+iyCpHm6E6mzLi3pM4TE02rbjt0k1iagl98yZ36F63IDKM/ff94rZDkMKpQdB24YK
         4wHW83p4ZcqO3yHelRdxV2fFEmaArjsiHYgJsXX1tFe/oUM553ewzBzLhpj45zFAxP
         DH0uJ4h+gvlBEStfIY2rge8lRyuZZ3Ry5vqQJg+oGOloPN9Rss6VnTBUX4CnVYJBJQ
         WRljmG4BslWa8DRyfVTQsH0XwtaOKNmsvrgaqNOREdYFVH7ieEbzY3agmZt35A8tRD
         9yUSFMdpWecQg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 07/18] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Wed, 28 Jul 2021 11:38:12 +0200
Message-Id: <3d6420ef65a3cd96aae4b01d9be6d0890e7ba0e4.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account if the received xdp_buff/xdp_frame is non-linear
recycling/returning the frame memory to the allocator or into
xdp_frame_bulk.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 18 ++++++++++++++--
 net/core/xdp.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 53cccdc9528c..d66e9877d773 100644
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
index 504be3ce3ca9..1346fb8b3f50 100644
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

