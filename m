Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5009639C8A
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiK0TSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiK0TSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:18:42 -0500
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Nov 2022 11:18:39 PST
Received: from fritzc.com (mail.fritzc.com [IPv6:2a00:17d8:100::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D583A0;
        Sun, 27 Nov 2022 11:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fritzc.com;
        s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4e0iHFbEGY3EtXZ64Kag7bjeqDn+/ViV93p9+8ED/ss=; b=CXns89WK0t1Pe6jS5ZDr4nj/Cx
        hMJtswiO7CuX/nhOyrOU1u76yvW7plb6OcYOKrQLZ69SqKWQUndXqX0hK2hTDlSqIQ6pRsXBqpm1A
        vdgcNG3PhtGBTnuDnvZVJwJAQnbBZ4V7FOZYNWnPo7UmDNP3lxVnfcb7/1mgBKiDxyqY=;
Received: from 127.0.0.1
        by fritzc.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim latest)
        (envelope-from <christoph.fritz@hexdev.de>)
        id 1ozMvj-000XD6-DQ; Sun, 27 Nov 2022 20:03:08 +0100
From:   Christoph Fritz <christoph.fritz@hexdev.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [RFC] can: Introduce LIN bus as CANFD abstraction
Date:   Sun, 27 Nov 2022 20:02:43 +0100
Message-Id: <20221127190244.888414-2-christoph.fritz@hexdev.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221127190244.888414-1-christoph.fritz@hexdev.de>
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a LIN bus abstraction ontop of CANFD. It is a glue
driver adapting CAN on one side while offering LIN abstraction on the
other side. So that upcoming LIN device drivers can make use of it.

Signed-off-by: Christoph Fritz <christoph.fritz@hexdev.de>
---
 drivers/net/can/Kconfig          |  10 ++
 drivers/net/can/Makefile         |   1 +
 drivers/net/can/lin.c            | 181 +++++++++++++++++++++++++++++++
 include/net/lin.h                |  30 +++++
 include/uapi/linux/can.h         |   1 +
 include/uapi/linux/can/netlink.h |   1 +
 6 files changed, 224 insertions(+)
 create mode 100644 drivers/net/can/lin.c
 create mode 100644 include/net/lin.h

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3048ad77edb3..d091994ea4fe 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -152,6 +152,16 @@ config CAN_KVASER_PCIEFD
 	    Kvaser Mini PCI Express HS v2
 	    Kvaser Mini PCI Express 2xHS v2
 
+config CAN_LIN
+	tristate "LIN mode support"
+	  help
+	  This is a glue driver for LIN-BUS support.
+
+	  The local interconnect (LIN) bus is a simple bus with a feature
+	  subset of CAN. It is often combined with CAN for simple controls.
+
+	  Actual device drivers need to be enabled too.
+
 config CAN_SLCAN
 	tristate "Serial / USB serial CAN Adaptors (slcan)"
 	depends on TTY
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 61c75ce9d500..9114d9e97c0c 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
 obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
 obj-$(CONFIG_CAN_JANZ_ICAN3)	+= janz-ican3.o
 obj-$(CONFIG_CAN_KVASER_PCIEFD)	+= kvaser_pciefd.o
+obj-$(CONFIG_CAN_LIN)		+= lin.o
 obj-$(CONFIG_CAN_MSCAN)		+= mscan/
 obj-$(CONFIG_CAN_M_CAN)		+= m_can/
 obj-$(CONFIG_CAN_PEAK_PCIEFD)	+= peak_canfd/
diff --git a/drivers/net/can/lin.c b/drivers/net/can/lin.c
new file mode 100644
index 000000000000..25eaccc18ab6
--- /dev/null
+++ b/drivers/net/can/lin.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2022 hexDEV GmbH
+ */
+#include <linux/can/core.h>
+#include <linux/can/dev.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <net/lin.h>
+
+static void lin_tx_work_handler(struct work_struct *ws)
+{
+	struct lin_device *priv = container_of(ws, struct lin_device,
+						tx_work);
+	struct net_device *net = priv->net;
+	struct device *dev = priv->dev;
+	struct canfd_frame *frame;
+	u8 id, n;
+
+	priv->tx_busy = true;
+
+	frame = (struct canfd_frame *)priv->tx_skb->data;
+	id = (u8)frame->can_id & 0xff;
+	n = frame->len;
+
+	priv->lindev_ops->ldo_tx(dev, id, n, frame->data);
+	priv->tx_busy = false;
+	netif_wake_queue(net);
+}
+
+static netdev_tx_t lin_start_xmit(struct sk_buff *skb,
+				  struct net_device *netdev)
+{
+	struct lin_device *priv = netdev_priv(netdev);
+
+	if (priv->tx_busy)
+		return NETDEV_TX_BUSY;
+
+	netif_stop_queue(netdev);
+	priv->tx_skb = skb;
+	queue_work(priv->wq, &priv->tx_work);
+
+	return NETDEV_TX_OK;
+}
+
+static int lin_open(struct net_device *netdev)
+{
+	struct lin_device *priv = netdev_priv(netdev);
+	int ret;
+
+	priv->tx_busy = false;
+
+	ret = open_candev(netdev);
+	if (ret)
+		return ret;
+
+	netif_wake_queue(netdev);
+
+	return 0;
+}
+
+static int lin_stop(struct net_device *net)
+{
+	close_candev(net);
+
+	return 0;
+}
+
+static const struct net_device_ops lin_netdev_ops = {
+	.ndo_open = lin_open,
+	.ndo_stop = lin_stop,
+	.ndo_start_xmit = lin_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
+};
+
+int lin_rx(struct lin_device *priv, u8 id, u8 n, u8 *data, u8 checksum)
+{
+	struct net_device *ndev = priv->net;
+	struct net_device_stats *stats = &ndev->stats;
+	struct canfd_frame *cfd;
+	struct sk_buff *skb;
+
+	skb = alloc_canfd_skb(ndev, &cfd);
+	if (unlikely(!skb)) {
+		stats->rx_dropped++;
+		return -ENOMEM;
+	}
+
+	cfd->flags = CANFD_LIN;
+	cfd->can_id = id;
+	cfd->len = n + 1;	/* n of data + checksum */
+	memcpy(cfd->data, data, n);
+	cfd->data[n] = checksum;
+
+	stats->rx_bytes += cfd->len;
+	stats->rx_packets++;
+
+	netif_receive_skb(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lin_rx);
+
+static int lin_set_bittiming(struct net_device *netdev)
+{
+	struct lin_device *priv = netdev_priv(netdev);
+	struct device *dev = priv->dev;
+	int ret;
+
+	ret = priv->lindev_ops->update_bitrate(dev, priv->can.bittiming.bitrate);
+
+	return ret;
+}
+
+static const u32 lin_bitrate[] = { 2400, 4800, 9600, 19200 };
+
+struct lin_device *register_lin(struct device *dev,
+				const struct lin_device_ops *ldops)
+{
+	struct net_device *ndev;
+	struct lin_device *priv;
+	int ret;
+
+	ndev = alloc_candev(sizeof(struct lin_device), 1);
+	if (!ndev)
+		return NULL;
+
+	ndev->netdev_ops = &lin_netdev_ops;
+	ndev->flags |= IFF_ECHO;
+	ndev->mtu = CANFD_MTU;
+
+	priv = netdev_priv(ndev);
+	priv->lindev_ops = ldops;
+	priv->can.bittiming.bitrate = 9600;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LIN;
+	priv->can.bitrate_const = lin_bitrate;
+	priv->can.bitrate_const_cnt = ARRAY_SIZE(lin_bitrate);
+	priv->can.do_set_bittiming = lin_set_bittiming;
+	priv->net = ndev;
+	priv->dev = dev;
+
+	SET_NETDEV_DEV(ndev, dev);
+
+	ret = register_candev(ndev);
+	if (ret)
+		goto exit_free;
+
+	priv->wq = alloc_workqueue(dev_name(dev), WQ_FREEZABLE | WQ_MEM_RECLAIM,
+				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto exit_free;
+	}
+	INIT_WORK(&priv->tx_work, lin_tx_work_handler);
+
+	netdev_info(ndev, "LIN initialized.\n");
+
+	return priv;
+
+exit_free:
+	free_candev(ndev);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(register_lin);
+
+void unregister_lin(struct lin_device *priv)
+{
+	unregister_candev(priv->net);
+
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
+	free_candev(priv->net);
+}
+EXPORT_SYMBOL_GPL(unregister_lin);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Fritz <christoph.fritz@hexdev.de>");
+MODULE_DESCRIPTION("LIN bus to CAN glue driver");
diff --git a/include/net/lin.h b/include/net/lin.h
new file mode 100644
index 000000000000..d3264844ce16
--- /dev/null
+++ b/include/net/lin.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _NET_LIN_H_
+#define _NET_LIN_H_
+
+#include <linux/can/dev.h>
+#include <linux/device.h>
+
+struct lin_device_ops {
+	int (*ldo_tx)(struct device *dev, u8 id, u8 n, u8 *data);
+	int (*update_bitrate)(struct device *dev, u16 bitrate);
+};
+
+struct lin_device {
+	struct can_priv can;
+	struct net_device *net;
+	const struct lin_device_ops *lindev_ops;
+	struct device *dev;
+	struct workqueue_struct *wq;
+	struct work_struct tx_work;
+	bool tx_busy;
+	struct sk_buff *tx_skb;
+};
+
+int lin_rx(struct lin_device *dev, u8 id, u8 n, u8 *bytes, u8 checksum);
+
+struct lin_device *register_lin(struct device *dev,
+				const struct lin_device_ops *ldops);
+void unregister_lin(struct lin_device *lbd);
+
+#endif /* _NET_LIN_H_ */
diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 90801ada2bbe..8596f9b23c68 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -147,6 +147,7 @@ struct can_frame {
 #define CANFD_BRS 0x01 /* bit rate switch (second bitrate for payload data) */
 #define CANFD_ESI 0x02 /* error state indicator of the transmitting node */
 #define CANFD_FDF 0x04 /* mark CAN FD for dual use of struct canfd_frame */
+#define CANFD_LIN 0x08 /* indicate LIN mode */
 
 /**
  * struct canfd_frame - CAN flexible data rate frame structure
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 02ec32d69474..d65a24b2aa3c 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -103,6 +103,7 @@ struct can_ctrlmode {
 #define CAN_CTRLMODE_CC_LEN8_DLC	0x100	/* Classic CAN DLC option */
 #define CAN_CTRLMODE_TDC_AUTO		0x200	/* CAN transiver automatically calculates TDCV */
 #define CAN_CTRLMODE_TDC_MANUAL		0x400	/* TDCV is manually set up by user */
+#define CAN_CTRLMODE_LIN		0x800	/* LIN BUS mode */
 
 /*
  * CAN device statistics
-- 
2.30.2

