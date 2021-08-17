Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8D93EE55E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhHQENz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhHQENw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:13:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081DC0617AD
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 21:13:18 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFqTN-0003Bb-S1; Tue, 17 Aug 2021 06:13:09 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFqTM-0006ZY-8h; Tue, 17 Aug 2021 06:13:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: [PATCH v2 3/3] can: dev: provide optional GPIO based termination support
Date:   Tue, 17 Aug 2021 06:13:06 +0200
Message-Id: <20210817041306.25185-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817041306.25185-1-o.rempel@pengutronix.de>
References: <20210817041306.25185-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For CAN buses to work, a termination resistor has to be present at both
ends of the bus. This resistor is usually 120 Ohms, other values may be
required for special bus topologies.

This patch adds support for a generic GPIO based CAN termination. The
resistor value has to be specified via device tree, and it can only be
attached to or detached from the bus. By default the termination is not
active.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/can/dev/dev.c | 54 +++++++++++++++++++++++++++++++++++++++
 include/linux/can/dev.h   |  8 ++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 311d8564d611..b4a6c7a6fc18 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -15,6 +15,7 @@
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
 #include <linux/can/led.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -400,10 +401,57 @@ void close_candev(struct net_device *dev)
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
+	u16 term;
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
+	ret = device_property_read_u16(dev, "termination-ohms", &term);
+	if (ret)
+		return ret;
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
@@ -419,6 +467,12 @@ int register_candev(struct net_device *dev)
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
2.30.2

