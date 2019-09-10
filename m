Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD51AEB4D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfIJNTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:19:12 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:42913 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfIJNTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:19:11 -0400
Received: by mail-io1-f48.google.com with SMTP id n197so37373669iod.9;
        Tue, 10 Sep 2019 06:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nr3h/K+K0px42kslD/xLEpxteAtPPNG4HRdU68/XkhE=;
        b=OaynSCXMHeX4QpIEbNpDDOCmke/0o2JvMAUbbwHzA2l0RmQ5Fvxtse0VLtxqf6PQYY
         Fy8OLGQ5tXQ8dOYYMZE//INLGeLCZPiqZTmuCbeckhldGEdZ5jvErSMk1hgIjNLEpEh9
         /BVIwRh0GyUCmsgT4+2bI61zLuOjsPHTFw+x7DWfkncWVQ4JguAcBIUWwB1UHpOnKKFU
         JtF7wQ87dI/lRlY3e5/OZ9uWlnjJNPcpLONYIF6yE+dP7lomaHB8oFncZhiSVVU2SG6q
         3nwY+oeyjBPF0iyOMqSY3Q4NC10DwerkFAaAHB/vAKLC8qnuat6c6opHFqnsdQJ653EJ
         UBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nr3h/K+K0px42kslD/xLEpxteAtPPNG4HRdU68/XkhE=;
        b=BTj+wWK/cnVgU6nZr1Yb4uY8DmX51Ye3Vbua/8GMRgCuw8O+Px50w9Zpv7HyjV19Yw
         BSG0SdrNBLsDUZ7e9OWlSgf4cMtALNs3zY/pNd2vXIxKJXHCVH4hPmUU7M+eGm381g6x
         fZua+xuK2ZMW63M6miv4q1u/fMYnDfLiIGm8sOEaFt99DCdvcY4t0yX71aoY47sfSuke
         /Iypcs2zZes6fEVdORSOt0/dWPt9CJ4Lc04yjPZdsLwjL2WfFQC2vKQ3hhNRssX3vY+i
         YGuZuMKjIbxk9tSO+5Mx0s63rMNidOZ3gyZAHE9ybqY4ZKrWzLax8yMKByptzp2e6MyB
         mvsw==
X-Gm-Message-State: APjAAAXKEZzt9WNFzV4d5nEg35d1LHudbeJ6Pm/APGUJrTyAD/wE/IEY
        iRrFOacWvTrQLlyWA2Yv7gfDK415nQ==
X-Google-Smtp-Source: APXvYqz8CF6cmUcIATTBgA7NDgZACq3cv+0euDfaxQKFtMHUz1y6WblUgWNgt69A/LXCVR42zAndMQ==
X-Received: by 2002:a6b:640f:: with SMTP id t15mr5151380iog.71.1568121550004;
        Tue, 10 Sep 2019 06:19:10 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f7sm13642740ioc.31.2019.09.10.06.19.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 06:19:09 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 1/3] net: dsa: microchip: add KSZ9477 I2C driver
Date:   Tue, 10 Sep 2019 08:18:34 -0500
Message-Id: <20190910131836.114058-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190910131836.114058-1-george.mccollister@gmail.com>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
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

Changes since v1:
	- Adjust order of includes so they are in alphabetical order.

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
index 000000000000..79867cc2474b
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
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
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

