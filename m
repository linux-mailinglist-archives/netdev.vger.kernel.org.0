Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AC7CF05F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfJHBWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:22:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53038 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729613AbfJHBWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 496E355D02756DA07D5C;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 2/6] net: hns3: add support for spoof check setting
Date:   Tue, 8 Oct 2019 09:20:05 +0800
Message-ID: <1570497609-36349-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch adds support for spoof check configuration for VFs.
When it is enabled, "spoof checking" is done for both mac address
and VLAN. For each VF, the HW ensures that the source MAC address
(or VLAN) of every outgoing packet exists in the MAC-list (or
VLAN-list) configured for RX filtering for that VF. If not,
the packet is dropped.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  14 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 125 +++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   3 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +-
 6 files changed, 140 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1fc3728..b7b8169 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -368,6 +368,8 @@ struct hnae3_ae_dev {
  *   Get the VF configuration setting by the host
  * set_vf_link_state
  *   Set VF link status
+ * set_vf_spoofchk
+ *   Enable/disable spoof check for specified vf
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -537,6 +539,8 @@ struct hnae3_ae_ops {
 			     struct ifla_vf_info *ivf);
 	int (*set_vf_link_state)(struct hnae3_handle *handle, int vf,
 				 int link_state);
+	int (*set_vf_spoofchk)(struct hnae3_handle *handle, int vf,
+			       bool enable);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2136323..4a5404e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1643,6 +1643,19 @@ static int hns3_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	return ret;
 }
 
+static int hns3_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	if (hns3_nic_resetting(netdev))
+		return -EBUSY;
+
+	if (!handle->ae_algo->ops->set_vf_spoofchk)
+		return -EOPNOTSUPP;
+
+	return handle->ae_algo->ops->set_vf_spoofchk(handle, vf, enable);
+}
+
 static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -1842,6 +1855,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= hns3_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= hns3_vlan_rx_kill_vid,
 	.ndo_set_vf_vlan	= hns3_ndo_set_vf_vlan,
+	.ndo_set_vf_spoofchk	= hns3_set_vf_spoofchk,
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= hns3_rx_flow_steer,
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 931a311..7c72862 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2888,6 +2888,7 @@ static int hclge_get_vf_config(struct hnae3_handle *handle, int vf,
 
 	ivf->vf = vf;
 	ivf->linkstate = vport->vf_info.link_state;
+	ivf->spoofchk = vport->vf_info.spoofchk;
 	ether_addr_copy(ivf->mac, vport->vf_info.mac);
 
 	return 0;
@@ -7619,6 +7620,8 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 				    __be16 proto)
 {
 #define HCLGE_MAX_VF_BYTES  16
+
+	struct hclge_vport *vport = &hdev->vport[vfid];
 	struct hclge_vlan_filter_vf_cfg_cmd *req0;
 	struct hclge_vlan_filter_vf_cfg_cmd *req1;
 	struct hclge_desc desc[2];
@@ -7627,10 +7630,18 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 	int ret;
 
 	/* if vf vlan table is full, firmware will close vf vlan filter, it
-	 * is unable and unnecessary to add new vlan id to vf vlan filter
+	 * is unable and unnecessary to add new vlan id to vf vlan filter.
+	 * If spoof check is enable, and vf vlan is full, it shouldn't add
+	 * new vlan, because tx packets with these vlan id will be dropped.
 	 */
-	if (test_bit(vfid, hdev->vf_vlan_full) && !is_kill)
+	if (test_bit(vfid, hdev->vf_vlan_full) && !is_kill) {
+		if (vport->vf_info.spoofchk && vlan) {
+			dev_err(&hdev->pdev->dev,
+				"Can't add vlan due to spoof check is on and vf vlan table is full\n");
+			return -EPERM;
+		}
 		return 0;
+	}
 
 	hclge_cmd_setup_basic_desc(&desc[0],
 				   HCLGE_OPC_VLAN_FILTER_VF_CFG, false);
@@ -8127,12 +8138,15 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 		}
 
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
-			if (vlan->hd_tbl_status)
-				hclge_set_vlan_filter_hw(hdev,
-							 htons(ETH_P_8021Q),
-							 vport->vport_id,
-							 vlan->vlan_id,
-							 false);
+			int ret;
+
+			if (!vlan->hd_tbl_status)
+				continue;
+			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+						       vport->vport_id,
+						       vlan->vlan_id, false);
+			if (ret)
+				break;
 		}
 	}
 
@@ -9374,6 +9388,97 @@ static void hclge_stats_clear(struct hclge_dev *hdev)
 	memset(&hdev->hw_stats, 0, sizeof(hdev->hw_stats));
 }
 
