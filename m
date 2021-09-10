Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52453406F65
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhIJQQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhIJQQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B549561260;
        Fri, 10 Sep 2021 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290498;
        bh=cH33syrGBiiLDaSG/+ip0JyfjFpNMMDuSn45hv+/CD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv5Tz+rf1dyx8HjBwK8P5ltS36DOu4hRYioELTPSRwVyR9Q6Z/zXbBts5IeSYuqEa
         O2E7kvMqLUklrspWaEkOXtt7OPIJ6jTdZbhm8lwD/+U0s+Dxr8WyZuR67pyHawZYYm
         hVs1AbJqiU8vuQWULKfNynL6gJ0UOiKc8eQEZ/f/4BMfwIm+CKjZE9Q32EE2SPf2xo
         6fibg4VrRz6wJkHQU3lvcMfKjaWdZFHpsqP5ViMGNeVUDkS6TzBqPqdlLEGitLMWR1
         qhOynqJpACu+drZIKH7408xKWOIn1yTpge3jVt8vLrvRx8W5RpOMAHlziY2x3f0coQ
         XlO4wKPWzk13w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 03/18] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Fri, 10 Sep 2021 18:14:09 +0200
Message-Id: <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
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
index 9d460a270601..0c7b84ca6efc 100644
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

