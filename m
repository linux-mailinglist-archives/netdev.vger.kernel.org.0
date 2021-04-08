Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB23583B2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhDHMvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhDHMvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEDB261105;
        Thu,  8 Apr 2021 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886297;
        bh=iZarM/GnN+s15eL9PQjPklc2zV5QwMWs7RUmDGo85R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0Nh71UcTQsl3zfudpb9C3KepoisSHjvK3A6vHUGUwN/QWDQbYXEocCHPzsE8V3bL
         aCfVe7su0bVh9qQH1POlmZXAaiT9G7vz765jB0l1QNCfeb667Ai8372jpewqIjYvue
         NGtOYftdiOsh0otQc6a1pIAiqIkqqYX2Jl9c8XLp8RPlFNAAWzzYrTTMo2UIyUCUZ3
         0yYcQZvT9M+eHHPt45bOeaSv4yF4+uHBDsZ8ymprLu2P4/M0I8RLnzTFvbCeNChWPR
         TaVp8+x+Dy3akzhC6GKXvERtcQvInoP9ImfMJAulhqFTWflFSYWdD5lhQy/7UtU8WE
         lfPn1uctMJxVg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 03/14] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Thu,  8 Apr 2021 14:50:55 +0200
Message-Id: <7a56776d5e2053755854dd668bb08a5e369ef722.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer. Access
xdp_shared_info only if xdp_buff mb is set.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index a52e132fd2cf..94e29cce693a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2041,12 +2041,16 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 {
 	int i;
 
+	if (likely(!xdp->mb))
+		goto out;
+
 	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
 		skb_frag_t *frag = &xdp_sinfo->frags[i];
 
 		page_pool_put_full_page(rxq->page_pool,
 					xdp_get_frag_page(frag), true);
 	}
+out:
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
 			   sync_len, true);
 }
@@ -2246,7 +2250,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
-	struct xdp_shared_info *xdp_sinfo;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 
@@ -2270,9 +2273,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
-
-	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
-	xdp_sinfo->nr_frags = 0;
 }
 
 static void
@@ -2307,12 +2307,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		xdp_set_frag_size(frag, data_len);
 		xdp_set_frag_page(frag, page);
 
+		if (!xdp->mb) {
+			xdp_sinfo->data_length = *size;
+			xdp->mb = 1;
+		}
 		/* last fragment */
 		if (len == *size) {
 			struct xdp_shared_info *sinfo;
 
 			sinfo = xdp_get_shared_info_from_buff(xdp);
 			sinfo->nr_frags = xdp_sinfo->nr_frags;
+			sinfo->data_length = xdp_sinfo->data_length;
+
 			memcpy(sinfo->frags, xdp_sinfo->frags,
 			       sinfo->nr_frags * sizeof(skb_frag_t));
 		}
@@ -2327,11 +2333,15 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct xdp_shared_info *xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = xdp_sinfo->nr_frags;
 	skb_frag_t frag_list[MAX_SKB_FRAGS];
+	int i, num_frags = 0;
 	struct sk_buff *skb;
 
-	memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
+	if (unlikely(xdp->mb)) {
+		num_frags = xdp_sinfo->nr_frags;
+		memcpy(frag_list, xdp_sinfo->frags,
+		       sizeof(skb_frag_t) * num_frags);
+	}
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
@@ -2343,6 +2353,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	skb_put(skb, xdp->data_end - xdp->data);
 	mvneta_rx_csum(pp, desc_status, skb);
 
+	if (likely(!xdp->mb))
+		return skb;
+
 	for (i = 0; i < num_frags; i++) {
 		struct page *page = xdp_get_frag_page(&frag_list[i]);
 
@@ -2404,6 +2417,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_status;
 
+			xdp_buf.mb = 0;
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
 		} else {
-- 
2.30.2

