Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB11894AF
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgCRD6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:58:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbgCRD6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 23:58:21 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6742C8906E0948A37487;
        Wed, 18 Mar 2020 11:57:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Mar 2020 11:57:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 3/3] net: hns3: refactor mailbox response scheme between PF and VF
Date:   Wed, 18 Mar 2020 11:57:07 +0800
Message-ID: <1584503827-12025-4-git-send-email-tanhuazhong@huawei.com>
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

Currently, PF responds to VF depending on what mailbox it is
handling, it is a bit inflexible. The correct way is, PF should
check the mbx_need_resp field to decide whether gives response
to VF.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 255 +++++++++------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   5 +-
 3 files changed, 113 insertions(+), 155 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index b622d93..948e67e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -88,6 +88,12 @@ struct hclgevf_mbx_resp_status {
 	u8 additional_info[HCLGE_MBX_MAX_RESP_DATA_SIZE];
 };
 
+struct hclge_respond_to_vf_msg {
+	int status;
+	u8 data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+	u16 len;
+};
+
 struct hclge_vf_to_pf_msg {
 	u8 code;
 	union {
@@ -127,7 +133,7 @@ struct hclge_mbx_vf_to_pf_cmd {
 	struct hclge_vf_to_pf_msg msg;
 };
 
-#define HCLGE_MBX_NEED_RESP_BIT		BIT(0)
+#define HCLGE_MBX_NEED_RESP_B		0
 
 struct hclge_mbx_pf_to_vf_cmd {
 	u8 dest_vfid;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 5cb2852..7f24fcb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -19,8 +19,7 @@ static u16 hclge_errno_to_resp(int errno)
  */
 static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 				struct hclge_mbx_vf_to_pf_cmd *vf_to_pf_req,
-				int resp_status,
-				u8 *resp_data, u16 resp_data_len)
+				struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hclge_mbx_pf_to_vf_cmd *resp_pf_to_vf;
 	struct hclge_dev *hdev = vport->back;
@@ -30,15 +29,15 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 
 	resp_pf_to_vf = (struct hclge_mbx_pf_to_vf_cmd *)desc.data;
 
-	if (resp_data_len > HCLGE_MBX_MAX_RESP_DATA_SIZE) {
+	if (resp_msg->len > HCLGE_MBX_MAX_RESP_DATA_SIZE) {
 		dev_err(&hdev->pdev->dev,
 			"PF fail to gen resp to VF len %u exceeds max len %u\n",
-			resp_data_len,
+			resp_msg->len,
 			HCLGE_MBX_MAX_RESP_DATA_SIZE);
-		/* If resp_data_len is too long, set the value to max length
+		/* If resp_msg->len is too long, set the value to max length
 		 * and return the msg to VF
 		 */
-		resp_data_len = HCLGE_MBX_MAX_RESP_DATA_SIZE;
+		resp_msg->len = HCLGE_MBX_MAX_RESP_DATA_SIZE;
 	}
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_PF_TO_VF, false);
@@ -49,7 +48,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 	resp_pf_to_vf->msg.code = HCLGE_MBX_PF_VF_RESP;
 	resp_pf_to_vf->msg.vf_mbx_msg_code = vf_to_pf_req->msg.code;
 	resp_pf_to_vf->msg.vf_mbx_msg_subcode = vf_to_pf_req->msg.subcode;
-	resp = hclge_errno_to_resp(resp_status);
+	resp = hclge_errno_to_resp(resp_msg->status);
 	if (resp < SHRT_MAX) {
 		resp_pf_to_vf->msg.resp_status = resp;
 	} else {
@@ -59,8 +58,9 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 		resp_pf_to_vf->msg.resp_status = EIO;
 	}
 
-	if (resp_data && resp_data_len > 0)
-		memcpy(resp_pf_to_vf->msg.resp_data, resp_data, resp_data_len);
+	if (resp_msg->len > 0)
+		memcpy(resp_pf_to_vf->msg.resp_data, resp_msg->data,
+		       resp_msg->len);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
@@ -230,8 +230,6 @@ static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 	}
 
 	ret = hclge_set_vport_promisc_mode(vport, en_uc, en_mc, en_bc);
-	if (req->mbx_need_resp)
-		hclge_gen_resp_to_vf(vport, req, ret, NULL, 0);
 
 	vport->vf_info.promisc_enable = (en_uc || en_mc) ? 1 : 0;
 
@@ -266,15 +264,11 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 		 * cannot be overridden by the MAC specified by the VM.
 		 */
 		if (!is_zero_ether_addr(vport->vf_info.mac) &&
-		    !ether_addr_equal(mac_addr, vport->vf_info.mac)) {
-			status = -EPERM;
-			goto out;
-		}
+		    !ether_addr_equal(mac_addr, vport->vf_info.mac))
+			return -EPERM;
 
