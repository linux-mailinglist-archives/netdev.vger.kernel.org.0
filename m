Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEC1EC962
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgFCGVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:21:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55886 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbgFCGVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 02:21:35 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 51363FCC5D884C57325D;
        Wed,  3 Jun 2020 14:21:33 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 3 Jun 2020 14:21:24 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <chiqijun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next 3/5] hinic: add self test support
Date:   Wed, 3 Jun 2020 14:20:13 +0800
Message-ID: <20200603062015.12640-4-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603062015.12640-1-luobin9@huawei.com>
References: <20200603062015.12640-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to excute internal and external loopback test with
ethtool -t cmd.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   6 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 178 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   3 +
 .../net/ethernet/huawei/hinic/hinic_port.c    |  30 +++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  16 ++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  39 ++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  61 ++++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.h  |   2 +
 8 files changed, 335 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 75d6dee948f5..9adb755f0820 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -20,11 +20,14 @@
 
 #define HINIC_DRV_NAME          "hinic"
 
+#define LP_PKT_CNT		64
+
 enum hinic_flags {
 	HINIC_LINK_UP = BIT(0),
 	HINIC_INTF_UP = BIT(1),
 	HINIC_RSS_ENABLE = BIT(2),
 	HINIC_LINK_DOWN = BIT(3),
+	HINIC_LP_TEST = BIT(4),
 };
 
 struct hinic_rx_mode_work {
@@ -91,6 +94,9 @@ struct hinic_dev {
 	struct hinic_intr_coal_info	*rx_intr_coalesce;
 	struct hinic_intr_coal_info	*tx_intr_coalesce;
 	struct hinic_sriov_info sriov_info;
+	int				lb_test_rx_idx;
+	int				lb_pkt_len;
+	u8				*lb_test_rx_buf;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 753fc36f926c..5d6278cf74ad 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -150,6 +150,16 @@ static struct hw2ethtool_link_mode
 	},
 };
 
