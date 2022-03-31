Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE44ED6CE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiCaJ2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbiCaJ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:52 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868211FDFF0;
        Thu, 31 Mar 2022 02:27:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EB727E0004;
        Thu, 31 Mar 2022 09:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nRN8rAoSulvBgbxXwy3jJyKItub0BlzV5SCreqaglg8=;
        b=TGBtJqjSaZbGSLLF2cTEmZtPnb7adUzM9yyG3Ii/aztqT7y3//d3bRp2fW/a5MKW1gWvJ/
        Pses9BikYicUPSwkDbCnZwyLeHO1tfKYGqya+6k7XXt40o45v07CtkEQSbqi6Z6G9ryUix
        b2w/2SFiqosscTMMN1/SxXorQMKHCT4/LaiOJHmree1JDzkK4hOybnpDX9f56bxeqC3d8/
        ucrukzyKPXH66AaNd2xr15TnpQDnXIp9gEJo2pn+ZBIr8HviGv7fxxmLcDrPeGLxpF0er8
        o84mpRscTF032uKwQG2U7iza0CbuUQ5pj2YL0nWSVj/3uX1C9Ls5O0/hQ84zwQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC PATCH net-next v2 01/11] net: mdio: fwnode: import of_mdiobus_register() and needed functions
Date:   Thu, 31 Mar 2022 11:25:23 +0200
Message-Id: <20220331092533.348626-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331092533.348626-1-clement.leger@bootlin.com>
References: <20220331092533.348626-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import of_mdiobus_register and needed functions to allow visualizing a
pretty diff of the modifications that are going to be done for fwnode
support. While importing, did a few modifications to ensure it compiles
correctly:
- Renamed of_mdiobus_register() to fwnode_mdiobus_register()
- Renamed of_mdiobus_child_is_phy() to fwnode_mdiobus_child_is_phy()
- Call fwnode_get_phy_id() instead of of_get_phy_id() which is already
  a wrapper ended up calling fwnode_get_phy_id().

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 195 +++++++++++++++++++++++++++++++++
 1 file changed, 195 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..a5a6fd9ebd94 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -9,8 +9,11 @@
 #include <linux/acpi.h>
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 
+#define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
+
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
@@ -142,3 +145,195 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
+static int of_mdiobus_register_device(struct mii_bus *mdio,
+				      struct device_node *child, u32 addr)
+{
+	struct fwnode_handle *fwnode = of_fwnode_handle(child);
+	struct mdio_device *mdiodev;
+	int rc;
+
+	mdiodev = mdio_device_create(mdio, addr);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	/* Associate the OF node with the device structure so it
+	 * can be looked up later.
+	 */
+	fwnode_handle_get(fwnode);
+	device_set_node(&mdiodev->dev, fwnode);
+
+	/* All data is now stored in the mdiodev struct; register it. */
+	rc = mdio_device_register(mdiodev);
+	if (rc) {
+		mdio_device_free(mdiodev);
+		of_node_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
+		child, addr);
+	return 0;
+}
+
+/* The following is a list of PHY compatible strings which appear in
+ * some DTBs. The compatible string is never matched against a PHY
+ * driver, so is pointless. We only expect devices which are not PHYs
+ * to have a compatible string, so they can be matched to an MDIO
+ * driver.  Encourage users to upgrade their DT blobs to remove these.
+ */
+static const struct of_device_id whitelist_phys[] = {
+	{ .compatible = "brcm,40nm-ephy" },
+	{ .compatible = "broadcom,bcm5241" },
+	{ .compatible = "marvell,88E1111", },
+	{ .compatible = "marvell,88e1116", },
+	{ .compatible = "marvell,88e1118", },
+	{ .compatible = "marvell,88e1145", },
+	{ .compatible = "marvell,88e1149r", },
+	{ .compatible = "marvell,88e1310", },
+	{ .compatible = "marvell,88E1510", },
+	{ .compatible = "marvell,88E1514", },
+	{ .compatible = "moxa,moxart-rtl8201cp", },
+	{}
+};
+
+/*
+ * Return true if the child node is for a phy. It must either:
+ * o Compatible string of "ethernet-phy-idX.X"
+ * o Compatible string of "ethernet-phy-ieee802.3-c45"
+ * o Compatible string of "ethernet-phy-ieee802.3-c22"
+ * o In the white list above (and issue a warning)
+ * o No compatibility string
+ *
+ * A device which is not a phy is expected to have a compatible string
+ * indicating what sort of device it is.
+ */
+bool fwnode_mdiobus_child_is_phy(struct device_node *child)
+{
+	u32 phy_id;
+
+	if (of_get_phy_id(child, &phy_id) != -EINVAL)
+		return true;
+
+	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c45"))
+		return true;
+
+	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c22"))
+		return true;
+
+	if (of_match_node(whitelist_phys, child)) {
+		pr_warn(FW_WARN
+			"%pOF: Whitelisted compatible string. Please remove\n",
+			child);
+		return true;
+	}
+
+	if (!of_find_property(child, "compatible", NULL))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_child_is_phy);
+
+/**
+ * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
+ * @mdio: pointer to mii_bus structure
+ * @np: pointer to device_node of MDIO bus.
+ *
+ * This function registers the mii_bus structure and registers a phy_device
+ * for each child node of @np.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+{
+	struct device_node *child;
+	bool scanphys = false;
+	int addr, rc;
+
+	if (!np)
+		return mdiobus_register(mdio);
+
+	/* Do not continue if the node is disabled */
+	if (!of_device_is_available(np))
+		return -ENODEV;
+
+	/* Mask out all PHYs from auto probing.  Instead the PHYs listed in
+	 * the device tree are populated after the bus has been registered */
+	mdio->phy_mask = ~0;
+
+	device_set_node(&mdio->dev, of_fwnode_handle(np));
+
+	/* Get bus level PHY reset GPIO details */
+	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
+	of_property_read_u32(np, "reset-delay-us", &mdio->reset_delay_us);
+	mdio->reset_post_delay_us = 0;
+	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
+
+	/* Register the MDIO bus */
+	rc = mdiobus_register(mdio);
+	if (rc)
+		return rc;
+
+	/* Loop over the child nodes and register a phy_device for each phy */
+	for_each_available_child_of_node(np, child) {
+		addr = of_mdio_parse_addr(&mdio->dev, child);
+		if (addr < 0) {
+			scanphys = true;
+			continue;
+		}
+
+		if (of_mdiobus_child_is_phy(child))
+			rc = fwnode_mdiobus_register_phy(mdio,
+							 of_fwnode_handle(child),
+							 addr);
+		else
+			rc = of_mdiobus_register_device(mdio, child, addr);
+
+		if (rc == -ENODEV)
+			dev_err(&mdio->dev,
+				"MDIO device at address %d is missing.\n",
+				addr);
+		else if (rc)
+			goto unregister;
+	}
+
+	if (!scanphys)
+		return 0;
+
+	/* auto scan for PHYs with empty reg property */
+	for_each_available_child_of_node(np, child) {
+		/* Skip PHYs with reg property set */
+		if (of_find_property(child, "reg", NULL))
+			continue;
+
+		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+			/* skip already registered PHYs */
+			if (mdiobus_is_registered_device(mdio, addr))
+				continue;
+
+			/* be noisy to encourage people to set reg property */
+			dev_info(&mdio->dev, "scan phy %pOFn at address %i\n",
+				 child, addr);
+
+			if (of_mdiobus_child_is_phy(child)) {
+				/* -ENODEV is the return code that PHYLIB has
+				 * standardized on to indicate that bus
+				 * scanning should continue.
+				 */
+				rc = fwnode_mdiobus_register_phy(mdio,
+								 of_fwnode_handle(child),
+								 addr);
+				if (!rc)
+					break;
+				if (rc != -ENODEV)
+					goto unregister;
+			}
+		}
+	}
+
+	return 0;
+
+unregister:
+	mdiobus_unregister(mdio);
+	return rc;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
-- 
2.34.1

