Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8EB36E80
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfFFIWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:22:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41836 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfFFIWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9905C8A26EB2DFEE5D64;
        Thu,  6 Jun 2019 16:22:43 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: Delete the redundant user nic codes
Date:   Thu, 6 Jun 2019 16:21:02 +0800
Message-ID: <1559809267-53805-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
References: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Since HNAE3_CLIENT_UNIC and HNAE3_DEV_UNIC is not used any more,
this patch removes the redundant codes.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        | 21 ++++---------
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  7 -----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 34 ++++------------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 16 ----------
 5 files changed, 10 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 738e013..0de3d6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -16,14 +16,10 @@ static LIST_HEAD(hnae3_ae_dev_list);
  */
 static DEFINE_MUTEX(hnae3_common_lock);
 
-static bool hnae3_client_match(enum hnae3_client_type client_type,
-			       enum hnae3_dev_type dev_type)
+static bool hnae3_client_match(enum hnae3_client_type client_type)
 {
-	if ((dev_type == HNAE3_DEV_KNIC) && (client_type == HNAE3_CLIENT_KNIC ||
-					     client_type == HNAE3_CLIENT_ROCE))
-		return true;
-
-	if (dev_type == HNAE3_DEV_UNIC && client_type == HNAE3_CLIENT_UNIC)
+	if (client_type == HNAE3_CLIENT_KNIC ||
+	    client_type == HNAE3_CLIENT_ROCE)
 		return true;
 
 	return false;
@@ -39,9 +35,6 @@ void hnae3_set_client_init_flag(struct hnae3_client *client,
 	case HNAE3_CLIENT_KNIC:
 		hnae3_set_bit(ae_dev->flag, HNAE3_KNIC_CLIENT_INITED_B, inited);
 		break;
-	case HNAE3_CLIENT_UNIC:
-		hnae3_set_bit(ae_dev->flag, HNAE3_UNIC_CLIENT_INITED_B, inited);
-		break;
 	case HNAE3_CLIENT_ROCE:
 		hnae3_set_bit(ae_dev->flag, HNAE3_ROCE_CLIENT_INITED_B, inited);
 		break;
@@ -61,10 +54,6 @@ static int hnae3_get_client_init_flag(struct hnae3_client *client,
 		inited = hnae3_get_bit(ae_dev->flag,
 				       HNAE3_KNIC_CLIENT_INITED_B);
 		break;
-	case HNAE3_CLIENT_UNIC:
-		inited = hnae3_get_bit(ae_dev->flag,
-				       HNAE3_UNIC_CLIENT_INITED_B);
-		break;
 	case HNAE3_CLIENT_ROCE:
 		inited = hnae3_get_bit(ae_dev->flag,
 				       HNAE3_ROCE_CLIENT_INITED_B);
@@ -82,7 +71,7 @@ static int hnae3_init_client_instance(struct hnae3_client *client,
 	int ret;
 
 	/* check if this client matches the type of ae_dev */
-	if (!(hnae3_client_match(client->type, ae_dev->dev_type) &&
+	if (!(hnae3_client_match(client->type) &&
 	      hnae3_get_bit(ae_dev->flag, HNAE3_DEV_INITED_B))) {
 		return 0;
 	}
@@ -99,7 +88,7 @@ static void hnae3_uninit_client_instance(struct hnae3_client *client,
 					 struct hnae3_ae_dev *ae_dev)
 {
 	/* check if this client matches the type of ae_dev */
-	if (!(hnae3_client_match(client->type, ae_dev->dev_type) &&
+	if (!(hnae3_client_match(client->type) &&
 	      hnae3_get_bit(ae_dev->flag, HNAE3_DEV_INITED_B)))
 		return;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 2e478d9..63cdc18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -102,15 +102,9 @@ enum hnae3_loop {
 
 enum hnae3_client_type {
 	HNAE3_CLIENT_KNIC,
-	HNAE3_CLIENT_UNIC,
 	HNAE3_CLIENT_ROCE,
 };
 
-enum hnae3_dev_type {
-	HNAE3_DEV_KNIC,
-	HNAE3_DEV_UNIC,
-};
-
 /* mac media type */
 enum hnae3_media_type {
 	HNAE3_MEDIA_TYPE_UNKNOWN,
@@ -220,7 +214,6 @@ struct hnae3_ae_dev {
 	struct list_head node;
 	u32 flag;
 	u8 override_pci_need_reset; /* fix to stop multiple reset happening */
-	enum hnae3_dev_type dev_type;
 	enum hnae3_reset_type reset_type;
 	void *priv;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ef4470..07e7c3a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1837,7 +1837,6 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ae_dev->pdev = pdev;
 	ae_dev->flag = ent->driver_data;
-	ae_dev->dev_type = HNAE3_DEV_KNIC;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hns3_get_dev_capability(pdev, ae_dev);
 	pci_set_drvdata(pdev, ae_dev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 35d2a45..9fe00a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1461,11 +1461,6 @@ static int hclge_map_tqp(struct hclge_dev *hdev)
 	return 0;
 }
 
-static void hclge_unic_setup(struct hclge_vport *vport, u16 num_tqps)
-{
-	/* this would be initialized later */
-}
-
 static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 {
 	struct hnae3_handle *nic = &vport->nic;
@@ -1476,20 +1471,12 @@ static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 	nic->ae_algo = &ae_algo;
 	nic->numa_node_mask = hdev->numa_node_mask;
 
-	if (hdev->ae_dev->dev_type == HNAE3_DEV_KNIC) {
-		ret = hclge_knic_setup(vport, num_tqps,
-				       hdev->num_tx_desc, hdev->num_rx_desc);
-
-		if (ret) {
-			dev_err(&hdev->pdev->dev, "knic setup failed %d\n",
-				ret);
-			return ret;
-		}
-	} else {
-		hclge_unic_setup(vport, num_tqps);
-	}
+	ret = hclge_knic_setup(vport, num_tqps,
+			       hdev->num_tx_desc, hdev->num_rx_desc);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "knic setup failed %d\n", ret);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_alloc_vport(struct hclge_dev *hdev)
@@ -8264,17 +8251,6 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				goto clear_roce;
 
 			break;
-		case HNAE3_CLIENT_UNIC:
-			hdev->nic_client = client;
-			vport->nic.client = client;
-
-			ret = client->ops->init_instance(&vport->nic);
-			if (ret)
-				goto clear_nic;
-
-			hnae3_set_client_init_flag(client, ae_dev, 1);
-
-			break;
 		case HNAE3_CLIENT_ROCE:
 			if (hnae3_dev_roce_supported(hdev)) {
 				hdev->roce_client = client;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 87a619d..121c4e5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -470,12 +470,6 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 	nic->numa_node_mask = hdev->numa_node_mask;
 	nic->flags |= HNAE3_SUPPORT_VF;
 
-	if (hdev->ae_dev->dev_type != HNAE3_DEV_KNIC) {
-		dev_err(&hdev->pdev->dev, "unsupported device type %d\n",
-			hdev->ae_dev->dev_type);
-		return -EINVAL;
-	}
-
 	ret = hclgevf_knic_setup(hdev);
 	if (ret)
 		dev_err(&hdev->pdev->dev, "VF knic setup failed %d\n",
@@ -2323,16 +2317,6 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			goto clear_roce;
 
 		break;
-	case HNAE3_CLIENT_UNIC:
-		hdev->nic_client = client;
-		hdev->nic.client = client;
-
-		ret = client->ops->init_instance(&hdev->nic);
-		if (ret)
-			goto clear_nic;
-
-		hnae3_set_client_init_flag(client, ae_dev, 1);
-		break;
 	case HNAE3_CLIENT_ROCE:
 		if (hnae3_dev_roce_supported(hdev)) {
 			hdev->roce_client = client;
-- 
2.7.4

