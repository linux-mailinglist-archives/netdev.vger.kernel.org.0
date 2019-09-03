Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE5FA68C4
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbfICMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:43:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:8104 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbfICMnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 08:43:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 05:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="211975658"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 03 Sep 2019 05:43:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E0417139; Tue,  3 Sep 2019 15:42:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 4/4] can: mcp251x: Get rid of legacy platform data
Date:   Tue,  3 Sep 2019 15:42:59 +0300
Message-Id: <20190903124259.60920-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using legacy platform data, switch to use device properties.
For clock frequency we are using well established clock-frequency property.

Users, two for now, are also converted here.

Cc: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/arm/mach-pxa/icontrol.c         |  9 +++++----
 arch/arm/mach-pxa/zeus.c             |  9 +++++----
 drivers/net/can/spi/mcp251x.c        | 19 ++++++++-----------
 include/linux/can/platform/mcp251x.h | 22 ----------------------
 4 files changed, 18 insertions(+), 41 deletions(-)
 delete mode 100644 include/linux/can/platform/mcp251x.h

diff --git a/arch/arm/mach-pxa/icontrol.c b/arch/arm/mach-pxa/icontrol.c
index 865b10344ea2..aa4ccb9bb1c1 100644
--- a/arch/arm/mach-pxa/icontrol.c
+++ b/arch/arm/mach-pxa/icontrol.c
@@ -12,6 +12,7 @@
 
 #include <linux/irq.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/gpio.h>
 
 #include <asm/mach-types.h>
@@ -22,7 +23,6 @@
 
 #include <linux/spi/spi.h>
 #include <linux/spi/pxa2xx_spi.h>
-#include <linux/can/platform/mcp251x.h>
 #include <linux/regulator/machine.h>
 
 #include "generic.h"
@@ -69,8 +69,9 @@ static struct pxa2xx_spi_chip mcp251x_chip_info4 = {
 	.gpio_cs        = ICONTROL_MCP251x_nCS4
 };
 
-static struct mcp251x_platform_data mcp251x_info = {
-	.oscillator_frequency = 16E6,
+static const struct property_entry mcp251x_properties = {
+	PROPERTY_ENTRY_U32("clock-frequency", 16000000),
+	{}
 };
 
 static struct spi_board_info mcp251x_board_info[] = {
@@ -79,7 +80,7 @@ static struct spi_board_info mcp251x_board_info[] = {
 		.max_speed_hz    = 6500000,
 		.bus_num         = 3,
 		.chip_select     = 0,
-		.platform_data   = &mcp251x_info,
+		.properties      = &mcp251x_properties,
 		.controller_data = &mcp251x_chip_info1,
 		.irq             = PXA_GPIO_TO_IRQ(ICONTROL_MCP251x_nIRQ1)
 	},
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index da113c8eefbf..645500ef427a 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -13,6 +13,7 @@
 #include <linux/leds.h>
 #include <linux/irq.h>
 #include <linux/pm.h>
+#include <linux/property.h>
 #include <linux/gpio.h>
 #include <linux/gpio/machine.h>
 #include <linux/serial_8250.h>
@@ -27,7 +28,6 @@
 #include <linux/platform_data/i2c-pxa.h>
 #include <linux/platform_data/pca953x.h>
 #include <linux/apm-emulation.h>
-#include <linux/can/platform/mcp251x.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 
@@ -428,14 +428,15 @@ static struct gpiod_lookup_table can_regulator_gpiod_table = {
 	},
 };
 
-static struct mcp251x_platform_data zeus_mcp2515_pdata = {
-	.oscillator_frequency	= 16*1000*1000,
+static const struct property_entry mcp251x_properties = {
+	PROPERTY_ENTRY_U32("clock-frequency", 16000000),
+	{}
 };
 
 static struct spi_board_info zeus_spi_board_info[] = {
 	[0] = {
 		.modalias	= "mcp2515",
-		.platform_data	= &zeus_mcp2515_pdata,
+		.properties	= &mcp251x_properties,
 		.irq		= PXA_GPIO_TO_IRQ(ZEUS_CAN_GPIO),
 		.max_speed_hz	= 1*1000*1000,
 		.bus_num	= 3,
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 6ee0ea51399a..3a4d7089dc7c 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -20,29 +20,26 @@
  *
  * Your platform definition file should specify something like:
  *
- * static struct mcp251x_platform_data mcp251x_info = {
- *         .oscillator_frequency = 8000000,
+ * static const struct property_entry mpc251x_properties[] = {
+ *         PROPERTY_ENTRY_U32("clock-frequency", 8000000),
+ *         {}
  * };
  *
  * static struct spi_board_info spi_board_info[] = {
  *         {
  *                 .modalias = "mcp2510",
  *			// "mcp2515" or "mcp25625" depending on your controller
- *                 .platform_data = &mcp251x_info,
+ *                 .properties = &mcp251x_properties,
  *                 .irq = IRQ_EINT13,
  *                 .max_speed_hz = 2*1000*1000,
  *                 .chip_select = 2,
  *         },
  * };
- *
- * Please see mcp251x.h for a description of the fields in
- * struct mcp251x_platform_data.
  */
 
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
 #include <linux/can/led.h>
-#include <linux/can/platform/mcp251x.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -1006,19 +1003,19 @@ MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
 static int mcp251x_can_probe(struct spi_device *spi)
 {
 	const void *match = device_get_match_data(&spi->dev);
-	struct mcp251x_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct net_device *net;
 	struct mcp251x_priv *priv;
 	struct clk *clk;
-	int freq, ret;
+	u32 freq;
+	int ret;
 
 	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
 	freq = clk_get_rate(clk);
-	if (freq == 0 && pdata)
-		freq = pdata->oscillator_frequency;
+	if (freq == 0)
+		device_property_read_u32(&spi->dev, "clock-frequency", &freq);
 
 	/* Sanity check */
 	if (freq < 1000000 || freq > 25000000)
diff --git a/include/linux/can/platform/mcp251x.h b/include/linux/can/platform/mcp251x.h
deleted file mode 100644
index 9e5ac27fb6c1..000000000000
--- a/include/linux/can/platform/mcp251x.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CAN_PLATFORM_MCP251X_H
-#define _CAN_PLATFORM_MCP251X_H
-
-/*
- *
- * CAN bus driver for Microchip 251x CAN Controller with SPI Interface
- *
- */
-
-#include <linux/spi/spi.h>
-
-/*
- * struct mcp251x_platform_data - MCP251X SPI CAN controller platform data
- * @oscillator_frequency:       - oscillator frequency in Hz
- */
-
-struct mcp251x_platform_data {
-	unsigned long oscillator_frequency;
-};
-
-#endif /* !_CAN_PLATFORM_MCP251X_H */
-- 
2.23.0.rc1

