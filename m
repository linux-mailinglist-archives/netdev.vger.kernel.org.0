Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60AB3929E4
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhE0IuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbhE0Itv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6FC06138F
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBge-00020G-LR
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 57FDD62D4F1
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A127E62D416;
        Thu, 27 May 2021 08:45:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c0b68a92;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 17/21] can: c_can: add ethtool support
Date:   Thu, 27 May 2021 10:45:28 +0200
Message-Id: <20210527084532.1384031-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

With commit 132f2d45fb23 ("can: c_can: add support to 64 message
objects") the number of message objects used for reception /
transmission depends on FIFO size.

The ethtools API support allows you to retrieve this info. Driver info
has been added too.

Link: https://lore.kernel.org/r/20210514165549.14365-2-dariobin@libero.it
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/Makefile                |  5 +++
 drivers/net/can/c_can/c_can.h                 |  2 +
 drivers/net/can/c_can/c_can_ethtool.c         | 43 +++++++++++++++++++
 .../net/can/c_can/{c_can.c => c_can_main.c}   |  1 +
 4 files changed, 51 insertions(+)
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (99%)

diff --git a/drivers/net/can/c_can/Makefile b/drivers/net/can/c_can/Makefile
index e6a94c948531..6fa3b2b9e4b9 100644
--- a/drivers/net/can/c_can/Makefile
+++ b/drivers/net/can/c_can/Makefile
@@ -4,5 +4,10 @@
 #
 
 obj-$(CONFIG_CAN_C_CAN) += c_can.o
+
+c_can-objs :=
+c_can-objs += c_can_ethtool.o
+c_can-objs += c_can_main.o
+
 obj-$(CONFIG_CAN_C_CAN_PLATFORM) += c_can_platform.o
 obj-$(CONFIG_CAN_C_CAN_PCI) += c_can_pci.o
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 517845c4571e..4247ff80a29c 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -218,4 +218,6 @@ int c_can_power_up(struct net_device *dev);
 int c_can_power_down(struct net_device *dev);
 #endif
 
+void c_can_set_ethtool_ops(struct net_device *dev);
+
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
new file mode 100644
index 000000000000..cd5f07fca2a5
--- /dev/null
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2021, Dario Binacchi <dariobin@libero.it>
+ */
+
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/netdevice.h>
+#include <linux/can/dev.h>
+
+#include "c_can.h"
+
+static void c_can_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *info)
+{
+	struct c_can_priv *priv = netdev_priv(netdev);
+	struct platform_device *pdev = to_platform_device(priv->device);
+
+	strscpy(info->driver, "c_can", sizeof(info->driver));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+}
+
+static void c_can_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	struct c_can_priv *priv = netdev_priv(netdev);
+
+	ring->rx_max_pending = priv->msg_obj_num;
+	ring->tx_max_pending = priv->msg_obj_num;
+	ring->rx_pending = priv->msg_obj_rx_num;
+	ring->tx_pending = priv->msg_obj_tx_num;
+}
+
+static const struct ethtool_ops c_can_ethtool_ops = {
+	.get_drvinfo = c_can_get_drvinfo,
+	.get_ringparam = c_can_get_ringparam,
+};
+
+void c_can_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &c_can_ethtool_ops;
+}
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can_main.c
similarity index 99%
rename from drivers/net/can/c_can/c_can.c
rename to drivers/net/can/c_can/c_can_main.c
index 1fa47968c2ec..7588f70ca0fe 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1334,6 +1334,7 @@ int register_c_can_dev(struct net_device *dev)
 
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
+	c_can_set_ethtool_ops(dev);
 
 	err = register_candev(dev);
 	if (!err)
-- 
2.30.2


