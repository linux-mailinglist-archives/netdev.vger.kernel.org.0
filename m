Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C385BE202
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiITJ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiITJ3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:29:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669565599
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:29:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaZZM-0005lq-Dm
        for netdev@vger.kernel.org; Tue, 20 Sep 2022 11:29:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BB5C0E7326
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:29:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 38580E72AF;
        Tue, 20 Sep 2022 09:29:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0382818a;
        Tue, 20 Sep 2022 09:29:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 12/17] can: kvaser_usb_leaf: Fix improved state not being reported
Date:   Tue, 20 Sep 2022 11:29:10 +0200
Message-Id: <20220920092915.921613-13-mkl@pengutronix.de>
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

The tested 0bfd:0017 Kvaser Memorator Professional HS/HS FW 2.0.50 and
0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778 do not seem to send
any unsolicited events when error counters decrease or when the device
transitions from ERROR_PASSIVE to ERROR_ACTIVE (or WARNING).

This causes the interface to e.g. indefinitely stay in the ERROR_PASSIVE
state.

Fix that by asking for chip state (inc. counters) event every 0.5 secs
when error counters are non-zero.

Since there are non-error-counter devices, also always poll in
ERROR_PASSIVE even if the counters show zero.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20220903182559.189-10-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  7 +++
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 19 +++++-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 58 +++++++++++++++++++
 3 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index f6c0938027ec..d9c5dd5da908 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -104,6 +104,9 @@ struct kvaser_usb_net_priv {
 	struct can_priv can;
 	struct can_berr_counter bec;
 
+	/* subdriver-specific data */
+	void *sub_priv;
+
 	struct kvaser_usb *dev;
 	struct net_device *netdev;
 	int channel;
@@ -125,6 +128,8 @@ struct kvaser_usb_net_priv {
  *
  * @dev_setup_endpoints:	setup USB in and out endpoints
  * @dev_init_card:		initialize card
+ * @dev_init_channel:		initialize channel
+ * @dev_remove_channel:		uninitialize channel
  * @dev_get_software_info:	get software info
  * @dev_get_software_details:	get software details
  * @dev_get_card_info:		get card info
@@ -146,6 +151,8 @@ struct kvaser_usb_dev_ops {
 				    struct can_berr_counter *bec);
 	int (*dev_setup_endpoints)(struct kvaser_usb *dev);
 	int (*dev_init_card)(struct kvaser_usb *dev);
+	int (*dev_init_channel)(struct kvaser_usb_net_priv *priv);
+	void (*dev_remove_channel)(struct kvaser_usb_net_priv *priv);
 	int (*dev_get_software_info)(struct kvaser_usb *dev);
 	int (*dev_get_software_details)(struct kvaser_usb *dev);
 	int (*dev_get_card_info)(struct kvaser_usb *dev);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e91648ed7386..19df05887166 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -684,6 +684,7 @@ static const struct ethtool_ops kvaser_usb_ethtool_ops_hwts = {
 
 static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 {
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int i;
 
 	for (i = 0; i < dev->nchannels; i++) {
@@ -699,6 +700,9 @@ static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 		if (!dev->nets[i])
 			continue;
 
+		if (ops->dev_remove_channel)
+			ops->dev_remove_channel(dev->nets[i]);
+
 		free_candev(dev->nets[i]->netdev);
 	}
 }
@@ -772,17 +776,26 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 
 	dev->nets[channel] = priv;
 
+	if (ops->dev_init_channel) {
+		err = ops->dev_init_channel(priv);
+		if (err)
+			goto err;
+	}
+
 	err = register_candev(netdev);
 	if (err) {
 		dev_err(&dev->intf->dev, "Failed to register CAN device\n");
-		free_candev(netdev);
-		dev->nets[channel] = NULL;
-		return err;
+		goto err;
 	}
 
 	netdev_dbg(netdev, "device registered\n");
 
 	return 0;
+
+err:
+	free_candev(netdev);
+	dev->nets[channel] = NULL;
+	return err;
 }
 
 static int kvaser_usb_probe(struct usb_interface *intf,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index a6a26085bc15..993fcc19637d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/units.h>
 #include <linux/usb.h>
+#include <linux/workqueue.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -56,6 +57,7 @@
 #define CMD_RX_EXT_MESSAGE		14
 #define CMD_TX_EXT_MESSAGE		15
 #define CMD_SET_BUS_PARAMS		16
+#define CMD_GET_CHIP_STATE		19
 #define CMD_CHIP_STATE_EVENT		20
 #define CMD_SET_CTRL_MODE		21
 #define CMD_RESET_CHIP			24
@@ -421,6 +423,12 @@ struct kvaser_usb_err_summary {
 	};
 };
 
+struct kvaser_usb_net_leaf_priv {
+	struct kvaser_usb_net_priv *net;
+
+	struct delayed_work chip_state_req_work;
+};
+
 static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
 	.name = "kvaser_usb_ucii",
 	.tseg1_min = 4,
@@ -943,6 +951,16 @@ static int kvaser_usb_leaf_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 	return err;
 }
 
+static void kvaser_usb_leaf_chip_state_req_work(struct work_struct *work)
+{
+	struct kvaser_usb_net_leaf_priv *leaf =
+		container_of(work, struct kvaser_usb_net_leaf_priv,
+			     chip_state_req_work.work);
+	struct kvaser_usb_net_priv *priv = leaf->net;
+
+	kvaser_usb_leaf_simple_cmd_async(priv, CMD_GET_CHIP_STATE);
+}
+
 static void
 kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 					const struct kvaser_usb_err_summary *es,
@@ -1014,6 +1032,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	struct sk_buff *skb;
 	struct net_device_stats *stats;
 	struct kvaser_usb_net_priv *priv;
+	struct kvaser_usb_net_leaf_priv *leaf;
 	enum can_state old_state, new_state;
 
 	if (es->channel >= dev->nchannels) {
@@ -1023,6 +1042,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	}
 
 	priv = dev->nets[es->channel];
+	leaf = priv->sub_priv;
 	stats = &priv->netdev->stats;
 
 	/* Update all of the CAN interface's state and error counters before
@@ -1039,6 +1059,14 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	kvaser_usb_leaf_rx_error_update_can_state(priv, es, &tmp_cf);
 	new_state = priv->can.state;
 
+	/* If there are errors, request status updates periodically as we do
+	 * not get automatic notifications of improved state.
+	 */
+	if (new_state < CAN_STATE_BUS_OFF &&
+	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE))
+		schedule_delayed_work(&leaf->chip_state_req_work,
+				      msecs_to_jiffies(500));
+
 	skb = alloc_can_err_skb(priv->netdev, &cf);
 	if (!skb) {
 		stats->rx_dropped++;
@@ -1573,10 +1601,13 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 
 static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
 	reinit_completion(&priv->stop_comp);
 
+	cancel_delayed_work(&leaf->chip_state_req_work);
+
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);
 	if (err)
