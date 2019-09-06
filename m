Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD1AC207
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404184AbfIFVbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:31:32 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:41928 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388050AbfIFVbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:31:31 -0400
Received: by mail-io1-f49.google.com with SMTP id r26so15997040ioh.8;
        Fri, 06 Sep 2019 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kFSs7yLUMlZ4ZJ3JzJb5cfx2eTSeuSjFKbJekM6Yoy8=;
        b=LNtbaTCNkiYZcp/diTZY4EJ0SwlXSxtzY/V1j7qO2GV2D6n5p1Y9OkeQvQ14JLkWSz
         nBHA1EZCcltmDDCiNUC38jgOU0QwJpjHKQK1osLiodCclIEfiviDxgsUprEzZlVpGP+n
         3Xuv6FOrQWCfNfgFozWRF/HTVKPqtUxHgzMZIl8NJi8aNEiMEsQ+sRo6BAk1I99qH6yU
         jx3GIHvfqNo5UMdIJupFpFa9C1QDAvv4DMqRuZGWkq8Ydlz4Za3PaevyMwHsezjocMUQ
         eOSn6VuqEw+psN7ENjJgFIy1lXouP3UCiQUrjXnRCi+73pTFWLj+WuyKyc0a4rc9LdpP
         wU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kFSs7yLUMlZ4ZJ3JzJb5cfx2eTSeuSjFKbJekM6Yoy8=;
        b=tLdRjiHw0EXOBnkS8ugJBIlip7VYlLAoH4gheRRhslW5J2PiWAVWYYLXf5d88mJvxV
         iRyx5C5+O+t2H7i0HAXjnb8EELzVzHMUqAw/G95RIiiEWCiZ8z65xoXFoluIcZ5fEOOK
         VIyVIB1/TqZbZTyMU8z1+RmAdKA7vTLrEyIw2IVIJ9Eex/Y3ZuptmzH7xmtgmB0PsVmB
         YjoBFUpWqWX+Ysj/W6mJ2IYGZNd9xsR8WzWMeg6dXqW0F2e+GBIf8mgSqi2R0uYGjbVe
         1mCIw/L+qM6bB6SRDjnmaObVZmhu7yvEByhnydc5pNlZVX50gpBZSPUyFpGs94sDFK8I
         cTGQ==
X-Gm-Message-State: APjAAAVdxXqo4Cq3EA0xsG20A1ZmdeqJtKs+PpugtkIq8aCKvu+t8hkk
        k4b3Yj7PRn1F7Th3klBZbZ4XsRC6cA==
X-Google-Smtp-Source: APXvYqwMznf1MiG86uD2dpvsiCIxnOMBrwgaJKjzcLEH3Zzno2LPj4eM4XGQ2clCiMDBWiMi627ddw==
X-Received: by 2002:a02:c9ce:: with SMTP id c14mr12280889jap.144.1567805489429;
        Fri, 06 Sep 2019 14:31:29 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r2sm4158110ioh.61.2019.09.06.14.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 14:31:28 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: microchip: add KSZ9477 I2C driver
Date:   Fri,  6 Sep 2019 16:30:52 -0500
Message-Id: <20190906213054.48908-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906213054.48908-1-george.mccollister@gmail.com>
References: <20190906213054.48908-1-george.mccollister@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tristram Ha <Tristram.Ha@microchip.com>

Add KSZ9477 I2C driver support.  The code ksz9477.c and ksz_common.c are
used together to generate the I2C driver.

Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
[george.mccollister@gmail.com: bring up to date, use ksz_common regmap macros]
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/microchip/Kconfig       |   7 +++
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz9477_i2c.c | 100 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |   2 +
 4 files changed, 110 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz9477_i2c.c

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index e1c23d1e91e6..1d7870c6df3c 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -9,6 +9,13 @@ menuconfig NET_DSA_MICROCHIP_KSZ9477
 	help
 	  This driver adds support for Microchip KSZ9477 switch chips.
 
+config NET_DSA_MICROCHIP_KSZ9477_I2C
+	tristate "KSZ9477 series I2C connected switch driver"
+	depends on NET_DSA_MICROCHIP_KSZ9477 && I2C
+	select REGMAP_I2C
+	help
+	  Select to enable support for registering switches configured through I2C.
+
 config NET_DSA_MICROCHIP_KSZ9477_SPI
 	tristate "KSZ9477 series SPI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ9477 && SPI
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index e3d799b95d7d..929caa81e782 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_common.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477)		+= ksz9477.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
new file mode 100644
index 000000000000..85fd0fb43941
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip KSZ9477 series register access through I2C
+ *
+ * Copyright (C) 2018-2019 Microchip Technology Inc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/i2c.h>
+
+#include "ksz_common.h"
+
+KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
+
+static int ksz9477_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *i2c_id)
+{
+	struct ksz_device *dev;
+	int i, ret;
+
+	dev = ksz_switch_alloc(&i2c->dev, i2c);
+	if (!dev)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
+		dev->regmap[i] = devm_regmap_init_i2c(i2c,
+					&ksz9477_regmap_config[i]);
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&i2c->dev,
+				"Failed to initialize regmap%i: %d\n",
+				ksz9477_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
+	if (i2c->dev.platform_data)
+		dev->pdata = i2c->dev.platform_data;
+
+	ret = ksz9477_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	i2c_set_clientdata(i2c, dev);
+
+	return 0;
+}
+
+static int ksz9477_i2c_remove(struct i2c_client *i2c)
+{
+	struct ksz_device *dev = i2c_get_clientdata(i2c);
+
+	ksz_switch_remove(dev);
+
+	return 0;
+}
+
+static void ksz9477_i2c_shutdown(struct i2c_client *i2c)
+{
+	struct ksz_device *dev = i2c_get_clientdata(i2c);
+
+	if (dev && dev->dev_ops->shutdown)
+		dev->dev_ops->shutdown(dev);
+}
+
+static const struct i2c_device_id ksz9477_i2c_id[] = {
+	{ "ksz9477-switch", 0 },
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
+
+static const struct of_device_id ksz9477_dt_ids[] = {
+	{ .compatible = "microchip,ksz9477" },
+	{ .compatible = "microchip,ksz9897" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
+
+static struct i2c_driver ksz9477_i2c_driver = {
+	.driver = {
+		.name	= "ksz9477-switch",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ksz9477_dt_ids),
+	},
+	.probe	= ksz9477_i2c_probe,
+	.remove	= ksz9477_i2c_remove,
+	.shutdown = ksz9477_i2c_shutdown,
+	.id_table = ksz9477_i2c_id,
+};
+
+module_i2c_driver(ksz9477_i2c_driver);
+
+MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
+MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch I2C access Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 13d027baaa8b..a24d8e61fbe7 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -294,6 +294,8 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
 
+#define swabnot_used(x)		0
+
 #define KSZ_SPI_OP_FLAG_MASK(opcode, swp, regbits, regpad)		\
 	swab##swp((opcode) << ((regbits) + (regpad)))
 
-- 
2.11.0

