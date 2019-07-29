Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962FF7837D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfG2C4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:56:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfG2Czi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 22:55:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0444227982404E727F8A;
        Mon, 29 Jul 2019 10:55:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Jul 2019 10:55:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 06/10] net: hns3: add debug messages to identify eth down cause
Date:   Mon, 29 Jul 2019 10:53:27 +0800
Message-ID: <1564368811-65492-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Some times just see the eth interface have been down/up via
dmesg, but can not know why the eth down. So adds some debug
messages to identify the cause for this.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 18 ++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 +++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    | 11 +++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4d58c53..0cf9301 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -459,6 +459,9 @@ static int hns3_nic_net_open(struct net_device *netdev)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
 
 	hns3_config_xps(priv);
+
+	netif_dbg(h, drv, netdev, "net open\n");
+
 	return 0;
 }
 
@@ -519,6 +522,8 @@ static int hns3_nic_net_stop(struct net_device *netdev)
 	if (test_and_set_bit(HNS3_NIC_STATE_DOWN, &priv->state))
 		return 0;
 
+	netif_dbg(h, drv, netdev, "net stop\n");
+
 	if (h->ae_algo->ops->set_timer_task)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, false);
 
@@ -1550,6 +1555,8 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	h = hns3_get_handle(netdev);
 	kinfo = &h->kinfo;
 
+	netif_dbg(h, drv, netdev, "setup tc: num_tc=%u\n", tc);
+
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
 		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
 }
@@ -1593,6 +1600,10 @@ static int hns3_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	int ret = -EIO;
 
+	netif_dbg(h, drv, netdev,
+		  "set vf vlan: vf=%d, vlan=%u, qos=%u, vlan_proto=%u\n",
+		  vf, vlan, qos, vlan_proto);
+
 	if (h->ae_algo->ops->set_vf_vlan_filter)
 		ret = h->ae_algo->ops->set_vf_vlan_filter(h, vf, vlan,
 							  qos, vlan_proto);
@@ -1611,6 +1622,9 @@ static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 	if (!h->ae_algo->ops->set_mtu)
 		return -EOPNOTSUPP;
 
+	netif_dbg(h, drv, netdev,
+		  "change mtu from %u to %d\n", netdev->mtu, new_mtu);
+
 	ret = h->ae_algo->ops->set_mtu(h, new_mtu);
 	if (ret)
 		netdev_err(netdev, "failed to change MTU in hardware %d\n",
@@ -4395,6 +4409,10 @@ int hns3_set_channels(struct net_device *netdev,
 	if (kinfo->rss_size == new_tqp_num)
 		return 0;
 
+	netif_dbg(h, drv, netdev,
+		  "set channels: tqp_num=%u, rxfh=%d\n",
+		  new_tqp_num, rxfh_configured);
+
 	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e71c92b..fe0f82a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -311,6 +311,8 @@ static void hns3_self_test(struct net_device *ndev,
 	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
 		return;
 
+	netif_dbg(h, drv, ndev, "self test start");
+
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -374,6 +376,8 @@ static void hns3_self_test(struct net_device *ndev,
 
 	if (if_running)
 		ndev->netdev_ops->ndo_open(ndev);
+
+	netif_dbg(h, drv, ndev, "self test end\n");
 }
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
@@ -604,6 +608,10 @@ static int hns3_set_pauseparam(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
+	netif_dbg(h, drv, netdev,
+		  "set pauseparam: autoneg=%u, rx:%u, tx:%u\n",
+		  param->autoneg, param->rx_pause, param->tx_pause);
+
 	if (h->ae_algo->ops->set_pauseparam)
 		return h->ae_algo->ops->set_pauseparam(h, param->autoneg,
 						       param->rx_pause,
@@ -743,6 +751,11 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex == DUPLEX_HALF)
 		return -EINVAL;
 
+	netif_dbg(handle, drv, netdev,
+		  "set link(%s): autoneg=%u, speed=%u, duplex=%u\n",
+		  netdev->phydev ? "phy" : "mac",
+		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex);
+
 	/* Only support ksettings_set for netdev with phy attached for now */
 	if (netdev->phydev)
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
@@ -984,6 +997,9 @@ static int hns3_nway_reset(struct net_device *netdev)
 		return -EINVAL;
 	}
 
+	netif_dbg(handle, drv, netdev,
+		  "nway reset (using %s)\n", phy ? "phy" : "mac");
+
 	if (phy)
 		return genphy_restart_aneg(phy);
 
@@ -1308,6 +1324,9 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	if (!ops->set_fec)
 		return -EOPNOTSUPP;
 	fec_mode = eth_to_loc_fec(fec->fec);
+
+	netif_dbg(handle, drv, netdev, "set fecparam: mode=%u\n", fec_mode);
+
 	return ops->set_fec(handle, fec_mode);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index bac4ce1..814e0f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -201,6 +201,7 @@ static int hclge_client_setup_tc(struct hclge_dev *hdev)
 static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 	bool map_changed = false;
 	u8 num_tc = 0;
@@ -215,6 +216,8 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 		return ret;
 
 	if (map_changed) {
+		netif_dbg(h, drv, netdev, "set ets\n");
+
 		ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
 		if (ret)
 			return ret;
@@ -300,6 +303,7 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 	u8 i, j, pfc_map, *prio_tc;
 
@@ -325,6 +329,10 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	hdev->tm_info.hw_pfc_map = pfc_map;
 	hdev->tm_info.pfc_en = pfc->pfc_en;
 
+	netif_dbg(h, drv, netdev,
+		  "set pfc: pfc_en=%u, pfc_map=%u, num_tc=%u\n",
+		  pfc->pfc_en, pfc_map, hdev->tm_info.num_tc);
+
 	hclge_tm_pfc_info_update(hdev);
 
 	return hclge_pause_setup_hw(hdev, false);
@@ -345,8 +353,11 @@ static u8 hclge_getdcbx(struct hnae3_handle *h)
 static u8 hclge_setdcbx(struct hnae3_handle *h, u8 mode)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 
+	netif_dbg(h, drv, netdev, "set dcbx: mode=%u\n", mode);
+
 	/* No support for LLD_MANAGED modes or CEE */
 	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
 	    (mode & DCB_CAP_DCBX_VER_CEE) ||
-- 
2.7.4

