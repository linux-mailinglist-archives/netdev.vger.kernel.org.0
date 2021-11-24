Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A445C917
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbhKXPr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhKXPr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:47:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1B8C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 07:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7QD3XOZexhHppGzTW9YYCYC1Yc3dWmj8JhrB76MQaik=; b=Ri3XLfmNIDbhY5GMzEbTZnpgL6
        UjU/oBy3qRcSl6cQtT3Lz6IDdFEHpKt4QIOZzJbm9df8zUvsjNPCfiIIiJyKlOpmxjBmZnAuh3mU4
        SG3nWKSS9+B+mZC8OXNBg+AwV7ltCqxt+yTor0aQdHgVVP5ST5RCmR0XwxF/zVw/HWpcyyK377tfq
        HhkikMP+JHg6hT/ttG9A2OTou//awEM88aZfc3YWivFJcB8B/k+Y3uR+hZP1Mru62Y4nsUJtJulrh
        6kgiMU1uro7xArVcjPBMa7C8/rAhXLtK47v+0tEj0rafVQLDmHo+TZC9JS2UOG/ZZ5xjDsNZwq270
        /mmDWi2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49094 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpuRw-0000nr-4e; Wed, 24 Nov 2021 15:44:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpuRv-00D4rb-Lz; Wed, 24 Nov 2021 15:44:43 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Parshuram Thombare <pthombar@cadence.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: macb: convert to phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpuRv-00D4rb-Lz@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 15:44:43 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces bitmap and MAC capabilities mask for
the macb driver and remove the old validate implementation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb_main.c | 133 +++++------------------
 1 file changed, 30 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 2c10a3f1cdbb..d4da9adf6777 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -506,108 +506,6 @@ static void macb_set_tx_clk(struct macb *bp, int speed)
 		netdev_err(bp->dev, "adjusting tx_clk failed.\n");
 }
 
-static void macb_validate(struct phylink_config *config,
-			  unsigned long *supported,
-			  struct phylink_link_state *state)
-{
-	struct net_device *ndev = to_net_dev(config->dev);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct macb *bp = netdev_priv(ndev);
-	bool have_1g=false, have_sgmii=false, have_10g=false;
-
-	/* Determine what modes are supported */
-	if (macb_is_gem(bp) &&
-	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
-		have_1g = true;
-		if (bp->caps & MACB_CAPS_PCS)
-			have_sgmii = true;
-		if (bp->caps & MACB_CAPS_HIGH_SPEED)
-			have_10g = true;
-	}
-
-	/* Eliminate unsupported modes */
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_MII:
-	case PHY_INTERFACE_MODE_RMII:
-		break;
-
-	case PHY_INTERFACE_MODE_GMII:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (have_1g)
-			break;
-		linkmode_zero(supported);
-		return;
-
-	case PHY_INTERFACE_MODE_SGMII:
-		if (have_sgmii)
-			break;
-		linkmode_zero(supported);
-		return;
-
-	case PHY_INTERFACE_MODE_10GBASER:
-		if (have_10g)
-			break;
-		fallthrough;
-
-	default:
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Asym_Pause);
-
-	/* And set the appropriate mask */
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_10GBASER:
-		if (have_10g) {
-			phylink_set_10g_modes(mask);
-			phylink_set(mask, 10000baseKR_Full);
-		}
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
-
-	/* FIXME: Do we actually support 10/100 for SGMII? Half duplex? */
-	case PHY_INTERFACE_MODE_SGMII:
-		if (!have_sgmii && state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
-
-	case PHY_INTERFACE_MODE_GMII:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (have_1g) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-
-			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-				phylink_set(mask, 1000baseT_Half);
-		} else if (state->interface != PHY_INTERFACE_MODE_NA) {
-			break;
-		}
-		fallthrough;
-
-	default:
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-		break;
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 				 phy_interface_t interface, int speed,
 				 int duplex)
@@ -849,7 +747,7 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 }
 
 static const struct phylink_mac_ops macb_phylink_ops = {
-	.validate = macb_validate,
+	.validate = phylink_generic_validate,
 	.mac_prepare = macb_mac_prepare,
 	.mac_config = macb_mac_config,
 	.mac_link_down = macb_mac_link_down,
@@ -916,6 +814,35 @@ static int macb_mii_probe(struct net_device *dev)
 		bp->phylink_config.get_fixed_state = macb_get_pcs_fixed_state;
 	}
 
+	bp->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
+		MAC_10 | MAC_100;
+
+	__set_bit(PHY_INTERFACE_MODE_MII,
+		  bp->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RMII,
+		  bp->phylink_config.supported_interfaces);
+
+	/* Determine what modes are supported */
+	if (macb_is_gem(bp) && (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
+		bp->phylink_config.mac_capabilities |= MAC_1000FD;
+		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+			bp->phylink_config.mac_capabilities |= MAC_1000HD;
+
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  bp->phylink_config.supported_interfaces);
+		phy_interface_set_rgmii(bp->phylink_config.supported_interfaces);
+
+		if (bp->caps & MACB_CAPS_PCS)
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  bp->phylink_config.supported_interfaces);
+
+		if (bp->caps & MACB_CAPS_HIGH_SPEED) {
+			__set_bit(PHY_INTERFACE_MODE_10GBASER,
+				  bp->phylink_config.supported_interfaces);
+			bp->phylink_config.mac_capabilities |= MAC_10000FD;
+		}
+	}
+
 	bp->phylink = phylink_create(&bp->phylink_config, bp->pdev->dev.fwnode,
 				     bp->phy_interface, &macb_phylink_ops);
 	if (IS_ERR(bp->phylink)) {
-- 
2.30.2

