Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3CB59989
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfF1LwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7675 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfF1LwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:08 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 02B9D2ED33F544117C4B;
        Fri, 28 Jun 2019 19:52:06 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:51:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: fix __QUEUE_STATE_STACK_XOFF not cleared issue
Date:   Fri, 28 Jun 2019 19:50:07 +0800
Message-ID: <1561722618-12168-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When change MTU or other operations, which just calling .reset_notify
to do HNAE3_DOWN_CLIENT and HNAE3_UP_CLIENT, then
the netdev_tx_reset_queue() in the hns3_clear_all_ring() will be
ignored. So the dev_watchdog() may misdiagnose a TX timeout.

This patch separates netdev_tx_reset_queue() from
hns3_clear_all_ring(), and unifies hns3_clear_all_ring() and
hns3_force_clear_all_ring into one, since they are doing
similar things.

Fixes: 3a30964a2eef ("net: hns3: delay ring buffer clearing during reset")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 54 ++++++++++++-------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b23652c..a5d46f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -28,8 +28,7 @@
 #define hns3_set_field(origin, shift, val)	((origin) |= ((val) << (shift)))
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
-static void hns3_clear_all_ring(struct hnae3_handle *h);
-static void hns3_force_clear_all_ring(struct hnae3_handle *h);
+static void hns3_clear_all_ring(struct hnae3_handle *h, bool force);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
@@ -463,6 +462,20 @@ static int hns3_nic_net_open(struct net_device *netdev)
 	return 0;
 }
 
+static void hns3_reset_tx_queue(struct hnae3_handle *h)
+{
+	struct net_device *ndev = h->kinfo.netdev;
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct netdev_queue *dev_queue;
+	u32 i;
+
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		dev_queue = netdev_get_tx_queue(ndev,
+						priv->ring_data[i].queue_index);
+		netdev_tx_reset_queue(dev_queue);
+	}
+}
+
 static void hns3_nic_net_down(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -493,7 +506,9 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	 * to disable the ring through firmware when downing the netdev.
 	 */
 	if (!hns3_nic_resetting(netdev))
-		hns3_clear_all_ring(priv->ae_handle);
+		hns3_clear_all_ring(priv->ae_handle, false);
+
+	hns3_reset_tx_queue(priv->ae_handle);
 }
 
 static int hns3_nic_net_stop(struct net_device *netdev)
@@ -3921,7 +3936,7 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_del_all_fd_rules(netdev, true);
 
-	hns3_force_clear_all_ring(handle);
+	hns3_clear_all_ring(handle, true);
 
 	hns3_nic_uninit_vector_data(priv);
 
@@ -4090,43 +4105,26 @@ static void hns3_force_clear_rx_ring(struct hns3_enet_ring *ring)
 	}
 }
 
-static void hns3_force_clear_all_ring(struct hnae3_handle *h)
-{
-	struct net_device *ndev = h->kinfo.netdev;
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hns3_enet_ring *ring;
-	u32 i;
-
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		ring = priv->ring_data[i].ring;
-		hns3_clear_tx_ring(ring);
-
-		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
-		hns3_force_clear_rx_ring(ring);
-	}
-}
-
-static void hns3_clear_all_ring(struct hnae3_handle *h)
+static void hns3_clear_all_ring(struct hnae3_handle *h, bool force)
 {
 	struct net_device *ndev = h->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	u32 i;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		struct netdev_queue *dev_queue;
 		struct hns3_enet_ring *ring;
 
 		ring = priv->ring_data[i].ring;
 		hns3_clear_tx_ring(ring);
-		dev_queue = netdev_get_tx_queue(ndev,
-						priv->ring_data[i].queue_index);
-		netdev_tx_reset_queue(dev_queue);
 
 		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
 		/* Continue to clear other rings even if clearing some
 		 * rings failed.
 		 */
-		hns3_clear_rx_ring(ring);
+		if (force)
+			hns3_force_clear_rx_ring(ring);
+		else
+			hns3_clear_rx_ring(ring);
 	}
 }
 
@@ -4331,8 +4329,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return 0;
 	}
 
-	hns3_clear_all_ring(handle);
-	hns3_force_clear_all_ring(handle);
+	hns3_clear_all_ring(handle, true);
+	hns3_reset_tx_queue(priv->ae_handle);
 
 	hns3_nic_uninit_vector_data(priv);
 
-- 
2.7.4

