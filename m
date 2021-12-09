Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B6846E3E5
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhLIIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbhLIIQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:16:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AC0C061A32
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:13:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mvEYN-0001i8-08
        for netdev@vger.kernel.org; Thu, 09 Dec 2021 09:13:23 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 282476C065B
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:13:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D934C6C0648;
        Thu,  9 Dec 2021 08:13:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f26335c9;
        Thu, 9 Dec 2021 08:13:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] can: kvaser_usb: get CAN clock frequency from device
Date:   Thu,  9 Dec 2021 09:13:12 +0100
Message-Id: <20211209081312.301036-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211209081312.301036-1-mkl@pengutronix.de>
References: <20211209081312.301036-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

The CAN clock frequency is used when calculating the CAN bittiming
parameters. When wrong clock frequency is used, the device may end up
with wrong bittiming parameters, depending on user requested bittiming
parameters.

To avoid this, get the CAN clock frequency from the device. Various
existing Kvaser Leaf products use different CAN clocks.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Link: https://lore.kernel.org/all/20211208152122.250852-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 101 +++++++++++++-----
 1 file changed, 73 insertions(+), 28 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 59ba7c7beec0..f7af1bf5ab46 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -28,10 +28,6 @@
 
 #include "kvaser_usb.h"
 
-/* Forward declaration */
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg;
-
-#define CAN_USB_CLOCK			8000000
 #define MAX_USBCAN_NET_DEVICES		2
 
 /* Command header size */
@@ -80,6 +76,12 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg;
 
 #define CMD_LEAF_LOG_MESSAGE		106
 
+/* Leaf frequency options */
+#define KVASER_USB_LEAF_SWOPTION_FREQ_MASK 0x60
+#define KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK 0
+#define KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK BIT(5)
+#define KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK BIT(6)
+
 /* error factors */
 #define M16C_EF_ACKE			BIT(0)
 #define M16C_EF_CRCE			BIT(1)
@@ -340,6 +342,50 @@ struct kvaser_usb_err_summary {
 	};
 };
 
+static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
+	.name = "kvaser_usb",
+	.tseg1_min = KVASER_USB_TSEG1_MIN,
+	.tseg1_max = KVASER_USB_TSEG1_MAX,
+	.tseg2_min = KVASER_USB_TSEG2_MIN,
+	.tseg2_max = KVASER_USB_TSEG2_MAX,
+	.sjw_max = KVASER_USB_SJW_MAX,
+	.brp_min = KVASER_USB_BRP_MIN,
+	.brp_max = KVASER_USB_BRP_MAX,
+	.brp_inc = KVASER_USB_BRP_INC,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+	.clock = {
+		.freq = 8000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+	.clock = {
+		.freq = 24000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+	.clock = {
+		.freq = 32000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			     const struct sk_buff *skb, int *frame_len,
@@ -471,6 +517,27 @@ static int kvaser_usb_leaf_send_simple_cmd(const struct kvaser_usb *dev,
 	return rc;
 }
 
+static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
+						   const struct leaf_cmd_softinfo *softinfo)
+{
+	u32 sw_options = le32_to_cpu(softinfo->sw_options);
+
+	dev->fw_version = le32_to_cpu(softinfo->fw_version);
+	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
+
+	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
+		break;
+	}
+}
+
 static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd cmd;
@@ -486,14 +553,13 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 
 	switch (dev->card_data.leaf.family) {
 	case KVASER_LEAF:
-		dev->fw_version = le32_to_cpu(cmd.u.leaf.softinfo.fw_version);
-		dev->max_tx_urbs =
-			le16_to_cpu(cmd.u.leaf.softinfo.max_outstanding_tx);
+		kvaser_usb_leaf_get_software_info_leaf(dev, &cmd.u.leaf.softinfo);
 		break;
 	case KVASER_USBCAN:
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
 		break;
 	}
 
@@ -1225,24 +1291,11 @@ static int kvaser_usb_leaf_init_card(struct kvaser_usb *dev)
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 
-	dev->cfg = &kvaser_usb_leaf_dev_cfg;
 	card_data->ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 
 	return 0;
 }
 
-static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
-};
-
 static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1348,11 +1401,3 @@ const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops = {
 	.dev_read_bulk_callback = kvaser_usb_leaf_read_bulk_callback,
 	.dev_frame_to_cmd = kvaser_usb_leaf_frame_to_cmd,
 };
-
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg = {
-	.clock = {
-		.freq = CAN_USB_CLOCK,
-	},
-	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
-};
-- 
2.33.0


