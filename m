Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EBB34C25D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhC2D7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15031 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhC2D6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zJH3R6XzNrB6;
        Mon, 29 Mar 2021 11:55:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: fix missing rule state assignment
Date:   Mon, 29 Mar 2021 11:57:45 +0800
Message-ID: <1616990273-46426-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, when adding flow director rule, it missed to set
rule state. Which may cause the rule state in software is
unconsistent with hardware.

Fixes: fc4243b8de8b ("net: hns3: refactor flow director configuration")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d639519..08da3e2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6439,7 +6439,8 @@ static int hclge_add_fd_entry_common(struct hclge_dev *hdev,
 	if (ret)
 		goto out;
 
-	hclge_update_fd_list(hdev, HCLGE_FD_ACTIVE, rule->location, rule);
+	rule->state = HCLGE_FD_ACTIVE;
+	hclge_update_fd_list(hdev, rule->state, rule->location, rule);
 	hdev->fd_active_type = rule->rule_type;
 
 out:
@@ -7002,6 +7003,7 @@ static void hclge_fd_build_arfs_rule(const struct hclge_fd_rule_tuples *tuples,
 	rule->action = 0;
 	rule->vf_id = 0;
 	rule->rule_type = HCLGE_FD_ARFS_ACTIVE;
+	rule->state = HCLGE_FD_TO_ADD;
 	if (tuples->ether_proto == ETH_P_IP) {
 		if (tuples->ip_proto == IPPROTO_TCP)
 			rule->flow_type = TCP_V4_FLOW;
@@ -7064,8 +7066,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 		rule->arfs.flow_id = flow_id;
 		rule->queue_id = queue_id;
 		hclge_fd_build_arfs_rule(&new_tuples, rule);
-		hclge_update_fd_list(hdev, HCLGE_FD_TO_ADD, rule->location,
-				     rule);
+		hclge_update_fd_list(hdev, rule->state, rule->location, rule);
 		hdev->fd_active_type = HCLGE_FD_ARFS_ACTIVE;
 	} else if (rule->queue_id != queue_id) {
 		rule->queue_id = queue_id;
-- 
2.7.4

