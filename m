Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA683D5B70
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhGZNee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbhGZNdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C64EC061381
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Ld-0002Vu-QB
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:49 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BA07F658301
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 47F9A658235;
        Mon, 26 Jul 2021 14:12:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d0bd7f4d;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Angelo Dureghello <angelo@kernel-space.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 45/46] can: flexcan: add mcf5441x support
Date:   Mon, 26 Jul 2021 16:11:43 +0200
Message-Id: <20210726141144.862529-46-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Angelo Dureghello <angelo@kernel-space.org>

Add flexcan support for NXP ColdFire mcf5441x family.

This flexcan module is quite similar to imx6 flexcan module, but
with some exceptions:

- 3 separate interrupt sources, MB, BOFF and ERR,
- implements 16 mb only,
- m68k architecture is not supporting devicetrees, so a
  platform data check/case has been added,
- ColdFire is m68k, so big-endian cpu, with a little-endian flexcan
  module.

Link: https://lore.kernel.org/r/20210702094841.327679-5-angelo@kernel-space.org
Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 124 ++++++++++++++++++++++++++++++++------
 1 file changed, 104 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index d9dcf6a8412b..54ffb796a320 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -28,6 +28,7 @@
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/can/platform/flexcan.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -208,18 +209,19 @@
 /* FLEXCAN hardware feature flags
  *
  * Below is some version info we got:
- *    SOC   Version   IP-Version  Glitch- [TR]WRN_INT IRQ Err Memory err RTR rece-   FD Mode
+ *    SOC   Version   IP-Version  Glitch- [TR]WRN_INT IRQ Err Memory err RTR rece-   FD Mode     MB
  *                                Filter? connected?  Passive detection  ption in MB Supported?
- *   MX25  FlexCAN2  03.00.00.00     no        no        no       no        no           no
- *   MX28  FlexCAN2  03.00.04.00    yes       yes        no       no        no           no
- *   MX35  FlexCAN2  03.00.00.00     no        no        no       no        no           no
- *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no
- *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no
- *   MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes
- *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
- *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
- * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
- * LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes
+ * MCF5441X FlexCAN2  ?               no       yes        no       no       yes           no     16
+ *    MX25  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
+ *    MX28  FlexCAN2  03.00.04.00    yes       yes        no       no        no           no     64
+ *    MX35  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
+ *    MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no     64
+ *    MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no     64
+ *    MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes     64
+ *    MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes     64
+ *    VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no     64
+ *  LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no     64
+ *  LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes     64
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
@@ -246,6 +248,10 @@
 #define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
 /* Setup stop mode with SCU firmware to support wakeup */
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
+/* Setup 3 separate interrupts, main, boff and err */
+#define FLEXCAN_QUIRK_NR_IRQ_3 BIT(12)
+/* Setup 16 mailboxes */
+#define FLEXCAN_QUIRK_NR_MB_16 BIT(13)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -363,6 +369,9 @@ struct flexcan_priv {
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
+	int irq_boff;
+	int irq_err;
+
 	/* IPC handle when setup stop mode by System Controller firmware(scfw) */
 	struct imx_sc_ipc *sc_ipc_handle;
 
@@ -371,6 +380,11 @@ struct flexcan_priv {
 	void (*write)(u32 val, void __iomem *addr);
 };
 
+static const struct flexcan_devtype_data fsl_mcf5441x_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16,
+};
+
 static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
@@ -637,13 +651,17 @@ static int flexcan_clks_enable(const struct flexcan_priv *priv)
 {
 	int err;
 
-	err = clk_prepare_enable(priv->clk_ipg);
-	if (err)
-		return err;
+	if (priv->clk_ipg) {
+		err = clk_prepare_enable(priv->clk_ipg);
+		if (err)
+			return err;
+	}
 
-	err = clk_prepare_enable(priv->clk_per);
-	if (err)
-		clk_disable_unprepare(priv->clk_ipg);
+	if (priv->clk_per) {
+		err = clk_prepare_enable(priv->clk_per);
+		if (err)
+			clk_disable_unprepare(priv->clk_ipg);
+	}
 
 	return err;
 }
@@ -1404,8 +1422,12 @@ static int flexcan_rx_offload_setup(struct net_device *dev)
 		priv->mb_size = sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
 	else
 		priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
