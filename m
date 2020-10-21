Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A125B2947CF
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407554AbgJUFYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:24 -0400
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:19620
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440525AbgJUFYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQTlceujRrf/DzWN9EQ+b0lk7Vx3uwtJDNxHz6jLYMdjJ+Nyco6q4bq64k0E3oAPUF2gw04wDNk4jHIg1yLN9e3gSNJ4voRe9HNLIXPyY8SAlXVrNnvbdnCML8vNaIyXygD6oa7P+QzUMI/SdWxJ7yn8TK2TrQOVpZi39svsldiYkytyC6xTuf2dc+pJHoembwSF3N8hZspnByv9rff8y9ANYlhp3ecSFXrMx2KsJTkITaX2solveRt668KAcyfuhje3moPCiIq4kvt+Di7xvSclI6Es8eNjNtw1vEad7/MKjLofmUS1mtELg/Owxzy5WHknQ1DZq2+w01jnlEWEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPdi4TMvfuVY4MIhW30erBO+x4l5jTA885N1BnSQykM=;
 b=HCc3uSZqjaaYirlWPf6cowkPnBsOGfKFWfXPDnjdXaoLsCEFrjOihySB5QIAGkVvUJLRVafZGR3ITyKE1joq4PrC5eZ0JrRkoNDFrmO5cb2cjZhwApfslEAp3SU68KhQRr9t17PQoas1rEGJfPKEWccg0RpTs5ztD1hcCWl/VgAlAJFfsUv0wn+04oka01LK5bRY0cgUZlTpp/DOwWw84WMLOvhcjQLZw1gWNSfSgSnan0YxKgjOEzQrWV4CUiHSpbnucv8UdNWINLY3atFRst85GnbP3qMn1Nr7mBAHXrHcLSEnUnEln6VdiJXrazJG0g8sqgigP4lArPcxs4LbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPdi4TMvfuVY4MIhW30erBO+x4l5jTA885N1BnSQykM=;
 b=lFe/Lfm5wCrKnsuCxHGTjU7w4MW/P9Vo4pKSVhIhcpci9KBf80nFZHbWiJpIJH+gllAy/vM4oa+mT3Vm1/fjFimZykPQLaFOQTaX3IOl9qsfTUbA0zvPhCA8QM+EXvYEvsp4nnHkx3c8K3Wa9RV0foZ+FcFGGQUFfmMmlydaILA=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:24:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:24:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 6/6] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Wed, 21 Oct 2020 13:24:37 +0800
Message-Id: <20201021052437.3763-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2b8671f-e87b-4fb7-3641-08d875818ddc
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB272641C54F847F0C24F03D12E61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 37Pk2wktnxkRKPAIkZWzmxIjBOEclE0lHyez6FXGwv8DL8Y8GDGNr/mPPcmF9RJ4n3gibxUgeS8mf4cy5qZP0eLp2VmI4nDLElbG1jk3Xd8VMY/1Lkojm/1Uzw6zOZRe3M/EErn1laDTXfLSiVlurc3tbfXgdywF10Kj6R0viXcs60gCV5Wq1jDaY9xlOmnpgbD6/xiqaXP/o99yRvLzlChxqOjT9bixBc8T/ydRNc7kPMhP8t1ipLv+IyGOkiFVMxqZk5plDfGnUgWYw7wcv5mK0IzOEL5Ne/zwNIwrpkQxjr0PaV8N0/wh/5XsCSoNDCLL0PbuewW+twgKWJR+xRHEAwsmpJ1fBGZ7aATgM1KEhUm7y5xp+zVnBxwIBQtU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J3gEfsx24AluGaPyUa1noqGhM6PBNuS0ElM0ZHrk14P9tLF/QqmzL+n3M/t7v+EtTXrZev94dW+tEX6IPXAV2oxd21ciApbCdZ4eNYyHubHcKzDfZOfBGuQrjSkiefIb2ao9vYc6FBZNgKpf6tlNgCI5ncNGGrQiT/unLJTUAaewKz0r0kVnQlPnA3UIiE8GpjxlcjAsXq/WV19MzPilQGf//8K6HCbg+rEezRnBAbf/BsIOUGQTjuVk1XUo/OzgyWENCNGm3y9jw9cIqJiSxBbNFUUbwHJu/P0zH1W/YZyXeWNcWpaSYD4m50LSkh7NRzp4/CmIJ+F5Y1f3I0z0AzZPPhVIL1iktu4JYW6TAIKDJ5ym1vwLLVlxkxXc0r781fts02vNTtTNkka4QfZikl1uzhA+De/1BGrrkdNZPZeVKGBiPMY/JhBVMV09NkJFpxZcJUoWxHounW0htMrjtXhNPslOG8Ruy/Eh75CN+i9vxt8zMxtPlpbFIboWejy3BPPmHiOYcNM1WaFZ5KO9JaVCmwkttqJu/oo/a+kX4gsVIV5d00Wgctn0rxLG7ePZgeAfRjUQzLR0nYQ3mxW+cN9KWllVlb5LA8htPhCPZoqqK4K8P6zYU3y80VAAgsaCMiZN/4tqeYPTtmh9G5o2bg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b8671f-e87b-4fb7-3641-08d875818ddc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:24:16.6385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9fMP8ZI1iU5LQKFuyqczWXCU5iofoLHe+5WW2BxHRHlWjL4msopnP9ruklB4/SI7mIg8Xl98H9XEQ7AWSEeRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
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

