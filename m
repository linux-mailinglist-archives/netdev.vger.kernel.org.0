Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B215834CF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiG0VXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG0VXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA24D5720A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B73B60A67
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 21:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A35C433D7;
        Wed, 27 Jul 2022 21:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658956997;
        bh=52i8qhkewCTocArWVeX2hw4wQ14wMGLcqJ6y1FiFQFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEMKLP4F4KK37Q9el1VFy934H2czJX1MSeUNd+Bm1MCFerO14LECG8eJW25AybOGj
         MGqoLkWV2+9qm6dZKbrG0h/mhH4Z/+KRRiaIO7rEGNZfpj/Hu9SY4eK1oLzV0O8DCG
         zjpKRJYoChQC9nQpfajj2qvxCz7DXNCWPS7M0VBrY7TAgRXTp3Gyo4noMOVvh7vvNd
         2vJGY6p8DpPT7wNvhlz5olgYvPN/81J3FKzX1wuL0HTFc6HlwXBvgeMocqT9V2sus6
         5dpjJhyuJFaRBClumFOVB9v0pxyhl7ExdRuHCYasiQZOC8pAwgSU4BFoldIzWX2xVW
         iGyhBrhr/5hOw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 3/3] net: ethernet: mtk_eth_soc: add xdp tx return bulking support
Date:   Wed, 27 Jul 2022 23:20:52 +0200
Message-Id: <a5475bba4c5ce73aa9d5fd8b876bb3969b4df718.1658955249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1658955249.git.lorenzo@kernel.org>
References: <cover.1658955249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mtk_eth_soc driver to xdp_return_frame_bulk APIs.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 24235f8f0a8f..d9426b01f462 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1001,7 +1001,7 @@ static int txd_to_idx(struct mtk_tx_ring *ring, void *dma, u32 txd_size)
 }
 
 static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
-			 bool napi)
+			 struct xdp_frame_bulk *bq, bool napi)
 {
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
 		if (tx_buf->flags & MTK_TX_FLAGS_SINGLE0) {
@@ -1044,6 +1044,8 @@ static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
 
 			if (napi && tx_buf->type == MTK_TYPE_XDP_TX)
 				xdp_return_frame_rx_napi(xdpf);
+			else if (bq)
+				xdp_return_frame_bulk(xdpf, bq);
 			else
 				xdp_return_frame(xdpf);
 		}
@@ -1296,7 +1298,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		tx_buf = mtk_desc_to_tx_buf(ring, itxd, soc->txrx.txd_size);
 
 		/* unmap dma */
-		mtk_tx_unmap(eth, tx_buf, false);
+		mtk_tx_unmap(eth, tx_buf, NULL, false);
 
 		itxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
@@ -1660,7 +1662,7 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 	while (htxd != txd) {
 		txd_pdma = qdma_to_pdma(ring, htxd);
 		tx_buf = mtk_desc_to_tx_buf(ring, htxd, soc->txrx.txd_size);
-		mtk_tx_unmap(eth, tx_buf, false);
+		mtk_tx_unmap(eth, tx_buf, NULL, false);
 
 		htxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
@@ -1973,6 +1975,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_buf *tx_buf;
+	struct xdp_frame_bulk bq;
 	struct mtk_tx_dma *desc;
 	u32 cpu, dma;
 
@@ -1980,6 +1983,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	dma = mtk_r32(eth, reg_map->qdma.drx_ptr);
 
 	desc = mtk_qdma_phys_to_virt(ring, cpu);
+	xdp_frame_bulk_init(&bq);
 
 	while ((cpu != dma) && budget) {
 		u32 next_cpu = desc->txd2;
@@ -2006,13 +2010,14 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 			}
 			budget--;
 		}
-		mtk_tx_unmap(eth, tx_buf, true);
+		mtk_tx_unmap(eth, tx_buf, &bq, true);
 
 		ring->last_free = desc;
 		atomic_inc(&ring->free_count);
 
 		cpu = next_cpu;
 	}
+	xdp_flush_frame_bulk(&bq);
 
 	ring->last_free_ptr = cpu;
 	mtk_w32(eth, cpu, reg_map->qdma.crx_ptr);
@@ -2025,11 +2030,13 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_buf *tx_buf;
+	struct xdp_frame_bulk bq;
 	struct mtk_tx_dma *desc;
 	u32 cpu, dma;
 
 	cpu = ring->cpu_idx;
 	dma = mtk_r32(eth, MT7628_TX_DTX_IDX0);
+	xdp_frame_bulk_init(&bq);
 
 	while ((cpu != dma) && budget) {
 		tx_buf = &ring->buf[cpu];
@@ -2045,7 +2052,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 			}
 			budget--;
 		}
-		mtk_tx_unmap(eth, tx_buf, true);
+		mtk_tx_unmap(eth, tx_buf, &bq, true);
 
 		desc = ring->dma + cpu * eth->soc->txrx.txd_size;
 		ring->last_free = desc;
@@ -2053,6 +2060,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 
 		cpu = NEXT_DESP_IDX(cpu, ring->dma_size);
 	}
+	xdp_flush_frame_bulk(&bq);
 
 	ring->cpu_idx = cpu;
 
@@ -2262,7 +2270,7 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
 	if (ring->buf) {
 		for (i = 0; i < MTK_DMA_SIZE; i++)
-			mtk_tx_unmap(eth, &ring->buf[i], false);
+			mtk_tx_unmap(eth, &ring->buf[i], NULL, false);
 		kfree(ring->buf);
 		ring->buf = NULL;
 	}
-- 
2.37.1

