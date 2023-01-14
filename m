Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616F566ACC2
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjANRB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjANRBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9112DA5EB
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CED060BD8
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 17:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADC6C433F0;
        Sat, 14 Jan 2023 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673715703;
        bh=lFWT5DP7A/2AOU42LDyGezyj2syVNLB5/gb2yi15+NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JavpqmWPxTVzZoqujuF6VheiggMdf3S1kmZ0qgGQsC9Q9Xx6/gwTi3EV2oiAMxzw/
         ktmng+gqzQFKm1uA69MEeGhoCgrGgkY2dXVcXw9fKrAtqNVe20ANlgdvtFZpH8jY9r
         Az+T1MrMGJrI5Zg4LYj4GBgm2FqcMS+2ksfkEpZPVSGUDM9Jdf40A+wHEuo0wYA6z2
         uyVdt5E8ck6O3TiOqnxisS5/jTndxRsK6uqYij4DkM7rJsvwlfDfjaPPNoawpql4NA
         EH8PfTne/zxPIm4OJxu3g66IobmAWIHGe+oeZ7i/zh2IDDzkmS3R2OVXTTGZX+2yuc
         NZYe7GKPHUKQQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org,
        alexander.duyck@gmail.com
Subject: [PATCH v6 net-next 1/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
Date:   Sat, 14 Jan 2023 18:01:28 +0100
Message-Id: <e57b57d38cbd0039300bc5a2222fc1efded33f6c.1673715298.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673715298.git.lorenzo@kernel.org>
References: <cover.1673715298.git.lorenzo@kernel.org>
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

This is a preliminary patch to add Wireless Ethernet Dispatcher reset
support.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++--------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index dc50e0b227a6..d5ffb8290855 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3517,6 +3517,27 @@ static void mtk_set_mcr_max_rx(struct mtk_mac *mac, u32 val)
 		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
 }
 
+static void mtk_hw_reset(struct mtk_eth *eth)
+{
+	u32 val;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
+		val = RSTCTRL_PPE0_V2;
+	} else {
+		val = RSTCTRL_PPE0;
+	}
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val |= RSTCTRL_PPE1;
+
+	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
+			     0x3ffffff);
+}
+
 static int mtk_hw_init(struct mtk_eth *eth)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
@@ -3556,22 +3577,9 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
-		val = RSTCTRL_PPE0_V2;
-	} else {
-		val = RSTCTRL_PPE0;
-	}
-
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
-		val |= RSTCTRL_PPE1;
-
-	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
+	mtk_hw_reset(eth);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
-			     0x3ffffff);
-
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
 		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
-- 
2.39.0

