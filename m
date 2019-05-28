Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40722C27F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfE1JFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17613 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727487AbfE1JEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5D57BD3082A05563A4B5;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: modify hclgevf_init_client_instance()
Date:   Tue, 28 May 2019 17:02:58 +0800
Message-ID: <1559034182-24737-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hclgevf_init_client_instance() is a little bloated and there is
some duplicated code. This patch adds some cleanup for it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 79 ++++++++++++++--------
 1 file changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8b3f8fd..9d5a4f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2253,6 +2253,48 @@ static void hclgevf_info_show(struct hclgevf_dev *hdev)
 	dev_info(dev, "VF info end.\n");
 }
 
+static int hclgevf_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
+					    struct hnae3_client *client)
+{
+	struct hclgevf_dev *hdev = ae_dev->priv;
+	int ret;
+
+	ret = client->ops->init_instance(&hdev->nic);
+	if (ret)
+		return ret;
+
+	set_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
+	hnae3_set_client_init_flag(client, ae_dev, 1);
+
+	if (netif_msg_drv(&hdev->nic))
+		hclgevf_info_show(hdev);
+
+	return 0;
+}
+
+static int hclgevf_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
+					     struct hnae3_client *client)
+{
+	struct hclgevf_dev *hdev = ae_dev->priv;
+	int ret;
+
+	if (!hnae3_dev_roce_supported(hdev) || !hdev->roce_client ||
+	    !hdev->nic_client)
+		return 0;
+
+	ret = hclgevf_init_roce_base_info(hdev);
+	if (ret)
+		return ret;
+
+	ret = client->ops->init_instance(&hdev->roce);
+	if (ret)
+		return ret;
+
+	hnae3_set_client_init_flag(client, ae_dev, 1);
+
+	return 0;
+}
+
 static int hclgevf_init_client_instance(struct hnae3_client *client,
 					struct hnae3_ae_dev *ae_dev)
 {
@@ -2264,29 +2306,15 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		hdev->nic_client = client;
 		hdev->nic.client = client;
 
-		ret = client->ops->init_instance(&hdev->nic);
+		ret = hclgevf_init_nic_client_instance(ae_dev, client);
 		if (ret)
 			goto clear_nic;
 
-		hnae3_set_client_init_flag(client, ae_dev, 1);
-		set_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
-
-		if (netif_msg_drv(&hdev->nic))
-			hclgevf_info_show(hdev);
-
-		if (hdev->roce_client && hnae3_dev_roce_supported(hdev)) {
-			struct hnae3_client *rc = hdev->roce_client;
-
-			ret = hclgevf_init_roce_base_info(hdev);
-			if (ret)
-				goto clear_roce;
-			ret = rc->ops->init_instance(&hdev->roce);
-			if (ret)
-				goto clear_roce;
+		ret = hclgevf_init_roce_client_instance(ae_dev,
+							hdev->roce_client);
+		if (ret)
+			goto clear_roce;
 
-			hnae3_set_client_init_flag(hdev->roce_client, ae_dev,
-						   1);
-		}
 		break;
 	case HNAE3_CLIENT_UNIC:
 		hdev->nic_client = client;
@@ -2304,17 +2332,10 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			hdev->roce.client = client;
 		}
 
-		if (hdev->roce_client && hdev->nic_client) {
-			ret = hclgevf_init_roce_base_info(hdev);
-			if (ret)
-				goto clear_roce;
-
-			ret = client->ops->init_instance(&hdev->roce);
-			if (ret)
-				goto clear_roce;
-		}
+		ret = hclgevf_init_roce_client_instance(ae_dev, client);
+		if (ret)
+			goto clear_roce;
 
-		hnae3_set_client_init_flag(client, ae_dev, 1);
 		break;
 	default:
 		return -EINVAL;
-- 
2.7.4

