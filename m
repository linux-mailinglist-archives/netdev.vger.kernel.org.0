Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A656E4E7D3D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiCYRo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 13:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiCYRoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 13:44:54 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D6013F80;
        Fri, 25 Mar 2022 10:43:13 -0700 (PDT)
Received: from relay6-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::226])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 327CFC8431;
        Fri, 25 Mar 2022 17:25:36 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8E1B8C0010;
        Fri, 25 Mar 2022 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648229040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92YrscYGwPSDZJXybsraG0OvQ2i/KwdGk8nKAr92wok=;
        b=M/cR+zwuXNK6Z5Mot9h7ILnY0TKSoLfn1JREYexbFsyC338EPSEJT5c8RgkqjFdxywfCBk
        mZBylyPl2o2uKh+9UgW3ANFYzYXbXzccjY0HckI/QxTbd/VORL4fI1oCuuS2JNnpTpF+uP
        Cl/cxR6D7U2EKqctR6duvjPHUeAblg2OdL7QNc34YWUDSbSeZ3TTDsE8Ela+JnJHWlxo37
        ntNvyXkS8atg/cAx4amUSLpX5UNPXsl74MqNKEA6Ac6rjJcH8k0rXeO3IXZ00NMAIGR9bj
        DMbZXGS041izTQnAq+Llm+o7OAntnv2oj74KKufEUeN0Kqnb+tcQhLkLoxM3PQ==
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
Subject: [net-next 2/5] net: mdio: of: use fwnode_mdiobus_* functions
Date:   Fri, 25 Mar 2022 18:22:31 +0100
Message-Id: <20220325172234.1259667-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325172234.1259667-1-clement.leger@bootlin.com>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that fwnode support has been added and implements the same behavior
expected by device-tree parsing, directly call fwnode_mdiobus_*
functions in of_mdio.c. Eventually, the same will be doable for ACPI in
order to use a single parsing method based on fwnode API.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/of_mdio.c | 187 +------------------------------------
 1 file changed, 2 insertions(+), 185 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..b53dab9fc78e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -21,18 +21,9 @@
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 
-#define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
-
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_LICENSE("GPL");
 
-/* Extract the clause 22 phy ID from the compatible string of the form
- * ethernet-phy-idAAAA.BBBB */
-static int of_get_phy_id(struct device_node *device, u32 *phy_id)
-{
-	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
-}
-
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr)
 {
@@ -42,98 +33,9 @@ int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 }
 EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 
-static int of_mdiobus_register_phy(struct mii_bus *mdio,
-				    struct device_node *child, u32 addr)
-{
-	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
-}
-
-static int of_mdiobus_register_device(struct mii_bus *mdio,
-				      struct device_node *child, u32 addr)
-{
-	struct fwnode_handle *fwnode = of_fwnode_handle(child);
-	struct mdio_device *mdiodev;
-	int rc;
-
-	mdiodev = mdio_device_create(mdio, addr);
-	if (IS_ERR(mdiodev))
-		return PTR_ERR(mdiodev);
-
-	/* Associate the OF node with the device structure so it
-	 * can be looked up later.
-	 */
-	fwnode_handle_get(fwnode);
-	device_set_node(&mdiodev->dev, fwnode);
-
-	/* All data is now stored in the mdiodev struct; register it. */
-	rc = mdio_device_register(mdiodev);
-	if (rc) {
-		mdio_device_free(mdiodev);
-		of_node_put(child);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
-		child, addr);
-	return 0;
-}
-
-/* The following is a list of PHY compatible strings which appear in
- * some DTBs. The compatible string is never matched against a PHY
- * driver, so is pointless. We only expect devices which are not PHYs
- * to have a compatible string, so they can be matched to an MDIO
- * driver.  Encourage users to upgrade their DT blobs to remove these.
- */
-static const struct of_device_id whitelist_phys[] = {
-	{ .compatible = "brcm,40nm-ephy" },
-	{ .compatible = "broadcom,bcm5241" },
-	{ .compatible = "marvell,88E1111", },
-	{ .compatible = "marvell,88e1116", },
-	{ .compatible = "marvell,88e1118", },
-	{ .compatible = "marvell,88e1145", },
-	{ .compatible = "marvell,88e1149r", },
-	{ .compatible = "marvell,88e1310", },
-	{ .compatible = "marvell,88E1510", },
-	{ .compatible = "marvell,88E1514", },
-	{ .compatible = "moxa,moxart-rtl8201cp", },
-	{}
-};
-
-/*
- * Return true if the child node is for a phy. It must either:
- * o Compatible string of "ethernet-phy-idX.X"
- * o Compatible string of "ethernet-phy-ieee802.3-c45"
- * o Compatible string of "ethernet-phy-ieee802.3-c22"
- * o In the white list above (and issue a warning)
- * o No compatibility string
- *
- * A device which is not a phy is expected to have a compatible string
- * indicating what sort of device it is.
- */
 bool of_mdiobus_child_is_phy(struct device_node *child)
 {
-	u32 phy_id;
-
-	if (of_get_phy_id(child, &phy_id) != -EINVAL)
-		return true;
-
-	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c45"))
-		return true;
-
-	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c22"))
-		return true;
-
-	if (of_match_node(whitelist_phys, child)) {
-		pr_warn(FW_WARN
-			"%pOF: Whitelisted compatible string. Please remove\n",
-			child);
-		return true;
-	}
-
-	if (!of_find_property(child, "compatible", NULL))
-		return true;
-
-	return false;
+	return fwnode_mdiobus_child_is_phy(of_fwnode_handle(child));
 }
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
@@ -147,92 +49,7 @@ EXPORT_SYMBOL(of_mdiobus_child_is_phy);
  */
 int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
