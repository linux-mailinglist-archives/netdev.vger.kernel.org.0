Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3928C6C9C26
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjC0HeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjC0HeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3B92134
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:06 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMi-0000NL-9F
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:34:04 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5B6CF19CE0B
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:34:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1CCE519CDE5;
        Mon, 27 Mar 2023 07:34:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7fa99cee;
        Mon, 27 Mar 2023 07:33:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/11] can: esd_usb: Improve code readability by means of replacing struct esd_usb_msg with a union
Date:   Mon, 27 Mar 2023 09:33:49 +0200
Message-Id: <20230327073354.1003134-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327073354.1003134-1-mkl@pengutronix.de>
References: <20230327073354.1003134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

As suggested by Vincent Mailhol, declare struct esd_usb_msg as a union
instead of a struct. Then replace all msg->msg.something constructs,
that make use of esd_usb_msg, with simpler and prettier looking
msg->something variants.

Link: https://lore.kernel.org/all/CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20230222163754.3711766-1-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 166 +++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 84 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 55b36973952d..e78bb468115a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -174,17 +174,15 @@ struct set_baudrate_msg {
 };
 
 /* Main message type used between library and application */
-struct __packed esd_usb_msg {
-	union {
-		struct header_msg hdr;
-		struct version_msg version;
-		struct version_reply_msg version_reply;
-		struct rx_msg rx;
-		struct tx_msg tx;
-		struct tx_done_msg txdone;
-		struct set_baudrate_msg setbaud;
-		struct id_filter_msg filter;
-	} msg;
+union __packed esd_usb_msg {
+	struct header_msg hdr;
+	struct version_msg version;
+	struct version_reply_msg version_reply;
+	struct rx_msg rx;
+	struct tx_msg tx;
+	struct tx_done_msg txdone;
+	struct set_baudrate_msg setbaud;
+	struct id_filter_msg filter;
 };
 
 static struct usb_device_id esd_usb_table[] = {
@@ -229,22 +227,22 @@ struct esd_usb_net_priv {
 };
 
 static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
-			     struct esd_usb_msg *msg)
+			     union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
-	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
+	u32 id = le32_to_cpu(msg->rx.id) & ESD_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.ev_can_err_ext.status;
-		u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
-		u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
-		u8 txerr = msg->msg.rx.ev_can_err_ext.tec;
+		u8 state = msg->rx.ev_can_err_ext.status;
+		u8 ecc = msg->rx.ev_can_err_ext.ecc;
+		u8 rxerr = msg->rx.ev_can_err_ext.rec;
+		u8 txerr = msg->rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+			   msg->rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 
@@ -322,7 +320,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 }
 
 static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
-			       struct esd_usb_msg *msg)
+			       union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
@@ -333,7 +331,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(priv->netdev))
 		return;
 
-	id = le32_to_cpu(msg->msg.rx.id);
+	id = le32_to_cpu(msg->rx.id);
 
 	if (id & ESD_EVENT) {
 		esd_usb_rx_event(priv, msg);
@@ -345,17 +343,17 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		can_frame_set_cc_len(cf, msg->msg.rx.dlc & ~ESD_RTR,
+		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
 				     priv->can.ctrlmode);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
-		if (msg->msg.rx.dlc & ESD_RTR) {
+		if (msg->rx.dlc & ESD_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
 			for (i = 0; i < cf->len; i++)
-				cf->data[i] = msg->msg.rx.data[i];
+				cf->data[i] = msg->rx.data[i];
 
 			stats->rx_bytes += cf->len;
 		}
@@ -366,7 +364,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 }
 
 static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
-				struct esd_usb_msg *msg)
+				union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct net_device *netdev = priv->netdev;
@@ -375,9 +373,9 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(netdev))
 		return;
 
-	context = &priv->tx_contexts[msg->msg.txdone.hnd & (MAX_TX_URBS - 1)];
+	context = &priv->tx_contexts[msg->txdone.hnd & (MAX_TX_URBS - 1)];
 
