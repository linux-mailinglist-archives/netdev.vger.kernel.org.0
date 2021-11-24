Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEED45CB76
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349990AbhKXR4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349995AbhKXR41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AB5C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RKYM0B3Z++w58EXIz+k2wVLgBF05n2MNrZBRg4Nr7u0=; b=ua249Ejz9PQZ8hlrurDcjh6YS5
        sT9lZWqsZUefUoRZ22Ewpp3aDdoDvxWWJyGSrp8GYeB8pWDDGUk9b1oR0XL0g6jppZgYGaNaFKutA
        YdUxqTrXR7oEpBDtxCjnqvdvqNX6m0CIzKv9qGO9hicWAky3vq4gXdv5GB/lSsp1WeAwA13tzqK9G
        w88OKqtkZZV2DCp2hU1WcyRasE/FsygoU8iMr/Big2mgeiXTD6YRbkL6F9t/txax9YAQNfby9RqTH
        ychMs2l9/P/Zxd3VLWNTVcTGE1gyhQyM1Ztx1D+11DJZiapMywQOshFc7RnGieZnXSmq/fe0h8eMn
        SJiaAjqA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49536 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSI-0000yZ-R6; Wed, 24 Nov 2021 17:53:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSI-00D8Lt-CB; Wed, 24 Nov 2021 17:53:14 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 10/12] net: dsa: qca8k: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwSI-00D8Lt-CB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:53:14 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the QCA8K
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

In making this change, we bring consistency to the ethtool linkmodes
that phylink's validate step produces, thereby following the expected
behaviour as the phylink documentation has explained. Specifically, the
ethtool 1000baseX_Full capability is now permitted for all interface
modes, as it is a property of the PHY driver whether 1000baseX fiber
connections can be supported.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 66 ++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6516df08a5d5..a0bdc14997e8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1527,67 +1527,39 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	}
 }
 
-static void
-qca8k_phylink_validate(struct dsa_switch *ds, int port,
-		       unsigned long *supported,
-		       struct phylink_link_state *state)
+static void qca8k_phylink_get_caps(struct dsa_switch *ds, int port,
+				   struct phylink_config *config)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
 	switch (port) {
 	case 0: /* 1st CPU port */
-		if (state->interface != PHY_INTERFACE_MODE_NA &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
-		    state->interface != PHY_INTERFACE_MODE_SGMII)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  config->supported_interfaces);
 		break;
+
 	case 1:
 	case 2:
 	case 3:
 	case 4:
 	case 5:
 		/* Internal PHY */
-		if (state->interface != PHY_INTERFACE_MODE_NA &&
-		    state->interface != PHY_INTERFACE_MODE_GMII &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 		break;
+
 	case 6: /* 2nd CPU port / external PHY */
-		if (state->interface != PHY_INTERFACE_MODE_NA &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
-		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
-		    state->interface != PHY_INTERFACE_MODE_SGMII &&
-		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  config->supported_interfaces);
 		break;
-	default:
-unsupported:
-		linkmode_zero(supported);
-		return;
 	}
 
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
-		phylink_set(mask, 1000baseX_Full);
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD;
 }
 
 static int
@@ -2405,7 +2377,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
-	.phylink_validate	= qca8k_phylink_validate,
+	.phylink_get_caps	= qca8k_phylink_get_caps,
 	.phylink_mac_link_state	= qca8k_phylink_mac_link_state,
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
-- 
2.30.2

