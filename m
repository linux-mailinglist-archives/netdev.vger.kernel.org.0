Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7A5A116A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242172AbiHYNCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242140AbiHYNCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:02:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AC68709D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 06:02:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUz-0007zW-9f; Thu, 25 Aug 2022 15:02:17 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUw-001uGQ-1p; Thu, 25 Aug 2022 15:02:14 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUv-00FeUN-37; Thu, 25 Aug 2022 15:02:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v2 4/7] net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
Date:   Thu, 25 Aug 2022 15:02:08 +0200
Message-Id: <20220825130211.3730461-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825130211.3730461-1-o.rempel@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework error handling as preparation for PSE patch. This patch should
make it easier to extend this function.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/mdio/fwnode_mdio.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 3e79c2c519298..e78ad55c0e091 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -108,8 +108,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
 	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
+		rc = PTR_ERR(phy);
+		goto clean_mii_ts;
 	}
 
 	if (is_acpi_node(child)) {
@@ -123,17 +123,13 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
-			phy_device_free(phy);
 			fwnode_handle_put(phy->mdio.dev.fwnode);
-			return rc;
+			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
-		if (rc) {
-			unregister_mii_timestamper(mii_ts);
-			phy_device_free(phy);
-			return rc;
-		}
+		if (rc)
+			goto clean_phy;
 	}
 
 	/* phy->mii_ts may already be defined by the PHY driver. A
@@ -143,5 +139,12 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 	return 0;
+
+clean_phy:
+	phy_device_free(phy);
+clean_mii_ts:
+	unregister_mii_timestamper(mii_ts);
+
+	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
-- 
2.30.2

