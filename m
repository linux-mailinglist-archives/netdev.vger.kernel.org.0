Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFF358EE6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhDHVBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:01:25 -0400
Received: from polaris.svanheule.net ([84.16.241.116]:60006 "EHLO
        polaris.svanheule.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhDHVBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:01:19 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2021 17:01:18 EDT
Received: from terra.local.svanheule.net (unknown [IPv6:2a02:a03f:eaff:9f01:6fea:16c6:2e86:c69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id BC20C1ECD3B;
        Thu,  8 Apr 2021 22:52:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1617915166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SS9GaPRDuLhxXWnxoBHuqXWDVS6xyMYDV/rd7M8lMyM=;
        b=N8xKJaf/nq2mBBZDefGV9nCV7IGC5LCG0wAvz2wWTQp8UM72wzWxkj4s9En51xwM2Uv0xX
        xl09qVDDZKIk5KgqZY7FSck3SUUVNbfXH/xs+wHrv5OyiGsFaK1UZ42kCubwmlNrTVbc/w
        r2CNP+urqc+hAMLyLDGLmC1+LDOWlOEqVw4QLpai0LEsFWX39S0yE6aV+IKHVuZAlxqULk
        FscRlYGj7mshxHbbpTn4RfEk1gNxDT33oXla5CG1Qas33mEirnEj0gBNRHcK/0EfJFYZHd
        A1JYlMRBO0OYY8mnE1x5Ax3L9tH509VdKgNcKQMA+p+2oPGwJEM2LL971CQuGw==
From:   Sander Vanheule <sander@svanheule.net>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     bert@biot.com, Sander Vanheule <sander@svanheule.net>
Subject: [RFC PATCH 2/2] gpio: Add Realtek RTL8231 support
Date:   Thu,  8 Apr 2021 22:52:35 +0200
Message-Id: <f774e1cf03590e243728812242970b291debca1a.1617914861.git.sander@svanheule.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617914861.git.sander@svanheule.net>
References: <cover.1617914861.git.sander@svanheule.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8231 GPIO and LED expander chip can be controlled via a MIIM or
I2C bus. A regmap interface is used to allow for portable code.

This patch only provides GPIO support, since this is the only known use,
as found on commercial devices.

Signed-off-by: Sander Vanheule <sander@svanheule.net>
---
 drivers/gpio/Kconfig        |   9 +
 drivers/gpio/Makefile       |   1 +
 drivers/gpio/gpio-rtl8231.c | 404 ++++++++++++++++++++++++++++++++++++
 3 files changed, 414 insertions(+)
 create mode 100644 drivers/gpio/gpio-rtl8231.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 20cc0012a5ef..982c87855510 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -521,6 +521,15 @@ config GPIO_REG
 	  A 32-bit single register GPIO fixed in/out implementation.  This
 	  can be used to represent any register as a set of GPIO signals.
 
+config GPIO_RTL8231
+	tristate "Realtek RTL8231 GPIO expander"
+	select REGMAP_I2C
+	select REGMAP_MIIM
+	select OF_MDIO
+	help
+	  RTL8231 GPIO and LED expander support.
+	  When built as a module, the module will be called rtl8231_expander.
+
 config GPIO_SAMA5D2_PIOBU
 	tristate "SAMA5D2 PIOBU GPIO support"
 	depends on MFD_SYSCON
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7ba71922817e..7f22f0e5430e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -126,6 +126,7 @@ obj-$(CONFIG_GPIO_RDA)			+= gpio-rda.o
 obj-$(CONFIG_GPIO_RDC321X)		+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_REALTEK_OTTO)		+= gpio-realtek-otto.o
 obj-$(CONFIG_GPIO_REG)			+= gpio-reg.o
+obj-$(CONFIG_GPIO_RTL8231)		+= gpio-rtl8231.o
 obj-$(CONFIG_ARCH_SA1100)		+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SAMA5D2_PIOBU)	+= gpio-sama5d2-piobu.o
 obj-$(CONFIG_GPIO_SCH311X)		+= gpio-sch311x.o
diff --git a/drivers/gpio/gpio-rtl8231.c b/drivers/gpio/gpio-rtl8231.c
new file mode 100644
index 000000000000..e0dfee68c859
--- /dev/null
+++ b/drivers/gpio/gpio-rtl8231.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/gpio/driver.h>
+#include <linux/i2c.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+/* RTL8231 registers for LED control */
+#define RTL8231_FUNC0			0x00
+#define RTL8231_FUNC1			0x01
+#define RTL8231_PIN_MODE0		0x02
+#define RTL8231_PIN_MODE1		0x03
+#define RTL8231_PIN_HI_CFG		0x04
+#define RTL8231_GPIO_DIR0		0x05
+#define RTL8231_GPIO_DIR1		0x06
+#define RTL8231_GPIO_INVERT0		0x07
+#define RTL8231_GPIO_INVERT1		0x08
+#define RTL8231_GPIO_DATA0		0x1c
+#define RTL8231_GPIO_DATA1		0x1d
+#define RTL8231_GPIO_DATA2		0x1e
+
+#define RTL8231_READY_CODE_VALUE	0x37
+#define RTL8231_GPIO_DIR_IN		1
+#define RTL8231_GPIO_DIR_OUT		0
+
+#define RTL8231_MAX_GPIOS		37
+
+enum rtl8231_regfield {
+	RTL8231_FIELD_LED_START,
+	RTL8231_FIELD_READY_CODE,
+	RTL8231_FIELD_SOFT_RESET,
+	RTL8231_FIELD_PIN_MODE0,
+	RTL8231_FIELD_PIN_MODE1,
+	RTL8231_FIELD_PIN_MODE2,
+	RTL8231_FIELD_GPIO_DIR0,
+	RTL8231_FIELD_GPIO_DIR1,
+	RTL8231_FIELD_GPIO_DIR2,
+	RTL8231_FIELD_GPIO_DATA0,
+	RTL8231_FIELD_GPIO_DATA1,
+	RTL8231_FIELD_GPIO_DATA2,
+	RTL8231_FIELD_MAX
+};
+
+static const struct reg_field rtl8231_fields[RTL8231_FIELD_MAX] = {
+	[RTL8231_FIELD_LED_START]   = REG_FIELD(RTL8231_FUNC0, 1, 1),
+	[RTL8231_FIELD_READY_CODE]  = REG_FIELD(RTL8231_FUNC1, 4, 9),
+	[RTL8231_FIELD_SOFT_RESET]  = REG_FIELD(RTL8231_PIN_HI_CFG, 15, 15),
+	[RTL8231_FIELD_PIN_MODE0]   = REG_FIELD(RTL8231_PIN_MODE0, 0, 15),
+	[RTL8231_FIELD_PIN_MODE1]   = REG_FIELD(RTL8231_PIN_MODE1, 0, 15),
+	[RTL8231_FIELD_PIN_MODE2]   = REG_FIELD(RTL8231_PIN_HI_CFG, 0, 4),
+	[RTL8231_FIELD_GPIO_DIR0]   = REG_FIELD(RTL8231_GPIO_DIR0, 0, 15),
+	[RTL8231_FIELD_GPIO_DIR1]   = REG_FIELD(RTL8231_GPIO_DIR1, 0, 15),
+	[RTL8231_FIELD_GPIO_DIR2]   = REG_FIELD(RTL8231_PIN_HI_CFG, 5, 9),
+	[RTL8231_FIELD_GPIO_DATA0]  = REG_FIELD(RTL8231_GPIO_DATA0, 0, 15),
+	[RTL8231_FIELD_GPIO_DATA1]  = REG_FIELD(RTL8231_GPIO_DATA1, 0, 15),
+	[RTL8231_FIELD_GPIO_DATA2]  = REG_FIELD(RTL8231_GPIO_DATA2, 0, 4),
+};
+
+/**
+ * struct rtl8231_gpio_ctrl - Control data for an RTL8231 chip
+ *
+ * @gc: Associated gpio_chip instance
+ * @dev
+ * @fields
+ */
+struct rtl8231_gpio_ctrl {
+	struct gpio_chip gc;
+	struct device *dev;
+	struct regmap_field *fields[RTL8231_FIELD_MAX];
+};
+
+static int rtl8231_pin_read(struct rtl8231_gpio_ctrl *ctrl, int base, int offset)
+{
+	int field = base + offset / 16;
+	int bit = offset % 16;
+	unsigned int v;
+	int err;
+
+	err = regmap_field_read(ctrl->fields[field], &v);
+
+	if (err)
+		return err;
+
+	return !!(v & BIT(bit));
+}
+
+static int rtl8231_pin_write(struct rtl8231_gpio_ctrl *ctrl, int base, int offset, int val)
+{
+	int field = base + offset / 16;
+	int bit = offset % 16;
+
+	return regmap_field_update_bits(ctrl->fields[field], BIT(bit), val << bit);
+}
+
+static int rtl8231_direction_input(struct gpio_chip *gc, unsigned int offset)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+
+	return rtl8231_pin_write(ctrl, RTL8231_FIELD_GPIO_DIR0, offset, RTL8231_GPIO_DIR_IN);
+}
+
+static int rtl8231_direction_output(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+	int err;
+
+	err = rtl8231_pin_write(ctrl, RTL8231_FIELD_GPIO_DIR0, offset, RTL8231_GPIO_DIR_OUT);
+	if (err)
+		return err;
+
+	return rtl8231_pin_write(ctrl, RTL8231_FIELD_GPIO_DATA0, offset, value);
+}
+
+static int rtl8231_get_direction(struct gpio_chip *gc, unsigned int offset)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+
+	return rtl8231_pin_read(ctrl, RTL8231_FIELD_GPIO_DIR0, offset);
+}
+
+static int rtl8231_gpio_get(struct gpio_chip *gc, unsigned int offset)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+
+	return rtl8231_pin_read(ctrl, RTL8231_FIELD_GPIO_DATA0, offset);
+}
+
+static void rtl8231_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+
+	rtl8231_pin_write(ctrl, RTL8231_FIELD_GPIO_DATA0, offset, value);
+}
+
+static int rtl8231_gpio_get_multiple(struct gpio_chip *gc,
+	unsigned long *mask, unsigned long *bits)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+	int read, field;
+	int offset, shift;
+	int sub_mask;
+	int value, err;
+
+	err = 0;
+	read = 0;
+	field = 0;
+
+	while (read < gc->ngpio) {
+		shift = read % (8 * sizeof(*bits));
+		offset = read / (8 * sizeof(*bits));
+		sub_mask = (mask[offset] >> shift) & 0xffff;
+		if (sub_mask) {
+			err = regmap_field_read(ctrl->fields[RTL8231_FIELD_GPIO_DATA0 + field],
+				&value);
+			if (err)
+				return err;
+			value = (sub_mask & value) << shift;
+			sub_mask <<= shift;
+			bits[offset] = (bits[offset] & ~sub_mask) | value;
+		}
+
+		field += 1;
+		read += 16;
+	}
+
+	return err;
+}
+
+static void rtl8231_gpio_set_multiple(struct gpio_chip *gc,
+	unsigned long *mask, unsigned long *bits)
+{
+	struct rtl8231_gpio_ctrl *ctrl = gpiochip_get_data(gc);
+	int read, field;
+	int offset, shift;
+	int sub_mask;
+	int value;
+
+	read = 0;
+	field = 0;
+
+	while (read < gc->ngpio) {
+		shift = read % (8 * sizeof(*bits));
+		offset = read / (8 * sizeof(*bits));
+		sub_mask = (mask[offset] >> shift) & 0xffff;
+		if (sub_mask) {
+			value = bits[offset] >> shift;
+			regmap_field_update_bits(ctrl->fields[RTL8231_FIELD_GPIO_DATA0 + field],
+				sub_mask, value);
+		}
+
+		field += 1;
+		read += 16;
+	}
+}
+
+static int rtl8231_init(struct rtl8231_gpio_ctrl *ctrl)
+{
+	unsigned int v;
+	int err;
+
+	err = regmap_field_read(ctrl->fields[RTL8231_FIELD_READY_CODE], &v);
+	if (err) {
+		dev_err(ctrl->dev, "failed to read READY_CODE\n");
+		return -ENODEV;
+	} else if (v != RTL8231_READY_CODE_VALUE) {
+		dev_err(ctrl->dev, "RTL8231 not present or ready 0x%x != 0x%x\n",
+			v, RTL8231_READY_CODE_VALUE);
+		return -ENODEV;
+	}
+
+	dev_info(ctrl->dev, "RTL8231 found\n");
+
+	/* If the device was already configured, just leave it alone */
+	err = regmap_field_read(ctrl->fields[RTL8231_FIELD_LED_START], &v);
+	if (err)
+		return err;
+	else if (v)
+		return 0;
+
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_SOFT_RESET], 1);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_LED_START], 1);
+
+	/* Select GPIO functionality for all pins and set to input */
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_PIN_MODE0], 0xffff);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_GPIO_DIR0], 0xffff);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_PIN_MODE1], 0xffff);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_GPIO_DIR1], 0xffff);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_PIN_MODE2], 0x1f);
+	regmap_field_write(ctrl->fields[RTL8231_FIELD_GPIO_DIR2], 0x1f);
+
+	return 0;
+}
+
+#define OF_COMPATIBLE_RTL8231_MDIO	"realtek,rtl8231-mdio"
+#define OF_COMPATIBLE_RTL8231_I2C	"realtek,rtl8231-i2c"
+
+static const struct of_device_id rtl8231_gpio_of_match[] = {
+	{ .compatible = OF_COMPATIBLE_RTL8231_MDIO },
+	{ .compatible = OF_COMPATIBLE_RTL8231_I2C },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, rtl8231_gpio_of_match);
+
+static struct regmap *rtl8231_gpio_regmap_mdio(struct device *dev, struct regmap_config *cfg)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *expander_np = NULL;
+	struct mdio_device *mdiodev;
+
+	expander_np = of_parse_phandle(np, "dev-handle", 0);
+	if (!expander_np) {
+		dev_err(dev, "missing dev-handle node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	mdiodev = of_mdio_find_device(expander_np);
+	of_node_put(expander_np);
+
+	if (!mdiodev) {
+		dev_err(dev, "failed to find MDIO device\n");
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	cfg->reg_bits = 5;
+	return devm_regmap_init_miim(mdiodev, cfg);
+}
+
+static struct regmap *rtl8231_gpio_regmap_i2c(struct device *dev, struct regmap_config *cfg)
+{
+	struct device_node *np = dev->of_node;
+	struct i2c_client *i2cdev;
+	struct regmap *map;
+	u32 reg_width;
+
+	// TODO untested
+	i2cdev = of_find_i2c_device_by_node(np);
+	if (IS_ERR(i2cdev)) {
+		dev_err(dev, "failed to find I2C device\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	/* Complete 7-bit I2C address is [1 0 1 0 A2 A1 A0] */
+	if ((i2cdev->addr & ~(0x7)) != 0x50) {
+		dev_err(dev, "invalid address\n");
+		map = ERR_PTR(-EINVAL);
+		goto regmap_i2c_out;
+	}
+
+	if (of_property_read_u32(np, "realtek,regnum-width", &reg_width)
+		|| reg_width != 1 || reg_width != 2) {
+		dev_err(dev, "invalid realtek,regnum-width\n");
+		map = ERR_PTR(-EINVAL);
+		goto regmap_i2c_out;
+	}
+
+	cfg->reg_bits = 8*reg_width;
+	map = devm_regmap_init_i2c(i2cdev, cfg);
+
+regmap_i2c_out:
+	put_device(&i2cdev->dev);
+	return map;
+}
+
+static int rtl8231_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct regmap *map;
+	struct regmap_config regmap_cfg = {};
+	struct rtl8231_gpio_ctrl *ctrl;
+	int field, err;
+	u32 ngpios;
+
+	if (!np) {
+		dev_err(dev, "no DT node found\n");
+		return -EINVAL;
+	}
+
+	ctrl = devm_kzalloc(dev, sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	ngpios = RTL8231_MAX_GPIOS;
+	of_property_read_u32(np, "ngpios", &ngpios);
+	if (ngpios > RTL8231_MAX_GPIOS) {
+		dev_err(dev, "ngpios can be at most %d\n", RTL8231_MAX_GPIOS);
+		return -EINVAL;
+	}
+
+	regmap_cfg.val_bits = 16;
+	regmap_cfg.max_register = 30;
+	regmap_cfg.cache_type = REGCACHE_NONE;
+	regmap_cfg.num_ranges = 0;
+	regmap_cfg.use_single_read = true;
+	regmap_cfg.use_single_write = true;
+	regmap_cfg.reg_format_endian = REGMAP_ENDIAN_BIG;
+	regmap_cfg.val_format_endian = REGMAP_ENDIAN_BIG;
+
+	if (of_device_is_compatible(np, OF_COMPATIBLE_RTL8231_MDIO)) {
+		map = rtl8231_gpio_regmap_mdio(dev, &regmap_cfg);
+	} else if (of_device_is_compatible(np, OF_COMPATIBLE_RTL8231_I2C)) {
+		map = rtl8231_gpio_regmap_i2c(dev, &regmap_cfg);
+	} else {
+		dev_err(dev, "invalid bus type\n");
+		return -ENOTSUPP;
+	}
+
+	if (IS_ERR(map)) {
+		dev_err(dev, "failed to init regmap\n");
+		return PTR_ERR(map);
+	}
+
+	for (field = 0; field < RTL8231_FIELD_MAX; field++) {
+		ctrl->fields[field] = devm_regmap_field_alloc(dev, map, rtl8231_fields[field]);
+		if (IS_ERR(ctrl->fields[field])) {
+			dev_err(dev, "unable to allocate regmap field\n");
+			return PTR_ERR(ctrl->fields[field]);
+		}
+	}
+
+	ctrl->dev = dev;
+	err = rtl8231_init(ctrl);
+	if (err < 0)
+		return err;
+
+	ctrl->gc.base = -1;
+	ctrl->gc.ngpio = ngpios;
+	ctrl->gc.label = "rtl8231-gpio";
+	ctrl->gc.parent = dev;
+	ctrl->gc.owner = THIS_MODULE;
+	ctrl->gc.can_sleep = true;
+
+	ctrl->gc.set = rtl8231_gpio_set;
+	ctrl->gc.set_multiple = rtl8231_gpio_set_multiple;
+	ctrl->gc.get = rtl8231_gpio_get;
+	ctrl->gc.get_multiple = rtl8231_gpio_get_multiple;
+	ctrl->gc.direction_input = rtl8231_direction_input;
+	ctrl->gc.direction_output = rtl8231_direction_output;
+	ctrl->gc.get_direction = rtl8231_get_direction;
+
+	return devm_gpiochip_add_data(dev, &ctrl->gc, ctrl);
+}
+
+static struct platform_driver rtl8231_gpio_driver = {
+	.driver = {
+		.name = "rtl8231-expander",
+		.of_match_table	= rtl8231_gpio_of_match,
+	},
+	.probe = rtl8231_gpio_probe,
+};
+module_platform_driver(rtl8231_gpio_driver);
+
+MODULE_AUTHOR("Sander Vanheule <sander@svanheule.net>");
+MODULE_DESCRIPTION("Realtek RTL8231 GPIO and LED expander support");
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

