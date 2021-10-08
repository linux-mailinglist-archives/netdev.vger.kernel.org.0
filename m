Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29406426B34
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241714AbhJHMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241993AbhJHMxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA43961038;
        Fri,  8 Oct 2021 12:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697487;
        bh=UxY+PUMX/+eSRTPDotxFwhDVvrjxuZe+UMeJMI3A/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj+Uwt+Uo1qqBAlCNxYFigsJyzC4A8HJXj9PttJYGGFf/2eMZetM9kNc4lUN6rYD8
         I3oCfAEB+FX+U2OCZygNCM0DKm9yKVMJpYfE5We2kBa88kkPXWZL6kRlUcwx51PTS9
         qIaZGmsd2G3Pf21pB6KJJCzsvG+WCxg/FjlvibLYaX13ecVaWD0jjWSE5+SqZeWjXF
         fx6rY7QDBFtWzC9vPYdrKlXIeirXmdFWXCB7tGA7xGBoidaDsbj35FeuSeTUI/Pu4H
         UoHAKRXox1WM3OM835jAME4b6nRLVwhckL7YCB8KELgGlGQUR7wWme3+SPIvN72ovu
         HH4/aaZT8HTGg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 06/18] net: marvell: rely on xdp_update_skb_shared_info utility routine
Date:   Fri,  8 Oct 2021 14:49:44 +0200
Message-Id: <ad05acc446a75cba2abe5e843a7d6924eeba029a.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
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

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 08d9466ef49f..3874302941bf 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2304,8 +2304,12 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
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
@@ -2319,7 +2323,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct sk_buff *skb;
 	u8 num_frags;
-	int i;
 
 	if (unlikely(xdp_buff_is_mb(xdp)))
 		num_frags = sinfo->nr_frags;
@@ -2334,18 +2337,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
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
+		xdp_update_skb_shared_info(skb, num_frags,
+					   sinfo->xdp_frags_size,
+					   num_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
 
-out:
 	return skb;
 }
 
-- 
2.31.1

