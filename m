Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFAE2D1614
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLGQdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLGQdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:33:50 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 04/14] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Mon,  7 Dec 2020 17:32:33 +0100
Message-Id: <12c23f8c86236b2c12f6a15cbb1f4f8dccc2f0b5.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index d635463609ad..bac1ae7014eb 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2038,12 +2038,16 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
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
@@ -2244,7 +2248,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
-	struct xdp_shared_info *xdp_sinfo;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 
@@ -2271,9 +2274,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
-
-	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
-	xdp_sinfo->nr_frags = 0;
 }
 
 static void
@@ -2308,12 +2308,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
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
@@ -2328,11 +2334,13 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct xdp_shared_info *xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = xdp_sinfo->nr_frags;
+	int i, num_frags = xdp->mb ? xdp_sinfo->nr_frags : 0;
 	skb_frag_t frag_list[MAX_SKB_FRAGS];
 	struct sk_buff *skb;
 
-	memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
+	if (unlikely(xdp->mb))
+		memcpy(frag_list, xdp_sinfo->frags,
+		       sizeof(skb_frag_t) * num_frags);
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
@@ -2344,6 +2352,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	skb_put(skb, xdp->data_end - xdp->data);
 	mvneta_rx_csum(pp, desc_status, skb);
 
+	if (likely(!xdp->mb))
+		return skb;
+
 	for (i = 0; i < num_frags; i++) {
 		struct page *page = xdp_get_frag_page(&frag_list[i]);
 
@@ -2407,6 +2418,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_status;
 
+			xdp_buf.mb = 0;
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
 		} else {
-- 
2.28.0

