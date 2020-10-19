Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD1A29233F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgJSH6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:58:18 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:51266
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728570AbgJSH6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:58:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Omrokz4WgmYHtwrFblKBcp/jx2tPty9jtRBVp/QbI1vQHhEUW8goyVI/5j4HrYeqTvH0gLOyalUr2DONLHkXIJxWStcGyEC67XBnKavsW+impBOuNkSeGT9YwfJqTeA525HC3CPDYsgohC71vIF+4E0TS2jq/JiFKmQfUiy79oT55pSgYXYUItdit0zQ4J88345rtqDs1jfrcF/jAJ0EQGgBKLAuAo10KOmSJAqI/IAVokclCuV4GGRUAGzTsXaguHx9Y74tAt1dzMc4lpzWzG7FoSPiitMmomYc7QKk/sALphTK2yzhG+JhXVyuPnCD0Wvgi/olXwt5jX1qzx6Zcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5PTBAvCw3PJiXmYefQzyZfL7s8rHcWnc5BjSN3brVM=;
 b=WJk0jtrJp0ltwsl/dlnjG3Q4+hDp0a/4RcZxfcsQ0lxgcaGDfR4Xhfe3x1J9WPJxyJlEHNCYV2DXTIOI7vdjquZNVjdyoVPJPo/fvtYn64+41ldt46rGaIZGIpvjerzVHFOK3zMJub1dbmLuqaFGDzHebNGUIkLlrHr0XFNNKTjFPtZZam+ezXirQcMP0xTbJusFgS07C3JoJj1xMSeJeMWwbCykXesHepzFjVYKGC4FSr9ZCG0fGP1/5r42DfJLKsYvnoyRdrdmflMNv2Vn7uxwl5Y0jjS1svljPKFRONXl+KjIMgmMm/pgXxZiCH3mO1k3XyCc4riCRSWGn7qdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5PTBAvCw3PJiXmYefQzyZfL7s8rHcWnc5BjSN3brVM=;
 b=kUAXdBx15icniqLVSq3sXGASL1Yp15baY4LMADgh6TX3PcM1osH1MrP8hIY0kZTmqmjpor+Ecx0l09yglUihE949zRR4cRlZ6pskQa02k74ej7RLesSu9lQr89/61fcOAJ6qyNUVa6K/Bjp2cNoRRoKUGDPF2RxpDNy/yChtJn4=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3963.eurprd04.prod.outlook.com (2603:10a6:5:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 07:58:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:58:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 8/8] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Mon, 19 Oct 2020 23:57:37 +0800
Message-Id: <20201019155737.26577-9-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 337f9a8e-84be-4ef6-9cd3-08d87404b97a
X-MS-TrafficTypeDiagnostic: DB7PR04MB3963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB39635504298C65FF96DB5A6DE61E0@DB7PR04MB3963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1PSLJly6fobR2IeLdQJmM3U/8dp00Ws+f/kPrxElu6V+ccNNOyayw4pw3bNJDeswVmSE3UfAzoDUSoEMGbt/5IncT+MQ9PNAii1HRqrI0Vu5tN0siA+fovPQm69dKnuyDlOu0q+p4uJUH6RWdCylyIG5ZBEGTi4L401rp1/qYs0DdlKuoeLgfznYKbD6jnwyoLGVHfi3u/wK6egvc0BAcVncO7pRUnBWsiLNAp3TYhcn0jpyLTSZhIohiwE4UtoP5QUmo2ulD+6Tzj9KyFe7RG7TD1TPV2aMJznk3D8TV3q7fWx/yTKTAYBZEvpCayXQXCRGQWxlEbHBE02/1crZgfGcHsi29IUg88zpXWLP4mNRaRXMpP9K8+XyUKE5n23
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(69590400008)(86362001)(6512007)(478600001)(2906002)(316002)(5660300002)(36756003)(1076003)(83380400001)(186003)(16526019)(956004)(2616005)(8676002)(8936002)(26005)(66556008)(66946007)(66476007)(6486002)(52116002)(6666004)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZpQ3yw2S+kVfuBZOMXtJyvWNINs6EuUggTYyYL2tgmmuxd55CehaI6NXEEI4CAC27cEDDnRo0EhEQomKgiDO099qRKANJaCxRzb1QgVr13U22qe1QmBBUpzxDenvA0IHvJl05MRv4QFbpnCAc2yTejLGFa1NyMwKB53zsSuU9sDfP++N2aH8+TwiwzXR2ZrFXd5jMyOdZg319y1dD6kRAkrHx9A2GE3+dwx3jiVOByvSrmDuSDMyB4+Cyvm0KeVmorwbn6jKCCSLw/LqNoPK2o1Nid3ahJrQwfyzxjm7bLbWagM7lUv8KtPXz5fYAGiMHaPYA0ZegrjymXwJpoSU8HILF1QJpc+6sUzlMJuxnQeWNnZe4ixoZ8ZegQGK5ca84/pIHzg2HCCErr+4JLVJf+LkiIRYyT/piIJHknKE4Q8h5QTL4tuLbLA+BSsUuwFocTLLE6NkhmDt/hrewLSXkm+NxDT5eqKqwrpQb89zkkMaRR0U2iwMC26rY0nd0R/5vRc4mdQEHPyxgImwLTFRI4o5wrDCXZ4qHLqMfTfjJw5AuLb7d3BbeI56oEApIDxu8N5Bo6POooNrvr0JRz1dCqCQku8Cu5nf/emZzcGih2e0Gvrp50ggqHbC2FPE6qjQHBIVX47myhTKy2/pvvcBpg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337f9a8e-84be-4ef6-9cd3-08d87404b97a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:58:11.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAGlQmXC3y770K9t2y5HAArGeTxxetkOLAyje0sSV8a650ms7PKzmNisCp9t+56FEf8R4WLpqjnAfR0Pd8sQdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3963
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
 drivers/net/can/flexcan.c | 131 +++++++++++++++++++++++++++++++++-----
 1 file changed, 114 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c0cdee904ca7..8ad5065c918f 100644
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
@@ -203,6 +205,8 @@
 
 #define FLEXCAN_TIMEOUT_US		(250)
 
