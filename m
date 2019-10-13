Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C55D57D4
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfJMTdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:33:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54448 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMTdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:33:00 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46rsKh1Jzxz1rY5p;
        Sun, 13 Oct 2019 21:32:56 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46rsKh0fxqz1qqkD;
        Sun, 13 Oct 2019 21:32:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id WFLE3EYeqjcm; Sun, 13 Oct 2019 21:32:54 +0200 (CEST)
X-Auth-Info: 51IkjQHMgEyeys7VLR3pl0nhmgVx5xZFfYAB2N1QGG0=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Oct 2019 21:32:54 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH V2 2/2] net: dsa: microchip: Add shared regmap mutex
Date:   Sun, 13 Oct 2019 21:32:38 +0200
Message-Id: <20191013193238.1638-2-marex@denx.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191013193238.1638-1-marex@denx.de>
References: <20191013193238.1638-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ driver uses one regmap per register width (8/16/32), each with
it's own lock, but accessing the same set of registers. In theory, it
is possible to create a race condition between these regmaps, although
the underlying bus (SPI or I2C) locking should assure nothing bad will
really happen and the accesses would be correct.

To make the driver do the right thing, add one single shared mutex for
all the regmaps used by the driver instead. This assures that even if
some future hardware is on a bus which does not serialize the accesses
the same way SPI or I2C does, nothing bad will happen.

Note that the status_mutex was unused and only initied, hence it was
renamed and repurposed as the regmap mutex.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
V2: Move ksz_regmap_{,un}lock() to ksz_common.h and turn it from void
    to static inline void. This fixes the following build failure:
    ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
    ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
    ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
    ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
    ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!
    ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!
---
 drivers/net/dsa/microchip/ksz8795_spi.c |  7 ++++---
 drivers/net/dsa/microchip/ksz9477_i2c.c |  6 ++++--
 drivers/net/dsa/microchip/ksz9477_spi.c |  6 ++++--
 drivers/net/dsa/microchip/ksz_common.c  |  2 +-
 drivers/net/dsa/microchip/ksz_common.h  | 16 +++++++++++++++-
 5 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index d0f8153e86b7..614404c40cba 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -26,6 +26,7 @@ KSZ_REGMAP_TABLE(ksz8795, 16, SPI_ADDR_SHIFT,
 static int ksz8795_spi_probe(struct spi_device *spi)
 {
 	struct ksz_device *dev;
+	struct regmap_config rc;
 	int i, ret;
 
 	dev = ksz_switch_alloc(&spi->dev, spi);
@@ -33,9 +34,9 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
-		dev->regmap[i] = devm_regmap_init_spi(spi,
-						      &ksz8795_regmap_config
-						      [i]);
+		rc = ksz8795_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
 		if (IS_ERR(dev->regmap[i])) {
 			ret = PTR_ERR(dev->regmap[i]);
 			dev_err(&spi->dev,
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index b0a1595d780d..2cb178675b83 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -18,6 +18,7 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 			     const struct i2c_device_id *i2c_id)
 {
 	struct ksz_device *dev;
+	struct regmap_config rc;
 	int i, ret;
 
 	dev = ksz_switch_alloc(&i2c->dev, i2c);
@@ -25,8 +26,9 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
-		dev->regmap[i] = devm_regmap_init_i2c(i2c,
-					&ksz9477_regmap_config[i]);
+		rc = ksz9477_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init_i2c(i2c, &rc);
 		if (IS_ERR(dev->regmap[i])) {
 			ret = PTR_ERR(dev->regmap[i]);
 			dev_err(&i2c->dev,
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index f4198d6f72be..a39d2373eb3a 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -25,6 +25,7 @@ KSZ_REGMAP_TABLE(ksz9477, 32, SPI_ADDR_SHIFT,
 static int ksz9477_spi_probe(struct spi_device *spi)
 {
 	struct ksz_device *dev;
+	struct regmap_config rc;
 	int i, ret;
 
 	dev = ksz_switch_alloc(&spi->dev, spi);
@@ -32,8 +33,9 @@ static int ksz9477_spi_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
-		dev->regmap[i] = devm_regmap_init_spi(spi,
-					&ksz9477_regmap_config[i]);
+		rc = ksz9477_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
 		if (IS_ERR(dev->regmap[i])) {
 			ret = PTR_ERR(dev->regmap[i]);
 			dev_err(&spi->dev,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index b0b870f0c252..fe47180c908b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -436,7 +436,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	}
 
 	mutex_init(&dev->dev_mutex);
-	mutex_init(&dev->stats_mutex);
+	mutex_init(&dev->regmap_mutex);
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index dd60d0837fc6..d78e61114765 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,7 +47,7 @@ struct ksz_device {
 	const char *name;
 
 	struct mutex dev_mutex;		/* device access */
-	struct mutex stats_mutex;	/* status access */
+	struct mutex regmap_mutex;	/* regmap access */
 	struct mutex alu_mutex;		/* ALU access */
 	struct mutex vlan_mutex;	/* vlan access */
 	const struct ksz_dev_ops *dev_ops;
@@ -290,6 +290,18 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
+static inline void ksz_regmap_lock(void *__mtx)
+{
+	struct mutex *mtx = __mtx;
+	mutex_lock(mtx);
+}
+
+static inline void ksz_regmap_unlock(void *__mtx)
+{
+	struct mutex *mtx = __mtx;
+	mutex_unlock(mtx);
+}
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
@@ -314,6 +326,8 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 		.write_flag_mask =					\
 			KSZ_SPI_OP_FLAG_MASK(KSZ_SPI_OP_WR, swp,	\
 					     regbits, regpad),		\
+		.lock = ksz_regmap_lock,				\
+		.unlock = ksz_regmap_unlock,				\
 		.reg_format_endian = REGMAP_ENDIAN_BIG,			\
 		.val_format_endian = REGMAP_ENDIAN_BIG			\
 	}
-- 
2.23.0

