Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7C53D5B60
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhGZNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbhGZNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822C1C0619E7
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LZ-0002P2-SB
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:45 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C80D86582D6
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:26 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 53B2465821A;
        Mon, 26 Jul 2021 14:12:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d5624d68;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 39/46] can: etas_es58x: use error pointer during device probing
Date:   Mon, 26 Jul 2021 16:11:37 +0200
Message-Id: <20210726141144.862529-40-mkl@pengutronix.de>
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

Make es58x_init_es58x_dev return a pointer to the allocated structure
instead of returning an integer. Errors are handled through the helper
function ERR_PTR and IS_ERR.

This slightly simplifies the code.

Link: https://lore.kernel.org/r/20210628155420.1176217-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 23 +++++++++------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 4758f793627a..7650e349cae1 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2152,14 +2152,13 @@ static int es58x_get_product_info(struct es58x_device *es58x_dev)
 /**
  * es58x_init_es58x_dev() - Initialize the ES58X device.
  * @intf: USB interface.
- * @p_es58x_dev: pointer to the address of the ES58X device.
  * @driver_info: Quirks of the device.
  *
- * Return: zero on success, errno when any error occurs.
+ * Return: pointer to an ES58X device on success, error pointer when
+ *	any error occurs.
  */
-static int es58x_init_es58x_dev(struct usb_interface *intf,
-				struct es58x_device **p_es58x_dev,
-				kernel_ulong_t driver_info)
+static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
+						 kernel_ulong_t driver_info)
 {
 	struct device *dev = &intf->dev;
 	struct es58x_device *es58x_dev;
@@ -2176,7 +2175,7 @@ static int es58x_init_es58x_dev(struct usb_interface *intf,
 	ret = usb_find_common_endpoints(intf->cur_altsetting, &ep_in, &ep_out,
 					NULL, NULL);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	if (driver_info & ES58X_FD_FAMILY) {
 		param = &es58x_fd_param;
@@ -2188,7 +2187,7 @@ static int es58x_init_es58x_dev(struct usb_interface *intf,
 
 	es58x_dev = kzalloc(es58x_sizeof_es58x_device(param), GFP_KERNEL);
 	if (!es58x_dev)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	es58x_dev->param = param;
 	es58x_dev->ops = ops;
@@ -2213,9 +2212,7 @@ static int es58x_init_es58x_dev(struct usb_interface *intf,
 					     ep_out->bEndpointAddress);
 	es58x_dev->rx_max_packet_size = le16_to_cpu(ep_in->wMaxPacketSize);
 
-	*p_es58x_dev = es58x_dev;
-
-	return 0;
+	return es58x_dev;
 }
 
 /**
@@ -2232,9 +2229,9 @@ static int es58x_probe(struct usb_interface *intf,
 	struct es58x_device *es58x_dev;
 	int ch_idx, ret;
 
-	ret = es58x_init_es58x_dev(intf, &es58x_dev, id->driver_info);
-	if (ret)
-		return ret;
+	es58x_dev = es58x_init_es58x_dev(intf, id->driver_info);
+	if (IS_ERR(es58x_dev))
+		return PTR_ERR(es58x_dev);
 
 	ret = es58x_get_product_info(es58x_dev);
 	if (ret)
-- 
2.30.2


