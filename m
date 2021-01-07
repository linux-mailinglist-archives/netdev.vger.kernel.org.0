Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058572ECD3C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbhAGJvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbhAGJv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D2EC0612A9
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvZ-0001BY-7Q
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7E8A75BBA7A
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1F2E45BBA17;
        Thu,  7 Jan 2021 09:49:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0463b136;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 04/19] can: tcan4x5x: move regmap code into seperate file
Date:   Thu,  7 Jan 2021 10:48:45 +0100
Message-Id: <20210107094900.173046-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the regmap code into a seperate file.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/Makefile          |   1 +
 drivers/net/can/m_can/tcan4x5x-core.c   | 104 +-----------------------
 drivers/net/can/m_can/tcan4x5x-regmap.c |  95 ++++++++++++++++++++++
 drivers/net/can/m_can/tcan4x5x.h        |  34 ++++++++
 4 files changed, 133 insertions(+), 101 deletions(-)
 create mode 100644 drivers/net/can/m_can/tcan4x5x-regmap.c
 create mode 100644 drivers/net/can/m_can/tcan4x5x.h

diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index 91f9190dc007..d717bbc9e033 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_CAN_M_CAN_TCAN4X5X) += tcan4x5x.o
 
 tcan4x5x-objs :=
 tcan4x5x-objs += tcan4x5x-core.o
+tcan4x5x-objs += tcan4x5x-regmap.o
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 1b47c9d32c30..739b8f89a335 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -2,13 +2,7 @@
 // SPI to CAN driver for the Texas Instruments TCAN4x5x
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
-#include <linux/regmap.h>
-#include <linux/spi/spi.h>
-
-#include <linux/regulator/consumer.h>
-#include <linux/gpio/consumer.h>
-
-#include "m_can.h"
+#include "tcan4x5x.h"
 
 #define TCAN4X5X_EXT_CLK_DEF 40000000
 
@@ -87,14 +81,10 @@
 
 #define TCAN4X5X_MRAM_START 0x8000
 #define TCAN4X5X_MCAN_OFFSET 0x1000
-#define TCAN4X5X_MAX_REGISTER 0x8fff
 
 #define TCAN4X5X_CLEAR_ALL_INT 0xffffffff
 #define TCAN4X5X_SET_ALL_INT 0xffffffff
 
-#define TCAN4X5X_WRITE_CMD (0x61 << 24)
-#define TCAN4X5X_READ_CMD (0x41 << 24)
-
 #define TCAN4X5X_MODE_SEL_MASK (BIT(7) | BIT(6))
 #define TCAN4X5X_MODE_SLEEP 0x00
 #define TCAN4X5X_MODE_STANDBY BIT(6)
@@ -112,18 +102,6 @@
 #define TCAN4X5X_WD_3_S_TIMER BIT(29)
 #define TCAN4X5X_WD_6_S_TIMER (BIT(28) | BIT(29))
 
-struct tcan4x5x_priv {
-	struct m_can_classdev cdev;
-
-	struct regmap *regmap;
-	struct spi_device *spi;
-
-	struct gpio_desc *reset_gpio;
-	struct gpio_desc *device_wake_gpio;
-	struct gpio_desc *device_state_gpio;
-	struct regulator *power;
-};
-
 static inline struct tcan4x5x_priv *cdev_to_priv(struct m_can_classdev *cdev)
 {
 	return container_of(cdev, struct tcan4x5x_priv, cdev);
@@ -190,72 +168,6 @@ static int tcan4x5x_reset(struct tcan4x5x_priv *priv)
 	return ret;
 }
 
-static int regmap_spi_gather_write(void *context, const void *reg,
-				   size_t reg_len, const void *val,
-				   size_t val_len)
-{
-	struct device *dev = context;
-	struct spi_device *spi = to_spi_device(dev);
-	struct spi_message m;
-	u32 addr;
-	struct spi_transfer t[2] = {
-		{ .tx_buf = &addr, .len = reg_len, .cs_change = 0,},
-		{ .tx_buf = val, .len = val_len, },
-	};
-
-	addr = TCAN4X5X_WRITE_CMD | (*((u16 *)reg) << 8) | val_len >> 2;
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
-	return spi_sync(spi, &m);
-}
-
-static int tcan4x5x_regmap_write(void *context, const void *data, size_t count)
-{
-	u16 *reg = (u16 *)(data);
-	const u32 *val = data + 4;
-
-	return regmap_spi_gather_write(context, reg, 4, val, count - 4);
-}
-
-static int regmap_spi_async_write(void *context,
-				  const void *reg, size_t reg_len,
-				  const void *val, size_t val_len,
-				  struct regmap_async *a)
-{
-	return -ENOTSUPP;
-}
-
-static struct regmap_async *regmap_spi_async_alloc(void)
-{
-	return NULL;
-}
-
-static int tcan4x5x_regmap_read(void *context,
-				const void *reg, size_t reg_size,
-				void *val, size_t val_size)
-{
-	struct device *dev = context;
-	struct spi_device *spi = to_spi_device(dev);
-
-	u32 addr = TCAN4X5X_READ_CMD | (*((u16 *)reg) << 8) | val_size >> 2;
-
-	return spi_write_then_read(spi, &addr, reg_size, (u32 *)val, val_size);
-}
-
-static struct regmap_bus tcan4x5x_bus = {
-	.write = tcan4x5x_regmap_write,
-	.gather_write = regmap_spi_gather_write,
-	.async_write = regmap_spi_async_write,
-	.async_alloc = regmap_spi_async_alloc,
-	.read = tcan4x5x_regmap_read,
-	.read_flag_mask = 0x00,
-	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
-	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
-};
-
 static u32 tcan4x5x_read_reg(struct m_can_classdev *cdev, int reg)
 {
 	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
@@ -410,13 +322,6 @@ static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
 	return 0;
 }
 
