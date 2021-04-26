Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3C36B400
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhDZNUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbhDZNUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:20:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F74EC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:19:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18s-0004UY-CJ; Mon, 26 Apr 2021 15:19:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18r-0006mR-9Z; Mon, 26 Apr 2021 15:19:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v7 2/9] net: dsa: microchip: ksz8795: move cpu_select_interface to extra function
Date:   Mon, 26 Apr 2021 15:19:04 +0200
Message-Id: <20210426131911.25976-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210426131911.25976-1-o.rempel@pengutronix.de>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

This patch moves the cpu interface selection code to a individual
function specific for ksz8795. It will make it simpler to customize the
code path for different switches supported by this driver.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---
v1 -> v5: - extracted this from previous bigger patch
---
 drivers/net/dsa/microchip/ksz8795.c | 92 ++++++++++++++++-------------
 1 file changed, 50 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 91297df4371c..85fb727c13eb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -909,10 +909,58 @@ static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
+static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
+{
+	struct ksz_port *p = &dev->ports[port];
+	u8 data8;
+
+	if (!p->interface && dev->compat_interface) {
+		dev_warn(dev->dev,
+			 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. "
+			 "Please update your device tree.\n",
+			 port);
+		p->interface = dev->compat_interface;
+	}
+
+	/* Configure MII interface for proper network communication. */
+	ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
+	data8 &= ~PORT_INTERFACE_TYPE;
+	data8 &= ~PORT_GMII_1GPS_MODE;
+	switch (p->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		p->phydev.speed = SPEED_100;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		data8 |= PORT_INTERFACE_RMII;
+		p->phydev.speed = SPEED_100;
+		break;
+	case PHY_INTERFACE_MODE_GMII:
+		data8 |= PORT_GMII_1GPS_MODE;
+		data8 |= PORT_INTERFACE_GMII;
+		p->phydev.speed = SPEED_1000;
+		break;
+	default:
+		data8 &= ~PORT_RGMII_ID_IN_ENABLE;
+		data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
+		if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			data8 |= PORT_RGMII_ID_IN_ENABLE;
+		if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			data8 |= PORT_RGMII_ID_OUT_ENABLE;
+		data8 |= PORT_GMII_1GPS_MODE;
+		data8 |= PORT_INTERFACE_RGMII;
+		p->phydev.speed = SPEED_1000;
+		break;
+	}
+	ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
+	p->phydev.duplex = 1;
+}
+
 static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
-	u8 data8, member;
+	u8 member;
 
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
@@ -929,47 +977,7 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
-		if (!p->interface && dev->compat_interface) {
-			dev_warn(dev->dev,
-				 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. "
-				 "Please update your device tree.\n",
-				 port);
-			p->interface = dev->compat_interface;
-		}
-
-		/* Configure MII interface for proper network communication. */
-		ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
-		data8 &= ~PORT_INTERFACE_TYPE;
-		data8 &= ~PORT_GMII_1GPS_MODE;
-		switch (p->interface) {
-		case PHY_INTERFACE_MODE_MII:
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_RMII:
-			data8 |= PORT_INTERFACE_RMII;
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_GMII:
-			data8 |= PORT_GMII_1GPS_MODE;
-			data8 |= PORT_INTERFACE_GMII;
-			p->phydev.speed = SPEED_1000;
-			break;
-		default:
-			data8 &= ~PORT_RGMII_ID_IN_ENABLE;
-			data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
-			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-				data8 |= PORT_RGMII_ID_IN_ENABLE;
-			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-				data8 |= PORT_RGMII_ID_OUT_ENABLE;
-			data8 |= PORT_GMII_1GPS_MODE;
-			data8 |= PORT_INTERFACE_RGMII;
-			p->phydev.speed = SPEED_1000;
-			break;
-		}
-		ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
-		p->phydev.duplex = 1;
+		ksz8795_cpu_interface_select(dev, port);
 
 		member = dev->port_mask;
 	} else {
-- 
2.29.2

