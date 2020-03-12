Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3336518291B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387971AbgCLGej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:34:39 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43337 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387978AbgCLGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:34:35 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCHQF-0006xP-M0; Thu, 12 Mar 2020 07:34:23 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCHQE-0006AM-C5; Thu, 12 Mar 2020 07:34:22 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 3/4] net: mdio: of: export part of of_mdiobus_register_phy()
Date:   Thu, 12 Mar 2020 07:34:18 +0100
Message-Id: <20200312063419.23615-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200312063419.23615-1-o.rempel@pengutronix.de>
References: <20200312063419.23615-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function will be needed in tja11xx driver for secondary PHY
support.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/of/of_mdio.c    | 74 ++++++++++++++++++++++++-----------------
 include/linux/of_mdio.h | 11 +++++-
 2 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 8270bbf505fb..6ee7e49dcb86 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -60,39 +60,16 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
-static int of_mdiobus_register_phy(struct mii_bus *mdio,
-				    struct device_node *child, u32 addr)
+int __of_mdiobus_register_phy(struct mii_bus *mdio, struct phy_device *phy,
+			      struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
 	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
+	int rc;
 
 	rc = of_irq_get(child, 0);
-	if (rc == -EPROBE_DEFER) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
+	if (rc == -EPROBE_DEFER)
 		return rc;
-	}
+
 	if (rc > 0) {
 		phy->irq = rc;
 		mdio->irq[addr] = rc;
@@ -117,11 +94,48 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	/* All data is now stored in the phy struct;
 	 * register it */
 	rc = phy_device_register(phy);
+	if (rc) {
+		of_node_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
+		child, addr);
+	return 0;
+}
+EXPORT_SYMBOL(__of_mdiobus_register_phy);
+
+static int of_mdiobus_register_phy(struct mii_bus *mdio,
+				    struct device_node *child, u32 addr)
+{
+	struct mii_timestamper *mii_ts;
+	struct phy_device *phy;
+	bool is_c45;
+	int rc;
+	u32 phy_id;
+
+	mii_ts = of_find_mii_timestamper(child);
+	if (IS_ERR(mii_ts))
+		return PTR_ERR(mii_ts);
+
+	is_c45 = of_device_is_compatible(child,
+					 "ethernet-phy-ieee802.3-c45");
+
+	if (!is_c45 && !of_get_phy_id(child, &phy_id))
+		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
+	else
+		phy = get_phy_device(mdio, addr, is_c45);
+	if (IS_ERR(phy)) {
+		if (mii_ts)
+			unregister_mii_timestamper(mii_ts);
+		return PTR_ERR(phy);
+	}
+
+	rc = __of_mdiobus_register_phy(mdio, phy, child, addr);
 	if (rc) {
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
-		of_node_put(child);
 		return rc;
 	}
 
@@ -132,8 +146,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 
-	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
-		child, addr);
 	return 0;
 }
 
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 491a2b7e77c1..b99e9f932002 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -30,7 +30,9 @@ extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 extern int of_phy_register_fixed_link(struct device_node *np);
 extern void of_phy_deregister_fixed_link(struct device_node *np);
 extern bool of_phy_is_fixed_link(struct device_node *np);
-
+extern int __of_mdiobus_register_phy(struct mii_bus *mdio,
+				     struct phy_device *phy,
+				     struct device_node *child, u32 addr);
 
 static inline int of_mdio_parse_addr(struct device *dev,
 				     const struct device_node *np)
@@ -118,6 +120,13 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
 {
 	return false;
 }
+
+static inline int __of_mdiobus_register_phy(struct mii_bus *mdio,
+					    struct phy_device *phy,
+					    struct device_node *child, u32 addr)
+{
+	return -ENOSYS;
+}
 #endif
 
 
-- 
2.25.1

