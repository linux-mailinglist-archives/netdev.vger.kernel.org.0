Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B953F35ACA4
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 12:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhDJKBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 06:01:19 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:57569 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbhDJKBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 06:01:15 -0400
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d06 with ME
        id qy0H2400Q3PnFJp03y0x7t; Sat, 10 Apr 2021 12:00:59 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 10 Apr 2021 12:00:59 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v15 2/3] can: etas_es58x: add support for ETAS ES581.4 CAN USB interface
Date:   Sat, 10 Apr 2021 18:59:47 +0900
Message-Id: <20210410095948.233305-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
References: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the ES581.4 interface from ETAS
GmbH (https://www.etas.com/en/products/es58x.php).

Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/Makefile     |   2 +-
 drivers/net/can/usb/etas_es58x/es581_4.c    | 507 ++++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es581_4.h    | 207 ++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.c |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h |   5 +-
 5 files changed, 726 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h

diff --git a/drivers/net/can/usb/etas_es58x/Makefile b/drivers/net/can/usb/etas_es58x/Makefile
index 60a1ac935a69..e4753ec9cb60 100644
--- a/drivers/net/can/usb/etas_es58x/Makefile
+++ b/drivers/net/can/usb/etas_es58x/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x.o
-etas_es58x-y = es58x_core.o
+etas_es58x-y = es58x_core.o es581_4.o
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
new file mode 100644
index 000000000000..1985f772fc3c
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -0,0 +1,507 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es581_4.c: Adds support to ETAS ES581.4.
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
+#include "es581_4.h"
+
+/**
+ * es581_4_sizeof_rx_tx_msg() - Calculate the actual length of the
+ *	structure of a rx or tx message.
+ * @msg: message of variable length, must have a dlc field.
+ *
+ * Even if RTR frames have actually no payload, the ES58X devices
+ * still expect it. Must be a macro in order to accept several types
+ * (struct es581_4_tx_can_msg and struct es581_4_rx_can_msg) as an
+ * input.
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
+static int es581_4_echo_msg(struct es58x_device *es58x_dev,
+			    const struct es581_4_urb_cmd *es581_4_urb_cmd)
+{
+	struct net_device *netdev;
+	const struct es581_4_bulk_echo_msg *bulk_echo_msg;
+	const struct es581_4_echo_msg *echo_msg;
+	u64 *tstamps = es58x_dev->timestamps;
+	u16 msg_len;
+	u32 first_packet_idx, packet_idx;
+	unsigned int dropped = 0;
+	int i, num_element, ret;
+
+	bulk_echo_msg = &es581_4_urb_cmd->bulk_echo_msg;
+	msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len) -
+	    sizeof(bulk_echo_msg->channel_no);
+	num_element = es58x_msg_num_element(es58x_dev->dev,
+					    bulk_echo_msg->echo_msg, msg_len);
+	if (num_element <= 0)
+		return num_element;
+
+	ret = es58x_get_netdev(es58x_dev, bulk_echo_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	echo_msg = &bulk_echo_msg->echo_msg[0];
+	first_packet_idx = get_unaligned_le32(&echo_msg->packet_idx);
+	packet_idx = first_packet_idx;
+	for (i = 0; i < num_element; i++) {
+		u32 tmp_idx;
+
+		echo_msg = &bulk_echo_msg->echo_msg[i];
+		tmp_idx = get_unaligned_le32(&echo_msg->packet_idx);
+		if (tmp_idx == packet_idx - 1) {
+			if (net_ratelimit())
+				netdev_warn(netdev,
+					    "Received echo packet idx %u twice\n",
+					    packet_idx - 1);
+			dropped++;
+			continue;
+		}
+		if (tmp_idx != packet_idx) {
+			netdev_err(netdev, "Echo packet idx jumped from %u to %u\n",
+				   packet_idx - 1, echo_msg->packet_idx);
+			return -EBADMSG;
+		}
+
+		tstamps[i] = get_unaligned_le64(&echo_msg->timestamp);
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
+		if (channel_no != rx_can_msg->channel_no)
+			return -EBADMSG;
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
+	const struct es581_4_rx_cmd_ret *rx_cmd_ret;
+	u16 msg_len = get_unaligned_le16(&es581_4_urb_cmd->msg_len);
+	int ret;
+
+	ret = es58x_check_msg_len(es58x_dev->dev,
+				  es581_4_urb_cmd->rx_cmd_ret, msg_len);
+	if (ret)
+		return ret;
+
+	rx_cmd_ret = &es581_4_urb_cmd->rx_cmd_ret;
+
+	ret = es58x_get_netdev(es58x_dev, rx_cmd_ret->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	return es58x_rx_cmd_ret_u32(netdev, ret_type,
+				    get_unaligned_le32(&rx_cmd_ret->rx_cmd_ret_le32));
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
+	if (tx_ack_msg->rx_cmd_ret_u8 != ES58X_RET_U8_OK)
+		return es58x_rx_cmd_ret_u8(es58x_dev->dev,
+					   ES58X_RET_TYPE_TX_MSG,
+					   tx_ack_msg->rx_cmd_ret_u8);
+
+	ret = es58x_get_netdev(es58x_dev, tx_ack_msg->channel_no,
+			       ES581_4_CHANNEL_IDX_OFFSET, &netdev);
+	if (ret)
+		return ret;
+
+	return es58x_tx_ack_msg(netdev,
+				get_unaligned_le16(&tx_ack_msg->tx_free_entries),
+				ES58X_RET_U32_OK);
+}
+
+static int es581_4_dispatch_rx_cmd(struct es58x_device *es58x_dev,
+				   const struct es581_4_urb_cmd *es581_4_urb_cmd)
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
+	struct device *dev = es58x_dev->dev;
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
+		es58x_rx_timestamp(es58x_dev,
+				   get_unaligned_le64(&es581_4_urb_cmd->timestamp));
+		return 0;
+
+	case ES581_4_CMD_ID_ECHO:
+		return es581_4_echo_msg(es58x_dev, es581_4_urb_cmd);
+
+	case ES581_4_CMD_ID_DEVICE_ERR:
+		ret = es58x_check_msg_len(dev, es581_4_urb_cmd->rx_cmd_ret_u8,
+					  msg_len);
+		if (ret)
+			return ret;
+		return es58x_rx_cmd_ret_u8(dev, ES58X_RET_TYPE_DEVICE_ERR,
+					   es581_4_urb_cmd->rx_cmd_ret_u8);
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
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct es581_4_tx_can_msg *tx_can_msg;
+	u16 msg_len;
+	int ret;
+
+	if (can_is_canfd_skb(skb))
+		return -EMSGSIZE;
+
+	if (priv->tx_can_msg_cnt == 0) {
+		msg_len = 1; /* struct es581_4_bulk_tx_can_msg:num_can_msg */
+		es581_4_fill_urb_header(urb_cmd, ES581_4_CAN_COMMAND_TYPE,
+					ES581_4_CMD_ID_TX_MSG,
+					priv->channel_idx, msg_len);
+		es581_4_urb_cmd->bulk_tx_can_msg.num_can_msg = 0;
+	} else {
+		msg_len = es581_4_get_msg_len(urb_cmd);
+	}
+
+	ret = es58x_check_msg_max_len(es58x_dev->dev,
+				      es581_4_urb_cmd->bulk_tx_can_msg,
+				      msg_len + sizeof(*tx_can_msg));
+	if (ret)
+		return ret;
+
+	/* Fill message contents. */
+	tx_can_msg = (struct es581_4_tx_can_msg *)
+	    &es581_4_urb_cmd->bulk_tx_can_msg.tx_can_msg_buf[msg_len - 1];
+	put_unaligned_le32(es58x_get_raw_can_id(cf), &tx_can_msg->can_id);
+	put_unaligned_le32(priv->tx_head, &tx_can_msg->packet_idx);
+	put_unaligned_le16((u16)es58x_get_flags(skb), &tx_can_msg->flags);
+	tx_can_msg->channel_no = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+	tx_can_msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+
+	memcpy(tx_can_msg->data, cf->data, cf->len);
+
+	/* Calculate new sizes. */
+	es581_4_urb_cmd->bulk_tx_can_msg.num_can_msg++;
+	msg_len += es581_4_sizeof_rx_tx_msg(*tx_can_msg);
+	priv->tx_urb->transfer_buffer_length = es58x_get_urb_cmd_len(es58x_dev,
+								     msg_len);
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
+	tx_conf_msg.echo_mode = cpu_to_le32(ES58X_ECHO_ON);
+	tx_conf_msg.channel_no = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	return es58x_send_msg(priv->es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_SET_BITTIMING, &tx_conf_msg,
+			      sizeof(tx_conf_msg), priv->channel_idx);
+}
+
+static int es581_4_enable_channel(struct es58x_priv *priv)
+{
+	int ret;
+	u8 msg = priv->channel_idx + ES581_4_CHANNEL_IDX_OFFSET;
+
+	ret = es581_4_set_bittiming(priv);
+	if (ret)
+		return ret;
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
+static int es581_4_reset_device(struct es58x_device *es58x_dev)
+{
+	return es58x_send_msg(es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_RESET_DEVICE,
+			      ES58X_EMPTY_MSG, 0, ES58X_CHANNEL_IDX_NA);
+}
+
+static int es581_4_get_timestamp(struct es58x_device *es58x_dev)
+{
+	return es58x_send_msg(es58x_dev, ES581_4_CAN_COMMAND_TYPE,
+			      ES581_4_CMD_ID_TIMESTAMP,
+			      ES58X_EMPTY_MSG, 0, ES58X_CHANNEL_IDX_NA);
+}
+
+/* Nominal bittiming constants for ES581.4 as specified in the
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
+	.tdc_const = NULL,
+	.bitrate_max = 1 * CAN_MBPS,
+	.clock = {.freq = 50 * CAN_MHZ},
+	.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
+	.tx_start_of_frame = 0xAFAF,
+	.rx_start_of_frame = 0xFAFA,
+	.tx_urb_cmd_max_len = ES581_4_TX_URB_CMD_MAX_LEN,
+	.rx_urb_cmd_max_len = ES581_4_RX_URB_CMD_MAX_LEN,
+	/* Size of internal device TX queue is 330.
+	 *
+	 * However, we witnessed some ES58X_ERR_PROT_CRC errors from
+	 * the device and thus, echo_skb_max was lowered to the
+	 * empirical value of 75 which seems stable and then rounded
+	 * down to become a power of two.
+	 *
+	 * Root cause of those ES58X_ERR_PROT_CRC errors is still
+	 * unclear.
+	 */
+	.fifo_mask = 63, /* echo_skb_max = 64 */
+	.dql_min_limit = CAN_FRAME_LEN_MAX * 50, /* Empirical value. */
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
+	.enable_channel = es581_4_enable_channel,
+	.disable_channel = es581_4_disable_channel,
+	.reset_device = es581_4_reset_device,
+	.get_timestamp = es581_4_get_timestamp
+};
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
new file mode 100644
index 000000000000..4bc60a6df697
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
+ * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
+ * Copyright (c) 2020 ETAS K.K.. All rights reserved.
+ * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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
+#define ES581_4_ECHO_BULK_MAX 30
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
+	ES581_4_CMD_ID_ECHO = 0x71,
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
+ * @echo_mode: type enum es58x_echo_mode.
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
+	__le32 echo_mode;
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
+struct es581_4_echo_msg {
+	__le64 timestamp;
+	__le32 packet_idx;
+} __packed;
+
+struct es581_4_bulk_echo_msg {
+	u8 channel_no;
+	struct es581_4_echo_msg echo_msg[ES581_4_ECHO_BULK_MAX];
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
+	u8 rx_cmd_ret_u8;	/* type enum es58x_cmd_ret_code_u8 */
+} __packed;
+
+struct es581_4_rx_cmd_ret {
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
+ * @bulk_echo_msg: Tx message being looped back.
+ * @rx_err_msg: Error message.
+ * @rx_event_msg: Event message.
+ * @tx_ack_msg: Tx acknowledgment message.
+ * @rx_cmd_ret: Command return code.
+ * @timestamp: Timestamp reply.
+ * @rx_cmd_ret_u8: Rx 8 bits return code (type: enum
+ *	es58x_cmd_ret_code_u8).
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
+		struct es581_4_bulk_echo_msg bulk_echo_msg;
+		struct es581_4_rx_err_msg rx_err_msg;
+		struct es581_4_rx_event_msg rx_event_msg;
+		struct es581_4_tx_ack_msg tx_ack_msg;
+		struct es581_4_rx_cmd_ret rx_cmd_ret;
+		__le64 timestamp;
+		u8 rx_cmd_ret_u8;
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
index b53563d5c542..cc003c62bee2 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -27,10 +27,15 @@ MODULE_LICENSE("GPL v2");
 
 #define ES58X_MODULE_NAME "etas_es58x"
 #define ES58X_VENDOR_ID 0x108C
+#define ES581_4_PRODUCT_ID 0x0159
 
 /* Table of devices which work with this driver. */
 static const struct usb_device_id es58x_id_table[] = {
 	{
+		/* ETAS GmbH ES581.4 USB dual-channel CAN Bus Interface module. */
+		USB_DEVICE(ES58X_VENDOR_ID, ES581_4_PRODUCT_ID),
+		.driver_info = ES58X_DUAL_CHANNEL
+	}, {
 		/* Terminating entry */
 	}
 };
@@ -2162,8 +2167,8 @@ static int es58x_init_es58x_dev(struct usb_interface *intf,
 		return -ENODEV;
 		/* Place holder for es58x_fd glue code. */
 	} else {
-		return -ENODEV;
-		/* Place holder for es581_4 glue code. */
+		param = &es581_4_param;
+		ops = &es581_4_ops;
 	}
 
 	es58x_dev = kzalloc(es58x_sizeof_es58x_device(param), GFP_KERNEL);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index ccced39d5d81..0e7a7dcc48d4 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -18,11 +18,13 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 
+#include "es581_4.h"
+
 /* Driver constants */
 #define ES58X_RX_URBS_MAX 5	/* Empirical value */
 #define ES58X_TX_URBS_MAX 6	/* Empirical value */
 
-#define ES58X_MAX(param) 0
+#define ES58X_MAX(param) (ES581_4_##param)
 #define ES58X_TX_BULK_MAX ES58X_MAX(TX_BULK_MAX)
 #define ES58X_RX_BULK_MAX ES58X_MAX(RX_BULK_MAX)
 #define ES58X_ECHO_BULK_MAX ES58X_MAX(ECHO_BULK_MAX)
@@ -210,6 +212,7 @@ enum es58x_ret_type {
 };
 
 union es58x_urb_cmd {
+	struct es581_4_urb_cmd es581_4_urb_cmd;
 	struct {		/* Common header parts of all variants */
 		__le16 sof;
 		u8 cmd_type;
-- 
2.26.3

