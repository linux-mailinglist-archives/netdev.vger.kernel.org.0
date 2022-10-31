Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493E4613A7B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiJaPoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiJaPoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61C211A32
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:44:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWxP-0002o7-Iu
        for netdev@vger.kernel.org; Mon, 31 Oct 2022 16:44:11 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2FE7110F445
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:44:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 43D9C10F40E;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 430d5cdf;
        Mon, 31 Oct 2022 15:44:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/14] can: peak_usb: allow flashing of the user device id
Date:   Mon, 31 Oct 2022 16:43:55 +0100
Message-Id: <20221031154406.259857-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031154406.259857-1-mkl@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

This series of patches adds a callback that allows the user to flash a
self-defined device id to all USB - CAN/CANFD interfaces of PEAK-System
managed by this driver, namely:
- PCAN-USB
- PCAN-USB FD
- PCAN-USB Pro FD
- PCAN-USB X6
- PCAN-Chip USB
- PCAN-USB Pro

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20221030105939.87658-4-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      | 26 ++++++++++++++++++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   | 26 ++++++++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  | 15 +++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h  |  1 +
 5 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 11fd033b57f3..6c01b2c6212b 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -9,10 +9,12 @@
  * Many thanks to Klaus Hitschler <klaus.hitschler@gmx.de>
  */
 #include <asm/unaligned.h>
+
+#include <linux/ethtool.h>
+#include <linux/limits.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
-#include <linux/module.h>
-#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -398,6 +400,25 @@ static int pcan_usb_get_user_devid(struct peak_usb_device *dev, u32 *user_devid)
 	return err;
 }
 
+/* set a new user device id in the flash memory of the device */
+static int pcan_usb_set_user_devid(struct peak_usb_device *dev, u32 user_devid)
+{
+	u8 args[PCAN_USB_CMD_ARGS_LEN];
+
+	/* this kind of device supports 8-bit values only */
+	if (user_devid > U8_MAX)
+		return -EINVAL;
+
+	/* during the flash process the device disconnects during ~1.25 s.:
+	 * prohibit access when interface is UP
+	 */
+	if (dev->netdev->flags & IFF_UP)
+		return -EBUSY;
+
+	args[0] = user_devid;
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_DEVID, PCAN_USB_SET, args);
+}
+
 /*
  * update current time ref with received timestamp
  */
