Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E72691476
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjBIXc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBIXcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:32:54 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D34131E31;
        Thu,  9 Feb 2023 15:32:52 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pQGPK-0002GU-23;
        Fri, 10 Feb 2023 00:32:50 +0100
Date:   Thu, 9 Feb 2023 23:31:13 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v3 06/12] net: ethernet: mtk_eth_soc: reset PCS state
Message-ID: <9de6402e09536d1c1a95d28615c1ed2aba223dbd.1675984550.git.daniel@makrotopia.org>
References: <cover.1675984550.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1675984550.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset PCS state when changing interface mode.

Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 4 ++++
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7014c02ba2d4..142def8629c8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -548,6 +548,10 @@
 #define SGMII_SEND_AN_ERROR_EN		BIT(11)
 #define SGMII_IF_MODE_MASK		GENMASK(5, 1)
 
+/* Register to reset SGMII design */
+#define SGMII_RESERVED_0	0x34
+#define SGMII_SW_RESET		BIT(0)
+
 /* Register to set SGMII speed, ANA RG_ Control Signals III*/
 #define SGMSYS_ANA_RG_CS3	0x2028
 #define RG_PHY_SPEED_MASK	(BIT(2) | BIT(3))
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index d7ffaaeaf9ab..d7e7352041a4 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -88,6 +88,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
 				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
 
+		/* Reset SGMII PCS state */
+		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
+				   SGMII_SW_RESET, SGMII_SW_RESET);
+
 		if (mpcs->flags & MTK_SGMII_FLAG_PN_SWAP)
 			regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_WRAP_CTRL,
 					   SGMII_PN_SWAP_MASK,
-- 
2.39.1