+#define LP_DEFAULT_TIME                 5 /* seconds */
+#define LP_PKT_LEN                      1514
+
+#define PORT_DOWN_ERR_IDX		0
+enum diag_test_index {
+	INTERNAL_LP_TEST = 0,
+	EXTERNAL_LP_TEST = 1,
+	DIAG_TEST_MAX = 2,
+};
+
 static void set_link_speed(struct ethtool_link_ksettings *link_ksettings,
 			   enum hinic_speed speed)
 {
@@ -1318,6 +1328,11 @@ static struct hinic_stats hinic_function_stats[] = {
 	HINIC_FUNC_STAT(rx_err_vport),
 };
 
+static char hinic_test_strings[][ETH_GSTRING_LEN] = {
+	"Internal lb test  (on/offline)",
+	"External lb test (external_lb)",
+};
+
 #define HINIC_PORT_STAT(_stat_item) { \
 	.name = #_stat_item, \
 	.size = sizeof_field(struct hinic_phy_port_stats, _stat_item), \
@@ -1527,6 +1542,8 @@ static int hinic_get_sset_count(struct net_device *netdev, int sset)
 	int count, q_num;
 
 	switch (sset) {
+	case ETH_SS_TEST:
+		return ARRAY_LEN(hinic_test_strings);
 	case ETH_SS_STATS:
 		q_num = nic_dev->num_qps;
 		count = ARRAY_LEN(hinic_function_stats) +
@@ -1549,6 +1566,9 @@ static void hinic_get_strings(struct net_device *netdev,
 	u16 i, j;
 
 	switch (stringset) {
+	case ETH_SS_TEST:
+		memcpy(data, *hinic_test_strings, sizeof(hinic_test_strings));
+		return;
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_LEN(hinic_function_stats); i++) {
 			memcpy(p, hinic_function_stats[i].name,
@@ -1582,6 +1602,163 @@ static void hinic_get_strings(struct net_device *netdev,
 	}
 }
 
+static int hinic_run_lp_test(struct hinic_dev *nic_dev, u32 test_time)
+{
+	u8 *lb_test_rx_buf = nic_dev->lb_test_rx_buf;
+	struct net_device *netdev = nic_dev->netdev;
+	struct sk_buff *skb_tmp = NULL;
+	struct sk_buff *skb = NULL;
+	u32 cnt = test_time * 5;
+	u8 *test_data = NULL;
+	u32 i;
+	u8 j;
+
+	skb_tmp = alloc_skb(LP_PKT_LEN, GFP_ATOMIC);
+	if (!skb_tmp)
+		return -ENOMEM;
+
+	test_data = __skb_put(skb_tmp, LP_PKT_LEN);
+
+	memset(test_data, 0xFF, 2 * ETH_ALEN);
+	test_data[ETH_ALEN] = 0xFE;
+	test_data[2 * ETH_ALEN] = 0x08;
+	test_data[2 * ETH_ALEN + 1] = 0x0;
+
+	for (i = ETH_HLEN; i < LP_PKT_LEN; i++)
+		test_data[i] = i & 0xFF;
+
+	skb_tmp->queue_mapping = 0;
+	skb_tmp->ip_summed = CHECKSUM_COMPLETE;
+	skb_tmp->dev = netdev;
+
+	for (i = 0; i < cnt; i++) {
+		nic_dev->lb_test_rx_idx = 0;
+		memset(lb_test_rx_buf, 0, LP_PKT_CNT * LP_PKT_LEN);
+
+		for (j = 0; j < LP_PKT_CNT; j++) {
+			skb = pskb_copy(skb_tmp, GFP_ATOMIC);
+			if (!skb) {
+				dev_kfree_skb_any(skb_tmp);
+				netif_err(nic_dev, drv, netdev,
+					  "Copy skb failed for loopback test\n");
+				return -ENOMEM;
+			}
+
+			/* mark index for every pkt */
+			skb->data[LP_PKT_LEN - 1] = j;
+
+			if (hinic_lb_xmit_frame(skb, netdev)) {
+				dev_kfree_skb_any(skb);
+				dev_kfree_skb_any(skb_tmp);
+				netif_err(nic_dev, drv, netdev,
+					  "Xmit pkt failed for loopback test\n");
+				return -EBUSY;
+			}
+		}
+
+		/* wait till all pkts received to RX buffer */
+		msleep(200);
+
+		for (j = 0; j < LP_PKT_CNT; j++) {
+			if (memcmp(lb_test_rx_buf + j * LP_PKT_LEN,
+				   skb_tmp->data, LP_PKT_LEN - 1) ||
+			    (*(lb_test_rx_buf + j * LP_PKT_LEN +
+			     LP_PKT_LEN - 1) != j)) {
+				dev_kfree_skb_any(skb_tmp);
+				netif_err(nic_dev, drv, netdev,
+					  "Compare pkt failed in loopback test(index=0x%02x, data[%d]=0x%02x)\n",
+					  j + i * LP_PKT_CNT,
+					  LP_PKT_LEN - 1,
+					  *(lb_test_rx_buf + j * LP_PKT_LEN +
+					    LP_PKT_LEN - 1));
+				return -EIO;
+			}
+		}
+	}
+
+	dev_kfree_skb_any(skb_tmp);
+	netif_info(nic_dev, drv, netdev, "Loopback test succeed.\n");
+	return 0;
+}
+
+static int do_lp_test(struct hinic_dev *nic_dev, u32 flags, u32 test_time,
+		      enum diag_test_index *test_index)
+{
+	struct net_device *netdev = nic_dev->netdev;
+	u8 *lb_test_rx_buf = NULL;
+	int err = 0;
+
+	if (!(flags & ETH_TEST_FL_EXTERNAL_LB)) {
+		*test_index = INTERNAL_LP_TEST;
+		if (hinic_set_loopback_mode(nic_dev->hwdev,
+					    HINIC_INTERNAL_LP_MODE, true)) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to set port loopback mode before loopback test\n");
+			return -EIO;
+		}
+	} else {
+		*test_index = EXTERNAL_LP_TEST;
+	}
+
+	lb_test_rx_buf = vmalloc(LP_PKT_CNT * LP_PKT_LEN);
+	if (!lb_test_rx_buf) {
+		err = -ENOMEM;
+	} else {
+		nic_dev->lb_test_rx_buf = lb_test_rx_buf;
+		nic_dev->lb_pkt_len = LP_PKT_LEN;
+		nic_dev->flags |= HINIC_LP_TEST;
+		err = hinic_run_lp_test(nic_dev, test_time);
+		nic_dev->flags &= ~HINIC_LP_TEST;
+		msleep(100);
+		vfree(lb_test_rx_buf);
+		nic_dev->lb_test_rx_buf = NULL;
+	}
+
+	if (!(flags & ETH_TEST_FL_EXTERNAL_LB)) {
+		if (hinic_set_loopback_mode(nic_dev->hwdev,
+					    HINIC_INTERNAL_LP_MODE, false)) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to cancel port loopback mode after loopback test\n");
+			err = -EIO;
+		}
+	}
+
+	return err;
+}
+
+static void hinic_diag_test(struct net_device *netdev,
+			    struct ethtool_test *eth_test, u64 *data)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	enum hinic_port_link_state link_state;
+	enum diag_test_index test_index = 0;
+	int err = 0;
+
+	memset(data, 0, DIAG_TEST_MAX * sizeof(u64));
+
+	/* don't support loopback test when netdev is closed. */
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, netdev,
+			  "Do not support loopback test when netdev is closed\n");
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[PORT_DOWN_ERR_IDX] = 1;
+		return;
+	}
+
+	netif_carrier_off(netdev);
+
+	err = do_lp_test(nic_dev, eth_test->flags, LP_DEFAULT_TIME,
+			 &test_index);
+	if (err) {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[test_index] = 1;
+	}
+
+	err = hinic_port_link_state(nic_dev, &link_state);
+	if (!err && link_state == HINIC_LINK_STATE_UP)
+		netif_carrier_on(netdev);
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -1611,6 +1788,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_sset_count = hinic_get_sset_count,
 	.get_ethtool_stats = hinic_get_ethtool_stats,
 	.get_strings = hinic_get_strings,
