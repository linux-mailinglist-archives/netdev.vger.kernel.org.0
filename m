Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262054ED6D9
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiCaJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiCaJ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:29:08 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A8A1FE55E;
        Thu, 31 Mar 2022 02:27:14 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A00B5E001C;
        Thu, 31 Mar 2022 09:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pjh1w4KsWjwbxRE8gzfuyRP+hgAL8kEMAJVXPRugr/0=;
        b=LfHoCHRWQKU+kWPmYEjxgCwvaMz+Vhtk392+KxdWo5M0jpaykc8TIQ4wqQiknqIXAPY1eg
        uELUZrVLIJHjXj/SqrVXtE5aMoY0kn+QlN5RyZfP8f7tOi0D358bZlGAbNCjd8N/qtpK9c
        QMD20fFsmNinM11Twx3w/iS3a9L3q4aOsXKhs6EythL+UOPlynXiP3gaPbkYJrev7y0g2a
        KxzbHf+ZjzRFIJtSU2vST/hpkZHkyipqYpsh0+d5Rve2zAx39SkD18S8ZFoh5Yq3AS3sdu
        8Ajr+kU4jWoDCd6QnWV6mBEoOVLRn+uDXpIlExtqgDSmC20DnzDHxB4C7HINWQ==
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
Subject: [RFC PATCH net-next v2 10/11] net: mdio: of: use fwnode_mdiobus_register() in of_mdiobus_register()
Date:   Thu, 31 Mar 2022 11:25:32 +0200
Message-Id: <20220331092533.348626-11-clement.leger@bootlin.com>
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

Now that fwnode_mdiobus_register() also handle phy registration, modify
of_mdiobus_register() to use this one but keep ilegacy scanning of
nodes that don't have a "reg" property. The behavior is a bit different
since the scanning loop will always be executed even if all nodes have
a "reg" property. However, since the "reg" property is checked in that
loop, the final outcome will be the same (ie scan only the node that
don't have a "reg" property). Since of_mdiobus_register_device() is not
used anymore, remove it.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/of_mdio.c | 77 +-------------------------------------
 1 file changed, 1 insertion(+), 76 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9c3cd8d3d1f6..4a7ad6704feb 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -47,36 +47,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
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
 /* The following is a list of PHY compatible strings which appear in
  * some DTBs. The compatible string is never matched against a PHY
  * driver, so is pointless. We only expect devices which are not PHYs
@@ -133,57 +103,12 @@ EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
 	struct device_node *child;
-	bool scanphys = false;
 	int addr, rc;
 
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
+	rc = fwnode_mdiobus_register(mdio, of_fwnode_handle(np));
 	if (rc)
 		return rc;
 
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
 	/* auto scan for PHYs with empty reg property */
 	for_each_available_child_of_node(np, child) {
 		/* Skip PHYs with reg property set */
-- 
2.34.1

