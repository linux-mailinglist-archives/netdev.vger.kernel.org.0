Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674D1116E88
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLIOG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:06:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34252 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLIOG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x4N2xBAa8pnsA/pZ9wzYaeEP4jUUv39UO7qYtlS9HQQ=; b=ZwqVdgjxr9ZU6yczEztLuXBHy6
        45eMJqV64SuCeVwzs0QCBKKqdUCY+CuQ9X5gI4wH+/xYhXcqjeFg3o+AiWgIxtisO4lgqfbCx9ajd
        SOPf+gzAobf4X3ECuXwz8FlYLy70+h2y03vU0XOmlgjrV5nKdc9ZBLHP4ERlayCn2kiDfyY21rz1f
        t3WEnGTkIsRhZagK0T2wJ6QZVJQrQjHwygP2U4FJk5TblV4bOP3JCHhV22o2vdXIV0/eEx4x9uwsb
        0KxoWm7cyu7F5WFMyJVXn9W1hwNkFCBbriX3/TRAwsxDqRZyC7DKjbnU5io4pHwtsTrWZ+HXocokq
        BGRXH4mA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54406 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJgZ-0003PZ-LL; Mon, 09 Dec 2019 14:06:51 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJgY-0004OG-G4; Mon, 09 Dec 2019 14:06:51 +0000
In-Reply-To: <20191209140258.GI25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/14] net: sfp: derive interface mode from ethtool
 link modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJgY-0004OG-G4@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:06:50 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need the EEPROM ID to derive the phy interface mode as we can
derive it merely from the ethtool link modes.  Remove the EEPROM ID
argument to sfp_select_interface().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c |  2 +-
 drivers/net/phy/phylink.c    |  2 +-
 drivers/net/phy/sfp-bus.c    | 11 ++++-------
 include/linux/sfp.h          |  2 --
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 6397e7c4219f..5c0140546ca2 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -216,7 +216,7 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	phy_interface_t iface;
 
 	sfp_parse_support(phydev->sfp_bus, id, support);
-	iface = sfp_select_interface(phydev->sfp_bus, id, support);
+	iface = sfp_select_interface(phydev->sfp_bus, support);
 
 	if (iface != PHY_INTERFACE_MODE_10GKR) {
 		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8e2a12885789..d02eb83ed151 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1717,7 +1717,7 @@ static int phylink_sfp_module_insert(void *upstream,
 
 	linkmode_copy(support1, support);
 
-	iface = sfp_select_interface(pl->sfp_bus, id, config.advertising);
+	iface = sfp_select_interface(pl->sfp_bus, config.advertising);
 	if (iface == PHY_INTERFACE_MODE_NA) {
 		phylink_err(pl,
 			    "selection of interface failed, advertisement %*pb\n",
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 02ab07624c89..1561962fda30 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -320,16 +320,12 @@ EXPORT_SYMBOL_GPL(sfp_parse_support);
 /**
  * sfp_select_interface() - Select appropriate phy_interface_t mode
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
- * @id: a pointer to the module's &struct sfp_eeprom_id
  * @link_modes: ethtool link modes mask
  *
- * Derive the phy_interface_t mode for the information found in the
- * module's identifying EEPROM and the link modes mask. There is no
- * standard or defined way to derive this information, so we decide
- * based upon the link mode mask.
+ * Derive the phy_interface_t mode for the SFP module from the link
+ * modes mask.
  */
 phy_interface_t sfp_select_interface(struct sfp_bus *bus,
-				     const struct sfp_eeprom_id *id,
 				     unsigned long *link_modes)
 {
 	if (phylink_test(link_modes, 10000baseCR_Full) ||
@@ -342,7 +338,8 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	if (phylink_test(link_modes, 2500baseX_Full))
 		return PHY_INTERFACE_MODE_2500BASEX;
 
-	if (id->base.e1000_base_t)
+	if (phylink_test(link_modes, 1000baseT_Half) ||
+	    phylink_test(link_modes, 1000baseT_Full))
 		return PHY_INTERFACE_MODE_SGMII;
 
 	if (phylink_test(link_modes, 1000baseX_Full))
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 487fd9412d10..8d7b98c214d7 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -504,7 +504,6 @@ int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		       unsigned long *support);
 phy_interface_t sfp_select_interface(struct sfp_bus *bus,
-				     const struct sfp_eeprom_id *id,
 				     unsigned long *link_modes);
 
 int sfp_get_module_info(struct sfp_bus *bus, struct ethtool_modinfo *modinfo);
@@ -532,7 +531,6 @@ static inline void sfp_parse_support(struct sfp_bus *bus,
 }
 
 static inline phy_interface_t sfp_select_interface(struct sfp_bus *bus,
-						   const struct sfp_eeprom_id *id,
 						   unsigned long *link_modes)
 {
 	return PHY_INTERFACE_MODE_NA;
-- 
2.20.1

