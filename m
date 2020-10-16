Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB3E28FDC3
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390533AbgJPFnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:51 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33504
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390203AbgJPFnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhgefIQKcVf+CJtigLgwDWa7HZkD5KWJJyLRTmE28Qwqb91hfVoNAvJcsnQTseXS0jJFgarYjEzDdmxdksiPl84Nq/PHBraDgqlYNsy4r+jY49sAg0mjJxz0513PyZB2BMR4KTI2wSQvZZUMDWUq1MxV2fmVEHK1NRvnQQJ/rSo6D4Sl/Ad0XPjBvwWPh8gYeIQ41zxTdrN0K57vL/XVmlPP82hrtTrxZzYPZk+XzCGE1oUQGbm7BHKsft3bsteweXwjf/cNo7R1/+h8T6sTKgi10L+F6WsQjDisVtAbZxpApKip1dE50uH/76KmIAyuHLQMCRw9eFQlmITJQllKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnHxx0jYmLyUOthalg5zK+SHUgy+o5xi82UreyPOqFs=;
 b=f5rv6I4aRVaUcWwTdExynlx/pem8QS7J3zhlhb0Kp8ctPKLOR6g63hY0GAwTVunoz4BJqnd2RSyM1B7kGWn4lnKyTCGXw1qxfNniAwi0vKv8CS6ocfKywABoe5jhSyz8Ksgp5n7uYY3ETML21bBFSxOxeAfBGE20luoEOV0nVcsZgZSpt1wq/rH+rD1CCqD3yECxq3e2JOrKfkQbNiNYI2s90GLCpULSPEmlqRR3f1gdVMwcKxk7lzMwC4DpHE3QNN1IoE+608M11lkq1gsRO+/P72wQvARfXpiDUgzdT0hBQbPAE77k7+j8rVKmtLlOqgA2BENjlj2nX3ndWcvGGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnHxx0jYmLyUOthalg5zK+SHUgy+o5xi82UreyPOqFs=;
 b=D0cCHtd5p9xm1GdnbaUn5Bu92sbaWW2ZilSv05D12kIlhf++OoBx0yFlZRIcIfaB2lMHUiL4WM2J3RVDczM8wjv7MPwHdo9jpNr2rogPK+jilM9OqyYfEjYQo5/vt/mGwmNxm/kp3VXzRna7UnVaveurVleBIacGfnwb9bbd3mc=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Fri, 16 Oct 2020 21:43:19 +0800
Message-Id: <20201016134320.20321-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:43:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd5c06f9-319e-4495-746c-08d871966327
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333F5759FD527682B055FCAE6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBYqR3wcLNZLtvFIjhTfnNRjfNlM3PBJeXNqU6N88u0ByimLQ6NQA3G6OO2F5MXIeecZhWFWRXDbLKlJUpOAVZ4EDOjvIz/oeXh0ulUfQa+RpXfrXSbAj5wxhaaO6aQdLq4jpRB4Nd1xqKMeWVZu2cEHvZkLBQb11yE7p/DW7FX4CPuCfzXC+sR9w8kyy6nunk4+RfxaEc/r9e2goGPXpB4niwQuavheUG33zQ1/s2llLZCq1M++boUatGaag8A6NM1hXLwi3bRJWWM2N7TJhlF9XVIP51oanogwXtRe2IQk+OmmWwJ/OvfBFgMbCveOLgSso9OACloMT9XOUWMXCkAv/AN+GCCg/Wk0LYMCKTqAbHvvzwgRvZU27hzdMCtdbUpPoXPjW3piO3hSUspG0fHXB4tRoLuYAs1IhqKczQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: V7f/+5j5uBLQ9WccAzOGiCmeFkX7ifPJ3oZRuRDmy1I26+waLi/QIiGcAyYBEyk6m3kgBgS7XsjmO0plhGU5OPdNxMhwB4ExCvM4BJ/BQPWgUXB5lY6tjpcJyXLAEfxBMBGKRemYQHW109ovROuKuvriyc2YJkI9wSINSY71W8NUO2NJXEm/mMIHZUKjy2W9MUZxBBpJztOTQ38Aw8gp6T+518eMssoGPkf22ZIgkS+1aFaYklCiK+O+zvG/v19gxadMcr/baoMpaDtPaYXdrW9YfWLpERT3bgMAdLzTIiItnXitnaXxKf7GPKU95Zc49J6oGZWJV3uXm0ww5/X/YCx4hWWkQzmQci+OANxj4IhxudO4TtpNsX8F8ZyY0rCMNtVMjVTZAyr6oIGtg9fo5XTbzjtjZER6cdDfx0aem43ZNLvD9S3wV52mYGAtt6FP4M6lPTCkSpTCGEUuSkbSjr6M9GaPORi7BZe8kXjbTEKuf/ewUBWKdP6HJgqIfcxvqY5mKH6HhtEnVZJEvYUN3ZTRtlix51nf/ITRz+EH1iz3HOAFHx4v7u+t2z8rSM0ooqdV2/HpRAiGek03pXVsvYlSdDqYqdnuDMRIXdsSm5+owpw5jXV7l2q/rDWTkkgO58FlxO+FJeZTlsYwUVVIEQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5c06f9-319e-4495-746c-08d871966327
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:19.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ewryjsx3hx+d8jbOivWfveTfXO6kRmV2XZZ8WAq5UfW4vMg3oAhLXBu3oPFIoYMycXtQWs9lEoW9/IjvBMbaaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The System Controller Firmware (SCFW) is a low-level system function
which runs on a dedicated Cortex-M core to provide power, clock, and
resource management. It exists on some i.MX8 processors. e.g. i.MX8QM
(QM, QP), and i.MX8QX (QXP, DX). SCU driver manages the IPC interface
between host CPU and the SCU firmware running on M4.

