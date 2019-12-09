Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6B117034
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLIPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:19:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35504 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLIPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZxfQyRh3I/JDy2JMsRxR25+rZ8JBTI54I2TXvatF6lo=; b=Xm0YtpqNpcEqNDOYAsdBWOGxzF
        MkYjFA4FvHj1viGYjYvlt476ysl17P8FbETU9fbiDV6gF3Ey1ya/GnFgyEUj6KssHQ1rUcYiecgYF
        9viFS0q/E2UtDJly/saiXvyiA+zlbIFs22eEX2aolWw9m4wJ5h9h1fYQzcHDrRrG9fY0rOucbTCHP
        pZNMY2wvqIEMuPp0kuUBKePPbuljLeUzmTm9U2Mxc3JcU1agGDf20CsQj1ZO4X9h2FOypgghr1YwJ
        FLwa3jW04SxxHdSvbDhHbbZsXw2kJCIQ6BY3PvnyZhd8E9MGkLp3M5dyVvpi9d036eWhvrcFgsGx/
        s00yfRow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:38184 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKoW-0003qt-LQ; Mon, 09 Dec 2019 15:19:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKoU-0004vM-Jr; Mon, 09 Dec 2019 15:19:06 +0000
In-Reply-To: <20191209151553.GP25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 08/14] net: phylink: support Clause 45 PHYs on
 SFP+ modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieKoU-0004vM-Jr@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 15:19:06 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP+ modules have Clause 45 PHYs embedded on them, which need a
little more handling in order to ensure that they are correctly setup,
as they switch the PHY link mode according to the negotiated speed.

With Clause 22 PHYs, we assumed that they would operate in SGMII mode,
but this assumption is now false.  Adapt phylink to support Clause 45
PHYs on SFP+ modules.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c32b2c080584..f4c8d50234ed 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -711,7 +711,8 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
 		    phy_duplex_to_str(phydev->duplex));
 }
 
-static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
+static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
+			       phy_interface_t interface)
 {
 	struct phylink_link_state config;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
@@ -729,7 +730,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
-	config.interface = pl->link_config.interface;
+	config.interface = interface;
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret)
@@ -745,6 +746,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
 	pl->phydev = phy;
+	pl->phy_state.interface = interface;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -809,7 +811,7 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 	if (ret < 0)
 		return ret;
 
-	ret = phylink_bringup_phy(pl, phy);
+	ret = phylink_bringup_phy(pl, phy, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy);
 
@@ -862,7 +864,7 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	if (!phy_dev)
 		return -ENODEV;
 
-	ret = phylink_bringup_phy(pl, phy_dev);
+	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy_dev);
 
@@ -1814,13 +1816,22 @@ static void phylink_sfp_link_up(void *upstream)
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
+	phy_interface_t interface = pl->link_config.interface;
 	int ret;
 
 	ret = phylink_attach_phy(pl, phy, pl->link_config.interface);
 	if (ret < 0)
 		return ret;
 
-	ret = phylink_bringup_phy(pl, phy);
+	/* Clause 45 PHYs switch their Serdes lane between several different
+	 * modes, normally 10GBASE-R, SGMII. Some use 2500BASE-X for 2.5G
+	 * speeds.  We really need to know which interface modes the PHY and
+	 * MAC supports to properly work out which linkmodes can be supported.
+	 */
+	if (phy->is_c45)
+		interface = PHY_INTERFACE_MODE_NA;
+
+	ret = phylink_bringup_phy(pl, phy, interface);
 	if (ret)
 		phy_detach(phy);
 
-- 
2.20.1

