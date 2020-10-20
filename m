Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC881293634
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405697AbgJTHyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:51 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:11069
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405589AbgJTHys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3IGgny4KNNDLvNXcJAdyULmU53GfcAdVJAvNLKC18b9ik+E7FDyH46OmoRvU1gRTYruZNfCDZ9zCI5zFxxLH5hsgQ+6HUrK58lQC3RkMa2N5yI9T6YRHOGyA0YzvvUughFPNdOUYsBXSwEjvnJDBVx/LImwpvLCSIqzj0ctGJOEkl64b48bwp5Es5XzNzahvT3UuIiSEIESS73TNlDskoTG1RJirV2BiotG8igmM7qYlw7l9A07fVOM+ZfSwae4Rxb1/jS16DntWssB4fOi+JtGxEyZQQatcQUW5Q2OZi7Wa3WyuIa4CVAnoHFEtqe0fMWqk2H5iFCDjTD2G0J8EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PE+k7tCnkpUCtHrrTqxbYsSvMH/A2nVRpG7egj8u9U=;
 b=JLCyrQid4ekf9bh1sIYkMeZrzM//q20AxgF0632KWd9Gdp7MuvyzoLMknlPg8CBLesGs9kVgNq2IoyEsJgTQozC4cJsmKKnAys2qL4Axg0a0mF7wU6bFG6b2iozPXqx1LRd8Xxiea2ABReWbOharehERv5Wc5Zi73G5B04SA1ni//9O89RhxOvvtkwHim7W1LzTdjSWVCT/6dx4yGYIALEM3imqVpqxrWW0C2rEbK3WKmL/nGziOeXdDDRB3IrDXmk6AmMhACDBwz298uVyh2QVKbzE9kEBLMwdc+hObmb2t/zhOadnOHRXlpTdveQWkxtN+3DC49XC+izGe+JyWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PE+k7tCnkpUCtHrrTqxbYsSvMH/A2nVRpG7egj8u9U=;
 b=AzKprvKomF8ZN3FVET4Pdyp4OGCqoUwx8AUC5KyUGau1ZnoKQwApr+n4t+EJ44ty3PePm5zKSG9budEJFUcUWQPR7px86sovqh6Byidcl7kcKingCiriRkVUD9022qYjpHD8J3nrlyxhucP8rBr+RqrQRspH3Etu7pfjhOBrKxM=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4106.eurprd04.prod.outlook.com (2603:10a6:5:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 07:54:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 10/10] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Tue, 20 Oct 2020 23:54:02 +0800
Message-Id: <20201020155402.30318-11-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6936d72-e82a-4c80-de09-08d874cd68db
X-MS-TrafficTypeDiagnostic: DB7PR04MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB41065EB9E94B174BE07506F8E61F0@DB7PR04MB4106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weEiF8z7iuFe09dRC52FS8aHp0z65tNP9nPmP0Vpd9kOCFlnUL/FP2YLUlsmIwOcC3MocoWunaW+6B/Y80l++sWxadbsBl1/kWLFmGenmxASrKfZLVBD++j7TVW2Q22A44SFLdRoFjrwuGu/Bwe0gZM8CyGuLVL+bSwd9f5SE/Y6xuA5ew/PQ0aNAiO0wGbqsPDVTLNTc9ZlwGKEcawKFPOVTrS8v9u2Pre7+Hfgyq8/rGRxJnaIkpTnFavN5CbtlvDcVKT9nv+FuzlSNBQ3xtXLtCm2+l8B4PZvRbkqNAOw7HtKgrYJlwwjZZKrAEZrKLFSbQfeI4mm2LDhts5ZBfD3OXkOQcfxxVpAQULYAuYGBqLgkB8hxgfk0U5N66To
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(36756003)(6512007)(2906002)(69590400008)(83380400001)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(66946007)(1076003)(16526019)(26005)(186003)(316002)(478600001)(6486002)(8676002)(6506007)(86362001)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oms0WDhjmsmAZOaZdwLVgTNiUr4Bi6tnUlh/rZrsGugE1qNqT8XTljgqkX1lt+yGO+DsesXjuKaKsUlKwJSJ6oAqAzOyuX0LoEVQLG8o3ah3YRAZo8rT5TlPRmGcZkMcX0ZwBBzp5BqumrCRu81Dujo+d8HGhOPlYhLlfaurZukn8VYy3yCWhU/jjsJFZR3fjIivcUEdxejlqPuPT8ieE19Tct28YqNUt0EzCIr59xa5i4pe+9JWF7BntImAcgHqT2adgNVR7zgc+F0FD5rSpNq3mkqYElABxUQuejvCXo4ZyQALwslLobtBNmEE+FubWJmLpc2J+biQdfSlJEJjZrJdwlVWGZTQKAbnwYJmiBHbvJuk9PZQPTLd+5abQ4HzxcxAumkWAi4C2H/BmRQQUAZXgz+cEwctPm3Nu+0n6SblLEOAdmNUGLiRIHjEeWZIWAch2q+Bhvfkmplt+wIQ3IE7hvYplsD4apqUIxCitNLxCi0RCu8mODktJRyF9zaQCkD4LcCobJYItBYOrZRnN9PBw2wOtOGIZ9Rc2qf3GkDnDXf5WoM7uHlEnXpR3xtqoPZOjH3YbELf8RPmk00IDxfJeoIPEZevdtLDGBtvBVkUQrQJ+jbb78tkTsBBz1b8cIOUyieiLX2MONGqXmoZOg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6936d72-e82a-4c80-de09-08d874cd68db
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:45.1154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8FvQgYAy70iidoG4xT6oiRGK/Hk5J8+8sJaiA6mtrPa1C5Oy5mDZHLLw2P2Cyx+v3bv7qpS5fxdIjLUkTSCOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4106
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
 drivers/net/can/flexcan.c | 127 +++++++++++++++++++++++++++++++++-----
 1 file changed, 110 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 8f578c867493..97840b3e0a8a 100644
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
@@ -546,18 +554,42 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
 
+static int flexcan_stop_mode_enable_scfw(struct flexcan_priv *priv, bool enabled)
+{
+	u8 idx = priv->can_idx;
+	u32 rsrc_id, val;
+
+	rsrc_id = IMX_SC_R_CAN(idx);
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
@@ -566,10 +598,17 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
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
@@ -1838,7 +1877,7 @@ static void unregister_flexcandev(struct net_device *dev)
 	unregister_candev(dev);
 }
 
-static int flexcan_setup_stop_mode(struct platform_device *pdev)
+static int flexcan_setup_stop_mode_gpr(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
@@ -1883,11 +1922,6 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		"gpr %s req_gpr=0x02%x req_bit=%u\n",
 		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit);
 
-	device_set_wakeup_capable(&pdev->dev, true);
-
-	if (of_property_read_bool(np, "wakeup-source"))
-		device_set_wakeup_enable(&pdev->dev, true);
-
 	return 0;
 
 out_put_node:
@@ -1895,6 +1929,62 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
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
+	if (ret < 0)
+		return ret;
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
@@ -2040,17 +2130,20 @@ static int flexcan_probe(struct platform_device *pdev)
 		goto failed_register;
 	}
 
+	err = flexcan_setup_stop_mode(pdev);
+	if (err < 0) {
+		if (err != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "setup stop mode failed\n");
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
-- 
2.17.1

