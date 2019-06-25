Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CFC55C98
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfFYXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:46:09 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35044 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfFYXqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:46:04 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45YN8V1Nm5z1rMqd;
        Wed, 26 Jun 2019 01:46:02 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45YN8V1DLHz20V2L;
        Wed, 26 Jun 2019 01:46:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vvLPb85soNAD; Wed, 26 Jun 2019 01:46:01 +0200 (CEST)
X-Auth-Info: u6BMv0YVJ7DK5sJIHL/k6hD2iM2JpoVgjy66YXxzqCE=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 26 Jun 2019 01:46:01 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V4 09/10] net: dsa: microchip: Factor out regmap config generation into common header
Date:   Wed, 26 Jun 2019 01:43:47 +0200
Message-Id: <20190625234348.16246-10-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625234348.16246-1-marex@denx.de>
References: <20190625234348.16246-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The regmap config tables are rather similar for various generations of
the KSZ8xxx/KSZ9xxx switches. Introduce a macro which allows generating
those tables without duplication. Note that $regalign parameter is not
used right now, but will be used in KSZ87xx series switches.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
V2: New patch
V3: - Rebase on next/master
    - Test on KSZ9477EVB
    - Increase regmap max register, to cover all switch registers
    - Make register swabbing configurable, to allow handling switches
      with only 16bit registers as well as switches with some 32bit ones
V4: No change
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 29 +++-------------------
 drivers/net/dsa/microchip/ksz_common.h  | 32 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index d1ffdf51d58c..5a9e27b337a8 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -14,37 +14,14 @@
 #include <linux/spi/spi.h>
 
 #include "ksz_priv.h"
+#include "ksz_common.h"
 
 #define SPI_ADDR_SHIFT			24
 #define SPI_ADDR_ALIGN			3
 #define SPI_TURNAROUND_SHIFT		5
 
-/* SPI frame opcodes */
-#define KS_SPIOP_RD			3
-#define KS_SPIOP_WR			2
-
-#define KS_SPIOP_FLAG_MASK(opcode)		\
-	swab32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
-
-#define KSZ_REGMAP_COMMON(width)					\
-	{								\
-		.val_bits = (width),					\
-		.reg_stride = (width) / 8,				\
-		.reg_bits = SPI_ADDR_SHIFT + SPI_ADDR_ALIGN,		\
-		.pad_bits = SPI_TURNAROUND_SHIFT,			\
-		.max_register = BIT(SPI_ADDR_SHIFT) - 1,		\
-		.cache_type = REGCACHE_NONE,				\
-		.read_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_RD),	\
-		.write_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_WR),	\
-		.reg_format_endian = REGMAP_ENDIAN_BIG,			\
-		.val_format_endian = REGMAP_ENDIAN_BIG			\
-	}
-
-static const struct regmap_config ksz9477_regmap_config[] = {
-	KSZ_REGMAP_COMMON(8),
-	KSZ_REGMAP_COMMON(16),
-	KSZ_REGMAP_COMMON(32),
-};
+KSZ_REGMAP_TABLE(ksz9477, 32, SPI_ADDR_SHIFT,
+		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
 
 static int ksz9477_spi_probe(struct spi_device *spi)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c3871ed9b097..745318424f71 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -133,4 +133,36 @@ static inline u32 ksz_pread32_poll(struct ksz_poll_ctx *ctx)
 	return data;
 }
 
+/* Regmap tables generation */
+#define KSZ_SPI_OP_RD		3
+#define KSZ_SPI_OP_WR		2
+
+#define KSZ_SPI_OP_FLAG_MASK(opcode, swp, regbits, regpad)		\
+	swab##swp((opcode) << ((regbits) + (regpad)))
+
+#define KSZ_REGMAP_ENTRY(width, swp, regbits, regpad, regalign)		\
+	{								\
+		.val_bits = (width),					\
+		.reg_stride = (width) / 8,				\
+		.reg_bits = (regbits) + (regalign),			\
+		.pad_bits = (regpad),					\
+		.max_register = BIT(regbits) - 1,			\
+		.cache_type = REGCACHE_NONE,				\
+		.read_flag_mask =					\
+			KSZ_SPI_OP_FLAG_MASK(KSZ_SPI_OP_RD, swp,	\
+					     regbits, regpad),		\
+		.write_flag_mask =					\
+			KSZ_SPI_OP_FLAG_MASK(KSZ_SPI_OP_WR, swp,	\
+					     regbits, regpad),		\
+		.reg_format_endian = REGMAP_ENDIAN_BIG,			\
+		.val_format_endian = REGMAP_ENDIAN_BIG			\
+	}
+
+#define KSZ_REGMAP_TABLE(ksz, swp, regbits, regpad, regalign)		\
+	static const struct regmap_config ksz##_regmap_config[] = {	\
+		KSZ_REGMAP_ENTRY(8, swp, (regbits), (regpad), (regalign)), \
+		KSZ_REGMAP_ENTRY(16, swp, (regbits), (regpad), (regalign)), \
+		KSZ_REGMAP_ENTRY(32, swp, (regbits), (regpad), (regalign)), \
+	}
+
 #endif
-- 
2.20.1

