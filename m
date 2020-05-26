Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658AF1D2768
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgENGUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:20:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4783 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbgENGUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 02:20:11 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7A5E82F506009A4B19BA;
        Thu, 14 May 2020 14:20:05 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 14:19:58 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next] hinic: add set_ringparam ethtool_ops support
Date:   Wed, 13 May 2020 22:37:33 +0000
Message-ID: <20200513223733.6854-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

support to change TX/RX queue depth with ethtool -G

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  2 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 78 ++++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 11 ++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |  4 +-
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |  3 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.c   |  1 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |  3 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  9 ++-
 .../net/ethernet/huawei/hinic/hinic_port.c    |  2 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |  4 +
 11 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index a621ebbf7610..48b40be3e84d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -69,6 +69,8 @@ struct hinic_dev {
 
 	struct hinic_txq                *txqs;
 	struct hinic_rxq                *rxqs;
+	u16				sq_depth;
+	u16				rq_depth;
 
 	struct hinic_txq_stats          tx_stats;
 	struct hinic_rxq_stats          rx_stats;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index b426eeced069..ace18d258049 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -538,12 +538,81 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 static void hinic_get_ringparam(struct net_device *netdev,
 				struct ethtool_ringparam *ring)
 {
-	ring->rx_max_pending = HINIC_RQ_DEPTH;
-	ring->tx_max_pending = HINIC_SQ_DEPTH;
-	ring->rx_pending = HINIC_RQ_DEPTH;
-	ring->tx_pending = HINIC_SQ_DEPTH;
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+
+	ring->rx_max_pending = HINIC_MAX_QUEUE_DEPTH;
+	ring->tx_max_pending = HINIC_MAX_QUEUE_DEPTH;
+	ring->rx_pending = nic_dev->rq_depth;
+	ring->tx_pending = nic_dev->sq_depth;
 }
 
+static int check_ringparam_valid(struct hinic_dev *nic_dev,
+				 struct ethtool_ringparam *ring)
+{
+	if (ring->rx_jumbo_pending || ring->rx_mini_pending) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Unsupported rx_jumbo_pending/rx_mini_pending\n");
+		return -EINVAL;
+	}
+
+	if (ring->tx_pending > HINIC_MAX_QUEUE_DEPTH ||
+	    ring->tx_pending < HINIC_MIN_QUEUE_DEPTH ||
+	    ring->rx_pending > HINIC_MAX_QUEUE_DEPTH ||
+	    ring->rx_pending < HINIC_MIN_QUEUE_DEPTH) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Queue depth out of range [%d-%d]\n",
+			  HINIC_MIN_QUEUE_DEPTH, HINIC_MAX_QUEUE_DEPTH);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hinic_set_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u16 new_sq_depth, new_rq_depth;
+	int err;
+
+	err = check_ringparam_valid(nic_dev, ring);
+	if (err)
+		return err;
+
+	new_sq_depth = (u16)(1U << (u16)ilog2(ring->tx_pending));
+	new_rq_depth = (u16)(1U << (u16)ilog2(ring->rx_pending));
+
+	if (new_sq_depth == nic_dev->sq_depth &&
+	    new_rq_depth == nic_dev->rq_depth)
+		return 0;
+
+	netif_info(nic_dev, drv, netdev,
+		   "Change Tx/Rx ring depth from %d/%d to %d/%d\n",
+		   nic_dev->sq_depth, nic_dev->rq_depth,
+		   new_sq_depth, new_rq_depth);
+
+	nic_dev->sq_depth = new_sq_depth;
+	nic_dev->rq_depth = new_rq_depth;
+
+	if (netif_running(netdev)) {
+		netif_info(nic_dev, drv, netdev, "Restarting netdev\n");
+		err = hinic_close(netdev);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to close netdev\n");
+			return -EFAULT;
+		}
+
+		err = hinic_open(netdev);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to open netdev\n");
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
 static void hinic_get_channels(struct net_device *netdev,
 			       struct ethtool_channels *channels)
 {
@@ -1148,6 +1217,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
+	.set_ringparam = hinic_set_ringparam,
 	.get_channels = hinic_get_channels,
 	.get_rxnfc = hinic_get_rxnfc,
 	.set_rxnfc = hinic_set_rxnfc,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 2879b0445eba..0245da02efbb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -269,8 +269,8 @@ static int init_fw_ctxt(struct hinic_hwdev *hwdev)
  *
  * Return 0 - Success, negative - Failure
  **/
-static int set_hw_ioctxt(struct hinic_hwdev *hwdev, unsigned int rq_depth,
-			 unsigned int sq_depth)
+static int set_hw_ioctxt(struct hinic_hwdev *hwdev, unsigned int sq_depth,
+			 unsigned int rq_depth)
 {
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_cmd_hw_ioctxt hw_ioctxt;
@@ -435,7 +435,7 @@ static int get_base_qpn(struct hinic_hwdev *hwdev, u16 *base_qpn)
  *
  * Return 0 - Success, negative - Failure
  **/
-int hinic_hwdev_ifup(struct hinic_hwdev *hwdev)
+int hinic_hwdev_ifup(struct hinic_hwdev *hwdev, u16 sq_depth, u16 rq_depth)
 {
 	struct hinic_func_to_io *func_to_io = &hwdev->func_to_io;
 	struct hinic_cap *nic_cap = &hwdev->nic_cap;
@@ -458,6 +458,9 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev)
 
 	ceq_msix_entries = &hwdev->msix_entries[num_aeqs];
 	func_to_io->hwdev = hwdev;
+	func_to_io->sq_depth = sq_depth;
+	func_to_io->rq_depth = rq_depth;
+
 	err = hinic_io_init(func_to_io, hwif, nic_cap->max_qps, num_ceqs,
 			    ceq_msix_entries);
 	if (err) {
@@ -482,7 +485,7 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev)
 		hinic_db_state_set(hwif, HINIC_DB_ENABLE);
 	}
 
-	err = set_hw_ioctxt(hwdev, HINIC_SQ_DEPTH, HINIC_RQ_DEPTH);
+	err = set_hw_ioctxt(hwdev, sq_depth, rq_depth);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to set HW IO ctxt\n");
 		goto err_hw_ioctxt;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index ce57914bef72..71ea7e46dbbc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -347,7 +347,7 @@ int hinic_hilink_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_hilink_cmd cmd,
 			 void *buf_in, u16 in_size, void *buf_out,
 			 u16 *out_size);
 
