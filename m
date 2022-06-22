Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D07554934
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357451AbiFVJLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357290AbiFVJLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:11:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5D101F2;
        Wed, 22 Jun 2022 02:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888993; x=1687424993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VyB9uEmbEGgRfy9izhRRCPPteqJC2UkXkoS0fuRQiEU=;
  b=VXnmshyOmJ5jHySF8TZZxY6O5qdPWQTBAI2x7x4l8jjgz92UdYLWP+Wg
   U6+TSvYlC0mvpGia6vRcgiyaWCE7JtW+CSwteNpL4yKSVos7qTDv625MT
   VEjqjmXSZX8wJjYSnIOvZVuMNf4nTZAj8XJVrwT6sazHefzso4Sr8ZjSY
   xvoe9t0VfktTx5JzZJDeAlVpMBFKu+0bjhYsDjAjzxe98s8SndYNT5gcz
   MmSbN4eYJGsI3ALtIAcX57q7r4h5KmBSQMt8Cdfq1r2sWDh85iAOVa018
   gy156KZ0JsCXLWZc+llsHNT2OxvJV3gV9BNo01Mg7kMzWlwchavHEnjaW
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="161496483"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:09:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:09:50 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:09:46 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 13/13] net: dsa: microchip: common ksz_spi_probe for ksz switches
Date:   Wed, 22 Jun 2022 14:34:25 +0530
Message-ID: <20220622090425.17709-14-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now, there are two spi probes, one ksz8795_spi.c and other
ksz9477_spi.c. This patch combines two files into single ksz_spi.c. The
difference between the two are regmap config and struct ksz8. The regmap
config is assigned based on the platform data. And struct ksz8 is left
untouched, as it is used only ksz8795.c. It can be used for all
other switches also in future.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig             |  16 +-
 drivers/net/dsa/microchip/Makefile            |   3 +-
 drivers/net/dsa/microchip/ksz9477_spi.c       | 150 ------------------
 .../microchip/{ksz8795_spi.c => ksz_spi.c}    |  83 +++++++---
 4 files changed, 69 insertions(+), 183 deletions(-)
 delete mode 100644 drivers/net/dsa/microchip/ksz9477_spi.c
 rename drivers/net/dsa/microchip/{ksz8795_spi.c => ksz_spi.c} (61%)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index d21ff069e5aa..2edb88080790 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -8,29 +8,19 @@ menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
 	  KSZ8795/KSZ88x3 switch chips.
 
 config NET_DSA_MICROCHIP_KSZ9477_I2C
-	tristate "KSZ9477 series I2C connected switch driver"
+	tristate "KSZ series I2C connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && I2C
 	select REGMAP_I2C
 	help
 	  Select to enable support for registering switches configured through I2C.
 
-config NET_DSA_MICROCHIP_KSZ9477_SPI
-	tristate "KSZ9477 series SPI connected switch driver"
+config NET_DSA_MICROCHIP_KSZ_SPI
+	tristate "KSZ series SPI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
 	select REGMAP_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
 
-config NET_DSA_MICROCHIP_KSZ8795_SPI
-	tristate "KSZ8795 series SPI connected switch driver"
-	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
-	select REGMAP_SPI
-	help
-	  This driver accesses KSZ8795 chip through SPI.
-
-	  It is required to use the KSZ8795 switch driver as the only access
-	  is through SPI.
-
 config NET_DSA_MICROCHIP_KSZ8863_SMI
 	tristate "KSZ series SMI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 4cf4755e6426..b2ba7c1bcb93 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -4,6 +4,5 @@ ksz_switch-objs := ksz_common.o
 ksz_switch-objs += ksz9477.o
 ksz_switch-objs += ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
-obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
-obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_SPI)		+= ksz_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
deleted file mode 100644
index 2ee0601bc014..000000000000
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ /dev/null
@@ -1,150 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Microchip KSZ9477 series register access through SPI
- *
- * Copyright (C) 2017-2019 Microchip Technology Inc.
- */
-
-#include <asm/unaligned.h>
-
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/regmap.h>
-#include <linux/spi/spi.h>
-
-#include "ksz_common.h"
-
-#define SPI_ADDR_SHIFT			24
-#define SPI_ADDR_ALIGN			3
-#define SPI_TURNAROUND_SHIFT		5
-
-KSZ_REGMAP_TABLE(ksz9477, 32, SPI_ADDR_SHIFT,
-		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
-
-static int ksz9477_spi_probe(struct spi_device *spi)
-{
-	struct regmap_config rc;
-	struct ksz_device *dev;
-	int i, ret;
-
-	dev = ksz_switch_alloc(&spi->dev, spi);
-	if (!dev)
-		return -ENOMEM;
-
-	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
-		rc = ksz9477_regmap_config[i];
-		rc.lock_arg = &dev->regmap_mutex;
-		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
-		if (IS_ERR(dev->regmap[i])) {
-			ret = PTR_ERR(dev->regmap[i]);
-			dev_err(&spi->dev,
-				"Failed to initialize regmap%i: %d\n",
-				ksz9477_regmap_config[i].val_bits, ret);
-			return ret;
-		}
-	}
-
-	if (spi->dev.platform_data)
-		dev->pdata = spi->dev.platform_data;
-
-	/* setup spi */
-	spi->mode = SPI_MODE_3;
-	ret = spi_setup(spi);
-	if (ret)
-		return ret;
-
-	ret = ksz_switch_register(dev);
-
-	/* Main DSA driver may not be started yet. */
-	if (ret)
-		return ret;
-
-	spi_set_drvdata(spi, dev);
-
-	return 0;
-}
-
-static void ksz9477_spi_remove(struct spi_device *spi)
-{
-	struct ksz_device *dev = spi_get_drvdata(spi);
-
-	if (dev)
-		ksz_switch_remove(dev);
-
-	spi_set_drvdata(spi, NULL);
-}
-
-static void ksz9477_spi_shutdown(struct spi_device *spi)
-{
-	struct ksz_device *dev = spi_get_drvdata(spi);
-
-	if (dev)
-		dsa_switch_shutdown(dev->ds);
-
-	spi_set_drvdata(spi, NULL);
-}
-
-static const struct of_device_id ksz9477_dt_ids[] = {
-	{
-		.compatible = "microchip,ksz9477",
-		.data = &ksz_switch_chips[KSZ9477]
-	},
-	{
-		.compatible = "microchip,ksz9897",
-		.data = &ksz_switch_chips[KSZ9897]
-	},
-	{
-		.compatible = "microchip,ksz9893",
-		.data = &ksz_switch_chips[KSZ9893]
-	},
-	{
-		.compatible = "microchip,ksz9563",
-		.data = &ksz_switch_chips[KSZ9893]
-	},
-	{
-		.compatible = "microchip,ksz8563",
-		.data = &ksz_switch_chips[KSZ9893]
-	},
-	{
-		.compatible = "microchip,ksz9567",
-		.data = &ksz_switch_chips[KSZ9567]
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
-
-static const struct spi_device_id ksz9477_spi_ids[] = {
-	{ "ksz9477" },
-	{ "ksz9897" },
-	{ "ksz9893" },
-	{ "ksz9563" },
-	{ "ksz8563" },
-	{ "ksz9567" },
-	{ },
-};
-MODULE_DEVICE_TABLE(spi, ksz9477_spi_ids);
-
-static struct spi_driver ksz9477_spi_driver = {
-	.driver = {
-		.name	= "ksz9477-switch",
-		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ksz9477_dt_ids),
-	},
-	.id_table = ksz9477_spi_ids,
-	.probe	= ksz9477_spi_probe,
-	.remove	= ksz9477_spi_remove,
-	.shutdown = ksz9477_spi_shutdown,
-};
-
-module_spi_driver(ksz9477_spi_driver);
-
-MODULE_ALIAS("spi:ksz9477");
-MODULE_ALIAS("spi:ksz9897");
-MODULE_ALIAS("spi:ksz9893");
-MODULE_ALIAS("spi:ksz9563");
-MODULE_ALIAS("spi:ksz8563");
-MODULE_ALIAS("spi:ksz9567");
-MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
-MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch SPI access Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
similarity index 61%
rename from drivers/net/dsa/microchip/ksz8795_spi.c
rename to drivers/net/dsa/microchip/ksz_spi.c
index 9d74e59624a6..344ff92db099 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Microchip KSZ8795 series register access through SPI
+ * Microchip ksz series register access through SPI
  *
  * Copyright (C) 2017 Microchip Technology Inc.
  *	Tristram Ha <Tristram.Ha@microchip.com>
@@ -25,13 +25,20 @@
 #define KSZ8863_SPI_ADDR_ALIGN			8
 #define KSZ8863_SPI_TURNAROUND_SHIFT		0
 
+#define KSZ9477_SPI_ADDR_SHIFT			24
+#define KSZ9477_SPI_ADDR_ALIGN			3
+#define KSZ9477_SPI_TURNAROUND_SHIFT		5
+
 KSZ_REGMAP_TABLE(ksz8795, 16, KSZ8795_SPI_ADDR_SHIFT,
 		 KSZ8795_SPI_TURNAROUND_SHIFT, KSZ8795_SPI_ADDR_ALIGN);
 
 KSZ_REGMAP_TABLE(ksz8863, 16, KSZ8863_SPI_ADDR_SHIFT,
 		 KSZ8863_SPI_TURNAROUND_SHIFT, KSZ8863_SPI_ADDR_ALIGN);
 
-static int ksz8795_spi_probe(struct spi_device *spi)
+KSZ_REGMAP_TABLE(ksz9477, 32, KSZ9477_SPI_ADDR_SHIFT,
+		 KSZ9477_SPI_TURNAROUND_SHIFT, KSZ9477_SPI_ADDR_ALIGN);
+
+static int ksz_spi_probe(struct spi_device *spi)
 {
 	const struct regmap_config *regmap_config;
 	const struct ksz_chip_data *chip;
@@ -57,8 +64,12 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 
 	if (chip->chip_id == KSZ8830_CHIP_ID)
 		regmap_config = ksz8863_regmap_config;
-	else
+	else if (chip->chip_id == KSZ8795_CHIP_ID ||
+		 chip->chip_id == KSZ8794_CHIP_ID ||
+		 chip->chip_id == KSZ8765_CHIP_ID)
 		regmap_config = ksz8795_regmap_config;
+	else
+		regmap_config = ksz9477_regmap_config;
 
 	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
 		rc = regmap_config[i];
@@ -93,7 +104,7 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 	return 0;
 }
 
-static void ksz8795_spi_remove(struct spi_device *spi)
+static void ksz_spi_remove(struct spi_device *spi)
 {
 	struct ksz_device *dev = spi_get_drvdata(spi);
 
@@ -103,7 +114,7 @@ static void ksz8795_spi_remove(struct spi_device *spi)
 	spi_set_drvdata(spi, NULL);
 }
 
-static void ksz8795_spi_shutdown(struct spi_device *spi)
+static void ksz_spi_shutdown(struct spi_device *spi)
 {
 	struct ksz_device *dev = spi_get_drvdata(spi);
 
@@ -118,7 +129,7 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 	spi_set_drvdata(spi, NULL);
 }
 
-static const struct of_device_id ksz8795_dt_ids[] = {
+static const struct of_device_id ksz_dt_ids[] = {
 	{
 		.compatible = "microchip,ksz8765",
 		.data = &ksz_switch_chips[KSZ8765]
@@ -139,34 +150,70 @@ static const struct of_device_id ksz8795_dt_ids[] = {
 		.compatible = "microchip,ksz8873",
 		.data = &ksz_switch_chips[KSZ8830]
 	},
+	{
+		.compatible = "microchip,ksz9477",
+		.data = &ksz_switch_chips[KSZ9477]
+	},
+	{
+		.compatible = "microchip,ksz9897",
+		.data = &ksz_switch_chips[KSZ9897]
+	},
+	{
+		.compatible = "microchip,ksz9893",
+		.data = &ksz_switch_chips[KSZ9893]
+	},
+	{
+		.compatible = "microchip,ksz9563",
+		.data = &ksz_switch_chips[KSZ9893]
+	},
+	{
+		.compatible = "microchip,ksz8563",
+		.data = &ksz_switch_chips[KSZ9893]
+	},
+	{
+		.compatible = "microchip,ksz9567",
+		.data = &ksz_switch_chips[KSZ9567]
+	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
+MODULE_DEVICE_TABLE(of, ksz_dt_ids);
 
-static const struct spi_device_id ksz8795_spi_ids[] = {
+static const struct spi_device_id ksz_spi_ids[] = {
 	{ "ksz8765" },
 	{ "ksz8794" },
 	{ "ksz8795" },
 	{ "ksz8863" },
 	{ "ksz8873" },
+	{ "ksz9477" },
+	{ "ksz9897" },
+	{ "ksz9893" },
+	{ "ksz9563" },
+	{ "ksz8563" },
+	{ "ksz9567" },
 	{ },
 };
-MODULE_DEVICE_TABLE(spi, ksz8795_spi_ids);
+MODULE_DEVICE_TABLE(spi, ksz_spi_ids);
 
-static struct spi_driver ksz8795_spi_driver = {
+static struct spi_driver ksz_spi_driver = {
 	.driver = {
-		.name	= "ksz8795-switch",
+		.name	= "ksz-switch",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ksz8795_dt_ids),
+		.of_match_table = of_match_ptr(ksz_dt_ids),
 	},
-	.id_table = ksz8795_spi_ids,
-	.probe	= ksz8795_spi_probe,
-	.remove	= ksz8795_spi_remove,
-	.shutdown = ksz8795_spi_shutdown,
+	.id_table = ksz_spi_ids,
+	.probe	= ksz_spi_probe,
+	.remove	= ksz_spi_remove,
+	.shutdown = ksz_spi_shutdown,
 };
 
-module_spi_driver(ksz8795_spi_driver);
+module_spi_driver(ksz_spi_driver);
 
+MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9897");
+MODULE_ALIAS("spi:ksz9893");
+MODULE_ALIAS("spi:ksz9563");
+MODULE_ALIAS("spi:ksz8563");
+MODULE_ALIAS("spi:ksz9567");
 MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
-MODULE_DESCRIPTION("Microchip KSZ8795 Series Switch SPI Driver");
+MODULE_DESCRIPTION("Microchip ksz Series Switch SPI Driver");
 MODULE_LICENSE("GPL");
-- 
2.36.1

