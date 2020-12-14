Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7022D98E3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439717AbgLNNdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407995AbgLNNdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:33:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA25CC061248
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:31:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1konxF-0003VA-Ay
        for netdev@vger.kernel.org; Mon, 14 Dec 2020 14:31:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2AC565AD2CB
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:31:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D2FFE5AD295;
        Mon, 14 Dec 2020 13:31:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5a0c37cc;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sean Nyekjaer <sean@geanix.com>, Dan Murphy <dmurphy@ti.com>
Subject: [net-next 6/7] can: m_can: let m_can_class_allocate_dev() allocate driver specific private data
Date:   Mon, 14 Dec 2020 14:31:44 +0100
Message-Id: <20201214133145.442472-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214133145.442472-1-mkl@pengutronix.de>
References: <20201214133145.442472-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enhances m_can_class_allocate_dev() to allocate driver specific
private data. The driver's private data struct must contain struct
m_can_classdev as its first member followed by the remaining private data.

Link: https://lore.kernel.org/r/20201212175518.139651-7-mkl@pengutronix.de
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          |  5 +--
 drivers/net/can/m_can/m_can.h          |  4 +--
 drivers/net/can/m_can/m_can_pci.c      | 27 +++++++++-------
 drivers/net/can/m_can/m_can_platform.c | 26 ++++++++-------
 drivers/net/can/m_can/tcan4x5x.c       | 44 +++++++++++++-------------
 5 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f258c81db0c3..cc7972a103dc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1759,7 +1759,8 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_get_clocks);
 
-struct m_can_classdev *m_can_class_allocate_dev(struct device *dev)
+struct m_can_classdev *m_can_class_allocate_dev(struct device *dev,
+						int sizeof_priv)
 {
 	struct m_can_classdev *class_dev = NULL;
 	u32 mram_config_vals[MRAM_CFG_LEN];
@@ -1782,7 +1783,7 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev)
 	tx_fifo_size = mram_config_vals[7];
 
 	/* allocate the m_can device */
