Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F795490F72
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbiAQR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:29:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40846 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiAQR31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:29:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4895B81136;
        Mon, 17 Jan 2022 17:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED80C36AF5;
        Mon, 17 Jan 2022 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440564;
        bh=Obdvx6LDpOc4IbaLZ95Cyv6cxhciyjPXyFCHwFbpY+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCR22D27sagu5BLwAwGtqg4lojGN0r2pbzgymeSpcvElKQDmzHeQCXcLx0t239y4U
         dcQDTLvUWx2EtLUh7GhrW4AdDO7MWCU3xnT1ebEoQmJ6Ad9e2qfiT3RvjYx6jba8gQ
         lGW70ytfqTJGlB52nEaGFOlnrTOpHmQxT6OnEoVP4EqgCi8sGoPExxzbTmM0Qv2JXt
         Ury4uk3QbHh8ZmxIsMumK1SrVhASEpG02FNN4rF0PwUD5skPI4mdF7vxTeeaXmQxY2
         LCPjxjUk4oDmucru0XtYGd/gZbR+v17RZTY3lqZbHoJiJN+lo5wEF3UTtfFrqZ7HhN
         QcbHvV2fuaBGw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 03/23] net: mvneta: update multi-frags bit before passing the xdp buffer to eBPF layer
Date:   Mon, 17 Jan 2022 18:28:15 +0100
Message-Id: <71713b9725e9092de7fb68ef6033d443910ca861.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-frags bit (XDP_FLAGS_HAS_FRAGS) in xdp_buff to notify
XDP/eBPF layer and XDP remote drivers if this is a "non-linear"
XDP buffer. Access skb_shared_info only if XDP_FLAGS_HAS_FRAGS flag
is set in order to avoid possible cache-misses.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 83c8908f0cc7..a3e74a4b19dc 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2065,9 +2065,14 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 {
 	int i;
 
+	if (likely(!xdp_buff_has_frags(xdp)))
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
@@ -2269,7 +2274,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	struct skb_shared_info *sinfo;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2289,11 +2293,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
+	xdp_buff_clear_frags_flag(xdp);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	sinfo->nr_frags = 0;
 }
 
 static void
@@ -2327,6 +2329,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
+
+		if (!xdp_buff_has_frags(xdp))
+			xdp_buff_set_frags_flag(xdp);
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
@@ -2348,8 +2353,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
 	struct sk_buff *skb;
+	u8 num_frags;
+	int i;
+
+	if (unlikely(xdp_buff_has_frags(xdp)))
+		num_frags = sinfo->nr_frags;
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
@@ -2361,6 +2370,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
+	if (likely(!xdp_buff_has_frags(xdp)))
+		goto out;
+
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
 
@@ -2369,6 +2381,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 				skb_frag_size(frag), PAGE_SIZE);
 	}
 
+out:
 	return skb;
 }
 
-- 
2.34.1

