Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28AC60F8AC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiJ0NMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236052AbiJ0NLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:11:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D895D100
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/wKT193MfnO7XGRSfuNSaDTElwuOIDfdRyZl1YDS3vM=; b=eh8LBgBah35COsFCtSQAqWdin9
        CnjYcPJ0AVe5wHhpO3h2hLt/8vPjZpQ/hojVhD4utVwf6u47u2hoqkBoeHPxMhWkn5MJc0SsOqfsP
        ExedEpfi7L9l+L5Lw8LyKZnFacNg/bjPbjJ+2dRgfR7ypwCuT+KMP+wc9fLEl4o89Ht75MPeYBV6i
        bTzlNPnHWcuQC9kdZ107o1Shbb8xAff5FXKUzJ03Uvm68s+hwX7w5HcIYBsbSqHQgMB03E7R9eopr
        W2vgXzJvbq7I74o4O/16SUpmCkr3BhHUAwreJkQu2pNVElhrCJHxfBR/jZ7pvpLEkaqUTubwGUswb
        jXHsI1sw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53004 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2ew-0006yX-L3; Thu, 27 Oct 2022 14:10:58 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2ew-00HF82-0g; Thu, 27 Oct 2022 14:10:58 +0100
In-Reply-To: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
References: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 05/11] net: mtk_eth_soc: convert mtk_sgmii to use
 regmap_update_bits()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2ew-00HF82-0g@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:10:58 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_sgmii does a lot of read-modify-write operations, for which there
is a specific regmap function. Use this function instead of open-coding
the operations.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 61 ++++++++++-------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 63785bd9a118..868ff0b2e036 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -36,23 +36,18 @@ static void mtk_pcs_get_state(struct phylink_pcs *pcs,
 /* For SGMII interface mode */
 static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 {
-	unsigned int val;
-
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
 	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
 		     SGMII_LINK_TIMER_DEFAULT);
 
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val |= SGMII_REMOTE_FAULT_DIS;
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_REMOTE_FAULT_DIS, SGMII_REMOTE_FAULT_DIS);
 
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART, SGMII_AN_RESTART);
 
-	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
-	val &= ~SGMII_PHYA_PWD;
-	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+			   SGMII_PHYA_PWD, 0);
 }
 
 /* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
@@ -61,29 +56,26 @@ static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 static void mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 				     phy_interface_t interface)
 {
-	unsigned int val;
+	unsigned int rgc3;
 
-	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
-	val &= ~RG_PHY_SPEED_MASK;
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		val |= RG_PHY_SPEED_3_125G;
-	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
+		rgc3 = RG_PHY_SPEED_3_125G;
+
+	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+			   RG_PHY_SPEED_3_125G, rgc3);
 
 	/* Disable SGMII AN */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val &= ~SGMII_AN_ENABLE;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_ENABLE, 0);
 
 	/* Set the speed etc but leave the duplex unchanged */
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val &= SGMII_DUPLEX_FULL | ~SGMII_IF_MODE_MASK;
-	val |= SGMII_SPEED_1000;
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_IF_MODE_MASK & ~SGMII_DUPLEX_FULL,
+			   SGMII_SPEED_1000);
 
 	/* Release PHYA power down state */
-	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
-	val &= ~SGMII_PHYA_PWD;
-	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+			   SGMII_PHYA_PWD, 0);
 }
 
 static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
@@ -105,29 +97,28 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int val;
 
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART, SGMII_AN_RESTART);
 }
 
 static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int val;
+	unsigned int sgm_mode;
 
 	if (!phy_interface_mode_is_8023z(interface))
 		return;
 
 	/* SGMII force duplex setting */
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val &= ~SGMII_DUPLEX_FULL;
 	if (duplex == DUPLEX_FULL)
-		val |= SGMII_DUPLEX_FULL;
+		sgm_mode = SGMII_DUPLEX_FULL;
+	else
+		sgm_mode = 0;
 
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_DUPLEX_FULL, sgm_mode);
 }
 
 static const struct phylink_pcs_ops mtk_pcs_ops = {
-- 
2.30.2

