Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A5955A9CD
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiFYMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiFYMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FE617073
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YM-0002XF-SJ
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:18 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 76A129F12B
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:03:51 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5AA619F11A;
        Sat, 25 Jun 2022 12:03:49 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 26e0e725;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/22] can: xilinx_can: add Transmitter Delay Compensation (TDC) feature support
Date:   Sat, 25 Jun 2022 14:03:14 +0200
Message-Id: <20220625120335.324697-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

This patch adds Transmitter Delay Compensation (TDC) feature support.

In the case of higher measured loop delay with higher bit rates, bit
stuff errors are observed. Enabling the TDC feature in CAN-FD
controllers will compensate for the measured loop delay in the receive
path.

Link: https://lore.kernel.org/all/20220609103157.1425730-1-srinivas.neeli@xilinx.com
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
[mkl: fix indention]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 66 +++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 8a3b7b103ca4..70dcb45078bf 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* Xilinx CAN device driver
  *
- * Copyright (C) 2012 - 2014 Xilinx, Inc.
+ * Copyright (C) 2012 - 2022 Xilinx, Inc.
  * Copyright (C) 2009 PetaLogix. All rights reserved.
  * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
  *
@@ -9,6 +9,7 @@
  * This driver is developed for Axi CAN IP and for Zynq CANPS Controller.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -86,6 +87,8 @@ enum xcan_reg {
 #define XCAN_MSR_LBACK_MASK		0x00000002 /* Loop back mode select */
 #define XCAN_MSR_SLEEP_MASK		0x00000001 /* Sleep mode select */
 #define XCAN_BRPR_BRP_MASK		0x000000FF /* Baud rate prescaler */
+#define XCAN_BRPR_TDCO_MASK		GENMASK(12, 8)  /* TDCO */
+#define XCAN_2_BRPR_TDCO_MASK		GENMASK(13, 8)  /* TDCO for CANFD 2.0 */
 #define XCAN_BTR_SJW_MASK		0x00000180 /* Synchronous jump width */
 #define XCAN_BTR_TS2_MASK		0x00000070 /* Time segment 2 */
 #define XCAN_BTR_TS1_MASK		0x0000000F /* Time segment 1 */
@@ -99,6 +102,7 @@ enum xcan_reg {
 #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
 #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
 #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
+#define XCAN_SR_TDCV_MASK		GENMASK(22, 16) /* TDCV Value */
 #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
 #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
 #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
@@ -132,6 +136,7 @@ enum xcan_reg {
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
 /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
+#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation (TDC) Enable */
 #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
 #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
 #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
@@ -276,6 +281,26 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.brp_inc = 1,
 };
 
+/* Transmission Delay Compensation constants for CANFD 1.0 */
+static const struct can_tdc_const xcan_tdc_const_canfd = {
+	.tdcv_min = 0,
+	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_min = 0,
+	.tdco_max = 32,
+	.tdcf_min = 0, /* Filter window not supported */
+	.tdcf_max = 0,
+};
+
+/* Transmission Delay Compensation constants for CANFD 2.0 */
+static const struct can_tdc_const xcan_tdc_const_canfd2 = {
+	.tdcv_min = 0,
+	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_min = 0,
+	.tdco_max = 64,
+	.tdcf_min = 0, /* Filter window not supported */
+	.tdcf_max = 0,
+};
+
 /**
  * xcan_write_reg_le - Write a value to the device register little endian
  * @priv:	Driver private data structure
@@ -424,6 +449,14 @@ static int xcan_set_bittiming(struct net_device *ndev)
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
 		/* Setting Baud Rate prescalar value in F_BRPR Register */
 		btr0 = dbt->brp - 1;
+		if (can_tdc_is_enabled(&priv->can)) {
+			if (priv->devtype.cantype == XAXI_CANFD)
+				btr0 |= FIELD_PREP(XCAN_BRPR_TDCO_MASK, priv->can.tdc.tdco) |
+					XCAN_BRPR_TDC_ENABLE;
+			else
+				btr0 |= FIELD_PREP(XCAN_2_BRPR_TDCO_MASK, priv->can.tdc.tdco) |
+					XCAN_BRPR_TDC_ENABLE;
+		}
 
 		/* Setting Time Segment 1 in BTR Register */
 		btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
@@ -1483,6 +1516,22 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
 	return 0;
 }
 
+/**
+ * xcan_get_auto_tdcv - Get Transmitter Delay Compensation Value
+ * @ndev:	Pointer to net_device structure
+ * @tdcv:	Pointer to TDCV value
+ *
+ * Return: 0 on success
+ */
+static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv)
+{
+	struct xcan_priv *priv = netdev_priv(ndev);
+
+	*tdcv = FIELD_GET(XCAN_SR_TDCV_MASK, priv->read_reg(priv, XCAN_SR_OFFSET));
+
+	return 0;
+}
+
 static const struct net_device_ops xcan_netdev_ops = {
 	.ndo_open	= xcan_open,
 	.ndo_stop	= xcan_close,
@@ -1735,17 +1784,24 @@ static int xcan_probe(struct platform_device *pdev)
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_BERR_REPORTING;
 
-	if (devtype->cantype == XAXI_CANFD)
+	if (devtype->cantype == XAXI_CANFD) {
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd;
+		priv->can.tdc_const = &xcan_tdc_const_canfd;
+	}
 
-	if (devtype->cantype == XAXI_CANFD_2_0)
+	if (devtype->cantype == XAXI_CANFD_2_0) {
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd2;
+		priv->can.tdc_const = &xcan_tdc_const_canfd2;
+	}
 
 	if (devtype->cantype == XAXI_CANFD ||
-	    devtype->cantype == XAXI_CANFD_2_0)
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+	    devtype->cantype == XAXI_CANFD_2_0) {
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
+						CAN_CTRLMODE_TDC_AUTO;
+		priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
+	}
 
 	priv->reg_base = addr;
 	priv->tx_max = tx_max;

base-commit: 27f2533bcc6e909b85d3c1b738fa1f203ed8a835
-- 
2.35.1


