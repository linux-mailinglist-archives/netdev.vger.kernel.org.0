Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7B0631C41
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKUJAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiKUJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC511A3B9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BDD9CCE1006
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936DAC433D6;
        Mon, 21 Nov 2022 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021215;
        bh=VAxlfHGPNx1lu1vw5SdguG4crB3iyMWNPr0oYTvjPQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8fIdvMfMuL+6Vr95Fo1PGNERePjsf6L33iOl4ygtq47J/bu/4Q+RL0jYwdUXXkDy
         1NgE133NvL0Ihnu7Nr5FyYfR+nnzthZLXCBSwVmgn4/Gl+WKUAcY9oN7AMzzY40A+y
         2uLav86HBhYlDiAgjoo1NjclvL7omQtHVJqeTmErXPdjIEjpijNH53U5mm7oKCzjhW
         spkEI4n4TMBqlCY4v5WgaeIi0NZ/KNnN+yGG7+HjtTLlf8Huwic3p55SminrJ6kDAf
         ibwxB23PuDwSKcK2reE7zyi6pJCZYpOCajrI2Pw76Bc5hJCylRU7t0KV48ED9QSlAj
         T/VaWH21q/STQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 3/5] net: ethernet: mtk_wed: update mtk_wed_stop
Date:   Mon, 21 Nov 2022 09:59:23 +0100
Message-Id: <96544565423ca4715ecb97f10ae092345cf6c97a.1669020847.git.lorenzo@kernel.org>
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

Update mtk_wed_stop routine and rename old mtk_wed_stop() to
mtk_wed_deinit(). This is a preliminary patch to add Wireless Ethernet
Dispatcher reset support.

Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 32 ++++++++++++++++++-------
 include/linux/soc/mediatek/mtk_wed.h    |  4 ++++
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 0fb51fb31407..f43652e72728 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -539,14 +539,8 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
 static void
 mtk_wed_stop(struct mtk_wed_device *dev)
 {
-	mtk_wed_dma_disable(dev);
 	mtk_wed_set_ext_int(dev, false);
 
-	wed_clr(dev, MTK_WED_CTRL,
-		MTK_WED_CTRL_WDMA_INT_AGENT_EN |
-		MTK_WED_CTRL_WPDMA_INT_AGENT_EN |
-		MTK_WED_CTRL_WED_TX_BM_EN |
-		MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
 	wed_w32(dev, MTK_WED_WPDMA_INT_TRIGGER, 0);
 	wed_w32(dev, MTK_WED_WDMA_INT_TRIGGER, 0);
 	wdma_w32(dev, MTK_WDMA_INT_MASK, 0);
@@ -558,7 +552,27 @@ mtk_wed_stop(struct mtk_wed_device *dev)
 
 	wed_w32(dev, MTK_WED_EXT_INT_MASK1, 0);
 	wed_w32(dev, MTK_WED_EXT_INT_MASK2, 0);
-	wed_clr(dev, MTK_WED_CTRL, MTK_WED_CTRL_WED_RX_BM_EN);
+}
+
+static void
+mtk_wed_deinit(struct mtk_wed_device *dev)
+{
+	mtk_wed_stop(dev);
+	mtk_wed_dma_disable(dev);
+
+	wed_clr(dev, MTK_WED_CTRL,
+		MTK_WED_CTRL_WDMA_INT_AGENT_EN |
+		MTK_WED_CTRL_WPDMA_INT_AGENT_EN |
+		MTK_WED_CTRL_WED_TX_BM_EN |
+		MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
+
+	if (dev->hw->version == 1)
+		return;
+
+	wed_clr(dev, MTK_WED_CTRL,
+		MTK_WED_CTRL_RX_ROUTE_QM_EN |
+		MTK_WED_CTRL_WED_RX_BM_EN |
+		MTK_WED_CTRL_RX_RRO_QM_EN);
 }
 
 static void
@@ -568,7 +582,7 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 
 	mutex_lock(&hw_lock);
 
-	mtk_wed_stop(dev);
+	mtk_wed_deinit(dev);
 
 	mtk_wdma_rx_reset(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
@@ -670,7 +684,7 @@ mtk_wed_hw_init_early(struct mtk_wed_device *dev)
 {
 	u32 mask, set;
 
-	mtk_wed_stop(dev);
+	mtk_wed_deinit(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
 	mtk_wed_set_wpdma(dev);
 
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 8294978f4bca..0bbba50cf929 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -231,6 +231,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
 	(_dev)->ops->ppe_check(_dev, _skb, _reason, _hash)
 #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) \
 	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
+#define mtk_wed_device_stop(_dev) (_dev)->ops->stop(_dev)
+#define mtk_wed_device_dma_reset(_dev) (_dev)->ops->reset_dma(_dev)
 #else
 static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 {
@@ -247,6 +249,8 @@ static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 #define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) -ENODEV
 #define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash)  do {} while (0)
 #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) -ENODEV
+#define mtk_wed_device_stop(_dev) do {} while (0)
+#define mtk_wed_device_dma_reset(_dev) do {} while (0)
 #endif
 
 #endif
-- 
2.38.1

