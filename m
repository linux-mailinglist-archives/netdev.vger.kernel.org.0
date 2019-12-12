Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B12611CCBB
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfLLMDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:03:45 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbfLLMDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 07:03:45 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2B8B07037F60CBF7E77B;
        Thu, 12 Dec 2019 20:03:43 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Thu, 12 Dec 2019 20:03:35 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <wireguard@lists.zx2c4.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] wireguard: Using kfree_rcu() to simplify the code
Date:   Thu, 12 Dec 2019 12:00:55 +0000
Message-ID: <20191212120055.129801-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback function of call_rcu() just calls a kfree(), so we
can use kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireguard/allowedips.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 72667d5399c3..121d9ea0f135 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -31,11 +31,6 @@ static void copy_and_assign_cidr(struct allowedips_node *node, const u8 *src,
 #define CHOOSE_NODE(parent, key) \
 	parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]
 
-static void node_free_rcu(struct rcu_head *rcu)
-{
-	kfree(container_of(rcu, struct allowedips_node, rcu));
-}
-
 static void push_rcu(struct allowedips_node **stack,
 		     struct allowedips_node __rcu *p, unsigned int *len)
 {
@@ -112,7 +107,7 @@ static void walk_remove_by_peer(struct allowedips_node __rcu **top,
 				if (!node->bit[0] || !node->bit[1]) {
 					rcu_assign_pointer(*nptr, DEREF(
 					       &node->bit[!REF(node->bit[0])]));
-					call_rcu(&node->rcu, node_free_rcu);
+					kfree_rcu(node, rcu);
 					node = DEREF(nptr);
 				}
 			}



