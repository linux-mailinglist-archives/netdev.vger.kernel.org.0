Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5106E2BA5BB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgKTJQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:28 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8567 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgKTJQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:26 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK0fM6zLqjp;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/5] net: hns3: add support for pf querying new interrupt resources
Date:   Fri, 20 Nov 2020 17:16:21 +0800
Message-ID: <1605863783-36995-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For HNAE3_DEVICE_VERSION_V3, a maximum of 1281 interrupt
resources are supported. To utilize these new resources,
extend the corresponding field or variable to 16bit type,
and remove the restriction of NIC client that only use a
maximum of 65 interrupt vectors. In addition, the I/O address
of the extended interrupt resources are different, so an extra
handler is needed.

Currently, the total number of interrupts is the sum of RoCE's
number and RoCE's offset (RoCE is in front of NIC), since
the number of both NIC and RoCE are same. For readability,
rewrite the corresponding field of the command, rename the
RoCE's offset field as the number of NIC interrupts, then
the total number of interrupts is sum of the number of RoCE
and NIC, and replace vport->back with hdev in
hclge_init_roce_base_info() for simplifying the code.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  16 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 100 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +-
 4 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 999a2aa..632ad42 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3645,8 +3645,6 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 
 static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 {
-#define HNS3_VECTOR_PF_MAX_NUM		64
-
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	struct hnae3_vector_info *vector;
@@ -3659,7 +3657,6 @@ static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 	/* RSS size, cpu online and vector_num should be the same */
 	/* Should consider 2p/4p later */
 	vector_num = min_t(u16, num_online_cpus(), tqp_num);
-	vector_num = min_t(u16, vector_num, HNS3_VECTOR_PF_MAX_NUM);
 
 	vector = devm_kcalloc(&pdev->dev, vector_num, sizeof(*vector),
 			      GFP_KERNEL);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index f458d32..6d7ba20 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -339,7 +339,9 @@ enum hclge_int_type {
 };
 
 struct hclge_ctrl_vector_chain_cmd {
-	u8 int_vector_id;
+#define HCLGE_VECTOR_ID_L_S	0
+#define HCLGE_VECTOR_ID_L_M	GENMASK(7, 0)
+	u8 int_vector_id_l;
 	u8 int_cause_num;
 #define HCLGE_INT_TYPE_S	0
 #define HCLGE_INT_TYPE_M	GENMASK(1, 0)
@@ -349,7 +351,9 @@ struct hclge_ctrl_vector_chain_cmd {
 #define HCLGE_INT_GL_IDX_M	GENMASK(14, 13)
 	__le16 tqp_type_and_id[HCLGE_VECTOR_ELEMENTS_PER_CMD];
 	u8 vfid;
-	u8 rsv;
+#define HCLGE_VECTOR_ID_H_S	8
+#define HCLGE_VECTOR_ID_H_M	GENMASK(15, 8)
+	u8 int_vector_id_h;
 };
 
 #define HCLGE_MAX_TC_NUM		8
@@ -473,12 +477,8 @@ struct hclge_pf_res_cmd {
 	__le16 tqp_num;
 	__le16 buf_size;
 	__le16 msixcap_localid_ba_nic;
-	__le16 msixcap_localid_ba_rocee;
-#define HCLGE_MSIX_OFT_ROCEE_S		0
-#define HCLGE_MSIX_OFT_ROCEE_M		GENMASK(15, 0)
-#define HCLGE_PF_VEC_NUM_S		0
-#define HCLGE_PF_VEC_NUM_M		GENMASK(7, 0)
-	__le16 pf_intr_vector_number;
+	__le16 msixcap_localid_number_nic;
+	__le16 pf_intr_vector_number_roce;
 	__le16 pf_own_fun_number;
 	__le16 tx_buf_size;
 	__le16 dv_buf_size;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9989930..500cc19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -906,35 +906,24 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 
 	hdev->dv_buf_size = roundup(hdev->dv_buf_size, HCLGE_BUF_SIZE_UNIT);
 
+	hdev->num_nic_msi = le16_to_cpu(req->msixcap_localid_number_nic);
+	if (hdev->num_nic_msi < HNAE3_MIN_VECTOR_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"only %u msi resources available, not enough for pf(min:2).\n",
+			hdev->num_nic_msi);
+		return -EINVAL;
+	}
+
 	if (hnae3_dev_roce_supported(hdev)) {
-		hdev->roce_base_msix_offset =
-		hnae3_get_field(le16_to_cpu(req->msixcap_localid_ba_rocee),
-				HCLGE_MSIX_OFT_ROCEE_M, HCLGE_MSIX_OFT_ROCEE_S);
 		hdev->num_roce_msi =
-		hnae3_get_field(le16_to_cpu(req->pf_intr_vector_number),
-				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
-
-		/* nic's msix numbers is always equals to the roce's. */
-		hdev->num_nic_msi = hdev->num_roce_msi;
+			le16_to_cpu(req->pf_intr_vector_number_roce);
 
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
-		hdev->num_msi = hdev->num_roce_msi +
-				hdev->roce_base_msix_offset;
+		hdev->num_msi = hdev->num_nic_msi + hdev->num_roce_msi;
 	} else {
-		hdev->num_msi =
-		hnae3_get_field(le16_to_cpu(req->pf_intr_vector_number),
-				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
-
-		hdev->num_nic_msi = hdev->num_msi;
-	}
-
-	if (hdev->num_nic_msi < HNAE3_MIN_VECTOR_NUM) {
-		dev_err(&hdev->pdev->dev,
-			"Just %u msi resources, not enough for pf(min:2).\n",
-			hdev->num_nic_msi);
-		return -EINVAL;
+		hdev->num_msi = hdev->num_nic_msi;
 	}
 
 	return 0;
@@ -2425,18 +2414,18 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 {
 	struct hnae3_handle *roce = &vport->roce;
 	struct hnae3_handle *nic = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
 
 	roce->rinfo.num_vectors = vport->back->num_roce_msi;
 
-	if (vport->back->num_msi_left < vport->roce.rinfo.num_vectors ||
-	    vport->back->num_msi_left == 0)
+	if (hdev->num_msi < hdev->num_nic_msi + hdev->num_roce_msi)
 		return -EINVAL;
 
-	roce->rinfo.base_vector = vport->back->roce_base_vector;
+	roce->rinfo.base_vector = hdev->roce_base_vector;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
-	roce->rinfo.roce_io_base = vport->back->hw.io_base;
-	roce->rinfo.roce_mem_base = vport->back->hw.mem_base;
+	roce->rinfo.roce_io_base = hdev->hw.io_base;
+	roce->rinfo.roce_mem_base = hdev->hw.mem_base;
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
@@ -2470,7 +2459,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = hdev->base_msi_vector +
-				hdev->roce_base_msix_offset;
+				hdev->num_nic_msi;
 
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
@@ -4143,6 +4132,30 @@ struct hclge_vport *hclge_get_vport(struct hnae3_handle *handle)
 		return container_of(handle, struct hclge_vport, nic);
 }
 
+static void hclge_get_vector_info(struct hclge_dev *hdev, u16 idx,
+				  struct hnae3_vector_info *vector_info)
+{
+#define HCLGE_PF_MAX_VECTOR_NUM_DEV_V2	64
+
+	vector_info->vector = pci_irq_vector(hdev->pdev, idx);
+
+	/* need an extend offset to config vector >= 64 */
+	if (idx - 1 < HCLGE_PF_MAX_VECTOR_NUM_DEV_V2)
+		vector_info->io_addr = hdev->hw.io_base +
+				HCLGE_VECTOR_REG_BASE +
+				(idx - 1) * HCLGE_VECTOR_REG_OFFSET;
+	else
+		vector_info->io_addr = hdev->hw.io_base +
+				HCLGE_VECTOR_EXT_REG_BASE +
+				(idx - 1) / HCLGE_PF_MAX_VECTOR_NUM_DEV_V2 *
+				HCLGE_VECTOR_REG_OFFSET_H +
+				(idx - 1) % HCLGE_PF_MAX_VECTOR_NUM_DEV_V2 *
+				HCLGE_VECTOR_REG_OFFSET;
+
+	hdev->vector_status[idx] = hdev->vport[0].vport_id;
+	hdev->vector_irq[idx] = vector_info->vector;
+}
+
 static int hclge_get_vector(struct hnae3_handle *handle, u16 vector_num,
 			    struct hnae3_vector_info *vector_info)
 {
@@ -4150,23 +4163,16 @@ static int hclge_get_vector(struct hnae3_handle *handle, u16 vector_num,
 	struct hnae3_vector_info *vector = vector_info;
 	struct hclge_dev *hdev = vport->back;
 	int alloc = 0;
-	int i, j;
+	u16 i = 0;
+	u16 j;
 
 	vector_num = min_t(u16, hdev->num_nic_msi - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
-		for (i = 1; i < hdev->num_msi; i++) {
+		while (++i < hdev->num_nic_msi) {
 			if (hdev->vector_status[i] == HCLGE_INVALID_VPORT) {
-				vector->vector = pci_irq_vector(hdev->pdev, i);
-				vector->io_addr = hdev->hw.io_base +
-					HCLGE_VECTOR_REG_BASE +
-					(i - 1) * HCLGE_VECTOR_REG_OFFSET +
-					vport->vport_id *
-					HCLGE_VECTOR_VF_OFFSET;
-				hdev->vector_status[i] = vport->vport_id;
-				hdev->vector_irq[i] = vector->vector;
-
+				hclge_get_vector_info(hdev, i, vector);
 				vector++;
 				alloc++;
 
@@ -4715,7 +4721,12 @@ int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 
 	op = en ? HCLGE_OPC_ADD_RING_TO_VECTOR : HCLGE_OPC_DEL_RING_TO_VECTOR;
 	hclge_cmd_setup_basic_desc(&desc, op, false);
-	req->int_vector_id = vector_id;
+	req->int_vector_id_l = hnae3_get_field(vector_id,
+					       HCLGE_VECTOR_ID_L_M,
+					       HCLGE_VECTOR_ID_L_S);
+	req->int_vector_id_h = hnae3_get_field(vector_id,
+					       HCLGE_VECTOR_ID_H_M,
+					       HCLGE_VECTOR_ID_H_S);
 
 	i = 0;
 	for (node = ring_chain; node; node = node->next) {
@@ -4747,7 +4758,14 @@ int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 			hclge_cmd_setup_basic_desc(&desc,
 						   op,
 						   false);
-			req->int_vector_id = vector_id;
+			req->int_vector_id_l =
+				hnae3_get_field(vector_id,
+						HCLGE_VECTOR_ID_L_M,
+						HCLGE_VECTOR_ID_L_S);
+			req->int_vector_id_h =
+				hnae3_get_field(vector_id,
+						HCLGE_VECTOR_ID_H_M,
+						HCLGE_VECTOR_ID_H_S);
 		}
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3ed4e84..bd17685 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -27,9 +27,11 @@
 	(HCLGE_PF_CFG_BLOCK_SIZE / HCLGE_CFG_RD_LEN_BYTES)
 
 #define HCLGE_VECTOR_REG_BASE		0x20000
+#define HCLGE_VECTOR_EXT_REG_BASE	0x30000
 #define HCLGE_MISC_VECTOR_REG_BASE	0x20400
 
 #define HCLGE_VECTOR_REG_OFFSET		0x4
+#define HCLGE_VECTOR_REG_OFFSET_H	0x1000
 #define HCLGE_VECTOR_VF_OFFSET		0x100000
 
 #define HCLGE_CMDQ_TX_ADDR_L_REG	0x27000
@@ -768,7 +770,6 @@ struct hclge_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
-	u16 roce_base_msix_offset;
 	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
-- 
2.7.4

