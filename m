Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19098278143
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgIYHKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:10:40 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:22663
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbgIYHKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:10:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMIAupd+LhkgovnZWw7gAoyskdZBboqn8zJqwD3V2BS29klotzeqh2KoFYMuczB3nSiRkXHfTY2gfU9E8RC9vsBxODR+Tj+X1qV1TX9ENTRK9GxWpMRAbQNfIkPVgYjXZrjloURJSxK8wt8g7t2IJ4MCfpfrHYP9PT6+aAEGYIP3yCWBBcMAyddmnv/96COhtLFw602rWuWbcD9tX4GDqzo4f5VZnM3iaRX+EIzWMua7Capmz9aeK8Mzfh6z+ht6VP0RtOM1/+RFtXUbAgnOjdIBygkGpUT468R6WcTGacpfW3IgwLuZdurOcV7DlXHcTkrXR1XEj0YM11MjFeA98w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk/9fuodC0TNlGXNO64RBvoiJuUYtthOxNRKi/GFxGM=;
 b=ZwSBF+Ovoj1tILA+LxSRYQdG6K/PsLTIVd2kVmDOj+MNhXfVFzI6/shOH6yq3KoN56FVFKkISONMkmwSjP+q7QbNFuL1BYbOFeNO6Asa65kG4IuWxQ0oaay5z53fL/mi9FqgT5X/uEexMIEEIgoVDswHtRypTpizSY5C6AGsjRN4snTN5yLB8HvDrT/RjJz2FdfQrckLDtg8ImhWBNfAhRlm/bpPQ82hXYI/fs2uOXFR/sADZqLUxzIjc9EXUWUJDjqNELHbzKnD69dAGaYwz7prLn1UWXNSJnDwagcZYcgOMyAvDFGWsrfXiFKwcaGjBskBnITaAOvj3ivnv8MrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk/9fuodC0TNlGXNO64RBvoiJuUYtthOxNRKi/GFxGM=;
 b=VE/UACMdYRwD2LirBuSBE8i1LbHDgl+iA+xzI2/vEo+DJ/pk+UDx69LLl8dvFJ2f/6geAx33E6GCk/yYKsCJAtoR1pisLCQUfjgqVGDnjFOSHaID6NiD4ecbh2MG2an6sc3jsXTIVbrIkEpORG4Su0NzM2mK5VxGK9Ouw7Y5ku0=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 07:10:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:10:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan 3/4] can: flexcan: add CAN wakeup function for i.MX8
