Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAAD37FE4A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 21:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhEMTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 15:38:46 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:39186 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230459AbhEMTip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 15:38:45 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id hH9CleHYgpK9whH9IlBtAk; Thu, 13 May 2021 21:37:34 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620934654; bh=0leY0tbYAknfA9t3wZngeHd0QK5dQLM9vUbV9/jvTvU=;
        h=From;
        b=x45XKW2V1C1rZmkdzmeHaiofFMxRsYbnJ8GkeQbBldU+3omdQ9AAznGHiORauFaeD
         6HjFvY7UXMVvPsxZQiq9AqHsJeaAW+NU2W7aiC1ZPLhLsvRAVYNrFx2FOlKp9iclGf
         nY/5EGpuC1dFrrKQgsEpqRUQgCbcKGAKIiBOvvgrLvDMKA9+1k4AKuEaXPlm/Sw37o
         tn7aOE6hub2pj6FcTgtO4fgfzcptJBTqIzPdcmfRtvLZUJCzh2a5LKyI4BEMPm+qG0
         TEnq6IiYH2BnnOqKNtO9C8PV8zpXXlhG0s7juiQGB6dqITrBV1xiK8SARpcDB2gCdv
         MwRQCt2qux1ug==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=609d7ffe cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=yyVY4NiJcYN5In7vbeEA:9
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
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] can: c_can: add ethtool support
Date:   Thu, 13 May 2021 21:36:37 +0200
Message-Id: <20210513193638.11201-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfBQeN0BhIrURjBI67X5A+oHh44Oxz1XMSEGOYF1kh3DVBhMk1FcP7609O2vm7U1NMPGzlpNEbtamUVtIrz4vVbdIILaA74bdOUpDnFdmJs9FiLa4ie3c
 DUe7cUZCDilfEtT1fmOBVILh3mv6wkK/PjR2I/US0SBAJUJZ/ycnDdaK850JgUnw+TmO0yrTRiUThTHfh/E0AutZwuO8JUhqIjRMGnTKqKHfjvJYn9YTixgy
 aMqWP2pYUVRk1+rGyLtSMZbifJxQfcBwQe4apCWthUJ7ZARVQLgqRu50Fk3KoAjkErrmmPXvhf7Z7X3WOvFmPVd8Jb3OFqipnmqc9RLgmV7Kfp9M4D+el6He
 6uD/sIHbZX7H/MBaCaw++gWysXUzb7rvQnQztaILv0KAbHajk+KUuRU9jcGW9pucoltnQ7Ku4OrU1XcsyiWCgLg+W+w2b1AsIqByrpOCzHs0OT+iIppYfGzf
 lgggFZ+r4r4vj2xJ0pev/ZPe86wgB0dpz6jSopQobNVoET7zbIdpXunJ6Y+WK6dLNDdmnzfCokXNEQQDbajO1XehSXLNXQPfytTRhA7Lvn7uVqEnuqwV0xCL
 JYT4A0Y6QodJjtj7BfaRXoK7Y431Na3BjSGcP/dVNew/dQ==
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

Changes in v2:
- Use get_ringparam instead of get_channels

 drivers/net/can/c_can/Makefile                |  3 ++
 drivers/net/can/c_can/c_can.h                 |  2 +
 drivers/net/can/c_can/c_can_ethtool.c         | 44 +++++++++++++++++++
 .../net/can/c_can/{c_can.c => c_can_main.c}   |  1 +
 4 files changed, 50 insertions(+)
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
index 06045f610f0e..f9001072514a 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -219,4 +219,6 @@ int c_can_power_up(struct net_device *dev);
 int c_can_power_down(struct net_device *dev);
 #endif
 
+void c_can_set_ethtool_ops(struct net_device *dev);
+
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
new file mode 100644
index 000000000000..1a61bf2fb9ef
--- /dev/null
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -0,0 +1,44 @@
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
index 313793f6922d..1903b87d5384 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1335,6 +1335,7 @@ int register_c_can_dev(struct net_device *dev)
 
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
+	c_can_set_ethtool_ops(dev);
 
 	err = register_candev(dev);
 	if (!err)
-- 
2.17.1

