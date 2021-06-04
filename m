Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D4B39AFE2
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFDBfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:35:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3534 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhFDBfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:35:11 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fx4vz0DvjzYnCJ;
        Fri,  4 Jun 2021 09:30:39 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:33:23 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] tipc: Return the correct errno code
Date:   Fri, 4 Jun 2021 09:47:02 +0800
Message-ID: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/tipc/link.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index c44b4bfaaee6..5b6181277cc5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -912,7 +912,7 @@ static int link_schedule_user(struct tipc_link *l, struct tipc_msg *hdr)
 	skb = tipc_msg_create(SOCK_WAKEUP, 0, INT_H_SIZE, 0,
 			      dnode, l->addr, dport, 0, 0);
 	if (!skb)
-		return -ENOBUFS;
+		return -ENOMEM;
 	msg_set_dest_droppable(buf_msg(skb), true);
 	TIPC_SKB_CB(skb)->chain_imp = msg_importance(hdr);
 	skb_queue_tail(&l->wakeupq, skb);
@@ -1030,7 +1030,7 @@ void tipc_link_reset(struct tipc_link *l)
  *
  * Consumes the buffer chain.
  * Messages at TIPC_SYSTEM_IMPORTANCE are always accepted
- * Return: 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS
+ * Return: 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS or -ENOMEM
  */
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
@@ -1088,7 +1088,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 			if (!_skb) {
 				kfree_skb(skb);
 				__skb_queue_purge(list);
-				return -ENOBUFS;
+				return -ENOMEM;
 			}
 			__skb_queue_tail(transmq, skb);
 			tipc_link_set_skb_retransmit_time(skb, l);
-- 
2.25.1

