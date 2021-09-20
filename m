Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D23411234
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhITJxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:31 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:62192 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbhITJw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131490; x=1663667490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+uznXalaLE+P10gWuj/wsDZ+JtTg3F/3Ho8CxZ4ZLO0=;
  b=eWyMPop9CvgcVO/U6+PqkaZc2M5Sy+guLSJ5Q/vjR7bG8+iMSAGAINEM
   4FkEx7+I/sT0GgfSMIBtEP8byRtJSY6iwTPdCsnLzLvyZJgPW+kgGvQ+s
   W0pNyFc0cXfmNf+7g/nwMrrP2aFXJL9UgPutjOGUdlJIF57qb1mFuFu0Z
   F5C95bWe2Qx9rIFGnIOYSAXppTcC+2fCIETLJe5nAv9rJGwGNrfpxegn0
   Qg8KJWwiAOYCBZ9015G5kgQ1hPV+vNzYRRBqcVzxmfRZHzsHhtppO3uqz
   UbaUN+HjzAVmZ+xCGWiG/ebrNm8hK2uJETnNoFdKTC1KRuoFWLwdEXQNk
   g==;
IronPort-SDR: YAvvO3EKM2UzLHtAekGuoC7kHPzMKd+k/UMtVj7b3r0IJQzCpXvwray0yH9E/0u0gPq1BQmA0Q
 t7uTJwRQNKZKVpnH5ZW7uw2UyHEjvor6EL8ZuYON0Jl0ygwkmWAgp9bqncQKpc4nT5acaYKA1N
 rM+QzMSSsSCxR3blHfeb3aP9nKTbiExDxeBd/y/k+iQPjaWnHBBOnFlegjY08uNIRcWaylLZiw
 Nw7/oARzDO3PK302E/IV+dQb06t7pD3fOgwwm6DNhKOrcOA3lhSLyRMo30XI2ByX28eabDU+yR
 gIi8gp9Ag4AUuvSdREkXoN7Y
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="132434729"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 05/12] reset: lan966x: Add switch reset driver
Date:   Mon, 20 Sep 2021 11:52:11 +0200
Message-ID: <20210920095218.1108151-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan966x switch SoC has a number of components that can be reset
indiviually, but at least the switch core needs to be in a well defined
state at power on, when any of the lan966x drivers starts to access the
switch core, this reset driver is available.

The reset driver is loaded early via the postcore_initcall interface, and
will then be available for the other lan966x drivers (SGPIO, SwitchDev etc)
that are loaded next, and the first of them to be loaded can perform the
one-time switch core reset that is needed.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/reset/Kconfig         |   8 +++
 drivers/reset/Makefile        |   1 +
 drivers/reset/reset-lan966x.c | 128 ++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 drivers/reset/reset-lan966x.c

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index be799a5abf8a..93f19303ebac 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -108,6 +108,14 @@ config RESET_LANTIQ
 	help
 	  This enables the reset controller driver for Lantiq / Intel XWAY SoCs.
 
+config RESET_LAN966X
+	bool "Microchip LAN966X Reset Driver"
+	depends on HAS_IOMEM || COMPILE_TEST
+	default y if LAN966X_SWITCH
+	select MFD_SYSCON
+	help
+	  This driver supports switch core reset for the Microchip LAN966X SoC.
+
 config RESET_LPC18XX
 	bool "LPC18xx/43xx Reset Driver" if COMPILE_TEST
 	default ARCH_LPC18XX
diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 21d46d8869ff..3358f491e617 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_RESET_HSDK) += reset-hsdk.o
 obj-$(CONFIG_RESET_IMX7) += reset-imx7.o
 obj-$(CONFIG_RESET_INTEL_GW) += reset-intel-gw.o
 obj-$(CONFIG_RESET_K210) += reset-k210.o
+obj-$(CONFIG_RESET_LAN966X) += reset-lan966x.o
 obj-$(CONFIG_RESET_LANTIQ) += reset-lantiq.o
 obj-$(CONFIG_RESET_LPC18XX) += reset-lpc18xx.o
 obj-$(CONFIG_RESET_MCHP_SPARX5) += reset-microchip-sparx5.o
