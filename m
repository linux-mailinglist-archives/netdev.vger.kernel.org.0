Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6B63EC78
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiLAJ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiLAJ3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:29:54 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0744FF86;
        Thu,  1 Dec 2022 01:29:48 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id E527F24E257;
        Thu,  1 Dec 2022 17:02:07 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 1 Dec
 2022 17:02:08 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Thu, 1 Dec 2022 17:02:06 +0800
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
Subject: [PATCH v1 5/7] net: stmmac: Add StarFive dwmac supoort
Date:   Thu, 1 Dec 2022 17:02:40 +0800
Message-ID: <20221201090242.2381-6-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS065.cuchost.com (172.16.6.25) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds StarFive dwmac driver support on the StarFive JH7110 SoCs.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../stmicro/stmmac/dwmac-starfive-plat.c      | 147 ++++++++++++++++++
 4 files changed, 160 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7eaaec8d3b96..36cb00cf860b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19610,6 +19610,7 @@ STARFIVE DWMAC GLUE LAYER
 M:	Yanhong Wang <yanhong.wang@starfivetech.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
+F:	drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
 
 STARFIVE PINCTRL DRIVER
 M:	Emil Renner Berthing <kernel@esmil.dk>
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 31ff35174034..1e29cd3770b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -235,6 +235,17 @@ config DWMAC_INTEL_PLAT
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
+	  the stmmac device driver. This driver is used for StarFive RISC-V SoCs.
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
index 000000000000..8fbf584d4e19
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * StarFive DWMAC platform driver
+ *
+ * Copyright(C) 2022 StarFive Technology Co., Ltd.
+ *
+ */
+
+#include <linux/of_device.h>
+#include "stmmac_platform.h"
+
+struct starfive_dwmac {
+	struct device *dev;
+	struct clk *clk_tx;
+	struct clk *clk_gtx;
+	struct clk *clk_gtxc;
+};
+
+static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
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
+static void dwmac_starfive_clk_disable(void *clk)
+{
+	clk_disable_unprepare(clk);
+}
+
+static int starfive_eth_plat_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct starfive_dwmac *dwmac;
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
+	dwmac->clk_tx = devm_clk_get(&pdev->dev, "tx");
+	if (IS_ERR(dwmac->clk_tx))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
+						"error getting tx clock\n");
+
+	err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
+			      dwmac->clk_tx);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(dwmac->clk_tx);
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "error enabling tx clock\n");
+
+	dwmac->clk_gtx = devm_clk_get(&pdev->dev, "gtx");
+	if (IS_ERR(dwmac->clk_gtx))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
+						"error getting gtx clock\n");
+
+	err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
+			      dwmac->clk_gtx);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(dwmac->clk_gtx);
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "error enabling gtx clock\n");
+
+	dwmac->clk_gtxc = devm_clk_get(&pdev->dev, "gtxc");
+	if (IS_ERR(dwmac->clk_gtxc))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
+						"error getting gtxc clock\n");
+
+	err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
+			      dwmac->clk_gtxc);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(dwmac->clk_gtxc);
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "error enabling gtxc clock\n");
+
+	dwmac->dev = &pdev->dev;
+	plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;
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
+	{.compatible = "starfive,dwmac"},
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

