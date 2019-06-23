Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE850035
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfFXD2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:28:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60790 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfFXD2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:28:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45X6kC64D1z1rcrb;
        Mon, 24 Jun 2019 00:37:23 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45X6kC5rypz1qqkd;
        Mon, 24 Jun 2019 00:37:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id TZtBzAL4Ki-m; Mon, 24 Jun 2019 00:37:22 +0200 (CEST)
X-Auth-Info: SN/CqvdB2A1SEeEHOxqJ4b9n4Isj+oKOio7JM0qE03o=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 24 Jun 2019 00:37:22 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V3 07/10] net: dsa: microchip: Initial SPI regmap support
Date:   Mon, 24 Jun 2019 00:35:05 +0200
Message-Id: <20190623223508.2713-8-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623223508.2713-1-marex@denx.de>
References: <20190623223508.2713-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic SPI regmap support into the driver.

Previous patches unconver that ksz_spi_write() is always ever called
with len = 1, 2 or 4. We can thus drop the if (len > SPI_TX_BUF_LEN)
check and we can also drop the allocation of the txbuf which is part
of the driver data and wastes 256 bytes for no reason. Regmap covers
the whole thing now.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
V2: - Squash with "net: dsa: microchip: Remove dev->txbuf"
    - Use separate regmaps for 8/16/32bit registers
    - Increase the regmap size to 0xd00 to cover the entire register area
V3: - Rebase on next/master
    - Test on KSZ9477EVB
    - Increase regmap max register, to cover all switch registers
    - Correct regmap reg_bits value to match the hardware
    - Use cpu_to_be32() instead of cpu_to_le16() in register masks, since
      the KSZ9477 has some 32bit registers.
---
 drivers/net/dsa/microchip/Kconfig       |   1 +
 drivers/net/dsa/microchip/ksz9477_spi.c | 114 +++++++++++-------------
 drivers/net/dsa/microchip/ksz_priv.h    |   3 +-
 3 files changed, 52 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 2c3a6751bdaf..56790d544eb2 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_DSA_MICROCHIP_KSZ_COMMON
+	select REGMAP_SPI
 	tristate
 
 menuconfig NET_DSA_MICROCHIP_KSZ9477
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 49aeb92d36fc..77e3cb100eae 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -10,78 +10,54 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
 #include "ksz_priv.h"
 
-/* SPI frame opcodes */
-#define KS_SPIOP_RD			3
-#define KS_SPIOP_WR			2
-
 #define SPI_ADDR_SHIFT			24
-#define SPI_ADDR_MASK			(BIT(SPI_ADDR_SHIFT) - 1)
+#define SPI_ADDR_ALIGN			3
 #define SPI_TURNAROUND_SHIFT		5
 
