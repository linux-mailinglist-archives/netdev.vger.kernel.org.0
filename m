Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A775BA4B5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 04:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIPClB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 22:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiIPCkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 22:40:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FA9858D;
        Thu, 15 Sep 2022 19:40:48 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJ952jpNzNm8K;
        Fri, 16 Sep 2022 10:36:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 10:40:46 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:40:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>, <shenjian15@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: add judge fd ability for sync and clear process of flow director
Date:   Fri, 16 Sep 2022 10:38:03 +0800
Message-ID: <20220916023803.23756-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220916023803.23756-1-huangguangbin2@huawei.com>
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, driver will always clear user defined field of flow director
in uninit process and sync flow director table in periodic task. However,
if hardware does not support flow director driver should not do those
processes, so add fd ability judgement.

The fd ability judgement in function hclge_clear_fd_rules_in_list() is
redundant, so delete it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 66436801fb8e..7b25d8f89427 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6628,9 +6628,6 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 	struct hlist_node *node;
 	u16 location;
 
-	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
-		return;
-
 	spin_lock_bh(&hdev->fd_rule_lock);
 
 	for_each_set_bit(location, hdev->fd_bmap,
@@ -6655,6 +6652,9 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 
 static void hclge_del_all_fd_entries(struct hclge_dev *hdev)
 {
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
+		return;
+
 	hclge_clear_fd_rules_in_list(hdev, true);
 	hclge_fd_disable_user_def(hdev);
 }
@@ -7488,6 +7488,9 @@ static void hclge_sync_fd_list(struct hclge_dev *hdev, struct hlist_head *hlist)
 
 static void hclge_sync_fd_table(struct hclge_dev *hdev)
 {
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
+		return;
+
 	if (test_and_clear_bit(HCLGE_STATE_FD_CLEAR_ALL, &hdev->state)) {
 		bool clear_list = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
 
-- 
2.33.0

