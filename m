Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDDF5E7A51
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiIWMSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiIWMQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB2F13C871
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUR-0007Gr-2y
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:07 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 33E29EB132
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3EAEFEB10F;
        Fri, 23 Sep 2022 12:09:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c38cca84;
        Fri, 23 Sep 2022 12:09:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        John Whittington <git@jbrengineering.co.uk>
Subject: [PATCH net-next 03/11] can: gs_usb: gs_usb_get_timestamp(): fix endpoint parameter for usb_control_msg_recv()
Date:   Fri, 23 Sep 2022 14:08:51 +0200
Message-Id: <20220923120859.740577-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923120859.740577-1-mkl@pengutronix.de>
References: <20220923120859.740577-1-mkl@pengutronix.de>
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

The 2nd argument of usb_control_msg_recv() is the "endpoint",
usb_control_msg_recv() will internally convert the endpoint into a
pipe with usb_rcvctrlpipe().

In gs_usb_get_timestamp() not the endpoint "0" is passed, but the
pipe. This worked by accident as endpoint is a __u8 and the lowest 8
bits of the pipe are 0. Fix this copy/paste error by using the correct
endpoint of "0".

Fixes: 45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")
Link: https://lore.kernel.org/all/20220920100416.959226-2-mkl@pengutronix.de
Cc: John Whittington <git@jbrengineering.co.uk>
Tested-by: John Whittington <git@jbrengineering.co.uk>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 5e0d280b0cd3..1430368ca327 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -386,8 +386,7 @@ static inline int gs_usb_get_timestamp(const struct gs_can *dev,
 	__le32 timestamp;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface),
-				  usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
+	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
 				  GS_USB_BREQ_TIMESTAMP,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
-- 
2.35.1


