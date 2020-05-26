Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32EB1B8509
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 11:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgDYJEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 05:04:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbgDYJEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 05:04:40 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 12DCF547C9B2C53968D6;
        Sat, 25 Apr 2020 17:04:37 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Apr 2020 17:04:27 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1 3/3] hinic: add net_device_ops associated with vf
Date:   Sat, 25 Apr 2020 01:21:11 +0000
Message-ID: <20200425012111.4297-4-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200425012111.4297-1-luobin9@huawei.com>
References: <20200425012111.4297-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adds ndo_set_vf_mac/ndo_set_vf_vlan/ndo_get_vf_config and
ndo_set_vf_trust to configure netdev of virtual function

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_main.c    |  43 ++-
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 318 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |  23 ++
 3 files changed, 383 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index cd71249f9b1c..b66bb86cff96 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -779,8 +779,26 @@ static void hinic_set_rx_mode(struct net_device *netdev)
 static void hinic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u16 sw_pi, hw_ci, sw_ci;
+	struct hinic_sq *sq;
+	u16 num_sqs, q_id;
+
+	num_sqs = hinic_hwdev_num_qps(nic_dev->hwdev);
 
 	netif_err(nic_dev, drv, netdev, "Tx timeout\n");
+
+	for (q_id = 0; q_id < num_sqs; q_id++) {
+		if (!netif_xmit_stopped(netdev_get_tx_queue(netdev, q_id)))
+			continue;
+
+		sq = hinic_hwdev_get_sq(nic_dev->hwdev, q_id);
+		sw_pi = atomic_read(&sq->wq->prod_idx) & sq->wq->mask;
+		hw_ci = be16_to_cpu(*(u16 *)(sq->hw_ci_addr)) & sq->wq->mask;
+		sw_ci = atomic_read(&sq->wq->cons_idx) & sq->wq->mask;
+		netif_err(nic_dev, drv, netdev, "Txq%d: sw_pi: %d, hw_ci: %d, sw_ci: %d, napi->state: 0x%lx\n",
+			  q_id, sw_pi, hw_ci, sw_ci,
+			  nic_dev->txqs[q_id].napi.state);
+	}
 }
 
 static void hinic_get_stats64(struct net_device *netdev,
@@ -846,6 +864,26 @@ static const struct net_device_ops hinic_netdev_ops = {
 	.ndo_get_stats64 = hinic_get_stats64,
 	.ndo_fix_features = hinic_fix_features,
 	.ndo_set_features = hinic_set_features,
+	.ndo_set_vf_mac	= hinic_ndo_set_vf_mac,
+	.ndo_set_vf_vlan = hinic_ndo_set_vf_vlan,
+	.ndo_get_vf_config = hinic_ndo_get_vf_config,
+	.ndo_set_vf_trust = hinic_ndo_set_vf_trust,
+};
+
+static const struct net_device_ops hinicvf_netdev_ops = {
+	.ndo_open = hinic_open,
+	.ndo_stop = hinic_close,
+	.ndo_change_mtu = hinic_change_mtu,
+	.ndo_set_mac_address = hinic_set_mac_addr,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_vlan_rx_add_vid = hinic_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = hinic_vlan_rx_kill_vid,
+	.ndo_set_rx_mode = hinic_set_rx_mode,
+	.ndo_start_xmit = hinic_xmit_frame,
+	.ndo_tx_timeout = hinic_tx_timeout,
+	.ndo_get_stats64 = hinic_get_stats64,
+	.ndo_fix_features = hinic_fix_features,
+	.ndo_set_features = hinic_set_features,
 };
 
 static void netdev_features_init(struct net_device *netdev)
@@ -983,7 +1021,10 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	hinic_set_ethtool_ops(netdev);
 
-	netdev->netdev_ops = &hinic_netdev_ops;
+	if (!HINIC_IS_VF(hwdev->hwif))
+		netdev->netdev_ops = &hinic_netdev_ops;
+	else
+		netdev->netdev_ops = &hinicvf_netdev_ops;
 
 	netdev->max_mtu = ETH_MAX_MTU;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index d1c4e1428b38..b24788e9733c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -359,6 +359,168 @@ struct hinic_sriov_info *hinic_get_sriov_info_by_pcidev(struct pci_dev *pdev)
 	return &nic_dev->sriov_info;
 }
 
