Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301903A5C32
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 06:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhFNEd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 00:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbhFNEdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 00:33:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680A6C061766
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 21:31:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lseFz-0001kV-Q5; Mon, 14 Jun 2021 06:31:27 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lseFy-00035T-Tp; Mon, 14 Jun 2021 06:31:26 +0200
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
Subject: [PATCH net-next v5 7/8] net: dsa: dsa_slave_phy_connect(): extend phy's flags with port specific phy flags
Date:   Mon, 14 Jun 2021 06:31:24 +0200
Message-Id: <20210614043125.11658-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210614043125.11658-1-o.rempel@pengutronix.de>
References: <20210614043125.11658-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current get_phy_flags() is only processed when we connect to a PHY
via a designed phy-handle property via phylink_of_phy_connect(), but if
we fallback on the internal MDIO bus created by a switch and take the
dsa_slave_phy_connect() path then we would not be processing that flag
and using it at PHY connection time.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/dsa/slave.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4756b920108..915c7cab7900 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1749,7 +1749,8 @@ static void dsa_slave_phylink_fixed_state(struct phylink_config *config,
 }
 
 /* slave device setup *******************************************************/
-static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
+static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr,
+				 u32 flags)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_switch *ds = dp->ds;
@@ -1760,6 +1761,8 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
 		return -ENODEV;
 	}
 
+	slave_dev->phydev->dev_flags |= flags;
+
 	return phylink_connect_phy(dp->pl, slave_dev->phydev);
 }
 
@@ -1804,7 +1807,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
 		 */
-		ret = dsa_slave_phy_connect(slave_dev, dp->index);
+		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
 		if (ret) {
 			netdev_err(slave_dev,
 				   "failed to connect to port %d: %d\n",
-- 
2.29.2

