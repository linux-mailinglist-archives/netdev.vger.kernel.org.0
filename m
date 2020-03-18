Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE21894AD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCRD57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:57:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58066 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbgCRD57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 23:57:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5FF546C83EE262AEF157;
        Wed, 18 Mar 2020 11:57:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Mar 2020 11:57:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: refactor the mailbox message between PF and VF
Date:   Wed, 18 Mar 2020 11:57:06 +0800
Message-ID: <1584503827-12025-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584503827-12025-1-git-send-email-tanhuazhong@huawei.com>
References: <1584503827-12025-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For making the code more readable, this adds several new
structure to replace the msg field in structure
hclge_mbx_vf_to_pf_cmd and hclge_mbx_pf_to_vf_cmd.
Also uses macro to instead of some magic number.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  46 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 124 ++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 311 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  40 ++-
 5 files changed, 291 insertions(+), 234 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index d87158a..b622d93 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -7,8 +7,6 @@
 #include <linux/mutex.h>
 #include <linux/types.h>
 
-#define HCLGE_MBX_VF_MSG_DATA_NUM	16
-
 enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_RESET = 0x01,		/* (VF -> PF) assert reset */
 	HCLGE_MBX_ASSERTING_RESET,	/* (PF -> VF) PF is asserting reset*/
@@ -72,10 +70,15 @@ enum hclge_mbx_vlan_cfg_subcode {
 	HCLGE_MBX_GET_PORT_BASE_VLAN_STATE,	/* get port based vlan state */
 };
 
-#define HCLGE_MBX_MAX_MSG_SIZE	16
+#define HCLGE_MBX_MAX_MSG_SIZE	14
 #define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
-#define HCLGE_MBX_RING_MAP_BASIC_MSG_NUM	3
-#define HCLGE_MBX_RING_NODE_VARIABLE_NUM	3
+#define HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM	4
+
+struct hclge_ring_chain_param {
+	u8 ring_type;
+	u8 tqp_index;
+	u8 int_gl_index;
+};
 
 struct hclgevf_mbx_resp_status {
 	struct mutex mbx_mutex; /* protects against contending sync cmd resp */
@@ -85,6 +88,35 @@ struct hclgevf_mbx_resp_status {
 	u8 additional_info[HCLGE_MBX_MAX_RESP_DATA_SIZE];
 };
 
+struct hclge_vf_to_pf_msg {
+	u8 code;
+	union {
+		struct {
+			u8 subcode;
+			u8 data[HCLGE_MBX_MAX_MSG_SIZE];
+		};
+		struct {
+			u8 en_bc;
+			u8 en_uc;
+			u8 en_mc;
+		};
+		struct {
+			u8 vector_id;
+			u8 ring_num;
+			struct hclge_ring_chain_param
+				param[HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM];
+		};
+	};
+};
+
+struct hclge_pf_to_vf_msg {
+	u16 code;
+	u16 vf_mbx_msg_code;
+	u16 vf_mbx_msg_subcode;
+	u16 resp_status;
+	u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+};
+
 struct hclge_mbx_vf_to_pf_cmd {
 	u8 rsv;
 	u8 mbx_src_vfid; /* Auto filled by IMP */
@@ -92,7 +124,7 @@ struct hclge_mbx_vf_to_pf_cmd {
 	u8 rsv1[1];
 	u8 msg_len;
 	u8 rsv2[3];
-	u8 msg[HCLGE_MBX_MAX_MSG_SIZE];
+	struct hclge_vf_to_pf_msg msg;
 };
 
 #define HCLGE_MBX_NEED_RESP_BIT		BIT(0)
@@ -102,7 +134,7 @@ struct hclge_mbx_pf_to_vf_cmd {
 	u8 rsv[3];
 	u8 msg_len;
 	u8 rsv1[3];
-	u16 msg[8];
+	struct hclge_pf_to_vf_msg msg;
 };
 
 struct hclge_vf_rst_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c24fd8c..5cb2852 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -46,26 +46,28 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 	resp_pf_to_vf->dest_vfid = vf_to_pf_req->mbx_src_vfid;
 	resp_pf_to_vf->msg_len = vf_to_pf_req->msg_len;
 
-	resp_pf_to_vf->msg[0] = HCLGE_MBX_PF_VF_RESP;
-	resp_pf_to_vf->msg[1] = vf_to_pf_req->msg[0];
-	resp_pf_to_vf->msg[2] = vf_to_pf_req->msg[1];
+	resp_pf_to_vf->msg.code = HCLGE_MBX_PF_VF_RESP;
+	resp_pf_to_vf->msg.vf_mbx_msg_code = vf_to_pf_req->msg.code;
+	resp_pf_to_vf->msg.vf_mbx_msg_subcode = vf_to_pf_req->msg.subcode;
 	resp = hclge_errno_to_resp(resp_status);
 	if (resp < SHRT_MAX) {
-		resp_pf_to_vf->msg[3] = resp;
+		resp_pf_to_vf->msg.resp_status = resp;
 	} else {
 		dev_warn(&hdev->pdev->dev,
 			 "failed to send response to VF, response status %d is out-of-bound\n",
 			 resp);
-		resp_pf_to_vf->msg[3] = EIO;
+		resp_pf_to_vf->msg.resp_status = EIO;
 	}
 
 	if (resp_data && resp_data_len > 0)
-		memcpy(&resp_pf_to_vf->msg[4], resp_data, resp_data_len);
+		memcpy(resp_pf_to_vf->msg.resp_data, resp_data, resp_data_len);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
 		dev_err(&hdev->pdev->dev,
-			"PF failed(=%d) to send response to VF\n", status);
+			"failed to send response to VF, status: %d, vfid: %u, code: %u, subcode: %u.\n",
+			status, vf_to_pf_req->mbx_src_vfid,
+			vf_to_pf_req->msg.code, vf_to_pf_req->msg.subcode);
 
 	return status;
 }
