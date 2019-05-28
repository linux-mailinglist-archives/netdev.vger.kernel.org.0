Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF86A2C26D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfE1JEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:04:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbfE1JEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6692323EC91F061FEA91;
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
Subject: [PATCH net-next 06/12] net: hns3: use HCLGEVF_STATE_NIC_REGISTERED to indicate VF NIC client has registered
Date:   Tue, 28 May 2019 17:02:56 +0800
Message-ID: <1559034182-24737-7-git-send-email-tanhuazhong@huawei.com>
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

When VF NIC client's init_instance() succeeds, it means this client
has been registered successfully, so we use HCLGEVF_STATE_NIC_REGISTERED
to indicate that. And before calling VF NIC client's uninit_instance(),
we clear this state.

So any operation of VF NIC client from HCLGEVF is not allowed if this
state is not set.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 7 +++++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5d53467..8b3f8fd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1306,6 +1306,10 @@ static int hclgevf_notify_client(struct hclgevf_dev *hdev,
 	struct hnae3_handle *handle = &hdev->nic;
 	int ret;
 
+	if (!test_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state) ||
+	    !client)
+		return 0;
+
 	if (!client->ops->reset_notify)
 		return -EOPNOTSUPP;
 
@@ -2265,6 +2269,7 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			goto clear_nic;
 
 		hnae3_set_client_init_flag(client, ae_dev, 1);
+		set_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
 
 		if (netif_msg_drv(&hdev->nic))
 			hclgevf_info_show(hdev);
@@ -2342,6 +2347,8 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 	/* un-init nic/unic, if this was not called by roce client */
 	if (client->ops->uninit_instance && hdev->nic_client &&
 	    client->type != HNAE3_CLIENT_ROCE) {
+		clear_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
+
 		client->ops->uninit_instance(&hdev->nic, 0);
 		hdev->nic_client = NULL;
 		hdev->nic.client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index cc52f54..eab1095 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -130,6 +130,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_DOWN,
 	HCLGEVF_STATE_DISABLED,
 	HCLGEVF_STATE_IRQ_INITED,
+	HCLGEVF_STATE_NIC_REGISTERED,
 	/* task states */
 	HCLGEVF_STATE_SERVICE_SCHED,
 	HCLGEVF_STATE_RST_SERVICE_SCHED,
-- 
2.7.4

