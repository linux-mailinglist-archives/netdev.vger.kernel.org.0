Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A849CF062
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfJHBXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:23:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52958 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729285AbfJHBWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:54 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 43B6DAB69B184AD771AB;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 3/6] net: hns3: add support for setting VF trust
Date:   Tue, 8 Oct 2019 09:20:06 +0800
Message-ID: <1570497609-36349-4-git-send-email-tanhuazhong@huawei.com>
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

This patch adds supports for setting VF trust by host. If specified
VF is trusted, then it can enable promisc(include allmulti mode).
If a trusted VF enabled promisc, and being untrusted, host will
disable promisc mode for this VF.

For VF will update its promisc mode from set_rx_mode now, so it's
unnecessary to set broadcst promisc mode when initialization or
reset.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  4 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 11 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 --
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 60 ++++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 36 +++++++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 34 +++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 12 +++++
 9 files changed, 129 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index f8a87f8..0059d44 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -45,6 +45,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_LINK_MODE,	/* (VF -> PF) get the link mode of pf */
 	HCLGE_MBX_PUSH_VLAN_INFO,	/* (PF -> VF) push port base vlan */
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
+	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf reset status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index b7b8169..ef56f37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -370,6 +370,9 @@ struct hnae3_ae_dev {
  *   Set VF link status
  * set_vf_spoofchk
  *   Enable/disable spoof check for specified vf
+ * set_vf_trust
+ *   Enable/disable trust for specified vf, if the vf being trusted, then
+ *   it can enable promisc mode
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -541,6 +544,7 @@ struct hnae3_ae_ops {
 				 int link_state);
 	int (*set_vf_spoofchk)(struct hnae3_handle *handle, int vf,
 			       bool enable);
+	int (*set_vf_trust)(struct hnae3_handle *handle, int vf, bool enable);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4a5404e..5c50555 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1656,6 +1656,16 @@ static int hns3_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
 	return handle->ae_algo->ops->set_vf_spoofchk(handle, vf, enable);
 }
 
+static int hns3_set_vf_trust(struct net_device *netdev, int vf, bool enable)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	if (!handle->ae_algo->ops->set_vf_trust)
+		return -EOPNOTSUPP;
+
+	return handle->ae_algo->ops->set_vf_trust(handle, vf, enable);
+}
+
 static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -1856,6 +1866,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= hns3_vlan_rx_kill_vid,
 	.ndo_set_vf_vlan	= hns3_ndo_set_vf_vlan,
 	.ndo_set_vf_spoofchk	= hns3_set_vf_spoofchk,
+	.ndo_set_vf_trust	= hns3_set_vf_trust,
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= hns3_rx_flow_steer,
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 4821fe0..265695a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1090,9 +1090,6 @@ void hclge_cmd_setup_basic_desc(struct hclge_desc *desc,
 				enum hclge_opcode_type opcode, bool is_read);
 void hclge_cmd_reuse_desc(struct hclge_desc *desc, bool is_read);
 
-int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
-			       struct hclge_promisc_param *param);
-
 enum hclge_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
 					   struct hclge_desc *desc);
 enum hclge_cmd_status hclge_cmd_mdio_read(struct hclge_hw *hw,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7c72862..c63f723 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2889,6 +2889,7 @@ static int hclge_get_vf_config(struct hnae3_handle *handle, int vf,
 	ivf->vf = vf;
 	ivf->linkstate = vport->vf_info.link_state;
 	ivf->spoofchk = vport->vf_info.spoofchk;
+	ivf->trusted = vport->vf_info.trusted;
 	ether_addr_copy(ivf->mac, vport->vf_info.mac);
 
 	return 0;
@@ -4614,8 +4615,8 @@ static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle, int vector,
 	return ret;
 }
 
-int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
-			       struct hclge_promisc_param *param)
+static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
+				      struct hclge_promisc_param *param)
 {
 	struct hclge_promisc_cfg_cmd *req;
 	struct hclge_desc desc;
@@ -4642,8 +4643,9 @@ int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
 	return ret;
 }
 
