Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3939D893E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733243AbfJPHUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4173 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730643AbfJPHUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:13 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8F88C004DD3111DC3E9;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:19:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: fix mis-counting IRQ vector numbers issue
Date:   Wed, 16 Oct 2019 15:17:03 +0800
Message-ID: <1571210231-29154-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Currently, the num_msi_left means the vector numbers of NIC,
but if the PF supported RoCE, it contains the vector numbers
of NIC and RoCE(Not expected).

This may cause interrupts lost in some case, because of the
NIC module used the vector resources which belongs to RoCE.

This patch adds a new variable num_nic_msi to store the vector
numbers of NIC, and adjust the default TQP numbers and rss_size
according to the value of num_nic_msi.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 21 +++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 11 +++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 28 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 6 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index c15d7fc..c99632d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -32,6 +32,8 @@
 
 #define HNAE3_MOD_VERSION "1.0"
 
+#define HNAE3_MIN_VECTOR_NUM	2 /* one for msi-x, another for IO */
+
 /* Device IDs */
 #define HNAE3_DEV_ID_GE				0xA220
 #define HNAE3_DEV_ID_25GE			0xA221
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8a3a4fd..2f0386d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -908,6 +908,9 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msi = hdev->num_roce_msi;
+
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
@@ -917,6 +920,15 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 		hdev->num_msi =
 		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
+
+		hdev->num_nic_msi = hdev->num_msi;
+	}
+
+	if (hdev->num_nic_msi < HNAE3_MIN_VECTOR_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"Just %u msi resources, not enough for pf(min:2).\n",
+			hdev->num_nic_msi);
+		return -EINVAL;
 	}
 
 	return 0;
@@ -1540,6 +1552,10 @@ static int  hclge_assign_tqp(struct hclge_vport *vport, u16 num_tqps)
 	kinfo->rss_size = min_t(u16, hdev->rss_size_max,
 				vport->alloc_tqps / hdev->tm_info.num_tc);
 
+	/* ensure one to one mapping between irq and queue at default */
+	kinfo->rss_size = min_t(u16, kinfo->rss_size,
+				(hdev->num_nic_msi - 1) / hdev->tm_info.num_tc);
+
 	return 0;
 }
 
@@ -2319,7 +2335,8 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	int vectors;
 	int i;
 
-	vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+	vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
+					hdev->num_msi,
 					PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
@@ -2334,6 +2351,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = hdev->base_msi_vector +
 				hdev->roce_base_msix_offset;
@@ -3993,6 +4011,7 @@ static int hclge_get_vector(struct hnae3_handle *handle, u16 vector_num,
 	int alloc = 0;
 	int i, j;
 
+	vector_num = min_t(u16, hdev->num_nic_msi - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3153a96..9e59f0e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -764,6 +764,7 @@ struct hclge_dev {
 	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
+	u16 num_nic_msi;	/* Num of nic vectors for this PF */
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
 	int roce_base_vector;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 0934954..b3c30e5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -580,9 +580,16 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 		kinfo->rss_size = kinfo->req_rss_size;
 	} else if (kinfo->rss_size > max_rss_size ||
 		   (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size)) {
+		/* if user not set rss, the rss_size should compare with the
+		 * valid msi numbers to ensure one to one map between tqp and
+		 * irq as default.
+		 */
+		if (!kinfo->req_rss_size)
+			max_rss_size = min_t(u16, max_rss_size,
+					     (hdev->num_nic_msi - 1) /
+					     kinfo->num_tc);
+
 		/* Set to the maximum specification value (max_rss_size). */
-		dev_info(&hdev->pdev->dev, "rss changes from %d to %d\n",
-			 kinfo->rss_size, max_rss_size);
 		kinfo->rss_size = max_rss_size;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 9c8fd97..408e386 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -411,6 +411,13 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 		kinfo->tqp[i] = &hdev->htqp[i].q;
 	}
 
+	/* after init the max rss_size and tqps, adjust the default tqp numbers
+	 * and rss size with the actual vector numbers
+	 */
+	kinfo->num_tqps = min_t(u16, hdev->num_nic_msix - 1, kinfo->num_tqps);
+	kinfo->rss_size = min_t(u16, kinfo->num_tqps / kinfo->num_tc,
+				kinfo->rss_size);
+
 	return 0;
 }
 
@@ -502,6 +509,7 @@ static int hclgevf_get_vector(struct hnae3_handle *handle, u16 vector_num,
 	int alloc = 0;
 	int i, j;
 
+	vector_num = min_t(u16, hdev->num_nic_msix - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
@@ -2282,13 +2290,14 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	int vectors;
 	int i;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B))
+	if (hnae3_dev_roce_supported(hdev))
 		vectors = pci_alloc_irq_vectors(pdev,
 						hdev->roce_base_msix_offset + 1,
 						hdev->num_msi,
 						PCI_IRQ_MSIX);
 	else
-		vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+		vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
+						hdev->num_msi,
 						PCI_IRQ_MSI | PCI_IRQ_MSIX);
 
 	if (vectors < 0) {
@@ -2304,6 +2313,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = pdev->irq + hdev->roce_base_msix_offset;
 
@@ -2569,7 +2579,7 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 
 	req = (struct hclgevf_query_res_cmd *)desc.data;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)) {
+	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
 		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGEVF_MSIX_OFT_ROCEE_M,
@@ -2578,6 +2588,9 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msix = hdev->num_roce_msix;
+
 		/* VF should have NIC vectors and Roce vectors, NIC vectors
 		 * are queued before Roce vectors. The offset is fixed to 64.
 		 */
@@ -2587,6 +2600,15 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 		hdev->num_msi =
 		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
+
+		hdev->num_nic_msix = hdev->num_msi;
+	}
+
+	if (hdev->num_nic_msix < HNAE3_MIN_VECTOR_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"Just %u msi resources, not enough for vf(min:2).\n",
+			hdev->num_nic_msix);
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index ed83940..ef86155 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -271,6 +271,7 @@ struct hclgevf_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
+	u16 num_nic_msix;	/* Num of nic vectors for this VF */
 	u16 num_roce_msix;	/* Num of roce vectors for this VF */
 	u16 roce_base_msix_offset;
 	int roce_base_vector;
-- 
2.7.4

