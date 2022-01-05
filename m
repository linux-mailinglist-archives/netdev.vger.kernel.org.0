Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5F74854E1
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbiAEOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241025AbiAEOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CD9C061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WT-0004C4-04
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:17 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 630696D1B0B
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8F4836D1AC5;
        Wed,  5 Jan 2022 14:44:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d952fa11;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/15] can: kvaser_usb: do not increase tx statistics when sending error message frames
Date:   Wed,  5 Jan 2022 15:43:55 +0100
Message-Id: <20220105144402.1174191-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The CAN error message frames (i.e. error skb) are an interface
specific to socket CAN. The payload of the CAN error message frames
does not correspond to any actual data sent on the wire. Only an error
flag and a delimiter are transmitted when an error occurs (c.f. ISO
11898-1 section 10.4.4.2 "Error flag").

For this reason, it makes no sense to increment the tx_packets and
tx_bytes fields of struct net_device_stats when sending an error
message frame because no actual payload will be transmitted on the
wire.

N.B. Sending error message frames is a very specific feature which, at
the moment, is only supported by the Kvaser Hydra hardware. Please
refer to [1] for more details on the topic.

[1] https://lore.kernel.org/linux-can/CAMZ6RqK0rTNg3u3mBpZOoY51jLZ-et-J01tY6-+mWsM4meVw-A@mail.gmail.com/t/#u

Link: https://lore.kernel.org/all/20211207121531.42941-3-mailhol.vincent@wanadoo.fr
Co-developed-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 8e2ff08d1083..60e7c5f27a5f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -296,6 +296,7 @@ struct kvaser_cmd {
 #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN	BIT(1)
 #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME	BIT(4)
 #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID	BIT(5)
+#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK		BIT(6)
 /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
 #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK	BIT(12)
 #define KVASER_USB_HYDRA_CF_FLAG_ABL		BIT(13)
@@ -1114,6 +1115,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	struct kvaser_usb_net_priv *priv;
 	unsigned long irq_flags;
 	bool one_shot_fail = false;
+	bool is_err_frame = false;
 	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
 
 	priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
@@ -1132,10 +1134,13 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 			kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
 			one_shot_fail = true;
 		}
+
+		is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
+			       flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
 	}
 
 	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-	if (!one_shot_fail) {
+	if (!one_shot_fail && !is_err_frame) {
 		struct net_device_stats *stats = &priv->netdev->stats;
 
 		stats->tx_packets++;
-- 
2.34.1


