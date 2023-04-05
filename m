Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEC26D7828
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbjDEJ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbjDEJ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA55277
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:41 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQA-0004pA-0y; Wed, 05 Apr 2023 11:27:14 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:27:02 +0200
Subject: [PATCH 11/12] net: mdiobus: remove now unused fwnode helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-11-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These APIs are broken since the very first day because they assume that
the phy is accessible to read the PHYID registers. If this requirement
is not meet the code fails to add the required phys.

The newly added phy_device_atomic_register() API have fixed this and
supports firmware parsing as well. After we switched all in kernel users
of the fwnode API we now can remove this part from the kernel.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 MAINTAINERS                    |   1 -
 drivers/net/mdio/Kconfig       |   7 --
 drivers/net/mdio/Makefile      |   1 -
 drivers/net/mdio/acpi_mdio.c   |   2 +-
 drivers/net/mdio/fwnode_mdio.c | 186 -----------------------------------------
 drivers/net/mdio/of_mdio.c     |   1 -
 include/linux/fwnode_mdio.h    |  35 --------
 7 files changed, 1 insertion(+), 232 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7812f0e251ad..2894b456c0a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7666,7 +7666,6 @@ F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
 F:	drivers/net/mdio/acpi_mdio.c
-F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 90309980686e..d0d19666f099 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -19,13 +19,6 @@ config MDIO_BUS
 	  reflects whether the mdio_bus/mdio_device code is built as a
 	  loadable module or built-in.
 
-config FWNODE_MDIO
-	def_tristate PHYLIB
-	depends on (ACPI || OF) || COMPILE_TEST
-	select FIXED_PHY
-	help
-	  FWNODE MDIO bus (Ethernet PHY) accessors
-
 config OF_MDIO
 	def_tristate PHYLIB
 	depends on OF
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 7d4cb4c11e4e..798ede184766 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -2,7 +2,6 @@
 # Makefile for Linux MDIO bus drivers
 
 obj-$(CONFIG_ACPI_MDIO)		+= acpi_mdio.o
-obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
 obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
 
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index 25feb571bd1f..727b83bf3a15 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -10,8 +10,8 @@
 #include <linux/acpi_mdio.h>
 #include <linux/bits.h>
 #include <linux/dev_printk.h>
-#include <linux/fwnode_mdio.h>
 #include <linux/module.h>
+#include <linux/phy.h>
 #include <linux/types.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
