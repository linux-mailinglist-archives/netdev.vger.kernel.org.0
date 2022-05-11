Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2700C5230CB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbiEKKjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbiEKKi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:38:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F169C2D7;
        Wed, 11 May 2022 03:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265522; x=1683801522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iRuNsoYN5kE/jNLE+TVxStrQqQ9p4IuuoAsChWlrFmc=;
  b=i0GMblOB2FpW4M8/ImgGYOjN0SBRmzcTajm9farPY1ZH3ef/gP5JTiUZ
   F/ftzFovrQiFJiPUrLdrILRfaaTyXOLeHt1KjHaTOVQ141hS52XCR2Sru
   qwnzxeZQiDwjTpEbEWzxaWTPxm5cn4ePvmvZxjDMIRJ7E3eYaMjhSJlNC
   kuvtaHgRYTi9a8K2cG8UZoBxtauY09m3f1nUtNV/AQc6/XQ1dOC9oNtzW
   3oB8aRpmn1V7PpffjlrnV9rpPru2IyQthcL40cvdm6bjTLToMgaD6NwAJ
   4mO6/YfYriNmB67wmIgn+Bk8oCRNjffd7DwqJKPC07ePF56O8mjRfWWQN
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="158596656"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:38:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:38:40 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:38:35 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 3/9] net: dsa: microchip: perform the compatibility check for dev probed
Date:   Wed, 11 May 2022 16:07:49 +0530
Message-ID: <20220511103755.12553-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220511103755.12553-1-arun.ramadoss@microchip.com>
References: <20220511103755.12553-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch perform the compatibility check for the device after the chip
detect is done. It is to prevent the mismatch between the device
compatible specified in the device tree and actual device found during
the detect. The ksz9477 device doesn't use any .data in the
of_device_id. But the ksz8795 uses .data for assigning the regmap
between 8830 family and 87xx family switch. Changed the regmap
assignment based on the chip_id from the .data.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 37 ++++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz9477_i2c.c | 30 ++++++++++++++++----
 drivers/net/dsa/microchip/ksz9477_spi.c | 30 ++++++++++++++++----
 drivers/net/dsa/microchip/ksz_common.c  | 22 +++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  1 +
 5 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 5f8d94aee774..1ae1b1ee9f2a 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -31,9 +31,12 @@ KSZ_REGMAP_TABLE(ksz8795, 16, KSZ8795_SPI_ADDR_SHIFT,
 KSZ_REGMAP_TABLE(ksz8863, 16, KSZ8863_SPI_ADDR_SHIFT,
 		 KSZ8863_SPI_TURNAROUND_SHIFT, KSZ8863_SPI_ADDR_ALIGN);
 
+#define KSZ_88X3_FAMILY 0x8830
+
 static int ksz8795_spi_probe(struct spi_device *spi)
 {
 	const struct regmap_config *regmap_config;
+	const struct ksz_chip_data *chip;
 	struct device *ddev = &spi->dev;
 	struct regmap_config rc;
 	struct ksz_device *dev;
@@ -50,10 +53,15 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 	if (!dev)
 		return -ENOMEM;
 
-	regmap_config = device_get_match_data(ddev);
-	if (!regmap_config)
+	chip = device_get_match_data(ddev);
+	if (!chip)
 		return -EINVAL;
 
+	if (chip->chip_id == KSZ_88X3_FAMILY)
+		regmap_config = ksz8863_regmap_config;
+	else
+		regmap_config = ksz8795_regmap_config;
+
 	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
 		rc = regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
@@ -113,11 +121,26 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 }
 
 static const struct of_device_id ksz8795_dt_ids[] = {
-	{ .compatible = "microchip,ksz8765", .data = &ksz8795_regmap_config },
-	{ .compatible = "microchip,ksz8794", .data = &ksz8795_regmap_config },
-	{ .compatible = "microchip,ksz8795", .data = &ksz8795_regmap_config },
-	{ .compatible = "microchip,ksz8863", .data = &ksz8863_regmap_config },
-	{ .compatible = "microchip,ksz8873", .data = &ksz8863_regmap_config },
+	{
+		.compatible = "microchip,ksz8765",
+		.data = &ksz_switch_chips[KSZ8765]
+	},
+	{
+		.compatible = "microchip,ksz8794",
+		.data = &ksz_switch_chips[KSZ8794]
+	},
+	{
+		.compatible = "microchip,ksz8795",
+		.data = &ksz_switch_chips[KSZ8795]
+	},
+	{
+		.compatible = "microchip,ksz8863",
+		.data = &ksz_switch_chips[KSZ8830]
+	},
+	{
+		.compatible = "microchip,ksz8873",
+		.data = &ksz_switch_chips[KSZ8830]
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index cbc0b20e7e1b..faa3163c86b0 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -87,12 +87,30 @@ static const struct i2c_device_id ksz9477_i2c_id[] = {
 MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
 
 static const struct of_device_id ksz9477_dt_ids[] = {
-	{ .compatible = "microchip,ksz9477" },
-	{ .compatible = "microchip,ksz9897" },
-	{ .compatible = "microchip,ksz9893" },
-	{ .compatible = "microchip,ksz9563" },
-	{ .compatible = "microchip,ksz9567" },
-	{ .compatible = "microchip,ksz8563" },
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
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 87ca464dad32..1bc8b0cbe458 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -86,12 +86,30 @@ static void ksz9477_spi_shutdown(struct spi_device *spi)
 }
 
 static const struct of_device_id ksz9477_dt_ids[] = {
-	{ .compatible = "microchip,ksz9477" },
-	{ .compatible = "microchip,ksz9897" },
-	{ .compatible = "microchip,ksz9893" },
-	{ .compatible = "microchip,ksz9563" },
-	{ .compatible = "microchip,ksz8563" },
-	{ .compatible = "microchip,ksz9567" },
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
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4e1bed4759f2..4b5c2df4ae18 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -14,6 +14,7 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/of_device.h>
 #include <linux/of_net.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -225,6 +226,23 @@ static const struct ksz_chip_data *ksz_lookup_info(unsigned int prod_num)
 	return NULL;
 }
 
+static int ksz_check_device_id(struct ksz_device *dev)
+{
+	const struct ksz_chip_data *dt_chip_data;
+
+	dt_chip_data = of_device_get_match_data(dev->dev);
+
+	/* Check for Device Tree and Chip ID */
+	if (dt_chip_data->chip_id != dev->chip_id) {
+		dev_err(dev->dev,
+			"Device tree specifies chip %s but found %s, please fix it!\n",
+			dt_chip_data->dev_name, dev->info->dev_name);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 {
 	struct rtnl_link_stats64 *stats;
@@ -741,6 +759,10 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Update the compatible info with the probed one */
 	dev->info = info;
 
+	ret = ksz_check_device_id(dev);
+	if (ret)
+		return ret;
+
 	ret = dev->dev_ops->init(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 7d87738329de..d6c4c4b7f7bf 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -177,6 +177,7 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_get_stats64(struct dsa_switch *ds, int port,
 		     struct rtnl_link_stats64 *s);
+extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common DSA access functions */
 
-- 
2.33.0

