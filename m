Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC23C229C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhGILNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhGILNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 07:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58A57613DF;
        Fri,  9 Jul 2021 11:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625829054;
        bh=F74RfuThWM3VCJ0NJKKlwLmMuK+MUODpe2DFhaOpXBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPojYhGZcZIo5d7gNDJWHXpQq1O5gCmAuFAWrVbwipWgrtHMoSry04uBoRs8o9lMR
         9UXVKhmVV7reKpg55YoQYp+TfrdYt9xxShXpt+XyU4gTOfSrES6Utdb5SD0t8t/15X
         HOkVIdFpfuFwx9EgPxjWoNhd/E1WJfVw5nE+/8ELL7Z2y3fhdWoQZFM1y2UVF6OhtC
         PcmMnP8HGWTaWIRtvgSAYjO6gOkPP6uDQAog09PlizHEJMrDT8RbtryRoLpDZGYwQv
         YjCiND0LcFByacJdgHrmAPvCpps3snnAx2u1coAWuRCMR8VWnPqlmWDEkHSyRL7vE0
         x566DdUL60rUA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexander.duyck@gmail.com, brouer@redhat.com,
        echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH bpf-next 2/2] net: xdp: add xdp_update_skb_shared_info utility routine
Date:   Fri,  9 Jul 2021 13:10:28 +0200
Message-Id: <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1625828537.git.lorenzo@kernel.org>
References: <cover.1625828537.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_update_skb_shared_info routine to update frags array
metadata from a given xdp_buffer/xdp_frame. We do not need to reset
frags array since it is already initialized by the driver.
Rely on xdp_update_skb_shared_info in mvneta driver.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 29 +++++++++++++++------------
 include/net/xdp.h                     |  3 +++
 net/core/xdp.c                        | 27 +++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 361bc4fbe20b..abf2e50880e0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	rx_desc->buf_phys_addr = 0;
 
 	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
-		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
+		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags];
 
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
+		/* We don't need to reset pp_recycle here. It's already set, so
+		 * just mark fragments for recycling.
+		 */
+		page_pool_store_mem_info(page, rxq->page_pool);
+
+		/* first fragment */
+		if (!xdp_sinfo->nr_frags)
+			xdp_sinfo->gso_type = *size;
+		xdp_sinfo->nr_frags++;
 
 		/* last fragment */
 		if (len == *size) {
 			struct skb_shared_info *sinfo;
 
 			sinfo = xdp_get_shared_info_from_buff(xdp);
+			sinfo->xdp_frags_tsize = xdp_sinfo->nr_frags * PAGE_SIZE;
 			sinfo->nr_frags = xdp_sinfo->nr_frags;
+			sinfo->gso_type = xdp_sinfo->gso_type;
 			memcpy(sinfo->frags, xdp_sinfo->frags,
 			       sinfo->nr_frags * sizeof(skb_frag_t));
 		}
@@ -2320,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
+	int num_frags = sinfo->nr_frags, size = sinfo->gso_type;
 	struct sk_buff *skb;
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
@@ -2333,17 +2344,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
-	for (i = 0; i < num_frags; i++) {
-		skb_frag_t *frag = &sinfo->frags[i];
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				skb_frag_page(frag), skb_frag_off(frag),
-				skb_frag_size(frag), PAGE_SIZE);
-		/* We don't need to reset pp_recycle here. It's already set, so
-		 * just mark fragments for recycling.
-		 */
-		page_pool_store_mem_info(skb_frag_page(frag), pool);
-	}
+	if (num_frags)
+		xdp_update_skb_shared_info(skb, num_frags, size,
+					   sinfo->xdp_frags_tsize, sinfo);
 
 	return skb;
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index ad5b02dcb6f4..08d151ea8400 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -164,6 +164,9 @@ void xdp_warn(const char *msg, const char *func, const int line);
 #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
+void xdp_update_skb_shared_info(struct sk_buff *skb, int nr_frags,
+				int size, int truesize,
+				struct skb_shared_info *sinfo);
 struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index cc92ccb38432..3f44c69e1f56 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -527,6 +527,33 @@ int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(xdp_alloc_skb_bulk);
 
+void xdp_update_skb_shared_info(struct sk_buff *skb, int nr_frags,
+				int size, int truesize,
+				struct skb_shared_info *sinfo)
+{
+	int i;
+
+	skb_shinfo(skb)->nr_frags = nr_frags;
+
+	skb->len += size;
+	skb->data_len += size;
+	skb->truesize += truesize;
+
+	if (skb->pfmemalloc)
+		return;
+
+	for (i = 0; i < nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		page = compound_head(page);
+		if (page_is_pfmemalloc(page)) {
+			skb->pfmemalloc = true;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(xdp_update_skb_shared_info);
+
 struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev)
-- 
2.31.1