For i.MX8QM, stop mode request is controlled by System Controller Unit(SCU)
firmware, this patch introduces FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW quirk
for this function.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 125 ++++++++++++++++++++++++++++++++------
 1 file changed, 107 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e708e7bf28db..a55ea8f27f7c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -9,6 +9,7 @@
 //
 // Based on code originally by Andrey Volkov <avolkov@varma-el.com>
 
+#include <dt-bindings/firmware/imx/rsrc.h>
 #include <linux/bitfield.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -17,6 +18,7 @@
 #include <linux/can/rx-offload.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/firmware/imx/sci.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mfd/syscon.h>
@@ -242,6 +244,8 @@
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
 /* support memory detection and correction */
 #define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
+/* Setup stop mode with SCU firmware to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -347,6 +351,7 @@ struct flexcan_priv {
 	u8 mb_count;
 	u8 mb_size;
 	u8 clk_src;	/* clock source of CAN Protocol Engine */
+	u8 can_idx;
 
 	u64 rx_mask;
 	u64 tx_mask;
@@ -358,6 +363,9 @@ struct flexcan_priv {
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
+	/* IPC handle when setup stop mode by System Controller firmware(scfw) */
+	struct imx_sc_ipc *sc_ipc_handle;
+
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
 	void (*write)(u32 val, void __iomem *addr);
@@ -387,7 +395,7 @@ static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
@@ -546,18 +554,46 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
 
+static int flexcan_stop_mode_enable_scfw(struct flexcan_priv *priv, bool enabled)
+{
+	u8 idx = priv->can_idx;
+	u32 rsrc_id, val;
+
+	if (idx == 0)
+		rsrc_id = IMX_SC_R_CAN_0;
+	else if (idx == 1)
+		rsrc_id = IMX_SC_R_CAN_1;
+	else
+		rsrc_id = IMX_SC_R_CAN_2;
+
+	if (enabled)
+		val = 1;
+	else
+		val = 0;
+
+	/* stop mode request via scu firmware */
+	return imx_sc_misc_set_control(priv->sc_ipc_handle, rsrc_id, IMX_SC_C_IPG_STOP, val);
+}
+
 static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
 	u32 reg_mcr;
+	int ret;
 
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr |= FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
 
 	/* enable stop request */
-	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
-			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+		ret = flexcan_stop_mode_enable_scfw(priv, true);
+		if (ret < 0)
+			return ret;
+	} else {
+		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
+				   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+	}
 
 	return flexcan_low_power_enter_ack(priv);
 }
