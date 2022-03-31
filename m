Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244F54ED6CA
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiCaJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiCaJ25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:57 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA621FDFEC;
        Thu, 31 Mar 2022 02:27:08 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 05909E001B;
        Thu, 31 Mar 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAGZigtkZzL3mxPDdsEnCyO5sPgES6vv2TqNmxRAREg=;
        b=UzE5Z7JCUE/E3r0ifA8zH7H+aQnHw9ve95hqnKOgLXHMkNpe2gzQCdcNqi6ed0YeTw4llH
        Mb6TNjnh7qfna9hDfMuyJ0toEk5Uz47z5W7G/QTHI2abB77Jk3xpoB+nGA5ZIY7Kk/V+Av
        vGVrDtAdKfOvfi1nrFEmumLHNGr/2qCsM3EITT3eq+NX7NmDkqYNL6z7ufXzdrRspdyEAg
        wUNwN8xU8QvsMnnv5KWRWDY8XLZANPCWwG9igmF3P4S98ZpzqaU40AEligOiAiax72SGFW
        vqgVW9vbqHvuqtIEthh7xf5xRgxoxTIrVYSDBXTc4cKXN3wGemPT8CVAyKFlCg==
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
Subject: [RFC PATCH net-next v2 05/11] net: mdio: fwnode: add fwnode_mdiobus_register()
Date:   Thu, 31 Mar 2022 11:25:27 +0200
Message-Id: <20220331092533.348626-6-clement.leger@bootlin.com>
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

In order to support software node description transparently, add fwnode
support with fwnode_mdiobus_register(). This function behaves exactly
like of_mdiobus_register() function but using the fwnode node agnostic
API. This support might also be used to merge ACPI mdiobus support
which is quite similar to the fwnode one.

Some part such as the whitelist matching are kept exclusively for OF
nodes since it uses an of_device_id struct and seems tightly coupled
with OF. Other parts are generic and will allow to move the existing
OF support on top of this fwnode version.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 include/linux/fwnode_mdio.h | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index faf603c48c86..cc50a0833a43 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -9,6 +9,9 @@
 #include <linux/phy.h>
 
 #if IS_ENABLED(CONFIG_FWNODE_MDIO)
+int fwnode_mdio_parse_addr(struct device *dev,
+			   const struct fwnode_handle *fwnode);
+bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child);
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr);
@@ -16,10 +19,23 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
-int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-				       struct phy_device *phy,
-				       struct fwnode_handle *child, u32 addr)
+
+static inline int fwnode_mdio_parse_addr(struct device *dev,
+					 const struct fwnode_handle *fwnode)
+{
+	return -EINVAL;
+}
+
+static inline bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
+{
+	return false;
+}
+
+static inline int
+fwnode_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
+				   struct fwnode_handle *child, u32 addr)
 {
 	return -EINVAL;
 }
@@ -30,6 +46,12 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
+
+static inline int fwnode_mdiobus_register(struct mii_bus *mdio,
+					  struct fwnode_handle *fwnode)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.34.1