@@ -84,15 +86,15 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 
 	resp_pf_to_vf->dest_vfid = dest_vfid;
 	resp_pf_to_vf->msg_len = msg_len;
-	resp_pf_to_vf->msg[0] = mbx_opcode;
+	resp_pf_to_vf->msg.code = mbx_opcode;
 
-	memcpy(&resp_pf_to_vf->msg[1], msg, msg_len);
+	memcpy(&resp_pf_to_vf->msg.vf_mbx_msg_code, msg, msg_len);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
 		dev_err(&hdev->pdev->dev,
-			"PF failed(=%d) to send mailbox message to VF\n",
-			status);
+			"failed to send mailbox to VF, status: %d, vfid: %u, opcode: %u\n",
+			status, dest_vfid, mbx_opcode);
 
 	return status;
 }
@@ -152,21 +154,20 @@ static int hclge_get_ring_chain_from_mbx(
 {
 	struct hnae3_ring_chain_node *cur_chain, *new_chain;
 	int ring_num;
-	int i;
+	int i = 0;
 
-	ring_num = req->msg[2];
+	ring_num = req->msg.ring_num;
 
-	if (ring_num > ((HCLGE_MBX_VF_MSG_DATA_NUM -
-		HCLGE_MBX_RING_MAP_BASIC_MSG_NUM) /
-		HCLGE_MBX_RING_NODE_VARIABLE_NUM))
+	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
 		return -ENOMEM;
 
-	hnae3_set_bit(ring_chain->flag, HNAE3_RING_TYPE_B, req->msg[3]);
+	hnae3_set_bit(ring_chain->flag, HNAE3_RING_TYPE_B,
+		      req->msg.param[i].ring_type);
 	ring_chain->tqp_index =
-			hclge_get_queue_id(vport->nic.kinfo.tqp[req->msg[4]]);
+		hclge_get_queue_id(vport->nic.kinfo.tqp
+				   [req->msg.param[i].tqp_index]);
 	hnae3_set_field(ring_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-			HNAE3_RING_GL_IDX_S,
-			req->msg[5]);
+			HNAE3_RING_GL_IDX_S, req->msg.param[i].int_gl_index);
 
 	cur_chain = ring_chain;
 
@@ -176,18 +177,15 @@ static int hclge_get_ring_chain_from_mbx(
 			goto err;
 
 		hnae3_set_bit(new_chain->flag, HNAE3_RING_TYPE_B,
-			      req->msg[HCLGE_MBX_RING_NODE_VARIABLE_NUM * i +
-			      HCLGE_MBX_RING_MAP_BASIC_MSG_NUM]);
+			      req->msg.param[i].ring_type);
 
 		new_chain->tqp_index =
 		hclge_get_queue_id(vport->nic.kinfo.tqp
-			[req->msg[HCLGE_MBX_RING_NODE_VARIABLE_NUM * i +
-			HCLGE_MBX_RING_MAP_BASIC_MSG_NUM + 1]]);
+			[req->msg.param[i].tqp_index]);
 
 		hnae3_set_field(new_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
 				HNAE3_RING_GL_IDX_S,
-				req->msg[HCLGE_MBX_RING_NODE_VARIABLE_NUM * i +
-				HCLGE_MBX_RING_MAP_BASIC_MSG_NUM + 2]);
+				req->msg.param[i].int_gl_index);
 
 		cur_chain->next = new_chain;
 		cur_chain = new_chain;