+#define FLEXCAN_IMX_SC_R_CAN(x)		(IMX_SC_R_CAN_0 + (x))
+
 /* FLEXCAN hardware feature flags
  *
  * Below is some version info we got:
@@ -242,6 +246,8 @@
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
 /* support memory detection and correction */
 #define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
+/* Setup stop mode with SCU firmware to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -347,6 +353,7 @@ struct flexcan_priv {
 	u8 mb_count;
 	u8 mb_size;
 	u8 clk_src;	/* clock source of CAN Protocol Engine */
+	u8 can_idx;
 
 	u64 rx_mask;
 	u64 tx_mask;
@@ -358,6 +365,9 @@ struct flexcan_priv {
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
+	/* IPC handle when setup stop mode by System Controller firmware(scfw) */
+	struct imx_sc_ipc *sc_ipc_handle;
+
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
 	void (*write)(u32 val, void __iomem *addr);
@@ -387,7 +397,7 @@ static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
@@ -546,18 +556,42 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
 
+static int flexcan_stop_mode_enable_scfw(struct flexcan_priv *priv, bool enabled)
+{
+	u8 idx = priv->can_idx;
+	u32 rsrc_id, val;
+
+	rsrc_id = FLEXCAN_IMX_SC_R_CAN(idx);
+
+	if (enabled)
+		val = 1;
+	else
+		val = 0;
+
+	/* stop mode request via scu firmware */
+	return imx_sc_misc_set_control(priv->sc_ipc_handle, rsrc_id,
+				       IMX_SC_C_IPG_STOP, val);
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
@@ -566,10 +600,17 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
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
@@ -1838,7 +1879,7 @@ static void unregister_flexcandev(struct net_device *dev)
 	unregister_candev(dev);
 }
 
-static int flexcan_setup_stop_mode(struct platform_device *pdev)
+static int flexcan_setup_stop_mode_gpr(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
@@ -1883,11 +1924,6 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		"gpr %s req_gpr=0x02%x req_bit=%u\n",
 		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit);
 
-	device_set_wakeup_capable(&pdev->dev, true);
-
-	if (of_property_read_bool(np, "wakeup-source"))
-		device_set_wakeup_enable(&pdev->dev, true);
-
 	return 0;
 
 out_put_node:
@@ -1895,6 +1931,64 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 	return ret;
 }
 
+static int flexcan_setup_stop_mode_scfw(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct flexcan_priv *priv;
+	u8 can_idx;
+	int ret;
+
+	ret = of_property_read_u8(pdev->dev.of_node, "fsl,scu-index", &can_idx);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "failed to get scu index\n");
+		return ret;
+	}
+
+	priv = netdev_priv(dev);
+	priv->can_idx = can_idx;
+
+	/* this function could be defered probe, return -EPROBE_DEFER */
+	ret = imx_scu_get_handle(&priv->sc_ipc_handle);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "get ipc handle used by SCU failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/* flexcan_setup_stop_mode - Setup stop mode for wakeup
+ *
+ * Return: = 0 setup stop mode successfully or doesn't support this feature
+ *         < 0 fail to setup stop mode (could be defered probe)
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
+		/* return 0 directly if doesn't support stop mode feature */
+		return 0;
+
+	if (ret)
+		return ret;
+
+	device_set_wakeup_capable(&pdev->dev, true);
+
+	if (of_property_read_bool(pdev->dev.of_node, "wakeup-source"))
+		device_set_wakeup_enable(&pdev->dev, true);
+
+	return 0;
+}
+
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
 	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
@@ -2040,17 +2134,19 @@ static int flexcan_probe(struct platform_device *pdev)
 		goto failed_register;
 	}
 
+	err = flexcan_setup_stop_mode(pdev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "setup stop mode failed\n");
+		goto failed_canregister;
+	}
+
 	of_can_transceiver(dev);
 	devm_can_led_init(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
-		err = flexcan_setup_stop_mode(pdev);
-		if (err)
-			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
-	}
-
 	return 0;
 
+ failed_canregister:
+	unregister_flexcandev(dev);
  failed_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -2062,6 +2158,7 @@ static int flexcan_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
+	device_set_wakeup_enable(&pdev->dev, false);
 	unregister_flexcandev(dev);
 	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
-- 
2.17.1

