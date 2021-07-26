Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60163D5B6F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhGZNec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhGZNdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0643CC061A14
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Ld-0002VW-BM
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:49 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 00EF16582F8
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 72930658211;
        Mon, 26 Jul 2021 14:12:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 52d528fc;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 37/46] can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes
Date:   Mon, 26 Jul 2021 16:11:35 +0200
Message-Id: <20210726141144.862529-38-mkl@pengutronix.de>
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

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch updates old code by using the can_change_state() function
published since by the socket-can module.

In particular, this new code better manages the change of bus state by
also using the value of the error counters that the driver now
systematically asks for when initializing the channel.

Link: https://lore.kernel.org/r/20210715142842.35793-1-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 166 ++++++------------------
 1 file changed, 43 insertions(+), 123 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index fea44e33c3dd..e36e60c3703a 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -452,145 +452,65 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
-	enum can_state new_state;
+	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
 
 	/* ignore this error until 1st ts received */
 	if (n == PCAN_USB_ERROR_QOVR)
 		if (!mc->pdev->time_ref.tick_count)
 			return 0;
 
-	new_state = mc->pdev->dev.can.state;
-
-	switch (mc->pdev->dev.can.state) {
-	case CAN_STATE_ERROR_ACTIVE:
-		if (n & PCAN_USB_ERROR_BUS_LIGHT) {
-			new_state = CAN_STATE_ERROR_WARNING;
-			break;
-		}
-		fallthrough;
-
-	case CAN_STATE_ERROR_WARNING:
-		if (n & PCAN_USB_ERROR_BUS_HEAVY) {
-			new_state = CAN_STATE_ERROR_PASSIVE;
-			break;
-		}
-		if (n & PCAN_USB_ERROR_BUS_OFF) {
-			new_state = CAN_STATE_BUS_OFF;
-			break;
-		}
-		if (n & ~PCAN_USB_ERROR_BUS) {
-			/*
-			 * trick to bypass next comparison and process other
-			 * errors
-			 */
-			new_state = CAN_STATE_MAX;
-			break;
-		}
-		if ((n & PCAN_USB_ERROR_BUS_LIGHT) == 0) {
-			/* no error (back to active state) */
-			new_state = CAN_STATE_ERROR_ACTIVE;
-			break;
-		}
-		break;
-
-	case CAN_STATE_ERROR_PASSIVE:
-		if (n & PCAN_USB_ERROR_BUS_OFF) {
-			new_state = CAN_STATE_BUS_OFF;
-			break;
-		}
-		if (n & PCAN_USB_ERROR_BUS_LIGHT) {
-			new_state = CAN_STATE_ERROR_WARNING;
-			break;
-		}
-		if (n & ~PCAN_USB_ERROR_BUS) {
-			/*
-			 * trick to bypass next comparison and process other
-			 * errors
-			 */
-			new_state = CAN_STATE_MAX;
-			break;
-		}
-
-		if ((n & PCAN_USB_ERROR_BUS_HEAVY) == 0) {
-			/* no error (back to warning state) */
-			new_state = CAN_STATE_ERROR_WARNING;
-			break;
-		}
-		break;
-
-	default:
-		/* do nothing waiting for restart */
-		return 0;
-	}
-
-	/* donot post any error if current state didn't change */
-	if (mc->pdev->dev.can.state == new_state)
-		return 0;
-
 	/* allocate an skb to store the error frame */
 	skb = alloc_can_err_skb(mc->netdev, &cf);
