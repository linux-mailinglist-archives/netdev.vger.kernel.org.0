Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C620C7F8
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgF1Mh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 08:37:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40088 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbgF1MhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 08:37:23 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6B8D9C2629D5D9774424;
        Sun, 28 Jun 2020 20:37:21 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sun, 28 Jun 2020 20:37:12 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v4 2/5] hinic: add support to set and get irq coalesce
Date:   Sun, 28 Jun 2020 20:36:21 +0800
Message-ID: <20200628123624.600-3-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200628123624.600-1-luobin9@huawei.com>
References: <20200628123624.600-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to set TX/RX irq coalesce params with ethtool -C and
get these params with ethtool -c.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   8 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 234 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  62 +++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  21 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   3 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  53 ++++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  19 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  19 ++
 8 files changed, 418 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 48b40be3e84d..75d6dee948f5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -49,6 +49,12 @@ enum hinic_rss_hash_type {
 	HINIC_RSS_HASH_ENGINE_TYPE_MAX,
 };
 
+struct hinic_intr_coal_info {
+	u8	pending_limt;
+	u8	coalesce_timer_cfg;
+	u8	resend_timer_cfg;
+};
+
 struct hinic_dev {
 	struct net_device               *netdev;
 	struct hinic_hwdev              *hwdev;
@@ -82,6 +88,8 @@ struct hinic_dev {
 	struct hinic_rss_type		rss_type;
 	u8				*rss_hkey_user;
 	s32				*rss_indir_user;
+	struct hinic_intr_coal_info	*rx_intr_coalesce;
+	struct hinic_intr_coal_info	*tx_intr_coalesce;
 	struct hinic_sriov_info sriov_info;
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index edd60c892ab2..8e5c326c7687 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -49,6 +49,13 @@
 #define ETHTOOL_ADD_ADVERTISED_LINK_MODE(ecmd, mode)	\
 				((ecmd)->advertising |= ADVERTISED_##mode)
 
+#define COALESCE_PENDING_LIMIT_UNIT	8
+#define	COALESCE_TIMER_CFG_UNIT		9
+#define COALESCE_ALL_QUEUE		0xFFFF
+#define COALESCE_MAX_PENDING_LIMIT	(255 * COALESCE_PENDING_LIMIT_UNIT)
+#define COALESCE_MAX_TIMER_CFG		(255 * COALESCE_TIMER_CFG_UNIT)
+#define OBJ_STR_MAX_LEN			32
+
 struct hw2ethtool_link_mode {
 	enum ethtool_link_mode_bit_indices link_mode_bit;
 	u32 speed;
@@ -614,6 +621,215 @@ static int hinic_set_ringparam(struct net_device *netdev,
 	return 0;
 }
 
+static int __hinic_get_coalesce(struct net_device *netdev,
+				struct ethtool_coalesce *coal, u16 queue)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_intr_coal_info *rx_intr_coal_info;
+	struct hinic_intr_coal_info *tx_intr_coal_info;
+
+	if (queue == COALESCE_ALL_QUEUE) {
+		/* get tx/rx irq0 as default parameters */
+		rx_intr_coal_info = &nic_dev->rx_intr_coalesce[0];
+		tx_intr_coal_info = &nic_dev->tx_intr_coalesce[0];
+	} else {
+		if (queue >= nic_dev->num_qps) {
+			netif_err(nic_dev, drv, netdev,
+				  "Invalid queue_id: %d\n", queue);
+			return -EINVAL;
+		}
+		rx_intr_coal_info = &nic_dev->rx_intr_coalesce[queue];
+		tx_intr_coal_info = &nic_dev->tx_intr_coalesce[queue];
+	}
+
+	/* coalesce_timer is in unit of 9us */
+	coal->rx_coalesce_usecs = rx_intr_coal_info->coalesce_timer_cfg *
+			COALESCE_TIMER_CFG_UNIT;
+	/* coalesced_frames is in unit of 8 */
+	coal->rx_max_coalesced_frames = rx_intr_coal_info->pending_limt *
+			COALESCE_PENDING_LIMIT_UNIT;
+	coal->tx_coalesce_usecs = tx_intr_coal_info->coalesce_timer_cfg *
+			COALESCE_TIMER_CFG_UNIT;
+	coal->tx_max_coalesced_frames = tx_intr_coal_info->pending_limt *
+			COALESCE_PENDING_LIMIT_UNIT;
+
+	return 0;
+}
+
+static int is_coalesce_exceed_limit(const struct ethtool_coalesce *coal)
+{
+	if (coal->rx_coalesce_usecs > COALESCE_MAX_TIMER_CFG ||
+	    coal->rx_max_coalesced_frames > COALESCE_MAX_PENDING_LIMIT ||
+	    coal->tx_coalesce_usecs > COALESCE_MAX_TIMER_CFG ||
+	    coal->tx_max_coalesced_frames > COALESCE_MAX_PENDING_LIMIT)
+		return -ERANGE;
+
+	return 0;
+}
+
+static int set_queue_coalesce(struct hinic_dev *nic_dev, u16 q_id,
+			      struct hinic_intr_coal_info *coal,
+			      bool set_rx_coal)
+{
+	struct hinic_intr_coal_info *intr_coal = NULL;
+	struct hinic_msix_config interrupt_info = {0};
+	struct net_device *netdev = nic_dev->netdev;
+	u16 msix_idx;
+	int err;
+
+	intr_coal = set_rx_coal ? &nic_dev->rx_intr_coalesce[q_id] :
+		    &nic_dev->tx_intr_coalesce[q_id];
+
+	intr_coal->coalesce_timer_cfg = coal->coalesce_timer_cfg;
+	intr_coal->pending_limt = coal->pending_limt;
+
+	/* netdev not running or qp not in using,
+	 * don't need to set coalesce to hw
+	 */
+	if (!(nic_dev->flags & HINIC_INTF_UP) ||
+	    q_id >= nic_dev->num_qps)
+		return 0;
+
+	msix_idx = set_rx_coal ? nic_dev->rxqs[q_id].rq->msix_entry :
+		   nic_dev->txqs[q_id].sq->msix_entry;
+	interrupt_info.msix_index = msix_idx;
+	interrupt_info.coalesce_timer_cnt = intr_coal->coalesce_timer_cfg;
+	interrupt_info.pending_cnt = intr_coal->pending_limt;
+	interrupt_info.resend_timer_cnt = intr_coal->resend_timer_cfg;
+
+	err = hinic_set_interrupt_cfg(nic_dev->hwdev, &interrupt_info);
+	if (err)
+		netif_warn(nic_dev, drv, netdev,
+			   "Failed to set %s queue%d coalesce",
+			   set_rx_coal ? "rx" : "tx", q_id);
+
+	return err;
+}
+
+static int __set_hw_coal_param(struct hinic_dev *nic_dev,
+			       struct hinic_intr_coal_info *intr_coal,
+			       u16 queue, bool set_rx_coal)
+{
+	int err;
+	u16 i;
+
+	if (queue == COALESCE_ALL_QUEUE) {
+		for (i = 0; i < nic_dev->max_qps; i++) {
+			err = set_queue_coalesce(nic_dev, i, intr_coal,
+						 set_rx_coal);
+			if (err)
+				return err;
+		}
+	} else {
+		if (queue >= nic_dev->num_qps) {
+			netif_err(nic_dev, drv, nic_dev->netdev,
+				  "Invalid queue_id: %d\n", queue);
+			return -EINVAL;
+		}
+		err = set_queue_coalesce(nic_dev, queue, intr_coal,
+					 set_rx_coal);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int __hinic_set_coalesce(struct net_device *netdev,
+				struct ethtool_coalesce *coal, u16 queue)
+{
+	struct hinic_intr_coal_info *ori_rx_intr_coal = NULL;
+	struct hinic_intr_coal_info *ori_tx_intr_coal = NULL;
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_intr_coal_info rx_intr_coal = {0};
+	struct hinic_intr_coal_info tx_intr_coal = {0};
+	char obj_str[OBJ_STR_MAX_LEN] = {0};
+	bool set_rx_coal = false;
+	bool set_tx_coal = false;
+	int err;
+
+	err = is_coalesce_exceed_limit(coal);
+	if (err)
+		return err;
+
+	if (coal->rx_coalesce_usecs || coal->rx_max_coalesced_frames) {
+		rx_intr_coal.coalesce_timer_cfg =
+		(u8)(coal->rx_coalesce_usecs / COALESCE_TIMER_CFG_UNIT);
+		rx_intr_coal.pending_limt = (u8)(coal->rx_max_coalesced_frames /
+				COALESCE_PENDING_LIMIT_UNIT);
+		set_rx_coal = true;
+	}
+
+	if (coal->tx_coalesce_usecs || coal->tx_max_coalesced_frames) {
+		tx_intr_coal.coalesce_timer_cfg =
+		(u8)(coal->tx_coalesce_usecs / COALESCE_TIMER_CFG_UNIT);
+		tx_intr_coal.pending_limt = (u8)(coal->tx_max_coalesced_frames /
+		COALESCE_PENDING_LIMIT_UNIT);
+		set_tx_coal = true;
+	}
+
+	if (queue == COALESCE_ALL_QUEUE) {
+		ori_rx_intr_coal = &nic_dev->rx_intr_coalesce[0];
+		ori_tx_intr_coal = &nic_dev->tx_intr_coalesce[0];
+		err = snprintf(obj_str, OBJ_STR_MAX_LEN, "for netdev");
+	} else {
+		ori_rx_intr_coal = &nic_dev->rx_intr_coalesce[queue];
+		ori_tx_intr_coal = &nic_dev->tx_intr_coalesce[queue];
+		err = snprintf(obj_str, OBJ_STR_MAX_LEN, "for queue %d", queue);
+	}
+	if (err <= 0 || err >= OBJ_STR_MAX_LEN) {
+		netif_err(nic_dev, drv, netdev, "Failed to snprintf string, function return(%d) and dest_len(%d)\n",
+			  err, OBJ_STR_MAX_LEN);
+		return -EFAULT;
+	}
+
+	/* setting coalesce timer or pending limit to zero will disable
+	 * coalesce
+	 */
+	if (set_rx_coal && (!rx_intr_coal.coalesce_timer_cfg ||
+			    !rx_intr_coal.pending_limt))
+		netif_warn(nic_dev, drv, netdev, "RX coalesce will be disabled\n");
+	if (set_tx_coal && (!tx_intr_coal.coalesce_timer_cfg ||
+			    !tx_intr_coal.pending_limt))
+		netif_warn(nic_dev, drv, netdev, "TX coalesce will be disabled\n");
+
+	if (set_rx_coal) {
+		err = __set_hw_coal_param(nic_dev, &rx_intr_coal, queue, true);
+		if (err)
+			return err;
+	}
+	if (set_tx_coal) {
+		err = __set_hw_coal_param(nic_dev, &tx_intr_coal, queue, false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int hinic_get_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *coal)
+{
+	return __hinic_get_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
+}
+
+static int hinic_set_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *coal)
+{
+	return __hinic_set_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
+}
+
+static int hinic_get_per_queue_coalesce(struct net_device *netdev, u32 queue,
+					struct ethtool_coalesce *coal)
+{
+	return __hinic_get_coalesce(netdev, coal, queue);
+}
+
+static int hinic_set_per_queue_coalesce(struct net_device *netdev, u32 queue,
+					struct ethtool_coalesce *coal)
+{
+	return __hinic_set_coalesce(netdev, coal, queue);
+}
+
 static void hinic_get_pauseparam(struct net_device *netdev,
 				 struct ethtool_pauseparam *pause)
 {
@@ -1293,12 +1509,21 @@ static void hinic_get_strings(struct net_device *netdev,
 }
 
 static const struct ethtool_ops hinic_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
+				     ETHTOOL_COALESCE_TX_USECS |
+				     ETHTOOL_COALESCE_TX_MAX_FRAMES,
+
 	.get_link_ksettings = hinic_get_link_ksettings,
 	.set_link_ksettings = hinic_set_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
+	.get_coalesce = hinic_get_coalesce,
+	.set_coalesce = hinic_set_coalesce,
+	.get_per_queue_coalesce = hinic_get_per_queue_coalesce,
+	.set_per_queue_coalesce = hinic_set_per_queue_coalesce,
 	.get_pauseparam = hinic_get_pauseparam,
 	.set_pauseparam = hinic_set_pauseparam,
 	.get_channels = hinic_get_channels,
@@ -1315,11 +1540,20 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 };
 
 static const struct ethtool_ops hinicvf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
+				     ETHTOOL_COALESCE_TX_USECS |
+				     ETHTOOL_COALESCE_TX_MAX_FRAMES,
+
 	.get_link_ksettings = hinic_get_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
+	.get_coalesce = hinic_get_coalesce,
+	.set_coalesce = hinic_set_coalesce,
+	.get_per_queue_coalesce = hinic_get_per_queue_coalesce,
+	.set_per_queue_coalesce = hinic_set_per_queue_coalesce,
 	.get_channels = hinic_get_channels,
 	.set_channels = hinic_set_channels,
 	.get_rxnfc = hinic_get_rxnfc,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 747d50b841ba..4de50e4ba4df 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -705,6 +705,68 @@ static int hinic_l2nic_reset(struct hinic_hwdev *hwdev)
 	return 0;
 }
 
+int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
+			    struct hinic_msix_config *interrupt_info)
+{
+	u16 out_size = sizeof(*interrupt_info);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	if (!hwdev || !interrupt_info)
+		return -EINVAL;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	interrupt_info->func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_MSI_CTRL_REG_RD_BY_UP,
+				interrupt_info, sizeof(*interrupt_info),
+				interrupt_info, &out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || !out_size || interrupt_info->status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to get interrupt config, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, interrupt_info->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
+			    struct hinic_msix_config *interrupt_info)
+{
+	u16 out_size = sizeof(*interrupt_info);
+	struct hinic_msix_config temp_info;
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	interrupt_info->func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+
+	err = hinic_get_interrupt_cfg(hwdev, &temp_info);
+	if (err)
+		return -EINVAL;
+
+	interrupt_info->lli_credit_cnt = temp_info.lli_timer_cnt;
+	interrupt_info->lli_timer_cnt = temp_info.lli_timer_cnt;
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_MSI_CTRL_REG_WR_BY_UP,
+				interrupt_info, sizeof(*interrupt_info),
+				interrupt_info, &out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || !out_size || interrupt_info->status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to get interrupt config, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, interrupt_info->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * hinic_init_hwdev - Initialize the NIC HW
  * @pdev: the NIC pci device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index cc776ca2d737..ed3cc154ce18 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -285,6 +285,21 @@ struct hinic_cmd_l2nic_reset {
 	u16	reset_flag;
 };
 
+struct hinic_msix_config {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	msix_index;
+	u8	pending_cnt;
+	u8	coalesce_timer_cnt;
+	u8	lli_timer_cnt;
+	u8	lli_credit_cnt;
+	u8	resend_timer_cnt;
+	u8	rsvd1[3];
+};
+
 struct hinic_hwdev {
 	struct hinic_hwif               *hwif;
 	struct msix_entry               *msix_entries;
@@ -378,4 +393,10 @@ int hinic_hwdev_hw_ci_addr_set(struct hinic_hwdev *hwdev, struct hinic_sq *sq,
 void hinic_hwdev_set_msix_state(struct hinic_hwdev *hwdev, u16 msix_index,
 				enum hinic_msix_state flag);
 
+int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
+			    struct hinic_msix_config *interrupt_info);
+
+int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
+			    struct hinic_msix_config *interrupt_info);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index c2b142c08b0e..a3349ae30ff3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -78,6 +78,9 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_CEQ_CTRL_REG_WR_BY_UP = 0x33,
 
+	HINIC_COMM_CMD_MSI_CTRL_REG_WR_BY_UP,
+	HINIC_COMM_CMD_MSI_CTRL_REG_RD_BY_UP,
+
 	HINIC_COMM_CMD_L2NIC_RESET		= 0x4b,
 
 	HINIC_COMM_CMD_PAGESIZE_SET	= 0x50,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 76e3debfebe5..834a20a0043c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -69,6 +69,10 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 
 #define HINIC_WAIT_SRIOV_CFG_TIMEOUT	15000
 
+#define HINIC_DEAULT_TXRX_MSIX_PENDING_LIMIT		2
+#define HINIC_DEAULT_TXRX_MSIX_COALESC_TIMER_CFG	32
+#define HINIC_DEAULT_TXRX_MSIX_RESEND_TIMER_CFG		7
+
 static int change_mac_addr(struct net_device *netdev, const u8 *addr);
 
 static int set_features(struct hinic_dev *nic_dev,
@@ -1021,6 +1025,45 @@ static int set_features(struct hinic_dev *nic_dev,
 	return 0;
 }
 
+static int hinic_init_intr_coalesce(struct hinic_dev *nic_dev)
+{
+	u64 size;
+	u16 i;
+
+	size = sizeof(struct hinic_intr_coal_info) * nic_dev->max_qps;
+	nic_dev->rx_intr_coalesce = kzalloc(size, GFP_KERNEL);
+	if (!nic_dev->rx_intr_coalesce)
+		return -ENOMEM;
+	nic_dev->tx_intr_coalesce = kzalloc(size, GFP_KERNEL);
+	if (!nic_dev->tx_intr_coalesce) {
+		kfree(nic_dev->rx_intr_coalesce);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nic_dev->max_qps; i++) {
+		nic_dev->rx_intr_coalesce[i].pending_limt =
+			HINIC_DEAULT_TXRX_MSIX_PENDING_LIMIT;
+		nic_dev->rx_intr_coalesce[i].coalesce_timer_cfg =
+			HINIC_DEAULT_TXRX_MSIX_COALESC_TIMER_CFG;
+		nic_dev->rx_intr_coalesce[i].resend_timer_cfg =
+			HINIC_DEAULT_TXRX_MSIX_RESEND_TIMER_CFG;
+		nic_dev->tx_intr_coalesce[i].pending_limt =
+			HINIC_DEAULT_TXRX_MSIX_PENDING_LIMIT;
+		nic_dev->tx_intr_coalesce[i].coalesce_timer_cfg =
+			HINIC_DEAULT_TXRX_MSIX_COALESC_TIMER_CFG;
+		nic_dev->tx_intr_coalesce[i].resend_timer_cfg =
+			HINIC_DEAULT_TXRX_MSIX_RESEND_TIMER_CFG;
+	}
+
+	return 0;
+}
+
+static void hinic_free_intr_coalesce(struct hinic_dev *nic_dev)
+{
+	kfree(nic_dev->tx_intr_coalesce);
+	kfree(nic_dev->rx_intr_coalesce);
+}
+
 /**
  * nic_dev_init - Initialize the NIC device
  * @pdev: the NIC pci device
@@ -1156,6 +1199,12 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
+	err = hinic_init_intr_coalesce(nic_dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to init_intr_coalesce\n");
+		goto err_init_intr;
+	}
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register netdev\n");
@@ -1165,6 +1214,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	return 0;
 
 err_reg_netdev:
+	hinic_free_intr_coalesce(nic_dev);
+err_init_intr:
 err_set_pfc:
 err_set_features:
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
@@ -1279,6 +1330,8 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
+	hinic_free_intr_coalesce(nic_dev);
+
 	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
 
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index af20d0dd6de7..c9a65a1f0347 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -478,11 +478,15 @@ static irqreturn_t rx_irq(int irq, void *data)
 static int rx_request_irq(struct hinic_rxq *rxq)
 {
 	struct hinic_dev *nic_dev = netdev_priv(rxq->netdev);
+	struct hinic_msix_config interrupt_info = {0};
+	struct hinic_intr_coal_info *intr_coal = NULL;
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_rq *rq = rxq->rq;
 	struct hinic_qp *qp;
 	int err;
 
+	qp = container_of(rq, struct hinic_qp, rq);
+
 	rx_add_napi(rxq);
 
 	hinic_hwdev_msix_set(hwdev, rq->msix_entry,
@@ -490,13 +494,26 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 			     RX_IRQ_NO_LLI_TIMER, RX_IRQ_NO_CREDIT,
 			     RX_IRQ_NO_RESEND_TIMER);
 
+	intr_coal = &nic_dev->rx_intr_coalesce[qp->q_id];
+	interrupt_info.msix_index = rq->msix_entry;
+	interrupt_info.coalesce_timer_cnt = intr_coal->coalesce_timer_cfg;
+	interrupt_info.pending_cnt = intr_coal->pending_limt;
+	interrupt_info.resend_timer_cnt = intr_coal->resend_timer_cfg;
+
+	err = hinic_set_interrupt_cfg(hwdev, &interrupt_info);
+	if (err) {
+		netif_err(nic_dev, drv, rxq->netdev,
+			  "Failed to set RX interrupt coalescing attribute\n");
+		rx_del_napi(rxq);
+		return err;
+	}
+
 	err = request_irq(rq->irq, rx_irq, 0, rxq->irq_name, rxq);
 	if (err) {
 		rx_del_napi(rxq);
 		return err;
 	}
 
-	qp = container_of(rq, struct hinic_qp, rq);
 	cpumask_set_cpu(qp->q_id % num_online_cpus(), &rq->affinity_mask);
 	return irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 4c66a0bc1b28..0f6d27f29de5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -718,12 +718,17 @@ static irqreturn_t tx_irq(int irq, void *data)
 static int tx_request_irq(struct hinic_txq *txq)
 {
 	struct hinic_dev *nic_dev = netdev_priv(txq->netdev);
+	struct hinic_msix_config interrupt_info = {0};
+	struct hinic_intr_coal_info *intr_coal = NULL;
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_sq *sq = txq->sq;
+	struct hinic_qp *qp;
 	int err;
 
+	qp = container_of(sq, struct hinic_qp, sq);
+
 	tx_napi_add(txq, nic_dev->tx_weight);
 
 	hinic_hwdev_msix_set(nic_dev->hwdev, sq->msix_entry,
@@ -731,6 +736,20 @@ static int tx_request_irq(struct hinic_txq *txq)
 			     TX_IRQ_NO_LLI_TIMER, TX_IRQ_NO_CREDIT,
 			     TX_IRQ_NO_RESEND_TIMER);
 
+	intr_coal = &nic_dev->tx_intr_coalesce[qp->q_id];
+	interrupt_info.msix_index = sq->msix_entry;
+	interrupt_info.coalesce_timer_cnt = intr_coal->coalesce_timer_cfg;
+	interrupt_info.pending_cnt = intr_coal->pending_limt;
+	interrupt_info.resend_timer_cnt = intr_coal->resend_timer_cfg;
+
+	err = hinic_set_interrupt_cfg(hwdev, &interrupt_info);
+	if (err) {
+		netif_err(nic_dev, drv, txq->netdev,
+			  "Failed to set TX interrupt coalescing attribute\n");
+		tx_napi_del(txq);
+		return err;
+	}
+
 	err = request_irq(sq->irq, tx_irq, 0, txq->irq_name, txq);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to request Tx irq\n");
-- 
2.17.1

