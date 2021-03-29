Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF77534C25B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhC2D7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15082 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhC2D6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F7zJw6WLfz19JSS;
        Mon, 29 Mar 2021 11:56:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/9] net: hns3: fix use-after-free issue for hclge_add_fd_entry_common()
Date:   Mon, 29 Mar 2021 11:57:46 +0800
Message-ID: <1616990273-46426-3-git-send-email-tanhuazhong@huawei.com>
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

When new rule state is TO_ADD or ACTIVE, and there is already a
rule with same location in the fd_rule_list, the new rule will
be freed after modifying the old rule. It may cause user-after-free
issue when access rule again in hclge_add_fd_entry_common().

Fixes: fc4243b8de8b ("net: hns3: refactor flow director configuration")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 08da3e2..042dfd8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6440,8 +6440,8 @@ static int hclge_add_fd_entry_common(struct hclge_dev *hdev,
 		goto out;
 
 	rule->state = HCLGE_FD_ACTIVE;
-	hclge_update_fd_list(hdev, rule->state, rule->location, rule);
 	hdev->fd_active_type = rule->rule_type;
+	hclge_update_fd_list(hdev, rule->state, rule->location, rule);
 
 out:
 	spin_unlock_bh(&hdev->fd_rule_lock);
-- 
2.7.4

