Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B353D40F59A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbhIQKNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhIQKNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4118560FA0;
        Fri, 17 Sep 2021 10:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631873543;
        bh=xY8J/j9qUaGYAGoqvQX5HhO1EN2JZ/E6yJSFEt2XZwc=;
        h=From:To:Cc:Subject:Date:From;
        b=gAacma7HG6O7VlmSYz4HuMuOUkiuQGtRQnzJbIJlRe70IcyRnEEHzc7f2i4scd4Ne
         TV3okVfzInNNFuyV5+3XUQzJXM/KIRz/Qh8zeE5SrfwoYJz5/8VaHKlyKKbJ0WQhHB
         JsH6uYXtEa81r3gxsUsVo6jKdN/0Sr0WU13uAPHp3tdwrzM1+vKZNy/vRQY19OBEPM
         R0y3Me9EQc+2K6Y0ZRWpBR8l47CdyaAX3TlgJc09715UI3rWuVepikMic0pibf3DwV
         yWj7V5plqjk+kqSYmdlA1NAJzVBWfQmOSCRFVcL5ADTn3ZvAOUGNcGCZpDErqWhv/9
         qvvabsGOP473A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRAr1-0002eR-OZ; Fri, 17 Sep 2021 12:12:24 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH net] net: hso: fix muxed tty registration
Date:   Fri, 17 Sep 2021 12:12:04 +0200
Message-Id: <20210917101204.10147-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If resource allocation and registration fail for a muxed tty device
(e.g. if there are no more minor numbers) the driver should not try to
deregister the never-registered (or already-deregistered) tty.

Fix up the error handling to avoid dereferencing a NULL pointer when
attempting to remove the character device.

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index a57251ba5991..f97813a4e8d1 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2719,14 +2719,14 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 
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
@@ -2742,11 +2742,9 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
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
2.32.0

