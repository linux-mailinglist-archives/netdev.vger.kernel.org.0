Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092C54ED6D2
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiCaJ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiCaJ25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:57 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDDE1FDFF0;
        Thu, 31 Mar 2022 02:27:07 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9D65DE0017;
        Thu, 31 Mar 2022 09:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAsAunOpLPkQ8b/B+a3+vq5yr3haPngqm0snsGYNZBo=;
        b=MexrRSnmes7h6ade/vOQF08VQCEFR/SfObvSIqwl9bTwkrLvpWAqzzBBZscKnPeA3o5PPi
        Y5B+gDOO5a2zTymOjnImEdScoc1H7hBTxI+eGO4Auo3gIi0Gk9y4Tnn8f1inVvehpCbSRW
        uQ9YA+5iuHqILIu8bCZk5YTDSbJZJ6W2u7kVWIacFpsuBGCzllLlF7oIuL/6fEeyU7m50j
        p6y7uc0hzqf3SPPHrRKMATsUM0PJYjjRvk4ZLllwruYvGUQfHA4uNv7CxZsbY77PQoLyVJ
        7o3GUmiOpCUSro0QPwtnlFQYKpLMG2XpMT4TC2aRF1FCgsyBX3ucPXDWCBZHFw==
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
Subject: [RFC PATCH net-next v2 04/11] net: mdio: fwnode: convert fwnode_mdiobus_register() for fwnode
Date:   Thu, 31 Mar 2022 11:25:26 +0200
Message-Id: <20220331092533.348626-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331092533.348626-1-clement.leger@bootlin.com>
References: <20220331092533.348626-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First version was added as a simple copy of of_mdiobus_register() to
allow compiling and being able to see the diff of modifications that
are going to be done. This commits convert the code that was imported
to handle a fwnode_handle properly.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 76 ++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 38c873c49ecf..319cccd0edeb 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -146,10 +146,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
 
-static int of_mdiobus_register_device(struct mii_bus *mdio,
-				      struct device_node *child, u32 addr)
+static int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+					  struct fwnode_handle *child, u32 addr)
 {
-	struct fwnode_handle *fwnode = of_fwnode_handle(child);
 	struct mdio_device *mdiodev;
 	int rc;
 
@@ -160,18 +159,18 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	/* Associate the OF node with the device structure so it
 	 * can be looked up later.
 	 */
-	fwnode_handle_get(fwnode);
-	device_set_node(&mdiodev->dev, fwnode);
+	fwnode_handle_get(child);
+	device_set_node(&mdiodev->dev, child);
 
 	/* All data is now stored in the mdiodev struct; register it. */
 	rc = mdio_device_register(mdiodev);
 	if (rc) {
 		mdio_device_free(mdiodev);
-		of_node_put(child);
+		fwnode_handle_put(child);
 		return rc;
 	}
 
-	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
+	dev_dbg(&mdio->dev, "registered mdio device %pfwP at address %i\n",
 		child, addr);
 	return 0;
 }
@@ -186,26 +185,51 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
  * A device which is not a phy is expected to have a compatible string
  * indicating what sort of device it is.
  */
-bool fwnode_mdiobus_child_is_phy(struct device_node *child)
+bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
 {
 	u32 phy_id;
 
-	if (of_get_phy_id(child, &phy_id) != -EINVAL)
+	if (fwnode_get_phy_id(child, &phy_id) != -EINVAL)
 		return true;
 
-	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c45"))
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c45") >= 0)
 		return true;
 
-	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c22"))
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c22") >= 0)
 		return true;
 
-	if (!of_find_property(child, "compatible", NULL))
+	if (!fwnode_property_present(child, "compatible"))
 		return true;
 
 	return false;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_child_is_phy);
 
+int fwnode_mdio_parse_addr(struct device *dev,
+			   const struct fwnode_handle *fwnode)
+{
+	u32 addr;
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", &addr);
+	if (ret < 0) {
+		dev_err(dev, "%pfwP has invalid PHY address\n", fwnode);
+		return ret;
+	}
+
+	/* A PHY must have a reg property in the range [0-31] */
+	if (addr >= PHY_MAX_ADDR) {
+		dev_err(dev, "%pfwP PHY address %i is too large\n",
+			fwnode, addr);
+		return -EINVAL;
+	}
+
+	return addr;
+}
+EXPORT_SYMBOL(fwnode_mdio_parse_addr);
+
 /**
  * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
  * @mdio: pointer to mii_bus structure
@@ -214,29 +238,31 @@ EXPORT_SYMBOL(fwnode_mdiobus_child_is_phy);
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @np.
  */
-int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 {
-	struct device_node *child;
+	struct fwnode_handle *child;
 	int addr, rc;
 
-	if (!np)
+	if (!fwnode)
 		return mdiobus_register(mdio);
 
 	/* Do not continue if the node is disabled */
-	if (!of_device_is_available(np))
+	if (!fwnode_device_is_available(fwnode))
 		return -ENODEV;
 
 	/* Mask out all PHYs from auto probing.  Instead the PHYs listed in
 	 * the device tree are populated after the bus has been registered */
 	mdio->phy_mask = ~0;
 
-	device_set_node(&mdio->dev, of_fwnode_handle(np));
+	device_set_node(&mdio->dev, fwnode);
 
 	/* Get bus level PHY reset GPIO details */
 	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
-	of_property_read_u32(np, "reset-delay-us", &mdio->reset_delay_us);
+	fwnode_property_read_u32(fwnode, "reset-delay-us",
+				 &mdio->reset_delay_us);
 	mdio->reset_post_delay_us = 0;
-	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
+	fwnode_property_read_u32(fwnode, "reset-post-delay-us",
+				 &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
 	rc = mdiobus_register(mdio);
@@ -244,17 +270,15 @@ int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		return rc;
 
 	/* Loop over the child nodes and register a phy_device for each phy */
-	for_each_available_child_of_node(np, child) {
-		addr = of_mdio_parse_addr(&mdio->dev, child);
+	fwnode_for_each_available_child_node(fwnode, child) {
+		addr = fwnode_mdio_parse_addr(&mdio->dev, child);
 		if (addr < 0)
 			continue;
 
-		if (of_mdiobus_child_is_phy(child))
-			rc = fwnode_mdiobus_register_phy(mdio,
-							 of_fwnode_handle(child),
-							 addr);
+		if (fwnode_mdiobus_child_is_phy(child))
+			rc = fwnode_mdiobus_register_phy(mdio, child, addr);
 		else
-			rc = of_mdiobus_register_device(mdio, child, addr);
+			rc = fwnode_mdiobus_register_device(mdio, child, addr);
 
 		if (rc == -ENODEV)
 			dev_err(&mdio->dev,
-- 
2.34.1

