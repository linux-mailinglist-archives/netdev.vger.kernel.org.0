Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EA4E5AF1
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfJZNTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfJZNTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7919E21D81;
        Sat, 26 Oct 2019 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095945;
        bh=/dMxvF82L0wnNG1rbiwx7rpRRnMYeG2cXV1IZct3sYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O96pdoQViZt4KbZMbeZ8C30LXg/taZKa+Dxl6kYsw3e1d/NfAeN9tOnVhYJQ6PjWE
         78qiBWbTCyW9DzojLl1s2H3ALO6t3KEV2Nrz8EXFzYDKkENUI1KqhDS/EHtX0Tpgct
         2P3qbJ5TtSQwDEUQ6LQuGy7JxcmLVnWX55HM+ieE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 98/99] net: hns3: fix mis-counting IRQ vector numbers issue
Date:   Sat, 26 Oct 2019 09:15:59 -0400
Message-Id: <20191026131600.2507-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 580a05f9d4ada3bfb689140d0efec1efdb8a48da ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 21 +++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 11 ++++++--
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 28 +++++++++++++++++--
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  1 +
 6 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 48c7b70fc2c4c..58a7d62b38de3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -32,6 +32,8 @@
 
 #define HNAE3_MOD_VERSION "1.0"
 
+#define HNAE3_MIN_VECTOR_NUM	2 /* first one for misc, another for IO */
+
 /* Device IDs */
 #define HNAE3_DEV_ID_GE				0xA220
 #define HNAE3_DEV_ID_25GE			0xA221
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3fde5471e1c04..65b53ec1d9cab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -800,6 +800,9 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msi = hdev->num_roce_msi;
+
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
@@ -809,6 +812,15 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
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
@@ -1394,6 +1406,10 @@ static int  hclge_assign_tqp(struct hclge_vport *vport, u16 num_tqps)
 	kinfo->rss_size = min_t(u16, hdev->rss_size_max,
 				vport->alloc_tqps / hdev->tm_info.num_tc);
 
+	/* ensure one to one mapping between irq and queue at default */
+	kinfo->rss_size = min_t(u16, kinfo->rss_size,
+				(hdev->num_nic_msi - 1) / hdev->tm_info.num_tc);
+
 	return 0;
 }
 
@@ -2172,7 +2188,8 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	int vectors;
 	int i;
 
-	vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+	vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
+					hdev->num_msi,
 					PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
@@ -2187,6 +2204,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = hdev->base_msi_vector +
 				hdev->roce_base_msix_offset;
@@ -3644,6 +3662,7 @@ static int hclge_get_vector(struct hnae3_handle *handle, u16 vector_num,
 	int alloc = 0;
 	int i, j;
 
+	vector_num = min_t(u16, hdev->num_nic_msi - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 6a12285f4c763..6dc66d3f8408f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -795,6 +795,7 @@ struct hclge_dev {
 	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
+	u16 num_nic_msi;	/* Num of nic vectors for this PF */
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
 	int roce_base_vector;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 3f41fa2bc4143..856337705949b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -540,9 +540,16 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
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
index a13a0e101c3bf..b094d4e9ba2dd 100644
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
@@ -2208,13 +2216,14 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
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
@@ -2230,6 +2239,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = pdev->irq + hdev->roce_base_msix_offset;
 
@@ -2495,7 +2505,7 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 
 	req = (struct hclgevf_query_res_cmd *)desc.data;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)) {
+	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
 		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGEVF_MSIX_OFT_ROCEE_M,
@@ -2504,6 +2514,9 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msix = hdev->num_roce_msix;
+
 		/* VF should have NIC vectors and Roce vectors, NIC vectors
 		 * are queued before Roce vectors. The offset is fixed to 64.
 		 */
@@ -2513,6 +2526,15 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
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
index 5a9e30998a8f5..3c90cff0e43ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -265,6 +265,7 @@ struct hclgevf_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
+	u16 num_nic_msix;	/* Num of nic vectors for this VF */
 	u16 num_roce_msix;	/* Num of roce vectors for this VF */
 	u16 roce_base_msix_offset;
 	int roce_base_vector;
-- 
2.20.1