@@ -203,7 +201,7 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 					     struct hclge_mbx_vf_to_pf_cmd *req)
 {
 	struct hnae3_ring_chain_node ring_chain;
-	int vector_id = req->msg[1];
+	int vector_id = req->msg.vector_id;
 	int ret;
 
 	memset(&ring_chain, 0, sizeof(ring_chain));
@@ -221,13 +219,9 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *req)
 {
-#define HCLGE_MBX_BC_INDEX	1
-#define HCLGE_MBX_UC_INDEX	2
-#define HCLGE_MBX_MC_INDEX	3
-
-	bool en_bc = req->msg[HCLGE_MBX_BC_INDEX] ? true : false;
-	bool en_uc = req->msg[HCLGE_MBX_UC_INDEX] ? true : false;
-	bool en_mc = req->msg[HCLGE_MBX_MC_INDEX] ? true : false;
+	bool en_bc = req->msg.en_bc ? true : false;
+	bool en_uc = req->msg.en_uc ? true : false;
+	bool en_mc = req->msg.en_mc ? true : false;
 	int ret;
 
 	if (!vport->vf_info.trusted) {
@@ -258,12 +252,15 @@ void hclge_inform_vf_promisc_info(struct hclge_vport *vport)
 static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 				    struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
-	const u8 *mac_addr = (const u8 *)(&mbx_req->msg[2]);
+#define HCLGE_MBX_VF_OLD_MAC_ADDR_OFFSET	6
+
+	const u8 *mac_addr = (const u8 *)(mbx_req->msg.data);
 	struct hclge_dev *hdev = vport->back;
 	int status;
 
-	if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_UC_MODIFY) {
-		const u8 *old_addr = (const u8 *)(&mbx_req->msg[8]);
+	if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_UC_MODIFY) {
+		const u8 *old_addr = (const u8 *)
+		(&mbx_req->msg.data[HCLGE_MBX_VF_OLD_MAC_ADDR_OFFSET]);
 
 		/* If VF MAC has been configured by the host then it
 		 * cannot be overridden by the MAC specified by the VM.
@@ -289,12 +286,12 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 			hclge_add_vport_mac_table(vport, mac_addr,
 						  HCLGE_MAC_ADDR_UC);
 		}
-	} else if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_UC_ADD) {
+	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_UC_ADD) {
 		status = hclge_add_uc_addr_common(vport, mac_addr);
 		if (!status)
 			hclge_add_vport_mac_table(vport, mac_addr,
 						  HCLGE_MAC_ADDR_UC);
-	} else if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_UC_REMOVE) {
+	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_UC_REMOVE) {
 		status = hclge_rm_uc_addr_common(vport, mac_addr);
 		if (!status)
 			hclge_rm_vport_mac_table(vport, mac_addr,
@@ -302,7 +299,7 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 	} else {
 		dev_err(&hdev->pdev->dev,
 			"failed to set unicast mac addr, unknown subcode %u\n",
-			mbx_req->msg[1]);
+			mbx_req->msg.subcode);
 		return -EIO;
 	}
 
@@ -317,18 +314,18 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
 				    bool gen_resp)
 {
-	const u8 *mac_addr = (const u8 *)(&mbx_req->msg[2]);
+	const u8 *mac_addr = (const u8 *)(mbx_req->msg.data);
 	struct hclge_dev *hdev = vport->back;
 	u8 resp_len = 0;
 	u8 resp_data;
 	int status;
 
-	if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_MC_ADD) {
+	if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_MC_ADD) {
 		status = hclge_add_mc_addr_common(vport, mac_addr);
 		if (!status)
 			hclge_add_vport_mac_table(vport, mac_addr,
 						  HCLGE_MAC_ADDR_MC);
-	} else if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_MC_REMOVE) {
+	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_MC_REMOVE) {
 		status = hclge_rm_mc_addr_common(vport, mac_addr);
 		if (!status)
 			hclge_rm_vport_mac_table(vport, mac_addr,
@@ -336,7 +333,7 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 	} else {
 		dev_err(&hdev->pdev->dev,
 			"failed to set mcast mac addr, unknown subcode %u\n",
-			mbx_req->msg[1]);
+			mbx_req->msg.subcode);
 		return -EIO;
 	}
 
@@ -367,10 +364,13 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
+#define HCLGE_MBX_VLAN_STATE_OFFSET	0
+#define HCLGE_MBX_VLAN_INFO_OFFSET	2
+
 	struct hclge_vf_vlan_cfg *msg_cmd;
 	int status = 0;
 
-	msg_cmd = (struct hclge_vf_vlan_cfg *)mbx_req->msg;
+	msg_cmd = (struct hclge_vf_vlan_cfg *)&mbx_req->msg;
 	if (msg_cmd->subcode == HCLGE_MBX_VLAN_FILTER) {
 		struct hnae3_handle *handle = &vport->nic;
 		u16 vlan, proto;
@@ -389,15 +389,16 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		bool en = msg_cmd->is_kill ? true : false;
 
 		status = hclge_en_hw_strip_rxvtag(handle, en);
-	} else if (mbx_req->msg[1] == HCLGE_MBX_PORT_BASE_VLAN_CFG) {
+	} else if (msg_cmd->subcode == HCLGE_MBX_PORT_BASE_VLAN_CFG) {
 		struct hclge_vlan_info *vlan_info;
 		u16 *state;
 
-		state = (u16 *)&mbx_req->msg[2];
-		vlan_info = (struct hclge_vlan_info *)&mbx_req->msg[4];
+		state = (u16 *)&mbx_req->msg.data[HCLGE_MBX_VLAN_STATE_OFFSET];
+		vlan_info = (struct hclge_vlan_info *)
+			&mbx_req->msg.data[HCLGE_MBX_VLAN_INFO_OFFSET];
 		status = hclge_update_port_base_vlan_cfg(vport, *state,
 							 vlan_info);
-	} else if (mbx_req->msg[1] == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
+	} else if (msg_cmd->subcode == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
 		u8 state;
 
 		state = vport->port_base_vlan_cfg.state;
@@ -412,7 +413,7 @@ static int hclge_set_vf_alive(struct hclge_vport *vport,
 			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
 			      bool gen_resp)
 {
-	bool alive = !!mbx_req->msg[2];
+	bool alive = !!mbx_req->msg.data[0];
 	int ret = 0;
 
 	if (alive)
@@ -543,7 +544,7 @@ static void hclge_get_link_mode(struct hclge_vport *vport,
 	advertising = hdev->hw.mac.advertising[0];
 	supported = hdev->hw.mac.supported[0];
 	dest_vfid = mbx_req->mbx_src_vfid;
-	msg_data[0] = mbx_req->msg[2];
+	msg_data[0] = mbx_req->msg.data[0];
 
 	send_data = msg_data[0] == HCLGE_SUPPORTED ? supported : advertising;
 
@@ -557,7 +558,7 @@ static void hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
 {
 	u16 queue_id;
 
-	memcpy(&queue_id, &mbx_req->msg[2], sizeof(queue_id));
+	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
 
 	hclge_reset_vf_queue(vport, queue_id);
 
@@ -590,7 +591,7 @@ static int hclge_set_vf_mtu(struct hclge_vport *vport,
 	int ret;
 	u32 mtu;
 
-	memcpy(&mtu, &mbx_req->msg[2], sizeof(mtu));
+	memcpy(&mtu, mbx_req->msg.data, sizeof(mtu));
 	ret = hclge_set_vport_mtu(vport, mtu);
 
 	return hclge_gen_resp_to_vf(vport, mbx_req, ret, NULL, 0);
@@ -602,7 +603,7 @@ static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	u16 queue_id, qid_in_pf;
 	u8 resp_data[2];
 
-	memcpy(&queue_id, &mbx_req->msg[2], sizeof(queue_id));
+	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_data, &qid_in_pf, sizeof(qid_in_pf));
 
@@ -618,7 +619,7 @@ static int hclge_get_rss_key(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	u8 index;
 
-	index = mbx_req->msg[2];
+	index = mbx_req->msg.data[0];
 
 	memcpy(&resp_data[0],
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
@@ -648,13 +649,10 @@ static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
 static void hclge_handle_link_change_event(struct hclge_dev *hdev,
 					   struct hclge_mbx_vf_to_pf_cmd *req)
 {
-#define LINK_STATUS_OFFSET	1
-#define LINK_FAIL_CODE_OFFSET	2
-
 	hclge_task_schedule(hdev, 0);
 
-	if (!req->msg[LINK_STATUS_OFFSET])
-		hclge_link_fail_parse(hdev, req->msg[LINK_FAIL_CODE_OFFSET]);
+	if (!req->msg.subcode)
+		hclge_link_fail_parse(hdev, req->msg.data[0]);
 }
 
 static bool hclge_cmd_crq_empty(struct hclge_hw *hw)
@@ -697,7 +695,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B))) {
 			dev_warn(&hdev->pdev->dev,
 				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg[0]);
+				 req->msg.code);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
@@ -707,7 +705,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 
 		vport = &hdev->vport[req->mbx_src_vfid];
 
-		switch (req->msg[0]) {
+		switch (req->msg.code) {
 		case HCLGE_MBX_MAP_RING_TO_VECTOR:
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
 								req);
@@ -843,7 +841,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		default:
 			dev_err(&hdev->pdev->dev,
 				"un-supported mailbox message, code = %u\n",
-				req->msg[0]);
+				req->msg.code);
 			break;
 		}
 		crq->desc[crq->next_to_use].flag = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index bd4bbcd..2c1d01f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -229,13 +229,25 @@ static void hclgevf_get_stats(struct hnae3_handle *handle, u64 *data)
 	hclgevf_tqps_get_stats(handle, data);
 }
 
+static void hclgevf_build_send_msg(struct hclge_vf_to_pf_msg *msg, u8 code,
+				   u8 subcode)
+{
+	if (msg) {
+		memset(msg, 0, sizeof(struct hclge_vf_to_pf_msg));
+		msg->code = code;
+		msg->subcode = subcode;
+	}
+}
+
 static int hclgevf_get_tc_info(struct hclgevf_dev *hdev)
 {
+	struct hclge_vf_to_pf_msg send_msg;
 	u8 resp_msg;
 	int status;
 
-	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_TCINFO, 0, NULL, 0,
-				      true, &resp_msg, sizeof(resp_msg));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_TCINFO, 0);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, &resp_msg,
+				      sizeof(resp_msg));
 	if (status) {
 		dev_err(&hdev->pdev->dev,
 			"VF request to get TC info from PF failed %d",
@@ -251,12 +263,14 @@ static int hclgevf_get_tc_info(struct hclgevf_dev *hdev)
 static int hclgevf_get_port_base_vlan_filter_state(struct hclgevf_dev *hdev)
 {
 	struct hnae3_handle *nic = &hdev->nic;
+	struct hclge_vf_to_pf_msg send_msg;
 	u8 resp_msg;
 	int ret;
 
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-				   HCLGE_MBX_GET_PORT_BASE_VLAN_STATE,
-				   NULL, 0, true, &resp_msg, sizeof(u8));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
+			       HCLGE_MBX_GET_PORT_BASE_VLAN_STATE);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, &resp_msg,
+				   sizeof(u8));
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"VF request to get port based vlan state failed %d",
@@ -272,11 +286,16 @@ static int hclgevf_get_port_base_vlan_filter_state(struct hclgevf_dev *hdev)
 static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_TQPS_RSS_INFO_LEN	6
+#define HCLGEVF_TQPS_ALLOC_OFFSET	0
+#define HCLGEVF_TQPS_RSS_SIZE_OFFSET	2
+#define HCLGEVF_TQPS_RX_BUFFER_LEN_OFFSET	4
+
 	u8 resp_msg[HCLGEVF_TQPS_RSS_INFO_LEN];
+	struct hclge_vf_to_pf_msg send_msg;
 	int status;
 
-	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_QINFO, 0, NULL, 0,
-				      true, resp_msg,
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_QINFO, 0);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_msg,
 				      HCLGEVF_TQPS_RSS_INFO_LEN);
 	if (status) {
 		dev_err(&hdev->pdev->dev,
@@ -285,9 +304,12 @@ static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 		return status;
 	}
 
-	memcpy(&hdev->num_tqps, &resp_msg[0], sizeof(u16));
-	memcpy(&hdev->rss_size_max, &resp_msg[2], sizeof(u16));
-	memcpy(&hdev->rx_buf_len, &resp_msg[4], sizeof(u16));
+	memcpy(&hdev->num_tqps, &resp_msg[HCLGEVF_TQPS_ALLOC_OFFSET],
+	       sizeof(u16));
+	memcpy(&hdev->rss_size_max, &resp_msg[HCLGEVF_TQPS_RSS_SIZE_OFFSET],
+	       sizeof(u16));
+	memcpy(&hdev->rx_buf_len, &resp_msg[HCLGEVF_TQPS_RX_BUFFER_LEN_OFFSET],
+	       sizeof(u16));
 
 	return 0;
 }
@@ -295,11 +317,15 @@ static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 static int hclgevf_get_queue_depth(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_TQPS_DEPTH_INFO_LEN	4
+#define HCLGEVF_TQPS_NUM_TX_DESC_OFFSET	0
+#define HCLGEVF_TQPS_NUM_RX_DESC_OFFSET	2
+
 	u8 resp_msg[HCLGEVF_TQPS_DEPTH_INFO_LEN];
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_QDEPTH, 0, NULL, 0,
-				   true, resp_msg,
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_QDEPTH, 0);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_msg,
 				   HCLGEVF_TQPS_DEPTH_INFO_LEN);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -308,8 +334,10 @@ static int hclgevf_get_queue_depth(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
-	memcpy(&hdev->num_tx_desc, &resp_msg[0], sizeof(u16));
-	memcpy(&hdev->num_rx_desc, &resp_msg[2], sizeof(u16));
+	memcpy(&hdev->num_tx_desc, &resp_msg[HCLGEVF_TQPS_NUM_TX_DESC_OFFSET],
+	       sizeof(u16));
+	memcpy(&hdev->num_rx_desc, &resp_msg[HCLGEVF_TQPS_NUM_RX_DESC_OFFSET],
+	       sizeof(u16));
 
 	return 0;
 }
@@ -317,14 +345,14 @@ static int hclgevf_get_queue_depth(struct hclgevf_dev *hdev)
 static u16 hclgevf_get_qid_global(struct hnae3_handle *handle, u16 queue_id)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	u8 msg_data[2], resp_data[2];
+	struct hclge_vf_to_pf_msg send_msg;
 	u16 qid_in_pf = 0;
+	u8 resp_data[2];
 	int ret;
 
-	memcpy(&msg_data[0], &queue_id, sizeof(queue_id));
-
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_QID_IN_PF, 0, msg_data,
-				   sizeof(msg_data), true, resp_data,
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_QID_IN_PF, 0);
+	memcpy(send_msg.data, &queue_id, sizeof(queue_id));
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_data,
 				   sizeof(resp_data));
 	if (!ret)
 		qid_in_pf = *(u16 *)resp_data;
@@ -334,11 +362,13 @@ static u16 hclgevf_get_qid_global(struct hnae3_handle *handle, u16 queue_id)
 
 static int hclgevf_get_pf_media_type(struct hclgevf_dev *hdev)
 {
+	struct hclge_vf_to_pf_msg send_msg;
 	u8 resp_msg[2];
 	int ret;
 
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_MEDIA_TYPE, 0, NULL, 0,
-				   true, resp_msg, sizeof(resp_msg));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_MEDIA_TYPE, 0);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_msg,
+				   sizeof(resp_msg));
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"VF request to get the pf port media type failed %d",
@@ -425,11 +455,11 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 
 static void hclgevf_request_link_info(struct hclgevf_dev *hdev)
 {
+	struct hclge_vf_to_pf_msg send_msg;
 	int status;
-	u8 resp_msg;
 
-	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_STATUS, 0, NULL,
-				      0, false, &resp_msg, sizeof(resp_msg));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_LINK_STATUS, 0);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 	if (status)
 		dev_err(&hdev->pdev->dev,
 			"VF failed to fetch link status(%d) from PF", status);
@@ -463,19 +493,16 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 
 static void hclgevf_update_link_mode(struct hclgevf_dev *hdev)
 {
-#define HCLGEVF_ADVERTISING 0
-#define HCLGEVF_SUPPORTED   1
-	u8 send_msg;
-	u8 resp_msg;
+#define HCLGEVF_ADVERTISING	0
+#define HCLGEVF_SUPPORTED	1
+
+	struct hclge_vf_to_pf_msg send_msg;
 
-	send_msg = HCLGEVF_ADVERTISING;
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0,
-			     &send_msg, sizeof(send_msg), false,
-			     &resp_msg, sizeof(resp_msg));
-	send_msg = HCLGEVF_SUPPORTED;
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0,
-			     &send_msg, sizeof(send_msg), false,
-			     &resp_msg, sizeof(resp_msg));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_LINK_MODE, 0);
+	send_msg.data[0] = HCLGEVF_ADVERTISING;
+	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	send_msg.data[0] = HCLGEVF_SUPPORTED;
+	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
@@ -677,19 +704,19 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RSS_MBX_RESP_LEN	8
-
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 resp_msg[HCLGEVF_RSS_MBX_RESP_LEN];
+	struct hclge_vf_to_pf_msg send_msg;
 	u16 msg_num, hash_key_index;
 	u8 index;
 	int ret;
 
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_RSS_KEY, 0);
 	msg_num = (HCLGEVF_RSS_KEY_SIZE + HCLGEVF_RSS_MBX_RESP_LEN - 1) /
 			HCLGEVF_RSS_MBX_RESP_LEN;
 	for (index = 0; index < msg_num; index++) {
-		ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_RSS_KEY, 0,
-					   &index, sizeof(index),
-					   true, resp_msg,
+		send_msg.data[0] = index;
+		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_msg,
 					   HCLGEVF_RSS_MBX_RESP_LEN);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -1001,44 +1028,32 @@ static int hclgevf_bind_ring_to_vector(struct hnae3_handle *handle, bool en,
 				       struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 	struct hnae3_ring_chain_node *node;
-	struct hclge_mbx_vf_to_pf_cmd *req;
-	struct hclgevf_desc desc;
-	int i = 0;
 	int status;
-	u8 type;
+	int i = 0;
 
-	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
-	type = en ? HCLGE_MBX_MAP_RING_TO_VECTOR :
+	memset(&send_msg, 0, sizeof(send_msg));
+	send_msg.code = en ? HCLGE_MBX_MAP_RING_TO_VECTOR :
 		HCLGE_MBX_UNMAP_RING_TO_VECTOR;
+	send_msg.vector_id = vector_id;
 
 	for (node = ring_chain; node; node = node->next) {
-		int idx_offset = HCLGE_MBX_RING_MAP_BASIC_MSG_NUM +
-					HCLGE_MBX_RING_NODE_VARIABLE_NUM * i;
-
-		if (i == 0) {
-			hclgevf_cmd_setup_basic_desc(&desc,
-						     HCLGEVF_OPC_MBX_VF_TO_PF,
-						     false);
-			req->msg[0] = type;
-			req->msg[1] = vector_id;
-		}
-
-		req->msg[idx_offset] =
+		send_msg.param[i].ring_type =
 				hnae3_get_bit(node->flag, HNAE3_RING_TYPE_B);
-		req->msg[idx_offset + 1] = node->tqp_index;
-		req->msg[idx_offset + 2] = hnae3_get_field(node->int_gl_idx,
-							   HNAE3_RING_GL_IDX_M,
-							   HNAE3_RING_GL_IDX_S);
+
+		send_msg.param[i].tqp_index = node->tqp_index;
+		send_msg.param[i].int_gl_index =
+					hnae3_get_field(node->int_gl_idx,
+							HNAE3_RING_GL_IDX_M,
+							HNAE3_RING_GL_IDX_S);
 
 		i++;
-		if ((i == (HCLGE_MBX_VF_MSG_DATA_NUM -
-		     HCLGE_MBX_RING_MAP_BASIC_MSG_NUM) /
-		     HCLGE_MBX_RING_NODE_VARIABLE_NUM) ||
-		    !node->next) {
-			req->msg[2] = i;
+		if (i == HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM || !node->next) {
+			send_msg.ring_num = i;
 
-			status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
+			status = hclgevf_send_mbx_msg(hdev, &send_msg, false,
+						      NULL, 0);
 			if (status) {
 				dev_err(&hdev->pdev->dev,
 					"Map TQP fail, status is %d.\n",
@@ -1046,11 +1061,6 @@ static int hclgevf_bind_ring_to_vector(struct hnae3_handle *handle, bool en,
 				return status;
 			}
 			i = 0;
-			hclgevf_cmd_setup_basic_desc(&desc,
-						     HCLGEVF_OPC_MBX_VF_TO_PF,
-						     false);
-			req->msg[0] = type;
-			req->msg[1] = vector_id;
 		}
 	}
 
@@ -1123,18 +1133,17 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 					bool en_uc_pmc, bool en_mc_pmc,
 					bool en_bc_pmc)
 {
-	struct hclge_mbx_vf_to_pf_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
-	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_VF_TO_PF, false);
-	req->msg[0] = HCLGE_MBX_SET_PROMISC_MODE;
-	req->msg[1] = en_bc_pmc ? 1 : 0;
-	req->msg[2] = en_uc_pmc ? 1 : 0;
-	req->msg[3] = en_mc_pmc ? 1 : 0;
+	memset(&send_msg, 0, sizeof(send_msg));
+	send_msg.code = HCLGE_MBX_SET_PROMISC_MODE;
+	send_msg.en_bc = en_bc_pmc ? 1 : 0;
+	send_msg.en_uc = en_uc_pmc ? 1 : 0;
+	send_msg.en_mc = en_mc_pmc ? 1 : 0;
+
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 
-	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"Set promisc mode fail, status is %d.\n", ret);
@@ -1193,11 +1202,13 @@ static void hclgevf_reset_tqp_stats(struct hnae3_handle *handle)
 
 static int hclgevf_get_host_mac_addr(struct hclgevf_dev *hdev, u8 *p)
 {
+	struct hclge_vf_to_pf_msg send_msg;
 	u8 host_mac[ETH_ALEN];
 	int status;
 
-	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_MAC_ADDR, 0, NULL, 0,
-				      true, host_mac, ETH_ALEN);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_MAC_ADDR, 0);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, host_mac,
+				      ETH_ALEN);
 	if (status) {
 		dev_err(&hdev->pdev->dev,
 			"fail to get VF MAC from host %d", status);
@@ -1229,20 +1240,16 @@ static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	u8 *old_mac_addr = (u8 *)hdev->hw.mac.mac_addr;
+	struct hclge_vf_to_pf_msg send_msg;
 	u8 *new_mac_addr = (u8 *)p;
-	u8 msg_data[ETH_ALEN * 2];
-	u16 subcode;
 	int status;
 
-	ether_addr_copy(msg_data, new_mac_addr);
-	ether_addr_copy(&msg_data[ETH_ALEN], old_mac_addr);
-
-	subcode = is_first ? HCLGE_MBX_MAC_VLAN_UC_ADD :
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST, 0);
+	send_msg.subcode = is_first ? HCLGE_MBX_MAC_VLAN_UC_ADD :
 			HCLGE_MBX_MAC_VLAN_UC_MODIFY;
-
-	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_UNICAST,
-				      subcode, msg_data, sizeof(msg_data),
-				      true, NULL, 0);
+	ether_addr_copy(send_msg.data, new_mac_addr);
+	ether_addr_copy(&send_msg.data[ETH_ALEN], old_mac_addr);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 	if (!status)
 		ether_addr_copy(hdev->hw.mac.mac_addr, new_mac_addr);
 
@@ -1253,49 +1260,60 @@ static int hclgevf_add_uc_addr(struct hnae3_handle *handle,
 			       const unsigned char *addr)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_UNICAST,
-				    HCLGE_MBX_MAC_VLAN_UC_ADD,
-				    addr, ETH_ALEN, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST,
+			       HCLGE_MBX_MAC_VLAN_UC_ADD);
+	ether_addr_copy(send_msg.data, addr);
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_rm_uc_addr(struct hnae3_handle *handle,
 			      const unsigned char *addr)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_UNICAST,
-				    HCLGE_MBX_MAC_VLAN_UC_REMOVE,
-				    addr, ETH_ALEN, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST,
+			       HCLGE_MBX_MAC_VLAN_UC_REMOVE);
+	ether_addr_copy(send_msg.data, addr);
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_add_mc_addr(struct hnae3_handle *handle,
 			       const unsigned char *addr)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_MULTICAST,
-				    HCLGE_MBX_MAC_VLAN_MC_ADD,
-				    addr, ETH_ALEN, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MULTICAST,
+			       HCLGE_MBX_MAC_VLAN_MC_ADD);
+	ether_addr_copy(send_msg.data, addr);
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_rm_mc_addr(struct hnae3_handle *handle,
 			      const unsigned char *addr)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_MULTICAST,
-				    HCLGE_MBX_MAC_VLAN_MC_REMOVE,
-				    addr, ETH_ALEN, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MULTICAST,
+			       HCLGE_MBX_MAC_VLAN_MC_REMOVE);
+	ether_addr_copy(send_msg.data, addr);
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 				   __be16 proto, u16 vlan_id,
 				   bool is_kill)
 {
-#define HCLGEVF_VLAN_MBX_MSG_LEN 5
+#define HCLGEVF_VLAN_MBX_IS_KILL_OFFSET	0
+#define HCLGEVF_VLAN_MBX_VLAN_ID_OFFSET	1
+#define HCLGEVF_VLAN_MBX_PROTO_OFFSET	3
+
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	u8 msg_data[HCLGEVF_VLAN_MBX_MSG_LEN];
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
 	if (vlan_id > HCLGEVF_MAX_VLAN_ID)
@@ -1313,16 +1331,18 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 		return -EBUSY;
 	}
 
-	msg_data[0] = is_kill;
-	memcpy(&msg_data[1], &vlan_id, sizeof(vlan_id));
-	memcpy(&msg_data[3], &proto, sizeof(proto));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
+			       HCLGE_MBX_VLAN_FILTER);
+	send_msg.data[HCLGEVF_VLAN_MBX_IS_KILL_OFFSET] = is_kill;
+	memcpy(&send_msg.data[HCLGEVF_VLAN_MBX_VLAN_ID_OFFSET], &vlan_id,
+	       sizeof(vlan_id));
+	memcpy(&send_msg.data[HCLGEVF_VLAN_MBX_PROTO_OFFSET], &proto,
+	       sizeof(proto));
 	/* when remove hw vlan filter failed, record the vlan id,
 	 * and try to remove it from hw later, to be consistence
 	 * with stack.
 	 */
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-				   HCLGE_MBX_VLAN_FILTER, msg_data,
-				   HCLGEVF_VLAN_MBX_MSG_LEN, true, NULL, 0);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 	if (is_kill && ret)
 		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
 
@@ -1355,37 +1375,38 @@ static void hclgevf_sync_vlan_filter(struct hclgevf_dev *hdev)
 static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	u8 msg_data;
+	struct hclge_vf_to_pf_msg send_msg;
 
-	msg_data = enable ? 1 : 0;
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-				    HCLGE_MBX_VLAN_RX_OFF_CFG, &msg_data,
-				    1, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
+			       HCLGE_MBX_VLAN_RX_OFF_CFG);
+	send_msg.data[0] = enable ? 1 : 0;
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	u8 msg_data[2];
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
-	memcpy(msg_data, &queue_id, sizeof(queue_id));
-
 	/* disable vf queue before send queue reset msg to PF */
 	ret = hclgevf_tqp_enable(hdev, queue_id, 0, false);
 	if (ret)
 		return ret;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_QUEUE_RESET, 0, msg_data,