Date:   Fri, 25 Sep 2020 23:10:27 +0800
Message-Id: <20200925151028.11004-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0240.apcprd06.prod.outlook.com (2603:1096:4:ac::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 07:10:28 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c6c4747-9eec-42a7-91f2-08d86122160a
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69717CEE29CC134F0D38B9C9E6360@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDKKxcqueaR0Tzt43/C0jRkxaB7jefzIHZSRjSgniVwoUSvYBmGCrDcUoyYJAlvIUecVuaKY8BT1emDSblDrAzS9XCEZNaoPJ9jhEj2rCyI8MnO9Kp8LaWzIhh87w6ky2ZOTFt22oIBmXJnipsM9vSFcILpuVJVkjZWCcDocMOYXml+VDCtHptO1mDsJAEtK7HVOtwy5Yx22lsQJxryC8n6T3WiHLN9k2P+TN8JYsBuymRP4Nl4od+vN4Mu2++BVV//qjnPZVxAbr307HfZFGFm5HPM5iir3CeVvD1tsXqHUK8MvrAxfXrH78mthduMlwt2p2LLzAkcQqG+xwEilwUKrlfRItFhlJx8oRfCNcaoL7mkdf4eXJ0M/4hIVzimVBrWA/el5zpcFjUt2k42hZHXXWsSyI7z6/htz9TswuTJDAsTiDKHzaQ6OaxZHtTI4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(478600001)(6486002)(66556008)(956004)(2616005)(1076003)(66476007)(36756003)(16526019)(186003)(5660300002)(26005)(66946007)(69590400008)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(6512007)(83380400001)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /5azU6L21FYrTDiiqx3rxV8vjD6LSajDDj2aqy39L7jiqGdWgB6p0xSIANneZIgFnXZY5w1vrKzxwyFIW4d877nceJ+JwASscNe93ClVEjH03tjhK9t/m3JYOm1TT6/PNCWm6rkLJS4u9gbbGNhepFK4RKQ/9e+AYzz0wHUdAAS+vMLbP60q8MO26GRXGC6bdnmJY8/tkvT04KbF+4fgeGOIfiN9RfhAYcvJfmbjcG/R8TauEo5GHsNZzXAZrL8ZL1BAtXWNznveJjus4SvXNr3yFnQeU9cal6J8pPq50qJ/Cf3K6NWoaUi6wPkCyCPvhz4Ey58EYjqqISthY5kZJ6ICeN6i5BbOsFvMCcN6Gs++VDLHmByAqTooqv25Xvs7+rJ+3rMjJaLk+ORXsM8pdTDLPEHIRaCRvO9/BunBABht1NG4QSGSxIVjn8Mj0Ubl3uWq/ihGZ+Tf20/MusdAYl9+BmbBScuq3pSYm9hYJJxOT1nZMKAcd0zJHQMaHdCjCdU7oZSCIPreLhrpvYf4UCBQYgDzQzLxTXDljPy/QfHvSdhUjDjswAKZpqYNZY9GuzjCn5ZciHqgLRrw3YWSL6sWtrSCC8ttgnMHhqQsxB1yfyGHr99cSwTW+jeIijMfybtBTI5yiNj/Vm+Xt+M2XQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6c4747-9eec-42a7-91f2-08d86122160a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 07:10:30.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVYEMczvFVLJUZq7BVTZKa0AzizVm7bZKpxXT5NQwjnL6Lzyj5Xps0gE3xSE/AG1eMlfuA1sJbGo+U0D7Yxj9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The System Controller Firmware (SCFW) is a low-level system function
which runs on a dedicated Cortex-M core to provide power, clock, and
resource management. It exists on some i.MX8 processors. e.g. i.MX8QM
(QM, QP), and i.MX8QX (QXP, DX).

SCU driver manages the IPC interface between host CPU and the
SCU firmware running on M4.

For i.MX8, stop mode request is controlled by System Controller Unit(SCU)
firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 81 ++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 8c8753f77764..41b52cb56f93 100644
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
@@ -240,6 +242,8 @@
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
 /* Support CAN-FD mode */
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
+/* Use System Controller Firmware */
+#define FLEXCAN_QUIRK_USE_SCFW BIT(10)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -358,6 +362,9 @@ struct flexcan_priv {
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
+	/* IPC handle when enable stop mode by System Controller firmware(scfw) */
+	struct imx_sc_ipc *sc_ipc_handle;
+
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
 	void (*write)(u32 val, void __iomem *addr);
@@ -387,7 +394,8 @@ static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_USE_SCFW,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
@@ -546,6 +554,25 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
 
+static void flexcan_stop_mode_enable_scfw(struct flexcan_priv *priv, bool enabled)
+{
+	struct device_node *np = priv->dev->of_node;
+	u32 rsrc_id, val;
+	int idx;
+
+	idx = of_alias_get_id(np, "can");
+	if (idx == 0)
+		rsrc_id = IMX_SC_R_CAN_0;
+	else if (idx == 1)
+		rsrc_id = IMX_SC_R_CAN_1;
+	else
+		rsrc_id = IMX_SC_R_CAN_2;
+
+	val = enabled ? 1 : 0;
+	/* stop mode request */
+	imx_sc_misc_set_control(priv->sc_ipc_handle, rsrc_id, IMX_SC_C_IPG_STOP, val);
+}
+
 static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
@@ -555,9 +582,12 @@ static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 	reg_mcr |= FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
 
-	/* enable stop request */
-	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
-			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+	 /* enable stop request */
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_SCFW)
+		flexcan_stop_mode_enable_scfw(priv, true);
+	else
+		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
+				   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
 
 	return flexcan_low_power_enter_ack(priv);
 }
@@ -568,8 +598,11 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 	u32 reg_mcr;
 
 	/* remove stop request */
-	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
-			   1 << priv->stm.req_bit, 0);
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_SCFW)
+		flexcan_stop_mode_enable_scfw(priv, false);
+	else
+		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
+				   1 << priv->stm.req_bit, 0);
 
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
@@ -1927,11 +1960,6 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit,
 		priv->stm.ack_gpr, priv->stm.ack_bit);
 
-	device_set_wakeup_capable(&pdev->dev, true);
-
-	if (of_property_read_bool(np, "wakeup-source"))
-		device_set_wakeup_enable(&pdev->dev, true);
-
 	return 0;
 
 out_put_node:
@@ -1939,6 +1967,23 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
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
+	ret = imx_scu_get_handle(&priv->sc_ipc_handle);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "get ipc handle used by SCU failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
@@ -2088,9 +2133,19 @@ static int flexcan_probe(struct platform_device *pdev)
 	devm_can_led_init(dev);
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
-		err = flexcan_setup_stop_mode(pdev);
-		if (err)
+		if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_SCFW)
+			err = flexcan_setup_stop_mode_scfw(pdev);
+		else
+			err = flexcan_setup_stop_mode(pdev);
+
+		if (err) {
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
+		} else {
+			device_set_wakeup_capable(&pdev->dev, true);
+
+			if (of_property_read_bool(pdev->dev.of_node, "wakeup-source"))
+				device_set_wakeup_enable(&pdev->dev, true);
+		}
 	}
 
 	return 0;
-- 
2.17.1

