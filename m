Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F61EC964
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFCGVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:21:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgFCGVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 02:21:38 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 693CBEEB7282597E571F;
        Wed,  3 Jun 2020 14:21:33 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 3 Jun 2020 14:21:23 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <chiqijun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next 1/5] hinic: add support to set and get pause params
Date:   Wed, 3 Jun 2020 14:20:11 +0800
Message-ID: <20200603062015.12640-2-luobin9@huawei.com>
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

add support to set pause params with ethtool -A and get pause
params with ethtool -a. Also remove set_link_ksettings ops for VF
and enable pause by default.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 100 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |  10 ++
 .../net/ethernet/huawei/hinic/hinic_main.c    |  48 +++++++--
 .../net/ethernet/huawei/hinic/hinic_port.c    |  40 +++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  13 +++
 7 files changed, 208 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index efb02e03e7da..a21078a6f5b1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -613,6 +613,78 @@ static int hinic_set_ringparam(struct net_device *netdev,
 
 	return 0;
 }
+
+static void hinic_get_pauseparam(struct net_device *netdev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_pause_config pause_info = {0};
+	struct hinic_nic_cfg *nic_cfg;
+	int err;
+
+	nic_cfg = &nic_dev->hwdev->func_to_io.nic_cfg;
+
+	err = hinic_get_hw_pause_info(nic_dev->hwdev, &pause_info);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get pauseparam from hw\n");
+	} else {
+		pause->autoneg = pause_info.auto_neg;
+		if (nic_cfg->pause_set || !pause_info.auto_neg) {
+			pause->rx_pause = nic_cfg->rx_pause;
+			pause->tx_pause = nic_cfg->tx_pause;
+		} else {
+			pause->rx_pause = pause_info.rx_pause;
+			pause->tx_pause = pause_info.tx_pause;
+		}
+	}
+}
+
+static int hinic_set_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_pause_config pause_info = {0};
+	struct hinic_port_cap port_cap = {0};
+	int err;
+
+	err = hinic_port_get_cap(nic_dev, &port_cap);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get port capability\n");
+		return -EIO;
+	}
+
+	if (pause->autoneg != port_cap.autoneg_state) {
+		netif_err(nic_dev, drv, netdev,
+			  "To change autoneg please use: ethtool -s <dev> autoneg <on|off>\n");
+		return -EOPNOTSUPP;
+	}
+
+	pause_info.auto_neg = pause->autoneg;
+	pause_info.rx_pause = pause->rx_pause;
+	pause_info.tx_pause = pause->tx_pause;
+
+	mutex_lock(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_mutex);
+	err = hinic_set_hw_pause_info(nic_dev->hwdev, &pause_info);
+	if (err) {
+		netif_err(nic_dev, drv, netdev, "Failed to set pauseparam\n");
+		mutex_unlock(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_mutex);
+		return err;
+	}
+	nic_dev->hwdev->func_to_io.nic_cfg.pause_set = true;
+	nic_dev->hwdev->func_to_io.nic_cfg.auto_neg = pause->autoneg;
+	nic_dev->hwdev->func_to_io.nic_cfg.rx_pause = pause->rx_pause;
+	nic_dev->hwdev->func_to_io.nic_cfg.tx_pause = pause->tx_pause;
+	mutex_unlock(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_mutex);
+
+	netif_dbg(nic_dev, drv, netdev, "Set pause options, tx: %s, rx: %s\n",
+		  pause->tx_pause ? "on" : "off",
+		  pause->rx_pause ? "on" : "off");
+
+	return 0;
+}
+
 static void hinic_get_channels(struct net_device *netdev,
 			       struct ethtool_channels *channels)
 {
@@ -1241,6 +1313,27 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
+	.get_pauseparam = hinic_get_pauseparam,
+	.set_pauseparam = hinic_set_pauseparam,
+	.get_channels = hinic_get_channels,
+	.set_channels = hinic_set_channels,
+	.get_rxnfc = hinic_get_rxnfc,
+	.set_rxnfc = hinic_set_rxnfc,
+	.get_rxfh_key_size = hinic_get_rxfh_key_size,
+	.get_rxfh_indir_size = hinic_get_rxfh_indir_size,
+	.get_rxfh = hinic_get_rxfh,
+	.set_rxfh = hinic_set_rxfh,
+	.get_sset_count = hinic_get_sset_count,
+	.get_ethtool_stats = hinic_get_ethtool_stats,
+	.get_strings = hinic_get_strings,
+};
+
+static const struct ethtool_ops hinicvf_ethtool_ops = {
+	.get_link_ksettings = hinic_get_link_ksettings,
+	.get_drvinfo = hinic_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = hinic_get_ringparam,
+	.set_ringparam = hinic_set_ringparam,
 	.get_channels = hinic_get_channels,
 	.set_channels = hinic_set_channels,
 	.get_rxnfc = hinic_get_rxnfc,
@@ -1256,5 +1349,10 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 
 void hinic_set_ethtool_ops(struct net_device *netdev)
 {
-	netdev->ethtool_ops = &hinic_ethtool_ops;
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		netdev->ethtool_ops = &hinic_ethtool_ops;
+	else
+		netdev->ethtool_ops = &hinicvf_ethtool_ops;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 0245da02efbb..747d50b841ba 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -777,6 +777,8 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 		goto err_dev_cap;
 	}
 
+	mutex_init(&hwdev->func_to_io.nic_cfg.cfg_mutex);
+
 	err = hinic_vf_func_init(hwdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to init nic mbox\n");
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 71ea7e46dbbc..cc776ca2d737 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -48,6 +48,8 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_ADD_VLAN         = 3,
 	HINIC_PORT_CMD_DEL_VLAN         = 4,
 
+	HINIC_PORT_CMD_SET_PFC		= 5,
+
 	HINIC_PORT_CMD_SET_MAC          = 9,
 	HINIC_PORT_CMD_GET_MAC          = 10,
 	HINIC_PORT_CMD_DEL_MAC          = 11,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
index 214f162f7579..ee6d60762d84 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
@@ -47,6 +47,15 @@ struct hinic_free_db_area {
 	struct semaphore        idx_lock;
 };
 
+struct hinic_nic_cfg {
+	/* lock for getting nic cfg */
+	struct mutex		cfg_mutex;
+	bool			pause_set;
+	u32			auto_neg;
+	u32			rx_pause;
+	u32			tx_pause;
+};
+
 struct hinic_func_to_io {
 	struct hinic_hwif       *hwif;
 	struct hinic_hwdev      *hwdev;
@@ -78,6 +87,7 @@ struct hinic_func_to_io {
 	u16			max_vfs;
 	struct vf_data_storage	*vf_infos;
 	u8			link_status;
+	struct hinic_nic_cfg	nic_cfg;
 };
 
 struct hinic_wq_page_size {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index e9e6f4c9309a..e69edb01fd9b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -467,6 +467,7 @@ int hinic_open(struct net_device *netdev)
 	if (ret)
 		netif_warn(nic_dev, drv, netdev,
 			   "Failed to revert port state\n");
+
 err_port_state:
 	free_rxqs(nic_dev);
 	if (nic_dev->flags & HINIC_RSS_ENABLE) {
@@ -887,6 +888,26 @@ static void netdev_features_init(struct net_device *netdev)
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
+static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
+{
+	struct hinic_nic_cfg *nic_cfg = &nic_dev->hwdev->func_to_io.nic_cfg;
+	struct hinic_pause_config pause_info = {0};
+	struct hinic_port_cap port_cap = {0};
+
+	if (hinic_port_get_cap(nic_dev, &port_cap))
+		return;
+
+	mutex_lock(&nic_cfg->cfg_mutex);
+	if (nic_cfg->pause_set || !port_cap.autoneg_state) {
+		nic_cfg->auto_neg = port_cap.autoneg_state;
+		pause_info.auto_neg = nic_cfg->auto_neg;
+		pause_info.rx_pause = nic_cfg->rx_pause;
+		pause_info.tx_pause = nic_cfg->tx_pause;
+		hinic_set_hw_pause_info(nic_dev->hwdev, &pause_info);
+	}
+	mutex_unlock(&nic_cfg->cfg_mutex);
+}
+
 /**
  * link_status_event_handler - link event handler
  * @handle: nic device for the handler
@@ -918,6 +939,9 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 
 		up(&nic_dev->mgmt_lock);
 
+		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+			hinic_refresh_nic_cfg(nic_dev);
+
 		netif_info(nic_dev, drv, nic_dev->netdev, "HINIC_Link is UP\n");
 	} else {
 		down(&nic_dev->mgmt_lock);
@@ -950,26 +974,38 @@ static int set_features(struct hinic_dev *nic_dev,
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
 	int err = 0;
 
-	if (changed & NETIF_F_TSO)
+	if (changed & NETIF_F_TSO) {
 		err = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
+		if (err)
+			return err;
+	}
 
-	if (changed & NETIF_F_RXCSUM)
+	if (changed & NETIF_F_RXCSUM) {
 		err = hinic_set_rx_csum_offload(nic_dev, csum_en);
+		if (err)
+			return err;
+	}
 
 	if (changed & NETIF_F_LRO) {
 		err = hinic_set_rx_lro_state(nic_dev,
 					     !!(features & NETIF_F_LRO),
 					     HINIC_LRO_RX_TIMER_DEFAULT,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
+		if (err)
+			return err;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
 		err = hinic_set_rx_vlan_offload(nic_dev,
 						!!(features &
 						   NETIF_F_HW_VLAN_CTAG_RX));
+		if (err)
+			return err;
+	}
 
-	return err;
+	/* enable pause and disable pfc by default */
+	return hinic_dcb_set_pfc(nic_dev->hwdev, 0, 0);
 }
 
 /**
@@ -1008,8 +1044,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_alloc_etherdev;
 	}
 
-	hinic_set_ethtool_ops(netdev);
-
 	if (!HINIC_IS_VF(hwdev->hwif))
 		netdev->netdev_ops = &hinic_netdev_ops;
 	else
@@ -1032,6 +1066,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->sriov_info.pdev = pdev;
 	nic_dev->max_qps = num_qps;
 
+	hinic_set_ethtool_ops(netdev);
+
 	sema_init(&nic_dev->mgmt_lock, 1);
 
 	tx_stats = &nic_dev->tx_stats;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 175c0ee00038..8b007a268675 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1082,6 +1082,7 @@ int hinic_get_link_mode(struct hinic_hwdev *hwdev,
 	if (!hwdev || !link_mode)
 		return -EINVAL;
 
+	link_mode->func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
 	out_size = sizeof(*link_mode);
 
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_LINK_MODE,
@@ -1172,6 +1173,8 @@ int hinic_get_hw_pause_info(struct hinic_hwdev *hwdev,
 	u16 out_size = sizeof(*pause_info);
 	int err;
 
+	pause_info->func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_PAUSE_INFO,
 				 pause_info, sizeof(*pause_info),
 				 pause_info, &out_size);
@@ -1190,6 +1193,8 @@ int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
 	u16 out_size = sizeof(*pause_info);
 	int err;
 
+	pause_info->func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_PAUSE_INFO,
 				 pause_info, sizeof(*pause_info),
 				 pause_info, &out_size);
@@ -1201,3 +1206,38 @@ int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
 
 	return 0;
 }
+
+int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap)
+{
+	struct hinic_nic_cfg *nic_cfg = &hwdev->func_to_io.nic_cfg;
+	struct hinic_set_pfc pfc = {0};
+	u16 out_size = sizeof(pfc);
+	int err;
+
+	if (HINIC_IS_VF(hwdev->hwif))
+		return 0;
+
+	mutex_lock(&nic_cfg->cfg_mutex);
+
+	pfc.func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	pfc.pfc_bitmap = pfc_bitmap;
+	pfc.pfc_en = pfc_en;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_PFC,
+				 &pfc, sizeof(pfc), &pfc, &out_size);
+	if (err || pfc.status || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to %s pfc, err: %d, status: 0x%x, out size: 0x%x\n",
+			pfc_en ? "enable" : "disable", err, pfc.status,
+			out_size);
+		mutex_unlock(&nic_cfg->cfg_mutex);
+		return -EIO;
+	}
+
+	/* pause settings is opposite from pfc */
+	nic_cfg->rx_pause = pfc_en ? 0 : 1;
+	nic_cfg->tx_pause = pfc_en ? 0 : 1;
+
+	mutex_unlock(&nic_cfg->cfg_mutex);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 661c6322dc15..7b17460d4e2c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -641,6 +641,17 @@ struct hinic_pause_config {
 	u32	tx_pause;
 };
 
+struct hinic_set_pfc {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	pfc_en;
+	u8	pfc_bitmap;
+	u8	rsvd1[4];
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -736,6 +747,8 @@ int hinic_get_hw_pause_info(struct hinic_hwdev *hwdev,
 int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
 			    struct hinic_pause_config *pause_info);
 
+int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap);
+
 int hinic_open(struct net_device *netdev);
 
 int hinic_close(struct net_device *netdev);
-- 
2.17.1

