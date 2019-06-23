Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8CF50036
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfFXD2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:28:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60790 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFXD23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:28:29 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45X6kF1ws4z1rcrc;
        Mon, 24 Jun 2019 00:37:25 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45X6kF1k5Xz1qqkd;
        Mon, 24 Jun 2019 00:37:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 2LD0-qaSz1rI; Mon, 24 Jun 2019 00:37:23 +0200 (CEST)
X-Auth-Info: kdGlNfxoa6gbP6cYuyND77deoGbj3NAx/ZUZvDM1jb0=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 24 Jun 2019 00:37:23 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V3 08/10] net: dsa: microchip: Dispose of ksz_io_ops
Date:   Mon, 24 Jun 2019 00:35:06 +0200
Message-Id: <20190623223508.2713-9-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623223508.2713-1-marex@denx.de>
References: <20190623223508.2713-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver now uses regmap , get rid of ad-hoc ksz_io_ops
abstraction, which no longer has any meaning. Moreover, since regmap
has it's own locking, get rid of the register access mutex.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
V2: Use separate regmaps for 8/16/32bit registers
V3: - Rebase on next/master
    - Test on KSZ9477EVB
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 57 +------------------------
 drivers/net/dsa/microchip/ksz_common.c  |  6 +--
 drivers/net/dsa/microchip/ksz_common.h  | 50 ++++++----------------
 drivers/net/dsa/microchip/ksz_priv.h    | 16 +------
 4 files changed, 17 insertions(+), 112 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 77e3cb100eae..8c8bf3237013 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -46,67 +46,12 @@ static const struct regmap_config ksz9477_regmap_config[] = {
 	KSZ_REGMAP_COMMON(32),
 };
 
-static int ksz_spi_read8(struct ksz_device *dev, u32 reg, u8 *val)
-{
-	unsigned int value;
-	int ret = regmap_read(dev->regmap, reg, &value);
-
-	*val = value;
-	return ret;
-}
-
-static int ksz_spi_read16(struct ksz_device *dev, u32 reg, u16 *val)
-{
-	int ret = regmap_bulk_read(dev->regmap, reg, val, 2);
-
-	if (!ret)
-		*val = be16_to_cpu(*val);
-
-	return ret;
-}
-
-static int ksz_spi_read32(struct ksz_device *dev, u32 reg, u32 *val)
-{
-	int ret = regmap_bulk_read(dev->regmap, reg, val, 4);
-
-	if (!ret)
-		*val = be32_to_cpu(*val);
-
-	return ret;
-}
-
-static int ksz_spi_write8(struct ksz_device *dev, u32 reg, u8 value)
-{
-	return regmap_write(dev->regmap, reg, value);
-}
-
-static int ksz_spi_write16(struct ksz_device *dev, u32 reg, u16 value)
-{
-	value = cpu_to_be16(value);
-	return regmap_bulk_write(dev->regmap, reg, &value, 2);
-}
-
-static int ksz_spi_write32(struct ksz_device *dev, u32 reg, u32 value)
-{
-	value = cpu_to_be32(value);
-	return regmap_bulk_write(dev->regmap, reg, &value, 4);
-}
-
-static const struct ksz_io_ops ksz9477_spi_ops = {
-	.read8 = ksz_spi_read8,
-	.read16 = ksz_spi_read16,
-	.read32 = ksz_spi_read32,
-	.write8 = ksz_spi_write8,
-	.write16 = ksz_spi_write16,
-	.write32 = ksz_spi_write32,
-};
-
 static int ksz9477_spi_probe(struct spi_device *spi)
 {
 	struct ksz_device *dev;
 	int i, ret;
 
-	dev = ksz_switch_alloc(&spi->dev, &ksz9477_spi_ops, spi);
+	dev = ksz_switch_alloc(&spi->dev, spi);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 978c59aa8efb..a3d2d67894bd 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -396,9 +396,7 @@ void ksz_disable_port(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_disable_port);
 
-struct ksz_device *ksz_switch_alloc(struct device *base,
-				    const struct ksz_io_ops *ops,
-				    void *priv)
+struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
 	struct ksz_device *swdev;
@@ -416,7 +414,6 @@ struct ksz_device *ksz_switch_alloc(struct device *base,
 
 	swdev->ds = ds;
 	swdev->priv = priv;
-	swdev->ops = ops;
 
 	return swdev;
 }
@@ -442,7 +439,6 @@ int ksz_switch_register(struct ksz_device *dev,
 	}
 
 	mutex_init(&dev->dev_mutex);
-	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index fe576a00facf..c3871ed9b097 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -7,6 +7,8 @@
 #ifndef __KSZ_COMMON_H
 #define __KSZ_COMMON_H
 
+#include <linux/regmap.h>
+
 void ksz_port_cleanup(struct ksz_device *dev, int port);
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
@@ -41,68 +43,44 @@ void ksz_disable_port(struct dsa_switch *ds, int port);
 
 static inline int ksz_read8(struct ksz_device *dev, u32 reg, u8 *val)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->read8(dev, reg, val);
-	mutex_unlock(&dev->reg_mutex);
+	unsigned int value;
+	int ret = regmap_read(dev->regmap[0], reg, &value);
 
+	*val = value;
 	return ret;
 }
 
 static inline int ksz_read16(struct ksz_device *dev, u32 reg, u16 *val)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->read16(dev, reg, val);
