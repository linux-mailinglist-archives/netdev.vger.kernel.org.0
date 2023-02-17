Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F00069AD6C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBQOKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQOKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:10:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E46ABED
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:10:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pT1Ra-0002yI-A6
        for netdev@vger.kernel.org; Fri, 17 Feb 2023 15:10:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1A0AC17C161
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:10:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 67F3717C140;
        Fri, 17 Feb 2023 14:10:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fbb29ba6;
        Fri, 17 Feb 2023 14:10:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/4] can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL
Date:   Fri, 17 Feb 2023 15:10:28 +0100
Message-Id: <20230217141029.3734802-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217141029.3734802-1-mkl@pengutronix.de>
References: <20230217141029.3734802-1-mkl@pengutronix.de>
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

From: Frank Jungclaus <frank.jungclaus@esd.eu>

Start a rework initiated by Vincents remarks "You should not report
the greatest of txerr and rxerr but the one which actually increased."
[1] and "As far as I understand, those flags should be set only when
the threshold is reached" [2] .

Therefore make use of can_change_state() to (among others) set the
flags CAN_ERR_CRTL_[RT]X_WARNING and CAN_ERR_CRTL_[RT]X_PASSIVE,
maintain CAN statistic counters for error_warning, error_passive and
bus_off.

Relocate testing alloc_can_err_skb() for NULL to the end of
esd_usb_rx_event(), to have things like can_bus_off(),
can_change_state() working even in out of memory conditions.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
Link: https://lore.kernel.org/all/20230216190450.3901254-3-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 5e182fadd875..578b25f873e5 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -239,41 +239,42 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
-		if (skb == NULL) {
-			stats->rx_dropped++;
-			return;
-		}
 
 		if (state != priv->old_state) {
+			enum can_state tx_state, rx_state;
+			enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
+
 			priv->old_state = state;
 
 			switch (state & ESD_BUSSTATE_MASK) {
 			case ESD_BUSSTATE_BUSOFF:
-				priv->can.state = CAN_STATE_BUS_OFF;
-				cf->can_id |= CAN_ERR_BUSOFF;
-				priv->can.can_stats.bus_off++;
+				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
 			case ESD_BUSSTATE_WARN:
-				priv->can.state = CAN_STATE_ERROR_WARNING;
-				priv->can.can_stats.error_warning++;
+				new_state = CAN_STATE_ERROR_WARNING;
 				break;
 			case ESD_BUSSTATE_ERRPASSIVE:
-				priv->can.state = CAN_STATE_ERROR_PASSIVE;
-				priv->can.can_stats.error_passive++;
+				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
-				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				new_state = CAN_STATE_ERROR_ACTIVE;
 				txerr = 0;
 				rxerr = 0;
 				break;
 			}
-		} else {
+
+			if (new_state != priv->can.state) {
+				tx_state = (txerr >= rxerr) ? new_state : 0;
+				rx_state = (txerr <= rxerr) ? new_state : 0;
+				can_change_state(priv->netdev, cf,
+						 tx_state, rx_state);
+			}
+		} else if (skb) {
 			priv->can.can_stats.bus_error++;
 			stats->rx_errors++;
 
-			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR |
-				      CAN_ERR_CNT;
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			switch (ecc & SJA1000_ECC_MASK) {
 			case SJA1000_ECC_BIT:
@@ -295,21 +296,20 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			/* Bit stream position in CAN frame as the error was detected */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
-
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
-			}
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 		}
 
 		priv->bec.txerr = txerr;
 		priv->bec.rxerr = rxerr;
 
-		netif_rx(skb);
+		if (skb) {
+			cf->can_id |= CAN_ERR_CNT;
+			cf->data[6] = txerr;
+			cf->data[7] = rxerr;
+
+			netif_rx(skb);
+		} else {
+			stats->rx_dropped++;
+		}
 	}
 }
 
-- 
2.39.1


