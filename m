Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07FE4ED6D1
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiCaJ2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiCaJ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:52 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD21FDFFF;
        Thu, 31 Mar 2022 02:27:04 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3EABFE000A;
        Thu, 31 Mar 2022 09:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2SAnDYRLKVywNOeBXc/6UH8ACkBgPoznG9i7b/FYe8=;
        b=KA9NzZ4AxKHzsT8w4D5p/XfRp+qbxvC4Z5E4LZjJj2at4otRL2rG39ivBs9vvte+62lhhT
        v+C5ucCgtDvdqH8fZI7IM+P+SMIe490JBke9c++lumBISF8Chw9IFlFevbhPHllS7Oq4rY
        aD08QthH9ldkb0yaj7/ZEUMCJcGelr4YA8xWqf91n1JIXXKA2tu6wIvLuG0vbWHFHGFhwA
        8w9MesAbeKbmItJDHPqZ6j9rZ+armNuQBp+Sz/EM6HvQeHge7FwwMJ6k82aTokbHkA1n3f
        YxOh/y8hdNrfR5P3W+rDaGr9Tl7HhKdvv2aW66c/tmekJVsJIbEhIrh8q3qcDA==
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
Subject: [RFC PATCH net-next v2 02/11] net: mdio: fwnode: remove legacy compatible checking for phy child
Date:   Thu, 31 Mar 2022 11:25:24 +0200
Message-Id: <20220331092533.348626-3-clement.leger@bootlin.com>
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

Remove legacy checking for specific phy compatibles.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index a5a6fd9ebd94..17585c5b34bb 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -176,33 +176,11 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	return 0;
 }
 
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
 /*
  * Return true if the child node is for a phy. It must either:
  * o Compatible string of "ethernet-phy-idX.X"
  * o Compatible string of "ethernet-phy-ieee802.3-c45"
  * o Compatible string of "ethernet-phy-ieee802.3-c22"
- * o In the white list above (and issue a warning)
  * o No compatibility string
  *
  * A device which is not a phy is expected to have a compatible string
@@ -221,13 +199,6 @@ bool fwnode_mdiobus_child_is_phy(struct device_node *child)
 	if (of_device_is_compatible(child, "ethernet-phy-ieee802.3-c22"))
 		return true;
 
-	if (of_match_node(whitelist_phys, child)) {
-		pr_warn(FW_WARN
-			"%pOF: Whitelisted compatible string. Please remove\n",
-			child);
-		return true;
-	}
-
 	if (!of_find_property(child, "compatible", NULL))
 		return true;
 
-- 
2.34.1

