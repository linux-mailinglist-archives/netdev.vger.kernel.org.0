Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9CE5E7A64
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiIWMSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiIWMQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE4213C876
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUS-0007J8-Pv
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:08 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 32B0EEB142
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 283E8EB11C;
        Fri, 23 Sep 2022 12:09:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3fac96ba;
        Fri, 23 Sep 2022 12:09:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        John Whittington <git@jbrengineering.co.uk>
Subject: [PATCH net-next 05/11] can: gs_usb: gs_can_open(): initialize time counter before starting device
Date:   Fri, 23 Sep 2022 14:08:53 +0200
Message-Id: <20220923120859.740577-6-mkl@pengutronix.de>
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

On busy networks the CAN controller might receive CAN frames directly
after starting it but before the timecounter is setup. This will lead
to NULL pointer deref while converting the converting the CAN frame's
timestamp with the timecounter.

Close the race window by setting up the timecounter before starting
the CAN controller.

Fixes: 45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")
Link: https://lore.kernel.org/all/20220921081329.385509-1-mkl@pengutronix.de
Cc: John Whittington <git@jbrengineering.co.uk
Tested-by: John Whittington <git@jbrengineering.co.uk>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 9a8a7f1b2002..aa619dfc3ff2 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -972,6 +972,10 @@ static int gs_can_open(struct net_device *netdev)
 	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 		flags |= GS_CAN_MODE_HW_TIMESTAMP;
 
+	/* start polling timestamp */
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		gs_usb_timestamp_init(dev);
+
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
@@ -985,16 +989,14 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc < 0) {
 		netdev_err(netdev, "Couldn't start device (err=%d)\n", rc);
 		kfree(dm);
+		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			gs_usb_timestamp_stop(dev);
 		dev->can.state = CAN_STATE_STOPPED;
 		return rc;
 	}
 
 	kfree(dm);
 
-	/* start polling timestamp */
-	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
-		gs_usb_timestamp_init(dev);
-
 	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
-- 
2.35.1


