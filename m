Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1D82BAB59
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgKTNeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgKTNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F7AC061A4D
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XV-0006Fn-RQ; Fri, 20 Nov 2020 14:33:25 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 10/25] can: drivers: add len8_dlc support for esd_usb2 CAN adapter
Date:   Fri, 20 Nov 2020 14:33:03 +0100
Message-Id: <20201120133318.3428231-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Mätje <Stefan.Maetje@esd.eu>

Support the Classical CAN raw DLC functionality to send and receive DLC values
from 9 .. 15 for the Classical CAN capable CAN network driver esd_usb that
supports the esd CAN-USB/2 and CAN-USB/Micro devices:

- esd_usb2

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Tested-by: Stefan Mätje <stefan.maetje@esd.eu>
Link: https://lore.kernel.org/r/20201116184430.25462-2-stefan.maetje@esd.eu
[mkl: rewrapped some long lines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb2.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 3643a8ee03cf..9eed75a4b678 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -183,7 +183,7 @@ struct esd_usb2_net_priv;
 struct esd_tx_urb_context {
 	struct esd_usb2_net_priv *priv;
 	u32 echo_index;
-	int dlc;
+	int len;	/* CAN payload length */
 };
 
 struct esd_usb2 {
@@ -321,7 +321,8 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		cf->len = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
+		can_frame_set_cc_len(cf, msg->msg.rx.dlc & ~ESD_RTR,
+				     priv->can.ctrlmode);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
@@ -355,7 +356,7 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 
 	if (!msg->msg.txdone.status) {
 		stats->tx_packets++;
-		stats->tx_bytes += context->dlc;
+		stats->tx_bytes += context->len;
 		can_get_echo_skb(netdev, context->echo_index);
 	} else {
 		stats->tx_errors++;
@@ -737,7 +738,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	msg->msg.hdr.len = 3; /* minimal length */
 	msg->msg.hdr.cmd = CMD_CAN_TX;
 	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = cf->len;
+	msg->msg.tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
 	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
@@ -769,7 +770,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->len;
+	context->len = cf->len;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
 	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
@@ -988,7 +989,8 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
 	priv->index = index;
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
+		CAN_CTRLMODE_CC_LEN8_DLC;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
-- 
2.29.2

