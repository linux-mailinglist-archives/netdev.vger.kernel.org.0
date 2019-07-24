Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012A572550
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfGXDU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:20:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50540 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbfGXDU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:20:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7AFF5FFCEA1B5656419F;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/11] net: hns3: adds debug messages to identify eth down cause
Date:   Wed, 24 Jul 2019 11:18:43 +0800
Message-ID: <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
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
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 24 ++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 26 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 14 ++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4d58c53..cff5d59 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -459,6 +459,10 @@ static int hns3_nic_net_open(struct net_device *netdev)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
 
 	hns3_config_xps(priv);
+
+	if (netif_msg_ifup(h))
+		netdev_info(netdev, "net open\n");
+
 	return 0;
 }
 
@@ -519,6 +523,9 @@ static int hns3_nic_net_stop(struct net_device *netdev)
 	if (test_and_set_bit(HNS3_NIC_STATE_DOWN, &priv->state))
 		return 0;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev, "net stop\n");
+
 	if (h->ae_algo->ops->set_timer_task)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, false);
 
@@ -1550,6 +1557,9 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	h = hns3_get_handle(netdev);
 	kinfo = &h->kinfo;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev, "setup tc: num_tc=%d\n", tc);
+
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
 		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
 }
@@ -1593,6 +1603,11 @@ static int hns3_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	int ret = -EIO;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev,
+			    "set vf vlan: vf=%d, vlan=%d, qos=%d, vlan_proto=%d\n",
+			    vf, vlan, qos, vlan_proto);
+
 	if (h->ae_algo->ops->set_vf_vlan_filter)
 		ret = h->ae_algo->ops->set_vf_vlan_filter(h, vf, vlan,
 							  qos, vlan_proto);
@@ -1611,6 +1626,10 @@ static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 	if (!h->ae_algo->ops->set_mtu)
 		return -EOPNOTSUPP;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev, "change mtu from %d to %d\n",
+			    netdev->mtu, new_mtu);
+
 	ret = h->ae_algo->ops->set_mtu(h, new_mtu);
 	if (ret)
 		netdev_err(netdev, "failed to change MTU in hardware %d\n",
@@ -4395,6 +4414,11 @@ int hns3_set_channels(struct net_device *netdev,
 	if (kinfo->rss_size == new_tqp_num)
 		return 0;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev,
+			    "set channels: tqp_num=%d, rxfh=%d\n",
+			    new_tqp_num, rxfh_configured);
+
 	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e71c92b..edb9845 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -311,6 +311,9 @@ static void hns3_self_test(struct net_device *ndev,
 	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
 		return;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test start\n");
+
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -374,6 +377,9 @@ static void hns3_self_test(struct net_device *ndev,
 
 	if (if_running)
 		ndev->netdev_ops->ndo_open(ndev);
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test end\n");
 }
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
@@ -604,6 +610,11 @@ static int hns3_set_pauseparam(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev,
+			    "set pauseparam: autoneg=%d, rx:%d, tx:%d\n",
+			    param->autoneg, param->rx_pause, param->tx_pause);
+
 	if (h->ae_algo->ops->set_pauseparam)
 		return h->ae_algo->ops->set_pauseparam(h, param->autoneg,
 						       param->rx_pause,
@@ -743,6 +754,13 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex == DUPLEX_HALF)
 		return -EINVAL;
 
+	if (netif_msg_ifdown(handle))
+		netdev_info(netdev,
+			    "set link(%s): autoneg=%d, speed=%d, duplex=%d\n",
+			    netdev->phydev ? "phy" : "mac",
+			    cmd->base.autoneg, cmd->base.speed,
+			    cmd->base.duplex);
+
 	/* Only support ksettings_set for netdev with phy attached for now */
 	if (netdev->phydev)
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
@@ -984,6 +1002,10 @@ static int hns3_nway_reset(struct net_device *netdev)
 		return -EINVAL;
 	}
 
+	if (netif_msg_ifdown(handle))
+		netdev_info(netdev, "nway reset (using %s)\n",
+			    phy ? "phy" : "mac");
+
 	if (phy)
 		return genphy_restart_aneg(phy);
 
@@ -1308,6 +1330,10 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	if (!ops->set_fec)
 		return -EOPNOTSUPP;
 	fec_mode = eth_to_loc_fec(fec->fec);
+
+	if (netif_msg_ifdown(handle))
+		netdev_info(netdev, "set fecparam: mode=%d\n", fec_mode);
+
 	return ops->set_fec(handle, fec_mode);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index bac4ce1..133e7c6 100644
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
@@ -215,6 +216,9 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 		return ret;
 
 	if (map_changed) {
+		if (netif_msg_ifdown(h))
+			netdev_info(netdev, "set ets\n");
+
 		ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
 		if (ret)
 			return ret;
@@ -300,6 +304,7 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 	u8 i, j, pfc_map, *prio_tc;
 
@@ -325,6 +330,11 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	hdev->tm_info.hw_pfc_map = pfc_map;
 	hdev->tm_info.pfc_en = pfc->pfc_en;
 
+	if (netif_msg_ifdown(h))
+		netdev_info(netdev,
+			    "set pfc: pfc_en=%d, pfc_map=%d, num_tc=%d\n",
+			    pfc->pfc_en, pfc_map, hdev->tm_info.num_tc);
+
 	hclge_tm_pfc_info_update(hdev);
 
 	return hclge_pause_setup_hw(hdev, false);
@@ -345,8 +355,12 @@ static u8 hclge_getdcbx(struct hnae3_handle *h)
 static u8 hclge_setdcbx(struct hnae3_handle *h, u8 mode)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 
+	if (netif_msg_drv(h))
+		netdev_info(netdev, "set dcbx: mode=%d\n", mode);
+
 	/* No support for LLD_MANAGED modes or CEE */
 	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
 	    (mode & DCB_CAP_DCBX_VER_CEE) ||
-- 
2.7.4