deleted file mode 100644
index 47ef702d4ffd..000000000000
--- a/drivers/net/mdio/fwnode_mdio.c
+++ /dev/null
@@ -1,186 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * fwnode helpers for the MDIO (Ethernet PHY) API
- *
- * This file provides helper functions for extracting PHY device information
- * out of the fwnode and using it to populate an mii_bus.
- */
-
-#include <linux/acpi.h>
-#include <linux/fwnode_mdio.h>
-#include <linux/of.h>
-#include <linux/phy.h>
-#include <linux/pse-pd/pse.h>
-
-MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
-MODULE_LICENSE("GPL");
-
-static struct pse_control *
-fwnode_find_pse_control(struct fwnode_handle *fwnode)
-{
-	struct pse_control *psec;
-	struct device_node *np;
-
-	if (!IS_ENABLED(CONFIG_PSE_CONTROLLER))
-		return NULL;
-
-	np = to_of_node(fwnode);
-	if (!np)
-		return NULL;
-
-	psec = of_pse_control_get(np);
-	if (PTR_ERR(psec) == -ENOENT)
-		return NULL;
-
-	return psec;
-}
-
-static struct mii_timestamper *
-fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
-{
-	struct of_phandle_args arg;
-	int err;
-
-	if (is_acpi_node(fwnode))
-		return NULL;
-
-	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode),
-					       "timestamper", 1, 0, &arg);
-	if (err == -ENOENT)
-		return NULL;
-	else if (err)
-		return ERR_PTR(err);
-
-	if (arg.args_count != 1)
-		return ERR_PTR(-EINVAL);
-
-	return register_mii_timestamper(arg.np, arg.args[0]);
-}
-
-int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-				       struct phy_device *phy,
-				       struct fwnode_handle *child, u32 addr)
-{
-	int rc;
-
-	rc = fwnode_irq_get(child, 0);
-	/* Don't wait forever if the IRQ provider doesn't become available,
-	 * just fall back to poll mode
-	 */
-	if (rc == -EPROBE_DEFER)
-		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
-	if (rc == -EPROBE_DEFER)
-		return rc;
-
-	if (rc > 0) {
-		phy->irq = rc;
-		mdio->irq[addr] = rc;
-	} else {
-		phy->irq = mdio->irq[addr];
-	}
-
-	if (fwnode_property_read_bool(child, "broken-turn-around"))
-		mdio->phy_ignore_ta_mask |= 1 << addr;
-
-	fwnode_property_read_u32(child, "reset-assert-us",
-				 &phy->mdio.reset_assert_delay);
-	fwnode_property_read_u32(child, "reset-deassert-us",
-				 &phy->mdio.reset_deassert_delay);
-
-	/* Associate the fwnode with the device structure so it
-	 * can be looked up later
-	 */
-	fwnode_handle_get(child);
-	device_set_node(&phy->mdio.dev, child);
-
-	/* All data is now stored in the phy struct;
-	 * register it
-	 */
-	rc = phy_device_register(phy);
-	if (rc) {
-		device_set_node(&phy->mdio.dev, NULL);
-		fwnode_handle_put(child);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered phy %p fwnode at address %i\n",
-		child, addr);
-	return 0;
-}
-EXPORT_SYMBOL(fwnode_mdiobus_phy_device_register);
-
-int fwnode_mdiobus_register_phy(struct mii_bus *bus,
-				struct fwnode_handle *child, u32 addr)
-{
-	struct phy_device_config config = {
-		.mii_bus = bus,
-		.phy_addr = addr,
-	};
-	struct mii_timestamper *mii_ts = NULL;
-	struct pse_control *psec = NULL;
-	struct phy_device *phy;
-	u32 phy_id;
-	int rc;
-
-	psec = fwnode_find_pse_control(child);
-	if (IS_ERR(psec))
-		return PTR_ERR(psec);
-
-	mii_ts = fwnode_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts)) {
-		rc = PTR_ERR(mii_ts);
-		goto clean_pse;
-	}
-
-	config.is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
-	if (config.is_c45 || fwnode_get_phy_id(child, &config.phy_id))
-		phy = get_phy_device(&config);
-	else
-		phy = phy_device_create(&config);
-	if (IS_ERR(phy)) {
-		rc = PTR_ERR(phy);
-		goto clean_mii_ts;
-	}
-
-	if (is_acpi_node(child)) {
-		phy->irq = bus->irq[addr];
-
-		/* Associate the fwnode with the device structure so it
-		 * can be looked up later.
-		 */
-		phy->mdio.dev.fwnode = fwnode_handle_get(child);
-
-		/* All data is now stored in the phy struct, so register it */
-		rc = phy_device_register(phy);
-		if (rc) {
-			phy->mdio.dev.fwnode = NULL;
-			fwnode_handle_put(child);
-			goto clean_phy;
-		}
-	} else if (is_of_node(child)) {
-		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
-		if (rc)
-			goto clean_phy;
-	}
-
-	phy->psec = psec;
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
-
-clean_phy:
-	phy_device_free(phy);
-clean_mii_ts:
-	unregister_mii_timestamper(mii_ts);
-clean_pse:
-	pse_control_put(psec);
-
-	return rc;
-}
-EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index e85be8a72978..15ae968ef186 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -10,7 +10,6 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/fwnode_mdio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
deleted file mode 100644
index faf603c48c86..000000000000
--- a/include/linux/fwnode_mdio.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * FWNODE helper for the MDIO (Ethernet PHY) API
- */
-
-#ifndef __LINUX_FWNODE_MDIO_H
-#define __LINUX_FWNODE_MDIO_H
-
-#include <linux/phy.h>
-
-#if IS_ENABLED(CONFIG_FWNODE_MDIO)
-int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-				       struct phy_device *phy,
-				       struct fwnode_handle *child, u32 addr);
-
-int fwnode_mdiobus_register_phy(struct mii_bus *bus,
-				struct fwnode_handle *child, u32 addr);
-
-#else /* CONFIG_FWNODE_MDIO */
-int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-				       struct phy_device *phy,
-				       struct fwnode_handle *child, u32 addr)
-{
-	return -EINVAL;
-}
-
-static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
-					      struct fwnode_handle *child,
-					      u32 addr)
-{
-	return -EINVAL;
-}
-#endif
-
-#endif /* __LINUX_FWNODE_MDIO_H */

-- 
2.39.2

