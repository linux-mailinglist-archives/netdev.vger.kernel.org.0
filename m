Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5A1373756
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhEEJXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhEEJWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:22:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74738C061360
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 02:20:40 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhn-0005Xk-1s; Wed, 05 May 2021 11:20:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhk-0002kU-2j; Wed, 05 May 2021 11:20:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [RFC PATCH v1 9/9] net: phy: micrel: add patch for erratas on port1
Date:   Wed,  5 May 2021 11:20:25 +0200
Message-Id: <20210505092025.8785-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210505092025.8785-1-o.rempel@pengutronix.de>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
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

The micrel switch ksz8873 has the following errata [1]:

* Module 1: LinkMD does not work on Port 1
* Module 4: Port 1 does not respond to received flow control PAUSE frames

This patch disables the support on the defective port.

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 13 +++++++++++++
 drivers/net/phy/micrel.c            |  3 +++
 drivers/net/phy/phylink.c           |  2 +-
 include/linux/micrel_phy.h          |  1 +
 net/dsa/slave.c                     |  4 ++++
 5 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index fb47be0c2154..42b7ef36f24f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -966,6 +966,18 @@ static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
 		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
 }
 
+static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	/* Silicon Errata Sheet (DS80000830A):
+	 * Port 1 does not work with LinkMD Cable-Testing.
+	 * Port 1 does not respond to received PAUSE control frames.
+	 */
+	if (!port)
+		return MICREL_KSZ8_P1_ERRATA;
+
+	return 0;
+}
+
 static void ksz8_get_strings(struct dsa_switch *ds, int port,
 			     u32 stringset, uint8_t *buf)
 {
@@ -1516,6 +1528,7 @@ static void ksz_validate(struct dsa_switch *ds, int port,
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.get_phy_flags		= ksz8_sw_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index f0ca7b53bcf9..dbdc0926386e 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1414,6 +1414,9 @@ static int kszphy_probe(struct phy_device *phydev)
 
 static int ksz886x_cable_test_start(struct phy_device *phydev)
 {
+	if (phydev->dev_flags & MICREL_KSZ8_P1_ERRATA)
+		return -ENOTSUPP;
+
 	/* If autoneg is enabled, we won't be able to test cross pair
 	 * short. In this case, the PHY will "detect" a link and
 	 * confuse the internal state machine - disable auto neg here.
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
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index ee23acc4d551..0117a2c126eb 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -39,6 +39,7 @@
 /* struct phy_device dev_flags definitions */
 #define MICREL_PHY_50MHZ_CLK	0x00000001
 #define MICREL_PHY_FXEN		0x00000002
+#define MICREL_KSZ8_P1_ERRATA	0x00000003
 
 #define MICREL_KSZ9021_EXTREG_CTRL	0xB
 #define MICREL_KSZ9021_EXTREG_DATA_WRITE	0xC
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

