Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2663836B402
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhDZNUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhDZNUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:20:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEB7C061760
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:19:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18s-0004Ue-CI; Mon, 26 Apr 2021 15:19:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18r-0006nL-G9; Mon, 26 Apr 2021 15:19:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v7 8/9] net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
Date:   Mon, 26 Apr 2021 15:19:10 +0200
Message-Id: <20210426131911.25976-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210426131911.25976-1-o.rempel@pengutronix.de>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
switches using the Microchip SMI Interface. They are supported using the
MDIO-Bitbang Interface.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---
v1 -> v2:  - this code was part of previuos patch
v2 -> v3:  - this code was part of previuos patch
v3 -> v4:  - moved this glue code so separate patch
           - fixed locking in regmap and mdio_read/mdio_write
v4 -> v5:  - removed extra default y in Kconfig
           - fixed capitalization in Kconfig description
	   - removed unnecessary cast
	   - added back the define for READ operation
	   - added KSZ88x3 to help text for KSZ8795 Kconfig entry
---
 drivers/net/dsa/microchip/Kconfig       |  10 +-
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz8863_smi.c | 213 ++++++++++++++++++++++++
 3 files changed, 223 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 4ec6a47b7f72..c9e2a8989556 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -29,7 +29,7 @@ menuconfig NET_DSA_MICROCHIP_KSZ8795
 	depends on NET_DSA
 	select NET_DSA_MICROCHIP_KSZ_COMMON
 	help
-	  This driver adds support for Microchip KSZ8795 switch chips.
+	  This driver adds support for Microchip KSZ8795/KSZ88X3 switch chips.
 
 config NET_DSA_MICROCHIP_KSZ8795_SPI
 	tristate "KSZ8795 series SPI connected switch driver"
@@ -40,3 +40,11 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
 
 	  It is required to use the KSZ8795 switch driver as the only access
 	  is through SPI.
+
+config NET_DSA_MICROCHIP_KSZ8863_SMI
+	tristate "KSZ series SMI connected switch driver"
+	depends on NET_DSA_MICROCHIP_KSZ8795
+	select MDIO_BITBANG
+	help
+	  Select to enable support for registering switches configured through
+	  Microchip SMI. It supports the KSZ8863 and KSZ8873 switch.
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 929caa81e782..2a03b21a3386 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
new file mode 100644
index 000000000000..30d97ea7a949
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip KSZ8863 series register access through SMI
+ *
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#include "ksz8.h"
+#include "ksz_common.h"
+
+/* Serial Management Interface (SMI) uses the following frame format:
+ *
+ *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
+ *               |frame| OP code  |address |address|  |                  |
+ * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
+ * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
+ *
+ */
+
+#define SMI_KSZ88XX_READ_PHY	BIT(4)
+
+static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
+			     void *val_buf, size_t val_len)
+{
+	struct ksz_device *dev = ctx;
+	struct mdio_device *mdev;
+	u8 reg = *(u8 *)reg_buf;
+	u8 *val = val_buf;
+	struct ksz8 *ksz8;
+	int i, ret = 0;
+
+	ksz8 = dev->priv;
+	mdev = ksz8->priv;
+
+	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	for (i = 0; i < val_len; i++) {
+		int tmp = reg + i;
+
+		ret = __mdiobus_read(mdev->bus, ((tmp & 0xE0) >> 5) |
+				     SMI_KSZ88XX_READ_PHY, tmp);
+		if (ret < 0)
+			goto out;
+
+		val[i] = ret;
+	}
+	ret = 0;
+
+ out:
+	mutex_unlock(&mdev->bus->mdio_lock);
+
+	return ret;
+}
+
+static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
+{
+	struct ksz_device *dev = ctx;
+	struct mdio_device *mdev;
+	struct ksz8 *ksz8;
+	int i, ret = 0;
+	u32 reg;
+	u8 *val;
+
+	ksz8 = dev->priv;
+	mdev = ksz8->priv;
+
+	val = (u8 *)(data + 4);
+	reg = *(u32 *)data;
+
+	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	for (i = 0; i < (count - 4); i++) {
+		int tmp = reg + i;
+
+		ret = __mdiobus_write(mdev->bus, ((tmp & 0xE0) >> 5),
+				      tmp, val[i]);
+		if (ret < 0)
+			goto out;
+	}
+
+ out:
+	mutex_unlock(&mdev->bus->mdio_lock);
+
+	return ret;
+}
+
+static const struct regmap_bus regmap_smi[] = {
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.max_raw_read = 1,
+		.max_raw_write = 1,
+	},
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.val_format_endian_default = REGMAP_ENDIAN_BIG,
+		.max_raw_read = 2,
+		.max_raw_write = 2,
+	},
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.val_format_endian_default = REGMAP_ENDIAN_BIG,
+		.max_raw_read = 4,
+		.max_raw_write = 4,
+	}
+};
+
+static const struct regmap_config ksz8863_regmap_config[] = {
+	{
+		.name = "#8",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 8,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+		.lock = ksz_regmap_lock,
+		.unlock = ksz_regmap_unlock,
+	},
+	{
+		.name = "#16",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 16,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+		.lock = ksz_regmap_lock,
+		.unlock = ksz_regmap_unlock,
+	},
+	{
+		.name = "#32",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 32,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+		.lock = ksz_regmap_lock,
+		.unlock = ksz_regmap_unlock,
+	}
+};
+
+static int ksz8863_smi_probe(struct mdio_device *mdiodev)
+{
+	struct regmap_config rc;
+	struct ksz_device *dev;
+	struct ksz8 *ksz8;
+	int ret;
+	int i;
+
+	ksz8 = devm_kzalloc(&mdiodev->dev, sizeof(struct ksz8), GFP_KERNEL);
+	ksz8->priv = mdiodev;
+
+	dev = ksz_switch_alloc(&mdiodev->dev, ksz8);
+	if (!dev)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ksz8863_regmap_config); i++) {
+		rc = ksz8863_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init(&mdiodev->dev,
+						  &regmap_smi[i], dev,
+						  &rc);
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&mdiodev->dev,
+				"Failed to initialize regmap%i: %d\n",
+				ksz8863_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
+	if (mdiodev->dev.platform_data)
+		dev->pdata = mdiodev->dev.platform_data;
+
+	ret = ksz8_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	dev_set_drvdata(&mdiodev->dev, dev);
+
+	return 0;
+}
+
+static void ksz8863_smi_remove(struct mdio_device *mdiodev)
+{
+	struct ksz_device *dev = dev_get_drvdata(&mdiodev->dev);
+
+	if (dev)
+		ksz_switch_remove(dev);
+}
+
+static const struct of_device_id ksz8863_dt_ids[] = {
+	{ .compatible = "microchip,ksz8863" },
+	{ .compatible = "microchip,ksz8873" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ksz8863_dt_ids);
+
+static struct mdio_driver ksz8863_driver = {
+	.probe	= ksz8863_smi_probe,
+	.remove	= ksz8863_smi_remove,
+	.mdiodrv.driver = {
+		.name	= "ksz8863-switch",
+		.of_match_table = ksz8863_dt_ids,
+	},
+};
+
+mdio_module_driver(ksz8863_driver);
+
+MODULE_AUTHOR("Michael Grzeschik <m.grzeschik@pengutronix.de>");
+MODULE_DESCRIPTION("Microchip KSZ8863 SMI Switch driver");
+MODULE_LICENSE("GPL v2");
-- 
2.29.2

