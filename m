Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6947D1EB2C9
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 02:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgFBAlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 20:41:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbgFBAlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 20:41:51 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 22E8767B2CD1C870F4BF;
        Tue,  2 Jun 2020 08:41:48 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 2 Jun 2020 08:41:39 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v6] hinic: add set_channels ethtool_ops support
Date:   Tue, 2 Jun 2020 08:40:32 +0800
Message-ID: <20200602004032.31919-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to change TX/RX queue number with "ethtool -L combined".

V5 -> V6: remove check for carrier in hinic_xmit_frame
V4 -> V5: change time zone in patch header
V3 -> V4: update date in patch header
V2 -> V3: remove check for zero channels->combined_count
V1 -> V2: update commit message("ethtool -L" to "ethtool -L combined")
V0 -> V1: remove check for channels->tx_count/rx_count/other_count

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 40 +++++++++++++++----
 .../net/ethernet/huawei/hinic/hinic_main.c    |  2 +-
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index ace18d258049..efb02e03e7da 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -619,14 +619,37 @@ static void hinic_get_channels(struct net_device *netdev,
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
@@ -1219,6 +1242,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
 	.get_channels = hinic_get_channels,
+	.set_channels = hinic_set_channels,
 	.get_rxnfc = hinic_get_rxnfc,
 	.set_rxnfc = hinic_set_rxnfc,
 	.get_rxfh_key_size = hinic_get_rxfh_key_size,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c8ab129a7ae8..e9e6f4c9309a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -326,7 +326,6 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
 	int i, node, err = 0;
 	u16 num_cpus = 0;
 
-	nic_dev->max_qps = hinic_hwdev_max_num_qps(hwdev);
 	if (nic_dev->max_qps <= 1) {
 		nic_dev->flags &= ~HINIC_RSS_ENABLE;
 		nic_dev->rss_limit = nic_dev->max_qps;
@@ -1031,6 +1030,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->rq_depth = HINIC_RQ_DEPTH;
 	nic_dev->sriov_info.hwdev = hwdev;
 	nic_dev->sriov_info.pdev = pdev;
+	nic_dev->max_qps = num_qps;
 
 	sema_init(&nic_dev->mgmt_lock, 1);
 
-- 
2.17.1

