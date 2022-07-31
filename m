Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90650586101
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbiGaTWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238327AbiGaTWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:22:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB58510FD5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:21:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUl-0008FW-He
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6FE4FBED2C
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:41 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CEF03BED0C;
        Sun, 31 Jul 2022 19:20:40 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 64e90c54;
        Sun, 31 Jul 2022 19:20:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 35/36] can: etas_es58x: remove useless calls to usb_fill_bulk_urb()
Date:   Sun, 31 Jul 2022 21:20:28 +0200
Message-Id: <20220731192029.746751-36-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Aside of urb->transfer_buffer_length and urb->context which might
change in the TX path, all the other URB parameters remains constant
during runtime. So, there is no reasons to call usb_fill_bulk_urb()
each time before submitting an URB.

Make sure to initialize all the fields of the URB at allocation
time. For the TX branch, replace the call usb_fill_bulk_urb() by an
assignment of urb->context. urb->urb->transfer_buffer_length is
already set by the caller functions, no need to set it again. For the
RX branch, because all parameters are unchanged, simply remove the
call to usb_fill_bulk_urb().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220729080902.25839-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 3b949e979583..51294b717040 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1460,10 +1460,6 @@ static void es58x_read_bulk_callback(struct urb *urb)
 	}
 
  resubmit_urb:
-	usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->rx_pipe,
-			  urb->transfer_buffer, urb->transfer_buffer_length,
-			  es58x_read_bulk_callback, es58x_dev);
-
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret == -ENODEV) {
 		for (i = 0; i < es58x_dev->num_can_ch; i++)
@@ -1597,7 +1593,8 @@ static struct urb *es58x_get_tx_urb(struct es58x_device *es58x_dev)
 			return NULL;
 
 		usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->tx_pipe,
-				  buf, tx_buf_len, NULL, NULL);
+				  buf, tx_buf_len, es58x_write_bulk_callback,
+				  NULL);
 		return urb;
 	}
 
@@ -1630,9 +1627,7 @@ static int es58x_submit_urb(struct es58x_device *es58x_dev, struct urb *urb,
 	int ret;
 
 	es58x_set_crc(urb->transfer_buffer, urb->transfer_buffer_length);
-	usb_fill_bulk_urb(urb, es58x_dev->udev, es58x_dev->tx_pipe,
-			  urb->transfer_buffer, urb->transfer_buffer_length,
-			  es58x_write_bulk_callback, netdev);
+	urb->context = netdev;
 	usb_anchor_urb(urb, &es58x_dev->tx_urbs_busy);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
-- 
2.35.1


