Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3E3EB4BF
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbhHMLuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239093AbhHMLuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7B9610FA;
        Fri, 13 Aug 2021 11:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855382;
        bh=KDr7aNf/6csWbD8I4k36IqoJmLWW3yRDq6maMsstik8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUzG0+UDo5xH9atzzOxu/096zwv9KrHHTLN0xl5EByiz2qiFmwdBcldBMjXT1MXu7
         0veTvElnWErSG+CBDgGp1z/So3ElgaAieO0XMJUFq+urSnTESSf026yX/CQf9vZX8v
         mbzIuiNqy8Kl8bOlpnXxWffyzwRp1nKshwfKKnqLno9T2EsC5VPiVdUxW9L6kzf6W3
         O7rnA4wGhk0Ghcj3MIbPfTO/UzSTvqesz4V1GoStSJ9yc4q1/MANmVjR7/uhB592tq
         7Ej4x1zchr70aHipc3u+gaR714pQ6GszbECrWLm5QdHm06v4ot6sTr+koouwZJP5FP
         Fkk4FMq54Qp0w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 06/18] net: marvell: rely on xdp_update_skb_shared_info utility routine
Date:   Fri, 13 Aug 2021 13:47:47 +0200
Message-Id: <19df740fdeea1a84456e9912c13f836efc19fd74.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on xdp_update_skb_shared_info routine in order to avoid
resetting frags array in skb_shared_info structure building
the skb in mvneta_swbm_build_skb(). Frags array is expected to
be initialized by the receiving driver building the xdp_buff
and here we just need to update memory metadata.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 35 +++++++++++++++------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index cbf614d6b993..b996eb49d813 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2304,11 +2304,19 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
 
-		if (!xdp_buff_is_mb(xdp))
+		if (!xdp_buff_is_mb(xdp)) {
+			sinfo->xdp_frags_size = *size;
 			xdp_buff_set_mb(xdp);
+		}
+		if (page_is_pfmemalloc(page))
+			xdp_buff_set_frag_pfmemalloc(xdp);
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
+
+	/* last fragment */
+	if (len == *size)
+		sinfo->xdp_frags_tsize = sinfo->nr_frags * PAGE_SIZE;
 	*size -= len;
 }
 
@@ -2316,13 +2324,18 @@ static struct sk_buff *
 mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	unsigned int size, truesize;
 	struct sk_buff *skb;
 	u8 num_frags;
-	int i;
 
-	if (unlikely(xdp_buff_is_mb(xdp)))
+	if (unlikely(xdp_buff_is_mb(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		truesize = sinfo->xdp_frags_tsize;
+		size = sinfo->xdp_frags_size;
 		num_frags = sinfo->nr_frags;
+	}
 
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
@@ -2334,18 +2347,10 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
-	if (likely(!xdp_buff_is_mb(xdp)))
-		goto out;
-
-	for (i = 0; i < num_frags; i++) {
-		skb_frag_t *frag = &sinfo->frags[i];
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				skb_frag_page(frag), skb_frag_off(frag),
-				skb_frag_size(frag), PAGE_SIZE);
-	}
+	if (unlikely(xdp_buff_is_mb(xdp)))
+		xdp_update_skb_shared_info(skb, num_frags, size, truesize,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
 
-out:
 	return skb;
 }
 
-- 
2.31.1

