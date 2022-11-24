Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC5E637CDD
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKXPX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiKXPXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:23:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F196CE5E
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0160AB8284D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52604C433D7;
        Thu, 24 Nov 2022 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669303397;
        bh=VAxlfHGPNx1lu1vw5SdguG4crB3iyMWNPr0oYTvjPQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq8GKZZaTnUAiAvF2ZyRCNi8hLYPNAUlwYdWetzzZJyM9onEur3rzUeEC+o37PwBq
         ACCZI5NEXtEECc+D2MpAnxyljkyjIULordLLKNnwZivlstsVjd2eIINGEMqxle3v2w
         Cm09125I4C/sRMl4hgZdwgLjc/s+4vufIOjB6nNgZ7Nt0N/U2f0VAVD5ecuugXE3wq
         4LRQcxga9DHvAjPppTa0tgmKYw0x0+ajj8myyW3W7GprDJWAGj8cgjRVFCCUHLm1DI
         GQyoqMq0mbJ80j03NMWso/Tjl3vZ32pH0LsnmAUzr6uV/YdP2kgnNJzhUIneR/cl6C
         2ZOPIPCZaO0ZQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net-next 3/5] net: ethernet: mtk_wed: update mtk_wed_stop
Date:   Thu, 24 Nov 2022 16:22:53 +0100
Message-Id: <6c8a6d7e203c5d8f414c9fefa5a9d3faabee1933.1669303154.git.lorenzo@kernel.org>
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

