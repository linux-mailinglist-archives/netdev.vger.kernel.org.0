Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846851BFEE
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378093AbiEEMzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377741AbiEEMyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:54:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961983B3EB;
        Thu,  5 May 2022 05:50:31 -0700 (PDT)
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KvD7B6zQ5zhYm3;
        Thu,  5 May 2022 20:49:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 4/5] net: hns3: add byte order conversion for VF to PF mailbox message
Date:   Thu, 5 May 2022 20:44:43 +0800
Message-ID: <20220505124444.2233-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220505124444.2233-1-huangguangbin2@huawei.com>
References: <20220505124444.2233-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

This patch uses __le16/__32 to define mailbox data structures. Then byte
order conversion are added for mailbox messages from VF to PF.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   | 25 ++++++++-
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 50 ++++++++---------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 54 +++++++++----------
 3 files changed, 73 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index b29474f13b23..9001a3abc26c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -92,8 +92,8 @@ struct hclge_ring_chain_param {
 struct hclge_basic_info {
 	u8 hw_tc_map;
 	u8 rsv;
-	u16 mbx_api_version;
-	u32 pf_caps;
+	__le16 mbx_api_version;
+	__le32 pf_caps;
 };
 
 struct hclgevf_mbx_resp_status {
@@ -198,6 +198,27 @@ struct hclge_mbx_port_base_vlan {
 	__le16 vlan_tag;
 };
 
+struct hclge_mbx_vf_queue_info {
+	__le16 num_tqps;
+	__le16 rss_size;
+	__le16 rx_buf_len;
+};
+
+struct hclge_mbx_vf_queue_depth {
+	__le16 num_tx_desc;
+	__le16 num_rx_desc;
+};
+
+struct hclge_mbx_vlan_filter {
+	u8 is_kill;
+	__le16 vlan_id;
+	__le16 proto;
+};
+
+struct hclge_mbx_mtu_info {
+	__le32 mtu;
+};
+
 #pragma pack()
 
 /* used by VF to store the received Async responses from PF */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index d3c4d2c4a5ba..6957b5e158c9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -362,13 +362,16 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_vf_vlan_cfg *msg_cmd;
+	__be16 proto;
+	u16 vlan_id;
 
 	msg_cmd = (struct hclge_vf_vlan_cfg *)&mbx_req->msg;
 	switch (msg_cmd->subcode) {
 	case HCLGE_MBX_VLAN_FILTER:
-		return hclge_set_vlan_filter(handle,
-					     cpu_to_be16(msg_cmd->proto),
-					     msg_cmd->vlan, msg_cmd->is_kill);
+		proto = cpu_to_be16(le16_to_cpu(msg_cmd->proto));
+		vlan_id = le16_to_cpu(msg_cmd->vlan);
+		return hclge_set_vlan_filter(handle, proto, vlan_id,
+					     msg_cmd->is_kill);
 	case HCLGE_MBX_VLAN_RX_OFF_CFG:
 		return hclge_en_hw_strip_rxvtag(handle, msg_cmd->enable);
 	case HCLGE_MBX_GET_PORT_BASE_VLAN_STATE:
@@ -411,15 +414,17 @@ static void hclge_get_basic_info(struct hclge_vport *vport,
 	struct hnae3_ae_dev *ae_dev = vport->back->ae_dev;
 	struct hclge_basic_info *basic_info;
 	unsigned int i;
+	u32 pf_caps;
 
 	basic_info = (struct hclge_basic_info *)resp_msg->data;
 	for (i = 0; i < kinfo->tc_info.num_tc; i++)
 		basic_info->hw_tc_map |= BIT(i);
 
+	pf_caps = le32_to_cpu(basic_info->pf_caps);
 	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		hnae3_set_bit(basic_info->pf_caps,
-			      HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B, 1);
+		hnae3_set_bit(pf_caps, HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B, 1);
 
+	basic_info->pf_caps = cpu_to_le32(pf_caps);
 	resp_msg->len = HCLGE_MBX_MAX_RESP_DATA_SIZE;
 }
 
@@ -427,19 +432,15 @@ static void hclge_get_vf_queue_info(struct hclge_vport *vport,
 				    struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_TQPS_RSS_INFO_LEN		6
-#define HCLGE_TQPS_ALLOC_OFFSET		0
-#define HCLGE_TQPS_RSS_SIZE_OFFSET	2
-#define HCLGE_TQPS_RX_BUFFER_LEN_OFFSET	4
 
+	struct hclge_mbx_vf_queue_info *queue_info;
 	struct hclge_dev *hdev = vport->back;
 
 	/* get the queue related info */
-	memcpy(&resp_msg->data[HCLGE_TQPS_ALLOC_OFFSET],
-	       &vport->alloc_tqps, sizeof(u16));
-	memcpy(&resp_msg->data[HCLGE_TQPS_RSS_SIZE_OFFSET],
-	       &vport->nic.kinfo.rss_size, sizeof(u16));
-	memcpy(&resp_msg->data[HCLGE_TQPS_RX_BUFFER_LEN_OFFSET],
-	       &hdev->rx_buf_len, sizeof(u16));
+	queue_info = (struct hclge_mbx_vf_queue_info *)resp_msg->data;
+	queue_info->num_tqps = cpu_to_le16(vport->alloc_tqps);
+	queue_info->rss_size = cpu_to_le16(vport->nic.kinfo.rss_size);
+	queue_info->rx_buf_len = cpu_to_le16(hdev->rx_buf_len);
 	resp_msg->len = HCLGE_TQPS_RSS_INFO_LEN;
 }
 
@@ -454,16 +455,15 @@ static void hclge_get_vf_queue_depth(struct hclge_vport *vport,
 				     struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_TQPS_DEPTH_INFO_LEN	4
-#define HCLGE_TQPS_NUM_TX_DESC_OFFSET	0
-#define HCLGE_TQPS_NUM_RX_DESC_OFFSET	2
 
+	struct hclge_mbx_vf_queue_depth *queue_depth;
 	struct hclge_dev *hdev = vport->back;
 
 	/* get the queue depth info */
-	memcpy(&resp_msg->data[HCLGE_TQPS_NUM_TX_DESC_OFFSET],
-	       &hdev->num_tx_desc, sizeof(u16));
-	memcpy(&resp_msg->data[HCLGE_TQPS_NUM_RX_DESC_OFFSET],
-	       &hdev->num_rx_desc, sizeof(u16));
+	queue_depth = (struct hclge_mbx_vf_queue_depth *)resp_msg->data;
+	queue_depth->num_tx_desc = cpu_to_le16(hdev->num_tx_desc);
+	queue_depth->num_rx_desc = cpu_to_le16(hdev->num_rx_desc);
+
 	resp_msg->len = HCLGE_TQPS_DEPTH_INFO_LEN;
 }
 
@@ -549,7 +549,7 @@ static int hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
 	u16 queue_id;
 	int ret;
 
-	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
+	queue_id = le16_to_cpu(*(__le16 *)mbx_req->msg.data);
 	resp_msg->data[0] = HCLGE_RESET_ALL_QUEUE_DONE;
 	resp_msg->len = sizeof(u8);
 
@@ -585,9 +585,11 @@ static void hclge_vf_keep_alive(struct hclge_vport *vport)
 static int hclge_set_vf_mtu(struct hclge_vport *vport,
 			    struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
+	struct hclge_mbx_mtu_info *mtu_info;
 	u32 mtu;
 
-	memcpy(&mtu, mbx_req->msg.data, sizeof(mtu));
+	mtu_info = (struct hclge_mbx_mtu_info *)mbx_req->msg.data;
+	mtu = le32_to_cpu(mtu_info->mtu);
 
 	return hclge_set_vport_mtu(vport, mtu);
 }
@@ -600,7 +602,7 @@ static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	u16 queue_id, qid_in_pf;
 
-	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
+	queue_id = le16_to_cpu(*(__le16 *)mbx_req->msg.data);
 	if (queue_id >= handle->kinfo.num_tqps) {
 		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
 			queue_id, mbx_req->mbx_src_vfid);
@@ -608,7 +610,7 @@ static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	}
 
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
-	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
+	*(__le16 *)resp_msg->data = cpu_to_le16(qid_in_pf);
 	resp_msg->len = sizeof(qid_in_pf);
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 38a26797c9d4..5eaf09ea4009 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -189,8 +189,8 @@ static int hclgevf_get_basic_info(struct hclgevf_dev *hdev)
 	basic_info = (struct hclge_basic_info *)resp_msg;
 
 	hdev->hw_tc_map = basic_info->hw_tc_map;
-	hdev->mbx_api_version = basic_info->mbx_api_version;
-	caps = basic_info->pf_caps;
+	hdev->mbx_api_version = le16_to_cpu(basic_info->mbx_api_version);
+	caps = le32_to_cpu(basic_info->pf_caps);
 	if (test_bit(HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B, &caps))
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
@@ -223,10 +223,8 @@ static int hclgevf_get_port_base_vlan_filter_state(struct hclgevf_dev *hdev)
 static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_TQPS_RSS_INFO_LEN	6
-#define HCLGEVF_TQPS_ALLOC_OFFSET	0
-#define HCLGEVF_TQPS_RSS_SIZE_OFFSET	2
-#define HCLGEVF_TQPS_RX_BUFFER_LEN_OFFSET	4
 
+	struct hclge_mbx_vf_queue_info *queue_info;
 	u8 resp_msg[HCLGEVF_TQPS_RSS_INFO_LEN];
 	struct hclge_vf_to_pf_msg send_msg;
 	int status;
@@ -241,12 +239,10 @@ static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 		return status;
 	}
 
-	memcpy(&hdev->num_tqps, &resp_msg[HCLGEVF_TQPS_ALLOC_OFFSET],
-	       sizeof(u16));
-	memcpy(&hdev->rss_size_max, &resp_msg[HCLGEVF_TQPS_RSS_SIZE_OFFSET],
-	       sizeof(u16));
-	memcpy(&hdev->rx_buf_len, &resp_msg[HCLGEVF_TQPS_RX_BUFFER_LEN_OFFSET],
-	       sizeof(u16));
+	queue_info = (struct hclge_mbx_vf_queue_info *)resp_msg;
+	hdev->num_tqps = le16_to_cpu(queue_info->num_tqps);
+	hdev->rss_size_max = le16_to_cpu(queue_info->rss_size);
+	hdev->rx_buf_len = le16_to_cpu(queue_info->rx_buf_len);
 
 	return 0;
 }
