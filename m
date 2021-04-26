Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888336B3FF
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhDZNUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhDZNUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:20:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF28C06175F
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:19:21 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18s-0004Ub-CJ; Mon, 26 Apr 2021 15:19:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb18r-0006mu-D6; Mon, 26 Apr 2021 15:19:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v7 5/9] net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
Date:   Mon, 26 Apr 2021 15:19:07 +0200
Message-Id: <20210426131911.25976-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210426131911.25976-1-o.rempel@pengutronix.de>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
switches using the SPI Interface.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---
v1 -> v2: - this glue was not implemented
v2 -> v3: - this glue was part of previous bigger patch
v3 -> v4: - this glue was moved to this separate patch
v4 -> v5: - added reviewed by from f.fainelli
          - using device_get_match_data instead of own matching code
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 44 ++++++++++++++++++-------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 45420c07c99f..85ba12aa82d8 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -14,34 +14,52 @@
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
 
 static int ksz8795_spi_probe(struct spi_device *spi)
 {
+	const struct regmap_config *regmap_config;
+	struct device *ddev = &spi->dev;
 	struct regmap_config rc;
 	struct ksz_device *dev;
-	int i, ret;
+	struct ksz8 *ksz8;
+	int i, ret = 0;
 
-	dev = ksz_switch_alloc(&spi->dev, spi);
+	ksz8 = devm_kzalloc(&spi->dev, sizeof(struct ksz8), GFP_KERNEL);
+	ksz8->priv = spi;
+
+	dev = ksz_switch_alloc(&spi->dev, ksz8);
 	if (!dev)
 		return -ENOMEM;
 
+	regmap_config = device_get_match_data(ddev);
+	if (!regmap_config)
+		return -EINVAL;
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
@@ -85,9 +103,11 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 }
 
 static const struct of_device_id ksz8795_dt_ids[] = {
-	{ .compatible = "microchip,ksz8765" },
-	{ .compatible = "microchip,ksz8794" },
-	{ .compatible = "microchip,ksz8795" },
+	{ .compatible = "microchip,ksz8765", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8794", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8795", .data = &ksz8795_regmap_config },
+	{ .compatible = "microchip,ksz8863", .data = &ksz8863_regmap_config },
+	{ .compatible = "microchip,ksz8873", .data = &ksz8863_regmap_config },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
-- 
2.29.2

