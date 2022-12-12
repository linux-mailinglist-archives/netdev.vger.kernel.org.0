Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C468F649DAF
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiLLLbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiLLLbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C687465CC
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1P-0000GD-0a
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:59 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3C73113CBC3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9819613CB88;
        Mon, 12 Dec 2022 11:30:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 473a40b4;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/39] can: etas_es58x: add devlink port support
Date:   Mon, 12 Dec 2022 12:30:20 +0100
Message-Id: <20221212113045.222493-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Add support for devlink port which extends the devlink support to the
network interface level. For now, the etas_es58x driver will only rely
on the default features that devlink port has to offer and not
implement additional feature ones.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221130174658.29282-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 34 ++++++++++++++++-----
 drivers/net/can/usb/etas_es58x/es58x_core.h |  3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index aeffe61faed8..de884de9fe57 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2039,10 +2039,16 @@ static int es58x_set_mode(struct net_device *netdev, enum can_mode mode)
  * @es58x_dev: ES58X device.
  * @priv: ES58X private parameters related to the network device.
  * @channel_idx: Index of the network device.
+ *
+ * Return: zero on success, errno if devlink port could not be
+ *	properly registered.
  */
-static void es58x_init_priv(struct es58x_device *es58x_dev,
-			    struct es58x_priv *priv, int channel_idx)
+static int es58x_init_priv(struct es58x_device *es58x_dev,
+			   struct es58x_priv *priv, int channel_idx)
 {
+	struct devlink_port_attrs attrs = {
+		.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL,
+	};
 	const struct es58x_parameters *param = es58x_dev->param;
 	struct can_priv *can = &priv->can;
 
@@ -2061,6 +2067,10 @@ static void es58x_init_priv(struct es58x_device *es58x_dev,
 	can->state = CAN_STATE_STOPPED;
 	can->ctrlmode_supported = param->ctrlmode_supported;
 	can->do_set_mode = es58x_set_mode;
+
+	devlink_port_attrs_set(&priv->devlink_port, &attrs);
+	return devlink_port_register(priv_to_devlink(es58x_dev),
+				     &priv->devlink_port, channel_idx);
 }
 
 /**
@@ -2084,7 +2094,10 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	}
 	SET_NETDEV_DEV(netdev, dev);
 	es58x_dev->netdev[channel_idx] = netdev;
-	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
+	ret = es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
+	if (ret)
+		goto free_candev;
+	SET_NETDEV_DEVLINK_PORT(netdev, &es58x_priv(netdev)->devlink_port);
 
 	netdev->netdev_ops = &es58x_netdev_ops;
 	netdev->ethtool_ops = &es58x_ethtool_ops;
@@ -2092,16 +2105,20 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
-	if (ret) {
-		es58x_dev->netdev[channel_idx] = NULL;
-		free_candev(netdev);
-		return ret;
-	}
+	if (ret)
+		goto devlink_port_unregister;
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
 
 	return ret;
+
+ devlink_port_unregister:
+	devlink_port_unregister(&es58x_priv(netdev)->devlink_port);
+ free_candev:
+	es58x_dev->netdev[channel_idx] = NULL;
+	free_candev(netdev);
+	return ret;
 }
 
 /**
@@ -2118,6 +2135,7 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 		if (!netdev)
 			continue;
 		unregister_candev(netdev);
+		devlink_port_unregister(&es58x_priv(netdev)->devlink_port);
 		es58x_dev->netdev[i] = NULL;
 		free_candev(netdev);
 	}
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index bf24375580e5..a76789119229 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -17,6 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/usb.h>
+#include <net/devlink.h>
 
 #include "es581_4.h"
 #include "es58x_fd.h"
@@ -230,6 +231,7 @@ union es58x_urb_cmd {
  * @can: struct can_priv must be the first member (Socket CAN relies
  *	on the fact that function netdev_priv() returns a pointer to
  *	a struct can_priv).
+ * @devlink_port: devlink instance for the network interface.
  * @es58x_dev: pointer to the corresponding ES58X device.
  * @tx_urb: Used as a buffer to concatenate the TX messages and to do
  *	a bulk send. Please refer to es58x_start_xmit() for more
@@ -255,6 +257,7 @@ union es58x_urb_cmd {
  */
 struct es58x_priv {
 	struct can_priv can;
+	struct devlink_port devlink_port;
 	struct es58x_device *es58x_dev;
 	struct urb *tx_urb;
 
-- 
2.35.1