+static int hinic_check_mac_info(u8 status, u16 vlan_id)
+{
+	if ((status && status != HINIC_MGMT_STATUS_EXIST &&
+	     status != HINIC_PF_SET_VF_ALREADY) ||
+	    (vlan_id & CHECK_IPSU_15BIT &&
+	     status == HINIC_MGMT_STATUS_EXIST))
+		return -EINVAL;
+
+	return 0;
+}
+
+#define HINIC_VLAN_ID_MASK	0x7FFF
+
+int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac, u8 *new_mac,
+		     u16 vlan_id, u16 func_id)
+{
+	struct hinic_port_mac_update mac_info = {0};
+	u16 out_size = sizeof(mac_info);
+	int err;
+
+	if (!hwdev || !old_mac || !new_mac)
+		return -EINVAL;
+
+	if ((vlan_id & HINIC_VLAN_ID_MASK) >= VLAN_N_VID) {
+		dev_err(&hwdev->hwif->pdev->dev, "Invalid VLAN number: %d\n",
+			(vlan_id & HINIC_VLAN_ID_MASK));
+		return -EINVAL;
+	}
+
+	mac_info.func_id = func_id;
+	mac_info.vlan_id = vlan_id;
+	memcpy(mac_info.old_mac, old_mac, ETH_ALEN);
+	memcpy(mac_info.new_mac, new_mac, ETH_ALEN);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_UPDATE_MAC, &mac_info,
+				 sizeof(mac_info), &mac_info, &out_size);
+
+	if (err || !out_size ||
+	    hinic_check_mac_info(mac_info.status, mac_info.vlan_id)) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to update MAC, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, mac_info.status, out_size);
+		return -EINVAL;
+	}
+
+	if (mac_info.status == HINIC_PF_SET_VF_ALREADY) {
+		dev_warn(&hwdev->hwif->pdev->dev,
+			 "PF has already set VF MAC. Ignore update operation\n");
+		return HINIC_PF_SET_VF_ALREADY;
+	}
+
+	if (mac_info.status == HINIC_MGMT_STATUS_EXIST)
+		dev_warn(&hwdev->hwif->pdev->dev, "MAC is repeated. Ignore update operation\n");
+
+	return 0;
+}
+
+void hinic_get_vf_config(struct hinic_hwdev *hwdev, u16 vf_id,
+			 struct ifla_vf_info *ivi)
+{
+	struct vf_data_storage *vfinfo;
+
+	vfinfo = hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
+
+	ivi->vf = HW_VF_ID_TO_OS(vf_id);
+	memcpy(ivi->mac, vfinfo->vf_mac_addr, ETH_ALEN);
+	ivi->vlan = vfinfo->pf_vlan;
+	ivi->qos = vfinfo->pf_qos;
+	ivi->spoofchk = vfinfo->spoofchk;
+	ivi->trusted = vfinfo->trust;
+	ivi->max_tx_rate = vfinfo->max_rate;
+	ivi->min_tx_rate = vfinfo->min_rate;
+
+	if (!vfinfo->link_forced)
+		ivi->linkstate = IFLA_VF_LINK_STATE_AUTO;
+	else if (vfinfo->link_up)
+		ivi->linkstate = IFLA_VF_LINK_STATE_ENABLE;
+	else
+		ivi->linkstate = IFLA_VF_LINK_STATE_DISABLE;
+}
+
+int hinic_ndo_get_vf_config(struct net_device *netdev,
+			    int vf, struct ifla_vf_info *ivi)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+
+	sriov_info = &nic_dev->sriov_info;
+	if (vf >= sriov_info->num_vfs)
+		return -EINVAL;
+
+	hinic_get_vf_config(sriov_info->hwdev, OS_VF_ID_TO_HW(vf), ivi);
+
+	return 0;
+}
+
+int hinic_set_vf_mac(struct hinic_hwdev *hwdev, int vf, unsigned char *mac_addr)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	struct vf_data_storage *vf_info;
+	u16 func_id;
+	int err;
+
+	vf_info = nic_io->vf_infos + HW_VF_ID_TO_OS(vf);
+
+	/* duplicate request, so just return success */
+	if (vf_info->pf_set_mac &&
+	    !memcmp(vf_info->vf_mac_addr, mac_addr, ETH_ALEN))
+		return 0;
+
+	vf_info->pf_set_mac = true;
+
+	func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf;
+	err = hinic_update_mac(hwdev, vf_info->vf_mac_addr,
+			       mac_addr, 0, func_id);
+	if (err) {
+		vf_info->pf_set_mac = false;
+		return err;
+	}
+
+	memcpy(vf_info->vf_mac_addr, mac_addr, ETH_ALEN);
+
+	return 0;
+}
+
+int hinic_ndo_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+	int err;
+
+	sriov_info = &nic_dev->sriov_info;
+	if (!is_valid_ether_addr(mac) || vf >= sriov_info->num_vfs)
+		return -EINVAL;
+
+	err = hinic_set_vf_mac(sriov_info->hwdev, OS_VF_ID_TO_HW(vf), mac);
+	if (err)
+		return err;
+
+	netif_info(nic_dev, drv, netdev, "Setting MAC %pM on VF %d\n", mac, vf);
+	netif_info(nic_dev, drv, netdev, "Reload the VF driver to make this change effective.");
+
+	return 0;
+}
+
+int hinic_add_vf_vlan(struct hinic_hwdev *hwdev, int vf_id, u16 vlan, u8 qos)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	int err;
+
+	err = hinic_set_vf_vlan(hwdev, true, vlan, qos, vf_id);
+	if (err)
+		return err;
+
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_vlan = vlan;
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_qos = qos;
+
+	dev_info(&hwdev->hwif->pdev->dev, "Setting VLAN %d, QOS 0x%x on VF %d\n",
+		 vlan, qos, HW_VF_ID_TO_OS(vf_id));
+	return 0;
+}
+
 int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
 {
 	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
@@ -381,6 +543,159 @@ int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
 	return 0;
 }
 