-	if (!msg->msg.txdone.status) {
+	if (!msg->txdone.status) {
 		stats->tx_packets++;
 		stats->tx_bytes += can_get_echo_skb(netdev, context->echo_index,
 						    NULL);
@@ -417,32 +415,32 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 	}
 
 	while (pos < urb->actual_length) {
-		struct esd_usb_msg *msg;
+		union esd_usb_msg *msg;
 
-		msg = (struct esd_usb_msg *)(urb->transfer_buffer + pos);
+		msg = (union esd_usb_msg *)(urb->transfer_buffer + pos);
 
-		switch (msg->msg.hdr.cmd) {
+		switch (msg->hdr.cmd) {
 		case CMD_CAN_RX:
-			if (msg->msg.rx.net >= dev->net_count) {
+			if (msg->rx.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
 			}
 
-			esd_usb_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
+			esd_usb_rx_can_msg(dev->nets[msg->rx.net], msg);
 			break;
 
 		case CMD_CAN_TX:
-			if (msg->msg.txdone.net >= dev->net_count) {
+			if (msg->txdone.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
 			}
 
-			esd_usb_tx_done_msg(dev->nets[msg->msg.txdone.net],
+			esd_usb_tx_done_msg(dev->nets[msg->txdone.net],
 					    msg);
 			break;
 		}
 
-		pos += msg->msg.hdr.len << 2;
+		pos += msg->hdr.len << 2;
 
 		if (pos > urb->actual_length) {
 			dev_err(dev->udev->dev.parent, "format error\n");
@@ -473,7 +471,7 @@ static void esd_usb_write_bulk_callback(struct urb *urb)
 	struct esd_tx_urb_context *context = urb->context;
 	struct esd_usb_net_priv *priv;
 	struct net_device *netdev;
-	size_t size = sizeof(struct esd_usb_msg);
+	size_t size = sizeof(union esd_usb_msg);
 
 	WARN_ON(!context);
 
@@ -529,20 +527,20 @@ static ssize_t nets_show(struct device *d,
 }
 static DEVICE_ATTR_RO(nets);
 
-static int esd_usb_send_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
+static int esd_usb_send_msg(struct esd_usb *dev, union esd_usb_msg *msg)
 {
 	int actual_length;
 
 	return usb_bulk_msg(dev->udev,
 			    usb_sndbulkpipe(dev->udev, 2),
 			    msg,
-			    msg->msg.hdr.len << 2,
+			    msg->hdr.len << 2,
 			    &actual_length,
 			    1000);
 }
 
 static int esd_usb_wait_msg(struct esd_usb *dev,
-			    struct esd_usb_msg *msg)
+			    union esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -630,7 +628,7 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
 	struct esd_usb *dev = priv->usb;
 	struct net_device *netdev = priv->netdev;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int err, i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -651,14 +649,14 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	 * the number of the starting bitmask (0..64) to the filter.option
 	 * field followed by only some bitmasks.
 	 */
-	msg->msg.hdr.cmd = CMD_IDADD;
-	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
-	msg->msg.filter.net = priv->index;
-	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
+	msg->hdr.cmd = CMD_IDADD;
+	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->filter.net = priv->index;
+	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i < ESD_MAX_ID_SEGMENT; i++)
-		msg->msg.filter.mask[i] = cpu_to_le32(0xffffffff);
+		msg->filter.mask[i] = cpu_to_le32(0xffffffff);
 	/* enable 29bit extended IDs */
-	msg->msg.filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
+	msg->filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err)
@@ -734,12 +732,12 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	struct esd_tx_urb_context *context = NULL;
 	struct net_device_stats *stats = &netdev->stats;
 	struct can_frame *cf = (struct can_frame *)skb->data;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	struct urb *urb;
 	u8 *buf;
 	int i, err;
 	int ret = NETDEV_TX_OK;
-	size_t size = sizeof(struct esd_usb_msg);
+	size_t size = sizeof(union esd_usb_msg);
 
 	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
@@ -761,24 +759,24 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		goto nobufmem;
 	}
 
-	msg = (struct esd_usb_msg *)buf;
+	msg = (union esd_usb_msg *)buf;
 
-	msg->msg.hdr.len = 3; /* minimal length */
-	msg->msg.hdr.cmd = CMD_CAN_TX;
-	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
-	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
+	msg->hdr.len = 3; /* minimal length */
+	msg->hdr.cmd = CMD_CAN_TX;
+	msg->tx.net = priv->index;
+	msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
-		msg->msg.tx.dlc |= ESD_RTR;
+		msg->tx.dlc |= ESD_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
-		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
+		msg->tx.id |= cpu_to_le32(ESD_EXTID);
 
 	for (i = 0; i < cf->len; i++)
-		msg->msg.tx.data[i] = cf->data[i];
+		msg->tx.data[i] = cf->data[i];
 
-	msg->msg.hdr.len += (cf->len + 3) >> 2;
+	msg->hdr.len += (cf->len + 3) >> 2;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -798,10 +796,10 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	context->echo_index = i;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
-	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
+	msg->tx.hnd = 0x80000000 | i; /* returned in TX done message */
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
-			  msg->msg.hdr.len << 2,
+			  msg->hdr.len << 2,
 			  esd_usb_write_bulk_callback, context);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -855,7 +853,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 static int esd_usb_close(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -863,21 +861,21 @@ static int esd_usb_close(struct net_device *netdev)
 		return -ENOMEM;
 
 	/* Disable all IDs (see esd_usb_start()) */
-	msg->msg.hdr.cmd = CMD_IDADD;
-	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
-	msg->msg.filter.net = priv->index;
-	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
+	msg->hdr.cmd = CMD_IDADD;
+	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->filter.net = priv->index;
+	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
-		msg->msg.filter.mask[i] = 0;
+		msg->filter.mask[i] = 0;
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
-	msg->msg.hdr.len = 2;
-	msg->msg.hdr.cmd = CMD_SETBAUD;
-	msg->msg.setbaud.net = priv->index;
-	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
+	msg->hdr.len = 2;
+	msg->hdr.cmd = CMD_SETBAUD;
+	msg->setbaud.net = priv->index;
+	msg->setbaud.rsvd = 0;
+	msg->setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending setbaud message failed\n");
 
@@ -919,7 +917,7 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	struct can_bittiming *bt = &priv->can.bittiming;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int err;
 	u32 canbtr;
 	int sjw_shift;
@@ -950,11 +948,11 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	if (!msg)
 		return -ENOMEM;
 
-	msg->msg.hdr.len = 2;
-	msg->msg.hdr.cmd = CMD_SETBAUD;
-	msg->msg.setbaud.net = priv->index;
-	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(canbtr);
+	msg->hdr.len = 2;
+	msg->hdr.cmd = CMD_SETBAUD;
+	msg->setbaud.net = priv->index;
+	msg->setbaud.rsvd = 0;
+	msg->setbaud.baud = cpu_to_le32(canbtr);
 
 	netdev_info(netdev, "setting BTR=%#x\n", canbtr);
 
@@ -1065,7 +1063,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct esd_usb *dev;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int i, err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -1087,11 +1085,11 @@ static int esd_usb_probe(struct usb_interface *intf,
 	}
 
 	/* query number of CAN interfaces (nets) */
-	msg->msg.hdr.cmd = CMD_VERSION;
-	msg->msg.hdr.len = 2;
-	msg->msg.version.rsvd = 0;
-	msg->msg.version.flags = 0;
-	msg->msg.version.drv_version = 0;
+	msg->hdr.cmd = CMD_VERSION;
+	msg->hdr.len = 2;
+	msg->version.rsvd = 0;
+	msg->version.flags = 0;
+	msg->version.drv_version = 0;
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err < 0) {
@@ -1105,8 +1103,8 @@ static int esd_usb_probe(struct usb_interface *intf,
 		goto free_msg;
 	}
 
-	dev->net_count = (int)msg->msg.version_reply.nets;
-	dev->version = le32_to_cpu(msg->msg.version_reply.version);
+	dev->net_count = (int)msg->version_reply.nets;
+	dev->version = le32_to_cpu(msg->version_reply.version);
 
 	if (device_create_file(&intf->dev, &dev_attr_firmware))
 		dev_err(&intf->dev,
-- 
2.39.2


