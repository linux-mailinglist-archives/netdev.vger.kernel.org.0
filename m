Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD1B58C75C
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242712AbiHHLNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiHHLNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:13:32 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06E95595;
        Mon,  8 Aug 2022 04:13:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 278BDAFq054676;
        Mon, 8 Aug 2022 06:13:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1659957190;
        bh=C/kLeq3Jxc0epknLEoYK0/ntvtTEkMFndk8v3sMnhhY=;
        h=From:To:CC:Subject:Date;
        b=ZhrmwZozrMOkRoPeQ26TCjlXz0qZ9RLifSmX5tIzZNnljyBxJMSjVbs4p63rbUmEc
         e4cLzbT2aNDXQrw0rJ50jdOt341PACj8QJ64XUYbVth8Uka8jK/Db2ntqsfXHbeokT
         jRqMiNgGoUpRF3TIuiJQv8zFu4xojs66FaemF63Y=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 278BDAN8033887
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 8 Aug 2022 06:13:10 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 8
 Aug 2022 06:13:10 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 8 Aug 2022 06:13:10 -0500
Received: from uda0500640.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 278BD6kw028466;
        Mon, 8 Aug 2022 06:13:06 -0500
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
To:     <davem@davemloft.net>
CC:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <vigneshr@ti.com>, <r-gunasekaran@ti.com>
Subject: [RESEND PATCH] net: ethernet: ti: davinci_mdio: Add workaround for errata i2329
Date:   Mon, 8 Aug 2022 16:42:29 +0530
Message-ID: <20220808111229.11951-1-r-gunasekaran@ti.com>
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
mode and achieve MDIO read and writes via software instructions

Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c | 336 ++++++++++++++++++++++++-
 1 file changed, 331 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index ea3772618043..20f979ef1faf 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -26,6 +26,7 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/sys_soc.h>
 
 /*
  * This timeout definition is a worst-case ultra defensive measure against
@@ -39,8 +40,16 @@
 
 #define DEF_OUT_FREQ		2200000		/* 2.2 MHz */
 
