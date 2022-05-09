Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF851F730
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiEIIuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbiEIIld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:41:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580161796D6;
        Mon,  9 May 2022 01:37:38 -0700 (PDT)
Received: from kwepemi500017.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KxYT50F0KzGpgg;
        Mon,  9 May 2022 15:58:33 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500017.china.huawei.com (7.221.188.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 3/6] net: hns3: add byte order conversion for PF to VF mailbox message
Date:   Mon, 9 May 2022 15:55:29 +0800
Message-ID: <20220509075532.32166-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220509075532.32166-1-huangguangbin2@huawei.com>
References: <20220509075532.32166-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, hns3 mailbox processing between PF and VF missed to convert
message byte order and use data type u16 instead of __le16 for mailbox
data process. These processes may cause problems between different
architectures.

So this patch uses __le16/__le32 data type to define mailbox data
structures. To be compatible with old hns3 driver, these structures use
one-byte alignment. Then byte order conversions are added to mailbox
messages from PF to VF.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   | 36 +++++++--
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 60 +++++++-------
 .../hisilicon/hns3/hns3pf/hclge_trace.h       |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  4 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       | 80 +++++++++++--------
 .../hisilicon/hns3/hns3vf/hclgevf_trace.h     |  2 +-
 7 files changed, 109 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 8c7fadf2b734..e1ba0ae055b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -134,13 +134,13 @@ struct hclge_vf_to_pf_msg {
 };
 
 struct hclge_pf_to_vf_msg {
-	u16 code;
+	__le16 code;
 	union {
 		/* used for mbx response */
 		struct {
-			u16 vf_mbx_msg_code;
-			u16 vf_mbx_msg_subcode;
-			u16 resp_status;
+			__le16 vf_mbx_msg_code;
+			__le16 vf_mbx_msg_subcode;
+			__le16 resp_status;
 			u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
 		};
 		/* used for general mbx */
@@ -157,7 +157,7 @@ struct hclge_mbx_vf_to_pf_cmd {
 	u8 rsv1[1];
 	u8 msg_len;
 	u8 rsv2;
-	u16 match_id;
+	__le16 match_id;
 	struct hclge_vf_to_pf_msg msg;
 };
 
@@ -168,7 +168,7 @@ struct hclge_mbx_pf_to_vf_cmd {
 	u8 rsv[3];
 	u8 msg_len;
 	u8 rsv1;
-	u16 match_id;
+	__le16 match_id;
 	struct hclge_pf_to_vf_msg msg;
 };
 
@@ -178,6 +178,28 @@ struct hclge_vf_rst_cmd {
 	u8 rsv[22];
 };
 
+#pragma pack(1)
+struct hclge_mbx_link_status {
+	__le16 link_status;
+	__le32 speed;
+	__le16 duplex;
+	u8 flag;
+};
+
+struct hclge_mbx_link_mode {
+	__le16 idx;
+	__le64 link_mode;
+};
+
+struct hclge_mbx_port_base_vlan {
+	__le16 state;
+	__le16 vlan_proto;
+	__le16 qos;
+	__le16 vlan_tag;
+};
+
+#pragma pack()
+
 /* used by VF to store the received Async responses from PF */
 struct hclgevf_mbx_arq_ring {
 #define HCLGE_MBX_MAX_ARQ_MSG_SIZE	8
@@ -186,7 +208,7 @@ struct hclgevf_mbx_arq_ring {
 	u32 head;
 	u32 tail;
 	atomic_t count;
-	u16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
+	__le16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
 #define hclge_mbx_ring_ptr_move_crq(crq) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 49c40744cda5..d3c4d2c4a5ba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -57,17 +57,19 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 	resp_pf_to_vf->msg_len = vf_to_pf_req->msg_len;
 	resp_pf_to_vf->match_id = vf_to_pf_req->match_id;
 
-	resp_pf_to_vf->msg.code = HCLGE_MBX_PF_VF_RESP;
-	resp_pf_to_vf->msg.vf_mbx_msg_code = vf_to_pf_req->msg.code;
-	resp_pf_to_vf->msg.vf_mbx_msg_subcode = vf_to_pf_req->msg.subcode;
+	resp_pf_to_vf->msg.code = cpu_to_le16(HCLGE_MBX_PF_VF_RESP);
+	resp_pf_to_vf->msg.vf_mbx_msg_code =
+				cpu_to_le16(vf_to_pf_req->msg.code);
+	resp_pf_to_vf->msg.vf_mbx_msg_subcode =
+				cpu_to_le16(vf_to_pf_req->msg.subcode);
 	resp = hclge_errno_to_resp(resp_msg->status);
 	if (resp < SHRT_MAX) {
-		resp_pf_to_vf->msg.resp_status = resp;
+		resp_pf_to_vf->msg.resp_status = cpu_to_le16(resp);
 	} else {
 		dev_warn(&hdev->pdev->dev,
 			 "failed to send response to VF, response status %u is out-of-bound\n",
 			 resp);
-		resp_pf_to_vf->msg.resp_status = EIO;
+		resp_pf_to_vf->msg.resp_status = cpu_to_le16(EIO);
 	}
 
 	if (resp_msg->len > 0)
@@ -107,7 +109,7 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 
 	resp_pf_to_vf->dest_vfid = dest_vfid;
 	resp_pf_to_vf->msg_len = msg_len;
-	resp_pf_to_vf->msg.code = mbx_opcode;
+	resp_pf_to_vf->msg.code = cpu_to_le16(mbx_opcode);
 
 	memcpy(resp_pf_to_vf->msg.msg_data, msg, msg_len);
 
@@ -125,8 +127,8 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
+	__le16 msg_data;
 	u16 reset_type;
-	u8 msg_data[2];
 	u8 dest_vfid;
 
 	BUILD_BUG_ON(HNAE3_MAX_RESET > U16_MAX);
@@ -140,10 +142,10 @@ int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 	else
 		reset_type = HNAE3_VF_FUNC_RESET;
 
-	memcpy(&msg_data[0], &reset_type, sizeof(u16));
+	msg_data = cpu_to_le16(reset_type);
 
 	/* send this requested info to VF */
-	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
+	return hclge_send_mbx_msg(vport, (u8 *)&msg_data, sizeof(msg_data),
 				  HCLGE_MBX_ASSERTING_RESET, dest_vfid);
 }
 
@@ -339,16 +341,14 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 				      u16 state,
 				      struct hclge_vlan_info *vlan_info)
 {
-#define MSG_DATA_SIZE	8
+	struct hclge_mbx_port_base_vlan base_vlan;
 
-	u8 msg_data[MSG_DATA_SIZE];
+	base_vlan.state = cpu_to_le16(state);
+	base_vlan.vlan_proto = cpu_to_le16(vlan_info->vlan_proto);
+	base_vlan.qos = cpu_to_le16(vlan_info->qos);
+	base_vlan.vlan_tag = cpu_to_le16(vlan_info->vlan_tag);
 
-	memcpy(&msg_data[0], &state, sizeof(u16));
-	memcpy(&msg_data[2], &vlan_info->vlan_proto, sizeof(u16));
-	memcpy(&msg_data[4], &vlan_info->qos, sizeof(u16));
-	memcpy(&msg_data[6], &vlan_info->vlan_tag, sizeof(u16));
-
-	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
+	return hclge_send_mbx_msg(vport, (u8 *)&base_vlan, sizeof(base_vlan),
 				  HCLGE_MBX_PUSH_VLAN_INFO, vfid);
 }
 
@@ -488,10 +488,9 @@ int hclge_push_vf_link_status(struct hclge_vport *vport)
 #define HCLGE_VF_LINK_STATE_UP		1U
 #define HCLGE_VF_LINK_STATE_DOWN	0U
 
+	struct hclge_mbx_link_status link_info;
 	struct hclge_dev *hdev = vport->back;
 	u16 link_status;
-	u8 msg_data[9];
-	u16 duplex;
 
 	/* mac.link can only be 0 or 1 */
 	switch (vport->vf_info.link_state) {
@@ -507,14 +506,13 @@ int hclge_push_vf_link_status(struct hclge_vport *vport)
 		break;
 	}
 
-	duplex = hdev->hw.mac.duplex;
-	memcpy(&msg_data[0], &link_status, sizeof(u16));
-	memcpy(&msg_data[2], &hdev->hw.mac.speed, sizeof(u32));
-	memcpy(&msg_data[6], &duplex, sizeof(u16));
-	msg_data[8] = HCLGE_MBX_PUSH_LINK_STATUS_EN;
+	link_info.link_status = cpu_to_le16(link_status);
+	link_info.speed = cpu_to_le32(hdev->hw.mac.speed);
+	link_info.duplex = cpu_to_le16(hdev->hw.mac.duplex);
+	link_info.flag = HCLGE_MBX_PUSH_LINK_STATUS_EN;
 
 	/* send this requested info to VF */
-	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
+	return hclge_send_mbx_msg(vport, (u8 *)&link_info, sizeof(link_info),
 				  HCLGE_MBX_LINK_STAT_CHANGE, vport->vport_id);
 }
 
@@ -522,22 +520,22 @@ static void hclge_get_link_mode(struct hclge_vport *vport,
 				struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
 #define HCLGE_SUPPORTED   1
+	struct hclge_mbx_link_mode link_mode;
 	struct hclge_dev *hdev = vport->back;
 	unsigned long advertising;
 	unsigned long supported;
 	unsigned long send_data;
-	u8 msg_data[10] = {};
 	u8 dest_vfid;
 
 	advertising = hdev->hw.mac.advertising[0];
 	supported = hdev->hw.mac.supported[0];
 	dest_vfid = mbx_req->mbx_src_vfid;
-	msg_data[0] = mbx_req->msg.data[0];
-
-	send_data = msg_data[0] == HCLGE_SUPPORTED ? supported : advertising;
+	send_data = mbx_req->msg.data[0] == HCLGE_SUPPORTED ? supported :
+							      advertising;
+	link_mode.idx = cpu_to_le16((u16)mbx_req->msg.data[0]);
+	link_mode.link_mode = cpu_to_le64(send_data);
 
-	memcpy(&msg_data[2], &send_data, sizeof(unsigned long));
-	hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
+	hclge_send_mbx_msg(vport, (u8 *)&link_mode, sizeof(link_mode),
 			   HCLGE_MBX_LINK_STAT_MODE, dest_vfid);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
index 5b0b71bd6120..8510b88d4982 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
@@ -62,7 +62,7 @@ TRACE_EVENT(hclge_pf_mbx_send,
 
 	TP_fast_assign(
 		__entry->vfid = req->dest_vfid;
-		__entry->code = req->msg.code;
+		__entry->code = le16_to_cpu(req->msg.code);
 		__assign_str(pciname, pci_name(hdev->pdev));
 		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e13d71abd9f7..38a26797c9d4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3333,7 +3333,7 @@ static void hclgevf_get_regs(struct hnae3_handle *handle, u32 *version,
 }
 
 void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
-					u8 *port_base_vlan_info, u8 data_size)
+				struct hclge_mbx_port_base_vlan *port_base_vlan)
 {
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hclge_vf_to_pf_msg send_msg;
@@ -3358,7 +3358,7 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 	/* send msg to PF and wait update port based vlan info */
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
 			       HCLGE_MBX_PORT_BASE_VLAN_CFG);
-	memcpy(send_msg.data, port_base_vlan_info, data_size);
+	memcpy(send_msg.data, port_base_vlan, sizeof(*port_base_vlan));
 	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 	if (!ret) {
 		if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 4b00fd44f118..59ca6c794d6d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -293,5 +293,5 @@ void hclgevf_update_speed_duplex(struct hclgevf_dev *hdev, u32 speed,
 void hclgevf_reset_task_schedule(struct hclgevf_dev *hdev);
 void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev);
 void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
-					u8 *port_base_vlan_info, u8 data_size);
+			struct hclge_mbx_port_base_vlan *port_base_vlan);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index c8055d69255c..bbf7b14079de 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -124,7 +124,7 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 	if (need_resp) {
 		mutex_lock(&hdev->mbx_resp.mbx_mutex);
 		hclgevf_reset_mbx_resp_status(hdev);
-		req->match_id = hdev->mbx_resp.match_id;
+		req->match_id = cpu_to_le16(hdev->mbx_resp.match_id);
 		status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 		if (status) {
 			dev_err(&hdev->pdev->dev,
@@ -162,27 +162,29 @@ static bool hclgevf_cmd_crq_empty(struct hclgevf_hw *hw)
 static void hclgevf_handle_mbx_response(struct hclgevf_dev *hdev,
 					struct hclge_mbx_pf_to_vf_cmd *req)
 {
+	u16 vf_mbx_msg_subcode = le16_to_cpu(req->msg.vf_mbx_msg_subcode);
+	u16 vf_mbx_msg_code = le16_to_cpu(req->msg.vf_mbx_msg_code);
 	struct hclgevf_mbx_resp_status *resp = &hdev->mbx_resp;
+	u16 resp_status = le16_to_cpu(req->msg.resp_status);
+	u16 match_id = le16_to_cpu(req->match_id);
 
 	if (resp->received_resp)
 		dev_warn(&hdev->pdev->dev,
-			 "VF mbx resp flag not clear(%u)\n",
-			 req->msg.vf_mbx_msg_code);
-
-	resp->origin_mbx_msg =
-			(req->msg.vf_mbx_msg_code << 16);
-	resp->origin_mbx_msg |= req->msg.vf_mbx_msg_subcode;
-	resp->resp_status =
-		hclgevf_resp_to_errno(req->msg.resp_status);
+			"VF mbx resp flag not clear(%u)\n",
+			 vf_mbx_msg_code);
+
+	resp->origin_mbx_msg = (vf_mbx_msg_code << 16);
+	resp->origin_mbx_msg |= vf_mbx_msg_subcode;
+	resp->resp_status = hclgevf_resp_to_errno(resp_status);
 	memcpy(resp->additional_info, req->msg.resp_data,
 	       HCLGE_MBX_MAX_RESP_DATA_SIZE * sizeof(u8));
-	if (req->match_id) {
+	if (match_id) {
 		/* If match_id is not zero, it means PF support match_id.
 		 * if the match_id is right, VF get the right response, or
 		 * ignore the response. and driver will clear hdev->mbx_resp
 		 * when send next message which need response.
 		 */
-		if (req->match_id == resp->match_id)
+		if (match_id == resp->match_id)
 			resp->received_resp = true;
 	} else {
 		resp->received_resp = true;
@@ -199,7 +201,7 @@ static void hclgevf_handle_mbx_msg(struct hclgevf_dev *hdev,
 	    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
 		dev_warn(&hdev->pdev->dev,
 			 "Async Q full, dropping msg(%u)\n",
-			 req->msg.code);
+			 le16_to_cpu(req->msg.code));
 		return;
 	}
 
@@ -218,6 +220,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 	struct hclge_comm_cmq_ring *crq;
 	struct hclge_desc *desc;
 	u16 flag;
+	u16 code;
 
 	crq = &hdev->hw.hw.cmq.crq;
 
@@ -232,10 +235,11 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		req = (struct hclge_mbx_pf_to_vf_cmd *)desc->data;
 
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
+		code = le16_to_cpu(req->msg.code);
 		if (unlikely(!hnae3_get_bit(flag, HCLGEVF_CMDQ_RX_OUTVLD_B))) {
 			dev_warn(&hdev->pdev->dev,
 				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg.code);
+				 code);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
@@ -251,7 +255,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		 * timeout and simultaneously queue the async messages for later
 		 * prcessing in context of mailbox task i.e. the slow path.
 		 */
-		switch (req->msg.code) {
+		switch (code) {
 		case HCLGE_MBX_PF_VF_RESP:
 			hclgevf_handle_mbx_response(hdev, req);
 			break;
@@ -265,7 +269,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		default:
 			dev_err(&hdev->pdev->dev,
 				"VF received unsupported(%u) mbx msg from PF\n",
-				req->msg.code);
+				code);
 			break;
 		}
 		crq->desc[crq->next_to_use].flag = 0;
@@ -287,14 +291,18 @@ static void hclgevf_parse_promisc_info(struct hclgevf_dev *hdev,
 
 void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 {
+	struct hclge_mbx_port_base_vlan *vlan_info;
+	struct hclge_mbx_link_status *link_info;
+	struct hclge_mbx_link_mode *link_mode;
 	enum hnae3_reset_type reset_type;
 	u16 link_status, state;
-	u16 *msg_q, *vlan_info;
+	__le16 *msg_q;
+	u16 opcode;
 	u8 duplex;
 	u32 speed;
 	u32 tail;
 	u8 flag;
-	u8 idx;
+	u16 idx;
 
 	tail = hdev->arq.tail;
 
@@ -308,13 +316,14 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 		}
 
 		msg_q = hdev->arq.msg_q[hdev->arq.head];
-
-		switch (msg_q[0]) {
+		opcode = le16_to_cpu(msg_q[0]);
+		switch (opcode) {
 		case HCLGE_MBX_LINK_STAT_CHANGE:
-			link_status = msg_q[1];
-			memcpy(&speed, &msg_q[2], sizeof(speed));
-			duplex = (u8)msg_q[4];
-			flag = (u8)msg_q[5];
+			link_info = (struct hclge_mbx_link_status *)(msg_q + 1);
+			link_status = le16_to_cpu(link_info->link_status);
+			speed = le32_to_cpu(link_info->speed);
+			duplex = (u8)le16_to_cpu(link_info->duplex);
+			flag = link_info->flag;
 
 			/* update upper layer with new link link status */
 			hclgevf_update_speed_duplex(hdev, speed, duplex);
@@ -326,13 +335,14 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 
 			break;
 		case HCLGE_MBX_LINK_STAT_MODE:
-			idx = (u8)msg_q[1];
+			link_mode = (struct hclge_mbx_link_mode *)(msg_q + 1);
+			idx = le16_to_cpu(link_mode->idx);
 			if (idx)
-				memcpy(&hdev->hw.mac.supported, &msg_q[2],
-				       sizeof(unsigned long));
+				hdev->hw.mac.supported =
+					le64_to_cpu(link_mode->link_mode);
 			else
-				memcpy(&hdev->hw.mac.advertising, &msg_q[2],
-				       sizeof(unsigned long));
+				hdev->hw.mac.advertising =
+					le64_to_cpu(link_mode->link_mode);
 			break;
 		case HCLGE_MBX_ASSERTING_RESET:
 			/* PF has asserted reset hence VF should go in pending
@@ -340,25 +350,27 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			 * has been completely reset. After this stack should
 			 * eventually be re-initialized.
 			 */
-			reset_type = (enum hnae3_reset_type)msg_q[1];
+			reset_type =
+				(enum hnae3_reset_type)le16_to_cpu(msg_q[1]);
 			set_bit(reset_type, &hdev->reset_pending);
 			set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 			hclgevf_reset_task_schedule(hdev);
 
 			break;
 		case HCLGE_MBX_PUSH_VLAN_INFO:
-			state = msg_q[1];
-			vlan_info = &msg_q[1];
+			vlan_info =
+				(struct hclge_mbx_port_base_vlan *)(msg_q + 1);
+			state = le16_to_cpu(vlan_info->state);
 			hclgevf_update_port_base_vlan_info(hdev, state,
-							   (u8 *)vlan_info, 8);
+							   vlan_info);
 			break;
 		case HCLGE_MBX_PUSH_PROMISC_INFO:
-			hclgevf_parse_promisc_info(hdev, msg_q[1]);
+			hclgevf_parse_promisc_info(hdev, le16_to_cpu(msg_q[1]));
 			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"fetched unsupported(%u) message from arq\n",
-				msg_q[0]);
+				opcode);
 			break;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
index e4bfb6191fef..5d4895bb57a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
@@ -29,7 +29,7 @@ TRACE_EVENT(hclge_vf_mbx_get,
 
 	TP_fast_assign(
 		__entry->vfid = req->dest_vfid;
-		__entry->code = req->msg.code;
+		__entry->code = le16_to_cpu(req->msg.code);
 		__assign_str(pciname, pci_name(hdev->pdev));
 		__assign_str(devname, &hdev->nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
-- 
2.33.0