@@ -566,10 +602,17 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
 	u32 reg_mcr;
+	int ret;
 
 	/* remove stop request */
-	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
-			   1 << priv->stm.req_bit, 0);
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+		ret = flexcan_stop_mode_enable_scfw(priv, false);
+		if (ret < 0)
+			return ret;
+	} else {
+		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
+				   1 << priv->stm.req_bit, 0);
+	}
 
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
@@ -1838,7 +1881,7 @@ static void unregister_flexcandev(struct net_device *dev)
 	unregister_candev(dev);
 }
 
-static int flexcan_setup_stop_mode(struct platform_device *pdev)
+static int flexcan_setup_stop_mode_gpr(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
@@ -1883,11 +1926,6 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		"gpr %s req_gpr=0x02%x req_bit=%u\n",
 		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit);
 
-	device_set_wakeup_capable(&pdev->dev, true);
-
-	if (of_property_read_bool(np, "wakeup-source"))
-		device_set_wakeup_enable(&pdev->dev, true);
-
 	return 0;
 
 out_put_node:
@@ -1895,6 +1933,56 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 	return ret;
 }
 
+static int flexcan_setup_stop_mode_scfw(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct flexcan_priv *priv;
+	int ret;
+
+	priv = netdev_priv(dev);
+
+	/* this function could be defer probe, return -EPROBE_DEFER */
+	ret = imx_scu_get_handle(&priv->sc_ipc_handle);
+	if (ret < 0)
+		dev_dbg(&pdev->dev, "get ipc handle used by SCU failed\n");
+
+	return ret;
+}
+
+/* flexcan_setup_stop_mode - Setup stop mode
+ *
+ * Return: 0 setup stop mode successfully or doesn't support this feature
+ *         -EPROBE_DEFER defer probe
+ *         < 0 fail to setup stop mode
+ */
+static int flexcan_setup_stop_mode(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct flexcan_priv *priv;
+	int ret;
+
+	priv = netdev_priv(dev);
+
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW)
+		ret = flexcan_setup_stop_mode_scfw(pdev);
+	else if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR)
+		ret = flexcan_setup_stop_mode_gpr(pdev);
+	else
+		/* return 0 directly if stop mode is unsupport */
+		return 0;
+
+	if (ret) {
+		dev_warn(&pdev->dev, "failed to setup stop mode\n");
+	} else {
+		device_set_wakeup_capable(&pdev->dev, true);
+
+		if (of_property_read_bool(pdev->dev.of_node, "wakeup-source"))
+			device_set_wakeup_enable(&pdev->dev, true);
+	}
+
+	return ret;
+}
+
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
 	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
@@ -1927,7 +2015,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	struct clk *clk_ipg = NULL, *clk_per = NULL;
 	struct flexcan_regs __iomem *regs;
 	int err, irq;
-	u8 clk_src = 1;
+	u8 clk_src = 1, can_idx = 0;
 	u32 clock_freq = 0;
 
 	reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
@@ -1943,6 +2031,8 @@ static int flexcan_probe(struct platform_device *pdev)
 				     "clock-frequency", &clock_freq);
 		of_property_read_u8(pdev->dev.of_node,
 				    "fsl,clk-source", &clk_src);
+		of_property_read_u8(pdev->dev.of_node,
+				    "fsl,can-index", &can_idx);
 	}
 
 	if (!clock_freq) {
@@ -2019,6 +2109,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->clk_src = clk_src;
 	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
+	priv->can_idx = can_idx;
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
@@ -2030,6 +2121,10 @@ static int flexcan_probe(struct platform_device *pdev)
 		priv->can.bittiming_const = &flexcan_bittiming_const;
 	}
 
+	err = flexcan_setup_stop_mode(pdev);
+	if (err == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
@@ -2043,12 +2138,6 @@ static int flexcan_probe(struct platform_device *pdev)
 	of_can_transceiver(dev);
 	devm_can_led_init(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
-		err = flexcan_setup_stop_mode(pdev);
-		if (err)
-			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
-	}
-
 	return 0;
 
  failed_register:
-- 
2.17.1