-static const struct regmap_config tcan4x5x_regmap = {
-	.reg_bits = 32,
-	.val_bits = 32,
-	.cache_type = REGCACHE_NONE,
-	.max_register = TCAN4X5X_MAX_REGISTER,
-};
-
 static struct m_can_ops tcan4x5x_ops = {
 	.init = tcan4x5x_init,
 	.read_reg = tcan4x5x_read_reg,
@@ -480,12 +385,9 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_m_can_class_free_dev;
 
-	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
-					&spi->dev, &tcan4x5x_regmap);
-	if (IS_ERR(priv->regmap)) {
-		ret = PTR_ERR(priv->regmap);
+	ret = tcan4x5x_regmap_init(priv);
+	if (ret)
 		goto out_m_can_class_free_dev;
-	}
 
 	ret = tcan4x5x_power_enable(priv->power, 1);
 	if (ret)
diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
new file mode 100644
index 000000000000..f130c3586543
--- /dev/null
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// tcan4x5x - Texas Instruments TCAN4x5x Family CAN controller driver
+//
+// Copyright (c) 2020 Pengutronix,
+//                    Marc Kleine-Budde <kernel@pengutronix.de>
+// Copyright (c) 2018-2019 Texas Instruments Incorporated
+//                    http://www.ti.com/
+
+#include "tcan4x5x.h"
+
+#define TCAN4X5X_WRITE_CMD (0x61 << 24)
+#define TCAN4X5X_READ_CMD (0x41 << 24)
+
+#define TCAN4X5X_MAX_REGISTER 0x8fff
+
+static int regmap_spi_gather_write(void *context, const void *reg,
+				   size_t reg_len, const void *val,
+				   size_t val_len)
+{
+	struct device *dev = context;
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_message m;
+	u32 addr;
+	struct spi_transfer t[2] = {
+		{ .tx_buf = &addr, .len = reg_len, .cs_change = 0,},
+		{ .tx_buf = val, .len = val_len, },
+	};
+
+	addr = TCAN4X5X_WRITE_CMD | (*((u16 *)reg) << 8) | val_len >> 2;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t[0], &m);
+	spi_message_add_tail(&t[1], &m);
+
+	return spi_sync(spi, &m);
+}
+
+static int tcan4x5x_regmap_write(void *context, const void *data, size_t count)
+{
+	u16 *reg = (u16 *)(data);
+	const u32 *val = data + 4;
+
+	return regmap_spi_gather_write(context, reg, 4, val, count - 4);
+}
+
+static int regmap_spi_async_write(void *context,
+				  const void *reg, size_t reg_len,
+				  const void *val, size_t val_len,
+				  struct regmap_async *a)
+{
+	return -ENOTSUPP;
+}
+
+static struct regmap_async *regmap_spi_async_alloc(void)
+{
+	return NULL;
+}
+
+static int tcan4x5x_regmap_read(void *context,
+				const void *reg, size_t reg_size,
+				void *val, size_t val_size)
+{
+	struct device *dev = context;
+	struct spi_device *spi = to_spi_device(dev);
+
+	u32 addr = TCAN4X5X_READ_CMD | (*((u16 *)reg) << 8) | val_size >> 2;
+
+	return spi_write_then_read(spi, &addr, reg_size, (u32 *)val, val_size);
+}
+
+static const struct regmap_config tcan4x5x_regmap = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.cache_type = REGCACHE_NONE,
+	.max_register = TCAN4X5X_MAX_REGISTER,
+};
+
+static struct regmap_bus tcan4x5x_bus = {
+	.write = tcan4x5x_regmap_write,
+	.gather_write = regmap_spi_gather_write,
+	.async_write = regmap_spi_async_write,
+	.async_alloc = regmap_spi_async_alloc,
+	.read = tcan4x5x_regmap_read,
+	.read_flag_mask = 0x00,
+	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
+};
+
+int tcan4x5x_regmap_init(struct tcan4x5x_priv *priv)
+{
+	priv->regmap = devm_regmap_init(&priv->spi->dev, &tcan4x5x_bus,
+					&priv->spi->dev, &tcan4x5x_regmap);
+	return PTR_ERR_OR_ZERO(priv->regmap);
+}
diff --git a/drivers/net/can/m_can/tcan4x5x.h b/drivers/net/can/m_can/tcan4x5x.h
new file mode 100644
index 000000000000..e5bdd91b8005
--- /dev/null
+++ b/drivers/net/can/m_can/tcan4x5x.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * tcan4x5x - Texas Instruments TCAN4x5x Family CAN controller driver
+ *
+ * Copyright (c) 2020 Pengutronix,
+ *                    Marc Kleine-Budde <kernel@pengutronix.de>
+ */
+
+#ifndef _TCAN4X5X_H
+#define _TCAN4X5X_H
+
+#include <linux/gpio/consumer.h>
+#include <linux/regmap.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+
+#include "m_can.h"
+
+struct tcan4x5x_priv {
+	struct m_can_classdev cdev;
+
+	struct regmap *regmap;
+	struct spi_device *spi;
+
+	struct gpio_desc *reset_gpio;
+	struct gpio_desc *device_wake_gpio;
+	struct gpio_desc *device_state_gpio;
+	struct regulator *power;
+};
+
+int tcan4x5x_regmap_init(struct tcan4x5x_priv *priv);
+
+#endif
-- 
2.29.2