-int hinic_hwdev_ifup(struct hinic_hwdev *hwdev);
+int hinic_hwdev_ifup(struct hinic_hwdev *hwdev, u16 sq_depth, u16 rq_depth);
 
 void hinic_hwdev_ifdown(struct hinic_hwdev *hwdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index a4581c988a63..3e3fa742e476 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -282,7 +282,7 @@ static int init_qp(struct hinic_func_to_io *func_to_io,
 
 	err = hinic_wq_allocate(&func_to_io->wqs, &func_to_io->sq_wq[q_id],
 				HINIC_SQ_WQEBB_SIZE, HINIC_SQ_PAGE_SIZE,
-				HINIC_SQ_DEPTH, HINIC_SQ_WQE_MAX_SIZE);
+				func_to_io->sq_depth, HINIC_SQ_WQE_MAX_SIZE);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate WQ for SQ\n");
 		return err;
@@ -290,7 +290,7 @@ static int init_qp(struct hinic_func_to_io *func_to_io,
 
 	err = hinic_wq_allocate(&func_to_io->wqs, &func_to_io->rq_wq[q_id],
 				HINIC_RQ_WQEBB_SIZE, HINIC_RQ_PAGE_SIZE,
-				HINIC_RQ_DEPTH, HINIC_RQ_WQE_SIZE);
+				func_to_io->rq_depth, HINIC_RQ_WQE_SIZE);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate WQ for RQ\n");
 		goto err_rq_alloc;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
index 28c0594f636d..214f162f7579 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
@@ -60,6 +60,9 @@ struct hinic_func_to_io {
 	struct hinic_qp         *qps;
 	u16                     max_qps;
 
+	u16			sq_depth;
+	u16			rq_depth;
+
 	void __iomem            **sq_db;
 	void __iomem            *db_base;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
index 20c5c8ea452e..fcf7bfe4aa47 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
@@ -643,6 +643,7 @@ void hinic_sq_write_db(struct hinic_sq *sq, u16 prod_idx, unsigned int wqe_size,
 
 	/* increment prod_idx to the next */
 	prod_idx += ALIGN(wqe_size, wq->wqebb_size) / wq->wqebb_size;
+	prod_idx = SQ_MASKED_IDX(sq, prod_idx);
 
 	wmb();  /* Write all before the doorbell */
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index c30d092e48d5..ca3e2d060284 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -44,6 +44,9 @@
 #define HINIC_SQ_DEPTH                          SZ_4K
 #define HINIC_RQ_DEPTH                          SZ_4K
 
+#define HINIC_MAX_QUEUE_DEPTH			SZ_4K
+#define HINIC_MIN_QUEUE_DEPTH			128
+
 /* In any change to HINIC_RX_BUF_SZ, HINIC_RX_BUF_SZ_IDX must be changed */
 #define HINIC_RX_BUF_SZ                         2048
 #define HINIC_RX_BUF_SZ_IDX			HINIC_RX_BUF_SZ_2048_IDX
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 3d6569d7bac8..e3ff119fe341 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -372,14 +372,15 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
 		netif_err(nic_dev, drv, netdev, "Failed to init rss\n");
 }
 
-static int hinic_open(struct net_device *netdev)
+int hinic_open(struct net_device *netdev)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	enum hinic_port_link_state link_state;
 	int err, ret;
 
 	if (!(nic_dev->flags & HINIC_INTF_UP)) {
-		err = hinic_hwdev_ifup(nic_dev->hwdev);
+		err = hinic_hwdev_ifup(nic_dev->hwdev, nic_dev->sq_depth,
+				       nic_dev->rq_depth);
 		if (err) {
 			netif_err(nic_dev, drv, netdev,
 				  "Failed - HW interface up\n");
@@ -483,7 +484,7 @@ static int hinic_open(struct net_device *netdev)
 	return err;
 }
 
-static int hinic_close(struct net_device *netdev)
+int hinic_close(struct net_device *netdev)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	unsigned int flags;
@@ -1038,6 +1039,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->rxqs = NULL;
 	nic_dev->tx_weight = tx_weight;
 	nic_dev->rx_weight = rx_weight;
+	nic_dev->sq_depth = HINIC_SQ_DEPTH;
+	nic_dev->rq_depth = HINIC_RQ_DEPTH;
 	nic_dev->sriov_info.hwdev = hwdev;
 	nic_dev->sriov_info.pdev = pdev;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 2edb6127f9fb..175c0ee00038 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -473,7 +473,7 @@ int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
 
 	rq_num.func_id = HINIC_HWIF_FUNC_IDX(hwif);
 	rq_num.num_rqs = num_rqs;
-	rq_num.rq_depth = ilog2(HINIC_SQ_DEPTH);
+	rq_num.rq_depth = ilog2(nic_dev->rq_depth);
 
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_RQ_IQ_MAP,
 				 &rq_num, sizeof(rq_num),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 5f34308abd2b..661c6322dc15 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -736,4 +736,8 @@ int hinic_get_hw_pause_info(struct hinic_hwdev *hwdev,
 int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
 			    struct hinic_pause_config *pause_info);
 
+int hinic_open(struct net_device *netdev);
+
+int hinic_close(struct net_device *netdev);
+
 #endif
-- 
2.17.1

