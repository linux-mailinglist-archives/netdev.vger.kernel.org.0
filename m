Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F98C20F73A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgF3O3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388849AbgF3O3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19EDC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8RY+/HPmsRgsDYhB+XNn8wO3N8NJINJr3b0rUd94SII=; b=1W3aGc4zsjk2LQxur8Z8jpvkiW
        v5HwOTI3PiAh0PHSxe3iqekDr2RSe3er6GvjPLNrvHux0thM43XRAtXeivN8mJcQ+yvAVes9tqP6z
        FDvjrJmewg5P85m10Gg/+2HYAzbYz6rqMjjGcQ2o3AKmUvGRsGFRu5d8IUhtgDEoe2Mm+WOq4ewqJ
        AOvvFmgUHeJVFa+vmdO/bm2R7KLIXNQ7hIxaaSLd5ZuumxF5bWXCSRuvRhLEsWczSYIEUGmrV96/w
        U4J6hkSsA80jgiz/QDvCMiGyUkSWSFWyorQKl/A8DPKAZZIiFWsII8z7JjyjKaHYNCAUM4s/pmTKF
        lziJiHYA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47270 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFz-0000ep-1o; Tue, 30 Jun 2020 15:29:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFy-0006PK-Qd; Tue, 30 Jun 2020 15:29:06 +0100
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 07/13] net: phylink: simplify ksettings_set()
 implementation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHFy-0006PK-Qd@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:29:06 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the ksettings_set() implementation to look more like phylib's
implementation; use a switch() for validating the autoneg setting, and
use the linkmode_modify() helper to set the autoneg bit in the
advertisement mask.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 424a927d7889..103d2a550415 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1314,25 +1314,24 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct ethtool_link_ksettings our_kset;
 	struct phylink_link_state config;
+	const struct phy_setting *s;
 	int ret;
 
 	ASSERT_RTNL();
 
-	if (kset->base.autoneg != AUTONEG_DISABLE &&
-	    kset->base.autoneg != AUTONEG_ENABLE)
-		return -EINVAL;
-
 	linkmode_copy(support, pl->supported);
 	config = pl->link_config;
+	config.an_enabled = kset->base.autoneg == AUTONEG_ENABLE;
 
-	/* Mask out unsupported advertisements */
+	/* Mask out unsupported advertisements, and force the autoneg bit */
 	linkmode_and(config.advertising, kset->link_modes.advertising,
 		     support);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,
+			 config.an_enabled);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
-	if (kset->base.autoneg == AUTONEG_DISABLE) {
-		const struct phy_setting *s;
-
+	switch (kset->base.autoneg) {
+	case AUTONEG_DISABLE:
 		/* Autonegotiation disabled, select a suitable speed and
 		 * duplex.
 		 */
@@ -1351,19 +1350,19 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 
 		config.speed = s->speed;
 		config.duplex = s->duplex;
-		config.an_enabled = false;
+		break;
 
-		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
-	} else {
+	case AUTONEG_ENABLE:
 		/* If we have a fixed link, refuse to enable autonegotiation */
 		if (pl->cur_link_an_mode == MLO_AN_FIXED)
 			return -EINVAL;
 
 		config.speed = SPEED_UNKNOWN;
 		config.duplex = DUPLEX_UNKNOWN;
-		config.an_enabled = true;
+		break;
 
-		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
+	default:
+		return -EINVAL;
 	}
 
 	if (pl->phydev) {
-- 
2.20.1

