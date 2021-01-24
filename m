Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF764301BD2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbhAXM0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:26:32 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:52003 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbhAXM0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:26:14 -0500
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d65 with ME
        id LcPt2400N3PnFJp03cQ1HD; Sun, 24 Jan 2021 13:24:06 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 24 Jan 2021 13:24:06 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: [PATCH v11 1/1] can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces
Date:   Sun, 24 Jan 2021 21:23:06 +0900
Message-Id: <20210124122306.265430-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210124122306.265430-1-mailhol.vincent@wanadoo.fr>
References: <20210124122306.265430-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
ETAS GmbH (https://www.etas.com/en/products/es58x.php).

Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/Kconfig                 |   10 +
 drivers/net/can/usb/Makefile                |    1 +
 drivers/net/can/usb/etas_es58x/Makefile     |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c    |  529 ++++
 drivers/net/can/usb/etas_es58x/es581_4.h    |  207 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2519 +++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h |  698 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c   |  600 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h   |  243 ++
 9 files changed, 4810 insertions(+)
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index c1e5d5b570b6..978746ce8873 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -20,6 +20,16 @@ config CAN_ESD_USB2
 	  This driver supports the CAN-USB/2 interface
 	  from esd electronic system design gmbh (http://www.esd.eu).
 
+config CAN_ETAS_ES58X
+	tristate "ETAS ES58X CAN/USB interfaces"
+	select CRC16
+	help
+	  This driver supports the ES581.4, ES582.1 and ES584.1 interfaces
+	  from ETAS GmbH (https://www.etas.com/en/products/es58x.php).
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called etas_es58x.
+
 config CAN_GS_USB
 	tristate "Geschwister Schneider UG interfaces"
 	help
diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
index aa0f17c0b2ed..748cf31a0d53 100644
--- a/drivers/net/can/usb/Makefile
+++ b/drivers/net/can/usb/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_CAN_8DEV_USB) += usb_8dev.o
 obj-$(CONFIG_CAN_EMS_USB) += ems_usb.o
 obj-$(CONFIG_CAN_ESD_USB2) += esd_usb2.o
+obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x/
 obj-$(CONFIG_CAN_GS_USB) += gs_usb.o
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb/
 obj-$(CONFIG_CAN_MCBA_USB) += mcba_usb.o
diff --git a/drivers/net/can/usb/etas_es58x/Makefile b/drivers/net/can/usb/etas_es58x/Makefile
new file mode 100644
index 000000000000..a129b4aa0215
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x.o
+etas_es58x-y = es58x_core.o es581_4.o es58x_fd.o
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
new file mode 100644
index 000000000000..66a76332a9a2
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -0,0 +1,529 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es581_4.c: Adds support to ETAS ES581.4.
+ *
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <asm/unaligned.h>
+
+#include "es58x_core.h"
+#include "es581_4.h"
+
+/**
+ * es58x_sizeof_rx_tx_msg() - Calculate the actual length of the
+ *	structure of a rx or tx message.
+ * @msg: message of variable length, must have a dlc field.
+ *
+ * Even if RTR frames have actually no payload, the ES58X devices
+ * still expect it. Must be a macro in order to retrieve the actual
+ * size using offsetof() and typeof().
+ *
+ * Return: length of the message.
+ */
+#define es581_4_sizeof_rx_tx_msg(msg)				\
+	offsetof(typeof(msg), data[can_cc_dlc2len((msg).dlc)])
+
+static u16 es581_4_get_msg_len(const union es58x_urb_cmd *urb_cmd)
+{
+	return get_unaligned_le16(&urb_cmd->es581_4_urb_cmd.msg_len);
+}
+
+static int es581_4_rx_loopback_msg(struct es58x_device *es58x_dev,
+				   const struct es581_4_urb_cmd
+				   *es581_4_urb_cmd)
+{
+	struct net_device *netdev;
+	const struct es581_4_bulk_rx_loopback_msg *bulk_rx_loopback_msg;
+	const struct es581_4_rx_loopback_msg *rx_loopback_msg;
+	u64 *tstamps = es58x_dev->timestamps;
+	u16 msg_len;
+	u32 first_packet_idx, packet_idx;
+	unsigned int dropped = 0;
+	int i, num_element, ret;
+
+	bulk_rx_loopback_msg = &es581_4_urb_cmd->bulk_rx_loopback_msg;
+	msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len) -
+	    sizeof(bulk_rx_loopback_msg->channel_no);
+	num_element =
+	    es58x_msg_num_element(es58x_dev->dev,
+				  bulk_rx_loopback_msg->rx_loopback_msg,
+				  msg_len);
+	if (num_element <= 0)
+		return num_element;
+
+	ret = es58x_get_netdev(es58x_dev, bulk_rx_loopback_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	rx_loopback_msg = &bulk_rx_loopback_msg->rx_loopback_msg[0];
+	first_packet_idx = get_unaligned_le32(&rx_loopback_msg->packet_idx);
+	packet_idx = first_packet_idx;
+	for (i = 0; i < num_element; i++) {
+		rx_loopback_msg = &bulk_rx_loopback_msg->rx_loopback_msg[i];
+		if (get_unaligned_le32(&rx_loopback_msg->packet_idx)
+		    == packet_idx - 1) {
+			if (net_ratelimit())
+				netdev_warn(netdev,
+					    "Received loopback packet idx %u twice\n",
+					    packet_idx - 1);
+			dropped++;
+			continue;
+		}
+		if (get_unaligned_le32(&rx_loopback_msg->packet_idx)
+		    != packet_idx) {
+			netdev_err(netdev, "Packet idx jumped from %u to %u\n",
+				   packet_idx - 1, rx_loopback_msg->packet_idx);
+			return -EBADMSG;
+		}
+
+		tstamps[i] = get_unaligned_le64(&rx_loopback_msg->timestamp);
+		packet_idx++;
+	}
+
+	netdev->stats.tx_dropped += dropped;
+	return es58x_can_get_echo_skb(netdev, first_packet_idx,
+				      tstamps, num_element - dropped);
+}
+
+static int es581_4_rx_can_msg(struct es58x_device *es58x_dev,
+			      const struct es581_4_urb_cmd *es581_4_urb_cmd,
+			      u16 msg_len)
+{
+	const struct device *dev = es58x_dev->dev;
+	struct net_device *netdev;
+	int pkts, num_element, channel_no, ret;
+
+	num_element = es58x_msg_num_element(dev, es581_4_urb_cmd->rx_can_msg,
+					    msg_len);
+	if (num_element <= 0)
+		return num_element;
+
+	channel_no = es581_4_urb_cmd->rx_can_msg[0].channel_no;
+	ret = es58x_get_netdev(es58x_dev, channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	if (!netif_running(netdev)) {
+		if (net_ratelimit())
+			netdev_info(netdev,
+				    "%s: %s is down, dropping %d rx packets\n",
+				    __func__, netdev->name, num_element);
+		netdev->stats.rx_dropped += num_element;
+		return 0;
+	}
+
+	for (pkts = 0; pkts < num_element; pkts++) {
+		const struct es581_4_rx_can_msg *rx_can_msg =
+		    &es581_4_urb_cmd->rx_can_msg[pkts];
+		u64 tstamp = get_unaligned_le64(&rx_can_msg->timestamp);
+		canid_t can_id = get_unaligned_le32(&rx_can_msg->can_id);
+
+		if (channel_no != rx_can_msg->channel_no) {
+			netdev_err(netdev,
+				   "%s: channel_no changed from %d to %d\n",
+				   __func__,
+				   channel_no, rx_can_msg->channel_no);
+			return -EBADMSG;
+		}
+
+		ret = es58x_rx_can_msg(netdev, tstamp, rx_can_msg->data,
+				       can_id, rx_can_msg->flags,
+				       rx_can_msg->dlc);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int es581_4_rx_err_msg(struct es58x_device *es58x_dev,
+			      const struct es581_4_rx_err_msg *rx_err_msg)
+{
+	struct net_device *netdev;
+	enum es58x_err error = get_unaligned_le32(&rx_err_msg->error);
+	int ret;
+
+	ret = es58x_get_netdev(es58x_dev, rx_err_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	return es58x_rx_err_msg(netdev, error, 0,
+				get_unaligned_le64(&rx_err_msg->timestamp));
+}
+
+static int es581_4_rx_event_msg(struct es58x_device *es58x_dev,
+				const struct es581_4_rx_event_msg *rx_event_msg)
+{
+	struct net_device *netdev;
+	enum es58x_event event = get_unaligned_le32(&rx_event_msg->event);
+	int ret;
+
+	ret = es58x_get_netdev(es58x_dev, rx_event_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	return es58x_rx_err_msg(netdev, 0, event,
+				get_unaligned_le64(&rx_event_msg->timestamp));
+}
+
+static int es581_4_rx_cmd_ret_u32(struct es58x_device *es58x_dev,
+				  const struct es581_4_urb_cmd *es581_4_urb_cmd,
+				  enum es58x_ret_type ret_type)
+{
+	struct net_device *netdev;
+	const struct es581_4_rx_dev_ret *rx_dev_ret;
+	u16 msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len);
+	enum es58x_ret_u32 rx_cmd_ret_u32;
+	int ret;
+
+	ret = es58x_check_msg_len(es58x_dev->dev,
+				  es581_4_urb_cmd->rx_dev_ret, msg_len);
+	if (ret)
+		return ret;
+
+	rx_dev_ret = &es581_4_urb_cmd->rx_dev_ret;
+
+	ret = es58x_get_netdev(es58x_dev, rx_dev_ret->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	rx_cmd_ret_u32 = get_unaligned_le32(&rx_dev_ret->rx_cmd_ret_le32);
+	return es58x_rx_cmd_ret_u32(netdev, ret_type, rx_cmd_ret_u32);
+}
+
+static int es581_4_tx_ack_msg(struct es58x_device *es58x_dev,
+			      const struct es581_4_urb_cmd *es581_4_urb_cmd)
+{
+	struct net_device *netdev;
+	const struct es581_4_tx_ack_msg *tx_ack_msg;
+	u16 msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len);
+	int ret;
+
+	tx_ack_msg = &es581_4_urb_cmd->tx_ack_msg;
+	ret = es58x_check_msg_len(es58x_dev->dev, *tx_ack_msg, msg_len);
+	if (ret)
+		return ret;
+
+	if (tx_ack_msg->rx_dev_ret_u8 != ES58X_RET_U8_OK)
+		return es58x_rx_dev_ret_u8(es58x_dev->dev,
+					   ES58X_RET_TYPE_TX_MSG,
+					   tx_ack_msg->rx_dev_ret_u8);
+
+	ret = es58x_get_netdev(es58x_dev, tx_ack_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	return
+	    es58x_tx_ack_msg(netdev,
+			     get_unaligned_le16(&tx_ack_msg->tx_free_entries),
+			     ES58X_RET_U32_OK);
+}
+
+static int es581_4_dispatch_rx_cmd(struct es58x_device *es58x_dev,
+				   const struct es581_4_urb_cmd
+				   *es581_4_urb_cmd)
+{
+	const struct device *dev = es58x_dev->dev;
+	u16 msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len);
+	enum es581_4_rx_type rx_type = es581_4_urb_cmd->rx_can_msg[0].rx_type;
+	int ret = 0;
+
+	switch (rx_type) {
+	case ES581_4_RX_TYPE_MESSAGE:
+		return es581_4_rx_can_msg(es58x_dev, es581_4_urb_cmd, msg_len);
+
+	case ES581_4_RX_TYPE_ERROR:
+		ret = es58x_check_msg_len(dev, es581_4_urb_cmd->rx_err_msg,
+					  msg_len);
+		if (ret < 0)
+			return ret;
+		return es581_4_rx_err_msg(es58x_dev,
+					  &es581_4_urb_cmd->rx_err_msg);
+
+	case ES581_4_RX_TYPE_EVENT:
+		ret = es58x_check_msg_len(dev, es581_4_urb_cmd->rx_event_msg,
+					  msg_len);
+		if (ret < 0)
+			return ret;
+		return es581_4_rx_event_msg(es58x_dev,
+					    &es581_4_urb_cmd->rx_event_msg);
+
+	default:
+		dev_err(dev, "%s: Unknown rx_type 0x%02X\n", __func__, rx_type);
+		return -EBADRQC;
+	}
+}
+
+static int es581_4_handle_urb_cmd(struct es58x_device *es58x_dev,
+				  const union es58x_urb_cmd *urb_cmd)
+{
+	const struct es581_4_urb_cmd *es581_4_urb_cmd;
+	const struct device *dev = es58x_dev->dev;
+	u16 msg_len = es581_4_get_msg_len(urb_cmd);
+	int ret;
+
+	es581_4_urb_cmd = &urb_cmd->es581_4_urb_cmd;
+
+	if (es581_4_urb_cmd->cmd_type != ES581_4_CAN_COMMAND_TYPE) {
+		dev_err(dev, "%s: Unknown command type (0x%02X)\n",
+			__func__, es581_4_urb_cmd->cmd_type);
+		return -EBADRQC;
+	}
+
+	switch ((enum es581_4_cmd_id)es581_4_urb_cmd->cmd_id) {
+	case ES581_4_CMD_ID_SET_BITTIMING:
+		return es581_4_rx_cmd_ret_u32(es58x_dev, es581_4_urb_cmd,
+					      ES58X_RET_TYPE_SET_BITTIMING);
+
+	case ES581_4_CMD_ID_ENABLE_CHANNEL:
+		return es581_4_rx_cmd_ret_u32(es58x_dev, es581_4_urb_cmd,
+					      ES58X_RET_TYPE_ENABLE_CHANNEL);
+
+	case ES581_4_CMD_ID_TX_MSG:
+		return es581_4_tx_ack_msg(es58x_dev, es581_4_urb_cmd);
+
+	case ES581_4_CMD_ID_RX_MSG:
+		return es581_4_dispatch_rx_cmd(es58x_dev, es581_4_urb_cmd);
+
+	case ES581_4_CMD_ID_RESET_RX:
+		ret = es581_4_rx_cmd_ret_u32(es58x_dev, es581_4_urb_cmd,
+					     ES58X_RET_TYPE_RESET_RX);
+		return ret;
+
+	case ES581_4_CMD_ID_RESET_TX:
+		ret = es581_4_rx_cmd_ret_u32(es58x_dev, es581_4_urb_cmd,
+					     ES58X_RET_TYPE_RESET_TX);
+		return ret;
+
+	case ES581_4_CMD_ID_DISABLE_CHANNEL:
+		return es581_4_rx_cmd_ret_u32(es58x_dev, es581_4_urb_cmd,
+					      ES58X_RET_TYPE_DISABLE_CHANNEL);
+
+	case ES581_4_CMD_ID_TIMESTAMP:
+		ret = es58x_check_msg_len(dev, es581_4_urb_cmd->timestamp,
+					  msg_len);
+		if (ret < 0)
+			return ret;
+		return es58x_rx_timestamp(es58x_dev,
+					  get_unaligned_le64
+					  (&es581_4_urb_cmd->timestamp));
+
+	case ES581_4_CMD_ID_SELF_RECEPTION:
+		return es581_4_rx_loopback_msg(es58x_dev, es581_4_urb_cmd);
+
+	case ES581_4_CMD_ID_DEVICE_ERR:
+		ret = es58x_check_msg_len(dev, es581_4_urb_cmd->rx_dev_ret_u8,
+					  msg_len);
+		if (ret)
+			return ret;
+		return es58x_rx_dev_ret_u8(es58x_dev->dev,
+					   ES58X_RET_TYPE_DEVICE_ERR,
+					   es581_4_urb_cmd->rx_dev_ret_u8);
+
+	default:
+		dev_warn(dev, "%s: Unexpected command ID: 0x%02X\n",
+			 __func__, es581_4_urb_cmd->cmd_id);
+		return -EBADRQC;
+	}
+}
+
+static void es581_4_fill_urb_header(union es58x_urb_cmd *urb_cmd, u8 cmd_type,
+				    u8 cmd_id, u8 channel_idx, u16 msg_len)
+{
+	struct es581_4_urb_cmd *es581_4_urb_cmd = &urb_cmd->es581_4_urb_cmd;
+
+	es581_4_urb_cmd->SOF = cpu_to_le16(es581_4_param.tx_start_of_frame);
+	es581_4_urb_cmd->cmd_type = cmd_type;
+	es581_4_urb_cmd->cmd_id = cmd_id;
+	es581_4_urb_cmd->msg_len = cpu_to_le16(msg_len);
+}
+
+static int es581_4_tx_can_msg(struct es58x_priv *priv,
+			      const struct sk_buff *skb)
+{
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	union es58x_urb_cmd *urb_cmd = priv->tx_urb->transfer_buffer;
+	struct es581_4_urb_cmd *es581_4_urb_cmd = &urb_cmd->es581_4_urb_cmd;
+	u32 *urb_cmd_len = &priv->tx_urb->transfer_buffer_length;
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct es581_4_tx_can_msg *tx_can_msg;
+	u16 msg_len;
+	int ret;
+
+	ret = es58x_check_msg_max_len(es58x_dev->dev,
+				      es581_4_urb_cmd->bulk_tx_can_msg,
+				      es581_4_get_msg_len(urb_cmd) +
+				      sizeof(*tx_can_msg));
+	if (ret)
+		return ret;
+
+	if (can_is_canfd_skb(skb))
+		return -EMSGSIZE;
+
+	/* Fill message contents. */
+	if (*urb_cmd_len == es58x_dev->param->urb_cmd_header_len) {
+		es581_4_fill_urb_header(urb_cmd, ES581_4_CAN_COMMAND_TYPE,
+					ES581_4_CMD_ID_TX_MSG,
+					priv->channel_idx, *urb_cmd_len);
+		msg_len = 1;
+	} else {
+		msg_len = le16_to_cpu(es581_4_urb_cmd->msg_len);
+	}
+	tx_can_msg = (struct es581_4_tx_can_msg *)
+	    &es581_4_urb_cmd->bulk_tx_can_msg.tx_can_msg_buf[msg_len - 1];
+
+	put_unaligned_le32(es58x_get_raw_can_id(cf), &tx_can_msg->can_id);
+	put_unaligned_le32(priv->tx_head + priv->tx_can_msg_cnt,
+			   &tx_can_msg->packet_idx);
+	put_unaligned_le16((u16)es58x_get_flags(skb), &tx_can_msg->flags);
+	tx_can_msg->channel_no = priv->channel_idx + 1;
+	tx_can_msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+
+	memcpy(tx_can_msg->data, cf->data, cf->len);
+
+	/* Calculate new sizes. */
+	es581_4_urb_cmd->bulk_tx_can_msg.num_can_msg++;
+	msg_len += es581_4_sizeof_rx_tx_msg(*tx_can_msg);
+	*urb_cmd_len = es58x_get_urb_cmd_len(es58x_dev, msg_len);
+	es581_4_urb_cmd->msg_len = cpu_to_le16(msg_len);
+
+	return 0;
+}
+
+static int es581_4_set_bittiming(struct es58x_priv *priv)
+{
+	struct es581_4_tx_conf_msg tx_conf_msg = { 0 };
+	struct can_bittiming *bt = &priv->can.bittiming;
+
+	tx_conf_msg.bitrate = cpu_to_le32(bt->bitrate);
+	/* bt->sample_point is in tenth of percent. Convert it to percent. */
+	tx_conf_msg.sample_point = cpu_to_le32(bt->sample_point / 10U);
+	tx_conf_msg.samples_per_bit = cpu_to_le32(ES58X_SAMPLES_PER_BIT_ONE);
+	tx_conf_msg.bit_time = cpu_to_le32(can_bit_time(bt));
+	tx_conf_msg.sjw = cpu_to_le32(bt->sjw);
+	tx_conf_msg.sync_edge = cpu_to_le32(ES58X_SYNC_EDGE_SINGLE);
+	tx_conf_msg.physical_layer =
+	    cpu_to_le32(ES58X_PHYSICAL_LAYER_HIGH_SPEED);
+	tx_conf_msg.self_reception_mode = cpu_to_le32(ES58X_SELF_RECEPTION_ON);
+	tx_conf_msg.channel_no = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_SET_BITTIMING, &tx_conf_msg,
+			      sizeof(tx_conf_msg), priv->channel_idx);
+}
+
+static int es581_4_enable_channel(struct es58x_priv *priv)
+{
+	u8 msg = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_ENABLE_CHANNEL, &msg, sizeof(msg),
+			      priv->channel_idx);
+}
+
+static int es581_4_disable_channel(struct es58x_priv *priv)
+{
+	u8 msg = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_DISABLE_CHANNEL, &msg, sizeof(msg),
+			      priv->channel_idx);
+}
+
+static int es581_4_reset_rx(struct es58x_priv *priv)
+{
+	u8 msg = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_RESET_RX, &msg, sizeof(msg),
+			      priv->channel_idx);
+}
+
+static int es581_4_reset_tx(struct es58x_priv *priv)
+{
+	u8 msg = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_RESET_TX, &msg, sizeof(msg),
+			      priv->channel_idx);
+}
+
+static int es581_4_get_timestamp(struct es58x_device *es58x_dev)
+{
+	return es58x_send_msg(es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_TIMESTAMP, ES58X_EMPTY_MSG,
+			      0, ES58X_CHANNEL_IDX_NA);
+}
+
+/* struct es581_4_bittiming_const - Nominal bittiming constants.
+ *
+ * Nominal bittiming constants for ES581.4 as specified in the
+ * microcontroller datasheet: "Stellaris(R) LM3S5B91 Microcontroller"
+ * table 17-4 "CAN Protocol Ranges" from Texas Instruments.
+ */
+static const struct can_bittiming_const es581_4_bittiming_const = {
+	.name = "ES581.4",
+	.tseg1_min = 1,
+	.tseg1_max = 8,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 128,
+	.brp_inc = 1
+};
+
+const struct es58x_parameters es581_4_param = {
+	.bittiming_const = &es581_4_bittiming_const,
+	.data_bittiming_const = NULL,
+	.bitrate_max = ES58X_MBPS(1),
+	.clock = {.freq = ES58X_MHZ(50)},
+	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_CC_LEN8_DLC,
+	.tx_start_of_frame = 0xAFAF,
+	.rx_start_of_frame = 0xFAFA,
+	.tx_urb_cmd_max_len = ES581_4_TX_URB_CMD_MAX_LEN,
+	.rx_urb_cmd_max_len = ES581_4_RX_URB_CMD_MAX_LEN,
+	/* Size of internal device TX queue is 330.
+	 *
+	 * However, we witnessed some ES58X_ERR_PROT_CRC errors from
+	 * the device and thus, echo_skb_max was lowered to the
+	 * empirical value of 75 which seems stable.
+	 *
+	 * Root cause of those ES58X_ERR_PROT_CRC errors is still
+	 * unclear.
+	 */
+	.fifo_mask = 63, /* echo_skb_max = 64 */
+#ifdef CONFIG_BQL
+	/* Empirical value. */
+	.dql_limit_min = CAN_FRAME_LEN_MAX * 50,
+#endif
+	.tx_bulk_max = ES581_4_TX_BULK_MAX,
+	.urb_cmd_header_len = ES581_4_URB_CMD_HEADER_LEN,
+	.rx_urb_max = ES58X_RX_URBS_MAX,
+	.tx_urb_max = ES58X_TX_URBS_MAX
+};
+
+const struct es58x_operators es581_4_ops = {
+	.get_msg_len = es581_4_get_msg_len,
+	.handle_urb_cmd = es581_4_handle_urb_cmd,
+	.fill_urb_header = es581_4_fill_urb_header,
+	.tx_can_msg = es581_4_tx_can_msg,
+	.set_bittiming = es581_4_set_bittiming,
+	.enable_channel = es581_4_enable_channel,
+	.disable_channel = es581_4_disable_channel,
+	.reset_rx = es581_4_reset_rx,
+	.reset_tx = es581_4_reset_tx,
+	.get_timestamp = es581_4_get_timestamp
+};
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
new file mode 100644
index 000000000000..c3489fe729a2
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es581_4.h
@@ -0,0 +1,207 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es581_4.h: Definitions and declarations specific to ETAS
+ * ES581.4.
+ *
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
+ */
+
+#ifndef __ES581_4_H__
+#define __ES581_4_H__
+
+#include <linux/types.h>
+
+#define ES581_4_NUM_CAN_CH 2
+#define ES581_4_CHANNEL_IDX_OFFSET 1
+
+#define ES581_4_TX_BULK_MAX 25
+#define ES581_4_RX_BULK_MAX 30
+#define ES581_4_RX_LOOPBACK_BULK_MAX 30
+
+enum es581_4_cmd_type {
+	ES581_4_CAN_COMMAND_TYPE = 0x45
+};
+
+enum es581_4_cmd_id {
+	ES581_4_CMD_ID_OPEN_CHANNEL = 0x01,
+	ES581_4_CMD_ID_CLOSE_CHANNEL = 0x02,
+	ES581_4_CMD_ID_SET_BITTIMING = 0x03,
+	ES581_4_CMD_ID_ENABLE_CHANNEL = 0x04,
+	ES581_4_CMD_ID_TX_MSG = 0x05,
+	ES581_4_CMD_ID_RX_MSG = 0x06,
+	ES581_4_CMD_ID_RESET_RX = 0x0A,
+	ES581_4_CMD_ID_RESET_TX = 0x0B,
+	ES581_4_CMD_ID_DISABLE_CHANNEL = 0x0C,
+	ES581_4_CMD_ID_TIMESTAMP = 0x0E,
+	ES581_4_CMD_ID_RESET_DEVICE = 0x28,
+	ES581_4_CMD_ID_SELF_RECEPTION = 0x71,
+	ES581_4_CMD_ID_DEVICE_ERR = 0x72
+};
+
+enum es581_4_rx_type {
+	ES581_4_RX_TYPE_MESSAGE = 1,
+	ES581_4_RX_TYPE_ERROR = 3,
+	ES581_4_RX_TYPE_EVENT = 4
+};
+
+/**
+ * struct es581_4_tx_conf_msg - Channel configuration.
+ * @bitrate: Bitrate.
+ * @sample_point: Sample point is in percent [0..100].
+ * @samples_per_bit: type enum es58x_samples_per_bit.
+ * @bit_time: Number of time quanta in one bit.
+ * @sjw: Synchronization Jump Width.
+ * @sync_edge: type enum es58x_sync_edge.
+ * @physical_layer: type enum es58x_physical_layer.
+ * @self_reception_mode: type enum es58x_self_reception_mode.
+ * @channel_no: Channel number, starting from 1. Not to be confused
+ *	with channed_idx of the ES58X FD which starts from 0.
+ */
+struct es581_4_tx_conf_msg {
+	__le32 bitrate;
+	__le32 sample_point;
+	__le32 samples_per_bit;
+	__le32 bit_time;
+	__le32 sjw;
+	__le32 sync_edge;
+	__le32 physical_layer;
+	__le32 self_reception_mode;
+	u8 channel_no;
+} __packed;
+
+struct es581_4_tx_can_msg {
+	__le32 can_id;
+	__le32 packet_idx;
+	__le16 flags;
+	u8 channel_no;
+	u8 dlc;
+	u8 data[CAN_MAX_DLEN];
+} __packed;
+
+/* The ES581.4 allows bulk transfer.  */
+struct es581_4_bulk_tx_can_msg {
+	u8 num_can_msg;
+	/* Using type "u8[]" instead of "struct es581_4_tx_can_msg[]"
+	 * for tx_msg_buf because each member has a flexible size.
+	 */
+	u8 tx_can_msg_buf[ES581_4_TX_BULK_MAX *
+			  sizeof(struct es581_4_tx_can_msg)];
+} __packed;
+
+struct es581_4_rx_loopback_msg {
+	__le64 timestamp;
+	__le32 packet_idx;
+} __packed;
+
+struct es581_4_bulk_rx_loopback_msg {
+	u8 channel_no;
+	struct es581_4_rx_loopback_msg
+	 rx_loopback_msg[ES581_4_RX_LOOPBACK_BULK_MAX];
+} __packed;
+
+/* Normal Rx CAN Message */
+struct es581_4_rx_can_msg {
+	__le64 timestamp;
+	u8 rx_type;		/* type enum es581_4_rx_type */
+	u8 flags;		/* type enum es58x_flag */
+	u8 channel_no;
+	u8 dlc;
+	__le32 can_id;
+	u8 data[CAN_MAX_DLEN];
+} __packed;
+
+struct es581_4_rx_err_msg {
+	__le64 timestamp;
+	__le16 rx_type;		/* type enum es581_4_rx_type */
+	__le16 flags;		/* type enum es58x_flag */
+	u8 channel_no;
+	u8 __padding[2];
+	u8 dlc;
+	__le32 tag;		/* Related to the CAN filtering. Unused in this module */
+	__le32 can_id;
+	__le32 error;		/* type enum es58x_error */
+	__le32 destination;	/* Unused in this module */
+} __packed;
+
+struct es581_4_rx_event_msg {
+	__le64 timestamp;
+	__le16 rx_type;		/* type enum es581_4_rx_type */
+	u8 channel_no;
+	u8 __padding;
+	__le32 tag;		/* Related to the CAN filtering. Unused in this module */
+	__le32 event;		/* type enum es58x_event */
+	__le32 destination;	/* Unused in this module */
+} __packed;
+
+struct es581_4_tx_ack_msg {
+	__le16 tx_free_entries;	/* Number of remaining free entries in the device TX queue */
+	u8 channel_no;
+	u8 rx_dev_ret_u8;	/* type enum es58x_dev_ret_code_u8 */
+} __packed;
+
+struct es581_4_rx_dev_ret {
+	__le32 rx_cmd_ret_le32;
+	u8 channel_no;
+	u8 __padding[3];
+} __packed;
+
+/**
+ * struct es581_4_urb_cmd - Commands received from or sent to the
+ *	ES581.4 device.
+ * @SOF: Start of Frame.
+ * @cmd_type: Command Type (type: enum es581_4_cmd_type). The CRC
+ *	calculation starts at this position.
+ * @cmd_id: Command ID (type: enum es581_4_cmd_id).
+ * @msg_len: Length of the message, excluding CRC (i.e. length of the
+ *	union).
+ * @tx_conf_msg: Channel configuration.
+ * @bulk_tx_can_msg: Tx messages.
+ * @rx_can_msg: Array of Rx messages.
+ * @bulk_rx_loopback_msg: Loopback messages.
+ * @rx_err_msg: Error message.
+ * @rx_event_msg: Event message.
+ * @tx_ack_msg: Tx acknowledgment message.
+ * @timestamp: Timestamp reply.
+ * @rx_cmd_ret_u8: Rx 8 bits return code (type: enum
+ *	es58x_dev_ret_code_u8).
+ * @raw_msg: Message raw payload.
+ * @reserved_for_crc16_do_not_use: The structure ends with a
+ *	CRC16. Because the structures in above union are of variable
+ *	lengths, we can not predict the offset of the CRC in
+ *	advance. Use functions es58x_get_crc() and es58x_set_crc() to
+ *	manipulate it.
+ */
+struct es581_4_urb_cmd {
+	__le16 SOF;
+	u8 cmd_type;
+	u8 cmd_id;
+	__le16 msg_len;
+
+	union {
+		struct es581_4_tx_conf_msg tx_conf_msg;
+		struct es581_4_bulk_tx_can_msg bulk_tx_can_msg;
+		struct es581_4_rx_can_msg rx_can_msg[ES581_4_RX_BULK_MAX];
+		struct es581_4_bulk_rx_loopback_msg bulk_rx_loopback_msg;
+		struct es581_4_rx_err_msg rx_err_msg;
+		struct es581_4_rx_event_msg rx_event_msg;
+		struct es581_4_tx_ack_msg tx_ack_msg;
+		struct es581_4_rx_dev_ret rx_dev_ret;
+		__le64 timestamp;
+		u8 rx_dev_ret_u8;
+		u8 raw_msg[0];
+	} __packed;
+
+	__le16 reserved_for_crc16_do_not_use;
+} __packed;
+
+#define ES581_4_URB_CMD_HEADER_LEN (offsetof(struct es581_4_urb_cmd, raw_msg))
+#define ES581_4_TX_URB_CMD_MAX_LEN					\
+	ES58X_SIZEOF_URB_CMD(struct es581_4_urb_cmd, bulk_tx_can_msg)
+#define ES581_4_RX_URB_CMD_MAX_LEN					\
+	ES58X_SIZEOF_URB_CMD(struct es581_4_urb_cmd, rx_can_msg)
+
+#endif /* __ES581_4_H__ */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
new file mode 100644
index 000000000000..da94f199bb6a
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -0,0 +1,2519 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_core.c: Core logic to manage the network devices and the
+ * USB interface.
+ *
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/usb.h>
+#include <linux/crc16.h>
+#include <linux/spinlock.h>
+#include <asm/unaligned.h>
+
+#include "es58x_core.h"
+
+#define DRV_VERSION "1.00"
+MODULE_AUTHOR("Mailhol Vincent <mailhol.vincent@wanadoo.fr>");
+MODULE_AUTHOR("Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>");
+MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+
+/* Vendor and product id */
+#define ES58X_MODULE_NAME "etas_es58x"
+#define ES58X_VENDOR_ID 0x108C
+#define ES581_4_PRODUCT_ID 0x0159
+#define ES582_1_PRODUCT_ID 0x0168
+#define ES584_1_PRODUCT_ID 0x0169
+
+/* Table of devices which work with this driver */
+static const struct usb_device_id es58x_id_table[] = {
+	{USB_DEVICE(ES58X_VENDOR_ID, ES581_4_PRODUCT_ID)},
+	{USB_DEVICE(ES58X_VENDOR_ID, ES582_1_PRODUCT_ID)},
+	{USB_DEVICE(ES58X_VENDOR_ID, ES584_1_PRODUCT_ID)},
+	{}			/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, es58x_id_table);
+
+#define es58x_print_hex_dump(buf, len)					\
+	print_hex_dump(KERN_DEBUG,					\
+		       ES58X_MODULE_NAME " " __stringify(buf) ": ",	\
+		       DUMP_PREFIX_NONE, 16, 1, buf, len, false)
+
+#define es58x_print_hex_dump_debug(buf, len)				 \
+	print_hex_dump_debug(ES58X_MODULE_NAME " " __stringify(buf) ": ",\
+			     DUMP_PREFIX_NONE, 16, 1, buf, len, false)
+
+/* The last two bytes of an ES58X command is a CRC16. The first two
+ * bytes (the start of frame) are skipped and the CRC calculation
+ * starts on the third byte.
+ */
+#define ES58X_CRC_CALC_OFFSET	2
+
+/**
+ * es58x_calculate_crc() - Compute the crc16 of a given URB.
+ * @urb_cmd: The URB command for which we want to calculate the CRC.
+ * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
+ *	(ES58X_CRC_CALC_OFFSET + sizeof(crc))
+ *
+ * Return: crc16 value.
+ */
+static u16 es58x_calculate_crc(const union es58x_urb_cmd *urb_cmd, u16 urb_len)
+{
+	u16 crc;
+	ssize_t len = urb_len - ES58X_CRC_CALC_OFFSET - sizeof(crc);
+
+	crc = crc16(0, &urb_cmd->raw_cmd[ES58X_CRC_CALC_OFFSET], len);
+	return crc;
+}
+
+/**
+ * es58x_get_crc() - Get the CRC value of a given URB.
+ * @urb_cmd: The URB command for which we want to get the CRC.
+ * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
+ *	(ES58X_CRC_CALC_OFFSET + sizeof(crc))
+ *
+ * Return: crc16 value.
+ */
+static u16 es58x_get_crc(const union es58x_urb_cmd *urb_cmd, u16 urb_len)
+{
+	u16 crc;
+	const __le16 *crc_addr;
+
+	crc_addr = (__le16 *)&urb_cmd->raw_cmd[urb_len - sizeof(crc)];
+	crc = get_unaligned_le16(crc_addr);
+	return crc;
+}
+
+/**
+ * es58x_set_crc() - Set the CRC value of a given URB.
+ * @urb_cmd: The URB command for which we want to get the CRC.
+ * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
+ *	(ES58X_CRC_CALC_OFFSET + sizeof(crc))
+ */
+static void es58x_set_crc(union es58x_urb_cmd *urb_cmd, u16 urb_len)
+{
+	u16 crc;
+	__le16 *crc_addr;
+
+	crc = es58x_calculate_crc(urb_cmd, urb_len);
+	crc_addr = (__le16 *)&urb_cmd->raw_cmd[urb_len - sizeof(crc)];
+	put_unaligned_le16(crc, crc_addr);
+}
+
+/**
+ * es58x_check_crc() - Validate the CRC value of a given URB.
+ * @es58x_dev: ES58X device.
+ * @urb_cmd: The URB command for which we want to check the CRC.
+ * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
+ *	(ES58X_CRC_CALC_OFFSET + sizeof(crc))
+ *
+ * Return: zero on success, -EBADMSG if the CRC check fails.
+ */
+static int es58x_check_crc(struct es58x_device *es58x_dev,
+			   const union es58x_urb_cmd *urb_cmd, u16 urb_len)
+{
+	u16 calculated_crc = es58x_calculate_crc(urb_cmd, urb_len);
+	u16 expected_crc = es58x_get_crc(urb_cmd, urb_len);
+
+	if (expected_crc != calculated_crc) {
+		dev_err_ratelimited(es58x_dev->dev,
+				    "%s: Bad CRC, urb_len: %d\n",
+				    __func__, urb_len);
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/**
+ * es58x_timestamp_to_ns() - Convert a timestamp value received from a
+ *	ES58X device to nanoseconds.
+ * @timestamp: Timestamp received from a ES58X device.
+ *
+ * The timestamp received from ES58X is expressed in multiple of 0.5
+ * micro seconds. This function converts it in to nanoseconds.
+ *
+ * Return: Timestamp value in nanoseconds.
+ */
+static u64 es58x_timestamp_to_ns(u64 timestamp)
+{
+	const u64 es58x_timestamp_ns_mult_coef = 500ULL;
+
+	return es58x_timestamp_ns_mult_coef * timestamp;
+}
+
+/**
+ * es58x_set_skb_timestamp() - Set the hardware timestamp of an skb.
+ * @netdev: CAN network device.
+ * @skb: socket buffer of a CAN message.
+ * @timestamp: Timestamp received from an ES58X device.
+ *
+ * Used for both received and loopback messages.
+ *
+ * Return: zero on success, -EFAULT if @skb is NULL.
+ */
+static int es58x_set_skb_timestamp(struct net_device *netdev,
+				   struct sk_buff *skb, u64 timestamp)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	struct skb_shared_hwtstamps *hwts;
+
+	hwts = skb_hwtstamps(skb);
+	/* Ignoring overflow (overflow on 64 bits timestamp with nano
+	 * second precision would occur after more than 500 years).
+	 */
+	hwts->hwtstamp = ns_to_ktime(es58x_timestamp_to_ns(timestamp) +
+				     es58x_dev->realtime_diff_ns);
+
+	return 0;
+}
+
+/**
+ * es58x_rx_timestamp() - Handle a received timestamp.
+ * @es58x_dev: ES58X device.
+ * @timestamp: Timestamp received from a ES58X device.
+ *
+ * Calculate the difference between the ES58X device and the kernel
+ * internal clocks. This difference will be later used as an offset to
+ * convert the timestamps of RX and loopback messages to match the
+ * kernel system time (e.g. convert to UNIX time).
+ *
+ * Return: zero on success.
+ */
+int es58x_rx_timestamp(struct es58x_device *es58x_dev, u64 timestamp)
+{
+	u64 ktime_real_ns = ktime_get_real_ns();
+	u64 device_timestamp = es58x_timestamp_to_ns(timestamp);
+
+	dev_dbg(es58x_dev->dev, "%s: request round-trip time: %llu ns\n",
+		__func__, ktime_real_ns - es58x_dev->ktime_req_ns);
+
+	es58x_dev->realtime_diff_ns =
+	    (es58x_dev->ktime_req_ns + ktime_real_ns) / 2 - device_timestamp;
+	es58x_dev->ktime_req_ns = 0;
+
+	dev_dbg(es58x_dev->dev,
+		"%s: Device timestamp: %llu, diff with kernel: %llu\n",
+		__func__, device_timestamp, es58x_dev->realtime_diff_ns);
+
+	return 0;
+}
+
+/**
+ * es58x_set_realtime_diff_ns() - Calculate difference between the
+ *	clocks of the ES58X device and the kernel
+ * @es58x_dev: ES58X device.
+ *
+ * Request a timestamp from the ES58X device. Once the answer is
+ * received, the timestamp difference will be set by the callback
+ * function es58x_rx_timestamp().
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_set_realtime_diff_ns(struct es58x_device *es58x_dev)
+{
+	if (es58x_dev->ktime_req_ns) {
+		dev_warn(es58x_dev->dev,
+			 "%s: Previous request to set timestamp has not completed yet\n",
+			 __func__);
+		return -EBUSY;
+	}
+
+	es58x_dev->ktime_req_ns = ktime_get_real_ns();
+	return es58x_dev->ops->get_timestamp(es58x_dev);
+}
+
+/**
+ * es58x_is_can_state_active() - Is the network device in an active
+ *	CAN state?
+ * @netdev: CAN network device.
+ *
+ * The device is considered active if it is able to send or receive
+ * CAN frames, that is to say if it is in any of
+ * CAN_STATE_ERROR_ACTIVE, CAN_STATE_ERROR_WARNING or
+ * CAN_STATE_ERROR_PASSIVE states.
+ *
+ * Caution: when recovering from a bus-off,
+ * net/core/dev.c#can_restart() will call
+ * net/core/dev.c#can_flush_echo_skb() without using any kind of
+ * locks. For this reason, it is critical to guaranty that no TX or
+ * loopback operations (i.e. any access to priv->echo_skb[]) can be
+ * done while this function is returning false.
+ *
+ * Return: true if the device is active, else returns false.
+ */
+static bool es58x_is_can_state_active(struct net_device *netdev)
+{
+	return es58x_priv(netdev)->can.state < CAN_STATE_BUS_OFF;
+}
+
+/**
+ * es58x_is_echo_skb_threshold_reached() - Determine the limit of how
+ *	many skb slots can be taken before we should stop the network
+ *	queue.
+ * @priv: ES58X private parameters related to the network device.
+ *
+ * We need to save enough free skb slots in order to be able to do
+ * bulk send. This function can be used to determine when to wake or
+ * stop the network queue in regard to the number of skb slots already
+ * taken if the loopback FIFO.
+ *
+ * Return: boolean.
+ */
+static bool es58x_is_echo_skb_threshold_reached(struct es58x_priv *priv)
+{
+	unsigned long num_echo_skb =  priv->tx_head - priv->tx_tail;
+	unsigned long threshold = priv->can.echo_skb_max -
+		priv->es58x_dev->param->tx_bulk_max + 1;
+
+	return num_echo_skb >= threshold;
+}
+
+/**
+ * es58x_netif_wake_queue() - Wake-up the network queue if conditions
+ *	are met.
+ * @netdev: CAN network device.
+ *
+ * If the queue is already awoken, do nothing.
+ *
+ * The conditions to wake up the queue are: a.) The device should be
+ * active (e.g. not in bus off state), b.) The network device must be
+ * up, c.) The echo_skb must have enough free slots for a bulk sent
+ * (c.f. es58x_is_echo_skb_threshold_reached()), d.) Enough idle URBs
+ * should be available.
+ */
+static void es58x_netif_wake_queue(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	unsigned long flags;
+
+	if (!netif_queue_stopped(netdev))
+		return;
+
+	if (!es58x_is_can_state_active(netdev))
+		return;
+
+	if (netif_running(netdev) &&
+	    !es58x_is_echo_skb_threshold_reached(priv)) {
+		/* Confirm that we have at least one idle URB per CAN
+		 * network device. Otherwise, we might run into race
+		 * conditions in the function es58x_start_xmit() which
+		 * would force us to return NETDEV_TX_BUSY.
+		 */
+		spin_lock_irqsave(&es58x_dev->tx_urbs_idle.lock, flags);
+		if (atomic_read(&es58x_dev->tx_urbs_idle_cnt) >=
+		    es58x_dev->num_can_ch)
+			netif_wake_queue(netdev);
+		spin_unlock_irqrestore(&es58x_dev->tx_urbs_idle.lock, flags);
+	}
+}
+
+/**
+ * es58x_netif_wake_all_queues() - Wake-up all the network queues if
+ *	conditions are met.
+ * @es58x_dev: ES58X device.
+ *
+ * Try to wake-up all the queues associated with a ES58X device. This
+ * function should be used when idle URB resources become available.
+ */
+static void es58x_netif_wake_all_queues(struct es58x_device *es58x_dev)
+{
+	int i;
+
+	for (i = 0; i < es58x_dev->num_can_ch; i++)
+		es58x_netif_wake_queue(es58x_dev->netdev[i]);
+}
+
+/**
+ * es58x_netif_stop_all_queues() - Unconditionally stop all the
+ *	network queues.
+ * @es58x_dev: ES58X device.
+ *
+ * Stop all the queues associated with a ES58X device. This
+ * function should be used when idle URB resources become unavailable.
+ */
+static void es58x_netif_stop_all_queues(struct es58x_device *es58x_dev)
+{
+	int i;
+
+	for (i = 0; i < es58x_dev->num_can_ch; i++)
+		if (es58x_dev->netdev[i])
+			netif_stop_queue(es58x_dev->netdev[i]);
+}
+
+/**
+ * es58x_can_free_echo_skb_tail() - Remove the oldest echo skb of the
+ *	loopback FIFO.
+ * @netdev: CAN network device.
+ *
+ * Naming convention: the tail is the beginning of the FIFO, i.e. the
+ * first skb to have entered the FIFO.
+ */
+static void es58x_can_free_echo_skb_tail(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	u16 fifo_mask = priv->es58x_dev->param->fifo_mask;
+	struct sk_buff *skb = priv->can.echo_skb[priv->tx_tail & fifo_mask];
+
+	netdev_completed_queue(netdev, 1, can_skb_prv(skb)->frame_len);
+	can_free_echo_skb(netdev, priv->tx_tail & fifo_mask);
+
+	priv->tx_tail++;
+
+	netdev->stats.tx_dropped++;
+}
+
+/**
+ * es58x_can_get_echo_skb_recovery() - Try to re-sync the loopback FIFO.
+ * @netdev: CAN network device.
+ * @rcv_packet_idx: Index
+ *
+ * This function should not be called under normal circumstances. In
+ * the unlikely case that one or several URB packages get dropped by
+ * the device, the index will get out of sync. Try to recover by
+ * dropping the echo skb packets with older indexes.
+ *
+ * Return: zero if recovery was successful, -EINVAL otherwise.
+ */
+static int es58x_can_get_echo_skb_recovery(struct net_device *netdev,
+					   u32 rcv_packet_idx)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	int ret = 0;
+
+	netdev->stats.tx_errors++;
+
+	if (net_ratelimit())
+		netdev_warn(netdev,
+			    "Bad loopback packet index: %u. First index: %u, end index %u, num_echo_skb: %02u/%02u\n",
+			    rcv_packet_idx, priv->tx_tail, priv->tx_head,
+			    priv->tx_head - priv->tx_tail,
+			    priv->can.echo_skb_max);
+
+	if (rcv_packet_idx < priv->tx_tail) {
+		if (net_ratelimit())
+			netdev_warn(netdev,
+				    "Received loopback is from the past. Ignoring it\n");
+		ret = -EINVAL;
+	} else if ((s32)(rcv_packet_idx - priv->tx_head) >= 0LL) {
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "Received loopback is from the future. Ignoring it\n");
+		ret = -EINVAL;
+	} else {
+		if (net_ratelimit())
+			netdev_warn(netdev,
+				    "Loopback recovery: dropping %u echo skb from index %u to %u\n",
+				    rcv_packet_idx - priv->tx_tail,
+				    priv->tx_tail, rcv_packet_idx - 1);
+		while (priv->tx_tail != rcv_packet_idx) {
+			if (priv->tx_tail == priv->tx_head)
+				return -EINVAL;
+			es58x_can_free_echo_skb_tail(netdev);
+		}
+	}
+	return ret;
+}
+
+/**
+ * es58x_can_get_echo_skb() - Get the skb from the loopback FIFO and
+ *	loop it back locally.
+ * @netdev: CAN network device.
+ * @rcv_packet_idx: Index of the first packet received from the device.
+ * @tstamps: Array of hardware timestamps received from a ES58X device.
+ * @pkts: Number of packets (and so, length of @tstamps).
+ *
+ * Callback function for when we receive a self reception acknowledgment.
+ * Retrieves the skb from the loopback FIFO, sets its hardware timestamp
+ * (the actual time it was sent) and loops it back locally.
+ *
+ * The device has to be active (i.e. network interface UP and not in
+ * bus off state or restarting).
+ *
+ * Packet indexes must be consecutive (i.e. index of first packet is
+ * @rcv_packet_idx, index of second packet is @rcv_packet_idx + 1 and
+ * index of last packet is @rcv_packet_idx + @pkts - 1).
+ *
+ * Return: zero on success.
+ */
+int es58x_can_get_echo_skb(struct net_device *netdev, u32 rcv_packet_idx,
+			   u64 *tstamps, unsigned int pkts)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	unsigned int rx_total_frame_len = 0;
+	unsigned int num_echo_skb = priv->tx_head - priv->tx_tail;
+	int i;
+	int ret = 0;
+	u16 fifo_mask = priv->es58x_dev->param->fifo_mask;
+
+	if (!netif_running(netdev)) {
+		if (net_ratelimit())
+			netdev_info(netdev,
+				    "%s: %s is down, dropping %d loopback packets\n",
+				    __func__, netdev->name, pkts);
+		netdev->stats.tx_dropped++;
+		return 0;
+	} else if (!es58x_is_can_state_active(netdev)) {
+		if (net_ratelimit())
+			netdev_dbg(netdev,
+				   "Bus is off or device is restarting. Ignoring %u loopback packets from index %u\n",
+				   pkts, rcv_packet_idx);
+		/* stats.tx_dropped will be (or was already)
+		 * incremented by
+		 * drivers/net/can/net/dev.c:can_flush_echo_skb().
+		 */
+		return 0;
+	} else if (num_echo_skb == 0) {
+		if (net_ratelimit())
+			netdev_warn(netdev,
+				    "Received %u loopback packets from index: %u but echo skb queue is empty.\n",
+				    pkts, rcv_packet_idx);
+		netdev->stats.tx_dropped += pkts;
+		return 0;
+	}
+
+	if (priv->tx_tail != rcv_packet_idx) {
+		ret = es58x_can_get_echo_skb_recovery(netdev, rcv_packet_idx);
+		if (ret < 0) {
+			if (net_ratelimit())
+				netdev_warn(netdev,
+					    "Could not find echo skb for loopback packet index: %u\n",
+					    rcv_packet_idx);
+			return 0;
+		}
+	}
+	if (num_echo_skb < pkts) {
+		int pkts_drop = pkts - num_echo_skb;
+
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "Received %u loopback packets but have only %d echo skb. Dropping %d echo skb\n",
+				   pkts, num_echo_skb, pkts_drop);
+		netdev->stats.tx_dropped += pkts_drop;
+		pkts -= pkts_drop;
+	}
+
+	for (i = 0; i < pkts; i++) {
+		unsigned int skb_idx = priv->tx_tail & fifo_mask;
+		struct sk_buff *skb = priv->can.echo_skb[skb_idx];
+		unsigned int frame_len = 0;
+
+		if (skb)
+			es58x_set_skb_timestamp(netdev, skb, tstamps[i]);
+
+		netdev->stats.tx_bytes += can_get_echo_skb(netdev, skb_idx,
+							   &frame_len);
+		rx_total_frame_len += frame_len;
+
+		priv->tx_tail++;
+	}
+
+	netdev_completed_queue(netdev, pkts, rx_total_frame_len);
+	netdev->stats.tx_packets += pkts;
+
+	priv->err_passive_before_rtx_success = 0;
+	es58x_netif_wake_queue(netdev);
+
+	return ret;
+}
+
+/**
+ * es58x_can_flush_echo_skb() - Reset the loopback FIFO.
+ * @netdev: CAN network device.
+ *
+ * The echo_skb array of struct can_priv will be flushed by
+ * drivers/net/can/dev.c:can_flush_echo_skb(). This function resets
+ * the parameters of the struct es58x_priv of our device and reset the
+ * queue (c.f. BQL).
+ */
+static void es58x_can_flush_echo_skb(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+
+	priv->tx_tail = 0;
+	priv->tx_head = 0;
+	netdev_reset_queue(netdev);
+}
+
+/**
+ * es58x_flush_pending_tx_msg() - Reset the buffer for transmission messages.
+ * @netdev: CAN network device.
+ *
+ * es58x_start_xmit() will queue up to tx_bulk_max messages in
+ * &tx_urb buffer and do a bulk send of all messages in one single URB
+ * (c.f. xmit_more flag). When the device recovers from a bus off
+ * state or when the device stops, the tx_urb buffer might still have
+ * pending messages in it and thus need to be flushed.
+ */
+static void es58x_flush_pending_tx_msg(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	int i;
+	u16 fifo_mask = priv->es58x_dev->param->fifo_mask;
+
+	if (priv->tx_urb) {
+		netdev_warn(netdev,
+			    "%s: dropping %d tx_msg that were pending for transmission\n",
+			    __func__, priv->tx_can_msg_cnt);
+		netdev->stats.tx_dropped += priv->tx_can_msg_cnt;
+		for (i = priv->tx_head;
+		     i < priv->tx_head + priv->tx_can_msg_cnt; i++)
+			can_free_echo_skb(netdev, i & fifo_mask);
+
+		usb_anchor_urb(priv->tx_urb, &priv->es58x_dev->tx_urbs_idle);
+		atomic_inc(&es58x_dev->tx_urbs_idle_cnt);
+		usb_free_urb(priv->tx_urb);
+	}
+	priv->tx_urb = NULL;
+}
+
+/**
+ * es58x_tx_ack_msg() - Handle acknowledgment messages.
+ * @netdev: CAN network device.
+ * @tx_free_entries: Number of free entries in the device transmit FIFO.
+ * @rx_cmd_ret_u32: error code as returned by the ES58X device.
+ *
+ * ES58X sends an acknowledgment message after a transmission request
+ * is done. This is mandatory for the ES581.4 but is optional (and
+ * deactivated in this driver) for the ES58X_FD family.
+ *
+ * Under normal circumstances, this function should never throw an
+ * error message.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+int es58x_tx_ack_msg(struct net_device *netdev, u16 tx_free_entries,
+		     enum es58x_ret_u32 rx_cmd_ret_u32)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+
+	if (tx_free_entries <= priv->es58x_dev->param->tx_bulk_max) {
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "Only %d entries remaining in device queue, num_echo_skb: %d/%d\n",
+				   tx_free_entries,
+				   priv->tx_head - priv->tx_tail,
+				   priv->can.echo_skb_max);
+		netif_stop_queue(netdev);
+	}
+
+	return es58x_rx_cmd_ret_u32(netdev, ES58X_RET_TYPE_TX_MSG,
+				    rx_cmd_ret_u32);
+}
+
+/**
+ * es58x_rx_can_msg() - Handle a received a CAN message.
+ * @netdev: CAN network device.
+ * @timestamp: Hardware time stamp (only relevant in rx branches).
+ * @data: CAN payload.
+ * @can_id: CAN ID.
+ * @es58x_flags: Please refer to enum es58x_flag.
+ * @dlc: Data Length Code (raw value).
+ *
+ * Fill up a CAN skb and post it.
+ *
+ * This function handles the case where the DLC of a classical CAN
+ * frame is greater than CAN_MAX_DLEN (c.f. the len8_dlc field of
+ * struct can_frame).
+ *
+ * Return: zero on success.
+ */
+int es58x_rx_can_msg(struct net_device *netdev, u64 timestamp, const u8 *data,
+		     canid_t can_id, enum es58x_flag es58x_flags, u8 dlc)
+{
+	struct canfd_frame *cfd;
+	struct can_frame *ccf;
+	struct sk_buff *skb;
+	u8 len;
+	bool is_can_fd = !!(es58x_flags & ES58X_FLAG_FD_DATA);
+
+	if (dlc > CAN_MAX_RAW_DLC) {
+		netdev_err(netdev,
+			   "%s: DLC is %d but maximum should be %d\n",
+			   __func__, dlc, CAN_MAX_RAW_DLC);
+		return -EMSGSIZE;
+	}
+
+	if (is_can_fd) {
+		len = can_fd_dlc2len(dlc);
+		skb = alloc_canfd_skb(netdev, &cfd);
+	} else {
+		len = can_cc_dlc2len(dlc);
+		skb = alloc_can_skb(netdev, &ccf);
+		cfd = (struct canfd_frame *)ccf;
+	}
+
+	if (!skb) {
+		netdev->stats.rx_dropped++;
+		return -ENOMEM;
+	}
+	cfd->can_id = can_id;
+	if (es58x_flags & ES58X_FLAG_EFF)
+		cfd->can_id |= CAN_EFF_FLAG;
+	if (is_can_fd) {
+		cfd->len = len;
+		if (es58x_flags & ES58X_FLAG_FD_BRS)
+			cfd->flags |= CANFD_BRS;
+		if (es58x_flags & ES58X_FLAG_FD_ESI)
+			cfd->flags |= CANFD_ESI;
+	} else {
+		can_frame_set_cc_len(ccf, dlc, es58x_priv(netdev)->can.ctrlmode);
+		if (es58x_flags & ES58X_FLAG_RTR) {
+			ccf->can_id |= CAN_RTR_FLAG;
+			len = 0;
+		}
+	}
+	memcpy(cfd->data, data, len);
+	netdev->stats.rx_packets++;
+	netdev->stats.rx_bytes += len;
+
+	es58x_set_skb_timestamp(netdev, skb, timestamp);
+	netif_rx(skb);
+
+	es58x_priv(netdev)->err_passive_before_rtx_success = 0;
+
+	return 0;
+}
+
+/**
+ * es58x_rx_err_msg() - Handle a received CAN event or error message.
+ * @netdev: CAN network device.
+ * @error: Error code.
+ * @event: Event code.
+ * @timestamp: Timestamp received from a ES58X device.
+ *
+ * Handle the errors and events received by the ES58X device, create
+ * a CAN error skb and post it.
+ *
+ * In some rare cases the devices might get stucked alternating between
+ * CAN_STATE_ERROR_PASSIVE and CAN_STATE_ERROR_WARNING. To prevent
+ * this behavior, we force a bus off state if the device goes in
+ * CAN_STATE_ERROR_WARNING for ES58X_MAX_CONSECUTIVE_WARN consecutive
+ * times with no successful transmission or reception in between.
+ *
+ * Once the device is in bus off state, the only way to restart it is
+ * through the drivers/net/can/dev.c:can_restart() function. The
+ * device is technically capable to recover by itself under certain
+ * circumstances, however, allowing self recovery would create
+ * complex race conditions with drivers/net/can/dev.c:can_restart()
+ * and thus was not implemented. To activate automatic restart, please
+ * set the restart-ms parameter (e.g. ip link set can0 type can
+ * restart-ms 100).
+ *
+ * If the bus is really instable, this function would try to send a
+ * lot of log messages. Those are rate limited (i.e. you will see
+ * messages such as "net_ratelimit: XXX callbacks suppressed" in
+ * dmesg).
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
+		     enum es58x_event event, u64 timestamp)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	struct can_priv *can = netdev_priv(netdev);
+	struct can_device_stats *can_stats = &can->can_stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	if (!netif_running(netdev)) {
+		if (net_ratelimit())
+			netdev_info(netdev, "%s: %s is down, dropping packet\n",
+				    __func__, netdev->name);
+		netdev->stats.rx_dropped++;
+		return 0;
+	}
+
+	if (error == ES58X_ERR_OK && event == ES58X_EVENT_OK) {
+		netdev_err(netdev, "%s: Both error and event are zero\n",
+			   __func__);
+		return -EINVAL;
+	}
+
+	skb = alloc_can_err_skb(netdev, &cf);
+	if (!skb)
+		return -ENOMEM;
+
+	switch (error) {
+	case ES58X_ERR_OK:	/* 0: No error */
+		break;
+
+	case ES58X_ERR_PROT_STUFF:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error BITSUFF\n");
+		cf->data[2] |= CAN_ERR_PROT_STUFF;
+		break;
+
+	case ES58X_ERR_PROT_FORM:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error FORMAT\n");
+		cf->data[2] |= CAN_ERR_PROT_FORM;
+		break;
+
+	case ES58X_ERR_ACK:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error ACK\n");
+		cf->can_id |= CAN_ERR_ACK;
+		break;
+
+	case ES58X_ERR_PROT_BIT:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error BIT\n");
+		cf->data[2] |= CAN_ERR_PROT_BIT;
+		break;
+
+	case ES58X_ERR_PROT_CRC:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error CRC\n");
+		cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
+		break;
+
+	case ES58X_ERR_PROT_BIT1:
+		if (net_ratelimit())
+			netdev_dbg(netdev,
+				   "Error: expected a recessive bit but monitored a dominant one\n");
+		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		break;
+
+	case ES58X_ERR_PROT_BIT0:
+		if (net_ratelimit())
+			netdev_dbg(netdev,
+				   "Error expected a dominant bit but monitored a recessive one\n");
+		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		break;
+
+	case ES58X_ERR_PROT_OVERLOAD:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Error OVERLOAD\n");
+		cf->data[2] |= CAN_ERR_PROT_OVERLOAD;
+		break;
+
+	case ES58X_ERR_PROT_UNSPEC:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Unspecified error\n");
+		cf->can_id |= CAN_ERR_PROT;
+		break;
+
+	default:
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "%s: Unspecified error code 0x%04X\n",
+				   __func__, (int)error);
+		cf->can_id |= CAN_ERR_PROT;
+		break;
+	}
+
+	switch (event) {
+	case ES58X_EVENT_OK:	/* 0: No event */
+		break;
+
+	case ES58X_EVENT_CRTL_ACTIVE:
+		if (can->state == CAN_STATE_BUS_OFF) {
+			netdev_err(netdev,
+				   "%s: state transition: BUS OFF -> ACTIVE\n",
+				   __func__);
+		}
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Event CAN BUS ACTIVE\n");
+		cf->data[1] |= CAN_ERR_CRTL_ACTIVE;
+		can->state = CAN_STATE_ERROR_ACTIVE;
+		break;
+
+	case ES58X_EVENT_CRTL_PASSIVE:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Event CAN BUS PASSIVE\n");
+		/* Either TX or RX error count reached passive state
+		 * but we do not know which. Setting both flags by
+		 * default.
+		 */
+		cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
+		cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
+		if (can->state < CAN_STATE_BUS_OFF)
+			can->state = CAN_STATE_ERROR_PASSIVE;
+		can_stats->error_passive++;
+		if (priv->err_passive_before_rtx_success < U8_MAX)
+			priv->err_passive_before_rtx_success++;
+		break;
+
+	case ES58X_EVENT_CRTL_WARNING:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Event CAN BUS WARNING\n");
+		/* Either TX or RX error count reached warning state
+		 * but we do not know which. Setting both flags by
+		 * default.
+		 */
+		cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
+		cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
+		if (can->state < CAN_STATE_BUS_OFF)
+			can->state = CAN_STATE_ERROR_WARNING;
+		can_stats->error_warning++;
+		break;
+
+	case ES58X_EVENT_BUSOFF:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "Event CAN BUS OFF\n");
+		/* Prevent the network device queue for being woke-up
+		 * by another interrupt while we set the bus to off
+		 * status.
+		 */
+		spin_lock_irqsave(&es58x_dev->tx_urbs_idle.lock, flags);
+		netif_stop_queue(netdev);
+		if (can->state != CAN_STATE_BUS_OFF) {
+			can->state = CAN_STATE_BUS_OFF;
+			can_bus_off(netdev);
+		}
+		spin_unlock_irqrestore(&es58x_dev->tx_urbs_idle.lock, flags);
+		cf->can_id |= CAN_ERR_BUSOFF;
+		can_stats->bus_off++;
+		break;
+
+	case ES58X_EVENT_SINGLE_WIRE:
+		if (net_ratelimit())
+			netdev_warn(netdev,
+				    "Lost connection on either CAN high or CAN low\n");
+		/* Lost connection on either CAN high or CAN
+		 * low. Setting both flags by default.
+		 */
+		cf->data[4] |= CAN_ERR_TRX_CANH_NO_WIRE;
+		cf->data[4] |= CAN_ERR_TRX_CANL_NO_WIRE;
+		break;
+
+	default:
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "%s: Unspecified event code 0x%04X\n",
+				   __func__, (int)event);
+		cf->can_id |= CAN_ERR_CRTL;
+		break;
+	}
+
+	if (cf->data[1])
+		cf->can_id |= CAN_ERR_CRTL;
+	if (cf->data[2] || cf->data[3]) {
+		cf->can_id |= CAN_ERR_PROT;
+		can_stats->bus_error++;
+	}
+	if (cf->data[4])
+		cf->can_id |= CAN_ERR_TRX;
+
+	/* driver/net/can/dev.c:can_restart() takes in account error
+	 * messages in the RX stats. Doing same here for
+	 * consistency.
+	 */
+	netdev->stats.rx_packets++;
+	netdev->stats.rx_bytes += cf->can_dlc;
+
+	es58x_set_skb_timestamp(netdev, skb, timestamp);
+	netif_rx(skb);
+
+	if ((event & ES58X_EVENT_CRTL_PASSIVE) &&
+	    priv->err_passive_before_rtx_success ==
+	    ES58X_CONSECUTIVE_ERR_PASSIVE_MAX) {
+		netdev_info(netdev,
+			    "Got %d consecutive warning events with no successful rx or tx. Forcing bus-off\n",
+			    priv->err_passive_before_rtx_success);
+		return es58x_rx_err_msg(netdev, ES58X_ERR_OK,
+					ES58X_EVENT_BUSOFF, timestamp);
+	}
+
+	return 0;
+}
+
+/* Human readable description of the &enum es58x_cmd_ret_type. */
+static const char *const es58x_cmd_ret_desc[] = {
+	"Set bittiming",
+	"Enable channel",
+	"Disable channel",
+	"Transmit message",
+	"Reset rx",
+	"Reset tx",
+	"Device error"
+};
+
+/**
+ * es58x_rx_dev_ret_u8() - Handle return codes received from the
+ *	ES58X device.
+ * @dev: Device, only used for the dev_XXX() print functions.
+ * @cmd_ret_type: Type of the command which triggered the return code.
+ * @rx_dev_ret_u8: error code as returned by the ES58X device.
+ *
+ * Handles the 8 bits return code. Those are specific to the ES581.4
+ * device. The return value will eventually be used by
+ * es58x_handle_urb_cmd() function which will take proper actions in
+ * case of critical issues such and memory errors or bad CRC values.
+ *
+ * In contrast with es58x_rx_cmd_ret_u32(), the network device is
+ * unknown.
+ *
+ * Return: zero on success, return errno when any error occurs.
+ */
+int es58x_rx_dev_ret_u8(struct device *dev,
+			enum es58x_ret_type cmd_ret_type,
+			enum es58x_ret_u8 rx_dev_ret_u8)
+{
+	const char *ret_desc = es58x_cmd_ret_desc[cmd_ret_type];
+
+	compiletime_assert(ARRAY_SIZE(es58x_cmd_ret_desc) ==
+			   ES58X_RET_TYPE_NUM_ENTRIES,
+			   "Size mismatch between es58x_cmd_ret_desc and enum es58x_cmd_ret_type");
+
+	switch (rx_dev_ret_u8) {
+	case ES58X_RET_U8_OK:
+		dev_dbg_ratelimited(dev, "%s: OK\n", ret_desc);
+		break;
+
+	case ES58X_RET_U8_ERR_UNSPECIFIED_FAILURE:
+		dev_err(dev, "%s: unspecified failure\n", ret_desc);
+		break;
+
+	case ES58X_RET_U8_ERR_NO_MEM:
+		dev_err(dev, "%s: device ran out of memory\n", ret_desc);
+		return -ENOMEM;
+
+	case ES58X_RET_U8_ERR_BAD_CRC:
+		dev_err(dev, "%s: CRC of previous command is incorrect\n",
+			ret_desc);
+		return -EIO;
+
+	default:
+		dev_err(dev, "%s: returned unknown value: 0x%02X\n",
+			ret_desc, rx_dev_ret_u8);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * es58x_rx_dev_ret_u32() - Handle return codes received from the
+ *	ES58X device.
+ * @netdev: CAN network device.
+ * @cmd_ret_type: Type of the command which triggered the return code.
+ * @rx_cmd_ret_u32: error code as returned by the ES58X device.
+ *
+ * Handles the 32 bits return code. The return value will eventually
+ * be used by es58x_handle_urb_cmd() function which will take proper
+ * actions in case of critical issues such and memory errors or bad
+ * CRC values.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+int es58x_rx_cmd_ret_u32(struct net_device *netdev,
+			 enum es58x_ret_type cmd_ret_type,
+			 enum es58x_ret_u32 rx_cmd_ret_u32)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	const char *ret_desc = es58x_cmd_ret_desc[cmd_ret_type];
+
+	switch (rx_cmd_ret_u32) {
+	case ES58X_RET_U32_OK:
+		switch (cmd_ret_type) {
+		case ES58X_RET_TYPE_ENABLE_CHANNEL:
+			es58x_flush_pending_tx_msg(netdev);
+			es58x_can_flush_echo_skb(netdev);
+			priv->err_passive_before_rtx_success = 0;
+			priv->can.state = CAN_STATE_ERROR_ACTIVE;
+			es58x_netif_wake_queue(netdev);
+			netdev_info(netdev,
+				    "%s (Serial Number %s): CAN%d channel becomes ready\n",
+				    priv->es58x_dev->udev->product,
+				    priv->es58x_dev->udev->serial,
+				    priv->channel_idx + 1);
+			break;
+
+		case ES58X_RET_TYPE_TX_MSG:
+#ifdef VERBOSE_DEBUG
+			if (net_ratelimit())
+				netdev_vdbg(netdev, "%s: OK\n", ret_desc);
+#endif
+			break;
+
+		default:
+			netdev_dbg(netdev, "%s: OK\n", ret_desc);
+			break;
+		}
+		break;
+
+	case ES58X_RET_U32_ERR_UNSPECIFIED_FAILURE:
+		if (cmd_ret_type == ES58X_RET_TYPE_DISABLE_CHANNEL)
+			netdev_dbg(netdev,
+				   "%s: channel is already closed\n", ret_desc);
+		else
+			netdev_err(netdev,
+				   "%s: unspecified failure\n", ret_desc);
+		break;
+
+	case ES58X_RET_U32_ERR_NO_MEM:
+		netdev_err(netdev, "%s: device ran out of memory\n", ret_desc);
+		return -ENOMEM;
+
+	case ES58X_RET_U32_WARN_PARAM_ADJUSTED:
+		netdev_warn(netdev,
+			    "%s: some incompatible parameters have been adjusted\n",
+			    ret_desc);
+		break;
+
+	case ES58X_RET_U32_WARN_TX_MAYBE_REORDER:
+		netdev_warn(netdev,
+			    "%s: TX messages might have been reordered\n",
+			    ret_desc);
+		break;
+
+	case ES58X_RET_U32_ERR_TIMEOUT:
+		netdev_err(netdev, "%s: command timed out\n", ret_desc);
+		break;
+
+	case ES58X_RET_U32_ERR_FIFO_FULL:
+		netdev_warn(netdev, "%s: fifo is full\n", ret_desc);
+		break;
+
+	case ES58X_RET_U32_ERR_BAD_CONFIG:
+		netdev_err(netdev, "%s: bad configuration\n", ret_desc);
+		return -EINVAL;
+
+	case ES58X_RET_U32_ERR_NO_RESOURCE:
+		netdev_err(netdev, "%s: no resource available\n", ret_desc);
+		break;
+
+	default:
+		netdev_err(netdev, "%s returned unknown value: 0x%08X\n",
+			   ret_desc, rx_cmd_ret_u32);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * es58x_increment_rx_errors() - Increment the network devices' error
+ *	count.
+ * @es58x_dev: ES58X device.
+ *
+ * If an error occurs on the early stages on receiving an URB command,
+ * we might not be able to figure out on which network device the
+ * error occurred. In such case, we arbitrarily increment the error
+ * count of all the network devices attached to our ES58X device.
+ */
+static void es58x_increment_rx_errors(struct es58x_device *es58x_dev)
+{
+	int i;
+
+	for (i = 0; i < es58x_dev->num_can_ch; i++)
+		if (es58x_dev->netdev[i])
+			es58x_dev->netdev[i]->stats.rx_errors++;
+}
+
+/**
+ * es58x_handle_urb_cmd() - Handle the URB command
+ * @es58x_dev: ES58X device.
+ * @urb_cmd: The URB command received from the ES58X device, might not
+ *	be aligned.
+ *
+ * Sends the URB command to the device specific function. Manages the
+ * errors throwed back by those functions.
+ */
+static void es58x_handle_urb_cmd(struct es58x_device *es58x_dev,
+				 const union es58x_urb_cmd *urb_cmd)
+{
+	const struct es58x_operators *ops = es58x_dev->ops;
+	size_t cmd_len;
+	int i, ret;
+
+	ret = ops->handle_urb_cmd(es58x_dev, urb_cmd);
+	switch (ret) {
+	case 0:		/* OK */
+		return;
+
+	case -ENODEV:
+		dev_err_ratelimited(es58x_dev->dev, "Device is not ready\n");
+		break;
+
+	case -EINVAL:
+	case -EMSGSIZE:
+	case -EBADRQC:
+	case -EBADMSG:
+	case -ECHRNG:
+		cmd_len = es58x_get_urb_cmd_len(es58x_dev,
+						ops->get_msg_len(urb_cmd));
+		dev_err(es58x_dev->dev,
+			"ops->handle_urb_cmd() returned error %pe",
+			ERR_PTR(ret));
+		es58x_print_hex_dump(urb_cmd, cmd_len);
+		break;
+
+	case -EFAULT:
+	case -ENOMEM:
+	case -EIO:
+	default:
+		dev_crit(es58x_dev->dev,
+			 "ops->handle_urb_cmd() returned error %pe, detaching all network devices\n",
+			 ERR_PTR(ret));
+		for (i = 0; i < es58x_dev->num_can_ch; i++)
+			if (es58x_dev->netdev[i])
+				netif_device_detach(es58x_dev->netdev[i]);
+		break;
+	}
+
+	/* Because the urb command could not fully be parsed,
+	 * channel_id is not confirmed. Incrementing rx_errors count
+	 * of all channels.
+	 */
+	es58x_increment_rx_errors(es58x_dev);
+}
+
+/**
+ * es58x_check_rx_urb() - Check the length and format of the URB command.
+ * @es58x_dev: ES58X device.
+ * @urb_cmd: The URB command received from the ES58X device, might not
+ *	be aligned.
+ * @urb_actual_len: The actual length of the URB command.
+ *
+ * Check if the first message of the received urb is valid, that is to
+ * say that both the header and the length are coherent.
+ *
+ * Return:
+ * the length of the first message of the URB on success.
+ *
+ * -ENODATA if the URB command is incomplete (in which case, the URB
+ * command should be buffered and combined with the next URB to try to
+ * reconstitute the URB command).
+ *
+ * -EOVERFLOW if the length is bigger than the maximum expected one.
+ *
+ * -EBADRQC if the start of frame does not match the expected value.
+ */
+static signed int es58x_check_rx_urb(struct es58x_device *es58x_dev,
+				     const union es58x_urb_cmd *urb_cmd,
+				     u32 urb_actual_len)
+{
+	const struct device *dev = es58x_dev->dev;
+	const struct es58x_parameters *param = es58x_dev->param;
+	u16 sof, msg_len;
+	signed int urb_cmd_len, ret;
+
+	if (urb_actual_len < param->urb_cmd_header_len) {
+		dev_vdbg(dev,
+			 "%s: Received %d bytes [%*ph]: header incomplete\n",
+			 __func__, urb_actual_len, urb_actual_len,
+			 urb_cmd->raw_cmd);
+		return -ENODATA;
+	}
+
+	sof = get_unaligned_le16(&urb_cmd->sof);
+	if (sof != param->rx_start_of_frame) {
+		dev_err_ratelimited(es58x_dev->dev,
+				    "%s: Expected sequence 0x%04X for start of frame but got 0x%04X.\n",
+				    __func__, param->rx_start_of_frame, sof);
+		return -EBADRQC;
+	}
+
+	msg_len = es58x_dev->ops->get_msg_len(urb_cmd);
+	urb_cmd_len = es58x_get_urb_cmd_len(es58x_dev, msg_len);
+	if (urb_cmd_len > param->rx_urb_cmd_max_len) {
+		dev_err_ratelimited(es58x_dev->dev,
+				    "%s: Biggest expected size for rx urb_cmd is %u but receive a command of size %d\n",
+				    __func__,
+				    param->rx_urb_cmd_max_len, urb_cmd_len);
+		return -EOVERFLOW;
+	} else if (urb_actual_len < urb_cmd_len) {
+		dev_vdbg(dev, "%s: Received %02d/%02d bytes\n",
+			 __func__, urb_actual_len, urb_cmd_len);
+		return -ENODATA;
+	}
+
+	ret = es58x_check_crc(es58x_dev, urb_cmd, urb_cmd_len);
+	if (ret)
+		return ret;
+
+	return urb_cmd_len;
+}
+
+/**
+ * es58x_flush_cmd_buf() - Reset the buffer for URB commands.
+ * @es58x_dev: ES58X device.
+ */
+static void es58x_flush_cmd_buf(struct es58x_device *es58x_dev)
+{
+	memset(&es58x_dev->rx_cmd_buf, 0, es58x_dev->param->rx_urb_cmd_max_len);
+	es58x_dev->rx_cmd_buf_len = 0;
+}
+
+/**
+ * es58x_copy_to_cmd_buf() - Copy an array to the URB command buffer.
+ * @es58x_dev: ES58X device.
+ * @raw_cmd: the buffer we want to copy.
+ * @raw_cmd_len: length of @raw_cmd.
+ *
+ * Concatenates @raw_cmd_len bytes of @raw_cmd to the end of the URB
+ * command buffer.
+ *
+ * Return: zero on success, -EMSGSIZE if not enough space is available
+ * to do the copy.
+ */
+static int es58x_copy_to_cmd_buf(struct es58x_device *es58x_dev,
+				 u8 *raw_cmd, int raw_cmd_len)
+{
+	if (es58x_dev->rx_cmd_buf_len + raw_cmd_len >
+	    es58x_dev->param->rx_urb_cmd_max_len)
+		return -EMSGSIZE;
+
+	memcpy(&es58x_dev->rx_cmd_buf.raw_cmd[es58x_dev->rx_cmd_buf_len],
+	       raw_cmd, raw_cmd_len);
+	es58x_dev->rx_cmd_buf_len += raw_cmd_len;
+
+	return 0;
+}
+
+/**
+ * es58x_split_urb_try_recovery() - Try to recover bad URB sequences.
+ * @es58x_dev: ES58X device.
+ * @raw_cmd: pointer to the buffer we want to copy.
+ * @raw_cmd_len: length of @raw_cmd.
+ *
+ * Under some rare conditions, we might get incorrect URBs from the
+ * device. From our observations, one of the valid URB gets replaced
+ * by one from the past. The full root cause is not identified.
+ *
+ * This function looks for the next start of frame in the urb buffer
+ * in order to try to recover.
+ *
+ * Such behavior was not observed on the devices of the ES58X FD
+ * family and only seems to impact the ES581.4.
+ *
+ * Return: the number of bytes dropped on success, -EBADMSG if recovery failed.
+ */
+static int es58x_split_urb_try_recovery(struct es58x_device *es58x_dev,
+					u8 *raw_cmd, size_t raw_cmd_len)
+{
+	union es58x_urb_cmd *urb_cmd;
+	signed int urb_cmd_len;
+	u16 sof;
+	int dropped_bytes = 0;
+
+	es58x_increment_rx_errors(es58x_dev);
+
+	while (raw_cmd_len > sizeof(sof)) {
+		urb_cmd = (union es58x_urb_cmd *)raw_cmd;
+		sof = get_unaligned_le16(&urb_cmd->sof);
+
+		if (sof == es58x_dev->param->rx_start_of_frame) {
+			urb_cmd_len = es58x_check_rx_urb(es58x_dev,
+							 urb_cmd, raw_cmd_len);
+			if ((urb_cmd_len == -ENODATA) || urb_cmd_len > 0) {
+				dev_info_ratelimited(es58x_dev->dev,
+						     "Recovery successful! Dropped %d bytes (urb_cmd_len: %d)\n",
+						     dropped_bytes,
+						     urb_cmd_len);
+				return dropped_bytes;
+			}
+		}
+		raw_cmd++;
+		raw_cmd_len--;
+		dropped_bytes++;
+	}
+
+	dev_warn_ratelimited(es58x_dev->dev, "%s: Recovery failed\n", __func__);
+	return -EBADMSG;
+}
+
+/**
+ * es58x_handle_incomplete_cmd() - Reconstitute an URB command from
+ *	different URB pieces.
+ * @es58x_dev: ES58X device.
+ * @urb: last urb buffer received.
+ *
+ * The device might split the URB commands in an arbitrary amount of
+ * pieces. This function concatenates those in an URB buffer until a
+ * full URB command is reconstituted and consume it.
+ *
+ * Return:
+ * number of bytes consumed from @urb if successful.
+ *
+ * -ENODATA if the URB command is still incomplete.
+ *
+ * -EBADMSG if the URB command is incorrect.
+ */
+static signed int es58x_handle_incomplete_cmd(struct es58x_device *es58x_dev,
+					      struct urb *urb)
+{
+	size_t cpy_len;
+	signed int urb_cmd_len, tmp_cmd_buf_len, ret;
+
+	tmp_cmd_buf_len = es58x_dev->rx_cmd_buf_len;
+	cpy_len = min_t(int, es58x_dev->param->rx_urb_cmd_max_len -
+			es58x_dev->rx_cmd_buf_len, urb->actual_length);
+	ret = es58x_copy_to_cmd_buf(es58x_dev, urb->transfer_buffer, cpy_len);
+	if (ret < 0)
+		return ret;
+
+	urb_cmd_len = es58x_check_rx_urb(es58x_dev, &es58x_dev->rx_cmd_buf,
+					 es58x_dev->rx_cmd_buf_len);
+	if (urb_cmd_len == -ENODATA) {
+		return -ENODATA;
+	} else if (urb_cmd_len < 0) {
+		dev_err_ratelimited(es58x_dev->dev,
+				    "Could not reconstitute incomplete command from previous URB, dropping %d bytes\n",
+				    tmp_cmd_buf_len + urb->actual_length);
+		dev_err_ratelimited(es58x_dev->dev,
+				    "Error code: %pe, es58x_dev->rx_cmd_buf_len: %d, urb->actual_length: %u\n",
+				    ERR_PTR(urb_cmd_len),
+				    tmp_cmd_buf_len, urb->actual_length);
+		es58x_print_hex_dump(&es58x_dev->rx_cmd_buf, tmp_cmd_buf_len);
+		es58x_print_hex_dump(urb->transfer_buffer, urb->actual_length);
+		return urb->actual_length;
+	}
+
+	es58x_handle_urb_cmd(es58x_dev, &es58x_dev->rx_cmd_buf);
+	return urb_cmd_len - tmp_cmd_buf_len;	/* consumed length */
+}
+
+/**
+ * es58x_split_urb() - Cut the received URB in individual URB commands.
+ * @es58x_dev: ES58X device.
+ * @urb: last urb buffer received.
+ *
+ * The device might send urb in bulk format (i.e. several URB commands
+ * concatenated together). This function will split all the commands
+ * contained in the urb.
+ *
+ * Return:
+ * number of bytes consumed from @urb if successful.
+ *
+ * -ENODATA if the URB command is still incomplete.
+ *
+ * -EBADMSG if the URB command is incorrect.
+ */
+static signed int es58x_split_urb(struct es58x_device *es58x_dev,
+				  struct urb *urb)
+{
+	const u8 es58x_is_alive = 0x11;
+	union es58x_urb_cmd *urb_cmd;
+	u8 *raw_cmd = urb->transfer_buffer;
+	ssize_t raw_cmd_len = urb->actual_length;
+	int ret;
+
+	if (es58x_dev->rx_cmd_buf_len != 0) {
+		ret = es58x_handle_incomplete_cmd(es58x_dev, urb);
+		if (ret != -ENODATA)
+			es58x_flush_cmd_buf(es58x_dev);
+		if (ret < 0)
+			return ret;
+
+		raw_cmd += ret;
+		raw_cmd_len -= ret;
+	}
+
+	while (raw_cmd_len > 0) {
+		if (raw_cmd[0] == es58x_is_alive) {
+			raw_cmd++;
+			raw_cmd_len--;
+			continue;
+		}
+		urb_cmd = (union es58x_urb_cmd *)raw_cmd;
+		ret = es58x_check_rx_urb(es58x_dev, urb_cmd, raw_cmd_len);
+		if (ret > 0) {
+			es58x_handle_urb_cmd(es58x_dev, urb_cmd);
+		} else if (ret == -ENODATA) {
+			es58x_copy_to_cmd_buf(es58x_dev, raw_cmd, raw_cmd_len);
+			return -ENODATA;
+		} else if (ret < 0) {
+			ret = es58x_split_urb_try_recovery(es58x_dev, raw_cmd,
+							   raw_cmd_len);
+			if (ret < 0)
+				return ret;
+		}
+		raw_cmd += ret;
+		raw_cmd_len -= ret;
+	}
+
+	return 0;
+}
+
+/**
+ * es58x_read_bulk_callback() - Callback for reading data from device.
+ * @urb: last urb buffer received.
+ *
+ * This function gets eventually called each time an URB is received
+ * from the ES58X device.
+ *
+ * Checks urb status, calls read function and resubmits urb read
+ * operation.
+ */
+static void es58x_read_bulk_callback(struct urb *urb)
+{
+	struct es58x_device *es58x_dev = urb->context;
+	const struct device *dev = es58x_dev->dev;
+	int i, ret;
+
+	switch (urb->status) {
+	case 0:		/* success */
+		break;
+
+	case -EOVERFLOW:
+		dev_err_ratelimited(dev, "%s: error %pe\n",
+				    __func__, ERR_PTR(urb->status));
+		es58x_print_hex_dump_debug(urb->transfer_buffer,
+					   urb->transfer_buffer_length);
+		goto resubmit_urb;
+
+	case -EPROTO:
+		dev_warn_ratelimited(dev, "%s: error %pe. Device unplugged?\n",
+				     __func__, ERR_PTR(urb->status));
+		goto free_urb;
+
+	case -ENOENT:
+	case -EPIPE:
+		dev_err_ratelimited(dev, "%s: error %pe\n",
+				    __func__, ERR_PTR(urb->status));
+		goto free_urb;
+
+	case -ESHUTDOWN:
+		dev_dbg_ratelimited(dev, "%s: error %pe\n",
+				    __func__, ERR_PTR(urb->status));
+		goto free_urb;
+
+	default:
+		dev_err_ratelimited(dev, "%s: error %pe\n",
+				    __func__, ERR_PTR(urb->status));
+		goto resubmit_urb;
+	}
+
+	ret = es58x_split_urb(es58x_dev, urb);
+	if ((ret != -ENODATA) && ret < 0) {
+		dev_err(es58x_dev->dev, "es58x_split_urb() returned error %pe",
+			ERR_PTR(ret));
+		es58x_print_hex_dump_debug(urb->transfer_buffer,
+					   urb->actual_length);
+
+		/* Because the urb command could not be parsed,
+		 * channel_id is not confirmed. Incrementing rx_errors
+		 * count of all channels.
+		 */
+		es58x_increment_rx_errors(es58x_dev);
+	}
+
+ resubmit_urb:
+	usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->rx_pipe,
+			  urb->transfer_buffer, urb->transfer_buffer_length,
+			  es58x_read_bulk_callback, es58x_dev);
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret == -ENODEV) {
+		for (i = 0; i < es58x_dev->num_can_ch; i++)
+			if (es58x_dev->netdev[i])
+				netif_device_detach(es58x_dev->netdev[i]);
+	} else if (ret)
+		dev_err_ratelimited(dev,
+				    "Failed resubmitting read bulk urb: %pe\n",
+				    ERR_PTR(ret));
+	return;
+
+ free_urb:
+	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
+}
+
+/**
+ * es58x_write_bulk_callback() - Callback after writing data to the device.
+ * @urb: urb buffer which was previously submitted.
+ *
+ * This function gets eventually called each time an URB was sent to
+ * the ES58X device.
+ *
+ * Puts the @urb back to the urbs idle anchor and tries to restart the
+ * network queue.
+ */
+static void es58x_write_bulk_callback(struct urb *urb)
+{
+	struct net_device *netdev = urb->context;
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+
+	switch (urb->status) {
+	case 0:		/* success */
+		break;
+
+	case -EOVERFLOW:
+		if (net_ratelimit())
+			netdev_err(netdev, "%s: error %pe\n",
+				   __func__, ERR_PTR(urb->status));
+		es58x_print_hex_dump(urb->transfer_buffer,
+				     urb->transfer_buffer_length);
+		break;
+
+	case -ENOENT:
+		if (net_ratelimit())
+			netdev_dbg(netdev, "%s: error %pe\n",
+				   __func__, ERR_PTR(urb->status));
+		usb_free_coherent(urb->dev,
+				  es58x_dev->param->tx_urb_cmd_max_len,
+				  urb->transfer_buffer, urb->transfer_dma);
+		return;
+
+	default:
+		if (net_ratelimit())
+			netdev_info(netdev, "%s: error %pe\n",
+				    __func__, ERR_PTR(urb->status));
+		break;
+	}
+
+	usb_anchor_urb(urb, &es58x_dev->tx_urbs_idle);
+	/* Wake the queue if it was stopped because of exhaustion of
+	 * urb resources.
+	 */
+	if (atomic_inc_return(&es58x_dev->tx_urbs_idle_cnt) ==
+	    es58x_dev->num_can_ch)
+		es58x_netif_wake_all_queues(es58x_dev);
+}
+
+/**
+ * es58x_alloc_urb() - Allocate memory for an URB and its transfer
+ *	buffer.
+ * @es58x_dev: ES58X device.
+ * @urb: URB to be allocated.
+ * @buf: used to return DMA address of buffer.
+ * @buf_len: requested buffer size.
+ * @mem_flags: affect whether allocation may block.
+ *
+ * Allocates an URB and its @transfer_buffer and set its @transfer_dma
+ * address.
+ *
+ * This function is used at start-up to allocate all of our TX and RX
+ * URBs at once (in order to avoid numerous memory allocations during
+ * run time) and might be used during run time under extremely rare
+ * conditions by @es58x_get_tx_urb() (c.f. comments of this function).
+ *
+ * Return: zero on success, -ENOMEM if no memory is available.
+ */
+static int es58x_alloc_urb(struct es58x_device *es58x_dev, struct urb **urb,
+			   u8 **buf, size_t buf_len, gfp_t mem_flags)
+{
+	*urb = usb_alloc_urb(0, mem_flags);
+	if (!*urb) {
+		dev_err(es58x_dev->dev, "No memory left for URBs\n");
+		return -ENOMEM;
+	}
+
+	*buf = usb_alloc_coherent(es58x_dev->udev, buf_len,
+				  mem_flags, &(*urb)->transfer_dma);
+	if (!*buf) {
+		dev_err(es58x_dev->dev, "No memory left for USB buffer\n");
+		usb_free_urb(*urb);
+		return -ENOMEM;
+	}
+
+	(*urb)->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	return 0;
+}
+
+/**
+ * es58x_get_tx_urb() - Get an URB for transmission.
+ * @netdev: CAN network device.
+ *
+ * Gets an URB from the idle urbs anchor and stop all network devices'
+ * queue if the idle urbs anchor is nearly empty.
+ *
+ * If the URB anchor is empty, allocates an new URB.
+ *
+ * Under normal circumstances, the network device stop/wake
+ * management should prevent any further request for memory
+ * allocations to occur when trying to send a message.
+ *
+ * Yet, new URB memory allocation might occur after a restart from bus
+ * off status when @es58x_set_mode() tries to disable and re-enable
+ * the device. This would only occur if no idle URBs are available at
+ * the moment (which is highly improbable because
+ * @es58x_write_bulk_callback() should have returned the URBs to the
+ * idle urbs anchor by that point).
+ *
+ * Return: a pointer to an URB on success, NULL if no memory is
+ * available.
+ */
+static struct urb *es58x_get_tx_urb(struct net_device *netdev)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	struct urb *urb;
+	unsigned long flags;
+
+	urb = usb_get_from_anchor(&es58x_dev->tx_urbs_idle);
+
+	if (!urb) {
+		size_t tx_buf_len;
+		u8 *buf;
+
+		netdev_warn(netdev,
+			    "%s: Idle TX URB anchor is empty. Allocating an extra URB\n",
+			    __func__);
+		tx_buf_len = es58x_dev->param->tx_urb_cmd_max_len;
+		if (es58x_alloc_urb(es58x_dev, &urb, &buf, tx_buf_len,
+				    GFP_ATOMIC))
+			urb = NULL;
+		else
+			usb_fill_bulk_urb(urb, es58x_dev->udev,
+					  es58x_dev->tx_pipe, buf, tx_buf_len,
+					  NULL, NULL);
+	} else {
+		spin_lock_irqsave(&es58x_dev->tx_urbs_idle.lock, flags);
+		if (atomic_dec_return(&es58x_dev->tx_urbs_idle_cnt) <
+		    es58x_dev->num_can_ch)
+			es58x_netif_stop_all_queues(es58x_dev);
+		spin_unlock_irqrestore(&es58x_dev->tx_urbs_idle.lock, flags);
+	}
+
+	return urb;
+}
+
+/**
+ * es58x_submit_urb() - Send data to the device.
+ * @es58x_dev: ES58X device.
+ * @urb: URB to be sent.
+ * @netdev: CAN network device.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_submit_urb(struct es58x_device *es58x_dev, struct urb *urb,
+			    struct net_device *netdev)
+{
+	int ret;
+
+	es58x_set_crc(urb->transfer_buffer, urb->transfer_buffer_length);
+	usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->tx_pipe,
+			  urb->transfer_buffer, urb->transfer_buffer_length,
+			  es58x_write_bulk_callback, netdev);
+	usb_anchor_urb(urb, &es58x_dev->tx_urbs_busy);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret) {
+		netdev_err(netdev, "%s: USB send urb failure: %pe\n",
+			   __func__, ERR_PTR(ret));
+		usb_unanchor_urb(urb);
+		usb_free_coherent(urb->dev,
+				  es58x_dev->param->tx_urb_cmd_max_len,
+				  urb->transfer_buffer, urb->transfer_dma);
+	}
+	usb_free_urb(urb);
+
+	return ret;
+}
+
+/**
+ * es58x_send_msg() - Prepare an URB and submit it.
+ * @es58x_dev: ES58X device.
+ * @cmd_type: Command type.
+ * @cmd_id: Command ID.
+ * @msg: ES58X message to be sent.
+ * @msg_len: Length of @msg.
+ * @channel_idx: Index of the network device.
+ *
+ * Creates an URB command from a given message, sets the header and the
+ * CRC and then submits it.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd_id,
+		   const void *msg, u16 msg_len, int channel_idx)
+{
+	struct net_device *netdev;
+	union es58x_urb_cmd *urb_cmd;
+	struct urb *urb;
+	int urb_cmd_len;
+
+	if (channel_idx == ES58X_CHANNEL_IDX_NA)
+		netdev = es58x_dev->netdev[0];	/* Default to first channel */
+	else
+		netdev = es58x_dev->netdev[channel_idx];
+
+	urb_cmd_len = es58x_get_urb_cmd_len(es58x_dev, msg_len);
+	if (urb_cmd_len > es58x_dev->param->tx_urb_cmd_max_len)
+		return -EOVERFLOW;
+
+	urb = es58x_get_tx_urb(netdev);
+	if (!urb)
+		return -EBUSY;
+
+	urb_cmd = urb->transfer_buffer;
+	es58x_dev->ops->fill_urb_header(urb_cmd, cmd_type, cmd_id,
+					channel_idx, msg_len);
+	memcpy(&urb_cmd->raw_cmd[es58x_dev->param->urb_cmd_header_len],
+	       msg, msg_len);
+	urb->transfer_buffer_length = urb_cmd_len;
+
+	return es58x_submit_urb(es58x_dev, urb, netdev);
+}
+
+/**
+ * es58x_start() - Start USB device.
+ * @es58x_dev: ES58X device.
+ *
+ * Allocate URBs for transmission and reception and put them in their
+ * respective anchors.
+ *
+ * This function took a lot of inspiration from the other drivers in
+ * drivers/net/can/usb.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_start(struct es58x_device *es58x_dev)
+{
+	const struct device *dev = es58x_dev->dev;
+	const struct es58x_parameters *param = es58x_dev->param;
+	size_t rx_buf_len, tx_buf_len;
+	struct urb *urb;
+	u8 *buf;
+	int i;
+	int ret = -EINVAL;
+
+	rx_buf_len = es58x_dev->rx_max_packet_size;
+	dev_dbg(dev, "%s: Allocation %d rx URBs each of size %zu\n", __func__,
+		param->rx_urb_max, rx_buf_len);
+
+	for (i = 0; i < param->rx_urb_max; i++) {
+		ret = es58x_alloc_urb(es58x_dev, &urb, &buf, rx_buf_len,
+				      GFP_KERNEL);
+		if (ret)
+			break;
+
+		usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->rx_pipe,
+				  buf, rx_buf_len, es58x_read_bulk_callback,
+				  es58x_dev);
+		usb_anchor_urb(urb, &es58x_dev->rx_urbs);
+
+		ret = usb_submit_urb(urb, GFP_KERNEL);
+		if (ret) {
+			usb_unanchor_urb(urb);
+			usb_free_coherent(es58x_dev->udev, rx_buf_len,
+					  buf, urb->transfer_dma);
+			usb_free_urb(urb);
+			break;
+		}
+		usb_free_urb(urb);
+	}
+
+	if (i == 0) {
+		dev_err(dev, "%s: Could not setup any rx URBs\n", __func__);
+		return ret;
+	} else if (i < param->rx_urb_max) {
+		dev_warn(dev,
+			 "%s: Could only allocate %d on %d URBs. Rx performance may be slow\n",
+			 __func__, i, param->rx_urb_max);
+	}
+
+	tx_buf_len = es58x_dev->param->tx_urb_cmd_max_len;
+	dev_dbg(dev, "%s: Allocation %d tx URBs each of size %zu\n", __func__,
+		param->tx_urb_max, tx_buf_len);
+
+	for (i = 0; i < param->tx_urb_max; i++) {
+		ret = es58x_alloc_urb(es58x_dev, &urb, &buf, tx_buf_len,
+				      GFP_KERNEL);
+		if (ret)
+			break;
+
+		usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->tx_pipe,
+				  buf, tx_buf_len, NULL, NULL);
+		usb_anchor_urb(urb, &es58x_dev->tx_urbs_idle);
+		usb_free_urb(urb);
+	}
+
+	if (i == 0) {
+		dev_err(dev, "%s: Could not setup any tx URBs\n", __func__);
+		return ret;
+	} else if (i < param->tx_urb_max) {
+		dev_warn(dev,
+			 "%s: Could only allocate %d on %d URBs. Tx performance may be slow\n",
+			 __func__, i, param->tx_urb_max);
+	}
+	atomic_set(&es58x_dev->tx_urbs_idle_cnt, i);
+
+	return ret;
+}
+
+/**
+ * es58x_enable_channel() - Enable the network device.
+ * @netdev: CAN network device.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_enable_channel(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	int ret;
+
+	ret = es58x_dev->ops->enable_channel(priv);
+	if (ret)
+		netdev_err(netdev, "%s: Could not enable the channel: %pe\n",
+			   __func__, ERR_PTR(ret));
+
+	return ret;
+}
+
+/**
+ * es58x_open() - Open and start network device.
+ * @netdev: CAN network device.
+ *
+ * Called when the network transitions to the up state.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_open(struct net_device *netdev)
+{
+	int ret;
+
+	ret = open_candev(netdev);
+	if (ret)
+		return ret;
+
+	ret = es58x_enable_channel(netdev);
+	if (ret)
+		return ret;
+
+	netif_start_queue(netdev);
+
+	return ret;
+}
+
+/**
+ * es58x_stop() - Disable the network device.
+ * @netdev: CAN network device.
+ *
+ * Called when the network transitions to the down state.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_stop(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&es58x_dev->tx_urbs_idle.lock, flags);
+	netif_stop_queue(netdev);
+	priv->can.state = CAN_STATE_STOPPED;
+	spin_unlock_irqrestore(&es58x_dev->tx_urbs_idle.lock, flags);
+	es58x_can_flush_echo_skb(netdev);
+	close_candev(netdev);
+
+	es58x_flush_pending_tx_msg(netdev);
+
+	return 0;
+}
+
+/**
+ * es58x_xmit_commit() - Send the bulk urb.
+ * @netdev: CAN network device.
+ *
+ * Update the loopback FIFO and do a bulk send. This function should
+ * be called only once by bulk transmission.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_xmit_commit(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	int ret;
+
+	if (!es58x_is_can_state_active(netdev)) {
+		netdev_warn(netdev,
+			    "%s: Device turned to %s while preparing to send. Aborting transmission\n",
+			    __func__, can_get_state_str(priv->can.state));
+		return -ENETDOWN;
+	}
+	priv->tx_head += priv->tx_can_msg_cnt;
+	if (es58x_is_echo_skb_threshold_reached(priv))
+		netif_stop_queue(netdev);
+
+	netdev_sent_queue(netdev, priv->tx_total_frame_len);
+	ret = es58x_submit_urb(priv->es58x_dev, priv->tx_urb, netdev);
+	if (ret) {
+		netdev_warn(netdev,
+			    "%s: es58x_submit_urb returned failed: %pe, num_echo_skb = %u\n",
+			    __func__, ERR_PTR(ret),
+			    priv->tx_head - priv->tx_tail);
+		netdev_completed_queue(netdev, priv->tx_can_msg_cnt,
+				       priv->tx_total_frame_len);
+		priv->tx_head -= priv->tx_can_msg_cnt;
+	}
+	priv->tx_urb = NULL;
+
+	return ret;
+}
+
+/**
+ * es58x_xmit_more() - Can we put more packets?
+ * @priv: ES58X private parameters related to the network device.
+ *
+ * Return: true if we can put more, false if it is time to send.
+ */
+static bool es58x_xmit_more(struct es58x_priv *priv)
+{
+	unsigned int free_slots =
+	    priv->can.echo_skb_max - (priv->tx_head - priv->tx_tail);
+
+	return netdev_xmit_more() &&
+		priv->tx_can_msg_cnt < free_slots &&
+		priv->tx_can_msg_cnt < priv->es58x_dev->param->tx_bulk_max;
+}
+
+/**
+ * es58x_start_xmit() - Transmit an skb.
+ * @skb: socket buffer of a CAN message.
+ * @netdev: CAN network device.
+ *
+ * Called when a packet needs to be transmitted.
+ *
+ * This function relies on Byte Queue Limits (BQL). The main benefit
+ * it to increase the throughput by allowing bulk transfers
+ * (c.f. xmit_more flag).
+ *
+ * Queues up to tx_bulk_max messages in &tx_urb buffer and does
+ * a bulk send of all messages in one single URB.
+ *
+ * Return:
+ * NETDEV_TX_OK if we could manage the @skb (either transmit it or
+ * drop it)
+ *
+ * NETDEV_TX_BUSY if the device is busy (this is a bug, the network
+ * device stop/wake management should prevent this return code to
+ * occur).
+ */
+static netdev_tx_t es58x_start_xmit(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	unsigned int packet_idx, frame_len;
+	int ret;
+
+	if (((struct can_frame *)skb->data)->can_id & CAN_ERR_FLAG) {
+		if (net_ratelimit())
+			netdev_info(netdev,
+				    "%s: CAN_ERR_FLAG is set but device can not send error frames. Dropping message\n",
+				    __func__);
+		dev_kfree_skb(skb);
+		if (priv->tx_urb && !es58x_xmit_more(priv)) {
+			ret = es58x_xmit_commit(netdev);
+			if (ret)
+				goto xmit_failure;
+		}
+		return NETDEV_TX_OK;
+	}
+
+	if (!priv->tx_urb) {
+		priv->tx_urb = es58x_get_tx_urb(netdev);
+		if (!priv->tx_urb)
+			return NETDEV_TX_BUSY;
+		memset(priv->tx_urb->transfer_buffer, 0,
+		       es58x_dev->param->tx_urb_cmd_max_len);
+		priv->tx_urb->transfer_buffer_length =
+		    es58x_dev->param->urb_cmd_header_len;
+		priv->tx_total_frame_len = 0;
+		priv->tx_can_msg_cnt = 0;
+		priv->tx_can_msg_is_fd = can_is_canfd_skb(skb);
+	} else if (priv->tx_can_msg_is_fd != can_is_canfd_skb(skb)) {
+		/* Can not do bulk send with mixed CAN and CAN FD frames. */
+		ret = es58x_xmit_commit(netdev);
+		if (ret)
+			goto drop_skb;
+		return es58x_start_xmit(skb, netdev);
+	}
+
+	ret = es58x_dev->ops->tx_can_msg(priv, skb);
+	if (ret)
+		goto drop_skb;
+
+	frame_len = can_skb_get_frame_len(skb);
+	priv->tx_total_frame_len += frame_len;
+	packet_idx = priv->tx_head + priv->tx_can_msg_cnt;
+	ret = can_put_echo_skb(skb, netdev,
+			       packet_idx & es58x_dev->param->fifo_mask,
+			       frame_len);
+	if (ret)
+		goto xmit_failure;
+
+	priv->tx_can_msg_cnt++;
+
+	if (!es58x_xmit_more(priv)) {
+		ret = es58x_xmit_commit(netdev);
+		if (ret)
+			goto xmit_failure;
+	}
+
+	return NETDEV_TX_OK;
+
+ drop_skb:
+	dev_kfree_skb(skb);
+	netdev->stats.tx_dropped++;
+ xmit_failure:
+	netdev->stats.tx_errors++;
+	es58x_flush_pending_tx_msg(netdev);
+	netdev_err(netdev, "%s: send message failure: %pe\n",
+		   __func__, ERR_PTR(ret));
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops es58x_netdev_ops = {
+	.ndo_open = es58x_open,
+	.ndo_stop = es58x_stop,
+	.ndo_start_xmit = es58x_start_xmit
+};
+
+/**
+ * es58x_set_bittiming() - Configure all the nominal bit timing
+ *	parameters.
+ * @netdev: CAN network device.
+ *
+ * Only relevant for ES581.4 (the ES58X FD family sets the bittiming
+ * parameters at the same time as the channel gets enabled).
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_set_bittiming(struct net_device *netdev)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	int ret;
+
+	/* Make sure that channel is closed before sending configuration. */
+	ret = es58x_dev->ops->disable_channel(priv);
+	if (ret)
+		netdev_err(netdev, "%s: Could not disable the channel: %pe\n",
+			   __func__, ERR_PTR(ret));
+	ret = es58x_dev->ops->set_bittiming(priv);
+	if (ret)
+		netdev_err(netdev, "%s: Could not set bittiming: %pe\n",
+			   __func__, ERR_PTR(ret));
+
+	return ret;
+}
+
+/**
+ * es58x_set_data_bittiming() - Configure all the data bit timing parameters.
+ * @netdev: CAN network device.
+ *
+ * Dummy function: ES58X FD family sets the bittiming
+ * parameters at the same time as the channel gets enabled.
+ *
+ * Return: zero.
+ */
+static int es58x_set_data_bittiming(struct net_device *netdev)
+{
+	return 0;
+}
+
+/**
+ * es58x_reset() - Reset one channel of the device.
+ * @netdev: CAN network device.
+ *
+ * Race conditions might appear when trying to use the reset_rx()
+ * and reset_tx() methods (e.g. loopback packets might remain in the
+ * queue causing some use after free issues in
+ * es58x_can_get_echo_skb()). Disabling and reenabling the channel is
+ * safer.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_reset(struct net_device *netdev)
+{
+	int ret = 0;
+
+	if (es58x_is_can_state_active(netdev))
+		es58x_priv(netdev)->can.do_set_mode(netdev, CAN_MODE_STOP);
+
+	ret = es58x_set_bittiming(netdev);
+	if (ret)
+		goto failure;
+	ret = es58x_enable_channel(netdev);
+	if (ret)
+		goto failure;
+
+	return ret;
+
+ failure:
+	netdev_err(netdev, "%s: reset failure: %pe\n", __func__, ERR_PTR(ret));
+	return ret;
+}
+
+/**
+ * es58x_set_mode() - Change network device mode.
+ * @netdev: CAN network device.
+ * @mode: either %CAN_MODE_START, %CAN_MODE_STOP or %CAN_MODE_SLEEP
+ *
+ * This function is used by drivers/net/can/dev.c:can_restart() to
+ * recover from a bus off state. Thus only the only value expected for
+ * @mode is %CAN_MODE_START. None the less, other modes were
+ * implemented as well.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_set_mode(struct net_device *netdev, enum can_mode mode)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	struct can_priv *can = netdev_priv(netdev);
+	unsigned long flags;
+
+	switch (mode) {
+	case CAN_MODE_START:
+		switch (can->state) {
+		case CAN_STATE_BUS_OFF:
+			return es58x_reset(netdev);
+
+		case CAN_STATE_STOPPED:
+		case CAN_STATE_SLEEPING:
+			es58x_netif_wake_queue(netdev);
+			can->state = CAN_STATE_ERROR_ACTIVE;
+			return 0;
+
+		case CAN_STATE_ERROR_ACTIVE:
+		case CAN_STATE_ERROR_WARNING:
+		case CAN_STATE_ERROR_PASSIVE:
+		default:
+			return 0;
+		}
+
+	case CAN_MODE_STOP:
+	case CAN_MODE_SLEEP:
+		spin_lock_irqsave(&es58x_dev->tx_urbs_idle.lock, flags);
+		netif_stop_queue(netdev);
+		can->state = (mode == CAN_MODE_STOP) ?
+		    CAN_STATE_STOPPED : CAN_STATE_SLEEPING;
+		spin_unlock_irqrestore(&es58x_dev->tx_urbs_idle.lock, flags);
+		return 0;
+
+	default:
+		netdev_err(netdev, "%s: Invalid can_mode value: %d\n",
+			   __func__, mode);
+		return -EOPNOTSUPP;
+	}
+}
+
+/**
+ * es58x_init_priv() - Initialize private parameters.
+ * @es58x_dev: ES58X device.
+ * @priv: ES58X private parameters related to the network device.
+ * @channel_idx: Index of the network device.
+ */
+static void es58x_init_priv(struct es58x_device *es58x_dev,
+			    struct es58x_priv *priv, int channel_idx)
+{
+	const struct es58x_parameters *param = es58x_dev->param;
+	struct can_priv *can = &priv->can;
+
+	priv->es58x_dev = es58x_dev;
+	priv->channel_idx = channel_idx;
+	priv->tx_urb = NULL;
+	priv->tx_can_msg_cnt = 0;
+
+	can->bittiming_const = param->bittiming_const;
+	can->do_set_bittiming = es58x_set_bittiming;
+	if (param->ctrlmode_supported & CAN_CTRLMODE_FD) {
+		can->data_bittiming_const = param->data_bittiming_const;
+		can->do_set_data_bittiming = es58x_set_data_bittiming;
+	}
+	can->bitrate_max = param->bitrate_max;
+	can->clock = param->clock;
+
+	can->state = CAN_STATE_STOPPED;
+
+	/* Hardware loopback is always enabled, regardless of the
+	 * value of can.ctrlmode & CAN_CTRLMODE_LOOPBACK.
+	 */
+	can->ctrlmode_supported = param->ctrlmode_supported;
+	can->do_get_berr_counter = NULL;	/* Not supported */
+
+	can->do_set_mode = es58x_set_mode;
+}
+
+/**
+ * es58x_init_netdev() - Initialize the network device.
+ * @es58x_dev: ES58X device.
+ * @channel_idx: Index of the network device.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
+{
+	struct net_device *netdev;
+	struct device *dev = es58x_dev->dev;
+	int ret;
+
+	netdev = alloc_candev(sizeof(struct es58x_priv),
+			      es58x_dev->param->fifo_mask + 1);
+	if (!netdev) {
+		dev_err(dev, "Could not allocate candev\n");
+		return -ENOMEM;
+	}
+	SET_NETDEV_DEV(netdev, dev);
+	es58x_dev->netdev[channel_idx] = netdev;
+	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
+
+	netdev->netdev_ops = &es58x_netdev_ops;
+	netdev->flags |= IFF_ECHO;	/* We support local echo */
+
+	ret = register_candev(netdev);
+	if (ret)
+		return ret;
+	netdev_dbg(netdev, "%s: Registered channel %s\n",
+		   es58x_dev->udev->product, netdev->name);
+
+#ifdef CONFIG_BQL
+	netdev_get_tx_queue(netdev, 0)->dql.min_limit =
+	    es58x_dev->param->dql_limit_min;
+#endif
+
+	return ret;
+}
+
+/**
+ * es58x_get_product_info() - Get the product information and print them.
+ * @es58x_dev: ES58X device.
+ *
+ * Do a synchronous call to get the product information.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_get_product_info(struct es58x_device *es58x_dev)
+{
+	struct usb_device *udev = es58x_dev->udev;
+	const int es58x_prod_info_idx = 6;
+	/* Empirical tests show a prod_info length of maximum 83,
+	 * below should be more than enough.
+	 */
+	const size_t prod_info_len = 127;
+	char *prod_info;
+	int ret;
+
+	prod_info = kmalloc(prod_info_len, GFP_KERNEL);
+	if (!prod_info)
+		return -ENOMEM;
+
+	ret = usb_string(udev, es58x_prod_info_idx, prod_info, prod_info_len);
+	if (ret < 0) {
+		dev_err(es58x_dev->dev,
+			"%s: Could not read the product info: %pe\n",
+			__func__, ERR_PTR(ret));
+		return ret;
+	} else if (ret >= prod_info_len - 1) {
+		dev_warn(es58x_dev->dev,
+			 "%s: Buffer is too small, result might be truncated\n",
+			 __func__);
+	}
+	dev_info(es58x_dev->dev, "Product info: %s\n", prod_info);
+	kfree(prod_info);
+
+	return 0;
+}
+
+/**
+ * es58x_init_es58x_dev() - Initialize the ES58X device.
+ * @intf: USB interface
+ * @p_es58x_dev: pointer to the address of the ES58X device.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_init_es58x_dev(struct usb_interface *intf,
+				struct es58x_device **p_es58x_dev)
+{
+	struct device *dev = &intf->dev;
+	struct es58x_device *es58x_dev;
+	const struct es58x_parameters *param;
+	const struct es58x_operators *ops;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *ep_in, *ep_out;
+	const u16 usb_id_product = le16_to_cpu(udev->descriptor.idProduct);
+	u8 num_can_ch;
+	int ret;
+
+	dev_info(dev,
+		 "Starting %s %s (Serial Number %s) driver version %s\n",
+		 udev->manufacturer, udev->product, udev->serial, DRV_VERSION);
+
+	ret = usb_find_common_endpoints(intf->cur_altsetting, &ep_in, &ep_out,
+					NULL, NULL);
+	if (ret)
+		return ret;
+
+	switch (usb_id_product) {
+	case ES581_4_PRODUCT_ID:	/* 2 Classical CAN channels */
+		param = &es581_4_param;
+		ops = &es581_4_ops;
+		num_can_ch = ES581_4_NUM_CAN_CH;
+		break;
+
+	case ES582_1_PRODUCT_ID:	/* 2 CAN(-FD) channels */
+		param = &es58x_fd_param;
+		ops = &es58x_fd_ops;
+		num_can_ch = ES582_1_NUM_CAN_CH;
+		break;
+
+	case ES584_1_PRODUCT_ID:	/* 1 CAN(-FD) and 1 LIN channel */
+		param = &es58x_fd_param;
+		ops = &es58x_fd_ops;
+		num_can_ch = ES584_1_NUM_CAN_CH;
+		break;
+
+	default:
+		return -ENODEV;
+	}
+	if (num_can_ch > ARRAY_SIZE(es58x_dev->netdev))
+		return -ECHRNG;
+
+	es58x_dev = kzalloc(es58x_sizeof_es58x_device(param), GFP_KERNEL);
+	if (!es58x_dev)
+		return -ENOMEM;
+
+	es58x_dev->param = param;
+	es58x_dev->ops = ops;
+	es58x_dev->num_can_ch = num_can_ch;
+	es58x_dev->dev = dev;
+	es58x_dev->udev = udev;
+
+	init_usb_anchor(&es58x_dev->rx_urbs);
+	init_usb_anchor(&es58x_dev->tx_urbs_idle);
+	init_usb_anchor(&es58x_dev->tx_urbs_busy);
+	usb_set_intfdata(intf, es58x_dev);
+
+	es58x_dev->rx_pipe = usb_rcvbulkpipe(es58x_dev->udev,
+					     ep_in->bEndpointAddress);
+	es58x_dev->tx_pipe = usb_sndbulkpipe(es58x_dev->udev,
+					     ep_out->bEndpointAddress);
+	es58x_dev->rx_max_packet_size = le16_to_cpu(ep_in->wMaxPacketSize);
+
+	*p_es58x_dev = es58x_dev;
+
+	return 0;
+}
+
+/**
+ * es58x_probe() - Initialize the USB device.
+ * @intf: USB interface
+ * @id: USB device ID
+ *
+ * Return: zero on success, -ENODEV if the interface is not supported
+ * or errno when any other error occurs.
+ */
+static int es58x_probe(struct usb_interface *intf,
+		       const struct usb_device_id *id)
+{
+	struct es58x_device *es58x_dev;
+	int ch_idx, ret;
+
+	/* ES58X FD has some interface protocols unsupported by this driver. */
+	if (intf->cur_altsetting->desc.bInterfaceProtocol != 0) {
+		dev_dbg(&intf->dev, "Interface protocol %d is not supported\n",
+			intf->cur_altsetting->desc.bInterfaceProtocol);
+		return -ENODEV;
+	}
+
+	ret = es58x_init_es58x_dev(intf, &es58x_dev);
+	if (ret)
+		return ret;
+
+	ret = es58x_get_product_info(es58x_dev);
+	if (ret)
+		goto cleanup_es58x_dev;
+
+	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
+		ret = es58x_init_netdev(es58x_dev, ch_idx);
+		if (ret)
+			goto cleanup_candev;
+	}
+
+	ret = es58x_start(es58x_dev);
+	if (ret)
+		goto cleanup_candev;
+
+	es58x_set_realtime_diff_ns(es58x_dev);
+
+	return ret;
+
+ cleanup_candev:
+	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++)
+		if (es58x_dev->netdev[ch_idx]) {
+			unregister_candev(es58x_dev->netdev[ch_idx]);
+			free_candev(es58x_dev->netdev[ch_idx]);
+		}
+ cleanup_es58x_dev:
+	kfree(es58x_dev);
+
+	return ret;
+}
+
+/**
+ * es58x_disconnect() - Disconnect the USB device.
+ * @intf: USB interface
+ *
+ * Called by the usb core when driver is unloaded or device is
+ * removed.
+ */
+static void es58x_disconnect(struct usb_interface *intf)
+{
+	struct es58x_device *es58x_dev = usb_get_intfdata(intf);
+	struct net_device *netdev;
+	struct urb *urb;
+	int i;
+
+	dev_info(&intf->dev, "Disconnecting %s %s\n",
+		 es58x_dev->udev->manufacturer, es58x_dev->udev->product);
+
+	for (i = 0; i < es58x_dev->num_can_ch; i++) {
+		netdev = es58x_dev->netdev[i];
+		if (!netdev)
+			continue;
+		netdev_dbg(netdev, "Unregistering %s\n", netdev->name);
+		unregister_candev(netdev);
+		netdev_dbg(netdev, "Freeing %s\n", netdev->name);
+		es58x_dev->netdev[i] = NULL;
+		free_candev(netdev);
+	}
+
+	dev_dbg(&intf->dev, "Killing TX busy anchored urbs\n");
+	if (!usb_wait_anchor_empty_timeout(&es58x_dev->tx_urbs_busy, 1000)) {
+		dev_err(&intf->dev, "%s: Timeout, some TX urbs still remain\n",
+			__func__);
+		usb_kill_anchored_urbs(&es58x_dev->tx_urbs_busy);
+	}
+
+	dev_dbg(&intf->dev, "Freeing TX idle anchored urbs\n");
+	while ((urb = usb_get_from_anchor(&es58x_dev->tx_urbs_idle)) != NULL) {
+		usb_free_coherent(urb->dev,
+				  es58x_dev->param->tx_urb_cmd_max_len,
+				  urb->transfer_buffer, urb->transfer_dma);
+		usb_free_urb(urb);
+		atomic_dec(&es58x_dev->tx_urbs_idle_cnt);
+	}
+	if (atomic_read(&es58x_dev->tx_urbs_idle_cnt) > 0)
+		dev_err(&intf->dev,
+			"All idle urbs were freed but tx_urb_idle_cnt is %u\n",
+			atomic_read(&es58x_dev->tx_urbs_idle_cnt));
+
+	dev_dbg(&intf->dev, "Unlinking RX anchored urbs\n");
+	usb_kill_anchored_urbs(&es58x_dev->rx_urbs);
+
+	dev_dbg(&intf->dev, "Freeing %s\n", es58x_dev->udev->product);
+	kfree(es58x_dev);
+	dev_dbg(&intf->dev, "Setting USB interface to NULL\n");
+	usb_set_intfdata(intf, NULL);
+}
+
+static struct usb_driver es58x_driver = {
+	.name = ES58X_MODULE_NAME,
+	.probe = es58x_probe,
+	.disconnect = es58x_disconnect,
+	.id_table = es58x_id_table,
+};
+
+module_usb_driver(es58x_driver);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
new file mode 100644
index 000000000000..1066a9b17b84
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -0,0 +1,698 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_core.h: All common definitions and declarations.
+ *
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
+ */
+
+#ifndef __ES58X_COMMON_H__
+#define __ES58X_COMMON_H__
+
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/netdevice.h>
+#include <linux/can.h>
+#include <linux/can/dev.h>
+
+#include "es581_4.h"
+#include "es58x_fd.h"
+
+/* Driver constants */
+#define ES58X_RX_URBS_MAX 5	/* Empirical value */
+#define ES58X_TX_URBS_MAX 8	/* Empirical value */
+
+#define ES58X_MAX(param)				\
+	(ES581_4_##param > ES58X_FD_##param ?		\
+		ES581_4_##param : ES58X_FD_##param)
+#define ES58X_TX_BULK_MAX ES58X_MAX(TX_BULK_MAX)
+#define ES58X_RX_BULK_MAX ES58X_MAX(RX_BULK_MAX)
+#define ES58X_RX_LOOPBACK_BULK_MAX ES58X_MAX(RX_LOOPBACK_BULK_MAX)
+#define ES58X_NUM_CAN_CH_MAX ES58X_MAX(NUM_CAN_CH)
+
+/* Use this when channel index is irrelevant (e.g. device
+ * timestamp).
+ */
+#define ES58X_CHANNEL_IDX_NA 0xFF
+#define ES58X_EMPTY_MSG NULL
+
+/* Threshold on consecutive CAN_STATE_ERROR_PASSIVE. If we receive
+ * ES58X_CONSECUTIVE_ERR_PASSIVE_MAX times the event
+ * ES58X_ERR_CRTL_PASSIVE in a row without any successful Rx or Tx,
+ * we force the device to switch to CAN_STATE_BUS_OFF state.
+ */
+#define ES58X_CONSECUTIVE_ERR_PASSIVE_MAX 254
+
+enum es58x_self_reception {
+	ES58X_SELF_RECEPTION_OFF = 0,
+	ES58X_SELF_RECEPTION_ON = 1
+};
+
+/**
+ * enum es58x_physical_layer - Type of the physical layer.
+ * @ES58X_PHYSICAL_LAYER_HIGH_SPEED: High-speed CAN (c.f. ISO
+ *	11898-2).
+ *
+ * Some products of the ETAS portfolio also support low-speed CAN
+ * (c.f. ISO 11898-3). However, all the devices in scope of this
+ * driver do not support the option, thus, the enum has only one
+ * member.
+ */
+enum es58x_physical_layer {
+	ES58X_PHYSICAL_LAYER_HIGH_SPEED = 1
+};
+
+enum es58x_samples_per_bit {
+	ES58X_SAMPLES_PER_BIT_ONE = 1,
+	ES58X_SAMPLES_PER_BIT_THREE = 2
+};
+
+/**
+ * enum es58x_sync_edge - Synchronization method.
+ * @ES58X_SYNC_EDGE_SINGLE: ISO CAN specification defines the use of a
+ *	single edge synchronization.  The synchronization should be
+ *	done on recessive to dominant level change.
+ *
+ * For information, ES582.1 and ES584.1 also support a double
+ * synchronization, requiring both recessive to dominant then dominant
+ * to recessive level change. However, this is not supported in
+ * SocketCAN framework, thus, the enum has only one member.
+ */
+enum es58x_sync_edge {
+	ES58X_SYNC_EDGE_SINGLE = 1
+};
+
+/**
+ * enum es58x_flag - CAN flags for RX/TX messages.
+ * @ES58X_FLAG_EFF: Extended Frame Format (EFF).
+ * @ES58X_FLAG_RTR: Remote Transmission Request (RTR).
+ * @ES58X_FLAG_FD_BRS: Bit rate switch (BRS): second bitrate for
+ *	payload data.
+ * @ES58X_FLAG_FD_ESI: Error State Indicator (ESI): tell if the
+ *	transmitting node is in error passive mode.
+ * @ES58X_FLAG_FD_DATA: CAN FD frame.
+ */
+enum es58x_flag {
+	ES58X_FLAG_EFF = BIT(0),
+	ES58X_FLAG_RTR = BIT(1),
+	ES58X_FLAG_FD_BRS = BIT(3),
+	ES58X_FLAG_FD_ESI = BIT(5),
+	ES58X_FLAG_FD_DATA = BIT(6)
+};
+
+/**
+ * enum es58x_err - CAN error detection.
+ * @ES58X_ERR_OK: No errors.
+ * @ES58X_ERR_PROT_STUFF: Bit stuffing error: more than 5 consecutive
+ *	equal bits.
+ * @ES58X_ERR_PROT_FORM: Frame format error.
+ * @ES58X_ERR_ACK: Received no ACK on transmission.
+ * @ES58X_ERR_PROT_BIT: Single bit error.
+ * @ES58X_ERR_PROT_CRC: Incorrect 15, 17 or 21 bits CRC.
+ * @ES58X_ERR_PROT_BIT1: Unable to send recessive bit: tried to send
+ *	recessive bit 1 but monitored dominant bit 0.
+ * @ES58X_ERR_PROT_BIT0: Unable to send dominant bit: tried to send
+ *	dominant bit 0 but monitored recessive bit 1.
+ * @ES58X_ERR_PROT_OVERLOAD: Bus overload.
+ * @ES58X_ERR_PROT_UNSPEC: Unspecified.
+ *
+ * Please refer to ISO 11898-1:2015, section 10.11 "Error detection"
+ * and section 10.13 "Overload signaling" for additional details.
+ */
+enum es58x_err {
+	ES58X_ERR_OK = 0,
+	ES58X_ERR_PROT_STUFF = BIT(0),
+	ES58X_ERR_PROT_FORM = BIT(1),
+	ES58X_ERR_ACK = BIT(2),
+	ES58X_ERR_PROT_BIT = BIT(3),
+	ES58X_ERR_PROT_CRC = BIT(4),
+	ES58X_ERR_PROT_BIT1 = BIT(5),
+	ES58X_ERR_PROT_BIT0 = BIT(6),
+	ES58X_ERR_PROT_OVERLOAD = BIT(7),
+	ES58X_ERR_PROT_UNSPEC = BIT(31)
+};
+
+/**
+ * enum es58x_event - CAN error codes returned by the device.
+ * @ES58X_EVENT_OK: No errors.
+ * @ES58X_EVENT_CRTL_ACTIVE: Active state: both TR and RX error count
+ *	is less than 128.
+ * @ES58X_EVENT_CRTL_PASSIVE: Passive state: either TX or RX error
+ *	count is greater than 127.
+ * @ES58X_EVENT_CRTL_WARNING: Warning state: either TX or RX error
+ *	count is greater than 96.
+ * @ES58X_EVENT_BUSOFF: Bus off.
+ * @ES58X_EVENT_SINGLE_WIRE: Lost connection on either CAN high or CAN
+ *	low.
+ *
+ * Please refer to ISO 11898-1:2015, section 12.1.4 "Rules of fault
+ * confinement" for additional details.
+ */
+enum es58x_event {
+	ES58X_EVENT_OK = 0,
+	ES58X_EVENT_CRTL_ACTIVE = BIT(0),
+	ES58X_EVENT_CRTL_PASSIVE = BIT(1),
+	ES58X_EVENT_CRTL_WARNING = BIT(2),
+	ES58X_EVENT_BUSOFF = BIT(3),
+	ES58X_EVENT_SINGLE_WIRE = BIT(4)
+};
+
+/**
+ * enum es58x_ret_u8 - Device return error codes, 8 bit format.
+ *
+ * Specific to ES581.4.
+ */
+enum es58x_ret_u8 {
+	ES58X_RET_U8_OK = 0x00,
+	ES58X_RET_U8_ERR_UNSPECIFIED_FAILURE = 0x80,
+	ES58X_RET_U8_ERR_NO_MEM = 0x81,
+	ES58X_RET_U8_ERR_BAD_CRC = 0x99
+};
+
+/**
+ * enum es58x_ret_u32 - Device return error codes, 32 bit format.
+ */
+enum es58x_ret_u32 {
+	ES58X_RET_U32_OK = 0x00000000UL,
+	ES58X_RET_U32_ERR_UNSPECIFIED_FAILURE = 0x80000000UL,
+	ES58X_RET_U32_ERR_NO_MEM = 0x80004001UL,
+	ES58X_RET_U32_WARN_PARAM_ADJUSTED = 0x40004000UL,
+	ES58X_RET_U32_WARN_TX_MAYBE_REORDER = 0x40004001UL,
+	ES58X_RET_U32_ERR_TIMEOUT = 0x80000008UL,
+	ES58X_RET_U32_ERR_FIFO_FULL = 0x80003002UL,
+	ES58X_RET_U32_ERR_BAD_CONFIG = 0x80004000UL,
+	ES58X_RET_U32_ERR_NO_RESOURCE = 0x80004002UL
+};
+
+/**
+ * enum es58x_ret_type - Type of the command returned by the ES58X
+ *	device.
+ */
+enum es58x_ret_type {
+	ES58X_RET_TYPE_SET_BITTIMING,
+	ES58X_RET_TYPE_ENABLE_CHANNEL,
+	ES58X_RET_TYPE_DISABLE_CHANNEL,
+	ES58X_RET_TYPE_TX_MSG,
+	ES58X_RET_TYPE_RESET_RX,
+	ES58X_RET_TYPE_RESET_TX,
+	ES58X_RET_TYPE_DEVICE_ERR,
+	ES58X_RET_TYPE_NUM_ENTRIES
+};
+
+union es58x_urb_cmd {
+	struct es581_4_urb_cmd es581_4_urb_cmd;
+	struct es58x_fd_urb_cmd es58x_fd_urb_cmd;
+	struct {		/* Common header parts of all variants */
+		__le16 sof;
+		u8 cmd_type;
+		u8 cmd_id;
+	} __packed;
+	u8 raw_cmd[0];
+};
+
+/**
+ * struct es58x_priv - All information specific to a CAN channel.
+ * @can: struct can_priv must be the first member (Socket CAN relies
+ *	on the fact that function netdev_priv() returns a pointer to
+ *	a struct can_priv).
+ * @es58x_dev: pointer to the corresponding ES58X device.
+ * @tx_urb: Used as a buffer to concatenate the TX messages and to do
+ *	a bulk send. Please refer to es58x_start_xmit() for more
+ *	details.
+ * @tx_tail: Index of the oldest packet still pending for
+ *	completion. @tx_tail & echo_skb_mask represents the beginning
+ *	of the echo skb FIFO, i.e. index of the first element.
+ * @tx_head: Index of the next packet to be sent to the
+ *	device. @tx_head & echo_skb_mask represents the end of the
+ *	echo skb FIFO plus one, i.e. the first free index.
+ * @tx_total_frame_len: sum, in bytes, of the length of each of the
+ *	CAN messages contained in @tx_urb. To be used as an input of
+ *	netdev_sent_queue() for BQL.
+ * @tx_can_msg_cnt: Number of messages in @tx_urb.
+ * @tx_can_msg_is_fd: false: all messages in @tx_urb are Classical
+ *	CAN, true: all messages in @tx_urb are CAN FD. Rationale:
+ *	ES58X FD devices do not allow to mix Classical CAN and FD CAN
+ *	frames in one single bulk transmission.
+ * @err_passive_before_rtx_success: The ES58X device might enter in a
+ *	state in which it keeps alternating between error passive
+ *	and active states. This counter keeps track of the number of
+ *	error passive and if it gets bigger than
+ *	ES58X_CONSECUTIVE_ERR_PASSIVE_MAX, es58x_rx_err_msg() will
+ *	force the status to bus-off.
+ * @channel_idx: Channel index, starts at zero.
+ */
+struct es58x_priv {
+	struct can_priv can;
+	struct es58x_device *es58x_dev;
+	struct urb *tx_urb;
+
+	u32 tx_tail;
+	u32 tx_head;
+
+	u16 tx_total_frame_len;
+	u8 tx_can_msg_cnt;
+	bool tx_can_msg_is_fd;
+
+	u8 err_passive_before_rtx_success;
+
+	u8 channel_idx;
+};
+
+/**
+ * struct es58x_parameters - Constant parameters of a given hardware
+ *	variant.
+ * @can_bittiming_const: Nominal bittimming parameters.
+ * @data_bittiming_const: Data bittiming parameters.
+ * @bitrate_max: Maximum bitrate supported by the device.
+ * @clock: CAN clock parameters.
+ * @ctrlmode_supported: List of supported modes. Please refer to
+ *	can/netlink.h file for additional details.
+ * @tx_start_of_frame: Magic number at the beginning of each TX URB
+ *	command.
+ * @rx_start_of_frame: Magic number at the beginning of each RX URB
+ *	command.
+ * @tx_urb_cmd_max_len: Maximum length of a TX URB command.
+ * @rx_urb_cmd_max_len: Maximum length of a RX URB command.
+ * @fifo_mask: Bit mask to quickly convert the tx_tail and tx_head
+ *	field of the struct es58x_priv into echo_skb
+ *	indexes. Properties: @fifo_mask = echos_skb_max - 1 where
+ *	echo_skb_max must be a power of two. Also, echo_skb_max must
+ *	not exceed the maximum size of the device internal TX FIFO
+ *	length. This parameter is used to control the network queue
+ *	wake/stop logic.
+ * @dql_limit_min: Dynamic Queue Limits (DQL) absolute minimum limit
+ *	of bytes allowed to be queued on this network device transmit
+ *	queue. Used by the Byte Queue Limits (BQL) to determine how
+ *	frequently the xmit_more flag will be set to true in
+ *	es58x_start_xmit(). Set this value higher to optimize for
+ *	throughput but be aware that it might have a negative impact
+ *	on the latency! This value can also be set dynamically. Please
+ *	refer to Documentation/ABI/testing/sysfs-class-net-queues for
+ *	more details.
+ * @tx_bulk_max: Maximum number of Tx messages that can be sent in one
+ *	single URB packet.
+ * @urb_cmd_header_len: Length of the URB command header.
+ * @rx_urb_max: Number of RX URB to be allocated during device probe.
+ * @tx_urb_max: Number of TX URB to be allocated during device probe.
+ */
+struct es58x_parameters {
+	const struct can_bittiming_const *bittiming_const;
+	const struct can_bittiming_const *data_bittiming_const;
+	u32 bitrate_max;
+	struct can_clock clock;
+	u32 ctrlmode_supported;
+	u16 tx_start_of_frame;
+	u16 rx_start_of_frame;
+	u16 tx_urb_cmd_max_len;
+	u16 rx_urb_cmd_max_len;
+	u16 fifo_mask;
+#ifdef CONFIG_BQL
+	u16 dql_limit_min;
+#endif
+	u8 tx_bulk_max;
+	u8 urb_cmd_header_len;
+	u8 rx_urb_max;
+	u8 tx_urb_max;
+};
+
+/**
+ * struct es58x_operators - Function pointers used to encode/decode
+ *	the TX/RX messages.
+ * @get_msg_len: Get field msg_len of the urb_cmd. The offset of
+ *	msg_len inside urb_cmd depends of the device model.
+ * @handle_urb_cmd: Decode the URB command received from the device
+ *	and manage the return code from device.
+ * @fill_urb_header: Fill the header of urb_cmd.
+ * @tx_can_msg: Encode a TX CAN message and add it to the bulk buffer
+ *	cmd_buf of es58x_dev.
+ * @set_bittiming: Encode the bittiming information and send it.
+ * @enable_channel: Start the CAN channel.
+ * @disable_channel: Stop the CAN channel.
+ * @reset_rx: Reset the RX queue of the ES58X device.
+ * @reset_tx: Reset the TX queue of the ES58X device.
+ * @get_timestamp: Request a timestamp from the ES58X device.
+ */
+struct es58x_operators {
+	u16 (*get_msg_len)(const union es58x_urb_cmd *urb_cmd);
+	int (*handle_urb_cmd)(struct es58x_device *es58x_dev,
+			      const union es58x_urb_cmd *urb_cmd);
+	void (*fill_urb_header)(union es58x_urb_cmd *urb_cmd, u8 cmd_type,
+				u8 cmd_id, u8 channel_idx, u16 cmd_len);
+	int (*tx_can_msg)(struct es58x_priv *priv, const struct sk_buff *skb);
+	int (*set_bittiming)(struct es58x_priv *priv);
+	int (*enable_channel)(struct es58x_priv *priv);
+	int (*disable_channel)(struct es58x_priv *priv);
+	int (*reset_rx)(struct es58x_priv *priv);
+	int (*reset_tx)(struct es58x_priv *priv);
+	int (*get_timestamp)(struct es58x_device *es58x_dev);
+};
+
+/**
+ * struct es58x_device - All information specific to an ES58X device.
+ * @dev: Device information.
+ * @udev: USB device information.
+ * @netdev: Array of our CAN channels.
+ * @param: The constant parameters.
+ * @ops: Operators.
+ * @rx_pipe: USB reception pipe.
+ * @tx_pipe: USB transmission pipe.
+ * @rx_urbs: Anchor for received URBs.
+ * @tx_urbs_busy: Anchor for TX URBs which were send to the device.
+ * @tx_urbs_idle: Anchor for TX USB which are idle. This driver
+ *	allocates the memory for the URBs during the probe. When a TX
+ *	URB is needed, it can be taken from this anchor. The network
+ *	queue wake/stop logic should prevent this URB from getting
+ *	empty. Please refer to es58x_get_tx_urb() for more details.
+ * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
+ * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
+ *	was called.
+ * @realtime_diff_ns: difference in nanoseconds between the clocks of
+ *	the ES58X device and the kernel.
+ * @timestamps: a temporary buffer to store the time stamps before
+ *	feeding them to es58x_can_get_echo_skb(). Can only be used
+ *	in rx branches.
+ * @rx_max_packet_size: Maximum length of bulk-in URB.
+ * @num_can_ch: Number of CAN channel (i.e. number of elements of @netdev).
+ * @rx_cmd_buf_len: Length of @rx_cmd_buf.
+ * @rx_cmd_buf: The device might split the URB commands in an
+ *	arbitrary amount of pieces. This buffer is used to concatenate
+ *	all those pieces. Can only be used in rx branches. This field
+ *	has to be the last one of the structure because it is has a
+ *	flexible size (c.f. es58x_sizeof_es58x_device() function).
+ */
+struct es58x_device {
+	struct device *dev;
+	struct usb_device *udev;
+	struct net_device *netdev[ES58X_NUM_CAN_CH_MAX];
+
+	const struct es58x_parameters *param;
+	const struct es58x_operators *ops;
+
+	int rx_pipe;
+	int tx_pipe;
+
+	struct usb_anchor rx_urbs;
+	struct usb_anchor tx_urbs_busy;
+	struct usb_anchor tx_urbs_idle;
+	atomic_t tx_urbs_idle_cnt;
+
+	u64 ktime_req_ns;
+	s64 realtime_diff_ns;
+
+	u64 timestamps[ES58X_RX_LOOPBACK_BULK_MAX];
+
+	u16 rx_max_packet_size;
+	u8 num_can_ch;
+
+	u16 rx_cmd_buf_len;
+	union es58x_urb_cmd rx_cmd_buf;
+};
+
+/**
+ * es58x_sizeof_es58x_device() - Calculate the maximum length of
+ *	struct es58x_device.
+ * @es58x_dev_param: The constant parameters of the device.
+ *
+ * The length of struct es58x_device depends on the length of its last
+ * field: rx_cmd_buf. This macro allows to optimize size for memory
+ * allocation.
+ *
+ * Return: length of struct es58x_device.
+ */
+static inline size_t es58x_sizeof_es58x_device(const struct es58x_parameters
+					       *es58x_dev_param)
+{
+	return offsetof(struct es58x_device, rx_cmd_buf) +
+		es58x_dev_param->rx_urb_cmd_max_len;
+}
+
+/* Megabit per second (multiply x per one million) */
+#define ES58X_MBPS(x) (1000000UL * (x))
+
+/* Megahertz (multiply x per one million) */
+#define ES58X_MHZ(x) (1000000UL * (x))
+
+static inline int __es58x_check_msg_len(const struct device *dev,
+					const char *stringified_msg,
+					size_t actual_len, size_t expected_len)
+{
+	if (expected_len != actual_len) {
+		dev_err(dev,
+			"Length of %s is %zu but received command is %zu.\n",
+			stringified_msg, expected_len, actual_len);
+		return -EMSGSIZE;
+	}
+	return 0;
+}
+
+/**
+ * es58x_check_msg_len() - Check the size of a received message.
+ * @dev: Device, used to print error messages.
+ * @msg: Received message, must not be a pointer.
+ * @actual_len: Length of the message as advertised in the command header.
+ *
+ * Must be a macro in order to retrieve the actual size using
+ * sizeof(). Can be use with any of the messages which have a fixed
+ * length. Check for an exact match of the size.
+ *
+ * Return: zero on success, -EMSGSIZE if @actual_len differs from the
+ * expected length.
+ */
+#define es58x_check_msg_len(dev, msg, actual_len)			\
+	__es58x_check_msg_len(dev, __stringify(msg),			\
+			      actual_len, sizeof(msg))
+
+static inline int __es58x_check_msg_max_len(const struct device *dev,
+					    const char *stringified_msg,
+					    size_t actual_len,
+					    size_t expected_len)
+{
+	if (actual_len > expected_len) {
+		dev_err(dev,
+			"Maximum length for %s is %zu but received command is %zu.\n",
+			stringified_msg, expected_len, actual_len);
+		return -EOVERFLOW;
+	}
+	return 0;
+}
+
+/**
+ * es58x_check_msg_max_len() - Check the maximum size of a received message.
+ * @dev: Device, used to print error messages.
+ * @msg: Received message, must not be a pointer.
+ * @actual_len: Length of the message as advertised in the command header.
+ *
+ * Must be a macro in order to retrieve the actual size using
+ * sizeof(). To be used with the messages of variable sizes. Only
+ * check that the message is not bigger than the maximum expected
+ * size.
+ *
+ * Return: zero on success, -EOVERFLOW if @actual_len is greater than
+ * the expected length.
+ */
+#define es58x_check_msg_max_len(dev, msg, actual_len)			\
+	__es58x_check_msg_max_len(dev, __stringify(msg),		\
+				  actual_len, sizeof(msg))
+
+static inline int __es58x_msg_num_element(const struct device *dev,
+					  const char *stringified_msg,
+					  size_t actual_len, size_t msg_len,
+					  size_t elem_len)
+{
+	size_t actual_num_elem = actual_len / elem_len;
+	size_t expected_num_elem = msg_len / elem_len;
+
+	if (actual_num_elem == 0) {
+		dev_err(dev,
+			"Minimum length for %s is %zu but received command is %zu.\n",
+			stringified_msg, elem_len, actual_len);
+		return -EMSGSIZE;
+	} else if ((actual_len % elem_len) != 0) {
+		dev_err(dev,
+			"Received command length: %zu is not a multiple of %s[0]: %zu\n",
+			actual_len, stringified_msg, elem_len);
+		return -EMSGSIZE;
+	} else if (actual_num_elem > expected_num_elem) {
+		dev_err(dev,
+			"Array %s is supposed to have %zu elements each of size %zu...\n",
+			stringified_msg, expected_num_elem, elem_len);
+		dev_err(dev,
+			"... But received command has %zu elements (total length %zu).\n",
+			actual_num_elem, actual_len);
+		return -EOVERFLOW;
+	}
+	return actual_num_elem;
+}
+
+/**
+ * es58x_msg_num_element() - Check size and give the number of
+ *	elements in a message of array type.
+ * @dev: Device, used to print error messages.
+ * @msg: Received message, must be an array.
+ * @actual_len: Length of the message as advertised in the command
+ *	header.
+ *
+ * Must be a macro in order to retrieve the actual size using
+ * sizeof(). To be used on message of array type. Array's element has
+ * to be of fixed size (else use es58x_check_msg_max_len()). Check
+ * that the total length is an exact multiple of the length of a
+ * single element.
+ *
+ * Return: number of elements in the array on success, -EOVERFLOW if
+ * @actual_len is greater than the expected length, -EMSGSIZE if
+ * @actual_len is not a multiple of a single element.
+ */
+#define es58x_msg_num_element(dev, msg, actual_len)			\
+({									\
+	size_t __elem_len = sizeof((msg)[0]) + __must_be_array(msg);	\
+	__es58x_msg_num_element(dev, __stringify(msg), actual_len,	\
+				sizeof(msg), __elem_len);		\
+})
+
+/**
+ * es58x_priv() - Get the priv member and cast it to struct es58x_priv.
+ * @netdev: CAN network device.
+ *
+ * Return: ES58X device.
+ */
+static inline struct es58x_priv *es58x_priv(struct net_device *netdev)
+{
+	return (struct es58x_priv *)netdev_priv(netdev);
+}
+
+/**
+ * ES58X_SIZEOF_URB_CMD() - Calculate the maximum length of an urb
+ *	command for a given message field name.
+ * @es58x_urb_cmd_type: type (either "struct es581_4_urb_cmd" or
+ *	"struct es58x_fd_urb_cmd").
+ * @msg_field: name of the message field.
+ *
+ * Must be a macro in order to retrieve the actual size using
+ * offsetof() and sizeof_field().
+ *
+ * Return: length of the urb command.
+ */
+#define ES58X_SIZEOF_URB_CMD(es58x_urb_cmd_type, msg_field)		\
+	(offsetof(es58x_urb_cmd_type, raw_msg)				\
+		+ sizeof_field(es58x_urb_cmd_type, msg_field)		\
+		+ sizeof_field(es58x_urb_cmd_type,			\
+			       reserved_for_crc16_do_not_use))
+
+/**
+ * es58x_get_urb_cmd_len() - Calculate the actual length of an urb
+ *	command for a given message length.
+ * @es58x_dev: ES58X device.
+ * @msg_len: Length of the message.
+ *
+ * Add the header and CRC lengths to the message length.
+ *
+ * Return: length of the urb command.
+ */
+static inline size_t es58x_get_urb_cmd_len(struct es58x_device *es58x_dev,
+					   u16 msg_len)
+{
+	/* URB Length = URB header len + Message len + sizeof crc16 */
+	return es58x_dev->param->urb_cmd_header_len + msg_len + sizeof(u16);
+}
+
+/**
+ * es58x_get_netdev() - Get the network device.
+ * @es58x_dev: ES58X device.
+ * @channel_no: The channel number as advertised in the urb command.
+ * @channel_idx_offset: Some of the ES58x starts channel numbering
+ *	from 0 (ES58X FD), others from 1 (ES581.4).
+ * @netdev: CAN network device.
+ *
+ * Do a sanity check on the index provided by the device.
+ *
+ * Return: zero on success, -ECHRNG if the received channel number is
+ *	out of range and -ENODEV if the network device is not yet
+ *	configured.
+ */
+static inline int es58x_get_netdev(struct es58x_device *es58x_dev,
+				   int channel_no, int channel_idx_offset,
+				   struct net_device **netdev)
+{
+	int channel_idx = channel_no - channel_idx_offset;
+
+	*netdev = NULL;
+	if (channel_idx < 0 || channel_idx >= es58x_dev->num_can_ch)
+		return -ECHRNG;
+
+	*netdev = es58x_dev->netdev[channel_idx];
+	if (!netdev || !netif_device_present(*netdev))
+		return -ENODEV;
+
+	return 0;
+}
+
+/**
+ * es58x_get_raw_can_id() - Get the CAN ID.
+ * @cf: CAN frame.
+ *
+ * Mask the CAN ID in order to only keep the significant bits.
+ *
+ * Return: the raw value of the CAN ID.
+ */
+static inline int es58x_get_raw_can_id(const struct can_frame *cf)
+{
+	if (cf->can_id & CAN_EFF_FLAG)
+		return cf->can_id & CAN_EFF_MASK;
+	else
+		return cf->can_id & CAN_SFF_MASK;
+}
+
+/**
+ * es58x_get_flags() - Get the CAN flags.
+ * @skb: socket buffer of a CAN message.
+ *
+ * Return: the CAN flag as an enum es58x_flag.
+ */
+static inline enum es58x_flag es58x_get_flags(const struct sk_buff *skb)
+{
+	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
+	enum es58x_flag es58x_flags = 0;
+
+	if (cf->can_id & CAN_EFF_FLAG)
+		es58x_flags |= ES58X_FLAG_EFF;
+
+	if (can_is_canfd_skb(skb)) {
+		es58x_flags |= ES58X_FLAG_FD_DATA;
+		if (cf->flags & CANFD_BRS)
+			es58x_flags |= ES58X_FLAG_FD_BRS;
+		if (cf->flags & CANFD_ESI)
+			es58x_flags |= ES58X_FLAG_FD_ESI;
+	} else if (cf->can_id & CAN_RTR_FLAG)
+		/* Remote frames are only defined in Classical CAN frames */
+		es58x_flags |= ES58X_FLAG_RTR;
+
+	return es58x_flags;
+}
+
+int es58x_can_get_echo_skb(struct net_device *netdev, u32 packet_idx,
+			   u64 *tstamps, unsigned int pkts);
+int es58x_tx_ack_msg(struct net_device *netdev, u16 tx_free_entries,
+		     enum es58x_ret_u32 rx_cmd_ret_u32);
+int es58x_rx_can_msg(struct net_device *netdev, u64 timestamp, const u8 *data,
+		     canid_t can_id, enum es58x_flag es58x_flags, u8 dlc);
+int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
+		     enum es58x_event event, u64 timestamp);
+int es58x_rx_timestamp(struct es58x_device *es58x_dev, u64 timestamp);
+int es58x_rx_dev_ret_u8(struct device *dev, enum es58x_ret_type cmd_ret_type,
+			enum es58x_ret_u8 rx_dev_ret_u8);
+int es58x_rx_cmd_ret_u32(struct net_device *netdev,
+			 enum es58x_ret_type cmd_ret_type,
+			 enum es58x_ret_u32 rx_cmd_ret_u32);
+int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd_id,
+		   const void *msg, u16 cmd_len, int channel_idx);
+
+extern const struct es58x_parameters es581_4_param;
+extern const struct es58x_operators es581_4_ops;
+
+extern const struct es58x_parameters es58x_fd_param;
+extern const struct es58x_operators es58x_fd_ops;
+
+#endif /* __ES58X_COMMON_H__ */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
new file mode 100644
index 000000000000..1352480da7be
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -0,0 +1,600 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_fd.c: Adds support to ETAS ES582.1 and ES584.1 (naming
+ * convention: we use the term "ES58X FD" when referring to those two
+ * variants together).
+ *
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <asm/unaligned.h>
+
+#include "es58x_core.h"
+#include "es58x_fd.h"
+
+/**
+ * es58x_sizeof_rx_tx_msg() - Calculate the actual length of the
+ *	structure of a rx or tx message.
+ * @msg: message of variable length, must have a dlc and a len fields.
+ *
+ * Even if RTR frames have actually no payload, the ES58X devices
+ * still expect it. Must be a macro in order to retrieve the actual
+ * size using offsetof() and typeof().
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
+	(offsetof(typeof(__msg), data[__msg_len]));			\
+})
+
+static enum es58x_fd_cmd_type es58x_fd_cmd_type(struct net_device *netdev)
+{
+	u32 ctrlmode = es58x_priv(netdev)->can.ctrlmode;
+
+	return ctrlmode & (CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO) ?
+	    ES58X_FD_CMD_TYPE_CANFD : ES58X_FD_CMD_TYPE_CAN;
+}
+
+static u16 es58x_fd_get_msg_len(const union es58x_urb_cmd *urb_cmd)
+{
+	return get_unaligned_le16(&urb_cmd->es58x_fd_urb_cmd.msg_len);
+}
+
+static int es58x_fd_rx_loopback_msg(struct net_device *netdev,
+				    const struct es58x_fd_urb_cmd
+				    *es58x_fd_urb_cmd)
+{
+	struct es58x_priv *priv = es58x_priv(netdev);
+	const struct es58x_fd_rx_loopback_msg *rx_loopback_msg;
+	struct es58x_device *es58x_dev = priv->es58x_dev;
+	u64 *tstamps = es58x_dev->timestamps;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	int i, num_element;
+	u32 rcv_packet_idx;
+
+	const u32 mask = GENMASK(31, sizeof(rx_loopback_msg->packet_idx) * 8);
+
+	num_element = es58x_msg_num_element(es58x_dev->dev,
+					    es58x_fd_urb_cmd->rx_loopback_msg,
+					    msg_len);
+	if (num_element < 0)
+		return num_element;
+	rx_loopback_msg = es58x_fd_urb_cmd->rx_loopback_msg;
+
+	rcv_packet_idx = (priv->tx_tail & mask) | rx_loopback_msg[0].packet_idx;
+	for (i = 0; i < num_element; i++) {
+		if ((u8)rcv_packet_idx != rx_loopback_msg[i].packet_idx) {
+			netdev_err(netdev, "Packet idx jumped from %u to %u\n",
+				   (u8)rcv_packet_idx - 1,
+				   rx_loopback_msg[i].packet_idx);
+			return -EBADMSG;
+		}
+
+		tstamps[i] = get_unaligned_le64(&rx_loopback_msg[i].timestamp);
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
+				 const struct es58x_fd_urb_cmd
+				 *es58x_fd_urb_cmd)
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
+				   const struct es58x_fd_urb_cmd
+				   *es58x_fd_urb_cmd,
+				   enum es58x_ret_type cmd_ret_type)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	enum es58x_ret_u32 rx_cmd_ret_u32;
+	int ret;
+
+	ret = es58x_check_msg_len(es58x_dev->dev,
+				  es58x_fd_urb_cmd->rx_cmd_ret_le32, msg_len);
+	if (ret)
+		return ret;
+
+	rx_cmd_ret_u32 = get_unaligned_le32(&es58x_fd_urb_cmd->rx_cmd_ret_le32);
+
+	return es58x_rx_cmd_ret_u32(netdev, cmd_ret_type, rx_cmd_ret_u32);
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
+	return
+	    es58x_tx_ack_msg(netdev,
+			     get_unaligned_le16(&tx_ack_msg->tx_free_entries),
+			     get_unaligned_le32(&tx_ack_msg->rx_cmd_ret_le32));
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
+	case ES58X_FD_CAN_CMD_ID_MSG_SELFRX_ACK:
+		return es58x_fd_rx_loopback_msg(netdev, es58x_fd_urb_cmd);
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
+				  const struct es58x_fd_urb_cmd
+				  *es58x_fd_urb_cmd)
+{
+	u16 msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	u64 timestamp;
+	int ret;
+
+	switch ((enum es58x_fd_dev_cmd_id)es58x_fd_urb_cmd->cmd_id) {
+	case ES58X_FD_DEV_CMD_ID_TIMESTAMP:
+		ret = es58x_check_msg_len(es58x_dev->dev,
+					  es58x_fd_urb_cmd->timestamp, msg_len);
+		if (ret)
+			return ret;
+		timestamp = get_unaligned_le64(&es58x_fd_urb_cmd->timestamp);
+		return es58x_rx_timestamp(es58x_dev, timestamp);
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
+	const struct device *dev = es58x_dev->dev;
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
+		dev_err(dev,
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
+	u32 *urb_cmd_len = &priv->tx_urb->transfer_buffer_length;
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct es58x_fd_tx_can_msg *tx_can_msg;
+	bool is_fd = can_is_canfd_skb(skb);
+	u16 msg_len;
+	int ret;
+
+	ret = es58x_check_msg_max_len(es58x_dev->dev,
+				      es58x_fd_urb_cmd->tx_can_msg_buf,
+				      es58x_fd_get_msg_len(urb_cmd) +
+				      sizeof(*tx_can_msg));
+	if (ret)
+		return ret;
+
+	msg_len = get_unaligned_le16(&es58x_fd_urb_cmd->msg_len);
+	tx_can_msg = (struct es58x_fd_tx_can_msg *)
+	    &es58x_fd_urb_cmd->tx_can_msg_buf[msg_len];
+
+	/* Fill message contents. */
+	if (*urb_cmd_len == es58x_dev->param->urb_cmd_header_len)
+		es58x_fd_fill_urb_header(urb_cmd,
+					 is_fd ? ES58X_FD_CMD_TYPE_CANFD
+					       : ES58X_FD_CMD_TYPE_CAN,
+					 ES58X_FD_CAN_CMD_ID_TX_MSG_NO_ACK,
+					 priv->channel_idx, *urb_cmd_len);
+	tx_can_msg->packet_idx = priv->tx_head + priv->tx_can_msg_cnt;
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
+	*urb_cmd_len = es58x_get_urb_cmd_len(es58x_dev, msg_len);
+	put_unaligned_le16(msg_len, &es58x_fd_urb_cmd->msg_len);
+
+	return 0;
+}
+
+/* ES58X uses the same command to set the bittiming parameters and
+ * enable the channel. The modification is done in
+ * es58x_fd_enable_channel().
+ */
+static int es58x_fd_set_bittiming(struct es58x_priv *priv)
+{
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
+	bool is_can_fd = false;
+	size_t conf_len = 0;
+
+	es58x_fd_convert_bittiming(&tx_conf_msg.nominal_bittiming,
+				   &priv->can.bittiming);
+	ctrlmode = priv->can.ctrlmode;
+
+	tx_conf_msg.samples_per_bit =
+	    ctrlmode & CAN_CTRLMODE_3_SAMPLES ?
+	    ES58X_SAMPLES_PER_BIT_THREE : ES58X_SAMPLES_PER_BIT_ONE;
+	tx_conf_msg.sync_edge = ES58X_SYNC_EDGE_SINGLE;
+	tx_conf_msg.physical_layer = ES58X_PHYSICAL_LAYER_HIGH_SPEED;
+	tx_conf_msg.self_reception_mode = ES58X_SELF_RECEPTION_ON;
+
+	tx_conf_msg.ctrlmode |=
+	    ctrlmode & CAN_CTRLMODE_LISTENONLY ?
+	    ES58X_FD_CTRLMODE_PASSIVE : ES58X_FD_CTRLMODE_ACTIVE;
+
+	conf_len = ES58X_FD_CAN_CONF_LEN;
+	if (ctrlmode & CAN_CTRLMODE_FD) {
+		tx_conf_msg.ctrlmode |= ES58X_FD_CTRLMODE_FD_ISO;
+		is_can_fd = true;
+	} else if (ctrlmode & CAN_CTRLMODE_FD_NON_ISO) {
+		tx_conf_msg.ctrlmode |= ES58X_FD_CTRLMODE_FD_NON_ISO;
+		is_can_fd = true;
+	}
+	if (is_can_fd) {
+		struct can_bittiming *dbt = &priv->can.data_bittiming;
+		int tdco = 0;
+
+		conf_len = ES58X_FD_CANFD_CONF_LEN;
+
+		tx_conf_msg.canfd_enabled = !!is_can_fd;
+		es58x_fd_convert_bittiming(&tx_conf_msg.data_bittiming, dbt);
+
+		/* As specified in ISO 11898-1 section 11.3.3
+		 * "Transmitter delay compensation" (TDC) is only
+		 * applicable if data BRP is one or two.
+		 */
+		tx_conf_msg.tdc = (dbt->brp == 1) || (dbt->brp == 2);
+		if (tx_conf_msg.tdc) {
+			/* Set the Transmitter Delay Compensation
+			 * offset as the duration (in time quanta)
+			 * from the start of the bit to the sample
+			 * point.
+			 */
+			tdco = can_bit_time(dbt) * dbt->sample_point / 1000;
+		}
+		tx_conf_msg.tdco = cpu_to_le16(min_t(u16, 127, tdco));
+		tx_conf_msg.tdcf = cpu_to_le16(0);
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
+static int es58x_fd_reset_rx(struct es58x_priv *priv)
+{
+	struct net_device *netdev = priv->es58x_dev->netdev[priv->channel_idx];
+
+	return es58x_send_msg(priv->es58x_dev, es58x_fd_cmd_type(netdev),
+			      ES58X_FD_CAN_CMD_ID_RESET_RX, ES58X_EMPTY_MSG,
+			      0,  priv->channel_idx);
+}
+
+static int es58x_fd_reset_tx(struct es58x_priv *priv)
+{
+	struct net_device *netdev = priv->es58x_dev->netdev[priv->channel_idx];
+
+	return es58x_send_msg(priv->es58x_dev, es58x_fd_cmd_type(netdev),
+			      ES58X_FD_CAN_CMD_ID_RESET_TX, ES58X_EMPTY_MSG,
+			      0, priv->channel_idx);
+}
+
+static int es58x_fd_get_timestamp(struct es58x_device *es58x_dev)
+{
+	return es58x_send_msg(es58x_dev, ES58X_FD_CMD_TYPE_DEVICE,
+			      ES58X_FD_DEV_CMD_ID_TIMESTAMP, ES58X_EMPTY_MSG,
+			      0, ES58X_CHANNEL_IDX_NA);
+}
+
+/* struct es58x_fd_nom_bittiming_const - Nominal bittiming constants.
+ *
+ * Nominal bittiming constants for ES582.1 and ES584.1 as specified in
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
+/* struct es58x_fd_data_bittiming_const - Data bittiming constants.
+ *
+ * Data bittiming constants for ES582.1 and ES584.1 as specified in
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
+const struct es58x_parameters es58x_fd_param = {
+	.bittiming_const = &es58x_fd_nom_bittiming_const,
+	.data_bittiming_const = &es58x_fd_data_bittiming_const,
+	/* The devices use NXP TJA1044G transievers which guarantee
+	 * the timing for data rates up to 5 Mbps. Bitrates up to 8
+	 * Mbps work in an optimal environment but are not recommended
+	 * for production environment.
+	 */
+	.bitrate_max = ES58X_MBPS(8),
+	.clock = {.freq = ES58X_MHZ(80)},
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
+	 * on the rx_loopback_msg were witnessed when the device is
+	 * recovering from bus off.
+	 *
+	 * For above reasons, a value that would prevent the device
+	 * from becoming busy was chosen. In practice, BQL would
+	 * prevent the value from even getting closer to below
+	 * maximum, so no impact on performance was measured.
+	 */
+	.fifo_mask = 255, /* echo_skb_max = 256 */
+#ifdef CONFIG_BQL
+	/* Empirical value. */
+	.dql_limit_min = CAN_FRAME_LEN_MAX * 15,
+#endif
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
+	.set_bittiming = es58x_fd_set_bittiming,
+	.enable_channel = es58x_fd_enable_channel,
+	.disable_channel = es58x_fd_disable_channel,
+	.reset_rx = es58x_fd_reset_rx,
+	.reset_tx = es58x_fd_reset_tx,
+	.get_timestamp = es58x_fd_get_timestamp
+};
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
new file mode 100644
index 000000000000..b340d64a2d16
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
+ * Copyright (C) 2019 Robert Bosch Engineering and Business
+ * Solutions. All rights reserved.
+ * Copyright (C) 2020 ETAS K.K.. All rights reserved.
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
+#define ES58X_FD_RX_LOOPBACK_BULK_MAX 100
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
+	ES58X_FD_CAN_CMD_ID_MSG_SELFRX_ACK = 0x07,
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
+ * @ES58X_FD_CTRLMODE_FD_ISO: CAN FD according to ISO11898-1.
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
+	ES58X_FD_CTRLMODE_FD_ISO = BIT(4),
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
+ * @self_reception_mode: type enum es58x_self_reception_mode.
+ * @ctrlmode: type enum es58x_fd_ctrlmode.
+ * @canfd_enabled: boolean (0: Classical CAN, 1: CAN and/or CANFD).
+ * @data_bittiming: Bittiming for flexible data-rate transmission.
+ * @tdc: Transmitter Delay Compensation switch (0: disabled, 1:
+ *	enabled). On very high bitrates, the delay between when the
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
+	u8 self_reception_mode;
+	u8 ctrlmode;
+	u8 canfd_enabled;
+	struct es58x_fd_bittiming data_bittiming;
+	u8 tdc;
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
+struct es58x_fd_rx_loopback_msg {
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
+ * @rx_loopback_msg: Array of loopback messages.
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
+		struct es58x_fd_rx_loopback_msg
+		 rx_loopback_msg[ES58X_FD_RX_LOOPBACK_BULK_MAX];
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
2.26.2

