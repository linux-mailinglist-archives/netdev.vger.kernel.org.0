Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45913ED394
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhHPMBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:01:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:17273 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235199AbhHPMBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:01:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="301429189"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="301429189"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="441058492"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2021 05:00:11 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 268D135D; Mon, 16 Aug 2021 15:00:03 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Subject: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Date:   Mon, 16 Aug 2021 14:59:52 +0300
Message-Id: <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TBD

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 106 +++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index 3ed95e958c17..bd4c29120b62 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -43,9 +43,13 @@
 #define YU_GPIO_MODE0			0x0c
 #define YU_GPIO_DATASET			0x14
 #define YU_GPIO_DATACLEAR		0x18
+#define YU_GPIO_CAUSE_FALL_EN		0x48
 #define YU_GPIO_MODE1_CLEAR		0x50
 #define YU_GPIO_MODE0_SET		0x54
 #define YU_GPIO_MODE0_CLEAR		0x58
+#define YU_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
+#define YU_GPIO_CAUSE_OR_EVTEN0		0x94
+#define YU_GPIO_CAUSE_OR_CLRCAUSE	0x98
 
 struct mlxbf2_gpio_context_save_regs {
 	u32 gpio_mode0;
@@ -218,6 +222,108 @@ static int mlxbf2_gpio_direction_output(struct gpio_chip *chip,
 	return ret;
 }
 
+static void mlxbf2_gpio_irq_enable(struct mlxbf2_gpio_context *gs, int offset)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+
+	/* The INT_N interrupt level is active low.
+	 * So enable cause fall bit to detect when GPIO
+	 * state goes low.
+	 */
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+
+	/* Enable PHY interrupt by setting the priority level */
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
+}
+
+static void mlxbf2_gpio_irq_disable(struct mlxbf2_gpio_context *gs, int offset)
+{
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
+static void mlxbf2_gpio_irq_ack(struct mlxbf2_gpio_context *gs, int offset)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	val |= BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
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
+	for_each_set_bit(level, &pending, gc->ngpio) {
+		int nested_irq = irq_find_mapping(gc->irq.domain, level);
+
+		handle_nested_irq(nested_irq);
+	}
+
+	return IRQ_RETVAL(pending);
+}
+
+static void mlxbf2_gpio_irq_mask(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
+	int offset = irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;
+
+	mlxbf2_gpio_irq_disable(gs, offset);
+}
+
+static void mlxbf2_gpio_irq_unmask(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
+	int offset = irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;
+
+	mlxbf2_gpio_irq_enable(gs, offset);
+}
+
+static void mlxbf2_gpio_irq_bus_lock(struct irq_data *irqd)
+{
+	mutex_lock(yu_arm_gpio_lock_param.lock);
+}
+
+static void mlxbf2_gpio_irq_bus_sync_unlock(struct irq_data *irqd)
+{
+	mutex_unlock(yu_arm_gpio_lock_param.lock);
+}
+
+static struct irq_chip mlxbf2_gpio_irq_chip = {
+	.name			= "mlxbf2_gpio",
+	.irq_mask		= mlxbf2_gpio_irq_mask,
+	.irq_unmask		= mlxbf2_gpio_irq_unmask,
+	.irq_bus_lock		= mlxbf2_gpio_irq_bus_lock,
+	.irq_bus_sync_unlock	= mlxbf2_gpio_irq_bus_sync_unlock,
+};
+
 /* BlueField-2 GPIO driver initialization routine. */
 static int
 mlxbf2_gpio_probe(struct platform_device *pdev)
-- 
2.30.2