+int hinic_update_mac_vlan(struct hinic_dev *nic_dev, u16 old_vlan, u16 new_vlan,
+			  int vf_id)
+{
+	struct vf_data_storage *vf_info;
+	u16 vlan_id;
+	int err;
+
+	if (!nic_dev || old_vlan >= VLAN_N_VID || new_vlan >= VLAN_N_VID)
+		return -EINVAL;
+
+	vf_info = nic_dev->hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
+	if (!vf_info->pf_set_mac)
+		return 0;
+
+	vlan_id = old_vlan;
+	if (vlan_id)
+		vlan_id |= HINIC_ADD_VLAN_IN_MAC;
+
+	err = hinic_port_del_mac(nic_dev, vf_info->vf_mac_addr, vlan_id);
+	if (err) {
+		dev_err(&nic_dev->hwdev->hwif->pdev->dev, "Failed to delete VF %d MAC %pM vlan %d\n",
+			HW_VF_ID_TO_OS(vf_id), vf_info->vf_mac_addr, old_vlan);
+		return err;
+	}
+
+	vlan_id = new_vlan;
+	if (vlan_id)
+		vlan_id |= HINIC_ADD_VLAN_IN_MAC;
+
+	err = hinic_port_add_mac(nic_dev, vf_info->vf_mac_addr, vlan_id);
+	if (err) {
+		dev_err(&nic_dev->hwdev->hwif->pdev->dev, "Failed to add VF %d MAC %pM vlan %d\n",
+			HW_VF_ID_TO_OS(vf_id), vf_info->vf_mac_addr, new_vlan);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	vlan_id = old_vlan;
+	if (vlan_id)
+		vlan_id |= HINIC_ADD_VLAN_IN_MAC;
+	hinic_port_add_mac(nic_dev, vf_info->vf_mac_addr, vlan_id);
+
+	return err;
+}
+
+static int set_hw_vf_vlan(struct hinic_dev *nic_dev,
+			  u16 cur_vlanprio, int vf, u16 vlan, u8 qos)
+{
+	u16 old_vlan = cur_vlanprio & VLAN_VID_MASK;
+	int err = 0;
+
+	if (vlan || qos) {
+		if (cur_vlanprio) {
+			err = hinic_kill_vf_vlan(nic_dev->hwdev,
+						 OS_VF_ID_TO_HW(vf));
+			if (err) {
+				dev_err(&nic_dev->sriov_info.pdev->dev, "Failed to delete vf %d old vlan %d\n",
+					vf, old_vlan);
+				goto out;
+			}
+		}
+		err = hinic_add_vf_vlan(nic_dev->hwdev,
+					OS_VF_ID_TO_HW(vf), vlan, qos);
+		if (err) {
+			dev_err(&nic_dev->sriov_info.pdev->dev, "Failed to add vf %d new vlan %d\n",
+				vf, vlan);
+			goto out;
+		}
+	} else {
+		err = hinic_kill_vf_vlan(nic_dev->hwdev, OS_VF_ID_TO_HW(vf));
+		if (err) {
+			dev_err(&nic_dev->sriov_info.pdev->dev, "Failed to delete vf %d vlan %d\n",
+				vf, old_vlan);
+			goto out;
+		}
+	}
+
+	err = hinic_update_mac_vlan(nic_dev, old_vlan, vlan,
+				    OS_VF_ID_TO_HW(vf));
+
+out:
+	return err;
+}
+
+int hinic_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
+			  __be16 vlan_proto)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+	u16 vlanprio, cur_vlanprio;
+
+	sriov_info = &nic_dev->sriov_info;
+	if (vf >= sriov_info->num_vfs || vlan > 4095 || qos > 7)
+		return -EINVAL;
+	if (vlan_proto != htons(ETH_P_8021Q))
+		return -EPROTONOSUPPORT;
+	vlanprio = vlan | qos << HINIC_VLAN_PRIORITY_SHIFT;
+	cur_vlanprio = hinic_vf_info_vlanprio(nic_dev->hwdev,
+					      OS_VF_ID_TO_HW(vf));
+	/* duplicate request, so just return success */
+	if (vlanprio == cur_vlanprio)
+		return 0;
+
+	return set_hw_vf_vlan(nic_dev, cur_vlanprio, vf, vlan, qos);
+}
+
+int hinic_set_vf_trust(struct hinic_hwdev *hwdev, u16 vf_id, bool trust)
+{
+	struct vf_data_storage *vf_infos;
+	struct hinic_func_to_io *nic_io;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	nic_io = &hwdev->func_to_io;
+	vf_infos = nic_io->vf_infos;
+	vf_infos[vf_id].trust = trust;
+
+	return 0;
+}
+
+int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting)
+{
+	struct hinic_dev *adapter = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+	struct hinic_func_to_io *nic_io;
+	bool cur_trust;
+	int err;
+
+	sriov_info = &adapter->sriov_info;
+	nic_io = &adapter->hwdev->func_to_io;
+
+	if (vf >= sriov_info->num_vfs)
+		return -EINVAL;
+
+	cur_trust = nic_io->vf_infos[vf].trust;
+	/* same request, so just return success */
+	if ((setting && cur_trust) || (!setting && !cur_trust))
+		return 0;
+
+	err = hinic_set_vf_trust(adapter->hwdev, vf, setting);
+	if (!err)
+		dev_info(&sriov_info->pdev->dev, "Set VF %d trusted %s succeed\n",
+			 vf, setting ? "on" : "off");
+	else
+		dev_err(&sriov_info->pdev->dev, "Failed set VF %d trusted %s\n",
+			vf, setting ? "on" : "off");
+
+	return err;
+}
+
 /* pf receive message from vf */
 int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 			u16 in_size, void *buf_out, u16 *out_size)
