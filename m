Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3F56561F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiGDMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiGDMwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D311C35
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LZ4-0001IB-7x
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D1CA2A7A0B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 27D7DA7954;
        Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4db23f35;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 09/15] can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
Date:   Mon,  4 Jul 2022 14:26:07 +0200
Message-Id: <20220704122613.1551119-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
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

From: Jimmy Assarsson <extja@kvaser.com>

The firmware of M32C based Leaf devices expects bittiming parameters
calculated for 16MHz clock. Since we use the actual clock frequency of
the device, the device may end up with wrong bittiming parameters,
depending on user requested parameters.

This regression affects M32C based Leaf devices with non-16MHz clock.

Fixes: fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device")
Link: https://lore.kernel.org/all/20220603083820.800246-3-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  1 +
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 33 ++++++++++++-------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 25 +++++++++-----
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 39d5bfd70ff4..c1f66cef2c3f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -38,6 +38,7 @@
 /* Kvaser USB device quirks */
 #define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
 #define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ	BIT(2)
 
 /* Device capabilities */
 #define KVASER_USB_CAP_BERR_CAP			0x01
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index d5b293e673d8..f211bfcb1d97 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -101,26 +101,33 @@ static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf = {
-	.quirks = 0,
+	.quirks = KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err = {
-	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS,
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err_listen = {
 	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
-		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
+	.quirks = 0,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
+
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf USB product IDs */
+	/* Leaf M32C USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
@@ -161,22 +168,24 @@ static const struct usb_device_id kvaser_usb_table[] = {
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_CAN_R_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+
+	/* Leaf i.MX28 USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_R_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_R_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 
 	/* USBCANII USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 5cf940ba3f7f..957144cee414 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -524,16 +524,23 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
 	dev->fw_version = le32_to_cpu(softinfo->fw_version);
 	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
 
-	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
-	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+	if (dev->driver_info->quirks & KVASER_USB_QUIRK_IGNORE_CLK_FREQ) {
+		/* Firmware expects bittiming parameters calculated for 16MHz
+		 * clock, regardless of the actual clock
+		 */
 		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
-		break;
+	} else {
+		switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+		case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
+			break;
+		}
 	}
 }
 
-- 
2.35.1


