Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB5323C91
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhBXMv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhBXMvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:51:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2ADE64EEA;
        Wed, 24 Feb 2021 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171033;
        bh=wWRzA55ZZ0wfuWAkDVKRy/jzGb5TYicPsND7SZ8CG04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMkL+CgAVwlbeoPk4s6gppMEzDkB6F1w2l55l50dnZ9FS8AmMZBsz0jX9vunb0zuT
         0VOlGu0/vFhfSr6UsN0h5Edxz9qNx6KfcYFi6+tFK/DvdBq6suJCKnyBqy438MHIid
         XJ3gHkWZe8Q3plPE09lbUKv0Y8ytoxOpWTBzl7CBP/r7zu20B0S4ARCG/U2Y/bQmBD
         70kCXJqV+6qHqBADU2mjchdFhCtZYzxLEshT9MpoNwZF7ba1ckd2P1mHsfQyp9SgoK
         /qXgaGV8Yh64xIriR9UpwBoMzbfF2vAXYobPE29uaT9LRtDR0xWuahFxToyAwUMCbK
         4hzq5njIFHl5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 05/67] can: flexcan: add CAN wakeup function for i.MX8QM
Date:   Wed, 24 Feb 2021 07:49:23 -0500
Message-Id: <20210224125026.481804-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 812f0116c66a3ebaf0b6062226aa85574dd79f67 ]

The System Controller Firmware (SCFW) is a low-level system function
which runs on a dedicated Cortex-M core to provide power, clock, and
resource management. It exists on some i.MX8 processors. e.g. i.MX8QM
(QM, QP), and i.MX8QX (QXP, DX). SCU driver manages the IPC interface
between host CPU and the SCU firmware running on M4.

For i.MX8QM, stop mode request is controlled by System Controller Unit(SCU)
firmware, this patch introduces FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW quirk
for this function.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201106105627.31061-6-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 123 ++++++++++++++++++++++++++++++++------
 1 file changed, 106 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 038fe1036df23..7ab20a6b0d1db 100644
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
@@ -1867,7 +1906,7 @@ static void unregister_flexcandev(struct net_device *dev)
 	unregister_candev(dev);
 }
 
-static int flexcan_setup_stop_mode(struct platform_device *pdev)
+static int flexcan_setup_stop_mode_gpr(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
@@ -1912,11 +1951,6 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		"gpr %s req_gpr=0x02%x req_bit=%u\n",
 		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit);
 
-	device_set_wakeup_capable(&pdev->dev, true);
-
-	if (of_property_read_bool(np, "wakeup-source"))
-		device_set_wakeup_enable(&pdev->dev, true);
-
 	return 0;
 
 out_put_node:
@@ -1924,6 +1958,58 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
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
@@ -2054,17 +2140,20 @@ static int flexcan_probe(struct platform_device *pdev)
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
2.27.0

