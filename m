Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E82C278
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfE1JE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:04:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17618 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727484AbfE1JEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6EE449E421CA36D388D8;
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
Subject: [PATCH net-next 04/12] net: hns3: use HCLGE_STATE_NIC_REGISTERED to indicate PF NIC client has registered
Date:   Tue, 28 May 2019 17:02:54 +0800
Message-ID: <1559034182-24737-5-git-send-email-tanhuazhong@huawei.com>
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

When PF NIC client's init_instance() succeeds, it means this client
has been registered successfully, so we use HCLGE_STATE_NIC_REGISTERED
to indicate that. And before calling PF NIC client's uninit_instance(),
we clear this state.

So any operation of PF NIC client from HCLGE is not allowed if this
state is not set.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fb0dc18..87c5cb0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2873,6 +2873,10 @@ int hclge_notify_client(struct hclge_dev *hdev,
 	struct hnae3_client *client = hdev->nic_client;
 	u16 i;
 
+	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state) ||
+	    !client)
+		return 0;
+
 	if (!client->ops->reset_notify)
 		return -EOPNOTSUPP;
 
@@ -8184,6 +8188,7 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				goto clear_nic;
 
 			hnae3_set_client_init_flag(client, ae_dev, 1);
+			set_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
 
 			if (netif_msg_drv(&hdev->vport->nic))
 				hclge_info_show(hdev);
@@ -8270,6 +8275,7 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 		if (client->type == HNAE3_CLIENT_ROCE)
 			return;
 		if (hdev->nic_client && client->ops->uninit_instance) {
+			clear_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
 			client->ops->uninit_instance(&vport->nic, 0);
 			hdev->nic_client = NULL;
 			vport->nic.client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c770390..43901ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -201,6 +201,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_DOWN,
 	HCLGE_STATE_DISABLED,
 	HCLGE_STATE_REMOVING,
+	HCLGE_STATE_NIC_REGISTERED,
 	HCLGE_STATE_SERVICE_INITED,
 	HCLGE_STATE_SERVICE_SCHED,
 	HCLGE_STATE_RST_SERVICE_SCHED,
-- 
2.7.4