+static int hclge_set_mac_spoofchk(struct hclge_dev *hdev, int vf, bool enable)
+{
+	return hclge_config_switch_param(hdev, vf, enable,
+					 HCLGE_SWITCH_ANTI_SPOOF_MASK);
+}
+
+static int hclge_set_vlan_spoofchk(struct hclge_dev *hdev, int vf, bool enable)
+{
+	return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+					  HCLGE_FILTER_FE_NIC_INGRESS_B,
+					  enable, vf);
+}
+
+static int hclge_set_vf_spoofchk_hw(struct hclge_dev *hdev, int vf, bool enable)
+{
+	int ret;
+
+	ret = hclge_set_mac_spoofchk(hdev, vf, enable);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"Set vf %d mac spoof check %s failed, ret=%d\n",
+			vf, enable ? "on" : "off", ret);
+		return ret;
+	}
+
+	ret = hclge_set_vlan_spoofchk(hdev, vf, enable);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"Set vf %d vlan spoof check %s failed, ret=%d\n",
+			vf, enable ? "on" : "off", ret);
+
+	return ret;
+}
+
+static int hclge_set_vf_spoofchk(struct hnae3_handle *handle, int vf,
+				 bool enable)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 new_spoofchk = enable ? 1 : 0;
+	int ret;
+
+	if (hdev->pdev->revision == 0x20)
+		return -EOPNOTSUPP;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	if (vport->vf_info.spoofchk == new_spoofchk)
+		return 0;
+
+	if (enable && test_bit(vport->vport_id, hdev->vf_vlan_full))
+		dev_warn(&hdev->pdev->dev,
+			 "vf %d vlan table is full, enable spoof check may cause its packet send fail\n",
+			 vf);
+	else if (enable && hclge_is_umv_space_full(vport))
+		dev_warn(&hdev->pdev->dev,
+			 "vf %d mac table is full, enable spoof check may cause its packet send fail\n",
+			 vf);
+
+	ret = hclge_set_vf_spoofchk_hw(hdev, vport->vport_id, enable);
+	if (ret)
+		return ret;
+
+	vport->vf_info.spoofchk = new_spoofchk;
+	return 0;
+}
+
+static int hclge_reset_vport_spoofchk(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = hdev->vport;
+	int ret;
+	int i;
+
+	if (hdev->pdev->revision == 0x20)
+		return 0;
+
+	/* resume the vf spoof check state after reset */
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		ret = hclge_set_vf_spoofchk_hw(hdev, vport->vport_id,
+					       vport->vf_info.spoofchk);
+		if (ret)
+			return ret;
+
+		vport++;
+	}
+
+	return 0;
+}
+
 static void hclge_reset_vport_state(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
@@ -9473,6 +9578,9 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	}
 
 	hclge_reset_vport_state(hdev);
+	ret = hclge_reset_vport_spoofchk(hdev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
@@ -10209,6 +10317,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.restore_vlan_table = hclge_restore_vlan_table,
 	.get_vf_config = hclge_get_vf_config,
 	.set_vf_link_state = hclge_set_vf_link_state,
+	.set_vf_spoofchk = hclge_set_vf_spoofchk,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 6a3ccda..9483529 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -888,6 +888,7 @@ struct hclge_port_base_vlan_config {
 struct hclge_vf_info {
 	int link_state;
 	u8 mac[ETH_ALEN];
+	u32 spoofchk;
 };
 
 struct hclge_vport {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index b842291..cad7029 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -324,6 +324,9 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		proto =  msg_cmd->proto;
 		status = hclge_set_vlan_filter(handle, cpu_to_be16(proto),
 					       vlan, is_kill);
+		if (mbx_req->mbx_need_resp)
+			return hclge_gen_resp_to_vf(vport, mbx_req, status,
+						    NULL, 0);
 	} else if (msg_cmd->subcode == HCLGE_MBX_VLAN_RX_OFF_CFG) {
 		struct hnae3_handle *handle = &vport->nic;
 		bool en = msg_cmd->is_kill ? true : false;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e3090b3..2b87b70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1267,7 +1267,7 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	memcpy(&msg_data[3], &proto, sizeof(proto));
 	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
 				   HCLGE_MBX_VLAN_FILTER, msg_data,
-				   HCLGEVF_VLAN_MBX_MSG_LEN, false, NULL, 0);
+				   HCLGEVF_VLAN_MBX_MSG_LEN, true, NULL, 0);
 
 	/* when remove hw vlan filter failed, record the vlan id,
 	 * and try to remove it from hw later, to be consistence
-- 
2.7.4

