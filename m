Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A2A4C9FC
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbfFTIyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19045 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731465AbfFTIyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 732A334DD74B32B3B7D3;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 09/11] net: hns3: fix race conditions between reset and module loading & unloading
Date:   Thu, 20 Jun 2019 16:52:43 +0800
Message-ID: <1561020765-14481-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When loading or unloading module, it should wait for the reset task
done before it un-initializes the client, otherwise the reset task
may cause a NULL pointer reference.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 40 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0772ca1..53dbef9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8282,13 +8282,21 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 {
 	struct hnae3_client *client = vport->nic.client;
 	struct hclge_dev *hdev = ae_dev->priv;
+	int rst_cnt;
 	int ret;
 
+	rst_cnt = hdev->rst_stats.reset_cnt;
 	ret = client->ops->init_instance(&vport->nic);
 	if (ret)
 		return ret;
 
 	set_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
+	    rst_cnt != hdev->rst_stats.reset_cnt) {
+		ret = -EBUSY;
+		goto init_nic_err;
+	}
+
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	/* Enable nic hw error interrupts */
@@ -8301,6 +8309,15 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 		hclge_info_show(hdev);
 
 	return ret;
+
+init_nic_err:
+	clear_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
+	while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		msleep(HCLGE_WAIT_RESET_DONE);
+
+	client->ops->uninit_instance(&vport->nic, 0);
+
+	return ret;
 }
 
 static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
@@ -8308,6 +8325,7 @@ static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
 {
 	struct hnae3_client *client = vport->roce.client;
 	struct hclge_dev *hdev = ae_dev->priv;
+	int rst_cnt;
 	int ret;
 
 	if (!hnae3_dev_roce_supported(hdev) || !hdev->roce_client ||
@@ -8319,14 +8337,30 @@ static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
 	if (ret)
 		return ret;
 
+	rst_cnt = hdev->rst_stats.reset_cnt;
 	ret = client->ops->init_instance(&vport->roce);
 	if (ret)
 		return ret;
 
 	set_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
+	    rst_cnt != hdev->rst_stats.reset_cnt) {
+		ret = -EBUSY;
+		goto init_roce_err;
+	}
+
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	return 0;
+
+init_roce_err:
+	clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
+	while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		msleep(HCLGE_WAIT_RESET_DONE);
+
+	hdev->roce_client->ops->uninit_instance(&vport->roce, 0);
+
+	return ret;
 }
 
 static int hclge_init_client_instance(struct hnae3_client *client,
@@ -8398,6 +8432,9 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 		vport = &hdev->vport[i];
 		if (hdev->roce_client) {
 			clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
+			while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+				msleep(HCLGE_WAIT_RESET_DONE);
+
 			hdev->roce_client->ops->uninit_instance(&vport->roce,
 								0);
 			hdev->roce_client = NULL;
@@ -8407,6 +8444,9 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 			return;
 		if (hdev->nic_client && client->ops->uninit_instance) {
 			clear_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
+			while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+				msleep(HCLGE_WAIT_RESET_DONE);
+
 			client->ops->uninit_instance(&vport->nic, 0);
 			hdev->nic_client = NULL;
 			vport->nic.client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 8c4e47a..6a12285 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -700,6 +700,7 @@ struct hclge_mac_tnl_stats {
 };
 
 #define HCLGE_RESET_INTERVAL	(10 * HZ)
+#define HCLGE_WAIT_RESET_DONE	100
 
 #pragma pack(1)
 struct hclge_vf_vlan_cfg {
-- 
2.7.4

