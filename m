Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED24470C9
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhKFV5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhKFV5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:57:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF164C061205
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:55:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjTeP-0000u5-9S
        for netdev@vger.kernel.org; Sat, 06 Nov 2021 22:55:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1F7D36A5F94
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 21:55:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9C7876A5F7B;
        Sat,  6 Nov 2021 21:54:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8c426bbe;
        Sat, 6 Nov 2021 21:54:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/8] can: peak_usb: always ask for BERR reporting for PCAN-USB devices
Date:   Sat,  6 Nov 2021 22:54:46 +0100
Message-Id: <20211106215449.57946-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106215449.57946-1-mkl@pengutronix.de>
References: <20211106215449.57946-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

Since for the PCAN-USB, the management of the transition to the
ERROR_WARNING or ERROR_PASSIVE state is done according to the error
counters, these must be requested unconditionally.

Link: https://lore.kernel.org/all/20211021081505.18223-2-s.grosjean@peak-system.com
Fixes: c11dcee75830 ("can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes")
Cc: stable@vger.kernel.org
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 837b3fecd71e..af8d3dadbbb8 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -841,14 +841,14 @@ static int pcan_usb_start(struct peak_usb_device *dev)
 	pdev->bec.rxerr = 0;
 	pdev->bec.txerr = 0;
 
-	/* be notified on error counter changes (if requested by user) */
-	if (dev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
-		err = pcan_usb_set_err_frame(dev, PCAN_USB_BERR_MASK);
-		if (err)
-			netdev_warn(dev->netdev,
-				    "Asking for BERR reporting error %u\n",
-				    err);
-	}
+	/* always ask the device for BERR reporting, to be able to switch from
+	 * WARNING to PASSIVE state
+	 */
+	err = pcan_usb_set_err_frame(dev, PCAN_USB_BERR_MASK);
+	if (err)
+		netdev_warn(dev->netdev,
+			    "Asking for BERR reporting error %u\n",
+			    err);
 
 	/* if revision greater than 3, can put silent mode on/off */
 	if (dev->device_rev > 3) {
@@ -986,7 +986,6 @@ const struct peak_usb_adapter pcan_usb = {
 	.device_id = PCAN_USB_PRODUCT_ID,
 	.ctrl_count = 1,
 	.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			      CAN_CTRLMODE_BERR_REPORTING |
 			      CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_USB_CRYSTAL_HZ / 2,
-- 
2.33.0


