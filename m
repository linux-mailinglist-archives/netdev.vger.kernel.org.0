Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C741C1C7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbhI2JmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:42:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:26969 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKB7q0qLLzbmwH;
        Wed, 29 Sep 2021 17:35:51 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 2/8] net: hns3: remove tc enable checking
Date:   Wed, 29 Sep 2021 17:35:50 +0800
Message-ID: <20210929093556.9146-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, in function hns3_nic_set_real_num_queue(), the
driver doesn't report the queue count and offset for disabled
tc. If user enables multiple TCs, but only maps user
priorities to partial of them, it may cause the queue range
of the unmapped TC being displayed abnormally.

Fix it by removing the tc enable checking, ensure the queue
count is not zero.

With this change, the tc_en is useless now, so remove it.

Fixes: a75a8efa00c5 ("net: hns3: Fix tc setup when netdev is first up")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h           |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 11 ++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    |  5 -----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 --
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 546a60530384..8ba21d6dc220 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -752,7 +752,6 @@ struct hnae3_tc_info {
 	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
 	u16 tqp_count[HNAE3_MAX_TC];
 	u16 tqp_offset[HNAE3_MAX_TC];
-	unsigned long tc_en; /* bitmap of TC enabled */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5637c075a894..468b8f07bf47 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -623,13 +623,9 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 			return ret;
 		}
 
-		for (i = 0; i < HNAE3_MAX_TC; i++) {
-			if (!test_bit(i, &tc_info->tc_en))
-				continue;
-
+		for (i = 0; i < tc_info->num_tc; i++)
 			netdev_set_tc_queue(netdev, i, tc_info->tqp_count[i],
 					    tc_info->tqp_offset[i]);
-		}
 	}
 
 	ret = netif_set_real_num_tx_queues(netdev, queue_size);
@@ -4870,12 +4866,9 @@ static void hns3_init_tx_ring_tc(struct hns3_nic_priv *priv)
 	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
 	int i;
 
-	for (i = 0; i < HNAE3_MAX_TC; i++) {
+	for (i = 0; i < tc_info->num_tc; i++) {
 		int j;
 
-		if (!test_bit(i, &tc_info->tc_en))
-			continue;
-
 		for (j = 0; j < tc_info->tqp_count[i]; j++) {
 			struct hnae3_queue *q;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 4a619e5d3f35..96f96644abab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -441,8 +441,6 @@ static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
 static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 				   struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
-	int i;
-
 	memset(tc_info, 0, sizeof(*tc_info));
 	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
 	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
@@ -451,9 +449,6 @@ static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 	       sizeof_field(struct hnae3_tc_info, tqp_count));
 	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
 	       sizeof_field(struct hnae3_tc_info, tqp_offset));
-
-	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
-		set_bit(tc_info->prio_tc[i], &tc_info->tc_en);
 }
 
 static int hclge_config_tc(struct hclge_dev *hdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 44618cc4cca1..6f5035a788c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -687,12 +687,10 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		if (hdev->hw_tc_map & BIT(i) && i < kinfo->tc_info.num_tc) {
-			set_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = i * kinfo->rss_size;
 			kinfo->tc_info.tqp_count[i] = kinfo->rss_size;
 		} else {
 			/* Set to default queue if TC is disable */
-			clear_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = 0;
 			kinfo->tc_info.tqp_count[i] = 1;
 		}
-- 
2.33.0

