Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2998921F3D0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgGNOWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:22:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:53222 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgGNOWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:22:18 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 9827413F695;
        Tue, 14 Jul 2020 16:22:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594736533; bh=2eEaBlQta2QnkrznkVDQHvNfEW6pZu0OBBRKGsFfQpY=;
        h=From:To:Date;
        b=aAJwng1m4nnc0QnJ9tFVfEOpjlRYdB/jUSELvoD4spvliiFrCKYMen1bWvqZDXUqx
         LDkDTEqGIrxXowlWXRRA26zM7vc7qQBVQiz8PDfEY53tNUYbuCqnbEzfTZeSZaEQGZ
         gqkMVbA6MDgLlnaqj3twfytcTGg0y1Mg3wdmzDrA=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v1 1/2] net: mdiobus: add support to access PHY registers via debugfs
Date:   Tue, 14 Jul 2020 16:22:12 +0200
Message-Id: <20200714142213.21365-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds config option CONFIG_MDIO_BUS_DEBUGFS which, when enabled,
adds support to communicate with the devices connected to the MDIO
via debugfs.

For every MDIO bus this creates directory
  /sys/kernel/debug/mdio_bus/MDIO_BUS_NAME
with files "addr", "reg" and "val".
User can write device address to the "addr" file and register number to
the "reg" file, and then can read the value of the register from the
"val" file, or can write new value by writing to the "val" file.

This is useful when debugging various PHYs or switches.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig    |  8 ++++++++
 drivers/net/phy/Makefile   |  2 ++
 drivers/net/phy/mdio_bus.c | 31 ++++++++++++++++++++++++++-----
 include/linux/phy.h        |  5 +++++
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..aca4b52225b1 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -24,6 +24,14 @@ if MDIO_BUS
 config MDIO_DEVRES
 	tristate
 
+config MDIO_BUS_DEBUGFS
+	bool "MDIO bus debugfs support"
+	depends on DEBUG_FS
+	help
+	  This adds support to communicate via the MDIO bus via files in
+	  debugfs. Note that using this on a PHY device that is being handled by
+	  a driver can break the state of the PHY.
+
 config MDIO_ASPEED
 	tristate "ASPEED MDIO bus controller"
 	depends on ARCH_ASPEED || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..4500050faf64 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -5,6 +5,8 @@ libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
 mdio-bus-y			+= mdio_bus.o mdio_device.o
 
+obj-$(CONFIG_MDIO_BUS_DEBUGFS)	+= mdio_debugfs.o
+
 ifdef CONFIG_MDIO_DEVICE
 obj-y				+= mdio-boardinfo.o
 endif
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..b31fa70dbd95 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -39,6 +39,7 @@
 #include <trace/events/mdio.h>
 
 #include "mdio-boardinfo.h"
+#include "mdio_debugfs.h"
 
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
@@ -576,6 +577,12 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		}
 	}
 
+	err = mdiobus_register_debugfs(bus);
+	if (err) {
+		dev_err(&bus->dev, "mii_bus %s couldn't create debugfs entries\n", bus->id);
+		goto error;
+	}
+
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
@@ -609,6 +616,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	BUG_ON(bus->state != MDIOBUS_REGISTERED);
 	bus->state = MDIOBUS_UNREGISTERED;
 
+	mdiobus_unregister_debugfs(bus);
+
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
 		mdiodev = bus->mdio_map[i];
 		if (!mdiodev)
@@ -1005,12 +1014,23 @@ int __init mdio_bus_init(void)
 	int ret;
 
 	ret = class_register(&mdio_bus_class);
-	if (!ret) {
-		ret = bus_register(&mdio_bus_type);
-		if (ret)
-			class_unregister(&mdio_bus_class);
-	}
+	if (ret)
+		return ret;
 
+	ret = bus_register(&mdio_bus_type);
+	if (ret)
+		goto err_class;
+
+	ret = mdiobus_debugfs_init();
+	if (ret)
+		goto err_bus;
+
+	return 0;
+
+err_bus:
+	bus_unregister(&mdio_bus_type);
+err_class:
+	class_unregister(&mdio_bus_class);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mdio_bus_init);
@@ -1018,6 +1038,7 @@ EXPORT_SYMBOL_GPL(mdio_bus_init);
 #if IS_ENABLED(CONFIG_PHYLIB)
 void mdio_bus_exit(void)
 {
+	mdiobus_debugfs_exit();
 	class_unregister(&mdio_bus_class);
 	bus_unregister(&mdio_bus_type);
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..e281099fb526 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -309,6 +309,11 @@ struct mii_bus {
 
 	/* shared state across different PHYs */
 	struct phy_package_shared *shared[PHY_MAX_ADDR];
+
+#if IS_ENABLED(CONFIG_MDIO_BUS_DEBUGFS)
+	/* address and regnum for debugfs */
+	u32 debug_addr, debug_reg;
+#endif
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
-- 
2.26.2