-				    sizeof(msg_data), true, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_QUEUE_RESET, 0);
+	memcpy(send_msg.data, &queue_id, sizeof(queue_id));
+	return hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 }
 
 static int hclgevf_set_mtu(struct hnae3_handle *handle, int new_mtu)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
 
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_MTU, 0, (u8 *)&new_mtu,
-				    sizeof(new_mtu), true, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MTU, 0);
+	memcpy(send_msg.data, &new_mtu, sizeof(new_mtu));
+	return hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 }
 
 static int hclgevf_notify_client(struct hclgevf_dev *hdev,
@@ -1500,11 +1521,12 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RESET_SYNC_TIME 100
 
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret = 0;
 
 	if (hdev->reset_type == HNAE3_VF_FUNC_RESET) {
-		ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_RESET, 0, NULL,
-					   0, true, NULL, sizeof(u8));
+		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_RESET, 0);
+		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 		hdev->rst_stats.vf_func_rst_cnt++;
 	}
 
@@ -1881,14 +1903,14 @@ static void hclgevf_mailbox_service_task(struct hclgevf_dev *hdev)
 
 static void hclgevf_keep_alive(struct hclgevf_dev *hdev)
 {
-	u8 respmsg;
+	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
 	if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state))
 		return;
 
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_KEEP_ALIVE, 0, NULL,
-				   0, false, &respmsg, sizeof(respmsg));
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_KEEP_ALIVE, 0);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"VF sends keep alive cmd failed(=%d)\n", ret);
@@ -2245,12 +2267,16 @@ static void hclgevf_ae_stop(struct hnae3_handle *handle)
 
 static int hclgevf_set_alive(struct hnae3_handle *handle, bool alive)
 {
+#define HCLGEVF_STATE_ALIVE	1
+#define HCLGEVF_STATE_NOT_ALIVE	0
+
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	u8 msg_data;
+	struct hclge_vf_to_pf_msg send_msg;
 
-	msg_data = alive ? 1 : 0;
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_ALIVE,
-				    0, &msg_data, 1, false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_ALIVE, 0);
+	send_msg.data[0] = alive ? HCLGEVF_STATE_ALIVE :
+				HCLGEVF_STATE_NOT_ALIVE;
+	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
 static int hclgevf_client_start(struct hnae3_handle *handle)