-void hclge_promisc_param_init(struct hclge_promisc_param *param, bool en_uc,
-			      bool en_mc, bool en_bc, int vport_id)
+static void hclge_promisc_param_init(struct hclge_promisc_param *param,
+				     bool en_uc, bool en_mc, bool en_bc,
+				     int vport_id)
 {
 	if (!param)
 		return;
@@ -4658,12 +4660,21 @@ void hclge_promisc_param_init(struct hclge_promisc_param *param, bool en_uc,
 	param->vf_id = vport_id;
 }
 
+int hclge_set_vport_promisc_mode(struct hclge_vport *vport, bool en_uc_pmc,
+				 bool en_mc_pmc, bool en_bc_pmc)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_promisc_param param;
+
+	hclge_promisc_param_init(&param, en_uc_pmc, en_mc_pmc, en_bc_pmc,
+				 vport->vport_id);
+	return hclge_cmd_set_promisc_mode(hdev, &param);
+}
+
 static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 				  bool en_mc_pmc)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-	struct hclge_promisc_param param;
 	bool en_bc_pmc = true;
 
 	/* For revision 0x20, if broadcast promisc enabled, vlan filter is
@@ -4673,9 +4684,8 @@ static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 	if (handle->pdev->revision == 0x20)
 		en_bc_pmc = handle->netdev_flags & HNAE3_BPE ? true : false;
 
-	hclge_promisc_param_init(&param, en_uc_pmc, en_mc_pmc, en_bc_pmc,
-				 vport->vport_id);
-	return hclge_cmd_set_promisc_mode(hdev, &param);
+	return hclge_set_vport_promisc_mode(vport, en_uc_pmc, en_mc_pmc,
+					    en_bc_pmc);
 }
 
 static int hclge_get_fd_mode(struct hclge_dev *hdev, u8 *fd_mode)
@@ -9479,6 +9489,37 @@ static int hclge_reset_vport_spoofchk(struct hclge_dev *hdev)
 	return 0;
 }
 
+static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 new_trusted = enable ? 1 : 0;
+	bool en_bc_pmc;
+	int ret;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	if (vport->vf_info.trusted == new_trusted)
+		return 0;
+
+	/* Disable promisc mode for VF if it is not trusted any more. */
+	if (!enable && vport->vf_info.promisc_enable) {
+		en_bc_pmc = hdev->pdev->revision != 0x20;
+		ret = hclge_set_vport_promisc_mode(vport, false, false,
+						   en_bc_pmc);
+		if (ret)
+			return ret;
+		vport->vf_info.promisc_enable = 0;
+		hclge_inform_vf_promisc_info(vport);
+	}
+
+	vport->vf_info.trusted = new_trusted;
+
+	return 0;
+}
+
 static void hclge_reset_vport_state(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
@@ -10318,6 +10359,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_vf_config = hclge_get_vf_config,
 	.set_vf_link_state = hclge_set_vf_link_state,
 	.set_vf_spoofchk = hclge_set_vf_spoofchk,
+	.set_vf_trust = hclge_set_vf_trust,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9483529..66e8833 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -889,6 +889,8 @@ struct hclge_vf_info {
 	int link_state;
 	u8 mac[ETH_ALEN];
 	u32 spoofchk;
+	u32 trusted;
+	u16 promisc_enable;
 };
 
 struct hclge_vport {
@@ -929,9 +931,8 @@ struct hclge_vport {
 	struct list_head vlan_list;     /* Store VF vlan table */
 };
 
-void hclge_promisc_param_init(struct hclge_promisc_param *param, bool en_uc,
-			      bool en_mc, bool en_bc, int vport_id);
-
+int hclge_set_vport_promisc_mode(struct hclge_vport *vport, bool en_uc_pmc,
+				 bool en_mc_pmc, bool en_bc_pmc);
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
 			     const unsigned char *addr);
 int hclge_rm_uc_addr_common(struct hclge_vport *vport,
@@ -1000,4 +1001,5 @@ int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 				struct hclge_desc *desc);
 void hclge_report_hw_error(struct hclge_dev *hdev,
 			   enum hnae3_hw_error_type type);
+void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index cad7029..131b47b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -205,12 +205,38 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *req)
 {
-	bool en_bc = req->msg[1] ? true : false;
-	struct hclge_promisc_param param;
+#define HCLGE_MBX_BC_INDEX	1
+#define HCLGE_MBX_UC_INDEX	2
+#define HCLGE_MBX_MC_INDEX	3
 
-	/* vf is not allowed to enable unicast/multicast broadcast */
-	hclge_promisc_param_init(&param, false, false, en_bc, vport->vport_id);
-	return hclge_cmd_set_promisc_mode(vport->back, &param);
+	bool en_bc = req->msg[HCLGE_MBX_BC_INDEX] ? true : false;
+	bool en_uc = req->msg[HCLGE_MBX_UC_INDEX] ? true : false;
+	bool en_mc = req->msg[HCLGE_MBX_MC_INDEX] ? true : false;
+	int ret;
+
+	if (!vport->vf_info.trusted) {
+		en_uc = false;
+		en_mc = false;
+	}
+
+	ret = hclge_set_vport_promisc_mode(vport, en_uc, en_mc, en_bc);
+	if (req->mbx_need_resp)
+		hclge_gen_resp_to_vf(vport, req, ret, NULL, 0);
+
+	vport->vf_info.promisc_enable = (en_uc || en_mc) ? 1 : 0;
+
+	return ret;
+}
+
+void hclge_inform_vf_promisc_info(struct hclge_vport *vport)
+{
+	u8 dest_vfid = (u8)vport->vport_id;
+	u8 msg_data[2];
+
+	memcpy(&msg_data[0], &vport->vf_info.promisc_enable, sizeof(u16));
+
+	hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
+			   HCLGE_MBX_PUSH_PROMISC_INFO, dest_vfid);
 }
 
 static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 2b87b70..1732668 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1105,6 +1105,7 @@ static int hclgevf_put_vector(struct hnae3_handle *handle, int vector)
 }
 
 static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
