Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44034631C3A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKUJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKUJAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83812639
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A112C60F45
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2DFC433C1;
        Mon, 21 Nov 2022 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021212;
        bh=QoNX4n5yKUnksQs6IHlT8R25KCm57YTFGMPSuoUZgy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGm5Lvqtbw7Oo8Bfyz7FGqGCZ3M0LbgN20+WqSGD+zVSnUJc62fL/RVjQCM6V/gU6
         O6hKLPag+1vsmMfPmTd+KRgKsuvb07fh6jjvhkouZdsk2clT1SbqlqDm3jkiYVLu1t
         Mb//FJhM+/K4PwAgh4bRqaFaZZ9u7OcysQTMNaQ7/qkWkJ9kZMvEe8PZHbL1IjTwov
         JfikaVUspMRldaUS8EyzFjtWuZccQ8jLj/XfZ1ba0MPaDKIgjV58mAJkDwyqHGq2Cg
         T9AJgKdhQDEunHDGCejikFPcyUGkAEewEfTM4rFF5byOgQuP4Y3VKVwjcP7IwOHYkV
         IJGs8A+VXY/NQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 2/5] net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in mtk_wdma_tx_reset
Date:   Mon, 21 Nov 2022 09:59:22 +0100
Message-Id: <00f8791e9d386d9a8110f60a0f73033587b6227f.1669020847.git.lorenzo@kernel.org>
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

Remove duplicated code. This is a preliminary patch to add Wireless
Ethernet Dispatcher reset support.

Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index dc898ded2f05..0fb51fb31407 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -135,16 +135,15 @@ mtk_wdma_tx_reset(struct mtk_wed_device *dev)
 
 	wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
 	if (readx_poll_timeout(mtk_wdma_read_reset, dev, status,
-			       !(status & mask), 0, 1000))
+			       !(status & mask), 0, 10000))
 		dev_err(dev->hw->dev, "tx reset failed\n");
 
-	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++) {
-		if (dev->tx_wdma[i].desc)
-			continue;
+	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_TX);
+	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
+	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
 		wdma_w32(dev,
 			 MTK_WDMA_RING_TX(i) + MTK_WED_RING_OFS_CPU_IDX, 0);
-	}
 }
 
 static void
@@ -573,12 +572,6 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 
 	mtk_wdma_rx_reset(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
-	if (mtk_wed_get_rx_capa(dev)) {
-		wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
-		wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_TX);
-		wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
-	}
-
 	mtk_wed_free_tx_buffer(dev);
 	mtk_wed_free_tx_rings(dev);
 
-- 
2.38.1

