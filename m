Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A44501E8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhKOKDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbhKOKDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:03:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D227EC061766
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 02:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Vpi21KSJhY7HAIL3VAX9wDUyYmeH6vr50QV1eCZvmGc=; b=Frr6Bo3y77VZej1epdBdkKIG7/
        73CTos0FUcQQ7tQkIS9O4pxrDW0sNPC40EZBLpbsvfJqB+5h5LKf/lPeBvIlKY0CNqOUwNB66jagL
        b+QBzEyDtxFCDk5YBrwe43pGAfMny/cLM1+ZVwSF6sYzSAjXiDNGXuuGaYWlXSr4rKZO8aN0UI1q9
        EncKHJEa8VDPtpuqoQM3D9NtjZxOmG+O9yrKwB9guGJx+BgsTr80CMCbq8N6wHs3x6eFRjxy1MpCc
        OFl5DhVlS5RTGaD3KRniuCjrfHLlKDJJL9RRan55otOt43XlrnK9Ffq4t1gibUKfGtoEeLEcpTqyB
        o9qQVErA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36180 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmYn0-0007Sa-9A; Mon, 15 Nov 2021 10:00:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmYmz-006nOr-Rp; Mon, 15 Nov 2021 10:00:37 +0000
In-Reply-To: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
References: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] net: mvpp2: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmYmz-006nOr-Rp@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 15 Nov 2021 10:00:37 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 to use phylink_generic_validate() for the bulk of its
validate() implementation. This network adapter has a restriction
that for 802.3z links, autonegotiation must be enabled.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 58 +++----------------
 1 file changed, 9 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b18d89d9756..df6c793f4b1b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6260,9 +6260,6 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
 	/* When in 802.3z mode, we must have AN enabled:
 	 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
 	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
@@ -6271,52 +6268,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	    !phylink_test(state->advertising, Autoneg))
 		goto empty_set;
 
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-
-	if (port->priv->global_tx_fc) {
-		phylink_set(mask, Pause);
-		phylink_set(mask, Asym_Pause);
-	}
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_XAUI:
-		if (mvpp2_port_supports_xlg(port)) {
-			phylink_set_10g_modes(mask);
-			phylink_set(mask, 10000baseKR_Full);
-		}
-		break;
-
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_SGMII:
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-		break;
-
-	default:
-		goto empty_set;
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	phylink_generic_validate(config, supported, state);
 	return;
 
 empty_set:
@@ -6911,12 +6863,20 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
 		port->phylink_config.dev = &dev->dev;
 		port->phylink_config.type = PHYLINK_NETDEV;
+		port->phylink_config.mac_capabilities =
+			MAC_2500FD | MAC_1000FD | MAC_100 | MAC_10;
+
+		if (port->priv->global_tx_fc)
+			port->phylink_config.mac_capabilities |=
+				MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
 		if (mvpp2_port_supports_xlg(port)) {
 			__set_bit(PHY_INTERFACE_MODE_10GBASER,
 				  port->phylink_config.supported_interfaces);
 			__set_bit(PHY_INTERFACE_MODE_XAUI,
 				  port->phylink_config.supported_interfaces);
+			port->phylink_config.mac_capabilities |=
+				MAC_10000FD;
 		}
 
 		if (mvpp2_port_supports_rgmii(port))
-- 
2.30.2

