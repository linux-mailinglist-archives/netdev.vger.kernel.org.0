Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3F637CDC
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiKXPXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiKXPXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816C26CE48
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F309AB8284F
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BADC433D6;
        Thu, 24 Nov 2022 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669303393;
        bh=Jn+RsWvy04FKIEZ1G57eLzq2+3w1Ek1KjYNzioxDrkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9EmrrQPV6FNV3Bk2HiTXBvwC3YJ1mRr1x54W4N4qRpEJhEaavEPCbBIa12/m6hQ4
         GU8iJvbd9APWiMkUy5LRYD/EVGdVyQzc2a7IdSwXXjegJnqkFfGKETXyOR7Y9WSoOJ
         bFbTqfTThhzknBaQ4CxmI0Vj6vKOfEBu57EDQGABnVln4JwFP1VmdtkbKjcb3KBTIR
         bKP8ZU4PAzOGU9GaVVWQGpsHgWIbtuGVJv9th/kijfmkQwT9uMe6lvYnnfe4hobYyo
         g/4kCVb94BkxfAatsi3ErSujwan+Vzg4eZ2le/M1fOsSyvXSXhu57eSVj1gyYJfIfZ
         P034qCG5fkngg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net-next 2/5] net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in mtk_wdma_tx_reset
Date:   Thu, 24 Nov 2022 16:22:52 +0100
Message-Id: <32ef50dc0c8c325279a110362ce8af2eaa0620a5.1669303154.git.lorenzo@kernel.org>
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

Remove duplicated code. Increase poll timeout to 10ms in order to be
aligned with vendor sdk.
This is a preliminary patch to add Wireless Ethernet Dispatcher reset
support.

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