+	.self_test = hinic_diag_test,
 };
 
 static const struct ethtool_ops hinicvf_ethtool_ops = {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index ed3cc154ce18..c92c39a50b81 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -97,6 +97,9 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
 
+	HINIC_PORT_CMD_GET_LOOPBACK_MODE = 72,
+	HINIC_PORT_CMD_SET_LOOPBACK_MODE,
+
 	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 78,
 
 	HINIC_PORT_CMD_GET_MGMT_VERSION = 88,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 8b007a268675..53ea2740ba9f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1241,3 +1241,33 @@ int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap)
 
 	return 0;
 }
+
+int hinic_set_loopback_mode(struct hinic_hwdev *hwdev, u32 mode, u32 enable)
+{
+	struct hinic_port_loopback lb = {0};
+	u16 out_size = sizeof(lb);
+	int err;
+
+	lb.mode = mode;
+	lb.en = enable;
+
+	if (mode < LOOP_MODE_MIN || mode > LOOP_MODE_MAX) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Invalid loopback mode %d to set\n", mode);
+		return -EINVAL;
+	}
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_LOOPBACK_MODE,
+				 &lb, sizeof(lb), &lb, &out_size);
+	if (err || !out_size || lb.status) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to set loopback mode %d en %d, err: %d, status: 0x%x, out size: 0x%x\n",
+			mode, enable, err, lb.status, out_size);
+		return -EIO;
+	}
+
+	dev_info(&hwdev->hwif->pdev->dev,
+		 "Set loopback mode %d en %d succeed\n", mode, enable);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 7b17460d4e2c..b21956d7232e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -652,6 +652,20 @@ struct hinic_set_pfc {
 	u8	rsvd1[4];
 };
 
+/* get or set loopback mode, need to modify by base API */
+#define HINIC_INTERNAL_LP_MODE			5
+#define LOOP_MODE_MIN				1
+#define LOOP_MODE_MAX				6
+
+struct hinic_port_loopback {
+	u8	status;
+	u8	version;
+	u8	rsvd[6];
+
+	u32	mode;
+	u32	en;
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -749,6 +763,8 @@ int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
 
 int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap);
 
+int hinic_set_loopback_mode(struct hinic_hwdev *hwdev, u32 mode, u32 enable);
+
 int hinic_open(struct net_device *netdev);
 
 int hinic_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index c9a65a1f0347..5bee951fe9d4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -316,6 +316,39 @@ static int rx_recv_jumbo_pkt(struct hinic_rxq *rxq, struct sk_buff *head_skb,
 	return num_wqes;
 }
 
