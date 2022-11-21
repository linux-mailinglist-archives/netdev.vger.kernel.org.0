Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B8631C39
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKUJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKUJAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF8D1AF21
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 333ABCE0FD7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC928C433D7;
        Mon, 21 Nov 2022 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021208;
        bh=srTuEf+fXRk7EGL41puQfe4XvdcfYWiNbJCBj7D+JYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPt5BlilkmqQf7us9nnpR6ibWlMjdkQDA04Bg7lmma1qzCu85laqxR+LE+jpDj/Kl
         I34iwfRh5Dp1y7JzJltaB1bcjEphkkRlHzCPdP7Oyy43yoQbKflHCT4K/TRzbuZ38n
         n0S6/+TdqXZw1Dkdp32Id03xA2B/szqQeKXEpkY8or/R7WRsTRst4YoLevgWw3nwe5
         2d7bgLXAqDeS8I3sWMRq6eivnytuyCHuqYieX7pq22jm5IEKjQ/J/LXiNszrjztrzO
         nyteLv0w9gGG1jlK680fGeIeLDRc5kCDCgR0bRueYzwWPWwtCx4TcucWnWtMdQiIdq
         XUD7UafvHGPJg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 1/5] net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
Date:   Mon, 21 Nov 2022 09:59:21 +0100
Message-Id: <8917d87eded7142a3a792c3ba64434a983278247.1669020847.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669020847.git.lorenzo@kernel.org>
References: <cover.1669020847.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move MTK_WDMA_RESET_IDX configuration in mtk_wdma_rx_reset routine.
This is a preliminary patch to add Wireless Ethernet Dispatcher reset
support.

Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 7d8842378c2b..dc898ded2f05 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -101,17 +101,21 @@ mtk_wdma_read_reset(struct mtk_wed_device *dev)
 	return wdma_r32(dev, MTK_WDMA_GLO_CFG);
 }
 
-static void
+static int
 mtk_wdma_rx_reset(struct mtk_wed_device *dev)
 {
 	u32 status, mask = MTK_WDMA_GLO_CFG_RX_DMA_BUSY;
-	int i;
+	int i, ret;
 
 	wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_RX_DMA_EN);
-	if (readx_poll_timeout(mtk_wdma_read_reset, dev, status,
-			       !(status & mask), 0, 1000))
+	ret = readx_poll_timeout(mtk_wdma_read_reset, dev, status,
+				 !(status & mask), 0, 10000);
+	if (ret)
 		dev_err(dev->hw->dev, "rx reset failed\n");
 
+	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_RX);
+	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
+
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
 		if (dev->rx_wdma[i].desc)
 			continue;
@@ -119,6 +123,8 @@ mtk_wdma_rx_reset(struct mtk_wed_device *dev)
 		wdma_w32(dev,
 			 MTK_WDMA_RING_RX(i) + MTK_WED_RING_OFS_CPU_IDX, 0);
 	}
+
+	return ret;
 }
 
 static void
@@ -565,9 +571,7 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 
 	mtk_wed_stop(dev);
 
-	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_RX);
-	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
-
+	mtk_wdma_rx_reset(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
 	if (mtk_wed_get_rx_capa(dev)) {
 		wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
@@ -582,7 +586,6 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 		mtk_wed_wo_reset(dev);
 		mtk_wed_free_rx_rings(dev);
 		mtk_wed_wo_deinit(hw);
-		mtk_wdma_rx_reset(dev);
 	}
 
 	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
@@ -999,11 +1002,7 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 		wed_w32(dev, MTK_WED_RESET_IDX, 0);
 	}
 
-	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_RX);
-	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
-
-	if (mtk_wed_get_rx_capa(dev))
-		mtk_wdma_rx_reset(dev);
+	mtk_wdma_rx_reset(dev);
 
 	if (busy) {
 		mtk_wed_reset(dev, MTK_WED_RESET_WDMA_INT_AGENT);
-- 
2.38.1

