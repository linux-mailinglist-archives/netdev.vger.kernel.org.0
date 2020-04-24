Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6101B6B41
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDXCYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2887 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbgDXCYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:32 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AB83C554A8AC514D47CD;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:18 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/8] net: hns3: optimize the filter table entries handling when resetting
Date:   Fri, 24 Apr 2020 10:23:13 +0800
Message-ID: <1587694993-25183-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the PF driver removes all (including its VFs') MAC/VLAN
flow director table entries when resetting, and restores them after
reset completed.

In fact, the hardware will clear all table entries only in IMP
reset and global reset. So driver only needs to restore the table
entries in these cases, and needs do nothing when PF reset, FLR
or other function level reset.

This patch optimizes it by removing unnecessary table entries clear
and restoring handling in the reset flow, and doing the restoring
after reset completed.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  5 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 --
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 33 --------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  9 ---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 89 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 28 ++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 29 ++++---
 8 files changed, 94 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 948e67e..21a7361 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -45,6 +45,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 	HCLGE_MBX_VF_UNINIT,            /* (VF -> PF) vf is unintializing */
+	HCLGE_MBX_HANDLE_VF_TBL,	/* (VF -> PF) store/clear hw table */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
@@ -70,6 +71,10 @@ enum hclge_mbx_vlan_cfg_subcode {
 	HCLGE_MBX_GET_PORT_BASE_VLAN_STATE,	/* get port based vlan state */
 };
 
+enum hclge_mbx_tbl_cfg_subcode {
+	HCLGE_MBX_VPORT_LIST_CLEAR,
+};
+
 #define HCLGE_MBX_MAX_MSG_SIZE	14
 #define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
 #define HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM	4
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a56f8d6..6291aa9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -233,7 +233,6 @@ struct hnae3_ae_dev {
 	struct list_head node;
 	u32 flag;
 	unsigned long hw_err_reset_req;
-	enum hnae3_reset_type reset_type;
 	void *priv;
 };
 
@@ -356,8 +355,6 @@ struct hnae3_ae_dev {
  *   Set vlan filter config of Ports
  * set_vf_vlan_filter()
  *   Set vlan filter config of vf
- * restore_vlan_table()
- *   Restore vlan filter entries after reset
  * enable_hw_strip_rxvtag()
  *   Enable/disable hardware strip vlan tag of packets received
  * set_gro_en
@@ -528,7 +525,6 @@ struct hnae3_ae_ops {
 				struct ethtool_rxnfc *cmd);
 	int (*get_fd_all_rules)(struct hnae3_handle *handle,
 				struct ethtool_rxnfc *cmd, u32 *rule_locs);
-	int (*restore_fd_rules)(struct hnae3_handle *handle);
 	void (*enable_fd)(struct hnae3_handle *handle, bool enable);
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
@@ -542,7 +538,6 @@ struct hnae3_ae_ops {
 	void (*set_timer_task)(struct hnae3_handle *handle, bool enable);
 	int (*mac_connect_phy)(struct hnae3_handle *handle);
 	void (*mac_disconnect_phy)(struct hnae3_handle *handle);
-	void (*restore_vlan_table)(struct hnae3_handle *handle);
 	int (*get_vf_config)(struct hnae3_handle *handle, int vf,
 			     struct ifla_vf_info *ivf);
 	int (*set_vf_link_state)(struct hnae3_handle *handle, int vf,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6b9535c..c79d6a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2102,7 +2102,6 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ae_dev->pdev = pdev;
 	ae_dev->flag = ent->driver_data;
-	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hns3_get_dev_capability(pdev, ae_dev);
 	pci_set_drvdata(pdev, ae_dev);
 
@@ -3936,17 +3935,6 @@ static void hns3_uninit_phy(struct net_device *netdev)
 		h->ae_algo->ops->mac_disconnect_phy(h);
 }
 
-static int hns3_restore_fd_rules(struct net_device *netdev)
-{
-	struct hnae3_handle *h = hns3_get_handle(netdev);
-	int ret = 0;
-
-	if (h->ae_algo->ops->restore_fd_rules)
-		ret = h->ae_algo->ops->restore_fd_rules(h);
-
-	return ret;
-}
-
 static void hns3_del_all_fd_rules(struct net_device *netdev, bool clear_list)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -4346,7 +4334,6 @@ static void hns3_restore_coal(struct hns3_nic_priv *priv)
 
 static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 {
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 	struct net_device *ndev = kinfo->netdev;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
@@ -4354,13 +4341,6 @@ static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 	if (test_and_set_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
 		return 0;
 
-	/* it is cumbersome for hardware to pick-and-choose entries for deletion
-	 * from table space. Hence, for function reset software intervention is
-	 * required to delete the entries
-	 */
-	if (hns3_dev_ongoing_func_reset(ae_dev))
-		hns3_del_all_fd_rules(ndev, false);
-
 	if (!netif_running(ndev))
 		return 0;
 
@@ -4455,16 +4435,6 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	return ret;
 }
 
-static int hns3_reset_notify_restore_enet(struct hnae3_handle *handle)
-{
-	struct net_device *netdev = handle->kinfo.netdev;
-
-	if (handle->ae_algo->ops->restore_vlan_table)
-		handle->ae_algo->ops->restore_vlan_table(handle);
-
-	return hns3_restore_fd_rules(netdev);
-}
-
 static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 {
 	struct net_device *netdev = handle->kinfo.netdev;
@@ -4514,9 +4484,6 @@ static int hns3_reset_notify(struct hnae3_handle *handle,
 	case HNAE3_UNINIT_CLIENT:
 		ret = hns3_reset_notify_uninit_enet(handle);
 		break;
-	case HNAE3_RESTORE_CLIENT:
-		ret = hns3_reset_notify_restore_enet(handle);
-		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 53bc0ed..240ba06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -576,15 +576,6 @@ static inline void hns3_write_reg(void __iomem *base, u32 reg, u32 value)
 	writel(value, reg_addr + reg);
 }
 
-static inline bool hns3_dev_ongoing_func_reset(struct hnae3_ae_dev *ae_dev)
-{
-	return (ae_dev && (ae_dev->reset_type == HNAE3_FUNC_RESET ||
-			   ae_dev->reset_type == HNAE3_FLR_RESET ||
-			   ae_dev->reset_type == HNAE3_VF_FUNC_RESET ||
-			   ae_dev->reset_type == HNAE3_VF_FULL_RESET ||
-			   ae_dev->reset_type == HNAE3_VF_PF_FUNC_RESET));
-}
-
 #define hns3_read_dev(a, reg) \
 	hns3_read_reg((a)->io_base, (reg))
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 177ef5e..c74990a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -69,6 +69,7 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 static int hclge_set_default_loopback(struct hclge_dev *hdev);
 
 static void hclge_sync_mac_table(struct hclge_dev *hdev);
+static void hclge_restore_hw_table(struct hclge_dev *hdev);
 static void hclge_sync_promisc_mode(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
@@ -3731,22 +3732,13 @@ static int hclge_reset_stack(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
-	if (ret)
-		return ret;
-
-	return hclge_notify_client(hdev, HNAE3_RESTORE_CLIENT);
+	return hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
 }
 
 static int hclge_reset_prepare(struct hclge_dev *hdev)
 {
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int ret;
 
-	/* Initialize ae_dev reset status as well, in case enet layer wants to
-	 * know if device is undergoing reset
-	 */
-	ae_dev->reset_type = hdev->reset_type;
 	hdev->rst_stats.reset_cnt++;
 	/* perform reset of the stack & ae device for a client */
 	ret = hclge_notify_roce_client(hdev, HNAE3_DOWN_CLIENT);
@@ -3808,7 +3800,6 @@ static int hclge_reset_rebuild(struct hclge_dev *hdev)
 	hdev->last_reset_time = jiffies;
 	hdev->rst_stats.reset_fail_cnt = 0;
 	hdev->rst_stats.reset_done_cnt++;
-	ae_dev->reset_type = HNAE3_NONE_RESET;
 	clear_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
 
 	/* if default_reset_request has a higher level reset request,
@@ -6942,8 +6933,14 @@ int hclge_vport_start(struct hclge_vport *vport)
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 	vport->last_active_jiffies = jiffies;
 
-	if (test_bit(vport->vport_id, hdev->vport_config_block))
-		hclge_restore_mac_table_common(vport);
+	if (test_bit(vport->vport_id, hdev->vport_config_block)) {
+		if (vport->vport_id) {
+			hclge_restore_mac_table_common(vport);
+			hclge_restore_vport_vlan_table(vport);
+		} else {
+			hclge_restore_hw_table(hdev);
+		}
+	}
 
 	clear_bit(vport->vport_id, hdev->vport_config_block);
 
@@ -8789,39 +8786,34 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_restore_vlan_table(struct hnae3_handle *handle)
+void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 	u16 vlan_proto;
-	u16 state, vlan_id;
-	int i;
+	u16 vlan_id;
+	u16 state;
+	int ret;
 
-	for (i = 0; i < hdev->num_alloc_vport; i++) {
-		vport = &hdev->vport[i];
-		vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
-		vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-		state = vport->port_base_vlan_cfg.state;
+	vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
+	vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
+	state = vport->port_base_vlan_cfg.state;
 
-		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
-			hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
-						 vport->vport_id, vlan_id,
-						 false);
-			continue;
-		}
-
-		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
-			int ret;
+	if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
+		clear_bit(vport->vport_id, hdev->vlan_table[vlan_id]);
+		hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
+					 vport->vport_id, vlan_id,
+					 false);
+		return;
+	}
 
-			if (!vlan->hd_tbl_status)
-				continue;
-			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
-						       vport->vport_id,
-						       vlan->vlan_id, false);
-			if (ret)
-				break;
-		}
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       vlan->vlan_id, false);
+		if (ret)
+			break;
+		vlan->hd_tbl_status = true;
 	}
 }
 
@@ -8856,6 +8848,18 @@ void hclge_restore_mac_table_common(struct hclge_vport *vport)
 	spin_unlock_bh(&vport->mac_list_lock);
 }
 
+static void hclge_restore_hw_table(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = &hdev->vport[0];
+	struct hnae3_handle *handle = &vport->nic;
+
+	hclge_restore_mac_table_common(vport);
+	hclge_restore_vport_vlan_table(vport);
+	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+
+	hclge_restore_fd_entries(handle);
+}
+
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -10352,13 +10356,12 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	 */
 	if (hdev->reset_type == HNAE3_IMP_RESET ||
 	    hdev->reset_type == HNAE3_GLOBAL_RESET) {
+		memset(hdev->vlan_table, 0, sizeof(hdev->vlan_table));
+		memset(hdev->vf_vlan_full, 0, sizeof(hdev->vf_vlan_full));
 		bitmap_set(hdev->vport_config_block, 0, hdev->num_alloc_vport);
 		hclge_reset_umv_space(hdev);
 	}
 
-	memset(hdev->vlan_table, 0, sizeof(hdev->vlan_table));
-	memset(hdev->vf_vlan_full, 0, sizeof(hdev->vf_vlan_full));
-
 	ret = hclge_cmd_init(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Cmd queue init failed\n");
@@ -11191,7 +11194,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_fd_rule_cnt = hclge_get_fd_rule_cnt,
 	.get_fd_rule_info = hclge_get_fd_rule_info,
 	.get_fd_all_rules = hclge_get_all_rules,
-	.restore_fd_rules = hclge_restore_fd_entries,
 	.enable_fd = hclge_enable_fd,
 	.add_arfs_entry = hclge_add_fd_entry_by_arfs,
 	.dbg_run_cmd = hclge_dbg_run_cmd,
@@ -11204,7 +11206,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_timer_task = hclge_set_timer_task,
 	.mac_connect_phy = hclge_mac_connect_phy,
 	.mac_disconnect_phy = hclge_mac_disconnect_phy,
-	.restore_vlan_table = hclge_restore_vlan_table,
 	.get_vf_config = hclge_get_vf_config,
 	.set_vf_link_state = hclge_set_vf_link_state,
 	.set_vf_spoofchk = hclge_set_vf_spoofchk,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 8e69651..913c4f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1001,6 +1001,7 @@ void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list);
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev);
 void hclge_restore_mac_table_common(struct hclge_vport *vport);
+void hclge_restore_vport_vlan_table(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0efc045..ac70faf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -629,6 +629,23 @@ static void hclge_handle_ncsi_error(struct hclge_dev *hdev)
 	ae_dev->ops->reset_event(hdev->pdev, NULL);
 }
 
+static void hclge_handle_vf_tbl(struct hclge_vport *vport,
+				struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_vf_vlan_cfg *msg_cmd;
+
+	msg_cmd = (struct hclge_vf_vlan_cfg *)&mbx_req->msg;
+	if (msg_cmd->subcode == HCLGE_MBX_VPORT_LIST_CLEAR) {
+		hclge_rm_vport_all_mac_table(vport, true, HCLGE_MAC_ADDR_UC);
+		hclge_rm_vport_all_mac_table(vport, true, HCLGE_MAC_ADDR_MC);
+		hclge_rm_vport_all_vlan_table(vport, true);
+	} else {
+		dev_warn(&hdev->pdev->dev, "Invalid cmd(%u)\n",
+			 msg_cmd->subcode);
+	}
+}
+
 void hclge_mbx_handler(struct hclge_dev *hdev)
 {
 	struct hclge_cmq_ring *crq = &hdev->hw.cmq.crq;
@@ -636,6 +653,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 	struct hclge_mbx_vf_to_pf_cmd *req;
 	struct hclge_vport *vport;
 	struct hclge_desc *desc;
+	bool is_del = false;
 	unsigned int flag;
 	int ret = 0;
 
@@ -753,11 +771,12 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			break;
 		case HCLGE_MBX_GET_VF_FLR_STATUS:
 		case HCLGE_MBX_VF_UNINIT:
-			hclge_rm_vport_all_mac_table(vport, true,
+			is_del = req->msg.code == HCLGE_MBX_VF_UNINIT;
+			hclge_rm_vport_all_mac_table(vport, is_del,
 						     HCLGE_MAC_ADDR_UC);
-			hclge_rm_vport_all_mac_table(vport, true,
+			hclge_rm_vport_all_mac_table(vport, is_del,
 						     HCLGE_MAC_ADDR_MC);
-			hclge_rm_vport_all_vlan_table(vport, true);
+			hclge_rm_vport_all_vlan_table(vport, is_del);
 			break;
 		case HCLGE_MBX_GET_MEDIA_TYPE:
 			hclge_get_vf_media_type(vport, &resp_msg);
@@ -771,6 +790,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		case HCLGE_MBX_NCSI_ERROR:
 			hclge_handle_ncsi_error(hdev);
 			break;
+		case HCLGE_MBX_HANDLE_VF_TBL:
+			hclge_handle_vf_tbl(vport, req);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"un-supported mailbox message, code = %u\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fea197f..32341dc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1777,10 +1777,6 @@ static int hclgevf_reset_stack(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclgevf_notify_client(hdev, HNAE3_RESTORE_CLIENT);
-	if (ret)
-		return ret;
-
 	/* clear handshake status with IMP */
 	hclgevf_reset_handshake(hdev, false);
 
@@ -1860,13 +1856,8 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 
 static int hclgevf_reset_prepare(struct hclgevf_dev *hdev)
 {
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int ret;
 
-	/* Initialize ae_dev reset status as well, in case enet layer wants to
-	 * know if device is undergoing reset
-	 */
-	ae_dev->reset_type = hdev->reset_type;
 	hdev->rst_stats.rst_cnt++;
 
 	rtnl_lock();
@@ -1881,7 +1872,6 @@ static int hclgevf_reset_prepare(struct hclgevf_dev *hdev)
 
 static int hclgevf_reset_rebuild(struct hclgevf_dev *hdev)
 {
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int ret;
 
 	hdev->rst_stats.hw_rst_done_cnt++;
@@ -1896,7 +1886,6 @@ static int hclgevf_reset_rebuild(struct hclgevf_dev *hdev)
 	}
 
 	hdev->last_reset_time = jiffies;
-	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hdev->rst_stats.rst_done_cnt++;
 	hdev->rst_stats.rst_fail_cnt = 0;
 	clear_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
@@ -2974,6 +2963,15 @@ static int hclgevf_pci_reset(struct hclgevf_dev *hdev)
 	return ret;
 }
 
+static int hclgevf_clear_vport_list(struct hclgevf_dev *hdev)
+{
+	struct hclge_vf_to_pf_msg send_msg;
+
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_HANDLE_VF_TBL,
+			       HCLGE_MBX_VPORT_LIST_CLEAR);
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+}
+
 static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -3083,6 +3081,15 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
+	/* ensure vf tbl list as empty before init*/
+	ret = hclgevf_clear_vport_list(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to clear tbl list configuration, ret = %d.\n",
+			ret);
+		goto err_config;
+	}
+
 	ret = hclgevf_init_vlan_config(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-- 
2.7.4