@@ -2804,10 +2830,12 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 {
+	struct hclge_vf_to_pf_msg send_msg;
+
 	hclgevf_state_uninit(hdev);
 
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_VF_UNINIT, 0, NULL, 0,
-			     false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_VF_UNINIT, 0);
+	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 
 	if (test_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state)) {
 		hclgevf_misc_irq_uninit(hdev);
@@ -3104,16 +3132,17 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 					u8 *port_base_vlan_info, u8 data_size)
 {
 	struct hnae3_handle *nic = &hdev->nic;
+	struct hclge_vf_to_pf_msg send_msg;
 
 	rtnl_lock();
 	hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
 	rtnl_unlock();
 
 	/* send msg to PF and wait update port based vlan info */
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-			     HCLGE_MBX_PORT_BASE_VLAN_CFG,
-			     port_base_vlan_info, data_size,
-			     false, NULL, 0);
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
+			       HCLGE_MBX_PORT_BASE_VLAN_CFG);
+	memcpy(send_msg.data, port_base_vlan_info, data_size);
+	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_DISABLE;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index fee8d97..3b88d86 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -305,8 +305,8 @@ static inline bool hclgevf_is_reset_pending(struct hclgevf_dev *hdev)
 	return !!hdev->reset_pending;
 }
 
-int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev, u16 code, u16 subcode,
-			 const u8 *msg_data, u8 msg_len, bool need_resp,
+int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
+			 struct hclge_vf_to_pf_msg *send_msg, bool need_resp,
 			 u8 *resp_data, u16 resp_len);
 void hclgevf_mbx_handler(struct hclgevf_dev *hdev);
 void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 5b481f9..3de2842 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -84,8 +84,8 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 	return 0;
 }
 
