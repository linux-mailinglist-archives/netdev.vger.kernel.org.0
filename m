Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC158EB11
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiHJLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJLPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:15:05 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1397C6112F;
        Wed, 10 Aug 2022 04:15:04 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27ABEcFp064504;
        Wed, 10 Aug 2022 06:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660130078;
        bh=345I50RE3xKiZyblOsizk7DF3Y9wvhfqaxWDe+NsnIk=;
        h=From:To:CC:Subject:Date;
        b=PfNvAIkmYHDRVi9hTJGrtIpO0vxxF5Ou4/qLjOgTfLGGpr9Rih9jzHirTXqLR1rcx
         IkfJJ+SiaOM55FOa5CvmaQ78iSjy5HrYjMLuJFAIjGujzHTgrr7nsRXa2Ky7QIjub0
         33rRGFBYamj6hBH124CAIZnX8QeRt05obHlkE3tc=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27ABEcwb081752
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Aug 2022 06:14:38 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 10
 Aug 2022 06:14:38 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 10 Aug 2022 06:14:37 -0500
Received: from uda0500640.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27ABEXce131033;
        Wed, 10 Aug 2022 06:14:34 -0500
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
To:     <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <vigneshr@ti.com>, <r-gunasekaran@ti.com>
Subject: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add workaround for errata i2329
Date:   Wed, 10 Aug 2022 16:43:45 +0530
Message-ID: <20220810111345.31200-1-r-gunasekaran@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the CPSW and ICSS peripherals, there is a possibility that the MDIO
interface returns corrupt data on MDIO reads or writes incorrect data
on MDIO writes. There is also a possibility for the MDIO interface to
become unavailable until the next peripheral reset.

The workaround is to configure the MDIO in manual mode and disable the
MDIO state machine and emulate the MDIO protocol by reading and writing
appropriate fields in MDIO_MANUAL_IF_REG register of the MDIO controller
to manipulate the MDIO clock and data pins.

More details about the errata i2329 and the workaround is available in:
https://www.ti.com/lit/er/sprz487a/sprz487a.pdf

Add implementation to disable MDIO state machine, configure MDIO in manual
mode and achieve MDIO read and writes via MDIO Bitbanging

Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
---
Changelog:
v1 -> v2:
1. Use the existing MDIO bitbang framework

v1: https://lore.kernel.org/netdev/20220808111229.11951-1-r-gunasekaran@ti.com/

 drivers/net/ethernet/ti/davinci_mdio.c | 255 +++++++++++++++++++++++--
 1 file changed, 244 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index ea3772618043..387244e6332b 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -26,6 +26,8 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/mdio-bitbang.h>
+#include <linux/sys_soc.h>
 
 /*
  * This timeout definition is a worst-case ultra defensive measure against
@@ -41,6 +43,7 @@
 
 struct davinci_mdio_of_param {
 	int autosuspend_delay_ms;
+	bool manual_mode;
 };
 
 struct davinci_mdio_regs {
@@ -49,6 +52,15 @@ struct davinci_mdio_regs {
 #define CONTROL_IDLE		BIT(31)
 #define CONTROL_ENABLE		BIT(30)
 #define CONTROL_MAX_DIV		(0xffff)
+#define CONTROL_CLKDIV		GENMASK(15, 0)
+
+#define MDIO_MAN_MDCLK_O	BIT(2)
+#define MDIO_MAN_OE		BIT(1)
+#define MDIO_MAN_PIN		BIT(0)
+#define MDIO_MANUALMODE		BIT(31)
+
+#define MDIO_PIN               0
+
 
 	u32	alive;
 	u32	link;
@@ -59,7 +71,9 @@ struct davinci_mdio_regs {
 	u32	userintmasked;
 	u32	userintmaskset;
 	u32	userintmaskclr;
-	u32	__reserved_1[20];
+	u32	manualif;
+	u32	poll;
+	u32	__reserved_1[18];
 
 	struct {
 		u32	access;
@@ -90,6 +104,8 @@ struct davinci_mdio_data {
 	 */
 	bool		skip_scan;
 	u32		clk_div;
+	bool		manual_mode;
+	struct mdiobb_ctrl	bb_ctrl;
 };
 
 static void davinci_mdio_init_clk(struct davinci_mdio_data *data)
@@ -128,9 +144,136 @@ static void davinci_mdio_enable(struct davinci_mdio_data *data)
 	writel(data->clk_div | CONTROL_ENABLE, &data->regs->control);
 }
 
