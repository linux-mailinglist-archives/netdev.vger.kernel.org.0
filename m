Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87AA34E6B4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhC3LrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhC3Lqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA55C0613D8
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpN-0006Dk-0s
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:33 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DD318603E6F
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 95872603E05;
        Tue, 30 Mar 2021 11:46:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8803bc0b;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 16/39] can: peak_usb: add support of ONE_SHOT mode
Date:   Tue, 30 Mar 2021 13:45:36 +0200
Message-Id: <20210330114559.1114855-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch adds "ONE-SHOT" mode support to the following CAN-USB
PEAK-System GmbH interfaces:
- PCAN-USB X6
- PCAN-USB FD
- PCAN-USB Pro FD
- PCAN-Chip USB
- PCAN-USB Pro

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
[mkl: split into two patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c  | 12 ++++++++----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c |  8 +++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index b3e56ee03cd5..6f62b6f51051 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -774,6 +774,10 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 			tx_msg_flags |= PUCAN_MSG_RTR;
 	}
 
+	/* Single-Shot frame */
+	if (dev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		tx_msg_flags |= PUCAN_MSG_SINGLE_SHOT;
+
 	tx_msg->flags = cpu_to_le16(tx_msg_flags);
 	tx_msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(dev->ctrl_idx, dlc);
 	memcpy(tx_msg->d, cfd->data, cfd->len);
@@ -1063,7 +1067,7 @@ const struct peak_usb_adapter pcan_usb_fd = {
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			CAN_CTRLMODE_CC_LEN8_DLC,
+			CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
@@ -1138,7 +1142,7 @@ const struct peak_usb_adapter pcan_usb_chip = {
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
 		CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_CC_LEN8_DLC,
+		CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
@@ -1213,7 +1217,7 @@ const struct peak_usb_adapter pcan_usb_pro_fd = {
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			CAN_CTRLMODE_CC_LEN8_DLC,
+			CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
@@ -1288,7 +1292,7 @@ const struct peak_usb_adapter pcan_usb_x6 = {
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			CAN_CTRLMODE_CC_LEN8_DLC,
+			CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index b314d2eaaece..2d1b645af76c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -37,6 +37,7 @@
 
 #define PCAN_USBPRO_RTR			0x01
 #define PCAN_USBPRO_EXT			0x02
+#define PCAN_USBPRO_SS			0x08
 
 #define PCAN_USBPRO_CMD_BUFFER_SIZE	512
 
@@ -781,6 +782,10 @@ static int pcan_usb_pro_encode_msg(struct peak_usb_device *dev,
 	if (cf->can_id & CAN_RTR_FLAG)
 		flags |= PCAN_USBPRO_RTR;
 
+	/* Single-Shot frame */
+	if (dev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		flags |= PCAN_USBPRO_SS;
+
 	pcan_msg_add_rec(&usb_msg, data_type, 0, flags, len, cf->can_id,
 			 cf->data);
 
@@ -1039,7 +1044,8 @@ const struct peak_usb_adapter pcan_usb_pro = {
 	.name = "PCAN-USB Pro",
 	.device_id = PCAN_USBPRO_PRODUCT_ID,
 	.ctrl_count = PCAN_USBPRO_CHANNEL_COUNT,
-	.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
+	.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
+			      CAN_CTRLMODE_ONE_SHOT,
 	.clock = {
 		.freq = PCAN_USBPRO_CRYSTAL_HZ,
 	},
-- 
2.30.2


