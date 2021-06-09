Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC10E3A0D3F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhFIHKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:10:32 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5346 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbhFIHKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 03:10:08 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0J4h2xzkz6tqL;
        Wed,  9 Jun 2021 15:04:20 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 15:08:11 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 15:08:11 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jian Shen" <shenjian15@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next v2] net: hns3: use list_move_tail instead of list_del/list_add_tail in hclgevf_main.c
Date:   Wed, 9 Jun 2021 15:17:20 +0800
Message-ID: <20210609071720.1346684-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using list_move_tail() instead of list_del() + list_add_tail() in hclgevf_main.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	CC mailist

 .../hisilicon/hns3/hns3vf/hclgevf_main.c     | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index f84b3a135c06..52eaf82b7cd7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1536,8 +1536,7 @@ static void hclgevf_sync_from_add_list(struct list_head *add_list,
 			kfree(mac_node);
 		} else if (mac_node->state == HCLGEVF_MAC_ACTIVE) {
 			mac_node->state = HCLGEVF_MAC_TO_DEL;
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, mac_list);
+			list_move_tail(&mac_node->node, mac_list);
 		} else {
 			list_del(&mac_node->node);
 			kfree(mac_node);
@@ -1562,8 +1561,7 @@ static void hclgevf_sync_from_del_list(struct list_head *del_list,
 			list_del(&mac_node->node);
 			kfree(mac_node);
 		} else {
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, mac_list);
+			list_move_tail(&mac_node->node, mac_list);
 		}
 	}
 }
@@ -1599,8 +1597,7 @@ static void hclgevf_sync_mac_list(struct hclgevf_dev *hdev,
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		switch (mac_node->state) {
 		case HCLGEVF_MAC_TO_DEL:
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, &tmp_del_list);
+			list_move_tail(&mac_node->node, &tmp_del_list);
 			break;
 		case HCLGEVF_MAC_TO_ADD:
 			new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);

