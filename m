Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD574ED6C6
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiCaJ3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiCaJ25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:57 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09331FDFFA;
        Thu, 31 Mar 2022 02:27:09 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 19EC3E0004;
        Thu, 31 Mar 2022 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/U4ywy2HHlrXB5mkjwH0y2BuGQP4lKAiCmY1p7B8gk4=;
        b=j2twj0+ThaBbKyaGJJifzdDEBKrLwMnTa+omXGQgZVfvZ8LkJjvJdA59TAZq+6ILjxzwCS
        FzIEh0/OMQxHOiQxwt9/wumisvXwivDklpWIsnKuHaa7Z6MmDVNxSJHbtcvcTSO3nk4dna
        sl30G5tEee4jV5Ev1Y0fiCcTpZjR45ZB2zWgGRayy+D/kaLch/odoSKVGnl9skBVivyMZ8
        HMQQBsTlJVoQvBHnaJxlQnhyuJEzZ7DQQ4Icv+2y/cOzk9YzuHtJqIt0iT1WowD36V+QKm
        MS6ikvXkZJFpOm1HRRYBBvsbfsVMSfKSl3i0Mgljy8oEuL/RhQjKpLzrCrJ7SQ==
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
Subject: [RFC PATCH net-next v2 06/11] net: mdio: of: wrap fwnode_mdio_parse_addr() in of_mdio_parse_addr()
Date:   Thu, 31 Mar 2022 11:25:28 +0200
Message-Id: <20220331092533.348626-7-clement.leger@bootlin.com>
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

Since function fwnode_mdio_parse_addr() returns the same value that is
done by of_mdio_parse_addr() and has the same behavior, wrap the first
one. The function was switched as non static in of_mdio.c to avoid
including fwnode_mdio.h in of_mdio.h.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/of_mdio.c |  6 ++++++
 include/linux/of_mdio.h    | 23 +----------------------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..b8fc1245048e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -26,6 +26,12 @@
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_LICENSE("GPL");
 
+int of_mdio_parse_addr(struct device *dev, const struct device_node *np)
+{
+	return fwnode_mdio_parse_addr(dev, of_fwnode_handle(np));
+}
+EXPORT_SYMBOL(of_mdio_parse_addr);
+
 /* Extract the clause 22 phy ID from the compatible string of the form
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index da633d34ab86..1de67a1e5cd7 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -33,28 +33,7 @@ void of_phy_deregister_fixed_link(struct device_node *np);
 bool of_phy_is_fixed_link(struct device_node *np);
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr);
-
-static inline int of_mdio_parse_addr(struct device *dev,
-				     const struct device_node *np)
-{
-	u32 addr;
-	int ret;
-
-	ret = of_property_read_u32(np, "reg", &addr);
-	if (ret < 0) {
-		dev_err(dev, "%s has invalid PHY address\n", np->full_name);
-		return ret;
-	}
-
-	/* A PHY must have a reg property in the range [0-31] */
-	if (addr >= PHY_MAX_ADDR) {
-		dev_err(dev, "%s PHY address %i is too large\n",
-			np->full_name, addr);
-		return -EINVAL;
-	}
-
-	return addr;
-}
+int of_mdio_parse_addr(struct device *dev, const struct device_node *np);
 
 #else /* CONFIG_OF_MDIO */
 static inline bool of_mdiobus_child_is_phy(struct device_node *child)
-- 
2.34.1

