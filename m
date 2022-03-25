Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5D84E7D13
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiCYTkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiCYTjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:39:10 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE121BA6AE;
        Fri, 25 Mar 2022 12:18:38 -0700 (PDT)
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B8734C1EBF;
        Fri, 25 Mar 2022 17:25:19 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7F5BAC0007;
        Fri, 25 Mar 2022 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648229039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+P/gGiENfYIPA/EqZKPnF3v0HfIcyQP5+PsKzM5cQ+w=;
        b=AipoZG39iudi8cU6BEpEiCg7RbXt40gwjsqwzIrbaQuh0IhvFSgw1oAhaTeFgnnl1hVLie
        dwRg0oyl8t9L/ky8n43KuVSj0fZ0op+OPT6oO5NbRsfa10tiyWBht+DJXFx+Of4lSvizoQ
        RLUuvXI3i+LA1VmshsSlVxNuEf5MSN+IJ6XrSNecNqfkfjQAqHPuQvaLC+dkuGmf++VU6u
        KVM8oqQCBD+VwP2aLPdyg6lAZFFXnYuaHt7+ouDqRQQES1Oi03OfJuPVLtxO6mqaNjAW7j
        ruxqlXYwZu2CIgX/Lab0zn+hoVXhtT1d+9nitmwGbiLN+c6uB7YF2PuPSz3HCA==
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
Subject: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Date:   Fri, 25 Mar 2022 18:22:30 +0100
Message-Id: <20220325172234.1259667-2-clement.leger@bootlin.com>
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
 drivers/net/mdio/fwnode_mdio.c | 210 +++++++++++++++++++++++++++++++++
 include/linux/fwnode_mdio.h    |  13 ++
 2 files changed, 223 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..f9ec3818041a 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -11,6 +11,8 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 
+#define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
+
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
@@ -142,3 +144,211 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
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
+/* Return true if the child node is for a phy. It must either:
+ * o Compatible string of "ethernet-phy-idX.X"
+ * o Compatible string of "ethernet-phy-ieee802.3-c45"
+ * o Compatible string of "ethernet-phy-ieee802.3-c22"
+ * o No compatibility string
+ *
+ * A device which is not a phy is expected to have a compatible string
+ * indicating what sort of device it is.
+ */
+bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
+{
+	u32 phy_id;
+
+	if (fwnode_get_phy_id(child, &phy_id) != -EINVAL)
+		return true;
+
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c45") >= 0)
+		return true;
+
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c22") >= 0)
+		return true;
+
+	if (is_of_node(child) &&
+	    of_match_node(whitelist_phys, to_of_node(child))) {
+		pr_warn(FW_WARN
+			"%s: Whitelisted compatible string. Please remove\n",
+			fwnode_get_name(child));
+		return true;
+	}
+
+	if (!fwnode_property_present(child, "compatible"))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_child_is_phy);
+
+static int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+					  struct fwnode_handle *child,
+					  u32 addr)
+{
+	struct mdio_device *mdiodev;
+	int rc;
+
+	mdiodev = mdio_device_create(mdio, addr);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	fwnode_handle_get(child);
+	device_set_node(&mdiodev->dev, child);
+
+	/* All data is now stored in the mdiodev struct; register it. */
+	rc = mdio_device_register(mdiodev);
+	if (rc) {
+		mdio_device_free(mdiodev);
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered mdio device %s at address %i\n",
+		fwnode_get_name(child), addr);
+	return 0;
+}
+
+static inline int fwnode_mdio_parse_addr(struct device *dev,
+					 const struct fwnode_handle *fwnode)
+{
+	u32 addr;
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", &addr);
+	if (ret < 0) {
+		dev_err(dev, "%s has invalid PHY address\n",
+			fwnode_get_name(fwnode));
+		return ret;
+	}
+
+	/* A PHY must have a reg property in the range [0-31] */
+	if (addr >= PHY_MAX_ADDR) {
+		dev_err(dev, "%s PHY address %i is too large\n",
+			fwnode_get_name(fwnode), addr);
+		return -EINVAL;
+	}
+
+	return addr;
+}
+
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *child;
+	bool scanphys = false;
+	int addr, rc;
+
+	if (!fwnode)
+		return mdiobus_register(mdio);
+
+	if (!fwnode_device_is_available(fwnode))
+		return -ENODEV;
+
+	/* Mask out all PHYs from auto probing.  Instead the PHYs listed in
+	 * the device tree are populated after the bus has been registered
+	 */
+	mdio->phy_mask = ~0;
+
+	device_set_node(&mdio->dev, fwnode);
+
+	/* Get bus level PHY reset GPIO details */
+	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
+	fwnode_property_read_u32(fwnode, "reset-delay-us",
+				 &mdio->reset_delay_us);
+	mdio->reset_post_delay_us = 0;
+	fwnode_property_read_u32(fwnode, "reset-post-delay-us",
+				 &mdio->reset_post_delay_us);
+
+	/* Register the MDIO bus */
+	rc = mdiobus_register(mdio);
+	if (rc)
+		return rc;
+
+	/* Loop over the child nodes and register a phy_device for each phy */
+	fwnode_for_each_available_child_node(fwnode, child) {
+		addr = fwnode_mdio_parse_addr(&mdio->dev, child);
+		if (addr < 0) {
+			scanphys = true;
+			continue;
+		}
+
+		if (fwnode_mdiobus_child_is_phy(child))
+			rc = fwnode_mdiobus_register_phy(mdio, child, addr);
+		else
+			rc = fwnode_mdiobus_register_device(mdio, child, addr);
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
+	fwnode_for_each_available_child_node(fwnode, child) {
+		/* Skip PHYs with reg property set */
+		if (fwnode_property_present(child, "reg"))
+			continue;
+
+		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+			/* skip already registered PHYs */
+			if (mdiobus_is_registered_device(mdio, addr))
+				continue;
+
+			/* be noisy to encourage people to set reg property */
+			dev_info(&mdio->dev, "scan phy %s at address %i\n",
+				 fwnode_get_name(child), addr);
+
+			if (fwnode_mdiobus_child_is_phy(child)) {
+				/* -ENODEV is the return code that PHYLIB has
+				 * standardized on to indicate that bus
+				 * scanning should continue.
+				 */
+				rc = fwnode_mdiobus_register_phy(mdio, child,
+								 addr);
+				if (!rc)
+					break;
+				if (rc != -ENODEV)
+					goto unregister;
+			}
+		}
+	}
+
+unregister:
+	mdiobus_unregister(mdio);
+	return rc;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index faf603c48c86..ca380050056d 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -9,6 +9,7 @@
 #include <linux/phy.h>
 
 #if IS_ENABLED(CONFIG_FWNODE_MDIO)
+bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child);
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr);
@@ -16,7 +17,13 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
+static inline bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
+{
+	return false;
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -30,6 +37,12 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
+
+static int fwnode_mdiobus_register(struct mii_bus *mdio,
+				   struct fwnode_handle *fwnode)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.34.1

