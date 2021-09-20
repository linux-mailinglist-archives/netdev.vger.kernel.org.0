Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C804C4127EA
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbhITV0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:26:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36809 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237630AbhITVYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 17:24:06 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from asmaa@mellanox.com)
        with SMTP; 21 Sep 2021 00:22:35 +0300
Received: from farm-0002.mtbu.labs.mlnx (farm-0002.mtbu.labs.mlnx [10.15.2.32])
        by mtbu-labmailer.labs.mlnx (8.14.4/8.14.4) with ESMTP id 18KLMZaL030014;
        Mon, 20 Sep 2021 17:22:35 -0400
Received: (from asmaa@localhost)
        by farm-0002.mtbu.labs.mlnx (8.14.7/8.13.8/Submit) id 18KLMZ5B019406;
        Mon, 20 Sep 2021 17:22:35 -0400
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>, andrew@lunn.ch, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Date:   Mon, 20 Sep 2021 17:22:26 -0400
Message-Id: <20210920212227.19358-2-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210920212227.19358-1-asmaa@nvidia.com>
References: <20210920212227.19358-1-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce standard IRQ handling in the gpio-mlxbf2.c
driver.

Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/gpio/gpio-mlxbf2.c | 147 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index 177d03ef4529..3d89912a05b8 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -1,9 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 
+/*
+ * Copyright (C) 2020-2021 NVIDIA CORPORATION & AFFILIATES
+ */
+
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/gpio/driver.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
@@ -43,9 +48,14 @@
 #define YU_GPIO_MODE0			0x0c
 #define YU_GPIO_DATASET			0x14
 #define YU_GPIO_DATACLEAR		0x18
+#define YU_GPIO_CAUSE_RISE_EN		0x44
+#define YU_GPIO_CAUSE_FALL_EN		0x48
 #define YU_GPIO_MODE1_CLEAR		0x50
 #define YU_GPIO_MODE0_SET		0x54
 #define YU_GPIO_MODE0_CLEAR		0x58
+#define YU_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
+#define YU_GPIO_CAUSE_OR_EVTEN0		0x94
+#define YU_GPIO_CAUSE_OR_CLRCAUSE	0x98
 
 struct mlxbf2_gpio_context_save_regs {
 	u32 gpio_mode0;
@@ -55,6 +65,7 @@ struct mlxbf2_gpio_context_save_regs {
 /* BlueField-2 gpio block context structure. */
 struct mlxbf2_gpio_context {
 	struct gpio_chip gc;
+	struct irq_chip irq_chip;
 
 	/* YU GPIO blocks address */
 	void __iomem *gpio_io;
@@ -218,15 +229,114 @@ static int mlxbf2_gpio_direction_output(struct gpio_chip *chip,
 	return ret;
 }
 
+static void mlxbf2_gpio_irq_enable(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
+	int offset = irqd_to_hwirq(irqd);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
+}
+
+static void mlxbf2_gpio_irq_disable(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
+	int offset = irqd_to_hwirq(irqd);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	val &= ~BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
+}
+
+static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr)
+{
+	struct mlxbf2_gpio_context *gs = ptr;
+	struct gpio_chip *gc = &gs->gc;
+	unsigned long pending;
+	u32 level;
+
+	pending = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CAUSE_EVTEN0);
+	writel(pending, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+
+	for_each_set_bit(level, &pending, gc->ngpio) {
+		int gpio_irq = irq_find_mapping(gc->irq.domain, level);
+		generic_handle_irq(gpio_irq);
+	}
+
+	return IRQ_RETVAL(pending);
+}
+
+static int
+mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
+	int offset = irqd_to_hwirq(irqd);
+	unsigned long flags;
+	bool fall = false;
+	bool rise = false;
+	u32 val;
+
+	switch (type & IRQ_TYPE_SENSE_MASK) {
+	case IRQ_TYPE_EDGE_BOTH:
+		fall = true;
+		rise = true;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		rise = true;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		fall = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	if (fall) {
+		val = readl(gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+		val |= BIT(offset);
+		writel(val, gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+	}
+
+	if (rise) {
+		val = readl(gs->gpio_io + YU_GPIO_CAUSE_RISE_EN);
+		val |= BIT(offset);
+		writel(val, gs->gpio_io + YU_GPIO_CAUSE_RISE_EN);
+	}
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
+
+	return 0;
+}
+
 /* BlueField-2 GPIO driver initialization routine. */
 static int
 mlxbf2_gpio_probe(struct platform_device *pdev)
 {
 	struct mlxbf2_gpio_context *gs;
 	struct device *dev = &pdev->dev;
+	struct gpio_irq_chip *girq;
 	struct gpio_chip *gc;
 	unsigned int npins;
-	int ret;
+	const char *name;
+	int ret, irq;
+
+	name = dev_name(dev);
 
 	gs = devm_kzalloc(dev, sizeof(*gs), GFP_KERNEL);
 	if (!gs)
@@ -256,11 +366,44 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 			NULL,
 			0);
 
+	if (ret) {
+		dev_err(dev, "bgpio_init failed\n");
+		return ret;
+	}
+
 	gc->direction_input = mlxbf2_gpio_direction_input;
 	gc->direction_output = mlxbf2_gpio_direction_output;
 	gc->ngpio = npins;
 	gc->owner = THIS_MODULE;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0) {
+		gs->irq_chip.name = name;
+		gs->irq_chip.irq_set_type = mlxbf2_gpio_irq_set_type;
+		gs->irq_chip.irq_enable = mlxbf2_gpio_irq_enable;
+		gs->irq_chip.irq_disable = mlxbf2_gpio_irq_disable;
+
+		girq = &gs->gc.irq;
+		girq->chip = &gs->irq_chip;
+		girq->handler = handle_simple_irq;
+		girq->default_type = IRQ_TYPE_NONE;
+		/* This will let us handle the parent IRQ in the driver */
+		girq->num_parents = 0;
+		girq->parents = NULL;
+		girq->parent_handler = NULL;
+
+		/*
+		 * Directly request the irq here instead of passing
+		 * a flow-handler because the irq is shared.
+		 */
+		ret = devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler,
+				       IRQF_SHARED, name, gs);
+		if (ret) {
+			dev_err(dev, "failed to request IRQ");
+			return ret;
+		}
+	}
+
 	platform_set_drvdata(pdev, gs);
 
 	ret = devm_gpiochip_add_data(dev, &gs->gc, gs);
@@ -315,5 +458,5 @@ static struct platform_driver mlxbf2_gpio_driver = {
 module_platform_driver(mlxbf2_gpio_driver);
 
 MODULE_DESCRIPTION("Mellanox BlueField-2 GPIO Driver");
-MODULE_AUTHOR("Mellanox Technologies");
+MODULE_AUTHOR("Asmaa Mnebhi <asmaa@nvidia.com>");
 MODULE_LICENSE("GPL v2");
-- 
2.30.1