-		if (!is_valid_ether_addr(mac_addr)) {
-			status = -EINVAL;
-			goto out;
-		}
+		if (!is_valid_ether_addr(mac_addr))
+			return -EINVAL;
 
 		hclge_rm_uc_addr_common(vport, old_addr);
 		status = hclge_add_uc_addr_common(vport, mac_addr);
@@ -303,21 +297,14 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 		return -EIO;
 	}
 
-out:
-	if (mbx_req->mbx_need_resp & HCLGE_MBX_NEED_RESP_BIT)
-		hclge_gen_resp_to_vf(vport, mbx_req, status, NULL, 0);
-
-	return 0;
+	return status;
 }
 
 static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
-				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				    bool gen_resp)
+				    struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
 	const u8 *mac_addr = (const u8 *)(mbx_req->msg.data);
 	struct hclge_dev *hdev = vport->back;
-	u8 resp_len = 0;
-	u8 resp_data;
 	int status;
 
 	if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_MC_ADD) {
@@ -337,11 +324,7 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 		return -EIO;
 	}
 
-	if (gen_resp)
-		hclge_gen_resp_to_vf(vport, mbx_req, status,
-				     &resp_data, resp_len);
-
-	return 0;
+	return status;
 }
 
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
@@ -362,7 +345,8 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 }
 
 static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
-				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+				 struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				 struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_MBX_VLAN_STATE_OFFSET	0
 #define HCLGE_MBX_VLAN_INFO_OFFSET	2
@@ -381,9 +365,6 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		proto =  msg_cmd->proto;
 		status = hclge_set_vlan_filter(handle, cpu_to_be16(proto),
 					       vlan, is_kill);
-		if (mbx_req->mbx_need_resp)
-			return hclge_gen_resp_to_vf(vport, mbx_req, status,
-						    NULL, 0);
 	} else if (msg_cmd->subcode == HCLGE_MBX_VLAN_RX_OFF_CFG) {
 		struct hnae3_handle *handle = &vport->nic;
 		bool en = msg_cmd->is_kill ? true : false;
@@ -399,19 +380,15 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		status = hclge_update_port_base_vlan_cfg(vport, *state,
 							 vlan_info);
 	} else if (msg_cmd->subcode == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
-		u8 state;
-
-		state = vport->port_base_vlan_cfg.state;
-		status = hclge_gen_resp_to_vf(vport, mbx_req, 0, &state,
-					      sizeof(u8));
+		resp_msg->data[0] = vport->port_base_vlan_cfg.state;
+		resp_msg->len = sizeof(u8);
 	}
 
 	return status;
 }
 
 static int hclge_set_vf_alive(struct hclge_vport *vport,
-			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-			      bool gen_resp)
+			      struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
 	bool alive = !!mbx_req->msg.data[0];
 	int ret = 0;
@@ -424,73 +401,76 @@ static int hclge_set_vf_alive(struct hclge_vport *vport,
 	return ret;
 }
 
-static int hclge_get_vf_tcinfo(struct hclge_vport *vport,
-			       struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-			       bool gen_resp)
+static void hclge_get_vf_tcinfo(struct hclge_vport *vport,
+				struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
-	u8 vf_tc_map = 0;
 	unsigned int i;
-	int ret;
 
 	for (i = 0; i < kinfo->num_tc; i++)
-		vf_tc_map |= BIT(i);
-
-	ret = hclge_gen_resp_to_vf(vport, mbx_req, 0, &vf_tc_map,
-				   sizeof(vf_tc_map));
+		resp_msg->data[0] |= BIT(i);
 
-	return ret;
+	resp_msg->len = sizeof(u8);
 }
 