-int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev, u16 code, u16 subcode,
-			 const u8 *msg_data, u8 msg_len, bool need_resp,
+int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
+			 struct hclge_vf_to_pf_msg *send_msg, bool need_resp,
 			 u8 *resp_data, u16 resp_len)
 {
 	struct hclge_mbx_vf_to_pf_cmd *req;
@@ -94,21 +94,16 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev, u16 code, u16 subcode,
 
 	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
 
-	/* first two bytes are reserved for code & subcode */
-	if (msg_len > (HCLGE_MBX_MAX_MSG_SIZE - 2)) {
+	if (!send_msg) {
 		dev_err(&hdev->pdev->dev,
-			"VF send mbx msg fail, msg len %d exceeds max len %d\n",
-			msg_len, HCLGE_MBX_MAX_MSG_SIZE);
+			"failed to send mbx, msg is NULL\n");
 		return -EINVAL;
 	}
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_VF_TO_PF, false);
 	req->mbx_need_resp |= need_resp ? HCLGE_MBX_NEED_RESP_BIT :
 					  ~HCLGE_MBX_NEED_RESP_BIT;
-	req->msg[0] = code;
-	req->msg[1] = subcode;
-	if (msg_data)
-		memcpy(&req->msg[2], msg_data, msg_len);
+	memcpy(&req->msg, send_msg, sizeof(struct hclge_vf_to_pf_msg));
 
 	/* synchronous send */
 	if (need_resp) {
@@ -123,7 +118,8 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev, u16 code, u16 subcode,
 			return status;
 		}
 
