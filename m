Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101A546CBDA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbhLHEHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:07:54 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34148 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232169AbhLHEHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:07:54 -0500
X-UUID: 1a1c6174d59640149656d99cc174e861-20211208
X-UUID: 1a1c6174d59640149656d99cc174e861-20211208
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <xiayu.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1867305673; Wed, 08 Dec 2021 12:04:19 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 8 Dec 2021 12:04:18 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 8 Dec 2021 12:04:17 +0800
From:   <xiayu.zhang@mediatek.com>
To:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xiayu.zhang@mediatek.com>,
        <haijun.liu@mediatek.com>, <zhaoping.shu@mediatek.com>,
        <hw.he@mediatek.com>, <srv_heupstream@mediatek.com>,
        Xiayu Zhang <Xiayu.Zhang@mediatek.com>
Subject: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
Date:   Wed, 8 Dec 2021 12:04:14 +0800
Message-ID: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiayu Zhang <Xiayu.Zhang@mediatek.com>

This patch adds 2 callback functions get_num_tx_queues() and
get_num_rx_queues() to let WWAN network device driver customize its own
TX and RX queue numbers. It gives WWAN driver a chance to implement its
own software strategies, such as TX Qos.

Currently, if WWAN device driver creates default bearer interface when
calling wwan_register_ops(), there will be only 1 TX queue and 1 RX queue
for the WWAN network device. In this case, driver is not able to enlarge
the queue numbers by calling netif_set_real_num_tx_queues() or
netif_set_real_num_rx_queues() to take advantage of the network device's
capability of supporting multiple TX/RX queues.

As for additional interfaces of secondary bearers, if userspace service
doesn't specify the num_tx_queues or num_rx_queues in netlink message or
iproute2 command, there also will be only 1 TX queue and 1 RX queue for
each additional interface. If userspace service specifies the num_tx_queues
and num_rx_queues, however, these numbers could be not able to match the
capabilities of network device.

Besides, userspace service is hard to learn every WWAN network device's
TX/RX queue numbers.

In order to let WWAN driver determine the queue numbers, this patch adds
below callback functions in wwan_ops:
    struct wwan_ops {
        unsigned int priv_size;
        ...
        unsigned int (*get_num_tx_queues)(unsigned int hint_num);
        unsigned int (*get_num_rx_queues)(unsigned int hint_num);
    };

WWAN subsystem uses the input parameters num_tx_queues and num_rx_queues of
wwan_rtnl_alloc() as hint values, and passes the 2 values to the two
callback functions. WWAN device driver should determine the actual numbers
of network device's TX and RX queues according to the hint value and
device's capabilities.

Signed-off-by: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
---
 drivers/net/wwan/wwan_core.c | 25 ++++++++++++++++++++++++-
 include/linux/wwan.h         |  6 ++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index d293ab688044..00095c6987be 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -823,6 +823,7 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
 	struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
 	struct net_device *dev;
 	unsigned int priv_size;
+	unsigned int num_txqs, num_rxqs;
 
 	if (IS_ERR(wwandev))
 		return ERR_CAST(wwandev);
@@ -833,9 +834,31 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
 		goto out;
 	}
 
+	/* let wwan device driver determine TX queue number if it wants */
+	if (wwandev->ops->get_num_tx_queues) {
+		num_txqs = wwandev->ops->get_num_tx_queues(num_tx_queues);
+		if (num_txqs < 1 || num_txqs > 4096) {
+			dev = ERR_PTR(-EINVAL);
+			goto out;
+		}
+	} else {
+		num_txqs = num_tx_queues;
+	}
+
+	/* let wwan device driver determine RX queue number if it wants */
+	if (wwandev->ops->get_num_rx_queues) {
+		num_rxqs = wwandev->ops->get_num_rx_queues(num_rx_queues);
+		if (num_rxqs < 1 || num_rxqs > 4096) {
+			dev = ERR_PTR(-EINVAL);
+			goto out;
+		}
+	} else {
+		num_rxqs = num_rx_queues;
+	}
+
 	priv_size = sizeof(struct wwan_netdev_priv) + wwandev->ops->priv_size;
 	dev = alloc_netdev_mqs(priv_size, ifname, name_assign_type,
-			       wwandev->ops->setup, num_tx_queues, num_rx_queues);
+			       wwandev->ops->setup, num_txqs, num_rxqs);
 
 	if (dev) {
 		SET_NETDEV_DEV(dev, &wwandev->dev);
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 9fac819f92e3..69c0af7ab6af 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -156,6 +156,10 @@ static inline void *wwan_netdev_drvpriv(struct net_device *dev)
  * @setup: set up a new netdev
  * @newlink: register the new netdev
  * @dellink: remove the given netdev
+ * @get_num_tx_queues: determine number of transmit queues
+ *                     to create when creating a new device.
+ * @get_num_rx_queues: determine number of receive queues
+ *                     to create when creating a new device.
  */
 struct wwan_ops {
 	unsigned int priv_size;
@@ -164,6 +168,8 @@ struct wwan_ops {
 		       u32 if_id, struct netlink_ext_ack *extack);
 	void (*dellink)(void *ctxt, struct net_device *dev,
 			struct list_head *head);
+	unsigned int (*get_num_tx_queues)(unsigned int hint_num);
+	unsigned int (*get_num_rx_queues)(unsigned int hint_num);
 };
 
 int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
-- 
2.17.0