-static int hclge_get_vf_queue_info(struct hclge_vport *vport,
-				   struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				   bool gen_resp)
+static void hclge_get_vf_queue_info(struct hclge_vport *vport,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_TQPS_RSS_INFO_LEN		6
-	u8 resp_data[HCLGE_TQPS_RSS_INFO_LEN];
+#define HCLGE_TQPS_ALLOC_OFFSET		0
+#define HCLGE_TQPS_RSS_SIZE_OFFSET	2
+#define HCLGE_TQPS_RX_BUFFER_LEN_OFFSET	4
+
 	struct hclge_dev *hdev = vport->back;
 
 	/* get the queue related info */
-	memcpy(&resp_data[0], &vport->alloc_tqps, sizeof(u16));
-	memcpy(&resp_data[2], &vport->nic.kinfo.rss_size, sizeof(u16));
-	memcpy(&resp_data[4], &hdev->rx_buf_len, sizeof(u16));
-
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
-				    HCLGE_TQPS_RSS_INFO_LEN);
+	memcpy(&resp_msg->data[HCLGE_TQPS_ALLOC_OFFSET],
+	       &vport->alloc_tqps, sizeof(u16));
+	memcpy(&resp_msg->data[HCLGE_TQPS_RSS_SIZE_OFFSET],
+	       &vport->nic.kinfo.rss_size, sizeof(u16));
+	memcpy(&resp_msg->data[HCLGE_TQPS_RX_BUFFER_LEN_OFFSET],
+	       &hdev->rx_buf_len, sizeof(u16));
+	resp_msg->len = HCLGE_TQPS_RSS_INFO_LEN;
 }
 
-static int hclge_get_vf_mac_addr(struct hclge_vport *vport,
-				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static void hclge_get_vf_mac_addr(struct hclge_vport *vport,
+				  struct hclge_respond_to_vf_msg *resp_msg)
 {
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, vport->vf_info.mac,
-				    ETH_ALEN);
+	ether_addr_copy(resp_msg->data, vport->vf_info.mac);
+	resp_msg->len = ETH_ALEN;
 }
 
-static int hclge_get_vf_queue_depth(struct hclge_vport *vport,
-				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				    bool gen_resp)
+static void hclge_get_vf_queue_depth(struct hclge_vport *vport,
+				     struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_TQPS_DEPTH_INFO_LEN	4
-	u8 resp_data[HCLGE_TQPS_DEPTH_INFO_LEN];
+#define HCLGE_TQPS_NUM_TX_DESC_OFFSET	0
+#define HCLGE_TQPS_NUM_RX_DESC_OFFSET	2
+
 	struct hclge_dev *hdev = vport->back;
 
 	/* get the queue depth info */
-	memcpy(&resp_data[0], &hdev->num_tx_desc, sizeof(u16));
-	memcpy(&resp_data[2], &hdev->num_rx_desc, sizeof(u16));
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
-				    HCLGE_TQPS_DEPTH_INFO_LEN);
+	memcpy(&resp_msg->data[HCLGE_TQPS_NUM_TX_DESC_OFFSET],
+	       &hdev->num_tx_desc, sizeof(u16));
+	memcpy(&resp_msg->data[HCLGE_TQPS_NUM_RX_DESC_OFFSET],
+	       &hdev->num_rx_desc, sizeof(u16));
+	resp_msg->len = HCLGE_TQPS_DEPTH_INFO_LEN;
 }
 
-static int hclge_get_vf_media_type(struct hclge_vport *vport,
-				   struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static void hclge_get_vf_media_type(struct hclge_vport *vport,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
+#define HCLGE_VF_MEDIA_TYPE_OFFSET	0
+#define HCLGE_VF_MODULE_TYPE_OFFSET	1
+#define HCLGE_VF_MEDIA_TYPE_LENGTH	2
+
 	struct hclge_dev *hdev = vport->back;
-	u8 resp_data[2];
 
-	resp_data[0] = hdev->hw.mac.media_type;
-	resp_data[1] = hdev->hw.mac.module_type;
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
-				    sizeof(resp_data));
+	resp_msg->data[HCLGE_VF_MEDIA_TYPE_OFFSET] =
+		hdev->hw.mac.media_type;
+	resp_msg->data[HCLGE_VF_MODULE_TYPE_OFFSET] =
+		hdev->hw.mac.module_type;
+	resp_msg->len = HCLGE_VF_MEDIA_TYPE_LENGTH;
 }
 
 static int hclge_get_link_info(struct hclge_vport *vport,
@@ -561,26 +541,19 @@ static void hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
 	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
 
 	hclge_reset_vf_queue(vport, queue_id);
-
-	/* send response msg to VF after queue reset complete */
-	hclge_gen_resp_to_vf(vport, mbx_req, 0, NULL, 0);
 }
 
