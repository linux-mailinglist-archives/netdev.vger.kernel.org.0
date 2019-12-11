Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C099011A960
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfLKK5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:57:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39604 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKK5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=J3bf8BUMb1q8O22wIE40HHLayWsAUvFoG2EExEke5JI=; b=yJpbo41GOZ8BQMPFRIZ4jQQm5Z
        bwu0qM8uD8f89kpLXrX3qt709vFu4g/bcgNVJZug+mglMMpMG9wRm0TJXqGUnaAuZNGhNWrnLhiO1
        1XYheJBi/I+pyp+ieS48m8Wfkc5eghKLyDhwL4HzmSMe1QiSY7C+p2DShf8ZcxPJB7jBsRiUVvQOR
        axRXng8i2QRMmkKsAAB9Fwgcsn0o0YEjj4neDRxIlbxwzJpZyigpxKQCpWVcGFr7OhiMBd1hLenhP
        oQ+IJ/CIu9h+iNiLLjZigePRS6jNtHwXcZoVyBBDLwEhXmIfML9nuGoicDxkjIdnCer0+acPtMlEj
        Gm1iB4Hg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60990 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfk-0007vY-Jh; Wed, 11 Dec 2019 10:56:48 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfh-0002ym-Nt; Wed, 11 Dec 2019 10:56:45 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 11/14] net: phylink: delay MAC configuration for
 copper SFP modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfh-0002ym-Nt@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:45 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Knowing whether we need to delay the MAC configuration because a module
may have a PHY is useful to phylink to allow NBASE-T modules to work on
systems supporting no more than 2.5G speeds.

This commit allows us to delay such configuration until after the PHY
has been probed by recording the parsed capabilities, and if the module
may have a PHY, doing no more until the module_start() notification is
called.  At that point, we either have a PHY, or we don't.

We move the PHY-based setup a little later, and use the PHYs support
capabilities rather than the EEPROM parsed capabilities to determine
whether we can support the PHY.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 53 +++++++++++++++++++++++++++++++--------
 drivers/net/phy/sfp-bus.c | 28 +++++++++++++++++++++
 include/linux/sfp.h       |  7 ++++++
 3 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a7717d70fade..6e166449736a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -72,6 +72,9 @@ struct phylink {
 	bool mac_link_dropped;
 
 	struct sfp_bus *sfp_bus;
+	bool sfp_may_have_phy;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	u8 sfp_port;
 };
 
 #define phylink_printk(level, pl, fmt, ...) \
@@ -1687,7 +1690,7 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
-static int phylink_sfp_config(struct phylink *pl, u8 mode, u8 port,
+static int phylink_sfp_config(struct phylink *pl, u8 mode,
 			      const unsigned long *supported,
 			      const unsigned long *advertising)
 {
@@ -1760,7 +1763,7 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode, u8 port,
 			     phy_modes(config.interface));
 	}
 
-	pl->link_port = port;
+	pl->link_port = pl->sfp_port;
 
 	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
 				 &pl->phylink_disable_state))
@@ -1773,15 +1776,20 @@ static int phylink_sfp_module_insert(void *upstream,
 				     const struct sfp_eeprom_id *id)
 {
 	struct phylink *pl = upstream;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
-	u8 port;
+	unsigned long *support = pl->sfp_support;
 
 	ASSERT_RTNL();
 
+	linkmode_zero(support);
 	sfp_parse_support(pl->sfp_bus, id, support);
-	port = sfp_parse_port(pl->sfp_bus, id, support);
+	pl->sfp_port = sfp_parse_port(pl->sfp_bus, id, support);
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND, port, support, support);
+	/* If this module may have a PHY connecting later, defer until later */
+	pl->sfp_may_have_phy = sfp_may_have_phy(pl->sfp_bus, id);
+	if (pl->sfp_may_have_phy)
+		return 0;
+
+	return phylink_sfp_config(pl, MLO_AN_INBAND, support, support);
 }
 
 static int phylink_sfp_module_start(void *upstream)
