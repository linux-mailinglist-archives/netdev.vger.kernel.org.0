Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9559CDAE39
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394507AbfJQN0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 09:26:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:38830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387959AbfJQN0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 09:26:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2239EADE0;
        Thu, 17 Oct 2019 13:25:59 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, johan@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCHv2] usb: hso: obey DMA rules in tiocmget
Date:   Thu, 17 Oct 2019 15:25:47 +0200
Message-Id: <20191017132548.21888-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The serial state information must not be embedded into another
data structure, as this interferes with cache handling for DMA
on architectures without cache coherence..
That would result in data corruption on some architectures
Allocating it separately.

v2: fix syntax error

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index a505b2ab88b8..74849da031fa 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -186,7 +186,7 @@ struct hso_tiocmget {
 	int    intr_completed;
 	struct usb_endpoint_descriptor *endp;
 	struct urb *urb;
-	struct hso_serial_state_notification serial_state_notification;
+	struct hso_serial_state_notification *serial_state_notification;
 	u16    prev_UART_state_bitmap;
 	struct uart_icount icount;
 };
@@ -1432,7 +1432,7 @@ static int tiocmget_submit_urb(struct hso_serial *serial,
 			 usb_rcvintpipe(usb,
 					tiocmget->endp->
 					bEndpointAddress & 0x7F),
-			 &tiocmget->serial_state_notification,
+			 tiocmget->serial_state_notification,
 			 sizeof(struct hso_serial_state_notification),
 			 tiocmget_intr_callback, serial,
 			 tiocmget->endp->bInterval);
@@ -1479,7 +1479,7 @@ static void tiocmget_intr_callback(struct urb *urb)
 	/* wIndex should be the USB interface number of the port to which the
 	 * notification applies, which should always be the Modem port.
 	 */
-	serial_state_notification = &tiocmget->serial_state_notification;
+	serial_state_notification = tiocmget->serial_state_notification;
 	if (serial_state_notification->bmRequestType != BM_REQUEST_TYPE ||
 	    serial_state_notification->bNotification != B_NOTIFICATION ||
 	    le16_to_cpu(serial_state_notification->wValue) != W_VALUE ||
@@ -2565,6 +2565,8 @@ static void hso_free_tiomget(struct hso_serial *serial)
 		usb_free_urb(tiocmget->urb);
 		tiocmget->urb = NULL;
 		serial->tiocmget = NULL;
+		kfree(tiocmget->serial_state_notification);
+		tiocmget->serial_state_notification = NULL;
 		kfree(tiocmget);
 	}
 }
@@ -2615,10 +2617,13 @@ static struct hso_device *hso_create_bulk_serial_device(
 		num_urbs = 2;
 		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
 					   GFP_KERNEL);
+		serial->tiocmget->serial_state_notification
+			= kzalloc(sizeof(struct hso_serial_state_notification),
+					   GFP_KERNEL);
 		/* it isn't going to break our heart if serial->tiocmget
 		 *  allocation fails don't bother checking this.
 		 */
-		if (serial->tiocmget) {
+		if (serial->tiocmget && serial->tiocmget->serial_state_notification) {
 			tiocmget = serial->tiocmget;
 			tiocmget->endp = hso_get_ep(interface,
 						    USB_ENDPOINT_XFER_INT,
-- 
2.16.4