+static void hinic_copy_lp_data(struct hinic_dev *nic_dev,
+			       struct sk_buff *skb)
+{
+	struct net_device *netdev = nic_dev->netdev;
+	u8 *lb_buf = nic_dev->lb_test_rx_buf;
+	int lb_len = nic_dev->lb_pkt_len;
+	int pkt_offset, frag_len, i;
+	void *frag_data = NULL;
+
+	if (nic_dev->lb_test_rx_idx == LP_PKT_CNT) {
+		nic_dev->lb_test_rx_idx = 0;
+		netif_warn(nic_dev, drv, netdev, "Loopback test warning, receive too more test pkts\n");
+	}
+
+	if (skb->len != nic_dev->lb_pkt_len) {
+		netif_warn(nic_dev, drv, netdev, "Wrong packet length\n");
+		nic_dev->lb_test_rx_idx++;
+		return;
+	}
+
+	pkt_offset = nic_dev->lb_test_rx_idx * lb_len;
+	frag_len = (int)skb_headlen(skb);
+	memcpy(lb_buf + pkt_offset, skb->data, frag_len);
+	pkt_offset += frag_len;
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		frag_data = skb_frag_address(&skb_shinfo(skb)->frags[i]);
+		frag_len = (int)skb_frag_size(&skb_shinfo(skb)->frags[i]);
+		memcpy((lb_buf + pkt_offset), frag_data, frag_len);
+		pkt_offset += frag_len;
+	}
+	nic_dev->lb_test_rx_idx++;
+}
+
 /**
  * rxq_recv - Rx handler
  * @rxq: rx queue
@@ -330,6 +363,7 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 	u64 pkt_len = 0, rx_bytes = 0;
 	struct hinic_rq *rq = rxq->rq;
 	struct hinic_rq_wqe *rq_wqe;
+	struct hinic_dev *nic_dev;
 	unsigned int free_wqebbs;
 	struct hinic_rq_cqe *cqe;
 	int num_wqes, pkts = 0;
@@ -342,6 +376,8 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 	u32 vlan_len;
 	u16 vid;
 
+	nic_dev = netdev_priv(netdev);
+
 	while (pkts < budget) {
 		num_wqes = 0;
 
@@ -384,6 +420,9 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
 		}
 
+		if (unlikely(nic_dev->flags & HINIC_LP_TEST))
+			hinic_copy_lp_data(nic_dev, skb);
+
 		skb_record_rx_queue(skb, qp->q_id);
 		skb->protocol = eth_type_trans(skb, rxq->netdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 0f6d27f29de5..a97498ee6914 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -459,6 +459,67 @@ static int hinic_tx_offload(struct sk_buff *skb, struct hinic_sq_task *task,
 	return 0;
 }
 
+netdev_tx_t hinic_lb_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u16 prod_idx, q_id = skb->queue_mapping;
+	struct netdev_queue *netdev_txq;
+	int nr_sges, err = NETDEV_TX_OK;
+	struct hinic_sq_wqe *sq_wqe;
+	unsigned int wqe_size;
+	struct hinic_txq *txq;
+	struct hinic_qp *qp;
+
+	txq = &nic_dev->txqs[q_id];
+	qp = container_of(txq->sq, struct hinic_qp, sq);
+	nr_sges = skb_shinfo(skb)->nr_frags + 1;
+
+	err = tx_map_skb(nic_dev, skb, txq->sges);
+	if (err)
+		goto skb_error;
+
+	wqe_size = HINIC_SQ_WQE_SIZE(nr_sges);
+
+	sq_wqe = hinic_sq_get_wqe(txq->sq, wqe_size, &prod_idx);
+	if (!sq_wqe) {
+		netif_stop_subqueue(netdev, qp->q_id);
+
+		sq_wqe = hinic_sq_get_wqe(txq->sq, wqe_size, &prod_idx);
+		if (sq_wqe) {
+			netif_wake_subqueue(nic_dev->netdev, qp->q_id);
+			goto process_sq_wqe;
+		}
+
+		tx_unmap_skb(nic_dev, skb, txq->sges);
+
+		u64_stats_update_begin(&txq->txq_stats.syncp);
+		txq->txq_stats.tx_busy++;
+		u64_stats_update_end(&txq->txq_stats.syncp);
+		err = NETDEV_TX_BUSY;
+		wqe_size = 0;
+		goto flush_skbs;
+	}
+
+process_sq_wqe:
+	hinic_sq_prepare_wqe(txq->sq, prod_idx, sq_wqe, txq->sges, nr_sges);
+	hinic_sq_write_wqe(txq->sq, prod_idx, sq_wqe, skb, wqe_size);
+
+flush_skbs:
+	netdev_txq = netdev_get_tx_queue(netdev, q_id);
+	if ((!netdev_xmit_more()) || (netif_xmit_stopped(netdev_txq)))
+		hinic_sq_write_db(txq->sq, prod_idx, wqe_size, 0);
+
+	return err;
+
+skb_error:
+	dev_kfree_skb_any(skb);
+	u64_stats_update_begin(&txq->txq_stats.syncp);
+	txq->txq_stats.tx_dropped++;
+	u64_stats_update_end(&txq->txq_stats.syncp);
+
+	return NETDEV_TX_OK;
+}
+
 netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.h b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
index f158b7db7fb8..b3c8657774a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
@@ -44,6 +44,8 @@ void hinic_txq_clean_stats(struct hinic_txq *txq);
 
 void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats);
 
+netdev_tx_t hinic_lb_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
+
 netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
 
 int hinic_init_txq(struct hinic_txq *txq, struct hinic_sq *sq,
-- 
2.17.1

