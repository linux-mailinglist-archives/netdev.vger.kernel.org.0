Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C135ACA7
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhDJKBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 06:01:34 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:20342 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhDJKB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 06:01:27 -0400
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d06 with ME
        id qy0H2400Q3PnFJp03y189w; Sat, 10 Apr 2021 12:01:11 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 10 Apr 2021 12:01:11 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v15 3/3] can: etas_es58x: add support for the ETAS ES58X_FD CAN USB interfaces
Date:   Sat, 10 Apr 2021 18:59:48 +0900
Message-Id: <20210410095948.233305-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
References: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for the ES582.1 and ES584.1 interfaces from
ETAS GmbH (https://www.etas.com/en/products/es58x.php).

Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/Makefile     |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c |  19 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h |   6 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c   | 562 ++++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h   | 243 +++++++++
 5 files changed, 828 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

diff --git a/drivers/net/can/usb/etas_es58x/Makefile b/drivers/net/can/usb/etas_es58x/Makefile
index e4753ec9cb60..a129b4aa0215 100644
--- a/drivers/net/can/usb/etas_es58x/Makefile
+++ b/drivers/net/can/usb/etas_es58x/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x.o
-etas_es58x-y = es58x_core.o es581_4.o
+etas_es58x-y = es58x_core.o es581_4.o es58x_fd.o
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index cc003c62bee2..35ba8af89b2e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -28,6 +28,11 @@ MODULE_LICENSE("GPL v2");
 #define ES58X_MODULE_NAME "etas_es58x"
 #define ES58X_VENDOR_ID 0x108C
 #define ES581_4_PRODUCT_ID 0x0159
+#define ES582_1_PRODUCT_ID 0x0168
+#define ES584_1_PRODUCT_ID 0x0169
+
+/* ES58X FD has some interface protocols unsupported by this driver. */
+#define ES58X_FD_INTERFACE_PROTOCOL 0
 
 /* Table of devices which work with this driver. */
 static const struct usb_device_id es58x_id_table[] = {
@@ -35,6 +40,16 @@ static const struct usb_device_id es58x_id_table[] = {
 		/* ETAS GmbH ES581.4 USB dual-channel CAN Bus Interface module. */
 		USB_DEVICE(ES58X_VENDOR_ID, ES581_4_PRODUCT_ID),
 		.driver_info = ES58X_DUAL_CHANNEL
+	}, {
+		/* ETAS GmbH ES582.1 USB dual-channel CAN FD Bus Interface module. */
+		USB_DEVICE_INTERFACE_PROTOCOL(ES58X_VENDOR_ID, ES582_1_PRODUCT_ID,
+					      ES58X_FD_INTERFACE_PROTOCOL),
+		.driver_info = ES58X_DUAL_CHANNEL | ES58X_FD_FAMILY
+	}, {
+		/* ETAS GmbH ES584.1 USB single-channel CAN FD Bus Interface module. */
+		USB_DEVICE_INTERFACE_PROTOCOL(ES58X_VENDOR_ID, ES584_1_PRODUCT_ID,
+					      ES58X_FD_INTERFACE_PROTOCOL),
+		.driver_info = ES58X_FD_FAMILY
 	}, {
 		/* Terminating entry */
 	}
@@ -2164,8 +2179,8 @@ static int es58x_init_es58x_dev(struct usb_interface *intf,
 		return ret;
 
 	if (driver_info & ES58X_FD_FAMILY) {
-		return -ENODEV;
-		/* Place holder for es58x_fd glue code. */
+		param = &es58x_fd_param;
+		ops = &es58x_fd_ops;
 	} else {
 		param = &es581_4_param;
 		ops = &es581_4_ops;
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 0e7a7dcc48d4..5f4e7dc5be35 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -19,12 +19,15 @@
 #include <linux/can/dev.h>
 
 #include "es581_4.h"
+#include "es58x_fd.h"
 
 /* Driver constants */
 #define ES58X_RX_URBS_MAX 5	/* Empirical value */
 #define ES58X_TX_URBS_MAX 6	/* Empirical value */
 
-#define ES58X_MAX(param) (ES581_4_##param)
+#define ES58X_MAX(param)				\
+	(ES581_4_##param > ES58X_FD_##param ?		\
+		ES581_4_##param : ES58X_FD_##param)
 #define ES58X_TX_BULK_MAX ES58X_MAX(TX_BULK_MAX)
 #define ES58X_RX_BULK_MAX ES58X_MAX(RX_BULK_MAX)
 #define ES58X_ECHO_BULK_MAX ES58X_MAX(ECHO_BULK_MAX)
@@ -213,6 +216,7 @@ enum es58x_ret_type {
 
 union es58x_urb_cmd {
 	struct es581_4_urb_cmd es581_4_urb_cmd;
+	struct es58x_fd_urb_cmd es58x_fd_urb_cmd;
 	struct {		/* Common header parts of all variants */
 		__le16 sof;
 		u8 cmd_type;
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
new file mode 100644
index 000000000000..1a2779d383a4
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_fd.c: Adds support to ETAS ES582.1 and ES584.1 (naming
+ * convention: we use the term "ES58X FD" when referring to those two
+ * variants together).
+ *
+ * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
+ * Copyright (c) 2020 ETAS K.K.. All rights reserved.
+ * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#include <linux/kernel.h>
+#include <asm/unaligned.h>
+
+#include "es58x_core.h"
+#include "es58x_fd.h"
+
+/**
+ * es58x_fd_sizeof_rx_tx_msg() - Calculate the actual length of the
+ *	structure of a rx or tx message.
+ * @msg: message of variable length, must have a dlc and a len fields.
+ *
+ * Even if RTR frames have actually no payload, the ES58X devices
+ * still expect it. Must be a macro in order to accept several types
+ * (struct es58x_fd_tx_can_msg and struct es58x_fd_rx_can_msg) as an
+ * input.
+ *
+ * Return: length of the message.
+ */
+#define es58x_fd_sizeof_rx_tx_msg(msg)					\
+({									\
+	typeof(msg) __msg = (msg);					\
+	size_t __msg_len;						\
+									\
+	if (__msg.flags & ES58X_FLAG_FD_DATA)				\
+		__msg_len = canfd_sanitize_len(__msg.len);		\
+	else								\
+		__msg_len = can_cc_dlc2len(__msg.dlc);			\
+									\
+	offsetof(typeof(__msg), data[__msg_len]);			\
+})
+
+static enum es58x_fd_cmd_type es58x_fd_cmd_type(struct net_device *netdev)
+{
+	u32 ctrlmode = es58x_priv(netdev)->can.ctrlmode;
+
+	if (ctrlmode & (CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO))
+		return ES58X_FD_CMD_TYPE_CANFD;
+	else
+		return ES58X_FD_CMD_TYPE_CAN;
+}
+
+static u16 es58x_fd_get_msg_len(const union es58x_urb_cmd *urb_cmd)
+{
+	return get_unaligned_le16(&urb_cmd->es58x_fd_urb_cmd.msg_len);
+}
+
+static int es58x_fd_echo_msg(struct net_device *netdev,
+			     const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	const struct es58x_fd_echo_msg *echo_msg;
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	u64 *tstamps = es58x_dev->timestamps;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int i, num_element;
+	u32 rcv_packet_idx;
+
+	const u32 mask = GENMASK(31, sizeof(echo_msg->packet_idx) * 8);
+
+	num_element = es58x_msg_num_element(es58x_dev->dev,
+					    es58x_fd_urb_cmd->echo_msg,
+					    msg_len);
+	if (num_element < 0)
+		return num_element;
+	echo_msg = es58x_fd_urb_cmd->echo_msg;
+
+	rcv_packet_idx = (priv->tx_tail & mask) | echo_msg[0].packet_idx;
+	for (i = 0; i < num_element; i++) {
+		if ((u8)rcv_packet_idx != echo_msg[i].packet_idx) {
+			netdev_err(netdev, "Packet idx jumped from %u to %u\n",
+				   (u8)rcv_packet_idx - 1,
+				   echo_msg[i].packet_idx);
+			return -EBADMSG;
+		}
+
+		tstamps[i] = get_unaligned_le64(&echo_msg[i].timestamp);
+		rcv_packet_idx++;
+	}
+
+	return es58x_can_get_echo_skb(netdev, priv->tx_tail, tstamps, num_element);
+}
+
+static int es58x_fd_rx_can_msg(struct net_device *netdev,
+			       const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	const u8 *rx_can_msg_buf = es58x_fd_urb_cmd->rx_can_msg_buf;
+	u16 rx_can_msg_buf_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int pkts, ret;
+
+	ret = es58x_check_msg_max_len(es58x_dev->dev,
+				      es58x_fd_urb_cmd->rx_can_msg_buf,
+				      rx_can_msg_buf_len);
+	if (ret)
+		return ret;
+
+	for (pkts = 0; rx_can_msg_buf_len > 0; pkts++) {
+		const struct es58x_fd_rx_can_msg *rx_can_msg =
+		    (const struct es58x_fd_rx_can_msg *)rx_can_msg_buf;
+		bool is_can_fd = !!(rx_can_msg->flags & ES58X_FLAG_FD_DATA);
+		/* rx_can_msg_len is the length of the rx_can_msg
+		 * buffer. Not to be confused with rx_can_msg->len
+		 * which is the length of the CAN payload
+		 * rx_can_msg->data.
+		 */
+		u16 rx_can_msg_len = es58x_fd_sizeof_rx_tx_msg(*rx_can_msg);
+
+		if (rx_can_msg_len > rx_can_msg_buf_len) {
+			netdev_err(netdev,
+				   "%s: Expected a rx_can_msg of size %d but only %d bytes are left in rx_can_msg_buf\n",
+				   __func__,
+				   rx_can_msg_len, rx_can_msg_buf_len);
+			return -EMSGSIZE;
+		}
+		if (rx_can_msg->len > CANFD_MAX_DLEN) {
+			netdev_err(netdev,
+				   "%s: Data length is %d but maximum should be %d\n",
+				   __func__, rx_can_msg->len, CANFD_MAX_DLEN);
+			return -EMSGSIZE;
+		}
+
+		if (netif_running(netdev)) {
+			u64 tstamp = get_unaligned_le64(&rx_can_msg->timestamp);
+			canid_t can_id = get_unaligned_le32(&rx_can_msg->can_id);
+			u8 dlc;
+
+			if (is_can_fd)
+				dlc = can_fd_len2dlc(rx_can_msg->len);
+			else
+				dlc = rx_can_msg->dlc;
+
+			ret = es58x_rx_can_msg(netdev, tstamp, rx_can_msg->data,
+					       can_id, rx_can_msg->flags, dlc);
+			if (ret)
+				break;
+		}
+
+		rx_can_msg_buf_len -= rx_can_msg_len;
+		rx_can_msg_buf += rx_can_msg_len;
+	}
+
+	if (!netif_running(netdev)) {
+		if (net_ratelimit())
+			netdev_info(netdev,
+				    "%s: %s is down, dropping %d rx packets\n",
+				    __func__, netdev->name, pkts);
+		netdev->stats.rx_dropped += pkts;
+	}
+
+	return ret;
+}
+
+static int es58x_fd_rx_event_msg(struct net_device *netdev,
+				 const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	const struct es58x_fd_rx_event_msg *rx_event_msg;
+	int ret;
+
+	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
+	if (ret)
+		return ret;
+
+	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
+
+	return es58x_rx_err_msg(netdev, rx_event_msg->error_code,
+				rx_event_msg->event_code,
+				get_unaligned_le64(&rx_event_msg->timestamp));
+}
+
+static int es58x_fd_rx_cmd_ret_u32(struct net_device *netdev,
+				   const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd,
+				   enum es58x_ret_type cmd_ret_type)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int ret;
+
+	ret = es58x_check_msg_len(es58x_dev->dev,
+				  es58x_fd_urb_cmd->rx_cmd_ret_le32, msg_len);
+	if (ret)
+		return ret;
+
+	return es58x_rx_cmd_ret_u32(netdev, cmd_ret_type,
+				    get_unaligned_le32(&es58x_fd_urb_cmd->rx_cmd_ret_le32));
+}
+
+static int es58x_fd_tx_ack_msg(struct net_device *netdev,
+			       const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	const struct es58x_fd_tx_ack_msg *tx_ack_msg;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int ret;
+
+	tx_ack_msg = &es58x_fd_urb_cmd->tx_ack_msg;
+	ret = es58x_check_msg_len(es58x_dev->dev, *tx_ack_msg, msg_len);
+	if (ret)
+		return ret;
+
+	return es58x_tx_ack_msg(netdev,
+				get_unaligned_le16(&tx_ack_msg->tx_free_entries),
+				get_unaligned_le32(&tx_ack_msg->rx_cmd_ret_le32));
+}
+
+static int es58x_fd_can_cmd_id(struct es58x_device *es58x_dev,
+			       const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	struct net_device *netdev;
+	int ret;
+
+	ret = es58x_get_netdev(es58x_dev, es58x_fd_urb_cmd->channel_idx,
+			       ES58X_FD_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	switch ((enum es58x_fd_can_cmd_id)es58x_fd_urb_cmd->cmd_id) {
+	case ES58X_FD_CAN_CMD_ID_ENABLE_CHANNEL:
+		return es58x_fd_rx_cmd_ret_u32(netdev, es58x_fd_urb_cmd,
+					       ES58X_RET_TYPE_ENABLE_CHANNEL);
+
+	case ES58X_FD_CAN_CMD_ID_DISABLE_CHANNEL:
+		return es58x_fd_rx_cmd_ret_u32(netdev, es58x_fd_urb_cmd,
+					       ES58X_RET_TYPE_DISABLE_CHANNEL);
+
+	case ES58X_FD_CAN_CMD_ID_TX_MSG:
+		return es58x_fd_tx_ack_msg(netdev, es58x_fd_urb_cmd);
+
+	case ES58X_FD_CAN_CMD_ID_ECHO_MSG:
+		return es58x_fd_echo_msg(netdev, es58x_fd_urb_cmd);
+
+	case ES58X_FD_CAN_CMD_ID_RX_MSG:
+		return es58x_fd_rx_can_msg(netdev, es58x_fd_urb_cmd);
+
+	case ES58X_FD_CAN_CMD_ID_RESET_RX:
+		return es58x_fd_rx_cmd_ret_u32(netdev, es58x_fd_urb_cmd,
+					       ES58X_RET_TYPE_RESET_RX);
+
+	case ES58X_FD_CAN_CMD_ID_RESET_TX:
+		return es58x_fd_rx_cmd_ret_u32(netdev, es58x_fd_urb_cmd,
+					       ES58X_RET_TYPE_RESET_TX);
+
+	case ES58X_FD_CAN_CMD_ID_ERROR_OR_EVENT_MSG:
+		return es58x_fd_rx_event_msg(netdev, es58x_fd_urb_cmd);
+
+	default:
+		return -EBADRQC;
+	}
+}
+
+static int es58x_fd_device_cmd_id(struct es58x_device *es58x_dev,
+				  const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd)
+{
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int ret;
+
+	switch ((enum es58x_fd_dev_cmd_id)es58x_fd_urb_cmd->cmd_id) {
+	case ES58X_FD_DEV_CMD_ID_TIMESTAMP:
+		ret = es58x_check_msg_len(es58x_dev->dev,
+					  es58x_fd_urb_cmd->timestamp, msg_len);
+		if (ret)
+			return ret;
+		es58x_rx_timestamp(es58x_dev,
+				   get_unaligned_le64(&es58x_fd_urb_cmd->timestamp));
+		return 0;
+
+	default:
+		return -EBADRQC;
+	}
+}
+
+static int es58x_fd_handle_urb_cmd(struct es58x_device *es58x_dev,
+				   const union es58x_urb_cmd *urb_cmd)
+{
+	const struct es58x_fd_urb_cmd *es58x_fd_urb_cmd;
+	int ret;
+
+	es58x_fd_urb_cmd = &urb_cmd->es58x_fd_urb_cmd;
+
+	switch ((enum es58x_fd_cmd_type)es58x_fd_urb_cmd->cmd_type) {
+	case ES58X_FD_CMD_TYPE_CAN:
+	case ES58X_FD_CMD_TYPE_CANFD:
+		ret = es58x_fd_can_cmd_id(es58x_dev, es58x_fd_urb_cmd);
+		break;
+
+	case ES58X_FD_CMD_TYPE_DEVICE:
+		ret = es58x_fd_device_cmd_id(es58x_dev, es58x_fd_urb_cmd);
+		break;
+
+	default:
+		ret = -EBADRQC;
+		break;
+	}
+
+	if (ret == -EBADRQC)
+		dev_err(es58x_dev->dev,
+			"%s: Unknown command type (0x%02X) and command ID (0x%02X) combination\n",
+			__func__, es58x_fd_urb_cmd->cmd_type,
+			es58x_fd_urb_cmd->cmd_id);
+
+	return ret;
+}
+
+static void es58x_fd_fill_urb_header(union es58x_urb_cmd *urb_cmd, u8 cmd_type,
+				     u8 cmd_id, u8 channel_idx, u16 msg_len)
+{
+	struct es58x_fd_urb_cmd *es58x_fd_urb_cmd = &urb_cmd->es58x_fd_urb_cmd;
+
+	es58x_fd_urb_cmd->SOF = cpu_to_le16(es58x_fd_param.tx_start_of_frame);
+	es58x_fd_urb_cmd->cmd_type = cmd_type;
+	es58x_fd_urb_cmd->cmd_id = cmd_id;
+	es58x_fd_urb_cmd->channel_idx = channel_idx;
+	es58x_fd_urb_cmd->msg_len = cpu_to_le16(msg_len);
+}
+
+static int es58x_fd_tx_can_msg(struct es58x_priv *priv,
+			       const struct sk_buff *skb)
+{
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	union es58x_urb_cmd *urb_cmd = priv->tx_urb->transfer_buffer;
+	struct es58x_fd_urb_cmd *es58x_fd_urb_cmd = &urb_cmd->es58x_fd_urb_cmd;
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct es58x_fd_tx_can_msg *tx_can_msg;
+	bool is_fd = can_is_canfd_skb(skb);
+	u16 msg_len;
+	int ret;
+
+	if (priv->tx_can_msg_cnt == 0) {
+		msg_len = 0;
+		es58x_fd_fill_urb_header(urb_cmd,
+					 is_fd ? ES58X_FD_CMD_TYPE_CANFD
+					       : ES58X_FD_CMD_TYPE_CAN,
+					 ES58X_FD_CAN_CMD_ID_TX_MSG_NO_ACK,
+					 priv->channel_idx, msg_len);
+	} else {
+		msg_len = es58x_fd_get_msg_len(urb_cmd);
+	}
+
+	ret = es58x_check_msg_max_len(es58x_dev->dev,
+				      es58x_fd_urb_cmd->tx_can_msg_buf,
+				      msg_len + sizeof(*tx_can_msg));
+	if (ret)
+		return ret;
+
+	/* Fill message contents. */
+	tx_can_msg = (struct es58x_fd_tx_can_msg *)
+	    &es58x_fd_urb_cmd->tx_can_msg_buf[msg_len];
+	tx_can_msg->packet_idx = (u8)priv->tx_head;
+	put_unaligned_le32(es58x_get_raw_can_id(cf), &tx_can_msg->can_id);
+	tx_can_msg->flags = (u8)es58x_get_flags(skb);
+	if (is_fd)
+		tx_can_msg->len = cf->len;
+	else
+		tx_can_msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+	memcpy(tx_can_msg->data, cf->data, cf->len);
+
+	/* Calculate new sizes */
+	msg_len += es58x_fd_sizeof_rx_tx_msg(*tx_can_msg);
+	priv->tx_urb->transfer_buffer_length = es58x_get_urb_cmd_len(es58x_dev,
+								     msg_len);
+	put_unaligned_le16(msg_len, &es58x_fd_urb_cmd->msg_len);
+
+	return 0;
+}
+
+static void es58x_fd_convert_bittiming(struct es58x_fd_bittiming *es58x_fd_bt,
+				       struct can_bittiming *bt)
+{
+	/* The actual value set in the hardware registers is one less
+	 * than the functional value.
+	 */
+	const int offset = 1;
+
+	es58x_fd_bt->bitrate = cpu_to_le32(bt->bitrate);
+	es58x_fd_bt->tseg1 =
+	    cpu_to_le16(bt->prop_seg + bt->phase_seg1 - offset);
+	es58x_fd_bt->tseg2 = cpu_to_le16(bt->phase_seg2 - offset);
+	es58x_fd_bt->brp = cpu_to_le16(bt->brp - offset);
+	es58x_fd_bt->sjw = cpu_to_le16(bt->sjw - offset);
+}
+
+static int es58x_fd_enable_channel(struct es58x_priv *priv)
+{
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	struct net_device *netdev = es58x_dev->netdev[priv->channel_idx];
+	struct es58x_fd_tx_conf_msg tx_conf_msg = { 0 };
+	u32 ctrlmode;
+	size_t conf_len = 0;
+
+	es58x_fd_convert_bittiming(&tx_conf_msg.nominal_bittiming,
+				   &priv->can.bittiming);
+	ctrlmode = priv->can.ctrlmode;
+
+	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
+		tx_conf_msg.samples_per_bit = ES58X_SAMPLES_PER_BIT_THREE;
+	else
+		tx_conf_msg.samples_per_bit = ES58X_SAMPLES_PER_BIT_ONE;
+	tx_conf_msg.sync_edge = ES58X_SYNC_EDGE_SINGLE;
+	tx_conf_msg.physical_layer = ES58X_PHYSICAL_LAYER_HIGH_SPEED;
+	tx_conf_msg.echo_mode = ES58X_ECHO_ON;
+	if (ctrlmode & CAN_CTRLMODE_LISTENONLY)
+		tx_conf_msg.ctrlmode |= ES58X_FD_CTRLMODE_PASSIVE;
+	else
+		tx_conf_msg.ctrlmode |=  ES58X_FD_CTRLMODE_ACTIVE;
+
+	if (ctrlmode & CAN_CTRLMODE_FD_NON_ISO) {
+		tx_conf_msg.ctrlmode |= ES58X_FD_CTRLMODE_FD_NON_ISO;
+		tx_conf_msg.canfd_enabled = 1;
+	} else if (ctrlmode & CAN_CTRLMODE_FD) {
+		tx_conf_msg.ctrlmode |= ES58X_FD_CTRLMODE_FD;
+		tx_conf_msg.canfd_enabled = 1;
+	}
+
+	if (tx_conf_msg.canfd_enabled) {
+		es58x_fd_convert_bittiming(&tx_conf_msg.data_bittiming,
+					   &priv->can.data_bittiming);
+
+		if (priv->can.tdc.tdco) {
+			tx_conf_msg.tdc_enabled = 1;
+			tx_conf_msg.tdco = cpu_to_le16(priv->can.tdc.tdco);
+			tx_conf_msg.tdcf = cpu_to_le16(priv->can.tdc.tdcf);
+		}
+
+		conf_len = ES58X_FD_CANFD_CONF_LEN;
+	} else {
+		conf_len = ES58X_FD_CAN_CONF_LEN;
+	}
+
+	return es58x_send_msg(es58x_dev, es58x_fd_cmd_type(netdev),
+			      ES58X_FD_CAN_CMD_ID_ENABLE_CHANNEL,
+			      &tx_conf_msg, conf_len, priv->channel_idx);
+}
+
+static int es58x_fd_disable_channel(struct es58x_priv *priv)
+{
+	/* The type (ES58X_FD_CMD_TYPE_CAN or ES58X_FD_CMD_TYPE_CANFD) does
+	 * not matter here.
+	 */
+	return es58x_send_msg(priv->es58x_dev, ES58X_FD_CMD_TYPE_CAN,
+			      ES58X_FD_CAN_CMD_ID_DISABLE_CHANNEL,
+			      ES58X_EMPTY_MSG, 0, priv->channel_idx);
+}
+
+static int es58x_fd_get_timestamp(struct es58x_device *es58x_dev)
+{
+	return es58x_send_msg(es58x_dev, ES58X_FD_CMD_TYPE_DEVICE,
+			      ES58X_FD_DEV_CMD_ID_TIMESTAMP, ES58X_EMPTY_MSG,
+			      0, ES58X_CHANNEL_IDX_NA);
+}
+
+/* Nominal bittiming constants for ES582.1 and ES584.1 as specified in
+ * the microcontroller datasheet: "SAM E701/S70/V70/V71 Family"
+ * section 49.6.8 "MCAN Nominal Bit Timing and Prescaler Register"
+ * from Microchip.
+ *
+ * The values from the specification are the hardware register
+ * values. To convert them to the functional values, all ranges were
+ * incremented by 1 (e.g. range [0..n-1] changed to [1..n]).
+ */
+static const struct can_bittiming_const es58x_fd_nom_bittiming_const = {
+	.name = "ES582.1/ES584.1",
+	.tseg1_min = 2,
+	.tseg1_max = 256,
+	.tseg2_min = 2,
+	.tseg2_max = 128,
+	.sjw_max = 128,
+	.brp_min = 1,
+	.brp_max = 512,
+	.brp_inc = 1
+};
+
+/* Data bittiming constants for ES582.1 and ES584.1 as specified in
+ * the microcontroller datasheet: "SAM E701/S70/V70/V71 Family"
+ * section 49.6.4 "MCAN Data Bit Timing and Prescaler Register" from
+ * Microchip.
+ */
+static const struct can_bittiming_const es58x_fd_data_bittiming_const = {
+	.name = "ES582.1/ES584.1",
+	.tseg1_min = 2,
+	.tseg1_max = 32,
+	.tseg2_min = 1,
+	.tseg2_max = 16,
+	.sjw_max = 8,
+	.brp_min = 1,
+	.brp_max = 32,
+	.brp_inc = 1
+};
+
+/* Transmission Delay Compensation constants for ES582.1 and ES584.1
+ * as specified in the microcontroller datasheet: "SAM
+ * E701/S70/V70/V71 Family" section 49.6.15 "MCAN Transmitter Delay
+ * Compensation Register" from Microchip.
+ */
+static const struct can_tdc_const es58x_tdc_const = {
+	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_max = 127,
+	.tdcf_max = 127
+};
+
+const struct es58x_parameters es58x_fd_param = {
+	.bittiming_const = &es58x_fd_nom_bittiming_const,
+	.data_bittiming_const = &es58x_fd_data_bittiming_const,
+	.tdc_const = &es58x_tdc_const,
+	/* The devices use NXP TJA1044G transievers which guarantee
+	 * the timing for data rates up to 5 Mbps. Bitrates up to 8
+	 * Mbps work in an optimal environment but are not recommended
+	 * for production environment.
+	 */
+	.bitrate_max = 8 * CAN_MBPS,
+	.clock = {.freq = 80 * CAN_MHZ},
+	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
+	    CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
+	    CAN_CTRLMODE_CC_LEN8_DLC,
+	.tx_start_of_frame = 0xCEFA,	/* FACE in little endian */
+	.rx_start_of_frame = 0xFECA,	/* CAFE in little endian */
+	.tx_urb_cmd_max_len = ES58X_FD_TX_URB_CMD_MAX_LEN,
+	.rx_urb_cmd_max_len = ES58X_FD_RX_URB_CMD_MAX_LEN,
+	/* Size of internal device TX queue is 500.
+	 *
+	 * However, when reaching value around 278, the device's busy
+	 * LED turns on and thus maximum value of 500 is never reached
+	 * in practice. Also, when this value is too high, some error
+	 * on the echo_msg were witnessed when the device is
+	 * recovering from bus off.
+	 *
+	 * For above reasons, a value that would prevent the device
+	 * from becoming busy was chosen. In practice, BQL would
+	 * prevent the value from even getting closer to below
+	 * maximum, so no impact on performance was measured.
+	 */
+	.fifo_mask = 255, /* echo_skb_max = 256 */
+	.dql_min_limit = CAN_FRAME_LEN_MAX * 15, /* Empirical value. */
+	.tx_bulk_max = ES58X_FD_TX_BULK_MAX,
+	.urb_cmd_header_len = ES58X_FD_URB_CMD_HEADER_LEN,
+	.rx_urb_max = ES58X_RX_URBS_MAX,
+	.tx_urb_max = ES58X_TX_URBS_MAX
+};
+
+const struct es58x_operators es58x_fd_ops = {
+	.get_msg_len = es58x_fd_get_msg_len,
+	.handle_urb_cmd = es58x_fd_handle_urb_cmd,
+	.fill_urb_header = es58x_fd_fill_urb_header,
+	.tx_can_msg = es58x_fd_tx_can_msg,
+	.enable_channel = es58x_fd_enable_channel,
+	.disable_channel = es58x_fd_disable_channel,
+	.reset_device = NULL, /* Not implemented in the device firmware. */
+	.get_timestamp = es58x_fd_get_timestamp
+};
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
new file mode 100644
index 000000000000..ee18a87e40c0
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -0,0 +1,243 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_fd.h: Definitions and declarations specific to ETAS
+ * ES582.1 and ES584.1 (naming convention: we use the term "ES58X FD"
+ * when referring to those two variants together).
+ *
+ * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
+ * Copyright (c) 2020 ETAS K.K.. All rights reserved.
+ * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#ifndef __ES58X_FD_H__
+#define __ES58X_FD_H__
+
+#include <linux/types.h>
+
+#define ES582_1_NUM_CAN_CH 2
+#define ES584_1_NUM_CAN_CH 1
+#define ES58X_FD_NUM_CAN_CH 2
+#define ES58X_FD_CHANNEL_IDX_OFFSET 0
+
+#define ES58X_FD_TX_BULK_MAX 100
+#define ES58X_FD_RX_BULK_MAX 100
+#define ES58X_FD_ECHO_BULK_MAX 100
+
+enum es58x_fd_cmd_type {
+	ES58X_FD_CMD_TYPE_CAN = 0x03,
+	ES58X_FD_CMD_TYPE_CANFD = 0x04,
+	ES58X_FD_CMD_TYPE_DEVICE = 0xFF
+};
+
+/* Command IDs for ES58X_FD_CMD_TYPE_{CAN,CANFD}. */
+enum es58x_fd_can_cmd_id {
+	ES58X_FD_CAN_CMD_ID_ENABLE_CHANNEL = 0x01,
+	ES58X_FD_CAN_CMD_ID_DISABLE_CHANNEL = 0x02,
+	ES58X_FD_CAN_CMD_ID_TX_MSG = 0x05,
+	ES58X_FD_CAN_CMD_ID_ECHO_MSG = 0x07,
+	ES58X_FD_CAN_CMD_ID_RX_MSG = 0x10,
+	ES58X_FD_CAN_CMD_ID_ERROR_OR_EVENT_MSG = 0x11,
+	ES58X_FD_CAN_CMD_ID_RESET_RX = 0x20,
+	ES58X_FD_CAN_CMD_ID_RESET_TX = 0x21,
+	ES58X_FD_CAN_CMD_ID_TX_MSG_NO_ACK = 0x55
+};
+
+/* Command IDs for ES58X_FD_CMD_TYPE_DEVICE. */
+enum es58x_fd_dev_cmd_id {
+	ES58X_FD_DEV_CMD_ID_GETTIMETICKS = 0x01,
+	ES58X_FD_DEV_CMD_ID_TIMESTAMP = 0x02
+};
+
+/**
+ * enum es58x_fd_ctrlmode - Controller mode.
+ * @ES58X_FD_CTRLMODE_ACTIVE: send and receive messages.
+ * @ES58X_FD_CTRLMODE_PASSIVE: only receive messages (monitor). Do not
+ *	send anything, not even the acknowledgment bit.
+ * @ES58X_FD_CTRLMODE_FD: CAN FD according to ISO11898-1.
+ * @ES58X_FD_CTRLMODE_FD_NON_ISO: follow Bosch CAN FD Specification
+ *	V1.0
+ * @ES58X_FD_CTRLMODE_DISABLE_PROTOCOL_EXCEPTION_HANDLING: How to
+ *	behave when CAN FD reserved bit is monitored as
+ *	dominant. (c.f. ISO 11898-1:2015, section 10.4.2.4 "Control
+ *	field", paragraph "r0 bit"). 0 (not disable = enable): send
+ *	error frame. 1 (disable): goes into bus integration mode
+ *	(c.f. below).
+ * @ES58X_FD_CTRLMODE_EDGE_FILTER_DURING_BUS_INTEGRATION: 0: Edge
+ *	filtering is disabled. 1: Edge filtering is enabled. Two
+ *	consecutive dominant bits required to detect an edge for hard
+ *	synchronization.
+ */
+enum es58x_fd_ctrlmode {
+	ES58X_FD_CTRLMODE_ACTIVE = 0,
+	ES58X_FD_CTRLMODE_PASSIVE = BIT(0),
+	ES58X_FD_CTRLMODE_FD = BIT(4),
+	ES58X_FD_CTRLMODE_FD_NON_ISO = BIT(5),
+	ES58X_FD_CTRLMODE_DISABLE_PROTOCOL_EXCEPTION_HANDLING = BIT(6),
+	ES58X_FD_CTRLMODE_EDGE_FILTER_DURING_BUS_INTEGRATION = BIT(7)
+};
+
+struct es58x_fd_bittiming {
+	__le32 bitrate;
+	__le16 tseg1;		/* range: [tseg1_min-1..tseg1_max-1] */
+	__le16 tseg2;		/* range: [tseg2_min-1..tseg2_max-1] */
+	__le16 brp;		/* range: [brp_min-1..brp_max-1] */
+	__le16 sjw;		/* range: [0..sjw_max-1] */
+} __packed;
+
+/**
+ * struct es58x_fd_tx_conf_msg - Channel configuration.
+ * @nominal_bittiming: Nominal bittiming.
+ * @samples_per_bit: type enum es58x_samples_per_bit.
+ * @sync_edge: type enum es58x_sync_edge.
+ * @physical_layer: type enum es58x_physical_layer.
+ * @echo_mode: type enum es58x_echo_mode.
+ * @ctrlmode: type enum es58x_fd_ctrlmode.
+ * @canfd_enabled: boolean (0: Classical CAN, 1: CAN and/or CANFD).
+ * @data_bittiming: Bittiming for flexible data-rate transmission.
+ * @tdc_enabled: Transmitter Delay Compensation switch (0: disabled,
+ *	1: enabled). On very high bitrates, the delay between when the
+ *	bit is sent and received on the CANTX and CANRX pins of the
+ *	transceiver start to be significant enough for errors to occur
+ *	and thus need to be compensated.
+ * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
+ *	quanta, defining the delay between the start of the bit
+ *	reception on the CANRX pin of the transceiver and the SSP
+ *	(Secondary Sample Point). Valid values: 0 to 127.
+ * @tdcf: Transmitter Delay Compensation Filter window. Defines the
+ *	minimum value for the SSP position, in time quanta. The
+ *	feature is enabled when TDCF is configured to a value greater
+ *	than TDCO. Valid values: 0 to 127.
+ *
+ * Please refer to the microcontroller datasheet: "SAM
+ * E701/S70/V70/V71 Family" section 49 "Controller Area Network
+ * (MCAN)" for additional information.
+ */
+struct es58x_fd_tx_conf_msg {
+	struct es58x_fd_bittiming nominal_bittiming;
+	u8 samples_per_bit;
+	u8 sync_edge;
+	u8 physical_layer;
+	u8 echo_mode;
+	u8 ctrlmode;
+	u8 canfd_enabled;
+	struct es58x_fd_bittiming data_bittiming;
+	u8 tdc_enabled;
+	__le16 tdco;
+	__le16 tdcf;
+} __packed;
+
+#define ES58X_FD_CAN_CONF_LEN					\
+	(offsetof(struct es58x_fd_tx_conf_msg, canfd_enabled))
+#define ES58X_FD_CANFD_CONF_LEN (sizeof(struct es58x_fd_tx_conf_msg))
+
+struct es58x_fd_tx_can_msg {
+	u8 packet_idx;
+	__le32 can_id;
+	u8 flags;
+	union {
+		u8 dlc;		/* Only if cmd_id is ES58X_FD_CMD_TYPE_CAN */
+		u8 len;		/* Only if cmd_id is ES58X_FD_CMD_TYPE_CANFD */
+	} __packed;
+	u8 data[CANFD_MAX_DLEN];
+} __packed;
+
+#define ES58X_FD_CAN_TX_LEN						\
+	(offsetof(struct es58x_fd_tx_can_msg, data[CAN_MAX_DLEN]))
+#define ES58X_FD_CANFD_TX_LEN (sizeof(struct es58x_fd_tx_can_msg))
+
+struct es58x_fd_rx_can_msg {
+	__le64 timestamp;
+	__le32 can_id;
+	u8 flags;
+	union {
+		u8 dlc;		/* Only if cmd_id is ES58X_FD_CMD_TYPE_CAN */
+		u8 len;		/* Only if cmd_id is ES58X_FD_CMD_TYPE_CANFD */
+	} __packed;
+	u8 data[CANFD_MAX_DLEN];
+} __packed;
+
+#define ES58X_FD_CAN_RX_LEN						\
+	(offsetof(struct es58x_fd_rx_can_msg, data[CAN_MAX_DLEN]))
+#define ES58X_FD_CANFD_RX_LEN (sizeof(struct es58x_fd_rx_can_msg))
+
+struct es58x_fd_echo_msg {
+	__le64 timestamp;
+	u8 packet_idx;
+} __packed;
+
+struct es58x_fd_rx_event_msg {
+	__le64 timestamp;
+	__le32 can_id;
+	u8 flags;		/* type enum es58x_flag */
+	u8 error_type;		/* 0: event, 1: error */
+	u8 error_code;
+	u8 event_code;
+} __packed;
+
+struct es58x_fd_tx_ack_msg {
+	__le32 rx_cmd_ret_le32;	/* type enum es58x_cmd_ret_code_u32 */
+	__le16 tx_free_entries;	/* Number of remaining free entries in the device TX queue */
+} __packed;
+
+/**
+ * struct es58x_fd_urb_cmd - Commands received from or sent to the
+ *	ES58X FD device.
+ * @SOF: Start of Frame.
+ * @cmd_type: Command Type (type: enum es58x_fd_cmd_type). The CRC
+ *	calculation starts at this position.
+ * @cmd_id: Command ID (type: enum es58x_fd_cmd_id).
+ * @channel_idx: Channel index starting at 0.
+ * @msg_len: Length of the message, excluding CRC (i.e. length of the
+ *	union).
+ * @tx_conf_msg: Channel configuration.
+ * @tx_can_msg_buf: Concatenation of Tx messages. Type is "u8[]"
+ *	instead of "struct es58x_fd_tx_msg[]" because the structure
+ *	has a flexible size.
+ * @rx_can_msg_buf: Concatenation Rx messages. Type is "u8[]" instead
+ *	of "struct es58x_fd_rx_msg[]" because the structure has a
+ *	flexible size.
+ * @echo_msg: Array of echo messages (e.g. Tx messages being looped
+ *	back).
+ * @rx_event_msg: Error or event message.
+ * @tx_ack_msg: Tx acknowledgment message.
+ * @timestamp: Timestamp reply.
+ * @rx_cmd_ret_le32: Rx 32 bits return code (type: enum
+ *	es58x_cmd_ret_code_u32).
+ * @raw_msg: Message raw payload.
+ * @reserved_for_crc16_do_not_use: The structure ends with a
+ *	CRC16. Because the structures in above union are of variable
+ *	lengths, we can not predict the offset of the CRC in
+ *	advance. Use functions es58x_get_crc() and es58x_set_crc() to
+ *	manipulate it.
+ */
+struct es58x_fd_urb_cmd {
+	__le16 SOF;
+	u8 cmd_type;
+	u8 cmd_id;
+	u8 channel_idx;
+	__le16 msg_len;
+
+	union {
+		struct es58x_fd_tx_conf_msg tx_conf_msg;
+		u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
+		u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
+		struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
+		struct es58x_fd_rx_event_msg rx_event_msg;
+		struct es58x_fd_tx_ack_msg tx_ack_msg;
+		__le64 timestamp;
+		__le32 rx_cmd_ret_le32;
+		u8 raw_msg[0];
+	} __packed;
+
+	__le16 reserved_for_crc16_do_not_use;
+} __packed;
+
+#define ES58X_FD_URB_CMD_HEADER_LEN (offsetof(struct es58x_fd_urb_cmd, raw_msg))
+#define ES58X_FD_TX_URB_CMD_MAX_LEN					\
+	ES58X_SIZEOF_URB_CMD(struct es58x_fd_urb_cmd, tx_can_msg_buf)
+#define ES58X_FD_RX_URB_CMD_MAX_LEN					\
+	ES58X_SIZEOF_URB_CMD(struct es58x_fd_urb_cmd, rx_can_msg_buf)
+
+#endif /* __ES58X_FD_H__ */
-- 
2.26.3

