Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8884B55F385
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiF2Cvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiF2Cvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:51:41 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3E2E098;
        Tue, 28 Jun 2022 19:51:39 -0700 (PDT)
X-UUID: ec4e0525fa4f481b8d1decae16eed288-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:6664284e-2111-42a9-a93d-c59def050255,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:87442a2,CLOUDID:ca101ad6-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: ec4e0525fa4f481b8d1decae16eed288-20220629
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 42457436; Wed, 29 Jun 2022 10:51:32 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 29 Jun 2022 10:51:30 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 10:51:28 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v4 10/10] net: ethernet: mtk-star-emac: enable half duplex hardware support
Date:   Wed, 29 Jun 2022 10:51:09 +0800
Message-ID: <20220629025109.21933-11-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629025109.21933-1-biao.huang@mediatek.com>
References: <20220629025109.21933-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver don't support 100/10M duplex half function.
This patch enable half duplex capability in hardware.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 30 ++++++++-----------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 1ee2bba29eef..d2072f023681 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -883,32 +883,26 @@ static void mtk_star_phy_config(struct mtk_star_priv *priv)
 	val <<= MTK_STAR_OFF_PHY_CTRL1_FORCE_SPD;
 
 	val |= MTK_STAR_BIT_PHY_CTRL1_AN_EN;
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
-	/* Only full-duplex supported for now. */
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
-
-	regmap_write(priv->regs, MTK_STAR_REG_PHY_CTRL1, val);
-
 	if (priv->pause) {
-		val = MTK_STAR_VAL_FC_CFG_SEND_PAUSE_TH_2K;
-		val <<= MTK_STAR_OFF_FC_CFG_SEND_PAUSE_TH;
-		val |= MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
 	} else {
-		val = 0;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
 	}
+	regmap_write(priv->regs, MTK_STAR_REG_PHY_CTRL1, val);
 
+	val = MTK_STAR_VAL_FC_CFG_SEND_PAUSE_TH_2K;
+	val <<= MTK_STAR_OFF_FC_CFG_SEND_PAUSE_TH;
+	val |= MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR;
 	regmap_update_bits(priv->regs, MTK_STAR_REG_FC_CFG,
 			   MTK_STAR_MSK_FC_CFG_SEND_PAUSE_TH |
 			   MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR, val);
 
-	if (priv->pause) {
-		val = MTK_STAR_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
-		val <<= MTK_STAR_OFF_EXT_CFG_SND_PAUSE_RLS;
-	} else {
-		val = 0;
-	}
-
+	val = MTK_STAR_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
+	val <<= MTK_STAR_OFF_EXT_CFG_SND_PAUSE_RLS;
 	regmap_update_bits(priv->regs, MTK_STAR_REG_EXT_CFG,
 			   MTK_STAR_MSK_EXT_CFG_SND_PAUSE_RLS, val);
 }
-- 
2.25.1

