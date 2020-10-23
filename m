Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6643A29760C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753790AbgJWRsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 13:48:11 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38558 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465725AbgJWRsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 13:48:11 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09NHlsAs123990;
        Fri, 23 Oct 2020 12:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603475274;
        bh=0W6J4nM1FKoWLcVbIteqqrnPO2KFBpQgLTSA/DQ/s6E=;
        h=From:To:CC:Subject:Date;
        b=uF5sAbHXxd9RFJZ1y3g/GDlEDz/29E4evmqKBGNdVcdAnJP1VauyFiwKGCp3BDU4w
         ZUz99r2KZ/GZn4ITNJjvyleiU6kIdrH6kaitF8VjRwOt5/jhe6VIW0ePSyR9mSyic7
         ccuuz4rjgFb3FJdIBAlYcB3mkYpmxLdQxMP0yUH0=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09NHlsxE120225
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 12:47:54 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 23
 Oct 2020 12:47:54 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 23 Oct 2020 12:47:53 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09NHlq6E081358;
        Fri, 23 Oct 2020 12:47:53 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] RFC: net: phy: of phys probe/reset issue
Date:   Fri, 23 Oct 2020 20:47:50 +0300
Message-ID: <20201023174750.21356-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

The main intention of this mail is to trigger discussion to find a proper
solution. All code is hackish and based on v5.9.

Problem statement:

There is an issue observed with MDIO OF PHYs discover/reset sequence in
case PHY has reset line with default state is (1).
In this case, when Linux boots PHY is in reset and following code fails:

of_mdiobus_register()
|- for_each_available_child_of_node(np, child)
   |- of_mdiobus_register_phy
      |- get_phy_device
         |- get_phy_c22_id ---- > *fails as PHY is in reset*
      ...
      |- of_mdiobus_phy_device_register() --> can't be reached

The current PHY allows to specify PHY reset line for PHY:
&mdio {
        phy0: ethernet-phy@0 {
                reg = <0>;
                ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
                ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
+               reset-gpios = <&pca9555 4 GPIO_ACTIVE_LOW>;
                ti,dp83867-rxctrl-strap-quirk;
        };
 };

But it doesn't help in this case, as PHY's reset code is initialized when
PHY's mdio_device is registered, which, in turn, happens after
get_phy_device() call (and get_phy_device() is failed).

of_mdiobus_phy_device_register()
 |-phy_device_register
   |-mdiobus_register_device()
     |-mdiobus_register_gpiod(mdiodev);
     |-mdiobus_register_reset(mdiodev);

There is also possibility to add GPIO reset line to MDIO node itself, but
It also doesn't help when there are >1 PHY and every PHY has it own reset
line.

Only one possible W/A now is to use GPIO HOG, with drawback that PHY will
stay active always.

Some history:

- commit 69226896ad63 ("mdio_bus: Issue GPIO RESET to PHYs") from Roger
Quadros <rogerq@ti.com> originally added possibility to specify >1 GPIO
reset line in MDIO node, which allowed to solve such issues.
 - commit 4c5e7a2c0501 ("dt-bindings: mdio: Clarify binding document") and
follow up commit d396e84c5604 ("mdio_bus: handle only single PHY reset
GPIO") rolled back original solution to only one GPIO reset line, which
causes problems now.

Possible solutions I come up with:
 1) Try to add PHY reset code around get_phy_device() call in of_mdiobus_register_phy()
  cons:
   - need to extract/share mdio_device reset code as PHY may have not only GPIO,
     but also reset_control object assigned.
     And all current mdio_device rest code expected to have mdio_device already initialized.
   - There 12 calls to get_phy_device() in v5.9 Kernel
 2) Try to consolidate OF mdio_device/PHY initialization in one place, as
illustrated by of_phy_device_create() function (marked by "// option 2" in
code).
 3) Return back possibility to use >1 GPIO reset line in MDIO node. Even if
It seems right thing to do by itself (Devices attached to MDIO bus may have
any combination of shared reset lines - not always "one for all"), there
are more things to consider:
   - PHY reset_control objects handling
   - the fact that MDIO reset will put PHY out of reset and not allow to
     reset it again (more like gpio-hog)

