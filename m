Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5D46AE593
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjCGP5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjCGP4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:56:42 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B5D92261;
        Tue,  7 Mar 2023 07:55:50 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZZfI-0001s0-2A;
        Tue, 07 Mar 2023 16:55:48 +0100
Date:   Tue, 7 Mar 2023 15:54:11 +0000
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
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Message-ID: <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678201958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link partner advertised link modes are not reported by the SerDes
hardware if not operating in SGMII mode. Hence we cannot use
phylink_mii_c22_pcs_decode_state() in this case.
Implement reporting link and an_complete only and use speed according to
the interface mode.

Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 26 ++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 58d8cb3aa7f4..98d80007d3bd 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -23,14 +23,30 @@ static void mtk_pcs_get_state(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int bm, adv;
+	unsigned int bm, bmsr, adv;
 
-	/* Read the BMSR and LPA */
+	/* Read the BMSR */
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
-	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+	bmsr = FIELD_GET(SGMII_BMSR, bm);
 
-	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
-					 FIELD_GET(SGMII_LPA, adv));
+	/* link partner advertised link modes are not reported by the
+	 * hardware when not operating in SGMII mode. Hence we cannot
+	 * use phylink_mii_c22_pcs_decode_state() in this case.
+	 */
+	if (state->interface != PHY_INTERFACE_MODE_SGMII) {
+		state->link = !!(bmsr & BMSR_LSTATUS);
+		state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
+		state->speed = (state->interface ==
+				PHY_INTERFACE_MODE_2500BASEX) ?
+			       SPEED_2500 : SPEED_1000;
+		state->duplex = DUPLEX_FULL;
+
+		return;
+	}
+
+	/* Read LPA and use standard decode function for SGMII mode */
+	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+	phylink_mii_c22_pcs_decode_state(state, bmsr, FIELD_GET(SGMII_LPA, adv));
 }
 
 static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-- 
2.39.2