-static void hclge_reset_vf(struct hclge_vport *vport,
-			   struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static int hclge_reset_vf(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
-	int ret;
 
 	dev_warn(&hdev->pdev->dev, "PF received VF reset request from VF %u!",
 		 vport->vport_id);
 
-	ret = hclge_func_reset_cmd(hdev, vport->vport_id);
-	hclge_gen_resp_to_vf(vport, mbx_req, ret, NULL, 0);
+	return hclge_func_reset_cmd(hdev, vport->vport_id);
 }
 
-static void hclge_vf_keep_alive(struct hclge_vport *vport,
-				struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static void hclge_vf_keep_alive(struct hclge_vport *vport)
 {
 	vport->last_active_jiffies = jiffies;
 }
@@ -588,45 +561,39 @@ static void hclge_vf_keep_alive(struct hclge_vport *vport,
 static int hclge_set_vf_mtu(struct hclge_vport *vport,
 			    struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
-	int ret;
 	u32 mtu;
 
 	memcpy(&mtu, mbx_req->msg.data, sizeof(mtu));
-	ret = hclge_set_vport_mtu(vport, mtu);
 
-	return hclge_gen_resp_to_vf(vport, mbx_req, ret, NULL, 0);
+	return hclge_set_vport_mtu(vport, mtu);
 }
 
-static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
-				    struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
+				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				     struct hclge_respond_to_vf_msg *resp_msg)
 {
 	u16 queue_id, qid_in_pf;
-	u8 resp_data[2];
 
 	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
-	memcpy(resp_data, &qid_in_pf, sizeof(qid_in_pf));
-
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
-				    sizeof(resp_data));
+	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
+	resp_msg->len = sizeof(qid_in_pf);
 }
 
-static int hclge_get_rss_key(struct hclge_vport *vport,
-			     struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static void hclge_get_rss_key(struct hclge_vport *vport,
+			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+			      struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_RSS_MBX_RESP_LEN	8
-	u8 resp_data[HCLGE_RSS_MBX_RESP_LEN];
 	struct hclge_dev *hdev = vport->back;
 	u8 index;
 
 	index = mbx_req->msg.data[0];
 
-	memcpy(&resp_data[0],
+	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
-
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
-				    HCLGE_RSS_MBX_RESP_LEN);
+	resp_msg->len = HCLGE_RSS_MBX_RESP_LEN;
 }
 
 static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
@@ -674,12 +641,14 @@ static void hclge_handle_ncsi_error(struct hclge_dev *hdev)
 void hclge_mbx_handler(struct hclge_dev *hdev)
 {
 	struct hclge_cmq_ring *crq = &hdev->hw.cmq.crq;
+	struct hclge_respond_to_vf_msg resp_msg;
 	struct hclge_mbx_vf_to_pf_cmd *req;
 	struct hclge_vport *vport;
 	struct hclge_desc *desc;
 	unsigned int flag;
-	int ret;
+	int ret = 0;
 
+	memset(&resp_msg, 0, sizeof(resp_msg));
 	/* handle all the mailbox requests in the queue */
 	while (!hclge_cmd_crq_empty(&hdev->hw)) {
 		if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
@@ -729,47 +698,34 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					ret);
 			break;
 		case HCLGE_MBX_SET_MULTICAST:
-			ret = hclge_set_vf_mc_mac_addr(vport, req, false);
+			ret = hclge_set_vf_mc_mac_addr(vport, req);
 			if (ret)
 				dev_err(&hdev->pdev->dev,
 					"PF fail(%d) to set VF MC MAC Addr\n",
 					ret);
 			break;
 		case HCLGE_MBX_SET_VLAN:
-			ret = hclge_set_vf_vlan_cfg(vport, req);
+			ret = hclge_set_vf_vlan_cfg(vport, req, &resp_msg);
 			if (ret)
 				dev_err(&hdev->pdev->dev,
 					"PF failed(%d) to config VF's VLAN\n",
 					ret);
 			break;
 		case HCLGE_MBX_SET_ALIVE:
-			ret = hclge_set_vf_alive(vport, req, false);
+			ret = hclge_set_vf_alive(vport, req);
 			if (ret)
 				dev_err(&hdev->pdev->dev,
 					"PF failed(%d) to set VF's ALIVE\n",
 					ret);
 			break;
 		case HCLGE_MBX_GET_QINFO:
-			ret = hclge_get_vf_queue_info(vport, req, true);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to get Q info for VF\n",
-					ret);
+			hclge_get_vf_queue_info(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_QDEPTH:
-			ret = hclge_get_vf_queue_depth(vport, req, true);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to get Q depth for VF\n",
-					ret);
+			hclge_get_vf_queue_depth(vport, &resp_msg);
 			break;
-
 		case HCLGE_MBX_GET_TCINFO:
-			ret = hclge_get_vf_tcinfo(vport, req, true);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to get TC info for VF\n",
-					ret);
+			hclge_get_vf_tcinfo(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_STATUS:
 			ret = hclge_get_link_info(vport, req);
@@ -782,10 +738,10 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			hclge_mbx_reset_vf_queue(vport, req);
 			break;
 		case HCLGE_MBX_RESET:
-			hclge_reset_vf(vport, req);
+			ret = hclge_reset_vf(vport);
 			break;
 		case HCLGE_MBX_KEEP_ALIVE:
-			hclge_vf_keep_alive(vport, req);
+			hclge_vf_keep_alive(vport);
 			break;
 		case HCLGE_MBX_SET_MTU:
 			ret = hclge_set_vf_mtu(vport, req);
@@ -794,18 +750,10 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"VF fail(%d) to set mtu\n", ret);
 			break;
 		case HCLGE_MBX_GET_QID_IN_PF:
-			ret = hclge_get_queue_id_in_pf(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to get qid for VF\n",
-					ret);
+			hclge_get_queue_id_in_pf(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_RSS_KEY:
-			ret = hclge_get_rss_key(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to get rss key for VF\n",
-					ret);
+			hclge_get_rss_key(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_MODE:
 			hclge_get_link_mode(vport, req);
@@ -819,21 +767,13 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			hclge_rm_vport_all_vlan_table(vport, true);
 			break;
 		case HCLGE_MBX_GET_MEDIA_TYPE:
-			ret = hclge_get_vf_media_type(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to media type for VF\n",
-					ret);
+			hclge_get_vf_media_type(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_PUSH_LINK_STATUS:
 			hclge_handle_link_change_event(hdev, req);
 			break;
 		case HCLGE_MBX_GET_MAC_ADDR:
-			ret = hclge_get_vf_mac_addr(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to get MAC for VF\n",
-					ret);
+			hclge_get_vf_mac_addr(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_NCSI_ERROR:
 			hclge_handle_ncsi_error(hdev);
@@ -844,8 +784,19 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 				req->msg.code);
 			break;
 		}
+
+		/* PF driver should not reply IMP */
+		if (hnae3_get_bit(req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
+		    req->msg.code < HCLGE_MBX_GET_VF_FLR_STATUS) {
+			resp_msg.status = ret;
+			hclge_gen_resp_to_vf(vport, req, &resp_msg);
+		}
+
 		crq->desc[crq->next_to_use].flag = 0;
 		hclge_mbx_ring_ptr_move_crq(crq);
+
+		/* reinitialize ret after complete the mbx message processing */
+		ret = 0;
 	}
 
 	/* Write back CMDQ_RQ header pointer, M7 need this pointer */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 3de2842..9b81549 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -101,8 +101,9 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 	}
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_VF_TO_PF, false);
-	req->mbx_need_resp |= need_resp ? HCLGE_MBX_NEED_RESP_BIT :
-					  ~HCLGE_MBX_NEED_RESP_BIT;
+	if (need_resp)
+		hnae3_set_bit(req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B, 1);
+
 	memcpy(&req->msg, send_msg, sizeof(struct hclge_vf_to_pf_msg));
 
 	/* synchronous send */
-- 
2.7.4

