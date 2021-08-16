Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6D63ED392
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbhHPMBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:01:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:38495 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233463AbhHPMA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:00:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="215572761"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="215572761"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="504864844"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2021 05:00:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 30F076BF; Mon, 16 Aug 2021 15:00:03 +0300 (EEST)
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
Subject: [PATCH v1 6/6] TODO: net: mellanox: mlxbf_gige: Replace non-standard interrupt handling
Date:   Mon, 16 Aug 2021 14:59:53 +0300
Message-Id: <20210816115953.72533-7-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since GPIO driver supports interrupt handling, replace custom routine with
simple IRQ request.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
 1 file changed, 212 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c
deleted file mode 100644
index a8d966db5715..000000000000
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c
+++ /dev/null
@@ -1,212 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
-
-/* Initialize and handle GPIO interrupt triggered by INT_N PHY signal.
- * This GPIO interrupt triggers the PHY state machine to bring the link
- * up/down.
- *
- * Copyright (C) 2021 NVIDIA CORPORATION & AFFILIATES
- */
-
-#include <linux/acpi.h>
-#include <linux/bitfield.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/gpio/driver.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/irqreturn.h>
-#include <linux/platform_device.h>
-#include <linux/property.h>
-
-#include "mlxbf_gige.h"
-#include "mlxbf_gige_regs.h"
-
-#define MLXBF_GIGE_GPIO_CAUSE_FALL_EN		0x48
-#define MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
-#define MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0		0x94
-#define MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE	0x98
-
-static void mlxbf_gige_gpio_enable(struct mlxbf_gige *priv)
-{
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&priv->gpio_lock, flags);
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
-	val |= priv->phy_int_gpio_mask;
-	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
-
-	/* The INT_N interrupt level is active low.
-	 * So enable cause fall bit to detect when GPIO
-	 * state goes low.
-	 */
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
-	val |= priv->phy_int_gpio_mask;
-	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
-
-	/* Enable PHY interrupt by setting the priority level */
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
-	val |= priv->phy_int_gpio_mask;
-	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
-	spin_unlock_irqrestore(&priv->gpio_lock, flags);
-}
-
-static void mlxbf_gige_gpio_disable(struct mlxbf_gige *priv)
-{
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&priv->gpio_lock, flags);
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
-	val &= ~priv->phy_int_gpio_mask;
-	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
-	spin_unlock_irqrestore(&priv->gpio_lock, flags);
-}
-
-static irqreturn_t mlxbf_gige_gpio_handler(int irq, void *ptr)
-{
-	struct mlxbf_gige *priv;
-	u32 val;
-
-	priv = ptr;
-
-	/* Check if this interrupt is from PHY device.
-	 * Return if it is not.
-	 */
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
-	if (!(val & priv->phy_int_gpio_mask))
-		return IRQ_NONE;
-
-	/* Clear interrupt when done, otherwise, no further interrupt
-	 * will be triggered.
-	 */
-	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
-	val |= priv->phy_int_gpio_mask;
-	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
-
-	generic_handle_irq(priv->phy_irq);
-
-	return IRQ_HANDLED;
-}
-
-static void mlxbf_gige_gpio_mask(struct irq_data *irqd)
-{
-	struct mlxbf_gige *priv = irq_data_get_irq_chip_data(irqd);
-
-	mlxbf_gige_gpio_disable(priv);
-}
-
-static void mlxbf_gige_gpio_unmask(struct irq_data *irqd)
-{
-	struct mlxbf_gige *priv = irq_data_get_irq_chip_data(irqd);
-
-	mlxbf_gige_gpio_enable(priv);
-}
-
-static struct irq_chip mlxbf_gige_gpio_chip = {
-	.name			= "mlxbf_gige_phy",
-	.irq_mask		= mlxbf_gige_gpio_mask,
-	.irq_unmask		= mlxbf_gige_gpio_unmask,
-};
-
-static int mlxbf_gige_gpio_domain_map(struct irq_domain *d,
-				      unsigned int irq,
-				      irq_hw_number_t hwirq)
-{
-	irq_set_chip_data(irq, d->host_data);
-	irq_set_chip_and_handler(irq, &mlxbf_gige_gpio_chip, handle_simple_irq);
-	irq_set_noprobe(irq);
-
-	return 0;
-}
-
-static const struct irq_domain_ops mlxbf_gige_gpio_domain_ops = {
-	.map    = mlxbf_gige_gpio_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
-#ifdef CONFIG_ACPI
-static int mlxbf_gige_gpio_resources(struct acpi_resource *ares,
-				     void *data)
-{
-	struct acpi_resource_gpio *gpio;
-	u32 *phy_int_gpio = data;
-
-	if (ares->type == ACPI_RESOURCE_TYPE_GPIO) {
-		gpio = &ares->data.gpio;
-		*phy_int_gpio = gpio->pin_table[0];
-	}
-
-	return 1;
-}
-#endif
-
-void mlxbf_gige_gpio_free(struct mlxbf_gige *priv)
-{
-	irq_dispose_mapping(priv->phy_irq);
-	irq_domain_remove(priv->irqdomain);
-}
-
-int mlxbf_gige_gpio_init(struct platform_device *pdev,
-			 struct mlxbf_gige *priv)
-{
-	struct device *dev = &pdev->dev;
-	struct resource *res;
-	u32 phy_int_gpio = 0;
-	int ret;
-
-	LIST_HEAD(resources);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_GPIO0);
-	if (!res)
-		return -ENODEV;
-
-	priv->gpio_io = devm_ioremap(dev, res->start, resource_size(res));
-	if (!priv->gpio_io)
-		return -ENOMEM;
-
-#ifdef CONFIG_ACPI
-	ret = acpi_dev_get_resources(ACPI_COMPANION(dev),
-				     &resources, mlxbf_gige_gpio_resources,
-				     &phy_int_gpio);
-	acpi_dev_free_resource_list(&resources);
-	if (ret < 0 || !phy_int_gpio) {
-		dev_err(dev, "Error retrieving the gpio phy pin");
-		return -EINVAL;
-	}
-#endif
-
-	priv->phy_int_gpio_mask = BIT(phy_int_gpio);
-
-	mlxbf_gige_gpio_disable(priv);
-
-	priv->hw_phy_irq = platform_get_irq(pdev, MLXBF_GIGE_PHY_INT_N);
-
-	priv->irqdomain = irq_domain_add_simple(NULL, 1, 0,
-						&mlxbf_gige_gpio_domain_ops,
-						priv);
-	if (!priv->irqdomain) {
-		dev_err(dev, "Failed to add IRQ domain\n");
-		return -ENOMEM;
-	}
-
-	priv->phy_irq = irq_create_mapping(priv->irqdomain, 0);
-	if (!priv->phy_irq) {
-		irq_domain_remove(priv->irqdomain);
-		priv->irqdomain = NULL;
-		dev_err(dev, "Error mapping PHY IRQ\n");
-		return -EINVAL;
-	}
-
-	ret = devm_request_irq(dev, priv->hw_phy_irq, mlxbf_gige_gpio_handler,
-			       IRQF_ONESHOT | IRQF_SHARED, "mlxbf_gige_phy", priv);
-	if (ret) {
-		dev_err(dev, "Failed to request PHY IRQ");
-		mlxbf_gige_gpio_free(priv);
-		return ret;
-	}
-
-	return ret;
-}
-- 
2.30.2

