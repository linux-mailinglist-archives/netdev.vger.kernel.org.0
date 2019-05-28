Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02D12C27C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfE1JFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfE1JEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 593075AB8E51A494ED66;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: use HCLGE_STATE_ROCE_REGISTERED to indicate PF ROCE client has registered
Date:   Tue, 28 May 2019 17:02:55 +0800
Message-ID: <1559034182-24737-6-git-send-email-tanhuazhong@huawei.com>
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

When PF ROCE client's init_instance() succeeds, it means this client
has been registered successfully, so we use HCLGE_STATE_ROCE_REGISTERED
to indicate that. And before calling PF ROCE client's uninit_instance(),
we clear this state.

So any operation of the ROCE client from HCLGE is not allowed if this
state is not set.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 +++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 87c5cb0..02a0698 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2902,7 +2902,8 @@ static int hclge_notify_roce_client(struct hclge_dev *hdev,
 	int ret = 0;
 	u16 i;
 
-	if (!client)
+	if (!test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state) ||
+	    !client)
 		return 0;
 
 	if (!client->ops->reset_notify)
@@ -8205,6 +8206,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				if (ret)
 					goto clear_roce;
 
+				set_bit(HCLGE_STATE_ROCE_REGISTERED,
+					&hdev->state);
 				hnae3_set_client_init_flag(hdev->roce_client,
 							   ae_dev, 1);
 			}
@@ -8236,6 +8239,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				if (ret)
 					goto clear_roce;
 
+				set_bit(HCLGE_STATE_ROCE_REGISTERED,
+					&hdev->state);
 				hnae3_set_client_init_flag(client, ae_dev, 1);
 			}
 
@@ -8267,6 +8272,7 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
 		vport = &hdev->vport[i];
 		if (hdev->roce_client) {
+			clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
 			hdev->roce_client->ops->uninit_instance(&vport->roce,
 								0);
 			hdev->roce_client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 43901ff..2b3bc95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -202,6 +202,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_DISABLED,
 	HCLGE_STATE_REMOVING,
 	HCLGE_STATE_NIC_REGISTERED,
+	HCLGE_STATE_ROCE_REGISTERED,
 	HCLGE_STATE_SERVICE_INITED,
 	HCLGE_STATE_SERVICE_SCHED,
 	HCLGE_STATE_RST_SERVICE_SCHED,
-- 
2.7.4

