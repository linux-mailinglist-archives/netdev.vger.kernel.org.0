Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819133D5B6C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhGZNe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhGZNdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDAAC0619F2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002Rw-Tv
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9F1BE6582E8
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7D7B165821C;
        Mon, 26 Jul 2021 14:12:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8ab2f979;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 40/46] can: etas_es58x: use devm_kzalloc() to allocate device resources
Date:   Mon, 26 Jul 2021 16:11:38 +0200
Message-Id: <20210726141144.862529-41-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
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

Replace kzalloc() with devm_kzalloc(). By doing this, we do not need
to care anymore about having to call kfree(). This result in a
simpler and more easy to read code.

Link: https://lore.kernel.org/r/20210628155420.1176217-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 7650e349cae1..d2bb1b56f962 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2185,7 +2185,8 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 		ops = &es581_4_ops;
 	}
 
-	es58x_dev = kzalloc(es58x_sizeof_es58x_device(param), GFP_KERNEL);
+	es58x_dev = devm_kzalloc(dev, es58x_sizeof_es58x_device(param),
+				 GFP_KERNEL);
 	if (!es58x_dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -2235,7 +2236,7 @@ static int es58x_probe(struct usb_interface *intf,
 
 	ret = es58x_get_product_info(es58x_dev);
 	if (ret)
-		goto cleanup_es58x_dev;
+		return ret;
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		ret = es58x_init_netdev(es58x_dev, ch_idx);
@@ -2251,8 +2252,6 @@ static int es58x_probe(struct usb_interface *intf,
 			unregister_candev(es58x_dev->netdev[ch_idx]);
 			free_candev(es58x_dev->netdev[ch_idx]);
 		}
- cleanup_es58x_dev:
-	kfree(es58x_dev);
 
 	return ret;
 }
@@ -2283,8 +2282,6 @@ static void es58x_disconnect(struct usb_interface *intf)
 	}
 
 	es58x_free_urbs(es58x_dev);
-
-	kfree(es58x_dev);
 	usb_set_intfdata(intf, NULL);
 }
 
-- 
2.30.2


