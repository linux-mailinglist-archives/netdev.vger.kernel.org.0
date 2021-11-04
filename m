Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D430445892
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhKDRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhKDRiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B91AB611C4;
        Thu,  4 Nov 2021 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047371;
        bh=wAlVtcvm1hjT2gYEeJyIzKs75l9c1SRt+wp+/TlSBtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxhLmTq37A8FuIXxGG4Jg05fcDY1+/jo9VkH9jmmq+B+g6Wpz1Ch3YgM8HQq5Y7TM
         ShwB7breqFOQtw7IDO4XcYHRnKBMMbWKjiURCb3Mj2gjFu8OjojOuctr9RMOthw2KM
         VGJGBXL4lKpg0T8m65nZ0uLIi2z15DjcuzW27ZPPmY0bUFnm4Akdyylw3GSu9Rs5LP
         QG0iu+Jxy0QtNtMXRhRB0dIVy2d9fcnquDZHvW2zpHNvGFCR/pGoSDTtwVp2jf59sU
         e7fwFFElIWynJdiiEUExoAQRTPpHf9KupFaJlWJwa5Brxk2n7tZ/8bkE/SDTdDAmTw
         GWKkTLVd6E9Ng==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 03/23] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Thu,  4 Nov 2021 18:35:23 +0100
Message-Id: <9c59c9428e3d483dcccd6d93162382c9bd21c6f9.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer. Access
skb_shared_info only if xdp_buff mb is set in order to avoid possible
cache-misses.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5a7bdca22a63..f3f8c32750b8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2037,9 +2037,14 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 {
 	int i;
 
+	if (likely(!xdp_buff_is_mb(xdp)))
+		goto out;
+
 	for (i = 0; i < sinfo->nr_frags; i++)
 		page_pool_put_full_page(rxq->page_pool,
 					skb_frag_page(&sinfo->frags[i]), true);
+
+out:
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
 			   sync_len, true);
 }
@@ -2241,7 +2246,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	struct skb_shared_info *sinfo;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2261,11 +2265,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
+	xdp_buff_clear_mb(xdp);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	sinfo->nr_frags = 0;
 }
 
 static void
@@ -2299,6 +2301,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
+
+		if (!xdp_buff_is_mb(xdp))
+			xdp_buff_set_mb(xdp);
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
@@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
 	struct sk_buff *skb;
+	u8 num_frags;
+	int i;
+
+	if (unlikely(xdp_buff_is_mb(xdp)))
+		num_frags = sinfo->nr_frags;
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
@@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
+	if (likely(!xdp_buff_is_mb(xdp)))
+		goto out;
+
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
 
@@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 				skb_frag_size(frag), PAGE_SIZE);
 	}
 
+out:
 	return skb;
 }
 
-- 
2.31.1

