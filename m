Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C802C5289B6
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbiEPQIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbiEPQIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDAF3878F;
        Mon, 16 May 2022 09:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C9E1B8125B;
        Mon, 16 May 2022 16:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3D8C36AE5;
        Mon, 16 May 2022 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717292;
        bh=1BP0hNAhVdSiaByBwuA4bapH8q0B/c5pl0i6BWJcHFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIS/fgeOVOq4M/JM/e6N7JJbGjwpKZ5YYTI9q/vQDq4f81wBLps+6hOIlYF/JtBVs
         GoqrZ24GOGAL6RWWN45OxXUSaSSLWE2WUsTWe2mhJNn16lztx4uxzT6BWIa/sent7x
         ytaVvf1OCdBYIfU8vM0una1WQaRJZd5iE/HK+Zrz4BmON+/TN6Qy1dslV4mI+YWQsz
         +W6od/m2RpTuBPU09D6MINKCWtDGKSb189guLmyBuPeo0ykJ8i3yvfNzuQ96sIEw3/
         FvEhdzbvDALcKKtCIWfyIfO+3syI+fQGnYKAyoNvJ9ju41pV0p6FQZXjbgb8C7ZODf
         HdoLaWeGVLRpA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 10/15] net: ethernet: mtk_eth_soc: rely on rxd_size field in mtk_rx_alloc/mtk_rx_clean
Date:   Mon, 16 May 2022 18:06:37 +0200
Message-Id: <eca56ab1af7f4bbedc4a6d0990a10ff58911d842.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.35.3

