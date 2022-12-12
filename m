Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E34649DBE
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiLLLbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiLLLbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B43656A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1N-00009g-FQ
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AECE413CBAF
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D1AE613CB77;
        Mon, 12 Dec 2022 11:30:51 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1d0d6f07;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Haibo Chen <haibo.chen@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/39] can: flexcan: add auto stop mode for IMX93 to support wakeup
Date:   Mon, 12 Dec 2022 12:30:17 +0100
Message-Id: <20221212113045.222493-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Link: https://lore.kernel.org/all/1669116752-4260-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
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
2.35.1