+#define MDIO_BITRANGE		0x8000
+#define C22_READ_PATTERN	0x6
+#define C22_WRITE_PATTERN	0x5
+#define C22_BITRANGE		0x8
+#define PHY_BITRANGE		0x10
+#define PHY_DATA_BITRANGE	0x8000
+
 struct davinci_mdio_of_param {
 	int autosuspend_delay_ms;
+	bool manual_mode;
 };
 
 struct davinci_mdio_regs {
@@ -49,6 +58,12 @@ struct davinci_mdio_regs {
 #define CONTROL_IDLE		BIT(31)
 #define CONTROL_ENABLE		BIT(30)
 #define CONTROL_MAX_DIV		(0xffff)
+#define CONTROL_CLKDIV		GENMASK(15, 0)
+
+#define MDIO_MAN_MDCLK_O	BIT(2)
+#define MDIO_MAN_OE		BIT(1)
+#define MDIO_MAN_PIN		BIT(0)
+#define MDIO_MANUALMODE		BIT(31)
 
 	u32	alive;
 	u32	link;
@@ -59,7 +74,9 @@ struct davinci_mdio_regs {
 	u32	userintmasked;
 	u32	userintmaskset;
 	u32	userintmaskclr;
-	u32	__reserved_1[20];
+	u32	manualif;
+	u32	poll;
+	u32	__reserved_1[18];
 
 	struct {
 		u32	access;
@@ -73,6 +90,11 @@ struct davinci_mdio_regs {
 	}	user[];
 };
 
+enum davinci_mdio_manual {
+	MDIO_PIN = 0,
+	MDIO_OE,
+	MDIO_MDCLK,
+};
 static const struct mdio_platform_data default_pdata = {
 	.bus_freq = DEF_OUT_FREQ,
 };
@@ -90,6 +112,8 @@ struct davinci_mdio_data {
 	 */
 	bool		skip_scan;
 	u32		clk_div;
+	u32		mdio_manualif;
+	bool		manual_mode;
 };
 
 static void davinci_mdio_init_clk(struct davinci_mdio_data *data)
@@ -122,12 +146,257 @@ static void davinci_mdio_init_clk(struct davinci_mdio_data *data)
 		data->access_time = 1;
 }
 
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
+
+	data->mdio_manualif = readl(&data->regs->manualif);
+}
+
 static void davinci_mdio_enable(struct davinci_mdio_data *data)
 {
 	/* set enable and clock divider */
 	writel(data->clk_div | CONTROL_ENABLE, &data->regs->control);
 }
 
+static void davinci_mdio_sw_set_bit(struct davinci_mdio_data *data,
+				    enum davinci_mdio_manual bit)
+{
+	u32 man_reg;
+
+	switch (bit) {
+	case MDIO_OE:
+		data->mdio_manualif |= MDIO_MAN_OE;
+		writel(data->mdio_manualif, &data->regs->manualif);
+		break;
+	case MDIO_PIN:
+		data->mdio_manualif |= MDIO_MAN_PIN;
+		writel(data->mdio_manualif, &data->regs->manualif);
+		break;
+	case MDIO_MDCLK:
+		man_reg = readl(&data->regs->manualif);
+		man_reg |= MDIO_MAN_MDCLK_O;
+		writel(man_reg, &data->regs->manualif);
+		data->mdio_manualif = readl(&data->regs->manualif);
+		break;
+	default:
+		break;
+	};
+}
+
+static void davinci_mdio_sw_clr_bit(struct davinci_mdio_data *data,
+				    enum davinci_mdio_manual bit)
+{
+	u32 man_reg;
+
+	switch (bit) {
+	case MDIO_OE:
+		data->mdio_manualif &= ~MDIO_MAN_OE;
+		writel(data->mdio_manualif, &data->regs->manualif);
+		break;
+	case MDIO_PIN:
+		data->mdio_manualif &= ~MDIO_MAN_PIN;
+		writel(data->mdio_manualif, &data->regs->manualif);
+		break;
+	case MDIO_MDCLK:
+		man_reg = readl(&data->regs->manualif);
+		man_reg &= ~MDIO_MAN_MDCLK_O;
+		writel(man_reg, &data->regs->manualif);
+		data->mdio_manualif = readl(&data->regs->manualif);
+		break;
+	default:
+		break;
+	};
+}
+
+static int davinci_mdio_test_man_bit(struct davinci_mdio_data *data,
+				     enum davinci_mdio_manual bit)
+{
+	unsigned long reg;
+
+	reg = readl(&data->regs->manualif);
+	return test_bit(bit, &reg);
+}
+
+static void davinci_mdio_toggle_man_bit(struct davinci_mdio_data *data,
+					enum davinci_mdio_manual bit)
+{
+	davinci_mdio_sw_clr_bit(data, bit);
+	davinci_mdio_sw_set_bit(data, bit);
+}
+
+static void davinci_mdio_man_send_pattern(struct davinci_mdio_data *data,
+					  u32 bitrange, u32 val)
+{
+	u32 i;
+
+	for (i = bitrange; i; i = i >> 1) {
+		if (i & val)
+			davinci_mdio_sw_set_bit(data, MDIO_PIN);
+		else
+			davinci_mdio_sw_clr_bit(data, MDIO_PIN);
+
+		davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+	}
+}
+
+static void davinci_mdio_sw_preamble(struct davinci_mdio_data *data)
+{
+	u32 i;
+
+	davinci_mdio_sw_clr_bit(data, MDIO_OE);
+
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
+
+	for (i = 0; i < 32; i++) {
+		davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+		davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+		davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+		davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+	}
+}
+
+static int davinci_mdio_sw_read(struct mii_bus *bus, int phy_id, int phy_reg)
+{
+	struct davinci_mdio_data *data = bus->priv;
+	u32 reg, i;
+	int ret;
+	u8 ack;
+
+	if (phy_reg & ~PHY_REG_MASK || phy_id & ~PHY_ID_MASK)
+		return -EINVAL;
+
+	ret = pm_runtime_get_sync(data->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(data->dev);
+		return ret;
+	}
+
+	davinci_mdio_disable(data);
+	davinci_mdio_enable_manual_mode(data);
+	davinci_mdio_sw_preamble(data);
+
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_set_bit(data, MDIO_OE);
+
+	 /* Issue clause 22 MII read function {0,1,1,0} */
+	davinci_mdio_man_send_pattern(data, C22_BITRANGE, C22_READ_PATTERN);
+
+	/* Send the device number MSB first */
+	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_id);
+
+	/* Send the register number MSB first */
+	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_reg);
+
+	/* Send turn around cycles */
+	davinci_mdio_sw_clr_bit(data, MDIO_OE);
+
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+	ack = davinci_mdio_test_man_bit(data, MDIO_PIN);
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+	reg = 0;
+	if (ack == 0) {
+		for (i = MDIO_BITRANGE; i; i = i >> 1) {
+			if (davinci_mdio_test_man_bit(data, MDIO_PIN))
+				reg |= i;
+
+			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+		}
+	} else {
+		for (i = MDIO_BITRANGE; i; i = i >> 1)
+			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+		reg = 0xFFFF;
+	}
+
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+	pm_runtime_mark_last_busy(data->dev);
+	pm_runtime_put_autosuspend(data->dev);
+
+	return reg;
+}
+
+static int davinci_mdio_sw_write(struct mii_bus *bus, int phy_id,
+				 int phy_reg, u16 phy_data)
+{
+	struct davinci_mdio_data *data = bus->priv;
+	int ret;
+
+	if ((phy_reg & ~PHY_REG_MASK) || (phy_id & ~PHY_ID_MASK))
+		return -EINVAL;
+
+	ret = pm_runtime_get_sync(data->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(data->dev);
+		return ret;
+	}
+
+	davinci_mdio_disable(data);
+	davinci_mdio_enable_manual_mode(data);
+	davinci_mdio_sw_preamble(data);
+
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_set_bit(data, MDIO_OE);
+
+	/* Issue clause 22 MII write function {0,1,0,1} */
+	davinci_mdio_man_send_pattern(data, C22_BITRANGE, C22_WRITE_PATTERN);
+
+	/* Send the device number MSB first */
+	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_id);
+
+	/* Send the register number MSB first */
+	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_reg);
+
+	/* set turn-around cycles */
+	davinci_mdio_sw_set_bit(data, MDIO_PIN);
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_clr_bit(data, MDIO_PIN);
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+	/* Send Register data MSB first */
+	davinci_mdio_man_send_pattern(data, PHY_DATA_BITRANGE, phy_data);
+	davinci_mdio_sw_clr_bit(data, MDIO_OE);
+
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
+	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
+
+	pm_runtime_mark_last_busy(data->dev);
+	pm_runtime_put_autosuspend(data->dev);
+
+	ret = 0;
+
+	return ret;
+}
+
 static int davinci_mdio_reset(struct mii_bus *bus)
 {
 	struct davinci_mdio_data *data = bus->priv;
@@ -138,6 +407,12 @@ static int davinci_mdio_reset(struct mii_bus *bus)
 	if (ret < 0)
 		return ret;
 
+	if (data->manual_mode) {
+		davinci_mdio_disable(data);
+		davinci_mdio_enable_manual_mode(data);
+		davinci_mdio_sw_preamble(data);
+	}
+
 	/* wait for scan logic to settle */
 	msleep(PHY_MAX_ADDR * data->access_time);
 
@@ -319,6 +594,28 @@ static int davinci_mdio_probe_dt(struct mdio_platform_data *data,
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
+	{ .family = "J721S2", .revision = "SR1.0", .data = &am65_mdio_soc_data },
+	{ /* sentinel */ },
+};
+
 static const struct davinci_mdio_of_param of_cpsw_mdio_data = {
 	.autosuspend_delay_ms = 100,
 };
@@ -340,6 +637,7 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	struct phy_device *phy;
 	int ret, addr;
 	int autosuspend_delay_ms = -1;
+	const struct soc_device_attribute *soc_match_data;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -351,6 +649,8 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	data->manual_mode = false;
+
 	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
 		const struct davinci_mdio_of_param *of_mdio_data;
 
@@ -364,6 +664,15 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 			autosuspend_delay_ms =
 					of_mdio_data->autosuspend_delay_ms;
 		}
