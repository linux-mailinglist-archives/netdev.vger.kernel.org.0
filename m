Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D662D11A95F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfLKK5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:57:02 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39588 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfLKK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/EAL+fd1v6lkI51XEnNBUfraZUHH9hRvM8U6GxcUANc=; b=A4Xahe65Ibl05WkEOMR5DJaZf3
        DN2wZMHxbQ+qkhMLk6DH7lDPtzGv/IKkB9D+pC0CO4XWn4QU8FmzMI52pJNuPwv6VkZq+IY4Eyzkq
        yzoWxFsfN3Q2+LMAijzvGQd5A+gFAshnvHPxXcBNWayjymZHDJP1qkzjNDA7aSLKcUMgalKYewSjV
        pR8blXIocBVOSfCUN6K0nFJxDGqufuZbARRepZMMwPhhozdl/7OMe1H3JhQZBHr/V/4LOgJt3b1XC
        93DiqNJ409J65hnpTnEqnhgPRi2Un6HS7s9ME8K5S+bblH2xpYmDpNEBGs+fjJee04PW6HLkR52mJ
        l0yvsZUw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56746 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfe-0007vO-TV; Wed, 11 Dec 2019 10:56:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfc-0002yf-JE; Wed, 11 Dec 2019 10:56:40 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 10/14] net: phylink: split
 phylink_sfp_module_insert()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfc-0002yf-JE@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:40 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out the configuration step from phylink_sfp_module_insert() so
we can re-use this later.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 47 +++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6ee9bcbf8283..a7717d70fade 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1687,25 +1687,21 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
-static int phylink_sfp_module_insert(void *upstream,
-				     const struct sfp_eeprom_id *id)
+static int phylink_sfp_config(struct phylink *pl, u8 mode, u8 port,
+			      const unsigned long *supported,
+			      const unsigned long *advertising)
 {
-	struct phylink *pl = upstream;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support1);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct phylink_link_state config;
 	phy_interface_t iface;
-	int ret = 0;
 	bool changed;
-	u8 port;
-
-	ASSERT_RTNL();
+	int ret;
 
-	sfp_parse_support(pl->sfp_bus, id, support);
-	port = sfp_parse_port(pl->sfp_bus, id, support);
+	linkmode_copy(support, supported);
 
 	memset(&config, 0, sizeof(config));
-	linkmode_copy(config.advertising, support);
+	linkmode_copy(config.advertising, advertising);
 	config.interface = PHY_INTERFACE_MODE_NA;
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
@@ -1720,8 +1716,6 @@ static int phylink_sfp_module_insert(void *upstream,
 		return ret;
 	}
 
-	linkmode_copy(support1, support);
-
 	iface = sfp_select_interface(pl->sfp_bus, config.advertising);
 	if (iface == PHY_INTERFACE_MODE_NA) {
 		phylink_err(pl,
@@ -1731,18 +1725,18 @@ static int phylink_sfp_module_insert(void *upstream,
 	}
 
 	config.interface = iface;
+	linkmode_copy(support1, support);
 	ret = phylink_validate(pl, support1, &config);
 	if (ret) {
 		phylink_err(pl, "validation of %s/%s with support %*pb failed: %d\n",
-			    phylink_an_mode_str(MLO_AN_INBAND),
+			    phylink_an_mode_str(mode),
 			    phy_modes(config.interface),
 			    __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
 		return ret;
 	}
 
 	phylink_dbg(pl, "requesting link mode %s/%s with support %*pb\n",
-		    phylink_an_mode_str(MLO_AN_INBAND),
-		    phy_modes(config.interface),
+		    phylink_an_mode_str(mode), phy_modes(config.interface),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
 
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
@@ -1754,15 +1748,15 @@ static int phylink_sfp_module_insert(void *upstream,
 		linkmode_copy(pl->link_config.advertising, config.advertising);
 	}
 
-	if (pl->cur_link_an_mode != MLO_AN_INBAND ||
+	if (pl->cur_link_an_mode != mode ||
 	    pl->link_config.interface != config.interface) {
 		pl->link_config.interface = config.interface;
-		pl->cur_link_an_mode = MLO_AN_INBAND;
+		pl->cur_link_an_mode = mode;
 
 		changed = true;
 
 		phylink_info(pl, "switched to %s/%s link mode\n",
-			     phylink_an_mode_str(MLO_AN_INBAND),
+			     phylink_an_mode_str(mode),
 			     phy_modes(config.interface));
 	}
 
@@ -1775,6 +1769,21 @@ static int phylink_sfp_module_insert(void *upstream,
 	return ret;
 }
 
+static int phylink_sfp_module_insert(void *upstream,
+				     const struct sfp_eeprom_id *id)
+{
+	struct phylink *pl = upstream;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	u8 port;
+
+	ASSERT_RTNL();
+
+	sfp_parse_support(pl->sfp_bus, id, support);
+	port = sfp_parse_port(pl->sfp_bus, id, support);
+
+	return phylink_sfp_config(pl, MLO_AN_INBAND, port, support, support);
+}
+
 static int phylink_sfp_module_start(void *upstream)
 {
 	struct phylink *pl = upstream;
-- 
2.20.1

