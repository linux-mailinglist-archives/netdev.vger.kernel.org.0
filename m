Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7222A94E4
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgKFK4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:34 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726901AbgKFK4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4Ry44+6OBtp7GyBV7Y9wYJTgu0YV+LJcJdfgbJafZSl5+jcBuGJCFKlRC809kJIkSo08HcRLwedZeRWHskk0gsME3y6DHALkMNhWCwd6oLWTlq+UtnV4hX2euTtQ7Cb18n62vXptsf3C7qY0MVbwQjcUUjs4/oorPtHwXVj9EJ6R1nP5+Tdc2j/VT3FaI+CbkQecNCAEqI9xfmmK+aEL3xMCjVyqg9jg1OIIe4B8tdBC7R2D3+j0m0c+oGIdG6zWaXej2DJzsWmRw/ttqYECeMOD+5AqAA4klH5eVN8UbbjPzi2odjVtl9KpBGeG2axc5zc3NgysNUis1DD/pS7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPdi4TMvfuVY4MIhW30erBO+x4l5jTA885N1BnSQykM=;
 b=Ks+RYJ+UzZjn0ajfMD+ZnjgZvaOIe7lCidTrm8mHFgAhUxvV/NNwIGSkJsvtGqTxs7Cf6Khbxq9C8FLxjhkGZ3cZV3c1sb0pOtbcM/mI76ikwLv46wK+AB8J9AaDT9uJcjalxEA3SeTlrkZRLh1GpJRVpgsb57K5bkiUhZxo49e8FRmacpJ2UKjFIs5lcLUAxRubs8cO7VmT43VYVZlyg94SmkOtc/SsKBsLrggFtdZNsapn9oOOOMcYu1aEbMO8WmwAw0bN9lSzqnozKusOZHSFWN0nP82h7CvKWBCGzHxhVtjHMN+hBqVoHhfM32YG2GA1pETBPX0kJUq4/lVKCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPdi4TMvfuVY4MIhW30erBO+x4l5jTA885N1BnSQykM=;
 b=lO2KtF9WD0uGEY3n9ctWQfFeKqm4qaIEHm64XWmmBznAASjkAFJ2dhyYCMvew9riH5TJ7r9xc+xtJodDgDz0FHPyQj+C3tLh/+OBSYAZ8fq4CFuM+kVV2KEfu2cMMyzpzsUxHEVEgmerS3i97UkrgysZN1FnI5fJJmyo8S4lITc=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:20 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 5/5] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Fri,  6 Nov 2020 18:56:27 +0800
Message-Id: <20201106105627.31061-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c6003b3-458a-4c67-24b4-08d882429827
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB428289CB83EF56AD8A8263BBE6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UFN4nfRZD+LHlmSWzDMou5f1Ha3Y0okFjIi+8zLpjLuXnRu5blwFBipdkSPrgr/opNyjs9YXsvki3dnyIomxQ4XBQPSndSXQqmUyIlr1ZPWWDtnCr0TLIdC+yRhIhW5F0iUNxjnuAC1Squ9w2DHlAUSqg5vqAeHKQJhcXvYsSCKatURyoyRpgKJxPS6xRPOiNe+sp6rSXdfZHa/JZSWK231tFPq0lTtSBfvdLuTeFmHS/t68W07P1Xhlx0ao6RkK2r3NFZysBEZr2MtCz1s6gMv4XpulCg7s5Qsyr+BjRqCY8sfHu1ufqUUThbbEXbR1BwDwapI4nlqmM/lDL4a1v6eH4DOcIVUfTJmtTLvCSg04vVxXWQgb69ykVU3zFIOR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(83380400001)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: if14YsG0bP5NdcgoZYI5x4NIHeo9VGkKuLsDSp+6iDUfzLMTQz2cbc/p9Z+I2tvHsxm0BJzO6l0QOdEwVQ54JmOQOvpLkkBeDI1vBbI5zAKtxsXyrPADh/Hc+PdTXmpBY6NESynyeZQh+27ordCCHi/bOIR8vOX6catok/VDxHmRxUbq1G9TSw4BVE7L5GoaGuExW0UXjVmF1kLFXbBVMkv7tKjx1XzXQ3f1UjxANDvbwM77V0gHjNyV0B+BpYeuHmfRi8LF/loMnGOTWWBOJtWmyz+x73nzxIyoa8PUZh3rhAq19/l/LAM7IbFavQ/gNwkTV6Hk9lA5rcUMhUnHDz9xPzTYYV0s2YHiKGIwsjB1M5YjnORFTIUQxSpVvI63lBiJYnMSI8tSfeOZT1MaEIgdqSubuM7DsR2Ro+5FmfMlKUSdnQrl/iWrjsnjJIm0nxG+VIla+ulyFpVE28xHQ/oMfA0Bo0AuFcmLQEPemE4RDETXfomp0jjCAaNPA58HYWNlah5K9O1xfGSxgGJXuC+OipktqchB4C29ZSQVHUdt7EHxcTzZMi+4s4BNLJl6XILQks795q6yVyiWJktZ+ki81bhb2DTUDU0PHWcSDR5bJVb1GGtl1SXJSdoPXmHTo7x3VgNjFvP1h7hoUF3TaA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6003b3-458a-4c67-24b4-08d882429827
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:20.7459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcYSe0clq5EwId7IU5L7yMjawuvNc5I/xEzmcRrgRGCwoMfmS698Q619b2mLAJfV/d9F8VQJDk6VBYhvIY57vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
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
 drivers/net/can/flexcan.c | 123 ++++++++++++++++++++++++++++++++------
 1 file changed, 106 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 8f578c867493..1f2adbc606f5 100644
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
+	u8 scu_idx;
 
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
+	u8 idx = priv->scu_idx;
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
@@ -1895,6 +1929,58 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 	return ret;
 }
 
+static int flexcan_setup_stop_mode_scfw(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct flexcan_priv *priv;
+	u8 scu_idx;
+	int ret;
+
+	ret = of_property_read_u8(pdev->dev.of_node, "fsl,scu-index", &scu_idx);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "failed to get scu index\n");
+		return ret;
+	}
+
+	priv = netdev_priv(dev);
+	priv->scu_idx = scu_idx;
+
+	/* this function could be defered probe, return -EPROBE_DEFER */
+	return imx_scu_get_handle(&priv->sc_ipc_handle);
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
@@ -2040,17 +2126,20 @@ static int flexcan_probe(struct platform_device *pdev)
 		goto failed_register;
 	}
 
+	err = flexcan_setup_stop_mode(pdev);
+	if (err < 0) {
+		if (err != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "setup stop mode failed\n");
+		goto failed_setup_stop_mode;
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
 
+ failed_setup_stop_mode:
+	unregister_flexcandev(dev);
  failed_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.17.1

