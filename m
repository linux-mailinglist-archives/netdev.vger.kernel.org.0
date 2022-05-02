Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7D5173A2
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386091AbiEBQGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386144AbiEBQGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:06:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A66BBC3D;
        Mon,  2 May 2022 09:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507314; x=1683043314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rLmGeHdUzqQiNUvfLahrdXwaapKU32rREMUf/oyYsBo=;
  b=jyY9FON/lZSxFaJFS9IrTa6OQkx5i4QJVJDjKFslGUZQ89UWI3MIE3oP
   n/YdvvwNoyZZn6ql21uOPh1Na7txr+CTHaDc6oOhhe+r8s0ugDxUhOWQu
   THCus6byYtcyXcA2nNdqaNyLl56Y2HQ2IySP9LImJjgwB9c4GO6WXp47C
   41JP4OJGiTQ8rrWqv0fTTGMkZr3BWaovbGUwCvXCygQdKrh5aEFe5YTx3
   UDjbPzerUf+Cr3foFydUV32lASr+9Zwype1Eb9fimbq7JF2qygoqBzWQh
   ENyIgmo93k/rdZBTz1CEwd5g0aC6Po7jxziNP8y9KOn04RvvjLir0gfL0
   w==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="157530130"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:01:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:01:52 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:01:34 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 07/13] net: dsa: microchip: add LAN937x SPI driver
Date:   Mon, 2 May 2022 21:28:42 +0530
Message-ID: <20220502155848.30493-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the SPI driver for the LAN937x switches. It uses the
lan937x_main.c and lan937x_dev.c functions.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/lan937x_spi.c | 236 ++++++++++++++++++++++++
 2 files changed, 237 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index d32ff38dc240..28d8eb62a795 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_LAN937X)		+= lan937x.o
 lan937x-objs := lan937x_dev.o
 lan937x-objs += lan937x_main.o
