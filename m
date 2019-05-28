Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC052C28B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfE1JFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17612 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727461AbfE1JEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:38 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 50CE98CBB0DF2193D2C2;
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
Subject: [PATCH net-next 07/12] net: hns3: modify hclge_init_client_instance()
Date:   Tue, 28 May 2019 17:02:57 +0800
Message-ID: <1559034182-24737-8-git-send-email-tanhuazhong@huawei.com>
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

hclge_init_client_instance() is a little bloated and there is
some duplicated code. This patch adds some cleanup for it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 90 +++++++++++++---------
 1 file changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 02a0698..b7106a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8169,6 +8169,52 @@ static void hclge_info_show(struct hclge_dev *hdev)
 	dev_info(dev, "PF info end.\n");
 }
 
+static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
+					  struct hclge_vport *vport)
+{
+	struct hnae3_client *client = vport->nic.client;
+	struct hclge_dev *hdev = ae_dev->priv;
+	int ret;
+
+	ret = client->ops->init_instance(&vport->nic);
+	if (ret)
+		return ret;
+
+	set_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
+	hnae3_set_client_init_flag(client, ae_dev, 1);
+
+	if (netif_msg_drv(&hdev->vport->nic))
+		hclge_info_show(hdev);
+
+	return 0;
+}
+
+static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
+					   struct hclge_vport *vport)
+{
+	struct hnae3_client *client = vport->roce.client;
+	struct hclge_dev *hdev = ae_dev->priv;
+	int ret;
+
+	if (!hnae3_dev_roce_supported(hdev) || !hdev->roce_client ||
+	    !hdev->nic_client)
+		return 0;
+
+	client = hdev->roce_client;
+	ret = hclge_init_roce_base_info(vport);
+	if (ret)
+		return ret;
+
+	ret = client->ops->init_instance(&vport->roce);
+	if (ret)
+		return ret;
+
+	set_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
+	hnae3_set_client_init_flag(client, ae_dev, 1);
+
+	return 0;
+}
+
 static int hclge_init_client_instance(struct hnae3_client *client,
 				      struct hnae3_ae_dev *ae_dev)
 {
@@ -8184,33 +8230,13 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 
 			hdev->nic_client = client;
 			vport->nic.client = client;
-			ret = client->ops->init_instance(&vport->nic);
+			ret = hclge_init_nic_client_instance(ae_dev, vport);
 			if (ret)
 				goto clear_nic;
 
-			hnae3_set_client_init_flag(client, ae_dev, 1);
-			set_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
-
-			if (netif_msg_drv(&hdev->vport->nic))
-				hclge_info_show(hdev);
-
-			if (hdev->roce_client &&
-			    hnae3_dev_roce_supported(hdev)) {
-				struct hnae3_client *rc = hdev->roce_client;
-
-				ret = hclge_init_roce_base_info(vport);
-				if (ret)
-					goto clear_roce;
-
-				ret = rc->ops->init_instance(&vport->roce);
-				if (ret)
-					goto clear_roce;
-
-				set_bit(HCLGE_STATE_ROCE_REGISTERED,
-					&hdev->state);
-				hnae3_set_client_init_flag(hdev->roce_client,
-							   ae_dev, 1);
-			}
+			ret = hclge_init_roce_client_instance(ae_dev, vport);
+			if (ret)
+				goto clear_roce;
 
 			break;
 		case HNAE3_CLIENT_UNIC:
@@ -8230,19 +8256,9 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				vport->roce.client = client;
 			}
 
-			if (hdev->roce_client && hdev->nic_client) {
-				ret = hclge_init_roce_base_info(vport);
-				if (ret)
-					goto clear_roce;
-
-				ret = client->ops->init_instance(&vport->roce);
-				if (ret)
-					goto clear_roce;
-
-				set_bit(HCLGE_STATE_ROCE_REGISTERED,
-					&hdev->state);
-				hnae3_set_client_init_flag(client, ae_dev, 1);
-			}
+			ret = hclge_init_roce_client_instance(ae_dev, vport);
+			if (ret)
+				goto clear_roce;
 
 			break;
 		default:
-- 
2.7.4