@@ -1623,6 +1654,31 @@ static int kvaser_usb_leaf_init_card(struct kvaser_usb *dev)
 	return 0;
 }
 
+static int kvaser_usb_leaf_init_channel(struct kvaser_usb_net_priv *priv)
+{
+	struct kvaser_usb_net_leaf_priv *leaf;
+
+	leaf = devm_kzalloc(&priv->dev->intf->dev, sizeof(*leaf), GFP_KERNEL);
+	if (!leaf)
+		return -ENOMEM;
+
+	leaf->net = priv;
+	INIT_DELAYED_WORK(&leaf->chip_state_req_work,
+			  kvaser_usb_leaf_chip_state_req_work);
+
+	priv->sub_priv = leaf;
+
+	return 0;
+}
+
+static void kvaser_usb_leaf_remove_channel(struct kvaser_usb_net_priv *priv)
+{
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
+
+	if (leaf)
+		cancel_delayed_work_sync(&leaf->chip_state_req_work);
+}
+
 static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1720,6 +1776,8 @@ const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops = {
 	.dev_get_berr_counter = kvaser_usb_leaf_get_berr_counter,
 	.dev_setup_endpoints = kvaser_usb_leaf_setup_endpoints,
 	.dev_init_card = kvaser_usb_leaf_init_card,
+	.dev_init_channel = kvaser_usb_leaf_init_channel,
+	.dev_remove_channel = kvaser_usb_leaf_remove_channel,
 	.dev_get_software_info = kvaser_usb_leaf_get_software_info,
 	.dev_get_software_details = NULL,
 	.dev_get_card_info = kvaser_usb_leaf_get_card_info,
-- 
2.35.1