diff --git a/drivers/reset/reset-lan966x.c b/drivers/reset/reset-lan966x.c
new file mode 100644
index 000000000000..3d4fe31653db
--- /dev/null
+++ b/drivers/reset/reset-lan966x.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries. */
+
+#include <linux/mfd/syscon.h>
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+
+#define PROTECT_REG    0x88
+#define PROTECT_BIT    BIT(5)
+#define SOFT_RESET_REG 0x00
+#define SOFT_RESET_BIT BIT(1)
+#define CHIP_COMMON_REG 0x10
+#define CHIP_COMMON_BIT BIT(0)
+
+struct mchp_reset_context {
+	struct regmap *cpu_ctrl;
+	struct regmap *switch_ctrl;
+	struct regmap *chip_ctrl;
+	struct reset_controller_dev rcdev;
+};
+
+static int lan966x_switch_reset(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct mchp_reset_context *ctx =
+		container_of(rcdev, struct mchp_reset_context, rcdev);
+	u32 val;
+	int ret;
+
+	/* Make sure the core is PROTECTED from reset */
+	regmap_update_bits(ctx->cpu_ctrl, PROTECT_REG, PROTECT_BIT, PROTECT_BIT);
+
+	/* Start soft reset */
+	regmap_write(ctx->switch_ctrl, SOFT_RESET_REG, SOFT_RESET_BIT);
+
+	/* Wait for soft reset done */
+	ret = regmap_read_poll_timeout(ctx->switch_ctrl, SOFT_RESET_REG, val,
+				       (val & SOFT_RESET_BIT) == 0, 1, 100);
+	if (ret)
+		return ret;
+
+	/* Release the reset of internal PHY */
+	regmap_update_bits(ctx->chip_ctrl, CHIP_COMMON_REG, CHIP_COMMON_BIT,
+			   CHIP_COMMON_BIT);
+
+	return 0;
+}
+
+static const struct reset_control_ops lan966x_reset_ops = {
+	.reset = lan966x_switch_reset,
+};
+
+static int mchp_lan966x_map_syscon(struct platform_device *pdev, char *name,
+				  struct regmap **target)
+{
+	struct device_node *syscon_np;
+	struct regmap *regmap;
+	int err;
+
+	syscon_np = of_parse_phandle(pdev->dev.of_node, name, 0);
+	if (!syscon_np)
+		return -ENODEV;
+	regmap = syscon_node_to_regmap(syscon_np);
+	of_node_put(syscon_np);
+	if (IS_ERR(regmap)) {
+		err = PTR_ERR(regmap);
+		dev_err(&pdev->dev, "No '%s' map: %d\n", name, err);
+		return err;
+	}
+
+	*target = regmap;
+	return 0;
+}
+
+static int mchp_lan966x_reset_probe(struct platform_device *pdev)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	struct mchp_reset_context *ctx;
+	int err;
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	err = mchp_lan966x_map_syscon(pdev, "cpu-syscon", &ctx->cpu_ctrl);
+	if (err)
+		return err;
+
+	err = mchp_lan966x_map_syscon(pdev, "switch-syscon", &ctx->switch_ctrl);
+	if (err)
+		return err;
+
+	err = mchp_lan966x_map_syscon(pdev, "chip-syscon", &ctx->chip_ctrl);
+	if (err)
+		return err;
+
+	ctx->rcdev.owner = THIS_MODULE;
+	ctx->rcdev.nr_resets = 1;
+	ctx->rcdev.ops = &lan966x_reset_ops;
+	ctx->rcdev.of_node = dn;
+
+	return devm_reset_controller_register(&pdev->dev, &ctx->rcdev);
+}
+
+static const struct of_device_id mchp_lan966x_reset_of_match[] = {
+	{
+		.compatible = "microchip,lan966x-switch-reset",
+	},
+	{ }
+};
+
+static struct platform_driver mchp_lan966x_reset_driver = {
+	.probe = mchp_lan966x_reset_probe,
+	.driver = {
+		.name = "lan966x-switch-reset",
+		.of_match_table = mchp_lan966x_reset_of_match,
+	},
+};
+
+static int __init mchp_lan966x_reset_init(void)
+{
+	return platform_driver_register(&mchp_lan966x_reset_driver);
+}
+
+postcore_initcall(mchp_lan966x_reset_init);
-- 
2.31.1