@@ -1018,6 +1039,7 @@ const struct peak_usb_adapter pcan_usb = {
 	.dev_set_bus = pcan_usb_write_mode,
 	.dev_set_bittiming = pcan_usb_set_bittiming,
 	.dev_get_user_devid = pcan_usb_get_user_devid,
+	.dev_set_user_devid = pcan_usb_set_user_devid,
 	.dev_decode_buf = pcan_usb_decode_buf,
 	.dev_encode_msg = pcan_usb_encode_msg,
 	.dev_start = pcan_usb_start,
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index 6ff32673a256..d9c9e333c47a 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -61,6 +61,7 @@ struct peak_usb_adapter {
 				      struct can_bittiming *bt);
 	int (*dev_set_bus)(struct peak_usb_device *dev, u8 onoff);
 	int (*dev_get_user_devid)(struct peak_usb_device *dev, u32 *user_devid);
+	int (*dev_set_user_devid)(struct peak_usb_device *dev, u32 user_devid);
 	int (*dev_decode_buf)(struct peak_usb_device *dev, struct urb *urb);
 	int (*dev_encode_msg)(struct peak_usb_device *dev, struct sk_buff *skb,
 					u8 *obuf, size_t *size);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 2db358d0295e..1f5ad0dc2b1c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -147,6 +147,15 @@ struct __packed pcan_ufd_ovr_msg {
 	u8	unused[3];
 };
 
+#define PCAN_UFD_CMD_DEVID_SET		0x81
+
+struct __packed pcan_ufd_device_id {
+	__le16	opcode_channel;
+
+	u16	unused;
+	__le32	device_id;
+};
+
 static inline int pufd_omsg_get_channel(struct pcan_ufd_ovr_msg *om)
 {
 	return om->channel & 0xf;
@@ -458,6 +467,19 @@ static int pcan_usb_fd_get_user_devid(struct peak_usb_device *dev,
 	return err;
 }
 
+/* set a new user device id in the flash memory of the device */
+static int pcan_usb_fd_set_user_devid(struct peak_usb_device *dev, u32 devid)
+{
+	struct pcan_ufd_device_id *cmd = pcan_usb_fd_cmd_buffer(dev);
+
+	cmd->opcode_channel = pucan_cmd_opcode_channel(dev->ctrl_idx,
+						       PCAN_UFD_CMD_DEVID_SET);
+	cmd->device_id = cpu_to_le32(devid);
+
+	/* send the command */
+	return pcan_usb_fd_send_cmd(dev, ++cmd);
+}
+
 /* handle restart but in asynchronously way
  * (uses PCAN-USB Pro code to complete asynchronous request)
  */
@@ -1170,6 +1192,7 @@ const struct peak_usb_adapter pcan_usb_fd = {
 	.dev_set_bittiming = pcan_usb_fd_set_bittiming_slow,
 	.dev_set_data_bittiming = pcan_usb_fd_set_bittiming_fast,
 	.dev_get_user_devid = pcan_usb_fd_get_user_devid,
+	.dev_set_user_devid = pcan_usb_fd_set_user_devid,
 	.dev_decode_buf = pcan_usb_fd_decode_buf,
 	.dev_start = pcan_usb_fd_start,
 	.dev_stop = pcan_usb_fd_stop,
@@ -1245,6 +1268,7 @@ const struct peak_usb_adapter pcan_usb_chip = {
 	.dev_set_bittiming = pcan_usb_fd_set_bittiming_slow,
 	.dev_set_data_bittiming = pcan_usb_fd_set_bittiming_fast,
 	.dev_get_user_devid = pcan_usb_fd_get_user_devid,
+	.dev_set_user_devid = pcan_usb_fd_set_user_devid,
 	.dev_decode_buf = pcan_usb_fd_decode_buf,
 	.dev_start = pcan_usb_fd_start,
 	.dev_stop = pcan_usb_fd_stop,
@@ -1320,6 +1344,7 @@ const struct peak_usb_adapter pcan_usb_pro_fd = {
 	.dev_set_bittiming = pcan_usb_fd_set_bittiming_slow,
 	.dev_set_data_bittiming = pcan_usb_fd_set_bittiming_fast,
 	.dev_get_user_devid = pcan_usb_fd_get_user_devid,
+	.dev_set_user_devid = pcan_usb_fd_set_user_devid,
 	.dev_decode_buf = pcan_usb_fd_decode_buf,
 	.dev_start = pcan_usb_fd_start,
 	.dev_stop = pcan_usb_fd_stop,
@@ -1395,6 +1420,7 @@ const struct peak_usb_adapter pcan_usb_x6 = {
 	.dev_set_bittiming = pcan_usb_fd_set_bittiming_slow,
 	.dev_set_data_bittiming = pcan_usb_fd_set_bittiming_fast,
 	.dev_get_user_devid = pcan_usb_fd_get_user_devid,
+	.dev_set_user_devid = pcan_usb_fd_set_user_devid,
 	.dev_decode_buf = pcan_usb_fd_decode_buf,
 	.dev_start = pcan_usb_fd_start,
 	.dev_stop = pcan_usb_fd_stop,
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 15410d60cdf7..d3731c5aa4ed 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -76,6 +76,7 @@ static u16 pcan_usb_pro_sizeof_rec[256] = {
 	[PCAN_USBPRO_SETFILTR] = sizeof(struct pcan_usb_pro_filter),
 	[PCAN_USBPRO_SETTS] = sizeof(struct pcan_usb_pro_setts),
 	[PCAN_USBPRO_GETDEVID] = sizeof(struct pcan_usb_pro_devid),
+	[PCAN_USBPRO_SETDEVID] = sizeof(struct pcan_usb_pro_devid),
 	[PCAN_USBPRO_SETLED] = sizeof(struct pcan_usb_pro_setled),
 	[PCAN_USBPRO_RXMSG8] = sizeof(struct pcan_usb_pro_rxmsg),
 	[PCAN_USBPRO_RXMSG4] = sizeof(struct pcan_usb_pro_rxmsg) - 4,
@@ -149,6 +150,7 @@ static int pcan_msg_add_rec(struct pcan_usb_pro_msg *pm, int id, ...)
 
 	case PCAN_USBPRO_SETBTR:
 	case PCAN_USBPRO_GETDEVID:
+	case PCAN_USBPRO_SETDEVID:
 		*pc++ = va_arg(ap, int);
 		pc += 2;
 		*(__le32 *)pc = cpu_to_le32(va_arg(ap, u32));
@@ -444,6 +446,18 @@ static int pcan_usb_pro_get_user_devid(struct peak_usb_device *dev,
 	return err;
 }
 
+static int pcan_usb_pro_set_user_devid(struct peak_usb_device *dev,
+				       u32 user_devid)
+{
+	struct pcan_usb_pro_msg um;
+
+	pcan_msg_init_empty(&um, dev->cmd_buf, PCAN_USB_MAX_CMD_LEN);
+	pcan_msg_add_rec(&um, PCAN_USBPRO_SETDEVID, dev->ctrl_idx,
+			 user_devid);
+
+	return pcan_usb_pro_send_cmd(dev, &um);
+}
+
 static int pcan_usb_pro_set_bittiming(struct peak_usb_device *dev,
 				      struct can_bittiming *bt)
 {
@@ -1077,6 +1091,7 @@ const struct peak_usb_adapter pcan_usb_pro = {
 	.dev_set_bus = pcan_usb_pro_set_bus,
 	.dev_set_bittiming = pcan_usb_pro_set_bittiming,
 	.dev_get_user_devid = pcan_usb_pro_get_user_devid,
+	.dev_set_user_devid = pcan_usb_pro_set_user_devid,
 	.dev_decode_buf = pcan_usb_pro_decode_buf,
 	.dev_encode_msg = pcan_usb_pro_encode_msg,
 	.dev_start = pcan_usb_pro_start,
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
index a34e0fc021c9..28e740af905d 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
@@ -62,6 +62,7 @@ struct __packed pcan_usb_pro_fwinfo {
 #define PCAN_USBPRO_SETBTR	0x02
 #define PCAN_USBPRO_SETBUSACT	0x04
 #define PCAN_USBPRO_SETSILENT	0x05
+#define PCAN_USBPRO_SETDEVID	0x06
 #define PCAN_USBPRO_SETFILTR	0x0a
 #define PCAN_USBPRO_SETTS	0x10
 #define PCAN_USBPRO_GETDEVID	0x12
-- 
2.35.1


