Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C30313138
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBHLpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:45:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12590 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbhBHLlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:41:15 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT0ZLpz165PR;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: remove redundant client_setup_tc handle
Date:   Mon, 8 Feb 2021 19:39:32 +0800
Message-ID: <1612784382-27262-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Since the real tx queue number and real rx queue number
always be updated when netdev opens, it's redundant
to call hclge_client_setup_tc to do the same thing.
So remove it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 15 ------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 27 ----------------------
 3 files changed, 43 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e20a1b3..12548809 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -292,7 +292,6 @@ struct hnae3_client_ops {
 	int (*init_instance)(struct hnae3_handle *handle);
 	void (*uninit_instance)(struct hnae3_handle *handle, bool reset);
 	void (*link_status_change)(struct hnae3_handle *handle, bool state);
-	int (*setup_tc)(struct hnae3_handle *handle, u8 tc);
 	int (*reset_notify)(struct hnae3_handle *handle,
 			    enum hnae3_reset_notify_type type);
 	void (*process_hw_error)(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cf16d5f..4c10b87 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4378,20 +4378,6 @@ static void hns3_link_status_change(struct hnae3_handle *handle, bool linkup)
 	}
 }
 
-static int hns3_client_setup_tc(struct hnae3_handle *handle, u8 tc)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct net_device *ndev = kinfo->netdev;
-
-	if (tc > HNAE3_MAX_TC)
-		return -EINVAL;
-
-	if (!ndev)
-		return -ENODEV;
-
-	return hns3_nic_set_real_num_queue(ndev);
-}
-
 static void hns3_clear_tx_ring(struct hns3_enet_ring *ring)
 {
 	while (ring->next_to_clean != ring->next_to_use) {
@@ -4828,7 +4814,6 @@ static const struct hnae3_client_ops client_ops = {
 	.init_instance = hns3_client_init,
 	.uninit_instance = hns3_client_uninit,
 	.link_status_change = hns3_link_status_change,
-	.setup_tc = hns3_client_setup_tc,
 	.reset_notify = hns3_reset_notify,
 	.process_hw_error = hns3_process_hw_error,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index e08d11b8..5bf5db9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -176,29 +176,6 @@ static int hclge_map_update(struct hclge_dev *hdev)
 	return hclge_rss_init_hw(hdev);
 }
 
-static int hclge_client_setup_tc(struct hclge_dev *hdev)
-{
-	struct hclge_vport *vport = hdev->vport;
-	struct hnae3_client *client;
-	struct hnae3_handle *handle;
-	int ret;
-	u32 i;
-
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-		handle = &vport[i].nic;
-		client = handle->client;
-
-		if (!client || !client->ops || !client->ops->setup_tc)
-			continue;
-
-		ret = client->ops->setup_tc(handle, hdev->tm_info.num_tc);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int hclge_notify_down_uinit(struct hclge_dev *hdev)
 {
 	int ret;
@@ -257,10 +234,6 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 		if (ret)
 			goto err_out;
 
-		ret = hclge_client_setup_tc(hdev);
-		if (ret)
-			goto err_out;
-
 		ret = hclge_notify_init_up(hdev);
 		if (ret)
 			return ret;
-- 
2.7.4

