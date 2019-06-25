Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A31555C91
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfFYXp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:45:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60775 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfFYXp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:45:57 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45YN8L3zgzz1rlws;
        Wed, 26 Jun 2019 01:45:54 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45YN8L3nR2z20V2K;
        Wed, 26 Jun 2019 01:45:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 1jeOAYT-vkxH; Wed, 26 Jun 2019 01:45:53 +0200 (CEST)
X-Auth-Info: Ey9wqDvs1iRkls+D/jBpkj0Q+pkAMvkD7yF57OH5zU0=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 26 Jun 2019 01:45:53 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V4 03/10] net: dsa: microchip: Inline ksz_spi.h
Date:   Wed, 26 Jun 2019 01:43:41 +0200
Message-Id: <20190625234348.16246-4-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625234348.16246-1-marex@denx.de>
References: <20190625234348.16246-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions in the header file are static, and the header file is
included from single C file, just inline the code into the C file.
The bonus is that it's easier to spot further content to clean up.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V2: No change
V3: - Rebase on next/master
    - Test on KSZ9477EVB
V4: Add RB
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 43 +++++++++++++++++-
 drivers/net/dsa/microchip/ksz_spi.h     | 59 -------------------------
 2 files changed, 42 insertions(+), 60 deletions(-)
 delete mode 100644 drivers/net/dsa/microchip/ksz_spi.h

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 86d12d48a2a9..a34e66eccbcd 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -13,7 +13,6 @@
 #include <linux/spi/spi.h>
 
 #include "ksz_priv.h"
-#include "ksz_spi.h"
 
 /* SPI frame opcodes */
 #define KS_SPIOP_RD			3
@@ -73,6 +72,48 @@ static int ksz_spi_write(struct ksz_device *dev, u32 reg, void *data,
 	return ksz9477_spi_write_reg(spi, reg, dev->txbuf, len);
 }
 
+static int ksz_spi_read8(struct ksz_device *dev, u32 reg, u8 *val)
+{
+	return ksz_spi_read(dev, reg, val, 1);
+}
+
+static int ksz_spi_read16(struct ksz_device *dev, u32 reg, u16 *val)
+{
+	int ret = ksz_spi_read(dev, reg, (u8 *)val, 2);
+
+	if (!ret)
+		*val = be16_to_cpu(*val);
+
+	return ret;
+}
+
+static int ksz_spi_read32(struct ksz_device *dev, u32 reg, u32 *val)
+{
+	int ret = ksz_spi_read(dev, reg, (u8 *)val, 4);
+
+	if (!ret)
+		*val = be32_to_cpu(*val);
+
+	return ret;
+}
+
+static int ksz_spi_write8(struct ksz_device *dev, u32 reg, u8 value)
+{
+	return ksz_spi_write(dev, reg, &value, 1);
+}
+
+static int ksz_spi_write16(struct ksz_device *dev, u32 reg, u16 value)
+{
+	value = cpu_to_be16(value);
+	return ksz_spi_write(dev, reg, &value, 2);
+}
+
+static int ksz_spi_write32(struct ksz_device *dev, u32 reg, u32 value)
+{
+	value = cpu_to_be32(value);
+	return ksz_spi_write(dev, reg, &value, 4);
+}
+
 static const struct ksz_io_ops ksz9477_spi_ops = {
 	.read8 = ksz_spi_read8,
 	.read16 = ksz_spi_read16,
diff --git a/drivers/net/dsa/microchip/ksz_spi.h b/drivers/net/dsa/microchip/ksz_spi.h
deleted file mode 100644
index 976bace31f37..000000000000
--- a/drivers/net/dsa/microchip/ksz_spi.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Microchip KSZ series SPI access common header
- *
- * Copyright (C) 2017-2018 Microchip Technology Inc.
- *	Tristram Ha <Tristram.Ha@microchip.com>
- */
-
-#ifndef __KSZ_SPI_H
-#define __KSZ_SPI_H
-
-/* Chip dependent SPI access */
-static int ksz_spi_read(struct ksz_device *dev, u32 reg, u8 *data,
-			unsigned int len);
-static int ksz_spi_write(struct ksz_device *dev, u32 reg, void *data,
-			 unsigned int len);
-
-static int ksz_spi_read8(struct ksz_device *dev, u32 reg, u8 *val)
-{
-	return ksz_spi_read(dev, reg, val, 1);
-}
-
-static int ksz_spi_read16(struct ksz_device *dev, u32 reg, u16 *val)
-{
-	int ret = ksz_spi_read(dev, reg, (u8 *)val, 2);
-
-	if (!ret)
-		*val = be16_to_cpu(*val);
-
-	return ret;
-}
-
-static int ksz_spi_read32(struct ksz_device *dev, u32 reg, u32 *val)
-{
-	int ret = ksz_spi_read(dev, reg, (u8 *)val, 4);
-
-	if (!ret)
-		*val = be32_to_cpu(*val);
-
-	return ret;
-}
-
-static int ksz_spi_write8(struct ksz_device *dev, u32 reg, u8 value)
-{
-	return ksz_spi_write(dev, reg, &value, 1);
-}
-
-static int ksz_spi_write16(struct ksz_device *dev, u32 reg, u16 value)
-{
-	value = cpu_to_be16(value);
-	return ksz_spi_write(dev, reg, &value, 2);
-}
-
-static int ksz_spi_write32(struct ksz_device *dev, u32 reg, u32 value)
-{
-	value = cpu_to_be32(value);
-	return ksz_spi_write(dev, reg, &value, 4);
-}
-
-#endif
-- 
2.20.1