-	priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
-			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
+
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_MB_16)
+		priv->mb_count = 16;
+	else
+		priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
+				 (sizeof(priv->regs->mb[1]) / priv->mb_size);
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
 		priv->tx_mb_reserved =
@@ -1777,6 +1799,18 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_can_rx_offload_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+		err = request_irq(priv->irq_boff,
+				  flexcan_irq, IRQF_SHARED, dev->name, dev);
+		if (err)
+			goto out_free_irq;
+
+		err = request_irq(priv->irq_err,
+				  flexcan_irq, IRQF_SHARED, dev->name, dev);
+		if (err)
+			goto out_free_irq_boff;
+	}
+
 	flexcan_chip_interrupts_enable(dev);
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
@@ -1785,6 +1819,10 @@ static int flexcan_open(struct net_device *dev)
 
 	return 0;
 
+ out_free_irq_boff:
+	free_irq(priv->irq_boff, dev);
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
 	flexcan_chip_stop(dev);
@@ -1806,6 +1844,12 @@ static int flexcan_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	flexcan_chip_interrupts_disable(dev);
+
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+		free_irq(priv->irq_err, dev);
+		free_irq(priv->irq_boff, dev);
+	}
+
 	free_irq(dev->irq, dev);
 	can_rx_offload_disable(&priv->offload);
 	flexcan_chip_stop_disable_on_error(dev);
@@ -2042,14 +2086,26 @@ static const struct of_device_id flexcan_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, flexcan_of_match);
 
+static const struct platform_device_id flexcan_id_table[] = {
+	{
+		.name = "flexcan-mcf5441x",
+		.driver_data = (kernel_ulong_t)&fsl_mcf5441x_devtype_data,
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(platform, flexcan_id_table);
+
 static int flexcan_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id;
 	const struct flexcan_devtype_data *devtype_data;
 	struct net_device *dev;
 	struct flexcan_priv *priv;
 	struct regulator *reg_xceiver;
 	struct clk *clk_ipg = NULL, *clk_per = NULL;
 	struct flexcan_regs __iomem *regs;
+	struct flexcan_platform_data *pdata;
 	int err, irq;
 	u8 clk_src = 1;
 	u32 clock_freq = 0;
@@ -2067,6 +2123,12 @@ static int flexcan_probe(struct platform_device *pdev)
 				     "clock-frequency", &clock_freq);
 		of_property_read_u8(pdev->dev.of_node,
 				    "fsl,clk-source", &clk_src);
+	} else {
+		pdata = dev_get_platdata(&pdev->dev);
+		if (pdata) {
+			clock_freq = pdata->clock_frequency;
+			clk_src = pdata->clk_src;
+		}
 	}
 
 	if (!clock_freq) {
@@ -2092,7 +2154,14 @@ static int flexcan_probe(struct platform_device *pdev)
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
-	devtype_data = of_device_get_match_data(&pdev->dev);
+	of_id = of_match_device(flexcan_of_match, &pdev->dev);
+	if (of_id)
+		devtype_data = of_id->data;
+	else if (platform_get_device_id(pdev)->driver_data)
+		devtype_data = (struct flexcan_devtype_data *)
+			platform_get_device_id(pdev)->driver_data;
+	else
+		return -ENODEV;
 
 	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
 	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)) {
@@ -2136,6 +2205,19 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
 
+	if (devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+		priv->irq_boff = platform_get_irq(pdev, 1);
+		if (priv->irq_boff <= 0) {
+			err = -ENODEV;
+			goto failed_platform_get_irq;
+		}
+		priv->irq_err = platform_get_irq(pdev, 2);
+		if (priv->irq_err <= 0) {
+			err = -ENODEV;
+			goto failed_platform_get_irq;
+		}
+	}
+
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_FD_NON_ISO;
@@ -2173,6 +2255,7 @@ static int flexcan_probe(struct platform_device *pdev)
  failed_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+ failed_platform_get_irq:
 	free_candev(dev);
 	return err;
 }
@@ -2325,6 +2408,7 @@ static struct platform_driver flexcan_driver = {
 	},
 	.probe = flexcan_probe,
 	.remove = flexcan_remove,
+	.id_table = flexcan_id_table,
 };
 
 module_platform_driver(flexcan_driver);
-- 
2.30.2


