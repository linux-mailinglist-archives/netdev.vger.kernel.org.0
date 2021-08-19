Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D3A3F1A9F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhHSNkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240172AbhHSNkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBB8C061760
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGR-0004Lk-NA
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3B52E66A7FF
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2D3C666A7E5;
        Thu, 19 Aug 2021 13:39:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 800e238a;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/22] can: dev: provide optional GPIO based termination support
Date:   Thu, 19 Aug 2021 15:38:55 +0200
Message-Id: <20210819133913.657715-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

For CAN buses to work, a termination resistor has to be present at both
ends of the bus. This resistor is usually 120 Ohms, other values may be
required for special bus topologies.

This patch adds support for a generic GPIO based CAN termination. The
resistor value has to be specified via device tree, and it can only be
attached to or detached from the bus. By default the termination is not
active.

Link: https://lore.kernel.org/r/20210818071232.20585-4-o.rempel@pengutronix.de
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/dev.c | 66 +++++++++++++++++++++++++++++++++++++++
 include/linux/can/dev.h   |  8 +++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 311d8564d611..e3d840b81357 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -15,6 +15,7 @@
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
 #include <linux/can/led.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -400,10 +401,69 @@ void close_candev(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(close_candev);
 
+static int can_set_termination(struct net_device *ndev, u16 term)
+{
+	struct can_priv *priv = netdev_priv(ndev);
+	int set;
+
+	if (term == priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_ENABLED])
+		set = 1;
+	else
+		set = 0;
+
+	gpiod_set_value(priv->termination_gpio, set);
+
+	return 0;
+}
+
+static int can_get_termination(struct net_device *ndev)
+{
+	struct can_priv *priv = netdev_priv(ndev);
+	struct device *dev = ndev->dev.parent;
+	struct gpio_desc *gpio;
+	u32 term;
+	int ret;
+
+	/* Disabling termination by default is the safe choice: Else if many
+	 * bus participants enable it, no communication is possible at all.
+	 */
+	gpio = devm_gpiod_get_optional(dev, "termination", GPIOD_OUT_LOW);
+	if (IS_ERR(gpio))
+		return dev_err_probe(dev, PTR_ERR(gpio),
+				     "Cannot get termination-gpios\n");
+
+	if (!gpio)
+		return 0;
+
+	ret = device_property_read_u32(dev, "termination-ohms", &term);
+	if (ret) {
+		netdev_err(ndev, "Cannot get termination-ohms: %pe\n",
+			   ERR_PTR(ret));
+		return ret;
+	}
+
+	if (term > U16_MAX) {
+		netdev_err(ndev, "Invalid termination-ohms value (%u > %u)\n",
+			   term, U16_MAX);
+		return -EINVAL;
+	}
+
+	priv->termination_const_cnt = ARRAY_SIZE(priv->termination_gpio_ohms);
+	priv->termination_const = priv->termination_gpio_ohms;
+	priv->termination_gpio = gpio;
+	priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_DISABLED] =
+		CAN_TERMINATION_DISABLED;
+	priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_ENABLED] = term;
+	priv->do_set_termination = can_set_termination;
+
+	return 0;
+}
+
 /* Register the CAN network device */
 int register_candev(struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
+	int err;
 
 	/* Ensure termination_const, termination_const_cnt and
 	 * do_set_termination consistency. All must be either set or
@@ -419,6 +479,12 @@ int register_candev(struct net_device *dev)
 	if (!priv->data_bitrate_const != !priv->data_bitrate_const_cnt)
 		return -EINVAL;
 
+	if (!priv->termination_const) {
+		err = can_get_termination(dev);
+		if (err)
+			return err;
+	}
+
 	dev->rtnl_link_ops = &can_link_ops;
 	netif_carrier_off(dev);
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 27b275e463da..2413253e54c7 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -32,6 +32,12 @@ enum can_mode {
 	CAN_MODE_SLEEP
 };
 
+enum can_termination_gpio {
+	CAN_TERMINATION_GPIO_DISABLED = 0,
+	CAN_TERMINATION_GPIO_ENABLED,
+	CAN_TERMINATION_GPIO_MAX,
+};
+
 /*
  * CAN common private data
  */
@@ -55,6 +61,8 @@ struct can_priv {
 	unsigned int termination_const_cnt;
 	const u16 *termination_const;
 	u16 termination;
+	struct gpio_desc *termination_gpio;
+	u16 termination_gpio_ohms[CAN_TERMINATION_GPIO_MAX];
 
 	enum can_state state;
 
-- 
2.32.0


