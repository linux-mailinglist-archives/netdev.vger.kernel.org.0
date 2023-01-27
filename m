Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D203E67EB32
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbjA0QmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbjA0QmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:42:09 -0500
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85BA7CC89;
        Fri, 27 Jan 2023 08:42:06 -0800 (PST)
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RF4Xot005261;
        Fri, 27 Jan 2023 17:41:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=CN5+5k2VdREt4EDJdVH4aJBpM4dDO3hcGBGhwxdkT7g=;
 b=NKd99bY2CSsEVNueGI3UVFB6jkFUNJzkDvRbo4PHEdlzDp+ihVOMv8Ws9XyYjbDRui4V
 X4zImj2UgQOUXMa/u+YpbLIw6inbQ1jk2eDxlGV1Sso8FGm4VoUeo8Wp5HKYPYFZ6/rP
 T+DPQgOmGvf9JVqI+QENmhw3QdpsfPIz/hfxCKLTPrdRESV++HCYOCkgD2Uz4lNBGQqC
 53J1+K2eZocappZtxh9PQBLwFkUbw+e8qBkCOmtS1c3Sozas2tqu7cpE2fqrPcESYJQg
 hfIbmqH4PnykNwNYWbxANfojwZSAYAWSO7fIAa9PnRZ30u2MkDM8HfOjRvRA9Ix8EqgH hw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3nbykcxq8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 17:41:26 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 96E0610003A;
        Fri, 27 Jan 2023 17:41:24 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8E01C21ED21;
        Fri, 27 Jan 2023 17:41:24 +0100 (CET)
Received: from localhost (10.201.21.177) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.13; Fri, 27 Jan
 2023 17:41:24 +0100
From:   Gatien Chevallier <gatien.chevallier@foss.st.com>
To:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <jic23@kernel.org>, <olivier.moysan@foss.st.com>,
        <arnaud.pouliquen@foss.st.com>, <mchehab@kernel.org>,
        <fabrice.gasnier@foss.st.com>, <ulf.hansson@linaro.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>,
        Loic PALLARDY <loic.pallardy@st.com>
Subject: [PATCH v3 4/6] bus: stm32_sys_bus: add support for STM32MP15 and STM32MP13 system bus
Date:   Fri, 27 Jan 2023 17:40:38 +0100
Message-ID: <20230127164040.1047583-5-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.201.21.177]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_10,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is checking the access rights of the different
peripherals connected to the system bus. If access is denied,
the associated device tree node is skipped so the platform bus
does not probe it.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Loic PALLARDY <loic.pallardy@st.com>
---

No changes in V2.

Changes in V3:
	- Remove useless sys_bus_get_access and unused map_table fields in
	stm32_sys_bus_match_data structure
	- Use devm_platform_ioremap_resource() helper
	- Clean check on of_device_get_match_data() and remove unused local
	variables in stm32_sys_bus_probe().

 MAINTAINERS                 |   6 ++
 drivers/bus/Kconfig         |   9 ++
 drivers/bus/Makefile        |   1 +
 drivers/bus/stm32_sys_bus.c | 168 ++++++++++++++++++++++++++++++++++++
 4 files changed, 184 insertions(+)
 create mode 100644 drivers/bus/stm32_sys_bus.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b74014994f5..aafe32aa1925 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19782,6 +19782,12 @@ L:	linux-spi@vger.kernel.org
 S:	Maintained
 F:	drivers/spi/spi-stm32.c
 
+ST STM32 SYS BUS DRIVER
+M:	Gatien Chevallier <gatien.chevallier@foss.st.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/bus/st,sys-bus.yaml
+F:	drivers/bus/stm32_sys_bus.c
+
 ST STPDDC60 DRIVER
 M:	Daniel Nilsson <daniel.nilsson@flex.com>
 L:	linux-hwmon@vger.kernel.org
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 7bfe998f3514..3f7bc1f67916 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -163,6 +163,15 @@ config QCOM_SSC_BLOCK_BUS
 	  i2c/spi/uart controllers, a hexagon core, and a clock controller
 	  which provides clocks for the above.
 
+config STM32_SYS_BUS
+	bool "STM32 System bus controller"
+	depends on ARCH_STM32 || COMPILE_TEST
+	default MACH_STM32MP157 || MACH_STM32MP13
+	help
+	  Say y to enable device access right verification before device probing.
+	  If access not granted, device won't be probed and an error message will
+	  provide the reason.
+
 config SUN50I_DE2_BUS
 	bool "Allwinner A64 DE2 Bus Driver"
 	  default ARM64
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index d90eed189a65..b15fdc42d0be 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
 obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 obj-$(CONFIG_QCOM_EBI2)		+= qcom-ebi2.o
 obj-$(CONFIG_QCOM_SSC_BLOCK_BUS)	+= qcom-ssc-block-bus.o
+obj-$(CONFIG_STM32_SYS_BUS)	+= stm32_sys_bus.o
 obj-$(CONFIG_SUN50I_DE2_BUS)	+= sun50i-de2.o
 obj-$(CONFIG_SUNXI_RSB)		+= sunxi-rsb.o
 obj-$(CONFIG_OF)		+= simple-pm-bus.o
