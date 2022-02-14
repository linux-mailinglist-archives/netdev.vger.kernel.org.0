Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D13C4B5E6A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiBNXsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:48:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiBNXsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:48:50 -0500
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907231402D
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:48:40 -0800 (PST)
Received: from localhost.localdomain ([124.33.176.97])
        by smtp.orange.fr with ESMTPA
        id Jl4ynKYlVPEU7Jl59na5Tp; Tue, 15 Feb 2022 00:48:37 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 15 Feb 2022 00:48:37 +0100
X-ME-IP: 124.33.176.97
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Maximilian Schneider <max@schneidersoft.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1] can: gs_usb: change active_channels's type from atomic_t to u8
Date:   Tue, 15 Feb 2022 08:48:14 +0900
Message-Id: <20220214234814.1321599-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses an atomic_t variable: gs_usb:active_channels to keep
track of the number of opened channels in order to only allocate
memory for the URBs when this count changes from zero to one.

However, the driver does not decrement the counter when an error
occurs in gs_can_open(). This issue is fixed by changing the type from
atomic_t to u8 and by simplifying the logic accordingly.

It is safe to use an u8 here because the network stack big kernel lock
(a.k.a. rtnl_mutex) is being hold. For details, please refer to [1].

[1] https://lore.kernel.org/linux-can/CAMZ6Rq+sHpiw34ijPsmp7vbUpDtJwvVtdV7CvRZJsLixjAFfrg@mail.gmail.com/T/#t

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN
devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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

