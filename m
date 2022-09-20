Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16B75BE210
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiITJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiITJ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:29:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A1455AE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:29:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaZZM-0005mN-Jg
        for netdev@vger.kernel.org; Tue, 20 Sep 2022 11:29:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 06B9AE732D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:29:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4B72FE72B2;
        Tue, 20 Sep 2022 09:29:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 96cd9b4c;
        Tue, 20 Sep 2022 09:29:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 14/17] can: kvaser_usb_leaf: Ignore stale bus-off after start
Date:   Tue, 20 Sep 2022 11:29:12 +0200
Message-Id: <20220920092915.921613-15-mkl@pengutronix.de>
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

With 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778 it was observed
that if the device was bus-off when stopped, at next start (either via
interface down/up or manual bus-off restart) the initial
CMD_CHIP_STATE_EVENT received just after CMD_START_CHIP_REPLY will have
the M16C_STATE_BUS_OFF bit still set, causing the interface to
immediately go bus-off again.

The bit seems to internally clear quickly afterwards but we do not get
another CMD_CHIP_STATE_EVENT.

Fix the issue by ignoring any initial bus-off state until we see at
least one bus-on state. Also, poll the state periodically until that
occurs.

It is possible we lose one actual immediately occurring bus-off event
here in which case the HW will auto-recover and we see the recovery
event. We will then catch the next bus-off event, if any.

This issue did not reproduce with 0bfd:0017 Kvaser Memorator
Professional HS/HS FW 2.0.50.

Cc: stable@vger.kernel.org
Fixes: 71873a9b38d1 ("can: kvaser_usb: Add support for more Kvaser Leaf v2 devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20220903182559.189-12-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 4f9c76f4d0da..f8a12a285050 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -427,6 +427,9 @@ struct kvaser_usb_net_leaf_priv {
 	struct kvaser_usb_net_priv *net;
 
 	struct delayed_work chip_state_req_work;
+
+	/* started but not reported as bus-on yet */
+	bool joining_bus;
 };
 
 static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
@@ -966,6 +969,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 					const struct kvaser_usb_err_summary *es,
 					struct can_frame *cf)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	struct kvaser_usb *dev = priv->dev;
 	struct net_device_stats *stats = &priv->netdev->stats;
 	enum can_state cur_state, new_state, tx_state, rx_state;
@@ -990,6 +994,22 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 		new_state = CAN_STATE_ERROR_ACTIVE;
 	}
 
+	/* 0bfd:0124 FW 4.18.778 was observed to send the initial
+	 * CMD_CHIP_STATE_EVENT after CMD_START_CHIP with M16C_STATE_BUS_OFF
+	 * bit set if the channel was bus-off when it was last stopped (even
+	 * across chip resets). This bit will clear shortly afterwards, without
+	 * triggering a second unsolicited chip state event.
+	 * Ignore this initial bus-off.
+	 */
+	if (leaf->joining_bus) {
+		if (new_state == CAN_STATE_BUS_OFF) {
+			netdev_dbg(priv->netdev, "ignoring bus-off during startup");
+			new_state = cur_state;
+		} else {
+			leaf->joining_bus = false;
+		}
+	}
+
 	if (new_state != cur_state) {
 		tx_state = (es->txerr >= es->rxerr) ? new_state : 0;
 		rx_state = (es->txerr <= es->rxerr) ? new_state : 0;
@@ -1065,9 +1085,12 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 
 	/* If there are errors, request status updates periodically as we do
 	 * not get automatic notifications of improved state.
+	 * Also request updates if we saw a stale BUS_OFF during startup
+	 * (joining_bus).
 	 */
 	if (new_state < CAN_STATE_BUS_OFF &&
-	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE))
+	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE ||
+	     leaf->joining_bus))
 		schedule_delayed_work(&leaf->chip_state_req_work,
 				      msecs_to_jiffies(500));
 
@@ -1587,8 +1610,11 @@ static int kvaser_usb_leaf_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 
 static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
+	leaf->joining_bus = true;
+
 	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
@@ -1719,12 +1745,15 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 				    enum can_mode mode)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
 	switch (mode) {
 	case CAN_MODE_START:
 		kvaser_usb_unlink_tx_urbs(priv);
 
+		leaf->joining_bus = true;
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
-- 
2.35.1


