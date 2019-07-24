Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB472552
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfGXDVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:21:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50500 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfGXDU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:20:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 70F9D67A04EC192DFFC1;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/11] net: hns3: fix mis-counting IRQ vector numbers issue
Date:   Wed, 24 Jul 2019 11:18:40 +0800
Message-ID: <1563938327-9865-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

The num_msi_left means the vector numbers of NIC, but if the
PF supported RoCE, it contains the vector numbers of NIC and
RoCE(Not expected).

This may cause interrupts lost in some case, because of the
NIC module used the vector resources which belongs to RoCE.

This patch corrects the value of num_msi_left to be equals to
the vector numbers of NIC, and adjust the default tqp numbers
according to the value of num_msi_left.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  5 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 12 ++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3c64d70..a59d13f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1470,13 +1470,16 @@ static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 {
 	struct hnae3_handle *nic = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
+	u16 alloc_tqps;
 	int ret;
 
 	nic->pdev = hdev->pdev;
 	nic->ae_algo = &ae_algo;
 	nic->numa_node_mask = hdev->numa_node_mask;
 
-	ret = hclge_knic_setup(vport, num_tqps,
+	alloc_tqps = min_t(u16, hdev->roce_base_msix_offset - 1, num_tqps);
+
+	ret = hclge_knic_setup(vport, alloc_tqps,
 			       hdev->num_tx_desc, hdev->num_rx_desc);
 	if (ret)
 		dev_err(&hdev->pdev->dev, "knic setup failed %d\n", ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index a13a0e1..db84782 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -287,6 +287,14 @@ static int hclgevf_get_queue_info(struct hclgevf_dev *hdev)
 	memcpy(&hdev->rss_size_max, &resp_msg[2], sizeof(u16));
 	memcpy(&hdev->rx_buf_len, &resp_msg[4], sizeof(u16));
 
+	/* if irq is not enough, let tqps have the same value of irqs,
+	 * to make sure one irq just bind to one tqp, this can improve
+	 * the performance
+	 */
+	hdev->num_tqps = min_t(u16, hdev->roce_base_msix_offset - 1,
+			       hdev->num_tqps);
+	hdev->rss_size_max = min_t(u16, hdev->rss_size_max, hdev->num_tqps);
+
 	return 0;
 }
 
@@ -2208,7 +2216,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	int vectors;
 	int i;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B))
+	if (hnae3_dev_roce_supported(hdev))
 		vectors = pci_alloc_irq_vectors(pdev,
 						hdev->roce_base_msix_offset + 1,
 						hdev->num_msi,
@@ -2495,7 +2503,7 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 
 	req = (struct hclgevf_query_res_cmd *)desc.data;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)) {
+	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
 		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGEVF_MSIX_OFT_ROCEE_M,
-- 
2.7.4

