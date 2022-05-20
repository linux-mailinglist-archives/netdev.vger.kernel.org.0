Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06552F241
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352474AbiETSNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352470AbiETSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7AE18FF01;
        Fri, 20 May 2022 11:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 788AEB82D93;
        Fri, 20 May 2022 18:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E3CC34117;
        Fri, 20 May 2022 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070374;
        bh=jFr/C+je3NokkqyXC7uJY0JiG6vYtPSvT2wCEXT3pnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMp3FfJHzDDvYejKvhgrI5W11mOFuK37cKFiNHYES5trjqGFFkXFqUwJZ+9kl/eZn
         zsSxvN+UPifjI5zJmjufHgN/Cqq3y70m44zR9p/NVc6sy9746qELUEYO7EfkZNjNLG
         PiiUASaaC0ngZPH6UxKqVyTjnqtZLKZm+pjDa1V9oo6ZY3B7u8GeQSgpHSDKeDR6jB
         1ph+9HHGko7znyTsu2bStguFFY1goK+fn0BRej2OqD3Wme81FSFlYF/5WCRRGcq24L
         4lrbCNe6igSTNSLkZzpcdVsoB/qfq5opoZGbn51tSZLXXax3oIAGFvqM4gkruMtwW3
         5OKKSOiZpiQWA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 11/16] net: ethernet: mtk_eth_soc: rely on rxd_size field in mtk_rx_alloc/mtk_rx_clean
Date:   Fri, 20 May 2022 20:11:34 +0200
Message-Id: <1be6a4f04eca440c610a9f22808cfd4062d1c096.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove mtk_rx_dma structure layout dependency in mtk_rx_alloc/mtk_rx_clean.
Initialize to 0 rxd3 and rxd4 in mtk_rx_alloc.
This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 26 ++++++++++++++-------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c7820dbc75f1..4706e3708bbc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1749,18 +1749,25 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
+		struct mtk_rx_dma *rxd;
+
 		dma_addr_t dma_addr = dma_map_single(eth->dma_dev,
 				ring->data[i] + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size,
 				DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr)))
 			return -ENOMEM;
-		ring->dma[i].rxd1 = (unsigned int)dma_addr;
+
+		rxd = (void *)ring->dma + i * eth->soc->txrx.rxd_size;
+		rxd->rxd1 = (unsigned int)dma_addr;
 
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
-			ring->dma[i].rxd2 = RX_DMA_LSO;
+			rxd->rxd2 = RX_DMA_LSO;
 		else
-			ring->dma[i].rxd2 = RX_DMA_PLEN0(ring->buf_size);
+			rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
+
+		rxd->rxd3 = 0;
+		rxd->rxd4 = 0;
 	}
 	ring->dma_size = rx_dma_size;
 	ring->calc_idx_update = false;
@@ -1785,14 +1792,17 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 
 	if (ring->data && ring->dma) {
 		for (i = 0; i < ring->dma_size; i++) {
+			struct mtk_rx_dma *rxd;
+
 			if (!ring->data[i])
 				continue;
-			if (!ring->dma[i].rxd1)
+
+			rxd = (void *)ring->dma + i * eth->soc->txrx.rxd_size;
+			if (!rxd->rxd1)
 				continue;
-			dma_unmap_single(eth->dma_dev,
-					 ring->dma[i].rxd1,
-					 ring->buf_size,
-					 DMA_FROM_DEVICE);
+
+			dma_unmap_single(eth->dma_dev, rxd->rxd1,
+					 ring->buf_size, DMA_FROM_DEVICE);
 			skb_free_frag(ring->data[i]);
 		}
 		kfree(ring->data);
-- 
2.35.3