I'd be appreciated for any comments to help resolve it. May be there is
better way to handle this?

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/phy_device.c | 152 +++++++++++++++++++++++++++++++++++
 drivers/of/of_mdio.c         |  35 +++++++-
 include/linux/phy.h          |   3 +
 3 files changed, 186 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..9b22e7c1c4a1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -23,6 +23,8 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of_irq.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/property.h>
@@ -3019,6 +3021,156 @@ void phy_drivers_unregister(struct phy_driver *drv, int n)
 }
 EXPORT_SYMBOL(phy_drivers_unregister);
 
+struct phy_device *
+of_phy_device_create(struct mii_bus *bus, struct device_node *child, int addr,
+		     u32 phy_id, bool is_c45)
+{
+	struct phy_c45_device_ids c45_ids;
+	struct phy_device *dev;
+	struct mdio_device *mdiodev;
+	int ret = 0;
+	int rc;
+
+	/* We allocate the device, and initialize the default values */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	mdiodev = &dev->mdio;
+	mdiodev->dev.parent = &bus->dev;
+	mdiodev->dev.bus = &mdio_bus_type;
+	mdiodev->dev.type = &mdio_bus_phy_type;
+	mdiodev->bus = bus;
+	mdiodev->bus_match = phy_bus_match;
+	mdiodev->addr = addr;
+	mdiodev->flags = MDIO_DEVICE_FLAG_PHY;
+	mdiodev->device_free = phy_mdio_device_free;
+	mdiodev->device_remove = phy_mdio_device_remove;
+
+	/* Associate the OF node with the device structure so it
+	 * can be looked up later
+	 */
+	of_node_get(child);
+	mdiodev->dev.of_node = child;
+	mdiodev->dev.fwnode = of_fwnode_handle(child);
+
+	rc = of_irq_get(child, 0);
+	if (rc == -EPROBE_DEFER)
+		return ERR_PTR(rc);
+
+	if (rc > 0) {
+		dev->irq = rc;
+		bus->irq[addr] = rc;
+	} else {
+		dev->irq = bus->irq[addr];
+	}
+
+	if (of_property_read_bool(child, "broken-turn-around"))
+		bus->phy_ignore_ta_mask |= 1 << addr;
+	of_property_read_u32(child, "reset-assert-us",
+			     &mdiodev->reset_assert_delay);
+	of_property_read_u32(child, "reset-deassert-us",
+			     &mdiodev->reset_deassert_delay);
+
+	dev->speed = SPEED_UNKNOWN;
+	dev->duplex = DUPLEX_UNKNOWN;
+	dev->pause = 0;
+	dev->asym_pause = 0;
+	dev->link = 0;
+	dev->interface = PHY_INTERFACE_MODE_GMII;
+	dev->autoneg = AUTONEG_ENABLE;
+	dev->is_c45 = is_c45;
+
+	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
+	device_initialize(&mdiodev->dev);
+
+	dev->state = PHY_DOWN;
+
+	mutex_init(&dev->lock);
+	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
+
+	ret = mdiobus_register_device(mdiodev);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Deassert the reset signal */
+	phy_device_reset(dev, 0);
+
+	if (phy_id == U32_MAX) {
+		phy_id = 0;
+
+		c45_ids.devices_in_package = 0;
+		c45_ids.mmds_present = 0;
+		memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
+
+		if (is_c45)
+			ret = get_phy_c45_ids(bus, addr, &c45_ids);
+		else
+			ret = get_phy_c22_id(bus, addr, &phy_id);
+
+		if (ret)
+			goto err_out;
+
+		dev->phy_id = phy_id;
+		dev->c45_ids = c45_ids;
+	} else {
+		dev->phy_id = phy_id;
+	}
+
+	/* Run all of the fixups for this PHY */
+	ret = phy_scan_fixups(dev);
+	if (ret) {
+		phydev_err(dev, "failed to initialize\n");
+		goto err_out;
+	}
+
+	/* Request the appropriate module unconditionally; don't
+	 * bother trying to do so only if it isn't already loaded,
+	 * because that gets complicated. A hotplug event would have
+	 * done an unconditional modprobe anyway.
+	 * We don't do normal hotplug because it won't work for MDIO
+	 * -- because it relies on the device staying around for long
+	 * enough for the driver to get loaded. With MDIO, the NIC
+	 * driver will get bored and give up as soon as it finds that
+	 * there's no driver _already_ loaded.
+	 */
+	if (is_c45) {
+		const int num_ids = ARRAY_SIZE(c45_ids.device_ids);
+		int i;
+
+		for (i = 1; i < num_ids; i++) {
+			if (c45_ids.device_ids[i] == 0xffffffff)
+				continue;
+
+			ret = phy_request_driver_module(dev,
+							c45_ids.device_ids[i]);
+			if (ret)
+				break;
+		}
+	} else {
+		ret = phy_request_driver_module(dev, phy_id);
+	}
+
+	if (ret)
+		goto err_out;
+
+	ret = device_add(&mdiodev->dev);
+	if (ret) {
+		phydev_err(dev, "failed to add\n");
+		goto err_out;
+	}
+
+	return dev;
+
+err_out:
+	/* Assert the reset signal */
+	phy_device_reset(dev, 1);
+
+	mdiobus_unregister_device(mdiodev);
+	put_device(&mdiodev->dev);
+	return  ERR_PTR(ret);
+}
+
 static struct phy_driver genphy_driver = {
 	.phy_id		= 0xffffffff,
 	.phy_id_mask	= 0xffffffff,
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 4daf94bb56a5..26783a9193da 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/gpio/consumer.h>
 #include <linux/netdevice.h>
 #include <linux/err.h>
 #include <linux/phy.h>
@@ -105,7 +106,7 @@ int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
-				    struct device_node *child, u32 addr)
+				   struct device_node *child, u32 addr)
 {
 	struct mii_timestamper *mii_ts;
 	struct phy_device *phy;
@@ -120,16 +121,42 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
+	if (!is_c45 && !of_get_phy_id(child, &phy_id)) {
+		phy = of_phy_device_create(mdio, child, addr, phy_id, 0);
+	} else {
+		struct gpio_desc *reset_gpio;
+		unsigned int reset_assert_delay = DEFAULT_GPIO_RESET_DELAY;
+		unsigned int reset_deassert_delay = DEFAULT_GPIO_RESET_DELAY;
+
+		reset_gpio = gpiod_get_from_of_node(child, "reset-gpios", 0,
+						    GPIOD_OUT_LOW,  "PHY reset");
+		if (IS_ERR(reset_gpio)) {
+			if (PTR_ERR(reset_gpio) == -ENOENT)
+				reset_gpio = NULL;
+			else
+				return PTR_ERR(reset_gpio);
+		}
+
+		if (reset_gpio) {
+			gpiod_set_value_cansleep(reset_gpio, 1);
+			fsleep(reset_assert_delay);
+			gpiod_set_value_cansleep(reset_gpio, 0);
+			fsleep(reset_deassert_delay);
+			pr_err("========== reset PHY\n");
+		}
+// option 2
+//		phy = of_phy_device_create(mdio, child, addr, U32_MAX, is_c45);
 		phy = get_phy_device(mdio, addr, is_c45);
+
+		gpiod_put(reset_gpio);
+	}
 	if (IS_ERR(phy)) {
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
 	}
 
+// option 2 - remove
 	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
 	if (rc) {
 		if (mii_ts)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..3e5efb120cad 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1753,4 +1753,7 @@ module_exit(phy_module_exit)
 bool phy_driver_is_genphy(struct phy_device *phydev);
 bool phy_driver_is_genphy_10g(struct phy_device *phydev);
 
+struct phy_device *of_phy_device_create(struct mii_bus *bus, struct device_node *child,
+					int addr, u32 phy_id, bool is_c45);
+
 #endif /* __PHY_H */
-- 
2.17.1

