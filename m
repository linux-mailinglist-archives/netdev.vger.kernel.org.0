Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379AF633BDB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiKVLyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiKVLys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:54:48 -0500
Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3012D252BF;
        Tue, 22 Nov 2022 03:54:47 -0800 (PST)
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BBAF2200D39;
        Tue, 22 Nov 2022 12:54:45 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 572A6200D34;
        Tue, 22 Nov 2022 12:54:45 +0100 (CET)
Received: from local (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 767CA181D0C4;
        Tue, 22 Nov 2022 19:54:43 +0800 (+08)
From:   haibo.chen@nxp.com
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        haibo.chen@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/3] can: flexcan: add auto stop mode for IMX93 to support wakeup
Date:   Tue, 22 Nov 2022 19:32:30 +0800
Message-Id: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

IMX93 do not contain a GPR to config the stop mode, it will set
the flexcan into stop mode automatically once the ARM core go
into low power mode (WFI instruct) and gate off the flexcan
related clock automatically. But to let these logic work as
expect, before ARM core go into low power mode, need to make
sure the flexcan related clock keep on.

To support stop mode and wakeup feature on imx93, this patch
add a new fsl_imx93_devtype_data to separate from imx8mp.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
---
 drivers/net/can/flexcan/flexcan-core.c | 37 +++++++++++++++++++++++---
 drivers/net/can/flexcan/flexcan.h      |  2 ++
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 9bdadd716f4e..0aeff34e5ae1 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -345,6 +345,15 @@ static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR,
 };
 
+static struct flexcan_devtype_data fsl_imx93_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_AUTO_STOP_MODE |
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
@@ -532,9 +541,14 @@ static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 		ret = flexcan_stop_mode_enable_scfw(priv, true);
 		if (ret < 0)
 			return ret;
-	} else {
+	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
 		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 				   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE) {
+		/* For the auto stop mode, software do nothing, hardware will cover
+		 * all the operation automatically after system go into low power mode.
+		 */
+		return 0;
 	}
 
 	return flexcan_low_power_enter_ack(priv);
@@ -551,7 +565,7 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 		ret = flexcan_stop_mode_enable_scfw(priv, false);
 		if (ret < 0)
 			return ret;
-	} else {
+	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
 		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 				   1 << priv->stm.req_bit, 0);
 	}
@@ -560,6 +574,12 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
 
+	/* For the auto stop mode, hardware will exist stop mode
+	 * automatically after system go out of low power mode.
+	 */
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)
+		return 0;
+
 	return flexcan_low_power_exit_ack(priv);
 }
 
@@ -1974,6 +1994,8 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		ret = flexcan_setup_stop_mode_scfw(pdev);
 	else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR)
 		ret = flexcan_setup_stop_mode_gpr(pdev);
+	else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)
+		ret = 0;
 	else
 		/* return 0 directly if doesn't support stop mode feature */
 		return 0;
@@ -1992,6 +2014,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
 	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
+	{ .compatible = "fsl,imx93-flexcan", .data = &fsl_imx93_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx53-flexcan", .data = &fsl_imx25_devtype_data, },
@@ -2299,8 +2322,16 @@ static int __maybe_unused flexcan_noirq_suspend(struct device *device)
 	if (netif_running(dev)) {
 		int err;
 
-		if (device_may_wakeup(device))
+		if (device_may_wakeup(device)) {
 			flexcan_enable_wakeup_irq(priv, true);
+			/* For auto stop mode, need to keep the clock on before
+			 * system go into low power mode. After system go into
+			 * low power mode, hardware will config the flexcan into
+			 * stop mode, and gate off the clock automatically.
+			 */
+			if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)
+				return 0;
+		}
 
 		err = pm_runtime_force_suspend(device);
 		if (err)
diff --git a/drivers/net/can/flexcan/flexcan.h b/drivers/net/can/flexcan/flexcan.h
index 025c3417031f..91402977780b 100644
--- a/drivers/net/can/flexcan/flexcan.h
+++ b/drivers/net/can/flexcan/flexcan.h
@@ -68,6 +68,8 @@
 #define FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR BIT(15)
 /* Device supports RX via FIFO */
 #define FLEXCAN_QUIRK_SUPPORT_RX_FIFO BIT(16)
+/* auto enter stop mode to support wakeup */
+#define FLEXCAN_QUIRK_AUTO_STOP_MODE BIT(17)
 
 struct flexcan_devtype_data {
 	u32 quirks;		/* quirks needed for different IP cores */
-- 
2.34.1