+
+		soc_match_data = soc_device_match(k3_mdio_socinfo);
+		if (soc_match_data && soc_match_data->data) {
+			const struct k3_mdio_soc_data *socdata =
+						soc_match_data->data;
+
+			data->manual_mode = socdata->manual_mode;
+		}
+
 	} else {
 		data->pdata = pdata ? (*pdata) : default_pdata;
 		snprintf(data->bus->id, MII_BUS_ID_SIZE, "%s-%x",
@@ -371,8 +680,16 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	}
 
 	data->bus->name		= dev_name(dev);
-	data->bus->read		= davinci_mdio_read;
-	data->bus->write	= davinci_mdio_write;
+
+	if (data->manual_mode) {
+		data->bus->read		= davinci_mdio_sw_read;
+		data->bus->write	= davinci_mdio_sw_write;
+		dev_info(dev, "Configuring MDIO in manual mode\n");
+	} else {
+		data->bus->read		= davinci_mdio_read;
+		data->bus->write	= davinci_mdio_write;
+	}
+
 	data->bus->reset	= davinci_mdio_reset;
 	data->bus->parent	= dev;
 	data->bus->priv		= data;
@@ -452,7 +769,9 @@ static int davinci_mdio_runtime_suspend(struct device *dev)
 	ctrl = readl(&data->regs->control);
 	ctrl &= ~CONTROL_ENABLE;
 	writel(ctrl, &data->regs->control);
-	wait_for_idle(data);
+
+	if (!data->manual_mode)
+		wait_for_idle(data);
 
 	return 0;
 }
@@ -461,7 +780,14 @@ static int davinci_mdio_runtime_resume(struct device *dev)
 {
 	struct davinci_mdio_data *data = dev_get_drvdata(dev);
 
-	davinci_mdio_enable(data);
+	if (data->manual_mode) {
+		davinci_mdio_disable(data);
+		davinci_mdio_enable_manual_mode(data);
+		davinci_mdio_sw_preamble(data);
+	} else {
+		davinci_mdio_enable(data);
+	}
+
 	return 0;
 }
 #endif
-- 
2.17.1

