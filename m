Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3245BE21B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiITJa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiITJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:30:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE7265D6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:29:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaZZO-0005o4-B9
        for netdev@vger.kernel.org; Tue, 20 Sep 2022 11:29:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B7776E7337
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:29:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 54AF1E72B5;
        Tue, 20 Sep 2022 09:29:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2a13597e;
        Tue, 20 Sep 2022 09:29:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 15/17] can: kvaser_usb_leaf: Fix bogus restart events
Date:   Tue, 20 Sep 2022 11:29:13 +0200
Message-Id: <20220920092915.921613-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920092915.921613-1-mkl@pengutronix.de>
References: <20220920092915.921613-1-mkl@pengutronix.de>
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

When auto-restart is enabled, the kvaser_usb_leaf driver considers
transition from any state >= CAN_STATE_BUS_OFF as a bus-off recovery
event (restart).

However, these events may occur at interface startup time before
kvaser_usb_open() has set the state to CAN_STATE_ERROR_ACTIVE, causing
restarts counter to increase and CAN_ERR_RESTARTED to be sent despite no
actual restart having occurred.

Fix that by making the auto-restart condition checks more strict so that
they only trigger when the interface was actually in the BUS_OFF state.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20220903182559.189-13-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index f8a12a285050..3e31a9ebea88 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -901,7 +901,7 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 	context = &priv->tx_contexts[tid % dev->max_tx_urbs];
 
 	/* Sometimes the state change doesn't come after a bus-off event */
-	if (priv->can.restart_ms && priv->can.state >= CAN_STATE_BUS_OFF) {
+	if (priv->can.restart_ms && priv->can.state == CAN_STATE_BUS_OFF) {
 		struct sk_buff *skb;
 		struct can_frame *cf;
 
@@ -1018,7 +1018,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 	}
 
 	if (priv->can.restart_ms &&
-	    cur_state >= CAN_STATE_BUS_OFF &&
+	    cur_state == CAN_STATE_BUS_OFF &&
 	    new_state < CAN_STATE_BUS_OFF)
 		priv->can.can_stats.restarts++;
 
@@ -1111,7 +1111,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		}
 
 		if (priv->can.restart_ms &&
-		    old_state >= CAN_STATE_BUS_OFF &&
+		    old_state == CAN_STATE_BUS_OFF &&
 		    new_state < CAN_STATE_BUS_OFF) {
 			cf->can_id |= CAN_ERR_RESTARTED;
 			netif_carrier_on(priv->netdev);
-- 
2.35.1


