Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49554128D0
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhITW0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 18:26:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59454 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237675AbhITWYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 18:24:12 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from asmaa@mellanox.com)
        with SMTP; 21 Sep 2021 00:22:39 +0300
Received: from farm-0002.mtbu.labs.mlnx (farm-0002.mtbu.labs.mlnx [10.15.2.32])
        by mtbu-labmailer.labs.mlnx (8.14.4/8.14.4) with ESMTP id 18KLMd2Z030017;
        Mon, 20 Sep 2021 17:22:39 -0400
Received: (from asmaa@localhost)
        by farm-0002.mtbu.labs.mlnx (8.14.7/8.13.8/Submit) id 18KLMdLu019407;
        Mon, 20 Sep 2021 17:22:39 -0400
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>, andrew@lunn.ch, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: [PATCH v2 2/2] net: mellanox: mlxbf_gige: Replace non-standard interrupt handling
Date:   Mon, 20 Sep 2021 17:22:27 -0400
Message-Id: <20210920212227.19358-3-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210920212227.19358-1-asmaa@nvidia.com>
References: <20210920212227.19358-1-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the GPIO driver (gpio-mlxbf2.c) supports interrupt
handling, replace the custom routine with simple IRQ
request.

Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../net/ethernet/mellanox/mlxbf_gige/Makefile |   1 -
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |  12 -
 .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  22 +-
 4 files changed, 9 insertions(+), 238 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
index e57c1375f236..a97c2bef846b 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
@@ -3,7 +3,6 @@
 obj-$(CONFIG_MLXBF_GIGE) += mlxbf_gige.o
 
 mlxbf_gige-y := mlxbf_gige_ethtool.o \
-		mlxbf_gige_gpio.o \
 		mlxbf_gige_intr.o \
 		mlxbf_gige_main.o \
 		mlxbf_gige_mdio.o \
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index e3509e69ed1c..86826a70f9dd 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -51,11 +51,6 @@
 #define MLXBF_GIGE_ERROR_INTR_IDX       0
 #define MLXBF_GIGE_RECEIVE_PKT_INTR_IDX 1
 #define MLXBF_GIGE_LLU_PLU_INTR_IDX     2
-#define MLXBF_GIGE_PHY_INT_N            3
-
-#define MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR 0x3
-
-#define MLXBF_GIGE_DEFAULT_PHY_INT_GPIO 12
 
 struct mlxbf_gige_stats {
 	u64 hw_access_errors;
@@ -81,11 +76,7 @@ struct mlxbf_gige {
 	struct platform_device *pdev;
 	void __iomem *mdio_io;
 	struct mii_bus *mdiobus;
-	void __iomem *gpio_io;
-	struct irq_domain *irqdomain;
-	u32 phy_int_gpio_mask;
 	spinlock_t lock;      /* for packet processing indices */
-	spinlock_t gpio_lock; /* for GPIO bus access */
 	u16 rx_q_entries;
 	u16 tx_q_entries;
 	u64 *tx_wqe_base;
@@ -184,7 +175,4 @@ int mlxbf_gige_poll(struct napi_struct *napi, int budget);
 extern const struct ethtool_ops mlxbf_gige_ethtool_ops;
 void mlxbf_gige_update_tx_wqe_next(struct mlxbf_gige *priv);
 
-int mlxbf_gige_gpio_init(struct platform_device *pdev, struct mlxbf_gige *priv);
-void mlxbf_gige_gpio_free(struct mlxbf_gige *priv);
-
 #endif /* !defined(__MLXBF_GIGE_H__) */
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
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 3e85b17f5857..4382ec8f7d64 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -273,8 +273,8 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	void __iomem *llu_base;
 	void __iomem *plu_base;
 	void __iomem *base;
+	int addr, phy_irq;
 	u64 control;
-	int addr;
 	int err;
 
 	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
@@ -309,20 +309,12 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->gpio_lock);
 
 	/* Attach MDIO device */
 	err = mlxbf_gige_mdio_probe(pdev, priv);
 	if (err)
 		return err;
 
-	err = mlxbf_gige_gpio_init(pdev, priv);
-	if (err) {
-		dev_err(&pdev->dev, "PHY IRQ initialization failed\n");
-		mlxbf_gige_mdio_remove(priv);
-		return -ENODEV;
-	}
-
 	priv->base = base;
 	priv->llu_base = llu_base;
 	priv->plu_base = plu_base;
@@ -343,6 +335,12 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->rx_irq = platform_get_irq(pdev, MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
 	priv->llu_plu_irq = platform_get_irq(pdev, MLXBF_GIGE_LLU_PLU_INTR_IDX);
 
+	phy_irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev), "phy-gpios", 0);
+	if (phy_irq < 0) {
+		dev_err(&pdev->dev, "Error getting PHY irq. Use polling instead");
+		phy_irq = PHY_POLL;
+	}
+
 	phydev = phy_find_first(priv->mdiobus);
 	if (!phydev) {
 		err = -ENODEV;
@@ -350,8 +348,8 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	}
 
 	addr = phydev->mdio.addr;
-	priv->mdiobus->irq[addr] = priv->phy_irq;
-	phydev->irq = priv->phy_irq;
+	priv->mdiobus->irq[addr] = phy_irq;
+	phydev->irq = phy_irq;
 
 	err = phy_connect_direct(netdev, phydev,
 				 mlxbf_gige_adjust_link,
@@ -387,7 +385,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	return 0;
 
 out:
-	mlxbf_gige_gpio_free(priv);
 	mlxbf_gige_mdio_remove(priv);
 	return err;
 }
@@ -398,7 +395,6 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
 
 	unregister_netdev(priv->netdev);
 	phy_disconnect(priv->netdev->phydev);
-	mlxbf_gige_gpio_free(priv);
 	mlxbf_gige_mdio_remove(priv);
 	platform_set_drvdata(pdev, NULL);
 
-- 
2.30.1

