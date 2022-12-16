Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA764E78A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 08:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiLPHF4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Dec 2022 02:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLPHFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 02:05:47 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1597C6D;
        Thu, 15 Dec 2022 23:05:45 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 5823024E39B;
        Fri, 16 Dec 2022 15:05:44 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 15:05:44 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 16 Dec 2022 15:05:43 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v2 7/9] net: stmmac: Add glue layer for StarFive JH71x0 SoCs
Date:   Fri, 16 Dec 2022 15:06:30 +0800
Message-ID: <20221216070632.11444-8-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="n"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds StarFive dwmac driver support on the StarFive JH71x0 SoCs.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../stmicro/stmmac/dwmac-starfive-plat.c      | 167 ++++++++++++++++++
 4 files changed, 181 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ff68b8524d2..c7d3229330aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19609,6 +19609,7 @@ F:	include/dt-bindings/clock/starfive*
 STARFIVE DWMAC GLUE LAYER
 M:	Yanhong Wang <yanhong.wang@starfivetech.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/dwmac-starfive-plat.c
 F:	Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
 F:	Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 31ff35174034..ca3d4dd95a95 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -235,6 +235,18 @@ config DWMAC_INTEL_PLAT
 	  the stmmac device driver. This driver is used for the Intel Keem Bay
 	  SoC.
 
+config DWMAC_STARFIVE_PLAT
+	tristate "StarFive dwmac support"
+	depends on OF && COMMON_CLK
+	depends on STMMAC_ETH
+	default SOC_STARFIVE
+	help
+	  Support for ethernet controllers on StarFive RISC-V SoCs
+
+	  This selects the StarFive platform specific glue layer support for
+	  the stmmac device driver. This driver is used for StarFive JH71x0
+	  ethernet controller.
+
 config DWMAC_VISCONTI
 	tristate "Toshiba Visconti DWMAC support"
 	default ARCH_VISCONTI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index d4e12e9ace4f..a63ab0ab5071 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+= dwmac-dwc-qos-eth.o
 obj-$(CONFIG_DWMAC_INTEL_PLAT)	+= dwmac-intel-plat.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
+obj-$(CONFIG_DWMAC_STARFIVE_PLAT)	+= dwmac-starfive-plat.o
 obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
new file mode 100644
index 000000000000..f8b68dd53c91
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * StarFive DWMAC platform driver
+ *
+ * Copyright(C) 2022 StarFive Technology Co., Ltd.
+ *
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+#include "stmmac_platform.h"
+
+struct starfive_dwmac {
+	struct device *dev;
+	struct clk *clk_tx;
+	struct clk *clk_gtx;
+	struct clk *clk_gtxc;
+};
+
+#define JH7100_SYSMAIN_REGISTER28 0x70
+/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
+#define JH7100_SYSMAIN_REGISTER49 0xc8
+
+static int starfive_eth_plat_jh7100_syscon_init(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct regmap *sysmain;
+	u32 gtxclk_dlychain;
+	int ret;
+
+	sysmain = syscon_regmap_lookup_by_phandle(np, "starfive,syscon");
+	if (IS_ERR(sysmain))
+		return dev_err_probe(dev, PTR_ERR(sysmain),
+				     "error getting sysmain registers\n");
+
+	/* Choose RGMII interface to the phy.
+	 * TODO: support other interfaces once we know the meaning of other
+	 * values in the register
+	 */
+	ret = regmap_update_bits(sysmain, JH7100_SYSMAIN_REGISTER28, 0x7, 1);
+	if (ret)
+		return dev_err_probe(dev, ret, "error selecting gmac interface\n");
+
+	if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk_dlychain)) {
+		ret = regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, gtxclk_dlychain);
+		if (ret)
+			return dev_err_probe(dev, ret, "error selecting gtxclk delay chain\n");
+	}
+
+	return 0;
+}
+
+static void starfive_eth_plat_fix_mac_speed(void *priv, unsigned int speed)
+{
+	struct starfive_dwmac *dwmac = priv;
+	unsigned long rate;
+	int err;
+
+	switch (speed) {
+	case SPEED_1000:
+		rate = 125000000;
+		break;
+	case SPEED_100:
+		rate = 25000000;
+		break;
+	case SPEED_10:
+		rate = 2500000;
+		break;
+	default:
+		dev_err(dwmac->dev, "invalid speed %u\n", speed);
+		return;
+	}
+
+	err = clk_set_rate(dwmac->clk_gtx, rate);
+	if (err)
+		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
+}
+
+static int starfive_eth_plat_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct starfive_dwmac *dwmac;
+	int (*syscon_init)(struct device *dev);
+	int err;
+
+	err = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (err)
+		return err;
+
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat)) {
+		dev_err(&pdev->dev, "dt configuration failed\n");
+		return PTR_ERR(plat_dat);
+	}
+
+	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac)
+		return -ENOMEM;
+
+	syscon_init = of_device_get_match_data(&pdev->dev);
+	if (syscon_init) {
+		err = syscon_init(&pdev->dev);
+		if (err)
+			return err;
+	}
+
+	dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
+	if (IS_ERR(dwmac->clk_tx))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
+						"error getting tx clock\n");
+
+	dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
+	if (IS_ERR(dwmac->clk_gtx))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
+						"error getting gtx clock\n");
+
+	/* Only StarFive JH7110 SoC support gtxc clock */
+	if (of_device_is_compatible(pdev->dev.of_node, "starfive,jh7110-dwmac")) {
+		dwmac->clk_gtxc = devm_clk_get_enabled(&pdev->dev, "gtxc");
+		if (IS_ERR(dwmac->clk_gtxc))
+			return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
+							"error getting gtxc clock\n");
+	}
+
+	dwmac->dev = &pdev->dev;
+	plat_dat->fix_mac_speed = starfive_eth_plat_fix_mac_speed;
+	plat_dat->init = NULL;
+	plat_dat->bsp_priv = dwmac;
+	plat_dat->dma_cfg->dche = true;
+
+	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (err) {
+		stmmac_remove_config_dt(pdev, plat_dat);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id starfive_eth_plat_match[] = {
+	{
+		.compatible = "starfive,jh7110-dwmac"
+	},
+	{
+		.compatible = "starfive,jh7100-dwmac",
+		.data = starfive_eth_plat_jh7100_syscon_init,
+	},
+	{ }
+};
+
+static struct platform_driver starfive_eth_plat_driver = {
+	.probe  = starfive_eth_plat_probe,
+	.remove = stmmac_pltfr_remove,
+	.driver = {
+		.name = "starfive-eth-plat",
+		.pm = &stmmac_pltfr_pm_ops,
+		.of_match_table = starfive_eth_plat_match,
+	},
+};
+
+module_platform_driver(starfive_eth_plat_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("StarFive DWMAC platform driver");
+MODULE_AUTHOR("Yanhong Wang <yanhong.wang@starfivetech.com>");
-- 
2.17.1

