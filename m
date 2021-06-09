Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D73A0D52
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhFIHNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:13:55 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5347 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhFIHNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 03:13:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0J9171sVz6vlK;
        Wed,  9 Jun 2021 15:08:05 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 15:11:48 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 15:11:47 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        GuoJia Liao <liaoguojia@huawei.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next v2] net: hns3: use list_move_tail instead of list_del/list_add_tail in hclge_main.c
Date:   Wed, 9 Jun 2021 15:20:56 +0800
Message-ID: <20210609072056.1351940-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using list_move_tail() instead of list_del() + list_add_tail() in hclge_main.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	CC mailist

 .../hns3/hns3pf/hclge_main.c          | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6ecc106af334..2e95d36fcc52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8799,8 +8799,7 @@ static bool hclge_sync_from_add_list(struct list_head *add_list,
 			kfree(mac_node);
 		} else if (mac_node->state == HCLGE_MAC_ACTIVE) {
 			mac_node->state = HCLGE_MAC_TO_DEL;
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, mac_list);
+			list_move_tail(&mac_node->node, mac_list);
 		} else {
 			list_del(&mac_node->node);
 			kfree(mac_node);
@@ -8829,8 +8828,7 @@ static void hclge_sync_from_del_list(struct list_head *del_list,
 			list_del(&mac_node->node);
 			kfree(mac_node);
 		} else {
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, mac_list);
+			list_move_tail(&mac_node->node, mac_list);
 		}
 	}
 }
@@ -8874,8 +8872,7 @@ static void hclge_sync_vport_mac_table(struct hclge_vport *vport,
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		switch (mac_node->state) {
 		case HCLGE_MAC_TO_DEL:
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, &tmp_del_list);
+			list_move_tail(&mac_node->node, &tmp_del_list);
 			break;
 		case HCLGE_MAC_TO_ADD:
 			new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);
@@ -8957,8 +8954,7 @@ static void hclge_build_del_list(struct list_head *list,
 		switch (mac_cfg->state) {
 		case HCLGE_MAC_TO_DEL:
 		case HCLGE_MAC_ACTIVE:
-			list_del(&mac_cfg->node);
-			list_add_tail(&mac_cfg->node, tmp_del_list);
+			list_move_tail(&mac_cfg->node, tmp_del_list);
 			break;
 		case HCLGE_MAC_TO_ADD:
 			if (is_del_list) {
@@ -9053,8 +9049,7 @@ static void hclge_uninit_vport_mac_list(struct hclge_vport *vport,
 		switch (mac_node->state) {
 		case HCLGE_MAC_TO_DEL:
 		case HCLGE_MAC_ACTIVE:
-			list_del(&mac_node->node);
-			list_add_tail(&mac_node->node, &tmp_del_list);
+			list_move_tail(&mac_node->node, &tmp_del_list);
 			break;
 		case HCLGE_MAC_TO_ADD:
 			list_del(&mac_node->node);