@@ -254,9 +250,8 @@ static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 static int hclgevf_get_queue_depth(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_TQPS_DEPTH_INFO_LEN	4
-#define HCLGEVF_TQPS_NUM_TX_DESC_OFFSET	0
-#define HCLGEVF_TQPS_NUM_RX_DESC_OFFSET	2
 
+	struct hclge_mbx_vf_queue_depth *queue_depth;
 	u8 resp_msg[HCLGEVF_TQPS_DEPTH_INFO_LEN];
 	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
@@ -271,10 +266,9 @@ static int hclgevf_get_queue_depth(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
-	memcpy(&hdev->num_tx_desc, &resp_msg[HCLGEVF_TQPS_NUM_TX_DESC_OFFSET],
-	       sizeof(u16));
-	memcpy(&hdev->num_rx_desc, &resp_msg[HCLGEVF_TQPS_NUM_RX_DESC_OFFSET],
-	       sizeof(u16));
+	queue_depth = (struct hclge_mbx_vf_queue_depth *)resp_msg;
+	hdev->num_tx_desc = le16_to_cpu(queue_depth->num_tx_desc);
+	hdev->num_rx_desc = le16_to_cpu(queue_depth->num_rx_desc);
 
 	return 0;
 }
@@ -288,11 +282,11 @@ static u16 hclgevf_get_qid_global(struct hnae3_handle *handle, u16 queue_id)
 	int ret;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_QID_IN_PF, 0);
