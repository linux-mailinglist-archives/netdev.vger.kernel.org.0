Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831923776A4
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 14:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhEIMwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 08:52:35 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:52124 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229661AbhEIMwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 08:52:32 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id fim8lvyCKpK9wfimGlntVh; Sun, 09 May 2021 14:43:20 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620564200; bh=MIC+8AvIQ/VJx/FyZwe6EZOxmjOe7sYnk6eOS8E7LDY=;
        h=From;
        b=CNn4GzKPtu6KZi8fwNyVrOz3HfJ6WlW4R2+D5ZTWG1y8ImhtsfCCfa0diJjAdc2xH
         zEN/hh1kNOielZeSmAjb4v4IXMN0xtZvW+R/ajezOtBxk9KWRqjnD2pvY7dmhn1Kx3
         vSzizbMgRWRkJzJu5gpYjBxKN7jeLvkc9LUdXx+PhySUMg9uaUiR/JdIJdBfMOYBvQ
         78EZ7G/xYV1yVlE6abEnLePNVqlhu0PjllMhOLPPQU2AxsIqHYqDGqn+Hti5Apuj2E
         E6/l2+b1j9wOPSXJ9T8w+gWTK8jaHbIdC/BrdoKoslXWlt82pXe/+vGcI6MwMHqiKI
         tdH3H/nCqVo7w==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=6097d8e8 cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=SGOFpciEqo9vyzegYnIA:9 a=-4wPlLVnJ--VLaRH:21 a=zBB0C0jdxDwOhFAb:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/3] can: c_can: add ethtool support
Date:   Sun,  9 May 2021 14:43:08 +0200
Message-Id: <20210509124309.30024-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210509124309.30024-1-dariobin@libero.it>
References: <20210509124309.30024-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfA0qDsJjNLWgnIKNi26fKGnMaxj6u1Cz9OWj2YYk6ar4WfzymnKgl0hOBUivPBQYf0LDW3FE995pKfX4pFi2yDXvkRmyzc/nkeoeczogcsFeubOt6ikb
 hF2rDcIQScqX+MHXgQYuCds51aLZ1y6kNLWuZmHi7ZrghMqnz4gW5RUd5TCQv/x8enSPnj5h7cq5p+N/ij16Rc2urTjpzrOeKXq2MkVTkqPpVyZ8iJdGYVYE
 61YrJPNFGLyYmI1NSB4hOTfBcDGiIXCPAJUqCV+rtQVnu4pZYPDaPCYMMB+T3Ft54Vdpq7NlAiCv+Mhz9TMpwVnr/sE/nTDnunALbVhKFU+8pUfiGvw7OH9P
 1d5Dy/mQbnVZxie6Bs2+q7vYw4KDcOuZwNiD2JNC1Vs91qDOFyDqteeFlj0DmcD1yq7+4vUqahKvU9+2yl53aRp0mcAQVUbvv4MO3pVRXtAd3bFeKAC8gUZN
 Cvg6udyvHRadYRKBgUOdQv5WaXzVkbzBouzo5AfCS7BDL8/StscmdSuX3d6sILIiTzdruZi7ytw4o4aaH7uGz93D6I56VcH1qMsHrcwT+ZY+7a/Pqg5lBN6h
 xyuCGn08RRcCJv35edJB1cZb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
the number of message objects used for reception / transmission depends
on FIFO size.
The ethtools API support allows you to retrieve this info. Driver info
has been added too.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/Makefile                |  3 ++
 drivers/net/can/c_can/c_can.h                 |  2 +
 drivers/net/can/c_can/c_can_ethtool.c         | 46 +++++++++++++++++++
 .../net/can/c_can/{c_can.c => c_can_main.c}   |  1 +
 4 files changed, 52 insertions(+)
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (99%)

diff --git a/drivers/net/can/c_can/Makefile b/drivers/net/can/c_can/Makefile
index e6a94c948531..ac2bca39d6ff 100644
--- a/drivers/net/can/c_can/Makefile
+++ b/drivers/net/can/c_can/Makefile
@@ -4,5 +4,8 @@
 #
 
 obj-$(CONFIG_CAN_C_CAN) += c_can.o
+
+c_can-objs := c_can_main.o c_can_ethtool.o
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
index 000000000000..1987c78b9647
--- /dev/null
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -0,0 +1,46 @@
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
+	struct platform_device	*pdev = to_platform_device(priv->device);
+
+	strscpy(info->driver, "c_can", sizeof(info->driver));
+	strscpy(info->version, "1.0", sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+}
+
+static void c_can_get_channels(struct net_device *netdev,
+			       struct ethtool_channels *ch)
+{
+	struct c_can_priv *priv = netdev_priv(netdev);
+
+	ch->max_rx = priv->msg_obj_num;
+	ch->max_tx = priv->msg_obj_num;
+	ch->max_combined = priv->msg_obj_num;
+	ch->rx_count = priv->msg_obj_rx_num;
+	ch->tx_count = priv->msg_obj_tx_num;
+	ch->combined_count = priv->msg_obj_rx_num + priv->msg_obj_tx_num;
+}
+
+static const struct ethtool_ops c_can_ethtool_ops = {
+	.get_drvinfo = c_can_get_drvinfo,
+	.get_channels = c_can_get_channels,
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
2.17.1

