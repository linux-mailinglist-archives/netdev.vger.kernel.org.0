Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EB64A86EC
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiBCOsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiBCOsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:48:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C9C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a0f2O2QhhrNcSHy+V11GBIMdvNWBfJpOsYRVeX1naPc=; b=dlBgWBkk6aE9eK6Atod27qJrBC
        n0W13XEbWzbvFPPLm6jpv+l1opMOG8hkT35i8wgNEYFJnsPzpLGefkv/HDSe5Ao+1kQkaBnigg9oG
        9Yz2QpJDvgekfomfy/B9S1YXXybNOqQbvHWJidtjQtLlhIURBgMZzG8uDvFu0qtG578xBDbyExp8t
        5zKDZhK8i+tehVTX9PqLEhXAdtFJXgruzbP7VRH2yB5eYEt69xFL3C0VSnkSIhRzZOtnVQqG1Zqsi
        3k2zoqmyQix+sCVntJvpcbGIRNR4AqjvN3IPuCwds8Rn+yZtT7vBbdrst0EqBzR7J8yYjDuMMNyUP
        gsI3l/ww==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54216 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFdPY-0002lD-F0; Thu, 03 Feb 2022 14:48:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFdPX-006WhI-S8; Thu, 03 Feb 2022 14:48:35 +0000
In-Reply-To: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 4/5] net: dsa: b53: switch to using
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFdPX-006WhI-S8@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 14:48:35 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch the Broadcom b53 driver to using the phylink_generic_validate()
implementation by removing its own .phylink_validate method and
associated code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 57 ++++++++------------------------
 drivers/net/dsa/b53/b53_priv.h   |  6 ----
 drivers/net/dsa/b53/b53_serdes.c | 22 ------------
 drivers/net/dsa/b53/b53_serdes.h |  3 --
 drivers/net/dsa/b53/b53_srab.c   |  1 -
 5 files changed, 13 insertions(+), 76 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a637e44bce0b..50a372dc32ae 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1309,48 +1309,6 @@ void b53_port_event(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_port_event);
 
-void b53_phylink_validate(struct dsa_switch *ds, int port,
-			  unsigned long *supported,
-			  struct phylink_link_state *state)
-{
-	struct b53_device *dev = ds->priv;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	if (dev->ops->serdes_phylink_validate)
-		dev->ops->serdes_phylink_validate(dev, port, mask, state);
-
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	/* With the exclusion of 5325/5365, MII, Reverse MII and 802.3z, we
-	 * support Gigabit, including Half duplex.
-	 *
-	 * FIXME: this is weird - 802.3z is always Gigabit, but we exclude
-	 * it here. Why? This makes no sense.
-	 */
-	if (!(state->interface == PHY_INTERFACE_MODE_MII ||
-	      state->interface == PHY_INTERFACE_MODE_REVMII ||
-	      phy_interface_mode_is_8023z(state->interface) ||
-	      is5325(dev) || is5365(dev))) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
-	}
-
-	if (!phy_interface_mode_is_8023z(state->interface)) {
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-EXPORT_SYMBOL(b53_phylink_validate);
-
 static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 				 struct phylink_config *config)
 {
@@ -1362,6 +1320,13 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	/* These switches appear to support MII and RevMII too, but beyond
 	 * this, the code gives very few clues. FIXME: We probably need more
 	 * interface modes here.
+	 *
+	 * According to b53_srab_mux_init(), ports 3..5 can support:
+	 *  SGMII, MII, GMII, RGMII or INTERNAL depending on the MUX setting.
+	 * However, the interface mode read from the MUX configuration is
+	 * not passed back to DSA, so phylink uses NA.
+	 * DT can specify RGMII for ports 0, 1.
+	 * For MDIO, port 8 can be RGMII_TXID.
 	 */
 	__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
@@ -1369,7 +1334,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100;
 
-	/* 5325/5365 are not capable of gigabit speeds, everything else is */
+	/* 5325/5365 are not capable of gigabit speeds, everything else is.
+	 * Note: the original code also exclulded Gigagbit for MII, RevMII
+	 * and 802.3z modes. MII and RevMII are not able to work above 100M,
+	 * so will be excluded by the generic validator implementation.
+	 * However, the exclusion of Gigabit for 802.3z just seems wrong.
+	 */
 	if (!(is5325(dev) || is5365(dev)))
 		config->mac_capabilities |= MAC_1000;
 
@@ -2288,7 +2258,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_write		= b53_phy_write16,
 	.adjust_link		= b53_adjust_link,
 	.phylink_get_caps	= b53_phylink_get_caps,
-	.phylink_validate	= b53_phylink_validate,
 	.phylink_mac_link_state	= b53_phylink_mac_link_state,
 	.phylink_mac_config	= b53_phylink_mac_config,
 	.phylink_mac_an_restart	= b53_phylink_mac_an_restart,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index b9d1b4819c5f..a6b339fcb17e 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -58,9 +58,6 @@ struct b53_io_ops {
 	void (*serdes_link_set)(struct b53_device *dev, int port,
 				unsigned int mode, phy_interface_t interface,
 				bool link_up);
-	void (*serdes_phylink_validate)(struct b53_device *dev, int port,
-					unsigned long *supported,
-					struct phylink_link_state *state);
 };
 
 #define B53_INVALID_LANE	0xff
@@ -339,9 +336,6 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
-void b53_phylink_validate(struct dsa_switch *ds, int port,
-			  unsigned long *supported,
-			  struct phylink_link_state *state);
 int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
 			       struct phylink_link_state *state);
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 7e1ec51ab4c9..c39c315afa8e 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -158,28 +158,6 @@ void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 }
 EXPORT_SYMBOL(b53_serdes_link_set);
 
-void b53_serdes_phylink_validate(struct b53_device *dev, int port,
-				 unsigned long *supported,
-				 struct phylink_link_state *state)
-{
-	u8 lane = b53_serdes_map_lane(dev, port);
-
-	if (lane == B53_INVALID_LANE)
-		return;
-
-	switch (lane) {
-	case 0:
-		phylink_set(supported, 2500baseX_Full);
-		fallthrough;
-	case 1:
-		phylink_set(supported, 1000baseX_Full);
-		break;
-	default:
-		break;
-	}
-}
-EXPORT_SYMBOL(b53_serdes_phylink_validate);
-
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config)
 {
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index 8fa24f7001aa..f47d5caa7557 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -117,9 +117,6 @@ void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up);
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config);
-void b53_serdes_phylink_validate(struct b53_device *dev, int port,
-				unsigned long *supported,
-				struct phylink_link_state *state);
 #if IS_ENABLED(CONFIG_B53_SERDES)
 int b53_serdes_init(struct b53_device *dev, int port);
 #else
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 7d72f3b293d3..c51b716657db 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -496,7 +496,6 @@ static const struct b53_io_ops b53_srab_ops = {
 	.serdes_config = b53_serdes_config,
 	.serdes_an_restart = b53_serdes_an_restart,
 	.serdes_link_set = b53_serdes_link_set,
-	.serdes_phylink_validate = b53_serdes_phylink_validate,
 #endif
 };
 
-- 
2.30.2