-/* Enough to read all switch port registers. */
-#define SPI_TX_BUF_LEN			0x100
-
-static u32 ksz9477_spi_cmd(u32 reg, bool read)
-{
-	u32 txbuf;
-
-	txbuf = reg & SPI_ADDR_MASK;
-	txbuf |= (read ? KS_SPIOP_RD : KS_SPIOP_WR) << SPI_ADDR_SHIFT;
-	txbuf <<= SPI_TURNAROUND_SHIFT;
-	txbuf = cpu_to_be32(txbuf);
-
-	return txbuf;
-}
-
-static int ksz9477_spi_read_reg(struct spi_device *spi, u32 reg, u8 *val,
-				unsigned int len)
-{
-	u32 txbuf = ksz9477_spi_cmd(reg, true);
-
-	return spi_write_then_read(spi, &txbuf, 4, val, len);
-}
-
-static int ksz9477_spi_write_reg(struct spi_device *spi, u32 reg, u8 *val,
-				 unsigned int len)
-{
-	u32 *txbuf = (u32 *)val;
-
-	*txbuf = ksz9477_spi_cmd(reg, false);
-
-	return spi_write(spi, txbuf, 4 + len);
-}
-
-static int ksz_spi_read(struct ksz_device *dev, u32 reg, u8 *data,
-			unsigned int len)
-{
-	struct spi_device *spi = dev->priv;
-
-	return ksz9477_spi_read_reg(spi, reg, data, len);
-}
-
-static int ksz_spi_write(struct ksz_device *dev, u32 reg, void *data,
-			 unsigned int len)
-{
-	struct spi_device *spi = dev->priv;
+/* SPI frame opcodes */
+#define KS_SPIOP_RD			3
+#define KS_SPIOP_WR			2
 
-	if (len > SPI_TX_BUF_LEN)
-		len = SPI_TX_BUF_LEN;
-	memcpy(&dev->txbuf[4], data, len);
-	return ksz9477_spi_write_reg(spi, reg, dev->txbuf, len);
-}
+#define KS_SPIOP_FLAG_MASK(opcode)		\
+	cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
+
+#define KSZ_REGMAP_COMMON(width)					\
+	{								\
+		.val_bits = (width),					\
+		.reg_stride = (width) / 8,				\
+		.reg_bits = SPI_ADDR_SHIFT + SPI_ADDR_ALIGN,		\
+		.pad_bits = SPI_TURNAROUND_SHIFT,			\
+		.max_register = BIT(SPI_ADDR_SHIFT) - 1,		\
+		.cache_type = REGCACHE_NONE,				\
+		.read_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_RD),	\
+		.write_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_WR),	\
+		.reg_format_endian = REGMAP_ENDIAN_BIG,			\
+		.val_format_endian = REGMAP_ENDIAN_BIG			\
+	}
+
+static const struct regmap_config ksz9477_regmap_config[] = {
+	KSZ_REGMAP_COMMON(8),
+	KSZ_REGMAP_COMMON(16),
+	KSZ_REGMAP_COMMON(32),
+};
 
 static int ksz_spi_read8(struct ksz_device *dev, u32 reg, u8 *val)
 {
-	return ksz_spi_read(dev, reg, val, 1);
+	unsigned int value;
+	int ret = regmap_read(dev->regmap, reg, &value);
+
+	*val = value;
+	return ret;
 }
 
 static int ksz_spi_read16(struct ksz_device *dev, u32 reg, u16 *val)
 {
-	int ret = ksz_spi_read(dev, reg, (u8 *)val, 2);
+	int ret = regmap_bulk_read(dev->regmap, reg, val, 2);
 
 	if (!ret)
 		*val = be16_to_cpu(*val);
@@ -91,7 +67,7 @@ static int ksz_spi_read16(struct ksz_device *dev, u32 reg, u16 *val)
 
 static int ksz_spi_read32(struct ksz_device *dev, u32 reg, u32 *val)
 {
-	int ret = ksz_spi_read(dev, reg, (u8 *)val, 4);
+	int ret = regmap_bulk_read(dev->regmap, reg, val, 4);
 
 	if (!ret)
 		*val = be32_to_cpu(*val);
@@ -101,19 +77,19 @@ static int ksz_spi_read32(struct ksz_device *dev, u32 reg, u32 *val)
 
 static int ksz_spi_write8(struct ksz_device *dev, u32 reg, u8 value)
 {
-	return ksz_spi_write(dev, reg, &value, 1);
+	return regmap_write(dev->regmap, reg, value);
 }
 
 static int ksz_spi_write16(struct ksz_device *dev, u32 reg, u16 value)
 {
 	value = cpu_to_be16(value);
-	return ksz_spi_write(dev, reg, &value, 2);
+	return regmap_bulk_write(dev->regmap, reg, &value, 2);
 }
 
 static int ksz_spi_write32(struct ksz_device *dev, u32 reg, u32 value)
 {
 	value = cpu_to_be32(value);
-	return ksz_spi_write(dev, reg, &value, 4);
+	return regmap_bulk_write(dev->regmap, reg, &value, 4);
 }
 
 static const struct ksz_io_ops ksz9477_spi_ops = {
@@ -128,17 +104,27 @@ static const struct ksz_io_ops ksz9477_spi_ops = {
 static int ksz9477_spi_probe(struct spi_device *spi)
 {
 	struct ksz_device *dev;
-	int ret;
+	int i, ret;
 
 	dev = ksz_switch_alloc(&spi->dev, &ksz9477_spi_ops, spi);
 	if (!dev)
 		return -ENOMEM;
 
+	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
+		dev->regmap[i] = devm_regmap_init_spi(spi,
+					&ksz9477_regmap_config[i]);
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&spi->dev,
+				"Failed to initialize regmap%i: %d\n",
+				ksz9477_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
 	if (spi->dev.platform_data)
 		dev->pdata = spi->dev.platform_data;
 
-	dev->txbuf = devm_kzalloc(dev->dev, 4 + SPI_TX_BUF_LEN, GFP_KERNEL);
-
 	ret = ksz9477_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index d3ddf98156bb..5ccc633fc766 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -57,6 +57,7 @@ struct ksz_device {
 	const struct ksz_dev_ops *dev_ops;
 
 	struct device *dev;
+	struct regmap *regmap[3];
 
 	void *priv;
 
@@ -82,8 +83,6 @@ struct ksz_device {
 
 	struct vlan_table *vlan_cache;
 
-	u8 *txbuf;
-
 	struct ksz_port *ports;
 	struct timer_list mib_read_timer;
 	struct work_struct mib_read;
-- 
2.20.1

