Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4A4490F7A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiAQR3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbiAQR3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:29:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C83AC06173F;
        Mon, 17 Jan 2022 09:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC92FB81142;
        Mon, 17 Jan 2022 17:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0247C36AF5;
        Mon, 17 Jan 2022 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440577;
        bh=imbv1xmL2ewxJtYBY1lCR/5/SOQQ7SP35P6phUWrwDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCGrq58uXps90bq9SUDCjBO14NL383Qisf5aCJzcetJyNOiW+wHheJCukPoK+fwg1
         wxissndp7kuF23zDSoUNi0pLNZ877syItMC5YZ7fiLIItMdaze2L5xAbqY+fgaqr8m
         aGfAQA6Dqf5B2m+gjt1B058TPTAqTSQnnH3VYMozpfJ/6G2OJovpBR0pWyfQUO1WXl
         bAe/YfU6WjuD8Ebut0Gx/UI72bmT0wZf4U/3zCKikDQ1ipjy7UQk7Z855hrExKPX2F
         AWZZuGzWtogYfuN0kXWZnzawKRz+R4PeTR1eoA5eywjCaXrfv37UaOdPO/aj2SBIJM
         J82HmNFQyRfUA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 06/23] net: marvell: rely on xdp_update_skb_shared_info utility routine
Date:   Mon, 17 Jan 2022 18:28:18 +0100
Message-Id: <c888c1bce57ab256c53e25ad4f0a99c7b941ad0f.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
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
index bc70292dda43..f1fd93e89c73 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2332,8 +2332,12 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
 
-		if (!xdp_buff_has_frags(xdp))
+		if (!xdp_buff_has_frags(xdp)) {
+			sinfo->xdp_frags_size = *size;
 			xdp_buff_set_frags_flag(xdp);
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
 
 	if (unlikely(xdp_buff_has_frags(xdp)))
 		num_frags = sinfo->nr_frags;
@@ -2362,18 +2365,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
-	if (likely(!xdp_buff_has_frags(xdp)))
-		goto out;
-
-	for (i = 0; i < num_frags; i++) {
-		skb_frag_t *frag = &sinfo->frags[i];
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				skb_frag_page(frag), skb_frag_off(frag),
-				skb_frag_size(frag), PAGE_SIZE);
-	}
+	if (unlikely(xdp_buff_has_frags(xdp)))
+		xdp_update_skb_shared_info(skb, num_frags,
+					   sinfo->xdp_frags_size,
+					   num_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
 
-out:
 	return skb;
 }
 
-- 
2.34.1

