Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63465A2650
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344252AbiHZK5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344153AbiHZK5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:57:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E7778221
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:56:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0w-0002uN-7i; Fri, 26 Aug 2022 12:56:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0u-0024Yf-QF; Fri, 26 Aug 2022 12:56:36 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0t-00GB3D-Hv; Fri, 26 Aug 2022 12:56:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 09/17] net: dsa: microchip: add support for regmap_access_tables
Date:   Fri, 26 Aug 2022 12:56:26 +0200
Message-Id: <20220826105634.3855578-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826105634.3855578-1-o.rempel@pengutronix.de>
References: <20220826105634.3855578-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is complex driver with support for different chips with different
layouts. To detect at least some bugs earlier, we should validate register
accesses by using regmap_access_table support.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 46 +++++++++++++++++++++++---
 drivers/net/dsa/microchip/ksz_spi.c    |  3 ++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 62b9499afca58..4491cedd32c32 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -62,6 +62,8 @@ struct ksz_chip_data {
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
 	bool internal_phy[KSZ_MAX_NUM_PORTS];
 	bool gbit_capable[KSZ_MAX_NUM_PORTS];
+	const struct regmap_access_table *wr_table;
+	const struct regmap_access_table *rd_table;
 };
 
 struct ksz_port {
@@ -333,6 +335,10 @@ static inline int ksz_read8(struct ksz_device *dev, u32 reg, u8 *val)
 	unsigned int value;
 	int ret = regmap_read(dev->regmap[0], reg, &value);
 
+	if (ret)
+		dev_err(dev->dev, "can't read 8bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
 	*val = value;
 	return ret;
 }
@@ -342,6 +348,10 @@ static inline int ksz_read16(struct ksz_device *dev, u32 reg, u16 *val)
 	unsigned int value;
 	int ret = regmap_read(dev->regmap[1], reg, &value);
 
+	if (ret)
+		dev_err(dev->dev, "can't read 16bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
 	*val = value;
 	return ret;
 }
@@ -351,6 +361,10 @@ static inline int ksz_read32(struct ksz_device *dev, u32 reg, u32 *val)
 	unsigned int value;
 	int ret = regmap_read(dev->regmap[2], reg, &value);
 
+	if (ret)
+		dev_err(dev->dev, "can't read 32bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
 	*val = value;
 	return ret;
 }
@@ -361,7 +375,10 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
 	int ret;
 
 	ret = regmap_bulk_read(dev->regmap[2], reg, value, 2);
-	if (!ret)
+	if (ret)
+		dev_err(dev->dev, "can't read 64bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+	else
 		*val = (u64)value[0] << 32 | value[1];
 
 	return ret;
@@ -369,17 +386,38 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
 
 static inline int ksz_write8(struct ksz_device *dev, u32 reg, u8 value)
 {
-	return regmap_write(dev->regmap[0], reg, value);
+	int ret;
+
+	ret = regmap_write(dev->regmap[0], reg, value);
+	if (ret)
+		dev_err(dev->dev, "can't write 8bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
 }
 
 static inline int ksz_write16(struct ksz_device *dev, u32 reg, u16 value)
 {
-	return regmap_write(dev->regmap[1], reg, value);
+	int ret;
+
+	ret = regmap_write(dev->regmap[1], reg, value);
+	if (ret)
+		dev_err(dev->dev, "can't write 16bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
 }
 
 static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 {
-	return regmap_write(dev->regmap[2], reg, value);
+	int ret;
+
+	ret = regmap_write(dev->regmap[2], reg, value);
+	if (ret)
+		dev_err(dev->dev, "can't write 32bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
 }
 
 static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 746b725b09ec4..44c2d99124066 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -66,7 +66,10 @@ static int ksz_spi_probe(struct spi_device *spi)
 	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
 		rc = regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
+		rc.wr_table = chip->wr_table;
+		rc.rd_table = chip->rd_table;
 		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
+
 		if (IS_ERR(dev->regmap[i])) {
 			ret = PTR_ERR(dev->regmap[i]);
 			dev_err(&spi->dev,
-- 
2.30.2

