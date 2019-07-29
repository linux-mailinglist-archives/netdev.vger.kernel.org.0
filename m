Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064087837C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfG2Czk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:55:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45358 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbfG2Czj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 22:55:39 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09DF31FC2DB48132A209;
        Mon, 29 Jul 2019 10:55:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Jul 2019 10:55:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        lipeng 00277521 <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 04/10] net: hns3: change GFP flag during lock period
Date:   Mon, 29 Jul 2019 10:53:25 +0800
Message-ID: <1564368811-65492-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

When allocating memory, the GFP_KERNEL cannot be used during the
spin_lock period. This is because it may cause scheduling when holding
spin_lock. This patch changes GFP flag to GFP_ATOMIC in this case.

Fixes: dd74f815dd41 ("net: hns3: Add support for rule add/delete for flow director")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: lipeng 00277521 <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3c64d70..14199c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5796,7 +5796,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 			return -ENOSPC;
 		}
 
-		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		rule = kzalloc(sizeof(*rule), GFP_ATOMIC);
 		if (!rule) {
 			spin_unlock_bh(&hdev->fd_rule_lock);
 
-- 
2.7.4

