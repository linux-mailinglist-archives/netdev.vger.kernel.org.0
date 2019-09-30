Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8AC2405
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbfI3PND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:13:03 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39652 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731276AbfI3PND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:13:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so9898018ljj.6;
        Mon, 30 Sep 2019 08:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Bfo0rr9vkrHOZNoCbxCpYEVjTK+dS54moPMT8PgtP0=;
        b=dgLc7SLMxhZ70hz7jiMmM6pvd9H5Olpzoyuhveqobd1dQI0XQfUgNvEcmiIejo1j5p
         pbtSw5G5V6B+uv01NjmPh8MKj3qpC04EiWunzdKHt0USXTxIMH7x39HB0uGaCztHe3fh
         3GIi1+Ctti0RRYrdh9fIVvt0twPQ5YRRrKlTOX3R7Lei7gYCQpOgvECoIJjdKYXeeCgg
         HAWX0WFCWd2BTVCmStgTWEM1f8y+3/TaDxevQrpDkBY5E4j3TZ4JbwxXR31oKWTXbK/i
         aXvySa0EIcK5WdPmgUwiEI8mEzsI/Vu9oa9L0hO5m7C33AdSglYCrw++HRYymhxMlqFG
         XHDw==
X-Gm-Message-State: APjAAAXljj85k6GWKiH8OnS8ef1r5C0GXmHB3OmcBjU/cj1r/RuKWsmH
        VBqHzeG7TAxyfQkcEAxuGKA=
X-Google-Smtp-Source: APXvYqwg/FEkVQ/xSlVzbMY3fcdyuxPargpqGNsa//amQHjHrZTEzZ+oIBnQVVZMZ0XsPRnoL1Om3g==
X-Received: by 2002:a2e:8184:: with SMTP id e4mr12785036ljg.240.1569856381011;
        Mon, 30 Sep 2019 08:13:01 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id n11sm3292479lfe.59.2019.09.30.08.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:13:00 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iExMH-0006gf-Pd; Mon, 30 Sep 2019 17:13:06 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net] hso: fix NULL-deref on tty open
Date:   Mon, 30 Sep 2019 17:12:41 +0200
Message-Id: <20190930151241.25646-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix NULL-pointer dereference on tty open due to a failure to handle a
missing interrupt-in endpoint when probing modem ports:

	BUG: kernel NULL pointer dereference, address: 0000000000000006
	...
	RIP: 0010:tiocmget_submit_urb+0x1c/0xe0 [hso]
	...
	Call Trace:
	hso_start_serial_device+0xdc/0x140 [hso]
	hso_serial_open+0x118/0x1b0 [hso]
	tty_open+0xf1/0x490

Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ce78714f536f..a505b2ab88b8 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2620,14 +2620,18 @@ static struct hso_device *hso_create_bulk_serial_device(
 		 */
 		if (serial->tiocmget) {
 			tiocmget = serial->tiocmget;
+			tiocmget->endp = hso_get_ep(interface,
+						    USB_ENDPOINT_XFER_INT,
+						    USB_DIR_IN);
+			if (!tiocmget->endp) {
+				dev_err(&interface->dev, "Failed to find INT IN ep\n");
+				goto exit;
+			}
+
 			tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (tiocmget->urb) {
 				mutex_init(&tiocmget->mutex);
 				init_waitqueue_head(&tiocmget->waitq);
-				tiocmget->endp = hso_get_ep(
-					interface,
-					USB_ENDPOINT_XFER_INT,
-					USB_DIR_IN);
 			} else
 				hso_free_tiomget(serial);
 		}
-- 
2.23.0

