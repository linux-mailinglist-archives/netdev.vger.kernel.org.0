Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19160F8B7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiJ0NMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiJ0NMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:12:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709FB7C1DD
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FqUkNYF/ox+HfqyI+4UjT+83Bw/3t3bU8jwaMM17C5o=; b=wfQLyIqMqWLLaGIooDXOt663my
        h7/RE1YjVnA8xUdVFljkWt50gzK0XtyaX9nz01rfua8lYS2e61eq3GKBLitJYHO/oOX4Ol/mZeoDQ
        U1AD2bDC2qIq9IVKpNoqbmXjz3IYo9aiUGYuabWN4NcDL5XjwXzgqDCgNMI/pUM5n92N1V8w38u27
        T6XyygF5PpndOoDKnr8bvbou+GgmQdcmgtGcPyIfaVmkeoLwshNujY9VfnsQP9H9mBt9XXq1b4wNv
        AA4PDuzayHmaKu9qM0cy8X4ZK8huAdyVRKyjJq8tq3y2YxTtcHpMcqrIQKBOyW9AO5Au1IbZaHLX3
        8OiItvpg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38420 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2fR-00070C-A4; Thu, 27 Oct 2022 14:11:29 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2fQ-00HF8c-Mu; Thu, 27 Oct 2022 14:11:28 +0100
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
Subject: [PATCH net-next 11/11] net: mtk_eth_soc: add support for in-band
 802.3z negotiation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2fQ-00HF8c-Mu@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:11:28 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a result of help from Frank Wunderlich to investigate and test, we
now know how to program this PCS for in-band 802.3z negotiation. Add
support for this by moving the contents of the two functions into the
common mtk_pcs_config() function and adding the register settings for
802.3z negotiation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 77 ++++++++++++-----------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 12e01d0ef52d..5c286f2c9418 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -33,41 +33,15 @@ static void mtk_pcs_get_state(struct phylink_pcs *pcs,
 					 FIELD_GET(SGMII_LPA, adv));
 }
 
-/* For SGMII interface mode */
-static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
-{
-	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-			   SGMII_REMOTE_FAULT_DIS, SGMII_REMOTE_FAULT_DIS);
-
-	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_RESTART, SGMII_AN_RESTART);
-}
-
-/* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
- * fixed speed.
- */
-static void mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
-				     phy_interface_t interface)
-{
-	/* Disable SGMII AN */
-	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_ENABLE, 0);
-
-	/* Set the speed etc but leave the duplex unchanged */
-	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-			   SGMII_IF_MODE_MASK & ~SGMII_DUPLEX_FULL,
-			   SGMII_SPEED_1000);
-}
-
 static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  phy_interface_t interface,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int rgc3, sgm_mode, bmcr;
 	int advertise, link_timer;
-	unsigned int rgc3;
-	bool changed;
+	bool changed, use_an;
 
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
 		rgc3 = RG_PHY_SPEED_3_125G;
@@ -83,6 +57,37 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	if (link_timer < 0)
 		return link_timer;
 
+	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
+	 * we assume that fixes it's speed at bitrate = line rate (in
+	 * other words, 1000Mbps or 2500Mbps).
+	 */
+	if (interface == PHY_INTERFACE_MODE_SGMII) {
+		sgm_mode = SGMII_IF_MODE_SGMII;
+		if (phylink_autoneg_inband(mode)) {
+			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
+				    SGMII_SPEED_DUPLEX_AN;
+			use_an = true;
+		} else {
+			use_an = false;
+		}
+	} else if (phylink_autoneg_inband(mode)) {
+		/* 1000base-X or 2500base-X autoneg */
+		sgm_mode = SGMII_REMOTE_FAULT_DIS;
+		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   advertising);
+	} else {
+		/* 1000base-X or 2500base-X without autoneg */
+		sgm_mode = 0;
+		use_an = false;
+	}
+
+	if (use_an) {
+		/* FIXME: Do we need to set AN_RESTART here? */
+		bmcr = SGMII_AN_RESTART | SGMII_AN_ENABLE;
+	} else {
+		bmcr = 0;
+	}
+
 	/* Configure the underlying interface speed */
 	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
 			   RG_PHY_SPEED_3_125G, rgc3);
@@ -94,11 +99,14 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
 	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
 
-	/* Setup SGMIISYS with the determined property */
-	if (interface != PHY_INTERFACE_MODE_SGMII)
-		mtk_pcs_setup_mode_force(mpcs, interface);
-	else if (phylink_autoneg_inband(mode))
-		mtk_pcs_setup_mode_an(mpcs);
+	/* Update the sgmsys mode register */
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
+			   SGMII_IF_MODE_SGMII, sgm_mode);
+
+	/* Update the BMCR */
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);
 
 	/* Release PHYA power down state */
 	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
@@ -121,8 +129,7 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
 	unsigned int sgm_mode;
 
-	if (!phylink_autoneg_inband(mode) ||
-	    phy_interface_mode_is_8023z(interface)) {
+	if (!phylink_autoneg_inband(mode)) {
 		/* Force the speed and duplex setting */
 		if (speed == SPEED_10)
 			sgm_mode = SGMII_SPEED_10;
-- 
2.30.2

