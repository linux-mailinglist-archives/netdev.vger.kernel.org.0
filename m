Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955B93789E7
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 13:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhEJLda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 07:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238405AbhEJLRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 07:17:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2298C061348
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 04:14:32 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lg3rj-0003uE-E5; Mon, 10 May 2021 13:14:23 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lg3rh-0005rJ-By; Mon, 10 May 2021 13:14:21 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC PATCH v2 8/9] net: dsa: dsa_slave_phy_connect(): extend phy's flags with port specific phy flags
Date:   Mon, 10 May 2021 13:14:18 +0200
Message-Id: <20210510111419.22384-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510111419.22384-1-o.rempel@pengutronix.de>
References: <20210510111419.22384-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the flags of the phy that's being connected with the
port specific flags of the switch port.

This is needed to handle a port specific erratum of the KSZ8873 switch,
which is added in a later patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phylink.c | 2 +-
 net/dsa/slave.c           | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 96d8e88b4e46..167c2277814f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1029,7 +1029,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 	if (pl->phydev)
 		return -EBUSY;
 
-	return phy_attach_direct(pl->netdev, phy, 0, interface);
+	return phy_attach_direct(pl->netdev, phy, phy->dev_flags, interface);
 }
 
 /**
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8c0f3c6ab365..7e208f16f006 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1758,6 +1758,10 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
 		return -ENODEV;
 	}
 
+	if (ds->ops->get_phy_flags)
+		slave_dev->phydev->dev_flags |=
+			ds->ops->get_phy_flags(ds, dp->index);
+
 	return phylink_connect_phy(dp->pl, slave_dev->phydev);
 }
 
-- 
2.29.2