@@ -484,6 +799,9 @@ void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 	if (hinic_vf_info_vlanprio(nic_dev->hwdev, vf_id))
 		hinic_kill_vf_vlan(nic_dev->hwdev, vf_id);
 
+	if (vf_infos->trust)
+		hinic_set_vf_trust(nic_dev->hwdev, vf_id, false);
+
 	memset(vf_infos, 0, sizeof(*vf_infos));
 	/* set vf_infos to default */
 	hinic_init_vf_infos(&nic_dev->hwdev->func_to_io, HW_VF_ID_TO_OS(vf_id));
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
index 4889eabe7b7c..64affc7474b5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
@@ -52,6 +52,19 @@ struct hinic_register_vf {
 	u8	rsvd0[6];
 };
 
+struct hinic_port_mac_update {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	vlan_id;
+	u16	rsvd1;
+	u8	old_mac[ETH_ALEN];
+	u16	rsvd2;
+	u8	new_mac[ETH_ALEN];
+};
+
 struct hinic_vf_vlan_config {
 	u8 status;
 	u8 version;
@@ -63,6 +76,16 @@ struct hinic_vf_vlan_config {
 	u8  rsvd1[7];
 };
 
+int hinic_ndo_set_vf_mac(struct net_device *netdev, int vf, u8 *mac);
+
+int hinic_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
+			  __be16 vlan_proto);
+
+int hinic_ndo_get_vf_config(struct net_device *netdev,
+			    int vf, struct ifla_vf_info *ivi);
+
+int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting);
+
 void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
 				       u8 link_status);
 
-- 
2.17.1