-		status = hclgevf_get_mbx_resp(hdev, code, subcode, resp_data,
+		status = hclgevf_get_mbx_resp(hdev, send_msg->code,
+					      send_msg->subcode, resp_data,
 					      resp_len);
 		mutex_unlock(&hdev->mbx_resp.mbx_mutex);
 	} else {
@@ -174,7 +170,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		if (unlikely(!hnae3_get_bit(flag, HCLGEVF_CMDQ_RX_OUTVLD_B))) {
 			dev_warn(&hdev->pdev->dev,
 				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg[0]);
+				 req->msg.code);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
@@ -188,19 +184,21 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		 * timeout and simultaneously queue the async messages for later
 		 * prcessing in context of mailbox task i.e. the slow path.
 		 */
-		switch (req->msg[0]) {
+		switch (req->msg.code) {
 		case HCLGE_MBX_PF_VF_RESP:
 			if (resp->received_resp)
 				dev_warn(&hdev->pdev->dev,
 					 "VF mbx resp flag not clear(%u)\n",
-					 req->msg[1]);
+					 req->msg.vf_mbx_msg_code);
 			resp->received_resp = true;
 
-			resp->origin_mbx_msg = (req->msg[1] << 16);
-			resp->origin_mbx_msg |= req->msg[2];
-			resp->resp_status = hclgevf_resp_to_errno(req->msg[3]);
+			resp->origin_mbx_msg =
+					(req->msg.vf_mbx_msg_code << 16);
+			resp->origin_mbx_msg |= req->msg.vf_mbx_msg_subcode;
+			resp->resp_status =
+				hclgevf_resp_to_errno(req->msg.resp_status);
 
-			temp = (u8 *)&req->msg[4];
+			temp = (u8 *)req->msg.resp_data;
 			for (i = 0; i < HCLGE_MBX_MAX_RESP_DATA_SIZE; i++) {
 				resp->additional_info[i] = *temp;
 				temp++;
@@ -225,13 +223,13 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
 				dev_warn(&hdev->pdev->dev,
 					 "Async Q full, dropping msg(%u)\n",
-					 req->msg[1]);
+					 req->msg.code);
 				break;
 			}
 
 			/* tail the async message in arq */
 			msg_q = hdev->arq.msg_q[hdev->arq.tail];
-			memcpy(&msg_q[0], req->msg,
+			memcpy(&msg_q[0], &req->msg,
 			       HCLGE_MBX_MAX_ARQ_MSG_SIZE * sizeof(u16));
 			hclge_mbx_tail_ptr_move_arq(hdev->arq);
 			atomic_inc(&hdev->arq.count);
@@ -242,7 +240,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		default:
 			dev_err(&hdev->pdev->dev,
 				"VF received unsupported(%u) mbx msg from PF\n",
-				req->msg[0]);
+				req->msg.code);
 			break;
 		}
 		crq->desc[crq->next_to_use].flag = 0;
-- 
2.7.4

