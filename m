Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386BF51D7E2
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392057AbiEFMgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392047AbiEFMfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB39692AA;
        Fri,  6 May 2022 05:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 806AEB835A8;
        Fri,  6 May 2022 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95394C385B4;
        Fri,  6 May 2022 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840300;
        bh=PW4vLnZjIl0Bzc+1C2aLi2/56EKP8QWhlG87rR1GtV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2t3ydcGV+MhBJBIjbJJph4FPwL1fll6voEVcHxX//Og12q0y7rbkm51LN4Z8slyy
         Z1ju1DP/R0Lr8WqzqRMtOfkpoyW+WvaXyDwdjIlUp9zsI38Gqw82b29sAGJpsIygxb
         np3/L6FOEEgRI501tzYc0wn+Rv8Hk8c8ENEIt3GNuDjJbtBrcGpsVaMkV63m0123eT
         4xC5fFrlS6qn+ze3Pexu1hyIb56g1MGOb/51fDZXSxO21zi0vBQrduqD3o4UvzFvB0
         gsd6PPrZXpQt4un07giPQ9hq6WrmfdNvwhHrDOfPB8ce0PDVHGeqiSFzrDbZC+PaL9
         3nsvTGbyNsQPg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 10/14] net: ethernet: mtk_eth_soc: rely on rxd_size field in mtk_rx_alloc/mtk_rx_clean
Date:   Fri,  6 May 2022 14:30:27 +0200
Message-Id: <240e43db4160652978ed63590326b19695da348b.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 26 ++++++++++++++-------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d431311578e8..1e2fddc2bdcb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1728,18 +1728,25 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
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
@@ -1764,14 +1771,17 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 
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
2.35.1

