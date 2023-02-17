Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30969AE90
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjBQO4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjBQO4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:56:25 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8B6EF32;
        Fri, 17 Feb 2023 06:56:02 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pT29Z-0005LE-03;
        Fri, 17 Feb 2023 15:56:01 +0100
Date:   Fri, 17 Feb 2023 14:54:25 +0000
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
Subject: [PATCH v8 07/12] net: ethernet: mtk_eth_soc: only write values if
 needed
Message-ID: <e0043d4e1d9a3a13834106417603428b9c6b06e7.1676645204.git.daniel@makrotopia.org>
References: <cover.1676645203.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1676645203.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only restart auto-negotiation and write link timer if actually
necessary.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index d7e7352041a4..61bd9986466a 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -38,20 +38,16 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac)
 {
+	bool mode_changed = false, changed, use_an;
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
 	unsigned int rgc3, sgm_mode, bmcr;
 	int advertise, link_timer;
-	bool changed, use_an;
 
 	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
 							     advertising);
 	if (advertise < 0)
 		return advertise;
 
-	link_timer = phylink_get_link_timer_ns(interface);
-	if (link_timer < 0)
-		return link_timer;
-
 	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
 	 * we assume that fixes it's speed at bitrate = line rate (in
 	 * other words, 1000Mbps or 2500Mbps).
@@ -77,13 +73,16 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	}
 
 	if (use_an) {
-		/* FIXME: Do we need to set AN_RESTART here? */
-		bmcr = SGMII_AN_RESTART | SGMII_AN_ENABLE;
+		bmcr = SGMII_AN_ENABLE;
 	} else {
 		bmcr = 0;
 	}
 
 	if (mpcs->interface != interface) {
+		link_timer = phylink_get_link_timer_ns(interface);
+		if (link_timer < 0)
+			return link_timer;
+
 		/* PHYA power down */
 		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
 				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
@@ -106,16 +105,17 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
 				   RG_PHY_SPEED_3_125G, rgc3);
 
+		/* Setup the link timer */
+		regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
+
 		mpcs->interface = interface;
+		mode_changed = true;
 	}
 
 	/* Update the advertisement, noting whether it has changed */
 	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
 				 SGMII_ADVERTISE, advertise, &changed);
 
-	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
-
 	/* Update the sgmsys mode register */
 	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
 			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
@@ -123,7 +123,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 
 	/* Update the BMCR */
 	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);
+			   SGMII_AN_ENABLE, bmcr);
 
 	/* Release PHYA power down state
 	 * Only removing bit SGMII_PHYA_PWD isn't enough.
@@ -137,7 +137,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
-	return changed;
+	return changed || mode_changed;
 }
 
 static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
-- 
2.39.2

