Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4221436B0F2
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhDZJqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhDZJqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:46:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E2A61075;
        Mon, 26 Apr 2021 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619430360;
        bh=qpsdBN6ORDIHKKWXNLHLog5L3frURDHaOI1Eg49/jDw=;
        h=From:To:Cc:Subject:Date:From;
        b=eCvxwAUO+BFi7IJ3TozokehnYq5mw16uyk/RuXzPEWJtfDuOBqsbb47lfK5Mp5vNS
         wI9AOTNYUvdvTk2+4MSVKuMsShA6vD3bNrprf7kgVI//ciAGLqpdXIztWeR3p5wsvO
         LYIKbOiGoeC21CLg4KwAouroC2xWxIhyCON0sbHD5fe30fibuGPqaiOD9m4OamQsnq
         rk0r14Y/ue8IS8JA4BkR9sbn4+Ftv7z0uhfmt+l62xOL6enmYR/dWms2bLUIFaG1Bt
         58TroM3D+7u1HTrOHbZ3F2dhGZ4BXIUW8GHHNDmKp+S/OJ1gOkaqauD6Dp2Ba24y/e
         aZzaUTbgITCUg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1laxog-0005t0-I6; Mon, 26 Apr 2021 11:46:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH net] net: hso: fix NULL-deref on tty registration failure
Date:   Mon, 26 Apr 2021 11:45:42 +0200
Message-Id: <20210426094542.22578-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If resource allocation and registration fail for a muxed tty device
(e.g. if there are no more minor numbers) the driver should not try to
deregister the never-registered tty.

Fix up the error handling to avoid dereferencing a NULL pointer when
attempting to remove the character device:

	BUG: kernel NULL pointer dereference, address: 0000000000000064
	[...]
	RIP: 0010:cdev_del+0x4/0x20
	[...]
	Call Trace:
	 tty_unregister_device+0x34/0x50
	 hso_probe+0x1d1/0x57e [hso]

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index cfad5b36bd8e..81ff54e9587f 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2710,14 +2710,14 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 
 	serial = kzalloc(sizeof(*serial), GFP_KERNEL);
 	if (!serial)
-		goto exit;
+		goto err_free_dev;
 
 	hso_dev->port_data.dev_serial = serial;
 	serial->parent = hso_dev;
 
 	if (hso_serial_common_create
 	    (serial, 1, CTRL_URB_RX_SIZE, CTRL_URB_TX_SIZE))
-		goto exit;
+		goto err_free_serial;
 
 	serial->tx_data_length--;
 	serial->write_data = hso_mux_serial_write_data;
@@ -2733,11 +2733,9 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 	/* done, return it */
 	return hso_dev;
 
-exit:
-	if (serial) {
-		tty_unregister_device(tty_drv, serial->minor);
-		kfree(serial);
-	}
+err_free_serial:
+	kfree(serial);
+err_free_dev:
 	kfree(hso_dev);
 	return NULL;
 
-- 
2.26.3