-	if (!skb)
-		return -ENOMEM;
-
-	switch (new_state) {
-	case CAN_STATE_BUS_OFF:
-		cf->can_id |= CAN_ERR_BUSOFF;
-		mc->pdev->dev.can.can_stats.bus_off++;
-		can_bus_off(mc->netdev);
-		break;
-
-	case CAN_STATE_ERROR_PASSIVE:
-		cf->can_id |= CAN_ERR_CRTL;
-		cf->data[1] = (mc->pdev->bec.txerr > mc->pdev->bec.rxerr) ?
-				CAN_ERR_CRTL_TX_PASSIVE :
-				CAN_ERR_CRTL_RX_PASSIVE;
-		cf->data[6] = mc->pdev->bec.txerr;
-		cf->data[7] = mc->pdev->bec.rxerr;
-
-		mc->pdev->dev.can.can_stats.error_passive++;
-		break;
-
-	case CAN_STATE_ERROR_WARNING:
-		cf->can_id |= CAN_ERR_CRTL;
-		cf->data[1] = (mc->pdev->bec.txerr > mc->pdev->bec.rxerr) ?
-				CAN_ERR_CRTL_TX_WARNING :
-				CAN_ERR_CRTL_RX_WARNING;
-		cf->data[6] = mc->pdev->bec.txerr;
-		cf->data[7] = mc->pdev->bec.rxerr;
-
-		mc->pdev->dev.can.can_stats.error_warning++;
-		break;
 
-	case CAN_STATE_ERROR_ACTIVE:
-		cf->can_id |= CAN_ERR_CRTL;
-		cf->data[1] = CAN_ERR_CRTL_ACTIVE;
-
-		/* sync local copies of rxerr/txerr counters */
-		mc->pdev->bec.txerr = 0;
-		mc->pdev->bec.rxerr = 0;
-		break;
-
-	default:
-		/* CAN_STATE_MAX (trick to handle other errors) */
-		if (n & PCAN_USB_ERROR_TXQFULL)
-			netdev_dbg(mc->netdev, "device Tx queue full)\n");
-
-		if (n & PCAN_USB_ERROR_RXQOVR) {
-			netdev_dbg(mc->netdev, "data overrun interrupt\n");
+	if (n & PCAN_USB_ERROR_RXQOVR) {
+		/* data overrun interrupt */
+		netdev_dbg(mc->netdev, "data overrun interrupt\n");
+		mc->netdev->stats.rx_over_errors++;
+		mc->netdev->stats.rx_errors++;
+		if (cf) {
 			cf->can_id |= CAN_ERR_CRTL;
 			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
-			mc->netdev->stats.rx_over_errors++;
-			mc->netdev->stats.rx_errors++;
 		}
+	}
 
-		cf->data[6] = mc->pdev->bec.txerr;
-		cf->data[7] = mc->pdev->bec.rxerr;
+	if (n & PCAN_USB_ERROR_TXQFULL)
+		netdev_dbg(mc->netdev, "device Tx queue full)\n");
 
-		new_state = mc->pdev->dev.can.state;
-		break;
+	if (n & PCAN_USB_ERROR_BUS_OFF) {
+		new_state = CAN_STATE_BUS_OFF;
+	} else if (n & PCAN_USB_ERROR_BUS_HEAVY) {
+		new_state = ((mc->pdev->bec.txerr >= 128) ||
+			     (mc->pdev->bec.rxerr >= 128)) ?
+				CAN_STATE_ERROR_PASSIVE :
+				CAN_STATE_ERROR_WARNING;
+	} else {
+		new_state = CAN_STATE_ERROR_ACTIVE;
 	}
 
-	mc->pdev->dev.can.state = new_state;
+	/* handle change of state */
+	if (new_state != mc->pdev->dev.can.state) {
+		enum can_state tx_state =
+			(mc->pdev->bec.txerr >= mc->pdev->bec.rxerr) ?
+				new_state : 0;
+		enum can_state rx_state =
+			(mc->pdev->bec.txerr <= mc->pdev->bec.rxerr) ?
+				new_state : 0;
+
+		can_change_state(mc->netdev, cf, tx_state, rx_state);
+
+		if (new_state == CAN_STATE_BUS_OFF) {
+			can_bus_off(mc->netdev);
+		} else if (cf && (cf->can_id & CAN_ERR_CRTL)) {
+			/* Supply TX/RX error counters in case of
+			 * controller error.
+			 */
+			cf->data[6] = mc->pdev->bec.txerr;
+			cf->data[7] = mc->pdev->bec.rxerr;
+		}
+	}
+
+	if (!skb)
+		return -ENOMEM;
 
 	if (status_len & PCAN_USB_STATUSLEN_TIMESTAMP) {
 		struct skb_shared_hwtstamps *hwts = skb_hwtstamps(skb);
-- 
2.30.2


