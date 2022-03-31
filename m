Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B84ED619
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiCaIsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiCaIse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:48:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4E1F9763
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:46:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZqS2-0000Gr-4F
        for netdev@vger.kernel.org; Thu, 31 Mar 2022 10:46:42 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 34A8A57A14
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7451C579DF;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c6123146;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 7/8] can: mcba_usb: properly check endpoint type
Date:   Thu, 31 Mar 2022 10:46:33 +0200
Message-Id: <20220331084634.869744-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

Syzbot reported warning in usb_submit_urb() which is caused by wrong
endpoint type. We should check that in endpoint is actually present to
prevent this warning.

Found pipes are now saved to struct mcba_priv and code uses them
directly instead of making pipes in place.

Fail log:

| usb 5-1: BOGUS urb xfer, pipe 3 != type 1
| WARNING: CPU: 1 PID: 49 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
| Modules linked in:
| CPU: 1 PID: 49 Comm: kworker/1:2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
| Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
| Workqueue: usb_hub_wq hub_event
| RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
| ...
| Call Trace:
|  <TASK>
|  mcba_usb_start drivers/net/can/usb/mcba_usb.c:662 [inline]
|  mcba_usb_probe+0x8a3/0xc50 drivers/net/can/usb/mcba_usb.c:858
|  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
|  call_driver_probe drivers/base/dd.c:517 [inline]

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Link: https://lore.kernel.org/all/20220313100903.10868-1-paskripkin@gmail.com
Reported-and-tested-by: syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/mcba_usb.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 7c198eb5bc9c..c45a814e1de2 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -33,10 +33,6 @@
 #define MCBA_USB_RX_BUFF_SIZE 64
 #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
 
-/* MCBA endpoint numbers */
-#define MCBA_USB_EP_IN 1
-#define MCBA_USB_EP_OUT 1
-
 /* Microchip command id */
 #define MBCA_CMD_RECEIVE_MESSAGE 0xE3
 #define MBCA_CMD_I_AM_ALIVE_FROM_CAN 0xF5
@@ -83,6 +79,8 @@ struct mcba_priv {
 	atomic_t free_ctx_cnt;
 	void *rxbuf[MCBA_MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
+	int rx_pipe;
+	int tx_pipe;
 };
 
 /* CAN frame */
@@ -268,10 +266,8 @@ static netdev_tx_t mcba_usb_xmit(struct mcba_priv *priv,
 
 	memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
 
-	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
-			  MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
-			  ctx);
+	usb_fill_bulk_urb(urb, priv->udev, priv->tx_pipe, buf, MCBA_USB_TX_BUFF_SIZE,
+			  mcba_usb_write_bulk_callback, ctx);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &priv->tx_submitted);
@@ -607,7 +603,7 @@ static void mcba_usb_read_bulk_callback(struct urb *urb)
 resubmit_urb:
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
+			  priv->rx_pipe,
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
@@ -652,7 +648,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		urb->transfer_dma = buf_dma;
 
 		usb_fill_bulk_urb(urb, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
+				  priv->rx_pipe,
 				  buf, MCBA_USB_RX_BUFF_SIZE,
 				  mcba_usb_read_bulk_callback, priv);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -806,6 +802,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
 	struct mcba_priv *priv;
 	int err;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *in, *out;
+
+	err = usb_find_common_endpoints(intf->cur_altsetting, &in, &out, NULL, NULL);
+	if (err) {
+		dev_err(&intf->dev, "Can't find endpoints\n");
+		return err;
+	}
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
 	if (!netdev) {
@@ -851,6 +854,9 @@ static int mcba_usb_probe(struct usb_interface *intf,
 		goto cleanup_free_candev;
 	}
 
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
+
 	devm_can_led_init(netdev);
 
 	/* Start USB dev only if we have successfully registered CAN device */
-- 
2.35.1


