Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FDA1DDD67
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgEVCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:51:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726988AbgEVCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 22:51:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B17BD9B878B76DAE3705;
        Fri, 22 May 2020 10:51:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 22 May 2020 10:51:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: add support for VF to query ring and vector mapping
Date:   Fri, 22 May 2020 10:49:42 +0800
Message-ID: <1590115786-9940-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
References: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

This patch adds support for VF to query the mapping of ring and
vector.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 91 ++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 1ffe8fa..40c7087 100644
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
index 0874ae4..561d4a09 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -221,6 +221,89 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 	return ret;
 }
 
+static int hclge_query_ring_vector_map(struct hclge_vport *vport,
+				       struct hnae3_ring_chain_node *ring_chain,
+				       struct hclge_desc *desc)
+{
+	struct hclge_ctrl_vector_chain_cmd *req =
+		(struct hclge_ctrl_vector_chain_cmd *)desc->data;
+	struct hclge_dev *hdev = vport->back;
+	u16 tqp_type_and_id = 0;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(desc, HCLGE_OPC_ADD_RING_TO_VECTOR, true);
+
+	hnae3_set_field(tqp_type_and_id, HCLGE_INT_TYPE_M, HCLGE_INT_TYPE_S,
+			hnae3_get_bit(ring_chain->flag, HNAE3_RING_TYPE_B));
+	hnae3_set_field(tqp_type_and_id, HCLGE_TQP_ID_M, HCLGE_TQP_ID_S,
+			ring_chain->tqp_index);
+	req->tqp_type_and_id[0] = cpu_to_le16(tqp_type_and_id);
+	req->vfid = vport->vport_id;
+
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to query VF ring vector map info, ret = %d.\n",
+			ret);
+
+	return ret;
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
+
+	struct hnae3_ring_chain_node ring_chain;
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_desc desc;
+	struct hclge_ctrl_vector_chain_cmd *data =
+		(struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	u16 tqp_type_and_id;
+	u8 int_gl_index;
+	int ret;
+
+	if (req->msg.param[0].tqp_index >= vport->nic.kinfo.rss_size) {
+		dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
+			req->msg.param[0].tqp_index,
+			vport->nic.kinfo.rss_size - 1);
+		return -EINVAL;
+	}
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
+	resp->data[HCLGE_VECTOR_ID_OFFSET] = data->int_vector_id;
+	resp->len = HCLGE_RING_VECTOR_MAP_INFO_LEN;
+
+	hclge_free_vector_ring_chain(&ring_chain);
+
+	return 0;
+}
+
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *req)
 {
@@ -694,6 +777,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, false,
 								req);
 			break;
+		case HCLGE_MBX_GET_RING_VECTOR_MAP:
+			ret = hclge_get_vf_ring_vector_map(vport, req,
+							   &resp_msg);
+			if (ret)
+				dev_err(&hdev->pdev->dev,
+					"failed to get VF ring vector map, ret = %d\n",
+					ret);
+			break;
 		case HCLGE_MBX_SET_PROMISC_MODE:
 			ret = hclge_set_vf_promisc_mode(vport, req);
 			if (ret)
-- 
2.7.4

