Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031A362CECF
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiKPXfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbiKPXfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:35:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BABE69DCF
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A064B81F3C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8CFC433B5;
        Wed, 16 Nov 2022 23:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668641719;
        bh=MEfeIkkqVkPmsIdkcj5UsJ3cKF9htDM9JXi0ROP6u6Q=;
        h=From:To:Cc:Subject:Date:From;
        b=d0/QYNO7VMPj6IkHVkByYOH+4B0A0X5Q9bQNe+dK5iiSKkw3Gm2ZxDz25gSGkUefL
         pRZYNgSFU8ReJ6AZO+SWhDFJR5+ZHEmhS9xJmCDe+wh+aMo3tL99i6GqnsmvgNFbbM
         2kWz/qcR8RLtdRDCn9t+1ApYi3dj5C2NHx284oTNPWTXAx5XwW9/zRNgyg6PGqmtK7
         esXxwTgGLfzzf8rqO2VOVytX4UNBIjhtDgis2IcuPDoo72j8Hx3KfLbeVOWr9jXp/Z
         4ZS1KiBe2BgRT5W1WnEegWk654ARMS1EnwF5qyky1DSVk72xSfmmU/tKdQcq2ZWeDL
         oxmzC9+98EigA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine
Date:   Thu, 17 Nov 2022 00:35:04 +0100
Message-Id: <17649664984df04f4855dfeb4f50adead5db422c.1668641530.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Restore user configured MTU running mtk_hw_init() during tx timeout routine
since it will be overwritten after a hw reset.

Reported-by: Felix Fietkau <nbd@nbd.name>
Fixes: 9ea4d311509f ("net: ethernet: mediatek: add the whole ethernet reset into the reset process")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 53 +++++++++++++--------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3e9f5536f0f3..f3a03d6f1a92 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3281,6 +3281,30 @@ static void mtk_dim_tx(struct work_struct *work)
 	dim->state = DIM_START_MEASURE;
 }
 
+static void mtk_set_mcr_max_rx(struct mtk_mac *mac, u32 val)
+{
+	struct mtk_eth *eth = mac->hw;
+	u32 mcr_cur, mcr_new;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		return;
+
+	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
+
+	if (val <= 1518)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1518);
+	else if (val <= 1536)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1536);
+	else if (val <= 1552)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1552);
+	else
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_2048);
+
+	if (mcr_new != mcr_cur)
+		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
+}
+
 static int mtk_hw_init(struct mtk_eth *eth)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
@@ -3355,8 +3379,16 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	 * up with the more appropriate value when mtk_mac_config call is being
 	 * invoked.
 	 */
-	for (i = 0; i < MTK_MAC_COUNT; i++)
+	for (i = 0; i < MTK_MAC_COUNT; i++) {
+		struct net_device *dev = eth->netdev[i];
+
 		mtk_w32(eth, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(i));
+		if (dev) {
+			struct mtk_mac *mac = netdev_priv(dev);
+
+			mtk_set_mcr_max_rx(mac, dev->mtu + MTK_RX_ETH_HLEN);
+		}
+	}
 
 	/* Indicates CDM to parse the MTK special tag from CPU
 	 * which also is working out for untag packets.
@@ -3476,7 +3508,6 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	int length = new_mtu + MTK_RX_ETH_HLEN;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
-	u32 mcr_cur, mcr_new;
 
 	if (rcu_access_pointer(eth->prog) &&
 	    length > MTK_PP_MAX_BUF_SIZE) {
@@ -3484,23 +3515,7 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 		return -EINVAL;
 	}
 
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
-		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
-		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
-
-		if (length <= 1518)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1518);
-		else if (length <= 1536)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1536);
-		else if (length <= 1552)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1552);
-		else
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_2048);
-
-		if (mcr_new != mcr_cur)
-			mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
-	}
-
+	mtk_set_mcr_max_rx(mac, length);
 	dev->mtu = new_mtu;
 
 	return 0;
-- 
2.38.1

