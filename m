Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C6455A9C2
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiFYMHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiFYMGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D422C67C
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YW-0002km-9P
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:28 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D15DD9F204
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CEB509F1D8;
        Sat, 25 Jun 2022 12:04:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 331330ee;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/22] can: etas_es58x: replace es58x_device::rx_max_packet_size by usb_maxpacket()
Date:   Sat, 25 Jun 2022 14:03:26 +0200
Message-Id: <20220625120335.324697-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The field rx_max_packet_size of struct es58x_device in nothing else
than usb_endpoint_descriptor::wMaxPacketSize and can be easily
retrieved using usb_maxpacket(). Also, rx_max_packet_size being used a
single time, there is no merit to cache it locally.

Remove es58x_device::rx_max_packet_size and rely on usb_maxpacket()
instead.

Link: https://lore.kernel.org/all/20220611162037.1507-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 2d73ebbf3836..7353745f92d7 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1707,7 +1707,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 {
 	const struct device *dev = es58x_dev->dev;
 	const struct es58x_parameters *param = es58x_dev->param;
-	size_t rx_buf_len = es58x_dev->rx_max_packet_size;
+	u16 rx_buf_len = usb_maxpacket(es58x_dev->udev, es58x_dev->rx_pipe);
 	struct urb *urb;
 	u8 *buf;
 	int i;
@@ -1739,7 +1739,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 		dev_err(dev, "%s: Could not setup any rx URBs\n", __func__);
 		return ret;
 	}
-	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %zu\n",
+	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %u\n",
 		__func__, i, rx_buf_len);
 
 	return ret;
@@ -2223,7 +2223,6 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 					     ep_in->bEndpointAddress);
 	es58x_dev->tx_pipe = usb_sndbulkpipe(es58x_dev->udev,
 					     ep_out->bEndpointAddress);
-	es58x_dev->rx_max_packet_size = le16_to_cpu(ep_in->wMaxPacketSize);
 
 	return es58x_dev;
 }
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index e5033cb5e695..512c5b7a1cfa 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -380,7 +380,6 @@ struct es58x_operators {
  * @timestamps: a temporary buffer to store the time stamps before
  *	feeding them to es58x_can_get_echo_skb(). Can only be used
  *	in RX branches.
- * @rx_max_packet_size: Maximum length of bulk-in URB.
  * @num_can_ch: Number of CAN channel (i.e. number of elements of @netdev).
  * @opened_channel_cnt: number of channels opened. Free of race
  *	conditions because its two users (net_device_ops:ndo_open()
@@ -414,7 +413,6 @@ struct es58x_device {
 
 	u64 timestamps[ES58X_ECHO_BULK_MAX];
 
-	u16 rx_max_packet_size;
 	u8 num_can_ch;
 	u8 opened_channel_cnt;
 
-- 
2.35.1


