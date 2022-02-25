Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43ED14C4B7A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243372AbiBYQ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243359AbiBYQ47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:56:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA2A1EC27F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:56:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nNdtJ-0004E6-Pt
        for netdev@vger.kernel.org; Fri, 25 Feb 2022 17:56:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BEC8C3D885
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6D1DC3D86F;
        Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 81a455f8;
        Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/3] can: gs_usb: change active_channels's type from atomic_t to u8
Date:   Fri, 25 Feb 2022 17:56:21 +0100
Message-Id: <20220225165622.3231809-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225165622.3231809-1-mkl@pengutronix.de>
References: <20220225165622.3231809-1-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The driver uses an atomic_t variable: gs_usb:active_channels to keep
track of the number of opened channels in order to only allocate
memory for the URBs when this count changes from zero to one.

However, the driver does not decrement the counter when an error
occurs in gs_can_open(). This issue is fixed by changing the type from
atomic_t to u8 and by simplifying the logic accordingly.

It is safe to use an u8 here because the network stack big kernel lock
(a.k.a. rtnl_mutex) is being hold. For details, please refer to [1].

[1] https://lore.kernel.org/linux-can/CAMZ6Rq+sHpiw34ijPsmp7vbUpDtJwvVtdV7CvRZJsLixjAFfrg@mail.gmail.com/T/#t

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/all/20220214234814.1321599-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b487e3fe770a..d35749fad1ef 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -191,8 +191,8 @@ struct gs_can {
 struct gs_usb {
 	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
-	atomic_t active_channels;
 	struct usb_device *udev;
+	u8 active_channels;
 };
 
 /* 'allocate' a tx context.
@@ -589,7 +589,7 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc)
 		return rc;
 
-	if (atomic_add_return(1, &parent->active_channels) == 1) {
+	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
@@ -690,6 +690,7 @@ static int gs_can_open(struct net_device *netdev)
 
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 
+	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
 
@@ -705,7 +706,8 @@ static int gs_can_close(struct net_device *netdev)
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
-	if (atomic_dec_and_test(&parent->active_channels))
+	parent->active_channels--;
+	if (!parent->active_channels)
 		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 	/* Stop sending URBs */
@@ -984,8 +986,6 @@ static int gs_usb_probe(struct usb_interface *intf,
 
 	init_usb_anchor(&dev->rx_submitted);
 
-	atomic_set(&dev->active_channels, 0);
-
 	usb_set_intfdata(intf, dev);
 	dev->udev = interface_to_usbdev(intf);
 
-- 
2.34.1