-	net_dev = alloc_candev(sizeof(*class_dev), tx_fifo_size);
+	net_dev = alloc_candev(sizeof_priv, tx_fifo_size);
 	if (!net_dev) {
 		dev_err(dev, "Failed to allocate CAN device");
 		goto out;
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 3994e20249f8..3fda84cef351 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -86,8 +86,6 @@ struct m_can_classdev {
 
 	struct m_can_ops *ops;
 
-	void *device_data;
-
 	int version;
 	u32 irqstatus;
 
@@ -97,7 +95,7 @@ struct m_can_classdev {
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-struct m_can_classdev *m_can_class_allocate_dev(struct device *dev);
+struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
 void m_can_class_free_dev(struct net_device *net);
 int m_can_class_register(struct m_can_classdev *cdev);
 void m_can_class_unregister(struct m_can_classdev *cdev);
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 04010ee0407c..ebfbef25e3f9 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -22,26 +22,33 @@
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
 struct m_can_pci_priv {
+	struct m_can_classdev cdev;
+
 	void __iomem *base;
 };
 
+static inline struct m_can_pci_priv *cdev_to_priv(struct m_can_classdev *cdev)
+{
+	return container_of(cdev, struct m_can_pci_priv, cdev);
+}
+
 static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 {
-	struct m_can_pci_priv *priv = cdev->device_data;
+	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
 	return readl(priv->base + reg);
 }
 
 static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
 {
-	struct m_can_pci_priv *priv = cdev->device_data;
+	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
 	return readl(priv->base + offset);
 }
 
 static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 {
-	struct m_can_pci_priv *priv = cdev->device_data;
+	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
 	writel(val, priv->base + reg);
 
@@ -50,7 +57,7 @@ static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 
 static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
 {
-	struct m_can_pci_priv *priv = cdev->device_data;
+	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
 	writel(val, priv->base + offset);
 
@@ -89,21 +96,19 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 		return -ENOMEM;
 	}
 
-	priv = devm_kzalloc(&pci->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	mcan_class = m_can_class_allocate_dev(&pci->dev);
+	mcan_class = m_can_class_allocate_dev(&pci->dev,
+					      sizeof(struct m_can_pci_priv));
 	if (!mcan_class)
 		return -ENOMEM;
 
+	priv = cdev_to_priv(mcan_class);
+
 	priv->base = base;
 
 	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
 		return ret;
 
-	mcan_class->device_data = priv;
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
@@ -135,7 +140,7 @@ static void m_can_pci_remove(struct pci_dev *pci)
 {
 	struct net_device *dev = pci_get_drvdata(pci);
 	struct m_can_classdev *mcan_class = netdev_priv(dev);
-	struct m_can_pci_priv *priv = mcan_class->device_data;
+	struct m_can_pci_priv *priv = cdev_to_priv(mcan_class);
 
 	pm_runtime_forbid(&pci->dev);
 	pm_runtime_get_noresume(&pci->dev);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 36ef791da388..5758d25e42c8 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -10,27 +10,34 @@
 #include "m_can.h"
 
 struct m_can_plat_priv {
+	struct m_can_classdev cdev;
+
 	void __iomem *base;
 	void __iomem *mram_base;
 };
 
+static inline struct m_can_plat_priv *cdev_to_priv(struct m_can_classdev *cdev)
+{
+	return container_of(cdev, struct m_can_plat_priv, cdev);
+}
+
 static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 {
-	struct m_can_plat_priv *priv = cdev->device_data;
+	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
 	return readl(priv->base + reg);
 }
 
 static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
 {
-	struct m_can_plat_priv *priv = cdev->device_data;
+	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
 	return readl(priv->mram_base + offset);
 }
 
 static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 {
-	struct m_can_plat_priv *priv = cdev->device_data;
+	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
 	writel(val, priv->base + reg);
 
@@ -39,7 +46,7 @@ static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 
 static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
 {
-	struct m_can_plat_priv *priv = cdev->device_data;
+	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
 	writel(val, priv->mram_base + offset);
 
@@ -62,17 +69,12 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	void __iomem *mram_addr;
 	int irq, ret = 0;
 
-	mcan_class = m_can_class_allocate_dev(&pdev->dev);
+	mcan_class = m_can_class_allocate_dev(&pdev->dev,
+					      sizeof(struct m_can_plat_priv));
 	if (!mcan_class)
 		return -ENOMEM;
 
-	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto probe_fail;
-	}
-
-	mcan_class->device_data = priv;
+	priv = cdev_to_priv(mcan_class);
 
 	ret = m_can_class_get_clocks(mcan_class);
 	if (ret)
diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index a0fecc3fb829..24c737c4fc44 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -114,17 +114,23 @@
 #define TCAN4X5X_WD_6_S_TIMER (BIT(28) | BIT(29))
 
 struct tcan4x5x_priv {
+	struct m_can_classdev cdev;
+
 	struct regmap *regmap;
 	struct spi_device *spi;
 
-	struct m_can_classdev *mcan_dev;
-
 	struct gpio_desc *reset_gpio;
 	struct gpio_desc *device_wake_gpio;
 	struct gpio_desc *device_state_gpio;
 	struct regulator *power;
 };
 
+static inline struct tcan4x5x_priv *cdev_to_priv(struct m_can_classdev *cdev)
+{
+	return container_of(cdev, struct tcan4x5x_priv, cdev);
+
+}
+
 static struct can_bittiming_const tcan4x5x_bittiming_const = {
 	.name = DEVICE_NAME,
 	.tseg1_min = 2,
@@ -253,7 +259,7 @@ static struct regmap_bus tcan4x5x_bus = {
 
 static u32 tcan4x5x_read_reg(struct m_can_classdev *cdev, int reg)
 {
-	struct tcan4x5x_priv *priv = cdev->device_data;
+	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 	u32 val;
 
 	regmap_read(priv->regmap, TCAN4X5X_MCAN_OFFSET + reg, &val);
@@ -263,7 +269,7 @@ static u32 tcan4x5x_read_reg(struct m_can_classdev *cdev, int reg)
 
 static u32 tcan4x5x_read_fifo(struct m_can_classdev *cdev, int addr_offset)
 {
-	struct tcan4x5x_priv *priv = cdev->device_data;
+	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 	u32 val;
 
 	regmap_read(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, &val);
@@ -273,7 +279,7 @@ static u32 tcan4x5x_read_fifo(struct m_can_classdev *cdev, int addr_offset)
 
 static int tcan4x5x_write_reg(struct m_can_classdev *cdev, int reg, int val)
 {
-	struct tcan4x5x_priv *priv = cdev->device_data;
+	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 
 	return regmap_write(priv->regmap, TCAN4X5X_MCAN_OFFSET + reg, val);
 }
@@ -281,7 +287,7 @@ static int tcan4x5x_write_reg(struct m_can_classdev *cdev, int reg, int val)
 static int tcan4x5x_write_fifo(struct m_can_classdev *cdev,
 			       int addr_offset, int val)
 {
-	struct tcan4x5x_priv *priv = cdev->device_data;
+	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 
 	return regmap_write(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, val);
 }
@@ -300,7 +306,7 @@ static int tcan4x5x_power_enable(struct regulator *reg, int enable)
 static int tcan4x5x_write_tcan_reg(struct m_can_classdev *cdev,
 				   int reg, int val)
 {
-	struct tcan4x5x_priv *priv = cdev->device_data;
+	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 
 	return regmap_write(priv->regmap, reg, val);
 }
@@ -330,7 +336,7 @@ static int tcan4x5x_clear_interrupts(struct m_can_classdev *cdev)
 
 static int tcan4x5x_init(struct m_can_classdev *cdev)
 {
-	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 	int ret;
 
 	tcan4x5x_check_wake(tcan4x5x);
@@ -357,7 +363,7 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 
 static int tcan4x5x_disable_wake(struct m_can_classdev *cdev)
 {
-	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 
 	return regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				  TCAN4X5X_DISABLE_WAKE_MSK, 0x00);
@@ -365,7 +371,7 @@ static int tcan4x5x_disable_wake(struct m_can_classdev *cdev)
 
 static int tcan4x5x_disable_state(struct m_can_classdev *cdev)
 {
-	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 
 	return regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				  TCAN4X5X_DISABLE_INH_MSK, 0x01);
@@ -373,7 +379,7 @@ static int tcan4x5x_disable_state(struct m_can_classdev *cdev)
 
 static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
 {
-	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 	int ret;
 
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
@@ -427,15 +433,12 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	struct m_can_classdev *mcan_class;
 	int freq, ret;
 
-	mcan_class = m_can_class_allocate_dev(&spi->dev);
+	mcan_class = m_can_class_allocate_dev(&spi->dev,
+					      sizeof(struct tcan4x5x_priv));
 	if (!mcan_class)
 		return -ENOMEM;
 
-	priv = devm_kzalloc(&spi->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto out_m_can_class_free_dev;
-	}
+	priv = cdev_to_priv(mcan_class);
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
 	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
@@ -445,8 +448,6 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		priv->power = NULL;
 	}
 
-	mcan_class->device_data = priv;
-
 	m_can_class_get_clocks(mcan_class);
 	if (IS_ERR(mcan_class->cclk)) {
 		dev_err(&spi->dev, "no CAN clock source defined\n");
@@ -462,7 +463,6 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	}
 
 	priv->spi = spi;
-	priv->mcan_dev = mcan_class;
 
 	mcan_class->pm_clock_support = 0;
 	mcan_class->can.clock.freq = freq;
@@ -518,11 +518,11 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
 {
 	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
 
-	m_can_class_unregister(priv->mcan_dev);
+	m_can_class_unregister(&priv->cdev);
 
 	tcan4x5x_power_enable(priv->power, 0);
 
-	m_can_class_free_dev(priv->mcan_dev->net);
+	m_can_class_free_dev(priv->cdev.net);
 
 	return 0;
 }
-- 
2.29.2


