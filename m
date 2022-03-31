Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834264ED6D7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiCaJ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiCaJ3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:29:07 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54FE1FE542;
        Thu, 31 Mar 2022 02:27:13 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 55D90E0011;
        Thu, 31 Mar 2022 09:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gl1iH0q2B0anl+aCK0/ljXsI9xlWsyssFxKF0grQmb4=;
        b=mouSqiOtzXTm7l+zTduxYuOFFzez059fBlSaf0kCcXS5lk6PkrtiVi8nnAc28ExeLbxlu/
        tBNESuQjkVlIIawn7GEhKVzOTBaQ89pclfJ0vIwJZ717wkT3f7E9c4PNoRA2kx2BxZMcYz
        sg0zWs/IVKaLrxp3r3hrXtzX9cODK7EGxhmEshpoNa+fHp5LLuGWDQdM12Lwo6TVSUw6Ta
        DEngwFQFWHnXremY3pjxZKhtEkW2xxlFzOG3qgGtuvuUXMZ5HN5CjtKNGVPqhAXZWd8qZZ
        GGBuXVwe1rCJfMMz7bd1O5gVGCWok80GKFuG0WogLDtBVCou5mEq/RZY0BrSEg==
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
Subject: [RFC PATCH net-next v2 09/11] net: mdio: of: use fwnode_mdiobus_child_is_phy()
Date:   Thu, 31 Mar 2022 11:25:31 +0200
Message-Id: <20220331092533.348626-10-clement.leger@bootlin.com>
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

Since fwnode_mdiobus_child_is_phy() does almost the same filtering
than done by of_mdiobus_child_is_phy() except the legacy OF compatible
list checking, modify the later one to use the fwnode variant. However,
keep the legacy compatible list checking for legacy purpose.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/of_mdio.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index b8fc1245048e..9c3cd8d3d1f6 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -32,13 +32,6 @@ int of_mdio_parse_addr(struct device *dev, const struct device_node *np)
 }
 EXPORT_SYMBOL(of_mdio_parse_addr);
 
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
@@ -118,17 +111,6 @@ static const struct of_device_id whitelist_phys[] = {
  */
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
 	if (of_match_node(whitelist_phys, child)) {
 		pr_warn(FW_WARN
 			"%pOF: Whitelisted compatible string. Please remove\n",
@@ -136,10 +118,7 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 		return true;
 	}
 
-	if (!of_find_property(child, "compatible", NULL))
-		return true;
-
-	return false;
+	return fwnode_mdiobus_child_is_phy(of_fwnode_handle(child));
 }
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
-- 
2.34.1

