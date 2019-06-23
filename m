Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6848550033
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfFXD21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:28:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43317 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFXD20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:28:26 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45X6k44lGKz1rcrP;
        Mon, 24 Jun 2019 00:37:16 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45X6k44H51z1qqkd;
        Mon, 24 Jun 2019 00:37:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id dE0PGaHcKLpt; Mon, 24 Jun 2019 00:37:15 +0200 (CEST)
X-Auth-Info: u/hKfZy5CTKH1MFh7yagWlak5C9uK44pM1I8rsl54FU=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 24 Jun 2019 00:37:15 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V3 01/10] net: dsa: microchip: Remove ksz_{read,write}24()
Date:   Mon, 24 Jun 2019 00:34:59 +0200
Message-Id: <20190623223508.2713-2-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623223508.2713-1-marex@denx.de>
References: <20190623223508.2713-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions and callbacks are never used, remove them.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
V2: No change
V3: - Rebase on next/master
    - Test on KSZ9477EVB
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 25 -------------------------
 drivers/net/dsa/microchip/ksz_common.h  | 22 ----------------------
 drivers/net/dsa/microchip/ksz_priv.h    |  2 --
 3 files changed, 49 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 75178624d3f5..e7118319c192 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -73,37 +73,12 @@ static int ksz_spi_write(struct ksz_device *dev, u32 reg, void *data,
 	return ksz9477_spi_write_reg(spi, reg, dev->txbuf, len);
 }
 
-static int ksz_spi_read24(struct ksz_device *dev, u32 reg, u32 *val)
-{
-	int ret;
-
-	*val = 0;
-	ret = ksz_spi_read(dev, reg, (u8 *)val, 3);
-	if (!ret) {
-		*val = be32_to_cpu(*val);
-		/* convert to 24bit */
-		*val >>= 8;
-	}
-
-	return ret;
-}
-
-static int ksz_spi_write24(struct ksz_device *dev, u32 reg, u32 value)
-{
-	/* make it to big endian 24bit from MSB */
-	value <<= 8;
-	value = cpu_to_be32(value);
-	return ksz_spi_write(dev, reg, &value, 3);
-}
-
 static const struct ksz_io_ops ksz9477_spi_ops = {
 	.read8 = ksz_spi_read8,
 	.read16 = ksz_spi_read16,
-	.read24 = ksz_spi_read24,
 	.read32 = ksz_spi_read32,
 	.write8 = ksz_spi_write8,
 	.write16 = ksz_spi_write16,
-	.write24 = ksz_spi_write24,
 	.write32 = ksz_spi_write32,
 	.get = ksz_spi_get,
 	.set = ksz_spi_set,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 21cd794e18f1..1781539c3a81 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -61,17 +61,6 @@ static inline int ksz_read16(struct ksz_device *dev, u32 reg, u16 *val)
 	return ret;
 }
 
-static inline int ksz_read24(struct ksz_device *dev, u32 reg, u32 *val)
-{
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->read24(dev, reg, val);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
-}
-
 static inline int ksz_read32(struct ksz_device *dev, u32 reg, u32 *val)
 {
 	int ret;
@@ -105,17 +94,6 @@ static inline int ksz_write16(struct ksz_device *dev, u32 reg, u16 value)
 	return ret;
 }
 
-static inline int ksz_write24(struct ksz_device *dev, u32 reg, u32 value)
-{
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->write24(dev, reg, value);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
-}
-
 static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 {
 	int ret;
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index c615d2a81dd5..5ef6153bd2cc 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -105,11 +105,9 @@ struct ksz_device {
 struct ksz_io_ops {
 	int (*read8)(struct ksz_device *dev, u32 reg, u8 *value);
 	int (*read16)(struct ksz_device *dev, u32 reg, u16 *value);
-	int (*read24)(struct ksz_device *dev, u32 reg, u32 *value);
 	int (*read32)(struct ksz_device *dev, u32 reg, u32 *value);
 	int (*write8)(struct ksz_device *dev, u32 reg, u8 value);
 	int (*write16)(struct ksz_device *dev, u32 reg, u16 value);
-	int (*write24)(struct ksz_device *dev, u32 reg, u32 value);
 	int (*write32)(struct ksz_device *dev, u32 reg, u32 value);
 	int (*get)(struct ksz_device *dev, u32 reg, void *data, size_t len);
 	int (*set)(struct ksz_device *dev, u32 reg, void *data, size_t len);
-- 
2.20.1

