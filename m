Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9901746177B
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343563AbhK2OK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:29 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16315 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbhK2OI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:26 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCl4j5rz91Rn;
        Mon, 29 Nov 2021 22:04:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:06 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:06 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 04/10] net: hns3: split function hns3_get_tx_timeo_queue_info()
Date:   Mon, 29 Nov 2021 22:00:21 +0800
Message-ID: <20211129140027.23036-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Function hns3_get_tx_timeo_queue_info() is a bit too long. So add two
new functions hns3_dump_queue_stats() and hns3_dump_queue_reg() to
simplify code and improve code readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 100 +++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   5 +
 2 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 731cefb3563c..cc962e5f563b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2659,18 +2659,8 @@ static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 	return ret;
 }
 
-static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
+static int hns3_get_timeout_queue(struct net_device *ndev)
 {
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = hns3_get_handle(ndev);
-	struct hns3_enet_ring *tx_ring;
-	struct napi_struct *napi;
-	int timeout_queue = 0;
-	int hw_head, hw_tail;
-	int fbd_num, fbd_oft;
-	int ebd_num, ebd_oft;
-	int bd_num, bd_err;
-	int ring_en, tc;
 	int i;
 
 	/* Find the stopped queue the same way the stack does */
@@ -2690,7 +2680,6 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 				    dql->last_obj_cnt, dql->num_queued,
 				    dql->adj_limit, dql->num_completed);
 #endif
-			timeout_queue = i;
 			netdev_info(ndev, "queue state: 0x%lx, delta msecs: %u\n",
 				    q->state,
 				    jiffies_to_msecs(jiffies - trans_start));
@@ -2698,17 +2687,15 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		}
 	}
 
-	if (i == ndev->num_tx_queues) {
-		netdev_info(ndev,
-			    "no netdev TX timeout queue found, timeout count: %llu\n",
-			    priv->tx_timeout_count);
-		return false;
-	}
-
-	priv->tx_timeout_count++;
+	return i;
+}
 
-	tx_ring = &priv->ring[timeout_queue];
-	napi = &tx_ring->tqp_vector->napi;
+static void hns3_dump_queue_stats(struct net_device *ndev,
+				  struct hns3_enet_ring *tx_ring,
+				  int timeout_queue)
+{
+	struct napi_struct *napi = &tx_ring->tqp_vector->napi;
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
 
 	netdev_info(ndev,
 		    "tx_timeout count: %llu, queue id: %d, SW_NTU: 0x%x, SW_NTC: 0x%x, napi state: %lu\n",
@@ -2724,6 +2711,48 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    "seg_pkt_cnt: %llu, tx_more: %llu, restart_queue: %llu, tx_busy: %llu\n",
 		    tx_ring->stats.seg_pkt_cnt, tx_ring->stats.tx_more,
 		    tx_ring->stats.restart_queue, tx_ring->stats.tx_busy);
+}
+
+static void hns3_dump_queue_reg(struct net_device *ndev,
+				struct hns3_enet_ring *tx_ring)
+{
+	netdev_info(ndev,
+		    "BD_NUM: 0x%x HW_HEAD: 0x%x, HW_TAIL: 0x%x, BD_ERR: 0x%x, INT: 0x%x\n",
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_BD_NUM_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_HEAD_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_TAIL_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_BD_ERR_REG),
+		    readl(tx_ring->tqp_vector->mask_addr));
+	netdev_info(ndev,
+		    "RING_EN: 0x%x, TC: 0x%x, FBD_NUM: 0x%x FBD_OFT: 0x%x, EBD_NUM: 0x%x, EBD_OFT: 0x%x\n",
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_EN_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_TC_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_FBDNUM_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_OFFSET_REG),
+		    hns3_tqp_read_reg(tx_ring, HNS3_RING_TX_RING_EBDNUM_REG),
+		    hns3_tqp_read_reg(tx_ring,
+				      HNS3_RING_TX_RING_EBD_OFFSET_REG));
+}
+
+static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+	struct hns3_enet_ring *tx_ring;
+	int timeout_queue;
+
+	timeout_queue = hns3_get_timeout_queue(ndev);
+	if (timeout_queue >= ndev->num_tx_queues) {
+		netdev_info(ndev,
+			    "no netdev TX timeout queue found, timeout count: %llu\n",
+			    priv->tx_timeout_count);
+		return false;
+	}
+
+	priv->tx_timeout_count++;
+
+	tx_ring = &priv->ring[timeout_queue];
+	hns3_dump_queue_stats(ndev, tx_ring, timeout_queue);
 
 	/* When mac received many pause frames continuous, it's unable to send
 	 * packets, which may cause tx timeout
@@ -2736,32 +2765,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 			    mac_stats.tx_pause_cnt, mac_stats.rx_pause_cnt);
 	}
 
-	hw_head = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_HEAD_REG);
-	hw_tail = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_TAIL_REG);
-	fbd_num = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_FBDNUM_REG);
-	fbd_oft = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_OFFSET_REG);
-	ebd_num = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_EBDNUM_REG);
-	ebd_oft = readl_relaxed(tx_ring->tqp->io_base +
-				HNS3_RING_TX_RING_EBD_OFFSET_REG);
-	bd_num = readl_relaxed(tx_ring->tqp->io_base +
-			       HNS3_RING_TX_RING_BD_NUM_REG);
-	bd_err = readl_relaxed(tx_ring->tqp->io_base +
-			       HNS3_RING_TX_RING_BD_ERR_REG);
-	ring_en = readl_relaxed(tx_ring->tqp->io_base + HNS3_RING_EN_REG);
-	tc = readl_relaxed(tx_ring->tqp->io_base + HNS3_RING_TX_RING_TC_REG);
-
-	netdev_info(ndev,
-		    "BD_NUM: 0x%x HW_HEAD: 0x%x, HW_TAIL: 0x%x, BD_ERR: 0x%x, INT: 0x%x\n",
-		    bd_num, hw_head, hw_tail, bd_err,
-		    readl(tx_ring->tqp_vector->mask_addr));
-	netdev_info(ndev,
-		    "RING_EN: 0x%x, TC: 0x%x, FBD_NUM: 0x%x FBD_OFT: 0x%x, EBD_NUM: 0x%x, EBD_OFT: 0x%x\n",
-		    ring_en, tc, fbd_num, fbd_oft, ebd_num, ebd_oft);
+	hns3_dump_queue_reg(ndev, tx_ring);
 
 	return true;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 361a6390e159..808405cc0280 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -621,6 +621,11 @@ static inline int ring_space(struct hns3_enet_ring *ring)
 			(begin - end)) - 1;
 }
 
+static inline u32 hns3_tqp_read_reg(struct hns3_enet_ring *ring, u32 reg)
+{
+	return readl_relaxed(ring->tqp->io_base + reg);
+}
+
 static inline u32 hns3_read_reg(void __iomem *base, u32 reg)
 {
 	return readl(base + reg);
-- 
2.33.0

