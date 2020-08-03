Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6021B239F3F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgHCFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgHCFpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637ACC0617A4
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005JK-QZ; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THL-0005UN-1I; Mon, 03 Aug 2020 07:44:55 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 10/11] net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
Date:   Mon,  3 Aug 2020 07:44:41 +0200
Message-Id: <20200803054442.20089-11-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
switches using the SPI Interface.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - this glue was not implemented
v2 -> v3: - this glue was part of previous bigger patch
v3 -> v4: - this glue was moved to this separate patch

 drivers/net/dsa/microchip/ksz8795_spi.c | 62 ++++++++++++++++++-------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 3bab09c46f6a7bd..d13a83c27428cdc 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -14,34 +14,70 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
+#include "ksz8.h"
 #include "ksz_common.h"
 
-#define SPI_ADDR_SHIFT			12
-#define SPI_ADDR_ALIGN			3
-#define SPI_TURNAROUND_SHIFT		1
+#define KSZ8795_SPI_ADDR_SHIFT			12
+#define KSZ8795_SPI_ADDR_ALIGN			3
+#define KSZ8795_SPI_TURNAROUND_SHIFT		1
 
-KSZ_REGMAP_TABLE(ksz8795, 16, SPI_ADDR_SHIFT,
-		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
+#define KSZ8863_SPI_ADDR_SHIFT			8
+#define KSZ8863_SPI_ADDR_ALIGN			8
+#define KSZ8863_SPI_TURNAROUND_SHIFT		0
+
+KSZ_REGMAP_TABLE(ksz8795, 16, KSZ8795_SPI_ADDR_SHIFT,
+		 KSZ8795_SPI_TURNAROUND_SHIFT, KSZ8795_SPI_ADDR_ALIGN);
+
+KSZ_REGMAP_TABLE(ksz8863, 16, KSZ8863_SPI_ADDR_SHIFT,
+		 KSZ8863_SPI_TURNAROUND_SHIFT, KSZ8863_SPI_ADDR_ALIGN);
+
+static const struct of_device_id ksz8795_dt_ids[] = {
+	{ .compatible = "microchip,ksz8765", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8794", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8795", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8863", .data = &ksz8863_regmap_config },
+	{ .compatible = "microchip,ksz8873", .data = &ksz8863_regmap_config },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
 
 static int ksz8795_spi_probe(struct spi_device *spi)
 {
+	const struct regmap_config *regmap_config;
+	const struct of_device_id *match;
+	struct device *ddev = &spi->dev;
+	struct ksz8 *ksz8;
 	struct regmap_config rc;
 	struct ksz_device *dev;
-	int i, ret;
+	int i, ret = 0;
 
-	dev = ksz_switch_alloc(&spi->dev, spi);
+	ksz8 = devm_kzalloc(&spi->dev, sizeof(struct ksz8), GFP_KERNEL);
+	ksz8->priv = spi;
+
+	dev = ksz_switch_alloc(&spi->dev, ksz8);
 	if (!dev)
 		return -ENOMEM;
 
+	regmap_config = ksz8795_regmap_config;
+
+	if (ddev->of_node) {
+		match = of_match_node(ksz8795_dt_ids, ddev->of_node);
+		if (!match)
+			return -ENOTSUPP;
+
+		if (match->data)
+			regmap_config = match->data;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
-		rc = ksz8795_regmap_config[i];
+		rc = regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
 		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
 		if (IS_ERR(dev->regmap[i])) {
 			ret = PTR_ERR(dev->regmap[i]);
 			dev_err(&spi->dev,
 				"Failed to initialize regmap%i: %d\n",
-				ksz8795_regmap_config[i].val_bits, ret);
+				regmap_config[i].val_bits, ret);
 			return ret;
 		}
 	}
@@ -78,14 +114,6 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 		dev->dev_ops->shutdown(dev);
 }
 
-static const struct of_device_id ksz8795_dt_ids[] = {
-	{ .compatible = "microchip,ksz8765" },
-	{ .compatible = "microchip,ksz8794" },
-	{ .compatible = "microchip,ksz8795" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
-
 static struct spi_driver ksz8795_spi_driver = {
 	.driver = {
 		.name	= "ksz8795-switch",
-- 
2.28.0

