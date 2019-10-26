Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B53E5C28
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfJZN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfJZNUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECA8D206DD;
        Sat, 26 Oct 2019 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096052;
        bh=ZbaRqPpNCSUJatQuWjo3ZGisq+XCjNCR5k/e3FVr3B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiXaxECsqooSHFBzrssbij67lwOBn0rbb01w6GyZXzH3R5djcxa/jwXotgOHZrsxO
         yXOWeliJmgrwa2KmhSsO2NidUPLAy4J43yWc9ujLMhZN8jSUdd5pjNDoW3scozJ6tq
         ugvSbz+0qFmkRAghTnHDVnV7+BJk5FeD3H45NqxY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/59] usb: hso: obey DMA rules in tiocmget
Date:   Sat, 26 Oct 2019 09:19:03 -0400
Message-Id: <20191026131910.3435-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit af0de1303c4e8f44fadd7b4c593f09f22324b04f ]

The serial state information must not be embedded into another
data structure, as this interferes with cache handling for DMA
on architectures without cache coherence..
That would result in data corruption on some architectures
Allocating it separately.

v2: fix syntax error

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/hso.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 5251c5f6f96ed..a7b612f6470cb 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -200,7 +200,7 @@ struct hso_tiocmget {
 	int    intr_completed;
 	struct usb_endpoint_descriptor *endp;
 	struct urb *urb;
-	struct hso_serial_state_notification serial_state_notification;
+	struct hso_serial_state_notification *serial_state_notification;
 	u16    prev_UART_state_bitmap;
 	struct uart_icount icount;
 };
@@ -1446,7 +1446,7 @@ static int tiocmget_submit_urb(struct hso_serial *serial,
 			 usb_rcvintpipe(usb,
 					tiocmget->endp->
 					bEndpointAddress & 0x7F),
-			 &tiocmget->serial_state_notification,
+			 tiocmget->serial_state_notification,
 			 sizeof(struct hso_serial_state_notification),
 			 tiocmget_intr_callback, serial,
 			 tiocmget->endp->bInterval);
@@ -1493,7 +1493,7 @@ static void tiocmget_intr_callback(struct urb *urb)
 	/* wIndex should be the USB interface number of the port to which the
 	 * notification applies, which should always be the Modem port.
 	 */
-	serial_state_notification = &tiocmget->serial_state_notification;
+	serial_state_notification = tiocmget->serial_state_notification;
 	if (serial_state_notification->bmRequestType != BM_REQUEST_TYPE ||
 	    serial_state_notification->bNotification != B_NOTIFICATION ||
 	    le16_to_cpu(serial_state_notification->wValue) != W_VALUE ||
@@ -2579,6 +2579,8 @@ static void hso_free_tiomget(struct hso_serial *serial)
 		usb_free_urb(tiocmget->urb);
 		tiocmget->urb = NULL;
 		serial->tiocmget = NULL;
+		kfree(tiocmget->serial_state_notification);
+		tiocmget->serial_state_notification = NULL;
 		kfree(tiocmget);
 	}
 }
@@ -2629,10 +2631,13 @@ static struct hso_device *hso_create_bulk_serial_device(
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
2.20.1

