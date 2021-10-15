Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5C042F1CE
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbhJONMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239297AbhJONMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61A9A611C3;
        Fri, 15 Oct 2021 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303394;
        bh=UxY+PUMX/+eSRTPDotxFwhDVvrjxuZe+UMeJMI3A/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hl/nMLTjfYyle0OhvskywVRwdYpESp7xQlAMFdl7jQ0LEp1mcVv0xR72KjlQ5Ii2b
         X2UfnJL01DZHr2T2J07F0hxOKSv+s7rjItLi+Lf/cS/bKOyegncPGQloJx0oByloXZ
         D4H+DiVwM5TgCqQgOXWBXqgQ9apyqjfiOHPOSRLfgNQjY7YCJtKgw1OselOZT19nn4
         db9uNIGoFu8+U3qN0cU1ilca/XEztssq4dmQZL0Pw7vBoCMFDC8RS+Y4eXTb5K0Bqp
         WYI9s7Joku4IWvF6lplubW0Wh2CNVjVsPEMxz6vgeqI5mWwerpnLv5PKHo4iMO7DRj
         ZYlkFUlLXE4yw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 06/20] net: marvell: rely on xdp_update_skb_shared_info utility routine
Date:   Fri, 15 Oct 2021 15:08:43 +0200
Message-Id: <ce3080f638851b8466424169ba5f8c31cb836f3c.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
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

