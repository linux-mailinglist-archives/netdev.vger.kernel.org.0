Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B076F48835C
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiAHLyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiAHLyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:54:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D38C06173E;
        Sat,  8 Jan 2022 03:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF01D60EF8;
        Sat,  8 Jan 2022 11:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9ECC36AF6;
        Sat,  8 Jan 2022 11:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642857;
        bh=Y2ePrdV9G0HuQ0LzPF1u2YdssshJHT1QMDEBlGKHjWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GK0R4f5bWlT7N1Ay0DZrOVUPM86KS9Oq0cIFQ7lnz0T+ArpCWzVqzKssq3/DmlepO
         F99EqGXL2gg17VfjTqSk8zX4DAyfSPXK0af9+S84RtNtxp8YTUxz7H4M5I3ZIfd2AM
         kF9D+7uR59+vmzucp11BotIaok4zwr46OxQrgZrgnaFEQNHiPEpAAWH/k/3lZHuZOr
         8Lp1Eid6vivWv2tn+4bndeT1bXSoDDP7NYAaAAh7aoi4Rjhd89KSb53Su82Y3Xjswd
         XK/X0TudRHZV6DvfHQuYP4m8gqfbLalfdXGldXEXbTWCYWwT/a9v3smPqnInzvY9TE
         /Dbj6ao4mQISg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 06/23] net: marvell: rely on xdp_update_skb_shared_info utility routine
Date:   Sat,  8 Jan 2022 12:53:09 +0100
Message-Id: <a346f27e55a9117f43f89aceb7e47c5f0743d50a.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
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

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 775ffd91b741..267a306d9c75 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2332,8 +2332,12 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
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
@@ -2347,7 +2351,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct sk_buff *skb;
 	u8 num_frags;
-	int i;
 
 	if (unlikely(xdp_buff_is_mb(xdp)))
 		num_frags = sinfo->nr_frags;
@@ -2362,18 +2365,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
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
2.33.1

