Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54082FC0DA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbhASUVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbhASUVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:21:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 777AB2310D;
        Tue, 19 Jan 2021 20:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087642;
        bh=+08pvCIfgsqYJ8S06q2qM20qFEOiUxlYPFCxQCxJDY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpvLLBnPEJYz5s+nRgj2Y/tdzW3/dSHqIkjQ37V4Kf4zXW754O9tD/NfezCMtBNYc
         RSCT6n5VDmHHnxQXt/oLAaL+zoB0IsQymaPO5i7JbJmJ8O3fdFEu/icR2+yo+Udwha
         RWs/SL8xmbCJJrvZ5QSXdtr4cfvcGW5rlmIuN5BOGqloA4bZ0oKpw453Mc9ldN8k6c
         ilPWmSvT4sQcu7vAtnm4jtGxWHJl3z+4mq+Im6obEzHK9pc4PTElOcSpKZO3H/9PLL
         p72VJd9tWjTmRK5/mq0+EmQpt9u6c61J7GkyV541xyqyM9p2CzcH0xpbKN9YgNtedB
         2gg2rwghSC+Sw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 3/8] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Tue, 19 Jan 2021 21:20:09 +0100
Message-Id: <daf0e50e7ccb074a8de3dec7ba87d7235d588ce1.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
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
index ed986ffff96b..3df0602239ad 100644
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
 
@@ -2268,9 +2271,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
-
-	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
-	xdp_sinfo->nr_frags = 0;
 }
 
 static void
@@ -2305,12 +2305,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
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
@@ -2325,11 +2331,15 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
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
@@ -2341,6 +2351,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	skb_put(skb, xdp->data_end - xdp->data);
 	mvneta_rx_csum(pp, desc_status, skb);
 
+	if (likely(!xdp->mb))
+		return skb;
+
 	for (i = 0; i < num_frags; i++) {
 		struct page *page = xdp_get_frag_page(&frag_list[i]);
 
@@ -2402,6 +2415,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_status;
 
+			xdp_buf.mb = 0;
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
 		} else {
-- 
2.29.2

