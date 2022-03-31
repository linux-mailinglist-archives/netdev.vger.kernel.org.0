Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF604ED6CB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiCaJ27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiCaJ2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:54 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41811FDFF5;
        Thu, 31 Mar 2022 02:27:05 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7ECE2E000F;
        Thu, 31 Mar 2022 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GPSyndh1tTrFYZd2ommChHstRrAw7UFBSUMhhD8Cfhk=;
        b=nmi9SS0ACqmwBMQWOjv1cnd0gcBFi3hcogsH29t4nMKKyTJIZU4Jhjy4e629RQNL5dnzb9
        qa4hSmKnpyWzV+XanyAAkXoz4pumAhkA+yI1/EMrhj4c//MpgFoi98ISc5FRyv24qe5GrD
        oX2kzntEeZkZ64J0Me6LNqx8AWPtBpXn/gXKIEfDeqXyKMxtyy2SGroHQh+u40MPEzyLiY
        nSnUQmtfiYGOs2aF0aakMe1bAXwVTEyV5I/jV2GXVcHUqQQgYM6Hwnng+JxyYnLywQ3DuW
        VkaCje+UIJglSTbDtoGmudJcC/h+bijKgyJG4L1zI5o4lpzaMK+FeWKsAN/edw==
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
Subject: [RFC PATCH net-next v2 03/11] net: mdio: fwnode: remove legacy phy scanning
Date:   Thu, 31 Mar 2022 11:25:25 +0200
Message-Id: <20220331092533.348626-4-clement.leger@bootlin.com>
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

When 'reg' property is missing from child MDIO nodes, an automatic scan
is done to find phy devices that are present on the bus. Since the
'reg' property is marked as required in the mdio.yaml bindings, remove
this legacy scan mechanism.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 39 +---------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 17585c5b34bb..38c873c49ecf 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -217,7 +217,6 @@ EXPORT_SYMBOL(fwnode_mdiobus_child_is_phy);
 int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
 	struct device_node *child;
-	bool scanphys = false;
 	int addr, rc;
 
 	if (!np)
@@ -247,10 +246,8 @@ int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	/* Loop over the child nodes and register a phy_device for each phy */
 	for_each_available_child_of_node(np, child) {
 		addr = of_mdio_parse_addr(&mdio->dev, child);
-		if (addr < 0) {
-			scanphys = true;
+		if (addr < 0)
 			continue;
-		}
 
 		if (of_mdiobus_child_is_phy(child))
 			rc = fwnode_mdiobus_register_phy(mdio,
@@ -267,40 +264,6 @@ int fwnode_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 			goto unregister;
 	}
 
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
-				rc = fwnode_mdiobus_register_phy(mdio,
-								 of_fwnode_handle(child),
-								 addr);
-				if (!rc)
-					break;
-				if (rc != -ENODEV)
-					goto unregister;
-			}
-		}
-	}
-
 	return 0;
 
 unregister:
-- 
2.34.1