-	mutex_unlock(&dev->reg_mutex);
+	unsigned int value;
+	int ret = regmap_read(dev->regmap[1], reg, &value);
 
+	*val = value;
 	return ret;
 }
 
 static inline int ksz_read32(struct ksz_device *dev, u32 reg, u32 *val)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->read32(dev, reg, val);
-	mutex_unlock(&dev->reg_mutex);
+	unsigned int value;
+	int ret = regmap_read(dev->regmap[2], reg, &value);
 
+	*val = value;
 	return ret;
 }
 
 static inline int ksz_write8(struct ksz_device *dev, u32 reg, u8 value)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->write8(dev, reg, value);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
+	return regmap_write(dev->regmap[0], reg, value);
 }
 
 static inline int ksz_write16(struct ksz_device *dev, u32 reg, u16 value)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->write16(dev, reg, value);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
+	return regmap_write(dev->regmap[1], reg, value);
 }
 
 static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 {
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->write32(dev, reg, value);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
+	return regmap_write(dev->regmap[2], reg, value);
 }
 
 static inline void ksz_pread8(struct ksz_device *dev, int port, int offset,
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index 5ccc633fc766..beacf0e40f42 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -14,8 +14,6 @@
 #include <linux/etherdevice.h>
 #include <net/dsa.h>
 
-struct ksz_io_ops;
-
 struct vlan_table {
 	u32 table[3];
 };
@@ -49,11 +47,9 @@ struct ksz_device {
 	const char *name;
 
 	struct mutex dev_mutex;		/* device access */
-	struct mutex reg_mutex;		/* register access */
 	struct mutex stats_mutex;	/* status access */
 	struct mutex alu_mutex;		/* ALU access */
 	struct mutex vlan_mutex;	/* vlan access */
-	const struct ksz_io_ops *ops;
 	const struct ksz_dev_ops *dev_ops;
 
 	struct device *dev;
@@ -101,15 +97,6 @@ struct ksz_device {
 	u16 port_mask;
 };
 
-struct ksz_io_ops {
-	int (*read8)(struct ksz_device *dev, u32 reg, u8 *value);
-	int (*read16)(struct ksz_device *dev, u32 reg, u16 *value);
-	int (*read32)(struct ksz_device *dev, u32 reg, u32 *value);
-	int (*write8)(struct ksz_device *dev, u32 reg, u8 value);
-	int (*write16)(struct ksz_device *dev, u32 reg, u16 value);
-	int (*write32)(struct ksz_device *dev, u32 reg, u32 value);
-};
-
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
@@ -158,8 +145,7 @@ struct ksz_dev_ops {
 	void (*exit)(struct ksz_device *dev);
 };
 
-struct ksz_device *ksz_switch_alloc(struct device *base,
-				    const struct ksz_io_ops *ops, void *priv);
+struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops);
 void ksz_switch_remove(struct ksz_device *dev);
-- 
2.20.1