diff --git a/drivers/bus/stm32_sys_bus.c b/drivers/bus/stm32_sys_bus.c
new file mode 100644
index 000000000000..c12926466bae
--- /dev/null
+++ b/drivers/bus/stm32_sys_bus.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023, STMicroelectronics - All Rights Reserved
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+/* ETZPC peripheral as firewall bus */
+/* ETZPC registers */
+#define ETZPC_DECPROT			0x10
+
+/* ETZPC miscellaneous */
+#define ETZPC_PROT_MASK			GENMASK(1, 0)
+#define ETZPC_PROT_A7NS			0x3
+#define ETZPC_DECPROT_SHIFT		1
+
+#define IDS_PER_DECPROT_REGS		16
+#define STM32MP15_ETZPC_ENTRIES		96
+#define STM32MP13_ETZPC_ENTRIES		64
+
+struct sys_bus_data;
+
+struct stm32_sys_bus_match_data {
+	unsigned int max_entries;
+};
+
+struct sys_bus_data {
+	const struct stm32_sys_bus_match_data *pconf;
+	void __iomem *sys_bus_base;
+	struct device *dev;
+};
+
+static int stm32_sys_bus_get_periph_id(struct sys_bus_data *pdata, struct device_node *np, u32 *id)
+{
+	int err;
+	u32 feature_domain_cell[2];
+	u32 id_bus;
+
+	/* Get reg from device node */
+	err = of_property_read_u32_array(np, "feature-domains", feature_domain_cell, 2);
+	if (err) {
+		dev_err(pdata->dev, "Unable to find feature-domains property\n");
+		return -ENODEV;
+	}
+
+	id_bus = feature_domain_cell[1];
+
+	if (id_bus >= pdata->pconf->max_entries) {
+		dev_err(pdata->dev, "Invalid sys bus ID for %s\n", np->full_name);
+		return -EINVAL;
+	}
+
+	*id = id_bus;
+
+	return 0;
+}
+
+static int stm32_etzpc_get_access(struct sys_bus_data *pdata, struct device_node *np)
+{
+	int err;
+	u32 offset, reg_offset, sec_val, id;
+
+	err = stm32_sys_bus_get_periph_id(pdata, np, &id);
+	if (err)
+		return err;
+
+	/* Check access configuration, 16 peripherals per register */
+	reg_offset = ETZPC_DECPROT + 0x4 * (id / IDS_PER_DECPROT_REGS);
+	offset = (id % IDS_PER_DECPROT_REGS) << ETZPC_DECPROT_SHIFT;
+
+	/* Verify peripheral is non-secure and attributed to cortex A7 */
+	sec_val = (readl(pdata->sys_bus_base + reg_offset) >> offset) & ETZPC_PROT_MASK;
+	if (sec_val != ETZPC_PROT_A7NS) {
+		dev_dbg(pdata->dev, "Invalid bus configuration: reg_offset %#x, value %d\n",
+			reg_offset, sec_val);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+static void stm32_sys_bus_populate(struct sys_bus_data *pdata)
+{
+	struct device *parent;
+	struct device_node *child;
+
+	parent = pdata->dev;
+
+	dev_dbg(parent, "Populating %s system bus\n", pdata->dev->driver->name);
+
+	for_each_available_child_of_node(dev_of_node(parent), child) {
+		if (stm32_etzpc_get_access(pdata, child)) {
+			/*
+			 * Peripheral access not allowed.
+			 * Mark the node as populated so platform bus won't probe it
+			 */
+			of_node_set_flag(child, OF_POPULATED);
+			dev_dbg(parent, "%s: Peripheral will not be probed\n",
+				child->full_name);
+		}
+	}
+}
+
+static int stm32_sys_bus_probe(struct platform_device *pdev)
+{
+	struct sys_bus_data *pdata;
+	void __iomem *mmio;
+	struct device_node *np = pdev->dev.of_node;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	mmio = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(mmio))
+		return PTR_ERR(mmio);
+
+	pdata->sys_bus_base = mmio;
+	pdata->pconf = of_device_get_match_data(&pdev->dev);
+	pdata->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, pdata);
+
+	stm32_sys_bus_populate(pdata);
+
+	/* Populate all available nodes */
+	return of_platform_populate(np, NULL, NULL, &pdev->dev);
+}
+
+static const struct stm32_sys_bus_match_data stm32mp15_sys_bus_data = {
+	.max_entries = STM32MP15_ETZPC_ENTRIES,
+};
+
+static const struct stm32_sys_bus_match_data stm32mp13_sys_bus_data = {
+	.max_entries = STM32MP13_ETZPC_ENTRIES,
+};
+
+static const struct of_device_id stm32_sys_bus_of_match[] = {
+	{ .compatible = "st,stm32mp15-sys-bus", .data = &stm32mp15_sys_bus_data },
+	{ .compatible = "st,stm32mp13-sys-bus", .data = &stm32mp13_sys_bus_data },
+	{}
+};
+MODULE_DEVICE_TABLE(of, stm32_sys_bus_of_match);
+
+static struct platform_driver stm32_sys_bus_driver = {
+	.probe  = stm32_sys_bus_probe,
+	.driver = {
+		.name = "stm32-sys-bus",
+		.of_match_table = stm32_sys_bus_of_match,
+	},
+};
+
+static int __init stm32_sys_bus_init(void)
+{
+	return platform_driver_register(&stm32_sys_bus_driver);
+}
+arch_initcall(stm32_sys_bus_init);
+
-- 
2.35.3

