Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7951BFE7
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345610AbiEEMzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377743AbiEEMyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:54:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9622A4C782;
        Thu,  5 May 2022 05:50:31 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KvD6Y1GB5z1JBq6;
        Thu,  5 May 2022 20:49:25 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 5/5] net: hns3: add query vf ring and vector map relation
Date:   Thu, 5 May 2022 20:44:44 +0800
Message-ID: <20220505124444.2233-6-huangguangbin2@huawei.com>
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

This patch adds a new mailbox opcode to query map relation between
vf ring and vector.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 83 +++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 9001a3abc26c..0bff2d834c4b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -46,6 +46,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 	HCLGE_MBX_VF_UNINIT,            /* (VF -> PF) vf is unintializing */
 	HCLGE_MBX_HANDLE_VF_TBL,	/* (VF -> PF) store/clear hw table */
+	HCLGE_MBX_GET_RING_VECTOR_MAP,	/* (VF -> PF) get ring-to-vector map */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 6957b5e158c9..e1012f7f9b73 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -251,6 +251,81 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 	return ret;
 }
 
+static int hclge_query_ring_vector_map(struct hclge_vport *vport,
+				       struct hnae3_ring_chain_node *ring_chain,
+				       struct hclge_desc *desc)
+{
+	struct hclge_ctrl_vector_chain_cmd *req =
+		(struct hclge_ctrl_vector_chain_cmd *)desc->data;
+	struct hclge_dev *hdev = vport->back;
+	u16 tqp_type_and_id;
+	int status;
+
+	hclge_cmd_setup_basic_desc(desc, HCLGE_OPC_ADD_RING_TO_VECTOR, true);
+
+	tqp_type_and_id = le16_to_cpu(req->tqp_type_and_id[0]);
+	hnae3_set_field(tqp_type_and_id, HCLGE_INT_TYPE_M, HCLGE_INT_TYPE_S,
+			hnae3_get_bit(ring_chain->flag, HNAE3_RING_TYPE_B));
+	hnae3_set_field(tqp_type_and_id, HCLGE_TQP_ID_M, HCLGE_TQP_ID_S,
+			ring_chain->tqp_index);
+	req->tqp_type_and_id[0] = cpu_to_le16(tqp_type_and_id);
+	req->vfid = vport->vport_id;
+
+	status = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (status)
+		dev_err(&hdev->pdev->dev,
+			"Get VF ring vector map info fail, status is %d.\n",
+			status);
+
+	return status;
+}
+
+static int hclge_get_vf_ring_vector_map(struct hclge_vport *vport,
+					struct hclge_mbx_vf_to_pf_cmd *req,
+					struct hclge_respond_to_vf_msg *resp)
+{
+#define HCLGE_LIMIT_RING_NUM			1
+#define HCLGE_RING_TYPE_OFFSET			0
+#define HCLGE_TQP_INDEX_OFFSET			1
+#define HCLGE_INT_GL_INDEX_OFFSET		2
+#define HCLGE_VECTOR_ID_OFFSET			3
+#define HCLGE_RING_VECTOR_MAP_INFO_LEN		4
+	struct hnae3_ring_chain_node ring_chain;
+	struct hclge_desc desc;
+	struct hclge_ctrl_vector_chain_cmd *data =
+		(struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	u16 tqp_type_and_id;
+	u8 int_gl_index;
+	int ret;
+
+	req->msg.ring_num = HCLGE_LIMIT_RING_NUM;
+
+	memset(&ring_chain, 0, sizeof(ring_chain));
+	ret = hclge_get_ring_chain_from_mbx(req, &ring_chain, vport);
+	if (ret)
+		return ret;
+
+	ret = hclge_query_ring_vector_map(vport, &ring_chain, &desc);
+	if (ret) {
+		hclge_free_vector_ring_chain(&ring_chain);
+		return ret;
+	}
+
+	tqp_type_and_id = le16_to_cpu(data->tqp_type_and_id[0]);
+	int_gl_index = hnae3_get_field(tqp_type_and_id,
+				       HCLGE_INT_GL_IDX_M, HCLGE_INT_GL_IDX_S);
+
+	resp->data[HCLGE_RING_TYPE_OFFSET] = req->msg.param[0].ring_type;
+	resp->data[HCLGE_TQP_INDEX_OFFSET] = req->msg.param[0].tqp_index;
+	resp->data[HCLGE_INT_GL_INDEX_OFFSET] = int_gl_index;
+	resp->data[HCLGE_VECTOR_ID_OFFSET] = data->int_vector_id_l;
+	resp->len = HCLGE_RING_VECTOR_MAP_INFO_LEN;
+
+	hclge_free_vector_ring_chain(&ring_chain);
+
+	return ret;
+}
+
 static void hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				      struct hclge_mbx_vf_to_pf_cmd *req)
 {
@@ -755,6 +830,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, false,
 								req);
 			break;
+		case HCLGE_MBX_GET_RING_VECTOR_MAP:
+			ret = hclge_get_vf_ring_vector_map(vport, req,
+							   &resp_msg);
+			if (ret)
+				dev_err(&hdev->pdev->dev,
+					"PF fail(%d) to get VF ring vector map\n",
+					ret);
+			break;
 		case HCLGE_MBX_SET_PROMISC_MODE:
 			hclge_set_vf_promisc_mode(vport, req);
 			break;
-- 
2.33.0

