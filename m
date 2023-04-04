Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3D6D5F1C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbjDDLfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbjDDLeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:34:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136453598
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:34:42 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjevx-0004zL-1M
        for netdev@vger.kernel.org; Tue, 04 Apr 2023 13:34:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8B55A1A6370
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 11:34:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5BA891A634B;
        Tue,  4 Apr 2023 11:34:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c41f5193;
        Tue, 4 Apr 2023 11:34:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/10] can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING
Date:   Tue,  4 Apr 2023 13:34:28 +0200
Message-Id: <20230404113429.1590300-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113429.1590300-1-mkl@pengutronix.de>
References: <20230404113429.1590300-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

Announce that the driver supports CAN_CTRLMODE_BERR_REPORTING by means
of priv->can.ctrlmode_supported. Until now berr reporting always has
been active without taking care of the berr-reporting parameter given
to an "ip link set ..." command.

Additionally apply some changes to function esd_usb_rx_event():
- If berr reporting is off and it is also no state change, then
immediately return.
- Unconditionally (even in case of the above "immediate return") store
tx- and rx-error counters, so directly use priv->bec.txerr and
priv->bec.rxerr instead of intermediate variables.
- Not directly related, but to better point out the linkage between a
failed alloc_can_err_skb() and stats->rx_dropped++:
Move the increment of the rx_dropped statistic counter (back) to
directly behind the err_skb allocation.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20230330184446.2802135-1-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index e78bb468115a..d33bac3a6c10 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -237,14 +237,23 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->rx.ev_can_err_ext.status;
 		u8 ecc = msg->rx.ev_can_err_ext.ecc;
-		u8 rxerr = msg->rx.ev_can_err_ext.rec;
-		u8 txerr = msg->rx.ev_can_err_ext.tec;
+
+		priv->bec.rxerr = msg->rx.ev_can_err_ext.rec;
+		priv->bec.txerr = msg->rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-			   msg->rx.dlc, state, ecc, rxerr, txerr);
+			   msg->rx.dlc, state, ecc,
+			   priv->bec.rxerr, priv->bec.txerr);
+
+		/* if berr-reporting is off, only pass through on state change ... */
+		if (!(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+		    state == priv->old_state)
+			return;
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
+		if (!skb)
+			stats->rx_dropped++;
 
 		if (state != priv->old_state) {
 			enum can_state tx_state, rx_state;
@@ -265,14 +274,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				new_state = CAN_STATE_ERROR_ACTIVE;
-				txerr = 0;
-				rxerr = 0;
+				priv->bec.txerr = 0;
+				priv->bec.rxerr = 0;
 				break;
 			}
 
 			if (new_state != priv->can.state) {
-				tx_state = (txerr >= rxerr) ? new_state : 0;
-				rx_state = (txerr <= rxerr) ? new_state : 0;
+				tx_state = (priv->bec.txerr >= priv->bec.rxerr) ? new_state : 0;
+				rx_state = (priv->bec.txerr <= priv->bec.rxerr) ? new_state : 0;
 				can_change_state(priv->netdev, cf,
 						 tx_state, rx_state);
 			}
@@ -304,17 +313,12 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
 		}
 
-		priv->bec.txerr = txerr;
-		priv->bec.rxerr = rxerr;
-
 		if (skb) {
 			cf->can_id |= CAN_ERR_CNT;
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
+			cf->data[6] = priv->bec.txerr;
+			cf->data[7] = priv->bec.rxerr;
 
 			netif_rx(skb);
-		} else {
-			stats->rx_dropped++;
 		}
 	}
 }
@@ -1016,7 +1020,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 
 	priv->can.state = CAN_STATE_STOPPED;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_CC_LEN8_DLC;
+		CAN_CTRLMODE_CC_LEN8_DLC |
+		CAN_CTRLMODE_BERR_REPORTING;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
-- 
2.39.2