-static int davinci_mdio_reset(struct mii_bus *bus)
+static void davinci_mdio_disable(struct davinci_mdio_data *data)
+{
+	u32 reg;
+
+	/* Disable MDIO state machine */
+	reg = readl(&data->regs->control);
+
+	reg &= ~CONTROL_CLKDIV;
+	reg |= data->clk_div;
+
+	reg &= ~CONTROL_ENABLE;
+	writel(reg, &data->regs->control);
+}
+
+static void davinci_mdio_enable_manual_mode(struct davinci_mdio_data *data)
+{
+	u32 reg;
+	/* set manual mode */
+	reg = readl(&data->regs->poll);
+	reg |= MDIO_MANUALMODE;
+	writel(reg, &data->regs->poll);
+}
+
+static void davinci_set_mdc(struct mdiobb_ctrl *ctrl, int level)
+{
+	struct davinci_mdio_data *data;
+	u32 reg;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+	reg = readl(&data->regs->manualif);
+
+	if (level)
+		reg |= MDIO_MAN_MDCLK_O;
+	else
+		reg &= ~MDIO_MAN_MDCLK_O;
+
+	writel(reg, &data->regs->manualif);
+}
+
+static void davinci_set_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
+{
+	struct davinci_mdio_data *data;
+	u32 reg;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+	reg = readl(&data->regs->manualif);
+
+	if (output)
+		reg |= MDIO_MAN_OE;
+	else
+		reg &= ~MDIO_MAN_OE;
+
+	writel(reg, &data->regs->manualif);
+}
+
+static void  davinci_set_mdio_data(struct mdiobb_ctrl *ctrl, int value)
+{
+	struct davinci_mdio_data *data;
+	u32 reg;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+	reg = readl(&data->regs->manualif);
+
+	if (value)
+		reg |= MDIO_MAN_PIN;
+	else
+		reg &= ~MDIO_MAN_PIN;
+
+	writel(reg, &data->regs->manualif);
+}
+
+static int davinci_get_mdio_data(struct mdiobb_ctrl *ctrl)
+{
+	struct davinci_mdio_data *data;
+	unsigned long reg;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+	reg = readl(&data->regs->manualif);
+	return test_bit(MDIO_PIN, &reg);
+}
+
+static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
+{
+	int ret;
+	struct mdiobb_ctrl *ctrl = bus->priv;
+	struct davinci_mdio_data *data;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+
+	if (phy & ~PHY_REG_MASK || reg & ~PHY_ID_MASK)
+		return -EINVAL;
+
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
+		return ret;
+
+	ret = mdiobb_read(bus, phy, reg);
+
+	pm_runtime_mark_last_busy(data->dev);
+	pm_runtime_put_autosuspend(data->dev);
+
+	return ret;
+}
+
+static int davinci_mdiobb_write(struct mii_bus *bus, int phy, int reg,
+				u16 val)
+{
+	int ret;
+	struct mdiobb_ctrl *ctrl = bus->priv;
+	struct davinci_mdio_data *data;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+
+	if (phy & ~PHY_REG_MASK || reg & ~PHY_ID_MASK)
+		return -EINVAL;
+
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
+		return ret;
+
+	ret = mdiobb_write(bus, phy, reg, val);
+
+	pm_runtime_mark_last_busy(data->dev);
+	pm_runtime_put_autosuspend(data->dev);
+
+	return ret;
+}
+
+static int davinci_mdio_common_reset(struct davinci_mdio_data *data)
 {
-	struct davinci_mdio_data *data = bus->priv;
 	u32 phy_mask, ver;
 	int ret;
 
@@ -138,6 +281,11 @@ static int davinci_mdio_reset(struct mii_bus *bus)
 	if (ret < 0)
 		return ret;
 
+	if (data->manual_mode) {
+		davinci_mdio_disable(data);
+		davinci_mdio_enable_manual_mode(data);
+	}
+
 	/* wait for scan logic to settle */
 	msleep(PHY_MAX_ADDR * data->access_time);
 
@@ -171,6 +319,23 @@ static int davinci_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+static int davinci_mdio_reset(struct mii_bus *bus)
+{
+	struct davinci_mdio_data *data = bus->priv;
+
+	return davinci_mdio_common_reset(data);
+}
+
+static int davinci_mdiobb_reset(struct mii_bus *bus)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+	struct davinci_mdio_data *data;
+
+	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
+
+	return davinci_mdio_common_reset(data);
+}
+
 /* wait until hardware is ready for another user access */
 static inline int wait_for_user_access(struct davinci_mdio_data *data)
 {
@@ -319,6 +484,28 @@ static int davinci_mdio_probe_dt(struct mdio_platform_data *data,
 }
 
 #if IS_ENABLED(CONFIG_OF)
+struct k3_mdio_soc_data {
+	bool manual_mode;
+};
+
+static const struct k3_mdio_soc_data am65_mdio_soc_data = {
+	.manual_mode = true,
+};
+
+static const struct soc_device_attribute k3_mdio_socinfo[] = {
+	{ .family = "AM62X", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ .family = "AM64X", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ .family = "AM64X", .revision = "SR2.0", .data = &am65_mdio_soc_data },
+	{ .family = "AM65X", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ .family = "AM65X", .revision = "SR2.0", .data = &am65_mdio_soc_data },
+	{ .family = "J7200", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ .family = "J7200", .revision = "SR2.0", .data = &am65_mdio_soc_data },
+	{ .family = "J721E", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ .family = "J721E", .revision = "SR2.0", .data = &am65_mdio_soc_data },
+	{ .family = "J721S2", .revision = "SR1.0", .data = &am65_mdio_soc_data},
+	{ /* sentinel */ },
+};
+
 static const struct davinci_mdio_of_param of_cpsw_mdio_data = {
 	.autosuspend_delay_ms = 100,
 };
@@ -331,6 +518,14 @@ static const struct of_device_id davinci_mdio_of_mtable[] = {
 MODULE_DEVICE_TABLE(of, davinci_mdio_of_mtable);
 #endif
 
+static const struct mdiobb_ops davinci_mdiobb_ops = {
+	.owner = THIS_MODULE,
+	.set_mdc = davinci_set_mdc,
+	.set_mdio_dir = davinci_set_mdio_dir,
+	.set_mdio_data = davinci_set_mdio_data,
+	.get_mdio_data = davinci_get_mdio_data,
+};
+
 static int davinci_mdio_probe(struct platform_device *pdev)
 {
 	struct mdio_platform_data *pdata = dev_get_platdata(&pdev->dev);
@@ -340,12 +535,30 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	struct phy_device *phy;
 	int ret, addr;
 	int autosuspend_delay_ms = -1;
+	const struct soc_device_attribute *soc_match_data;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->bus = devm_mdiobus_alloc(dev);
+	data->manual_mode = false;
+	data->bb_ctrl.ops = &davinci_mdiobb_ops;
+
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
+		soc_match_data = soc_device_match(k3_mdio_socinfo);
+		if (soc_match_data && soc_match_data->data) {
+			const struct k3_mdio_soc_data *socdata =
+						soc_match_data->data;
+
+			data->manual_mode = socdata->manual_mode;
+		}
+	}
+
+	if (data->manual_mode)
+		data->bus = alloc_mdio_bitbang(&data->bb_ctrl);
+	else
+		data->bus = devm_mdiobus_alloc(dev);
+
 	if (!data->bus) {
 		dev_err(dev, "failed to alloc mii bus\n");
 		return -ENOMEM;
@@ -371,11 +584,20 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	}
 
 	data->bus->name		= dev_name(dev);
-	data->bus->read		= davinci_mdio_read;
-	data->bus->write	= davinci_mdio_write;
-	data->bus->reset	= davinci_mdio_reset;
+
+	if (data->manual_mode) {
+		data->bus->read		= davinci_mdiobb_read;
+		data->bus->write	= davinci_mdiobb_write;
+		data->bus->reset	= davinci_mdiobb_reset;
+
+		dev_info(dev, "Configuring MDIO in manual mode\n");
+	} else {
+		data->bus->read		= davinci_mdio_read;
+		data->bus->write	= davinci_mdio_write;
+		data->bus->reset	= davinci_mdio_reset;
+		data->bus->priv		= data;
+	}
 	data->bus->parent	= dev;
-	data->bus->priv		= data;
 
 	data->clk = devm_clk_get(dev, "fck");
 	if (IS_ERR(data->clk)) {
@@ -433,9 +655,13 @@ static int davinci_mdio_remove(struct platform_device *pdev)
 {
 	struct davinci_mdio_data *data = platform_get_drvdata(pdev);
 
-	if (data->bus)
+	if (data->bus) {
 		mdiobus_unregister(data->bus);
 
+		if (data->manual_mode)
+			free_mdio_bitbang(data->bus);
+	}
+
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -452,7 +678,9 @@ static int davinci_mdio_runtime_suspend(struct device *dev)
 	ctrl = readl(&data->regs->control);
 	ctrl &= ~CONTROL_ENABLE;
 	writel(ctrl, &data->regs->control);
-	wait_for_idle(data);
+
+	if (!data->manual_mode)
+		wait_for_idle(data);
 
 	return 0;
 }
@@ -461,7 +689,12 @@ static int davinci_mdio_runtime_resume(struct device *dev)
 {
 	struct davinci_mdio_data *data = dev_get_drvdata(dev);
 
-	davinci_mdio_enable(data);
+	if (data->manual_mode) {
+		davinci_mdio_disable(data);
+		davinci_mdio_enable_manual_mode(data);
+	} else {
+		davinci_mdio_enable(data);
+	}
 	return 0;
 }
 #endif
-- 
2.17.1

