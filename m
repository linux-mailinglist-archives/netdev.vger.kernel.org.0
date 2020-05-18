Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BA01D90E9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgESHVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:21:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728027AbgESHVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 03:21:41 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AA6755BE553CD87A54C;
        Tue, 19 May 2020 15:21:27 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 19 May 2020 15:21:17 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1] hinic: add support to set and get pause param
Date:   Mon, 18 May 2020 23:38:48 +0000
Message-ID: <20200518233848.29536-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to set pause param with ethtool -A and get pause
param with ethtool -a. Also remove set_link_ksettings ops for VF.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 100 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |  10 ++
 .../net/ethernet/huawei/hinic/hinic_main.c    |  27 ++++-
 .../net/ethernet/huawei/hinic/hinic_port.c    |   5 +
 5 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 9796c1fbe132..62e44edd8151 100644
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
+		if (nic_cfg->pause_set) {
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
@@ -1247,6 +1319,27 @@ static const struct ethtool_ops hinic_ethtool_ops = {
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
@@ -1262,5 +1355,10 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 
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
index 2c07b03bf6e5..66e2bafa8615 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -899,6 +899,26 @@ static void netdev_features_init(struct net_device *netdev)
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
+	if (nic_cfg->pause_set) {
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
@@ -930,6 +950,9 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 
 		up(&nic_dev->mgmt_lock);
 
+		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+			hinic_refresh_nic_cfg(nic_dev);
+
 		netif_info(nic_dev, drv, nic_dev->netdev, "HINIC_Link is UP\n");
 	} else {
 		down(&nic_dev->mgmt_lock);
@@ -1020,8 +1043,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_alloc_etherdev;
 	}
 
-	hinic_set_ethtool_ops(netdev);
-
 	if (!HINIC_IS_VF(hwdev->hwif))
 		netdev->netdev_ops = &hinic_netdev_ops;
 	else
@@ -1044,6 +1065,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->sriov_info.pdev = pdev;
 	nic_dev->max_qps = num_qps;
 
+	hinic_set_ethtool_ops(netdev);
+
 	sema_init(&nic_dev->mgmt_lock, 1);
 
 	tx_stats = &nic_dev->tx_stats;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 175c0ee00038..4b51121b3021 100644
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
-- 
2.17.1

