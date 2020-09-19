Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301EF270952
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgISADr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISADr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 20:03:47 -0400
Received: from lore-desk.redhat.com (unknown [151.66.80.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E8121D20;
        Sat, 19 Sep 2020 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600473826;
        bh=ms0u7SxurPaJEcdz/G6+5K1nb+m89Z2Mi4Hp0Jn+g3M=;
        h=From:To:Cc:Subject:Date:From;
        b=b98vS5tloGy3ipIIeCimgM9hTpFNniFluDwOZAP55IQCA1u7gY/IPcrh/xkc7xGwG
         oFnMg6pFN85LPkkhhTlfJu8+/El2TyI2q+qxZuDrD0fcb+thCo+IoVxqev5h1psDSG
         +RxPG/90JNZiEq6weWdRls959eyw8BbSmMmv67Go=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, echaudro@redhat.com,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next] net: mvneta: avoid copying shared_info frags in mvneta_swbm_build_skb
Date:   Sat, 19 Sep 2020 02:03:26 +0200
Message-Id: <82d03019421ee256db1fc5d8df34da5cc2dd6abb.1600472391.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid copying skb_shared_info frags array in mvneta_swbm_build_skb() since
__build_skb_around() does not overwrite it

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0cd315f1380e..d315ba1cd332 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2305,11 +2305,8 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i, num_frags = sinfo->nr_frags;
-	skb_frag_t frags[MAX_SKB_FRAGS];
 	struct sk_buff *skb;
 
-	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
-
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
@@ -2321,12 +2318,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	mvneta_rx_csum(pp, desc_status, skb);
 
 	for (i = 0; i < num_frags; i++) {
-		struct page *page = skb_frag_page(&frags[i]);
+		skb_frag_t *frag = &sinfo->frags[i];
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				page, skb_frag_off(&frags[i]),
-				skb_frag_size(&frags[i]), PAGE_SIZE);
-		page_pool_release_page(rxq->page_pool, page);
+				skb_frag_page(frag), skb_frag_off(frag),
+				skb_frag_size(frag), PAGE_SIZE);
+		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
 	}
 
 	return skb;
-- 
2.26.2

