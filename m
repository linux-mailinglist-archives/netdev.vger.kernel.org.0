Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4678827C161
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgI2JfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:35:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14773 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727831AbgI2Jex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:53 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A8C7A23A1888DD047538;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: Add RoCE VF reset support
Date:   Tue, 29 Sep 2020 17:32:02 +0800
Message-ID: <1601371925-49426-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add RoCE VF client reset support by notifying the RoCE VF client
when hns3 VF is resetting and adding a interface to query whether
CMDQ is ready to work.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 50 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 2 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8c8e666..50c84c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1702,6 +1702,26 @@ static int hclgevf_notify_client(struct hclgevf_dev *hdev,
 	return ret;
 }
 
+static int hclgevf_notify_roce_client(struct hclgevf_dev *hdev,
+				      enum hnae3_reset_notify_type type)
+{
+	struct hnae3_client *client = hdev->roce_client;
+	struct hnae3_handle *handle = &hdev->roce;
+	int ret;
+
+	if (!test_bit(HCLGEVF_STATE_ROCE_REGISTERED, &hdev->state) || !client)
+		return 0;
+
+	if (!client->ops->reset_notify)
+		return -EOPNOTSUPP;
+
+	ret = client->ops->reset_notify(handle, type);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "notify roce client failed %d(%d)",
+			type, ret);
+	return ret;
+}
+
 static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RESET_WAIT_US	20000
@@ -1865,6 +1885,11 @@ static int hclgevf_reset_prepare(struct hclgevf_dev *hdev)
 
 	hdev->rst_stats.rst_cnt++;
 
+	/* perform reset of the stack & ae device for a client */
+	ret = hclgevf_notify_roce_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
 	rtnl_lock();
 	/* bring down the nic to stop any ongoing TX/RX */
 	ret = hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
@@ -1880,6 +1905,9 @@ static int hclgevf_reset_rebuild(struct hclgevf_dev *hdev)
 	int ret;
 
 	hdev->rst_stats.hw_rst_done_cnt++;
+	ret = hclgevf_notify_roce_client(hdev, HNAE3_UNINIT_CLIENT);
+	if (ret)
+		return ret;
 
 	rtnl_lock();
 	/* now, re-initialize the nic client and ae device */
@@ -1890,6 +1918,18 @@ static int hclgevf_reset_rebuild(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	ret = hclgevf_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
+	/* ignore RoCE notify error if it fails HCLGEVF_RESET_MAX_FAIL_CNT - 1
+	 * times
+	 */
+	if (ret &&
+	    hdev->rst_stats.rst_fail_cnt < HCLGEVF_RESET_MAX_FAIL_CNT - 1)
+		return ret;
+
+	ret = hclgevf_notify_roce_client(hdev, HNAE3_UP_CLIENT);
+	if (ret)
+		return ret;
+
 	hdev->last_reset_time = jiffies;
 	hdev->rst_stats.rst_done_cnt++;
 	hdev->rst_stats.rst_fail_cnt = 0;
@@ -2757,6 +2797,7 @@ static int hclgevf_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
 	if (ret)
 		return ret;
 
+	set_bit(HCLGEVF_STATE_ROCE_REGISTERED, &hdev->state);
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	return 0;
@@ -2817,6 +2858,7 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 
 	/* un-init roce, if it exists */
 	if (hdev->roce_client) {
+		clear_bit(HCLGEVF_STATE_ROCE_REGISTERED, &hdev->state);
 		hdev->roce_client->ops->uninit_instance(&hdev->roce, 0);
 		hdev->roce_client = NULL;
 		hdev->roce.client = NULL;
@@ -3419,6 +3461,13 @@ static bool hclgevf_get_hw_reset_stat(struct hnae3_handle *handle)
 	return !!hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
 }
 
+static bool hclgevf_get_cmdq_stat(struct hnae3_handle *handle)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+
+	return test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+}
+
 static bool hclgevf_ae_dev_resetting(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
@@ -3604,6 +3653,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.get_link_mode = hclgevf_get_link_mode,
 	.set_promisc_mode = hclgevf_set_promisc_mode,
 	.request_update_promisc_mode = hclgevf_request_update_promisc_mode,
+	.get_cmdq_stat = hclgevf_get_cmdq_stat,
 };
 
 static struct hnae3_ae_algo ae_algovf = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index c1fac89..c5bcc38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -139,6 +139,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_IRQ_INITED,
 	HCLGEVF_STATE_REMOVING,
 	HCLGEVF_STATE_NIC_REGISTERED,
+	HCLGEVF_STATE_ROCE_REGISTERED,
 	/* task states */
 	HCLGEVF_STATE_RST_SERVICE_SCHED,
 	HCLGEVF_STATE_RST_HANDLING,
-- 
2.7.4

