Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A499C52BE0C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbiEROzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbiEROzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:55:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E61DE540
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sb6q6Lg6o4w1EnTmis3tpq7HqUoc6Z7lgLtJTzs2BwY=; b=IA3UyexjYatUmoz2ma/1uTOLRy
        M/ALrLzUy4JBZTgSsPIJ5zPwq1AJx1JK9yBBnGlwLUPZrs5fi4mRHmyfP5dJzPv+lmEVPu91yj+os
        LMdk1OdcvgoZCUsRxlGUQKwarZwBn35ibpmwXV4jg8nY6YGMgL/1kjYFUkFDr/f9vviSrg2o7HzW9
        piOJR0qb1g9nSwBGDVGSszJ1pyFp1Gj2MwAjx8Zqj+biEiLdnLdeseEDMn9WLM4WzjAI+vVOtL5yW
        1MVpHmbPd6ykqFRWCY1pT7/qBemyOkYivmVIsz3G/VRsGxanMBOv07IeKEnU9I2kKOULuvTjvzJ7z
        CeIZDADw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38614 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nrL4Z-0002EQ-9g; Wed, 18 May 2022 15:54:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nrL4Z-00AM4w-5V; Wed, 18 May 2022 15:54:47 +0100
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 04/12] net: mtk_eth_soc: correct 802.3z speed setting
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nrL4Z-00AM4w-5V@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 May 2022 15:54:47 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink does not guarantee that state->speed will be set correctly in
the mac_config() call, so it's a bug that the driver makes use of it.
Moreover, it is making use of it in a function that is only ever called
for 1000BASE-X and 2500BASE-X which operate at a fixed speed which
happens to be the same setting irrespective of the interface mode. We
can simply remove the switch statement and just set the SGMII interface
speed.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 5897940a418b..d378ecdf56cc 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -34,6 +34,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 	return 0;
 }
 
+/* For SGMII interface mode */
 int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 {
 	unsigned int val;
@@ -60,6 +61,9 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 	return 0;
 }
 
+/* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
+ * fixed speed.
+ */
 int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 			       const struct phylink_link_state *state)
 {
@@ -82,19 +86,7 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 	/* SGMII force mode setting */
 	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
 	val &= ~SGMII_IF_MODE_MASK;
-
-	switch (state->speed) {
-	case SPEED_10:
-		val |= SGMII_SPEED_10;
-		break;
-	case SPEED_100:
-		val |= SGMII_SPEED_100;
-		break;
-	case SPEED_2500:
-	case SPEED_1000:
-		val |= SGMII_SPEED_1000;
-		break;
-	}
+	val |= SGMII_SPEED_1000;
 
 	if (state->duplex == DUPLEX_FULL)
 		val |= SGMII_DUPLEX_FULL;
-- 
2.30.2

