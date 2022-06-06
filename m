Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55FB53F2A9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 01:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiFFXlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 19:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiFFXlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 19:41:19 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EF47B5257;
        Mon,  6 Jun 2022 16:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=W2pGeBJj/dLqJYD8kB
        9C4khRrBNd4zxXRj9ATg2uzBY=; b=Goj6AceCMxqUO8j9t4MO6BV6oHOeJ2PM1W
        34uvRHBYiiilbIxy+8LBhoMZamvh1Q2OHsOcW+yC0qrM9rUauLYapZfT7n6NTbAA
        zVVR80LNDZ/Jwa5bh6jnFxqLe9Y51bINkg1JJht4SIvF0EVxZkelkRbxCPb8TDNR
        4x0tg7hu8=
Received: from localhost.localdomain (unknown [171.221.147.121])
        by smtp13 (Coremail) with SMTP id EcCowABHYpM1kJ5iHCCHGg--.35368S2;
        Tue, 07 Jun 2022 07:39:43 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     kuba@kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, Chen Lin <chen45464546@163.com>
Subject: [PATCH v4] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
Date:   Tue,  7 Jun 2022 07:39:11 +0800
Message-Id: <1654558751-3702-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20220606143437.25397f08@kernel.org>
References: <20220606143437.25397f08@kernel.org>
X-CM-TRANSID: EcCowABHYpM1kJ5iHCCHGg--.35368S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFyfKF13AF45WF4kJFyxZrb_yoW8ur18pr
        4UtFy3AF4UJr47G395Aa1DZa1Yyw4IgrWUKFy3Z34fZ345tFWrtFyktFWUWrySkrWqkF1S
        yFs8Zr9I9FnIkw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi2g43UUUUU=
X-Originating-IP: [171.221.147.121]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbB2AcYnmBHK2EpqgAAs3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rx_flag == MTK_RX_FLAGS_HWLRO,
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use __get_free_pages when ring->frag_size > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b3b3c07..3da162e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -899,6 +899,17 @@ static bool mtk_rx_get_desc(struct mtk_eth *eth, struct mtk_rx_dma_v2 *rxd,
 	return true;
 }
 
+static inline void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
+{
+	void *data;
+
+	data = (void *)__get_free_pages(gfp_mask |
+			  __GFP_COMP | __GFP_NOWARN,
+			  get_order(mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH)));
+
+	return data;
+}
+
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
@@ -1467,7 +1478,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1914,7 +1928,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
1.7.9.5