+					bool en_uc_pmc, bool en_mc_pmc,
 					bool en_bc_pmc)
 {
 	struct hclge_mbx_vf_to_pf_cmd *req;
@@ -1112,10 +1113,11 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 	int ret;
 
 	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
-
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_VF_TO_PF, false);
 	req->msg[0] = HCLGE_MBX_SET_PROMISC_MODE;
 	req->msg[1] = en_bc_pmc ? 1 : 0;
+	req->msg[2] = en_uc_pmc ? 1 : 0;
+	req->msg[3] = en_mc_pmc ? 1 : 0;
 
 	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
@@ -1125,9 +1127,17 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 	return ret;
 }
 
-static int hclgevf_set_promisc_mode(struct hclgevf_dev *hdev, bool en_bc_pmc)
+static int hclgevf_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
+				    bool en_mc_pmc)
 {
-	return hclgevf_cmd_set_promisc_mode(hdev, en_bc_pmc);
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct pci_dev *pdev = hdev->pdev;
+	bool en_bc_pmc;
+
+	en_bc_pmc = pdev->revision != 0x20;
+
+	return hclgevf_cmd_set_promisc_mode(hdev, en_uc_pmc, en_mc_pmc,
+					    en_bc_pmc);
 }
 
 static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, unsigned int tqp_id,
@@ -2626,12 +2636,6 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
-	if (pdev->revision >= 0x21) {
-		ret = hclgevf_set_promisc_mode(hdev, true);
-		if (ret)
-			return ret;
-	}
-
 	dev_info(&hdev->pdev->dev, "Reset done\n");
 
 	return 0;
@@ -2706,17 +2710,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		goto err_config;
 
-	/* vf is not allowed to enable unicast/multicast promisc mode.
-	 * For revision 0x20, default to disable broadcast promisc mode,
-	 * firmware makes sure broadcast packets can be accepted.
-	 * For revision 0x21, default to enable broadcast promisc mode.
-	 */
-	if (pdev->revision >= 0x21) {
-		ret = hclgevf_set_promisc_mode(hdev, true);
-		if (ret)
-			goto err_config;
-	}
-
 	/* Initialize RSS for this VF */
 	ret = hclgevf_rss_init_hw(hdev);
 	if (ret) {
@@ -3130,6 +3123,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.get_global_queue_id = hclgevf_get_qid_global,
 	.set_timer_task = hclgevf_set_timer_task,
 	.get_link_mode = hclgevf_get_link_mode,
+	.set_promisc_mode = hclgevf_set_promisc_mode,
 };
 
 static struct hnae3_ae_algo ae_algovf = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index a108191..72bacf8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -205,6 +205,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		case HCLGE_MBX_ASSERTING_RESET:
 		case HCLGE_MBX_LINK_STAT_MODE:
 		case HCLGE_MBX_PUSH_VLAN_INFO:
+		case HCLGE_MBX_PUSH_PROMISC_INFO:
 			/* set this mbx event as pending. This is required as we
 			 * might loose interrupt event when mbx task is busy
 			 * handling. This shall be cleared when mbx task just
@@ -248,6 +249,14 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			  crq->next_to_use);
 }
 
+static void hclgevf_parse_promisc_info(struct hclgevf_dev *hdev,
+				       u16 promisc_info)
+{
+	if (!promisc_info)
+		dev_info(&hdev->pdev->dev,
+			 "Promisc mode is closed by host for being untrusted.\n");
+}
+
 void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 {
 	enum hnae3_reset_type reset_type;
@@ -313,6 +322,9 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			hclgevf_update_port_base_vlan_info(hdev, state,
 							   (u8 *)vlan_info, 8);
 			break;
+		case HCLGE_MBX_PUSH_PROMISC_INFO:
+			hclgevf_parse_promisc_info(hdev, msg_q[1]);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"fetched unsupported(%d) message from arq\n",
-- 
2.7.4

