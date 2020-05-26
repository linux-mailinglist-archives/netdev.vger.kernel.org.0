Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5991D5E38
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 05:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgEPDYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 23:24:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50948 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEPDYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 23:24:48 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1EB7E3846B1DB85CBE38;
        Sat, 16 May 2020 11:24:46 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 16 May 2020 11:24:36 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1] hinic: add set_channels ethtool_ops support
Date:   Fri, 15 May 2020 19:42:12 +0000
Message-ID: <20200515194212.10381-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to change TX/RX queue number with ethtool -L

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 46 +++++++++++++++----
 .../net/ethernet/huawei/hinic/hinic_main.c    |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  5 ++
 3 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index ace18d258049..9796c1fbe132 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -619,14 +619,43 @@ static void hinic_get_channels(struct net_device *netdev,
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 
-	channels->max_rx = hwdev->nic_cap.max_qps;
-	channels->max_tx = hwdev->nic_cap.max_qps;
-	channels->max_other = 0;
-	channels->max_combined = 0;
-	channels->rx_count = hinic_hwdev_num_qps(hwdev);
-	channels->tx_count = hinic_hwdev_num_qps(hwdev);
-	channels->other_count = 0;
-	channels->combined_count = 0;
+	channels->max_combined = nic_dev->max_qps;
+	channels->combined_count = hinic_hwdev_num_qps(hwdev);
+}
+
+static int hinic_set_channels(struct net_device *netdev,
+			      struct ethtool_channels *channels)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	unsigned int count = channels->combined_count;
+	int err;
+
+	if (!count) {
+		netif_err(nic_dev, drv, netdev,
+			  "Unsupported combined_count: 0\n");
+		return -EINVAL;
+	}
+
+	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
+		   hinic_hwdev_num_qps(nic_dev->hwdev), count);
+
+	if (netif_running(netdev)) {
+		netif_info(nic_dev, drv, netdev, "Restarting netdev\n");
+		hinic_close(netdev);
+
+		nic_dev->hwdev->nic_cap.num_qps = count;
+
+		err = hinic_open(netdev);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to open netdev\n");
+			return -EFAULT;
+		}
+	} else {
+		nic_dev->hwdev->nic_cap.num_qps = count;
+	}
+
+	return 0;
 }
 
 static int hinic_get_rss_hash_opts(struct hinic_dev *nic_dev,
@@ -1219,6 +1248,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
 	.get_channels = hinic_get_channels,
+	.set_channels = hinic_set_channels,
 	.get_rxnfc = hinic_get_rxnfc,
 	.set_rxnfc = hinic_set_rxnfc,
 	.get_rxfh_key_size = hinic_get_rxfh_key_size,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index e3ff119fe341..2c07b03bf6e5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -326,7 +326,6 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
 	int i, node, err = 0;
 	u16 num_cpus = 0;
 
-	nic_dev->max_qps = hinic_hwdev_max_num_qps(hwdev);
 	if (nic_dev->max_qps <= 1) {
 		nic_dev->flags &= ~HINIC_RSS_ENABLE;
 		nic_dev->rss_limit = nic_dev->max_qps;
@@ -1043,6 +1042,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->rq_depth = HINIC_RQ_DEPTH;
 	nic_dev->sriov_info.hwdev = hwdev;
 	nic_dev->sriov_info.pdev = pdev;
+	nic_dev->max_qps = num_qps;
 
 	sema_init(&nic_dev->mgmt_lock, 1);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 4c66a0bc1b28..6da761d7a6ef 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -470,6 +470,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	struct hinic_txq *txq;
 	struct hinic_qp *qp;
 
+	if (unlikely(!netif_carrier_ok(netdev))) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
 	txq = &nic_dev->txqs[q_id];
 	qp = container_of(txq->sq, struct hinic_qp, sq);
 
-- 
2.17.1

