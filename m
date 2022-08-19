Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C62759943E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346190AbiHSEjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345746AbiHSEjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:39:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0AE6BCFA;
        Thu, 18 Aug 2022 21:39:17 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M88886bzdz1N7Sx;
        Fri, 19 Aug 2022 12:35:52 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 12:39:15 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 19 Aug
 2022 12:39:15 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <den@openvz.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>
Subject: [PATCH net v2] net: neigh: don't call kfree_skb() under spin_lock_irqsave()
Date:   Fri, 19 Aug 2022 12:47:24 +0800
Message-ID: <20220819044724.961356-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So add all skb to
a tmp list, then free them after spin_unlock_irqrestore() at
once.

Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/core/neighbour.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5b669eb80270..d21c7de1ff1a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -309,14 +309,17 @@ static int neigh_del_timer(struct neighbour *n)
 
 static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 {
+	struct sk_buff_head tmp;
 	unsigned long flags;
 	struct sk_buff *skb;
 
+	skb_queue_head_init(&tmp);
 	spin_lock_irqsave(&list->lock, flags);
 	skb = skb_peek(list);
 	while (skb != NULL) {
 		struct sk_buff *skb_next = skb_peek_next(skb, list);
 		struct net_device *dev = skb->dev;
+
 		if (net == NULL || net_eq(dev_net(dev), net)) {
 			struct in_device *in_dev;
 
@@ -328,11 +331,16 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 			__skb_unlink(skb, list);
 
 			dev_put(dev);
-			kfree_skb(skb);
+			dev_kfree_skb_irq(skb);
 		}
 		skb = skb_next;
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
+
+	while ((skb = __skb_dequeue(&tmp))) {
+		dev_put(skb->dev);
+		kfree_skb(skb);
+	}
 }
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
-- 
2.25.1