@@ -1789,10 +1797,19 @@ static int phylink_sfp_module_start(void *upstream)
 	struct phylink *pl = upstream;
 
 	/* If this SFP module has a PHY, start the PHY now. */
-	if (pl->phydev)
+	if (pl->phydev) {
 		phy_start(pl->phydev);
+		return 0;
+	}
 
-	return 0;
+	/* If the module may have a PHY but we didn't detect one we
+	 * need to configure the MAC here.
+	 */
+	if (!pl->sfp_may_have_phy)
+		return 0;
+
+	return phylink_sfp_config(pl, MLO_AN_INBAND,
+				  pl->sfp_support, pl->sfp_support);
 }
 
 static void phylink_sfp_module_stop(void *upstream)
@@ -1826,10 +1843,26 @@ static void phylink_sfp_link_up(void *upstream)
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
-	phy_interface_t interface = pl->link_config.interface;
+	phy_interface_t interface;
 	int ret;
 
-	ret = phylink_attach_phy(pl, phy, pl->link_config.interface);
+	/*
+	 * This is the new way of dealing with flow control for PHYs,
+	 * as described by Timur Tabi in commit 529ed1275263 ("net: phy:
+	 * phy drivers should not set SUPPORTED_[Asym_]Pause") except
+	 * using our validate call to the MAC, we rely upon the MAC
+	 * clearing the bits from both supported and advertising fields.
+	 */
+	phy_support_asym_pause(phy);
+
+	/* Do the initial configuration */
+	ret = phylink_sfp_config(pl, MLO_AN_INBAND, phy->supported,
+				 phy->advertising);
+	if (ret < 0)
+		return ret;
+
+	interface = pl->link_config.interface;
+	ret = phylink_attach_phy(pl, phy, interface);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index eabc9e3f0a9e..06e6429b8b71 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -103,6 +103,7 @@ static const struct sfp_quirk *sfp_lookup_quirk(const struct sfp_eeprom_id *id)
 
 	return NULL;
 }
+
 /**
  * sfp_parse_port() - Parse the EEPROM base ID, setting the port type
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
@@ -178,6 +179,33 @@ int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 }
 EXPORT_SYMBOL_GPL(sfp_parse_port);
 
+/**
+ * sfp_may_have_phy() - indicate whether the module may have a PHY
+ * @bus: a pointer to the &struct sfp_bus structure for the sfp module
+ * @id: a pointer to the module's &struct sfp_eeprom_id
+ *
+ * Parse the EEPROM identification given in @id, and return whether
+ * this module may have a PHY.
+ */
+bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
+{
+	if (id->base.e1000_base_t)
+		return true;
+
+	if (id->base.phys_id != SFF8024_ID_DWDM_SFP) {
+		switch (id->base.extended_cc) {
+		case SFF8024_ECC_10GBASE_T_SFI:
+		case SFF8024_ECC_10GBASE_T_SR:
+		case SFF8024_ECC_5GBASE_T:
+		case SFF8024_ECC_2_5GBASE_T:
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(sfp_may_have_phy);
+
 /**
  * sfp_parse_support() - Parse the eeprom id for supported link modes
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 66a56396e8e3..38893e4dd0f0 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -533,6 +533,7 @@ struct sfp_upstream_ops {
 #if IS_ENABLED(CONFIG_SFP)
 int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		   unsigned long *support);
+bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id);
 void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		       unsigned long *support);
 phy_interface_t sfp_select_interface(struct sfp_bus *bus,
@@ -556,6 +557,12 @@ static inline int sfp_parse_port(struct sfp_bus *bus,
 	return PORT_OTHER;
 }
 
+static inline bool sfp_may_have_phy(struct sfp_bus *bus,
+				    const struct sfp_eeprom_id *id)
+{
+	return false;
+}
+
 static inline void sfp_parse_support(struct sfp_bus *bus,
 				     const struct sfp_eeprom_id *id,
 				     unsigned long *support)
-- 
2.20.1