-	memcpy(send_msg.data, &queue_id, sizeof(queue_id));
+	*(__le16 *)send_msg.data = cpu_to_le16(queue_id);
 	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_data,
 				   sizeof(resp_data));
 	if (!ret)
-		qid_in_pf = *(u16 *)resp_data;
+		qid_in_pf = le16_to_cpu(*(__le16 *)resp_data);
 
 	return qid_in_pf;
 }
@@ -1245,11 +1239,8 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 				   __be16 proto, u16 vlan_id,
 				   bool is_kill)
 {
-#define HCLGEVF_VLAN_MBX_IS_KILL_OFFSET	0
-#define HCLGEVF_VLAN_MBX_VLAN_ID_OFFSET	1
-#define HCLGEVF_VLAN_MBX_PROTO_OFFSET	3
-
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_mbx_vlan_filter *vlan_filter;
 	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
@@ -1271,11 +1262,11 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
 			       HCLGE_MBX_VLAN_FILTER);
-	send_msg.data[HCLGEVF_VLAN_MBX_IS_KILL_OFFSET] = is_kill;
-	memcpy(&send_msg.data[HCLGEVF_VLAN_MBX_VLAN_ID_OFFSET], &vlan_id,
-	       sizeof(vlan_id));
-	memcpy(&send_msg.data[HCLGEVF_VLAN_MBX_PROTO_OFFSET], &proto,
-	       sizeof(proto));
+	vlan_filter = (struct hclge_mbx_vlan_filter *)send_msg.data;
+	vlan_filter->is_kill = is_kill;
+	vlan_filter->vlan_id = cpu_to_le16(vlan_id);
+	vlan_filter->proto = cpu_to_le16(be16_to_cpu(proto));
+
 	/* when remove hw vlan filter failed, record the vlan id,
 	 * and try to remove it from hw later, to be consistence
 	 * with stack.
@@ -1347,7 +1338,7 @@ static int hclgevf_reset_tqp(struct hnae3_handle *handle)
 
 	for (i = 1; i < handle->kinfo.num_tqps; i++) {
 		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_QUEUE_RESET, 0);
-		memcpy(send_msg.data, &i, sizeof(i));
+		*(__le16 *)send_msg.data = cpu_to_le16(i);
 		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 		if (ret)
 			return ret;
@@ -1359,10 +1350,13 @@ static int hclgevf_reset_tqp(struct hnae3_handle *handle)
 static int hclgevf_set_mtu(struct hnae3_handle *handle, int new_mtu)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_mbx_mtu_info *mtu_info;
 	struct hclge_vf_to_pf_msg send_msg;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MTU, 0);
-	memcpy(send_msg.data, &new_mtu, sizeof(new_mtu));
+	mtu_info = (struct hclge_mbx_mtu_info *)send_msg.data;
+	mtu_info->mtu = cpu_to_le32(new_mtu);
+
 	return hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 }
 
-- 
2.33.0

