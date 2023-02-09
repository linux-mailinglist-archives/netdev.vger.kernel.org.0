Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7C690CAC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjBIPPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjBIPPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:15:07 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53C3643E8;
        Thu,  9 Feb 2023 07:14:46 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2E244100009;
        Thu,  9 Feb 2023 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675955685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+b40twGxCdSc5QQc2SQJSyKNWqs4/oSfyFtqvqrIBhE=;
        b=TnAXLvutxsoV6SQPVLC5IpOYUVeKfybmBcXAoMhkGOpU6H6V8PNfgml/lve5R4qszfbMaO
        7ZkfVOy3sU5aE/eVcpgo7GLYcdEH4kOi489P9EzR4IdOr3Lhjaa2aT3svQk25Nrz2X5oSy
        bffTADKtd9mJXOYB+d0qo8Vc9aTlKYnChJFdMwleyqgM45LtVmsg0v7PX/C5kYM+Vt7iQO
        2Z03pqKdAytD3qBBKes1xD3W0TI8itOOGEbEiw2JhnVlHIt4KuEZSZ+uoaakXMKP4sLh9B
        qyBt7L3uBqwyi+TruoKNio0dVYazReU+lJD2B6KYLzQua6VTLW9fx2WN66QIXg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v3 5/6] net: stmmac: add support for RZ/N1 GMAC
Date:   Thu,  9 Feb 2023 16:16:31 +0100
Message-Id: <20230209151632.275883-6-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209151632.275883-1-clement.leger@bootlin.com>
References: <20230209151632.275883-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Renesas RZ/N1 GMAC. This support uses a custom PCS (MIIC)
which is handle by parsing the pcs-handle device tree property.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-rzn1.c  | 120 ++++++++++++++++++
 3 files changed, 132 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index f77511fe4e87..be5429b7e192 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -153,6 +153,17 @@ config DWMAC_ROCKCHIP
 	  This selects the Rockchip RK3288 SoC glue layer support for
 	  the stmmac device driver.
 
+config DWMAC_RZN1
+	tristate "Renesas RZ/N1 dwmac support"
+	default ARCH_RZN1
+	depends on OF && (ARCH_RZN1 || COMPILE_TEST)
+	select PCS_RZN1_MIIC
+	help
+	  Support for Ethernet controller on Renesas RZ/N1 SoC family.
+
+	  This selects the Renesas RZ/N1 SoC glue layer support for
+	  the stmmac device driver.
+
 config DWMAC_SOCFPGA
 	tristate "SOCFPGA dwmac support"
 	default ARCH_INTEL_SOCFPGA
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 057e4bab5c08..53a0f74c1cb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_DWMAC_MESON)	+= dwmac-meson.o dwmac-meson8b.o
 obj-$(CONFIG_DWMAC_OXNAS)	+= dwmac-oxnas.o
 obj-$(CONFIG_DWMAC_QCOM_ETHQOS)	+= dwmac-qcom-ethqos.o
 obj-$(CONFIG_DWMAC_ROCKCHIP)	+= dwmac-rk.o
+obj-$(CONFIG_DWMAC_RZN1)	+= dwmac-rzn1.o
 obj-$(CONFIG_DWMAC_SOCFPGA)	+= dwmac-altr-socfpga.o
 obj-$(CONFIG_DWMAC_STI)		+= dwmac-sti.o
 obj-$(CONFIG_DWMAC_STM32)	+= dwmac-stm32.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c
new file mode 100644
index 000000000000..82118d8cb50e
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Schneider-Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#include <linux/of.h>
+#include <linux/pcs-rzn1-miic.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+
+#include "stmmac_platform.h"
+#include "stmmac.h"
+
+struct rzn1_dwmac {
+	struct phylink_pcs *pcs;
+};
+
+static int rzn1_dt_parse(struct device *dev, struct rzn1_dwmac *dwmac)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *pcs_node;
+	struct phylink_pcs *pcs;
+	int ret;
+
+	pcs_node = of_parse_phandle(np, "pcs-handle", 0);
+	if (!pcs_node)
+		return 0;
+
+	pcs = miic_create(dev, pcs_node);
+	if (IS_ERR(pcs))
+		return PTR_ERR(pcs);
+
+	ret = miic_early_setup(pcs, dev);
+	if (ret) {
+		miic_destroy(pcs);
+		return ret;
+	}
+
+	dwmac->pcs = pcs;
+
+	return 0;
+}
+
+static int rzn1_dwmac_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct device *dev = &pdev->dev;
+	struct rzn1_dwmac *dwmac;
+	int ret;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
+
+	dwmac = devm_kzalloc(dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac) {
+		ret = -ENOMEM;
+		goto err_remove_config_dt;
+	}
+
+	ret = rzn1_dt_parse(dev, dwmac);
+	if (ret)
+		goto err_remove_config_dt;
+
+	plat_dat->bsp_priv = dwmac;
+	plat_dat->pcs = dwmac->pcs;
+
+	ret = stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_free_pcs;
+
+	return 0;
+
+err_free_pcs:
+	if (dwmac->pcs)
+		miic_destroy(dwmac->pcs);
+
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
+	return ret;
+}
+
+static int rzn1_dwmac_remove(struct platform_device *pdev)
+{
+	struct rzn1_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
+	int ret = stmmac_dvr_remove(&pdev->dev);
+
+	if (dwmac->pcs)
+		miic_destroy(dwmac->pcs);
+
+	return ret;
+}
+
+static const struct of_device_id rzn1_dwmac_match[] = {
+	{ .compatible = "renesas,rzn1-gmac" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, rzn1_dwmac_match);
+
+static struct platform_driver rzn1_dwmac_driver = {
+	.probe  = rzn1_dwmac_probe,
+	.remove = rzn1_dwmac_remove,
+	.driver = {
+		.name           = "rzn1-dwmac",
+		.of_match_table = rzn1_dwmac_match,
+	},
+};
+module_platform_driver(rzn1_dwmac_driver);
+
+MODULE_AUTHOR("Clément Léger <clement.leger@bootlin.com>");
+MODULE_DESCRIPTION("Renesas RZN1 DWMAC specific glue layer");
+MODULE_LICENSE("GPL");
-- 
2.39.0