-	struct device_node *child;
-	bool scanphys = false;
-	int addr, rc;
-
-	if (!np)
-		return mdiobus_register(mdio);
-
-	/* Do not continue if the node is disabled */
-	if (!of_device_is_available(np))
-		return -ENODEV;
-
-	/* Mask out all PHYs from auto probing.  Instead the PHYs listed in
-	 * the device tree are populated after the bus has been registered */
-	mdio->phy_mask = ~0;
-
-	device_set_node(&mdio->dev, of_fwnode_handle(np));
-
-	/* Get bus level PHY reset GPIO details */
-	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
-	of_property_read_u32(np, "reset-delay-us", &mdio->reset_delay_us);
-	mdio->reset_post_delay_us = 0;
-	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
-
-	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
-	if (rc)
-		return rc;
-
-	/* Loop over the child nodes and register a phy_device for each phy */
-	for_each_available_child_of_node(np, child) {
-		addr = of_mdio_parse_addr(&mdio->dev, child);
-		if (addr < 0) {
-			scanphys = true;
-			continue;
-		}
-
-		if (of_mdiobus_child_is_phy(child))
-			rc = of_mdiobus_register_phy(mdio, child, addr);
-		else
-			rc = of_mdiobus_register_device(mdio, child, addr);
-
-		if (rc == -ENODEV)
-			dev_err(&mdio->dev,
-				"MDIO device at address %d is missing.\n",
-				addr);
-		else if (rc)
-			goto unregister;
-	}
-
-	if (!scanphys)
-		return 0;
-
-	/* auto scan for PHYs with empty reg property */
-	for_each_available_child_of_node(np, child) {
-		/* Skip PHYs with reg property set */
-		if (of_find_property(child, "reg", NULL))
-			continue;
-
-		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
-			/* skip already registered PHYs */
-			if (mdiobus_is_registered_device(mdio, addr))
-				continue;
-
-			/* be noisy to encourage people to set reg property */
-			dev_info(&mdio->dev, "scan phy %pOFn at address %i\n",
-				 child, addr);
-
-			if (of_mdiobus_child_is_phy(child)) {
-				/* -ENODEV is the return code that PHYLIB has
-				 * standardized on to indicate that bus
-				 * scanning should continue.
-				 */
-				rc = of_mdiobus_register_phy(mdio, child, addr);
-				if (!rc)
-					break;
-				if (rc != -ENODEV)
-					goto unregister;
-			}
-		}
-	}
-
-	return 0;
-
-unregister:
-	mdiobus_unregister(mdio);
-	return rc;
+	return fwnode_mdiobus_register(mdio, of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdiobus_register);
 
-- 
2.34.1

