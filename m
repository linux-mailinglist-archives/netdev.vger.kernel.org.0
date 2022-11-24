Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4EC637CDB
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiKXPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKXPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:23:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB2D69314
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D28B621A7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8CCC433C1;
        Thu, 24 Nov 2022 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669303389;
        bh=gkG/CFKzk4MuB3f6M6uabhgEVgS5tUtQ/c7+V8pmd0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4ARMKcDZhk+RaLk1n+PeZVKM+ce0g02Ic8oaQK7KxG/jY975Q7OI9Y0qCx/+cwhB
         n9wL7EZvlYGYh++jIRGkB7Y16ukGvb9xc3cJsiyAlawlEN34AJBD84k7BoHBmVoNgi
         1V8L5mokzkz4y5f7cteRC75GjrU0oeJnoTIx1kmv+RodVCdD99/+NyHS5r+sb7sPp+
         xo9oM+teD44fuRt7A4GaO8fKl1bGk19+3dum/ncqU2QsrLugTZe1FBlCPaL0bsVWIB
         kRJ2nYuLtVNeodcC+oJKm5MoGrwQjxrFms6n/lXiL8wt6I8XSXO8KdzoEd7SpVlERd
         Rl0GHB/dwBRng==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net-next 1/5] net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
Date:   Thu, 24 Nov 2022 16:22:51 +0100
Message-Id: <b8284d47918e9b6a4a27b7757d2c9391d5a0c0aa.1669303154.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669303154.git.lorenzo@kernel.org>
References: <cover.1669303154.git.lorenzo@kernel.org>
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
Increase poll timeout to 10ms in order to be aligned with vendor sdk.
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