+lan937x-objs += lan937x_spi.o
diff --git a/drivers/net/dsa/microchip/lan937x_spi.c b/drivers/net/dsa/microchip/lan937x_spi.c
new file mode 100644
index 000000000000..a50dfcf27aff
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_spi.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X switch driver register access through SPI
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+#include <linux/of_device.h>
+
+#include "ksz_common.h"
+
+#define SPI_ADDR_SHIFT 24
+#define SPI_ADDR_ALIGN 3
+#define SPI_TURNAROUND_SHIFT 5
+
+KSZ_REGMAP_TABLE(lan937x, 32, SPI_ADDR_SHIFT, SPI_TURNAROUND_SHIFT,
+		 SPI_ADDR_ALIGN);
+
+struct lan937x_chip_data {
+	u32 chip_id;
+	const char *dev_name;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_ports;
+	int port_cnt;
+};
+
+static const struct of_device_id lan937x_dt_ids[];
+
+static const struct lan937x_chip_data lan937x_switch_chips[] = {
+	{
+		.chip_id = 0x00937010,
+		.dev_name = "LAN9370",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x10,
+		/* total port count */
+		.port_cnt = 5,
+	},
+	{
+		.chip_id = 0x00937110,
+		.dev_name = "LAN9371",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 6,
+	},
+	{
+		.chip_id = 0x00937210,
+		.dev_name = "LAN9372",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 8,
+	},
+	{
+		.chip_id = 0x00937310,
+		.dev_name = "LAN9373",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x38,
+		/* total port count */
+		.port_cnt = 5,
+	},
+	{
+		.chip_id = 0x00937410,
+		.dev_name = "LAN9374",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 8,
+	},
+};
+
+static int lan937x_spi_probe(struct spi_device *spi)
+{
+	struct regmap_config rc;
+	struct ksz_device *dev;
+	int i, ret;
+
+	dev = ksz_switch_alloc(&spi->dev, spi);
+	if (!dev)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(lan937x_regmap_config); i++) {
+		rc = lan937x_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
+
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&spi->dev,
+				"Failed to initialize regmap%i: %d\n",
+				lan937x_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
+	if (spi->dev.platform_data)
+		dev->pdata = spi->dev.platform_data;
+
+	ret = lan937x_switch_register(dev);
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	spi_set_drvdata(spi, dev);
+
+	return 0;
+}
+
+int lan937x_check_device_id(struct ksz_device *dev)
+{
+	const struct lan937x_chip_data *dt_chip_data;
+	const struct of_device_id *match;
+	int i;
+
+	dt_chip_data = of_device_get_match_data(dev->dev);
+
+	if (!dt_chip_data)
+		return -EINVAL;
+
+	for (match = lan937x_dt_ids; match->compatible[0]; match++) {
+		const struct lan937x_chip_data *chip_data = match->data;
+
+		/* Check for chip id */
+		if (chip_data->chip_id != dev->chip_id)
+			continue;
+
+		/* Check for Device Tree and Chip ID */
+		if (dt_chip_data->chip_id != dev->chip_id) {
+			dev_err(dev->dev,
+				"Device tree specifies chip %s but found %s, please fix it!\n",
+				dt_chip_data->dev_name, chip_data->dev_name);
+			return -ENODEV;
+		}
+
+		break;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(lan937x_switch_chips); i++) {
+		const struct lan937x_chip_data *chip = &lan937x_switch_chips[i];
+
+		if (dev->chip_id == chip->chip_id) {
+			dev->name = chip->dev_name;
+			dev->num_vlans = chip->num_vlans;
+			dev->num_alus = chip->num_alus;
+			dev->num_statics = chip->num_statics;
+			dev->port_cnt = chip->port_cnt;
+			dev->cpu_ports = chip->cpu_ports;
+			break;
+		}
+	}
+
+	/* no switch found */
+	if (!dev->port_cnt)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(lan937x_check_device_id);
+
+static void lan937x_spi_remove(struct spi_device *spi)
+{
+	struct ksz_device *dev = spi_get_drvdata(spi);
+
+	if (dev)
+		ksz_switch_remove(dev);
+
+	spi_set_drvdata(spi, NULL);
+}
+
+static void lan937x_spi_shutdown(struct spi_device *spi)
+{
+	struct ksz_device *dev = spi_get_drvdata(spi);
+
+	if (dev)
+		dsa_switch_shutdown(dev->ds);
+
+	spi_set_drvdata(spi, NULL);
+}
+
+static const struct of_device_id lan937x_dt_ids[] = {
+	{ .compatible = "microchip,lan9370", .data = &lan937x_switch_chips[0] },
+	{ .compatible = "microchip,lan9371", .data = &lan937x_switch_chips[1] },
+	{ .compatible = "microchip,lan9372", .data = &lan937x_switch_chips[2] },
+	{ .compatible = "microchip,lan9373", .data = &lan937x_switch_chips[3] },
+	{ .compatible = "microchip,lan9374", .data = &lan937x_switch_chips[4] },
+	{},
+};
+MODULE_DEVICE_TABLE(of, lan937x_dt_ids);
+
+static const struct spi_device_id lan937x_spi_ids[] = {
+	{ .name = "lan9370" },
+	{ .name = "lan9371" },
+	{ .name = "lan9372" },
+	{ .name = "lan9373" },
+	{ .name = "lan9374" },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, lan937x_spi_ids);
+
+static struct spi_driver lan937x_spi_driver = {
+	.driver = {
+		.name	= "lan937x-switch",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lan937x_dt_ids),
+	},
+	.probe	= lan937x_spi_probe,
+	.remove	= lan937x_spi_remove,
+	.shutdown = lan937x_spi_shutdown,
+	.id_table = lan937x_spi_ids,
+};
+
+module_spi_driver(lan937x_spi_driver);
+
+MODULE_ALIAS("spi:lan937x");
+
+MODULE_AUTHOR("Prasanna Vengateshan Varadharajan <Prasanna.Vengateshan@microchip.com>");
+MODULE_DESCRIPTION("Microchip LAN937x Series Switch SPI access Driver");
+MODULE_LICENSE("GPL");
-- 
2.33.0

