Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43D8584EEA
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiG2KhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiG2KhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:37:17 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8FF13F05;
        Fri, 29 Jul 2022 03:37:16 -0700 (PDT)
Received: from dev010.ch-qa.sw.ru ([172.29.1.15])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1oHNLB-00Cf1E-IH;
        Fri, 29 Jul 2022 12:35:57 +0200
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        kernel@openvz.org, "Denis V . Lunev" <den@openvz.org>
Subject: [PATCH 2/2] neighbour: make proxy_queue.qlen limit per-device
Date:   Fri, 29 Jul 2022 13:35:59 +0300
Message-Id: <20220729103559.215140-3-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now we have a neigh_param PROXY_QLEN which specifies maximum length
of neigh_table->proxy_queue. But in fact, this limitation doesn't work well
because check condition looks like:
tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)

The problem is that p (struct neigh_parms) is a per-device thing,
but tbl (struct neigh_table) is a system-wide global thing.

It seems reasonable to make proxy_queue limit per-device based.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: kernel@openvz.org
Suggested-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Reviewed-by: Denis V. Lunev <den@openvz.org>
---
 include/net/neighbour.h |  1 +
 net/core/neighbour.c    | 25 ++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 87419f7f5421..bc3fbec70d10 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -82,6 +82,7 @@ struct neigh_parms {
 	struct rcu_head rcu_head;
 
 	int	reachable_time;
+	int	qlen;
 	int	data[NEIGH_VAR_DATA_MAX];
 	DECLARE_BITMAP(data_state, NEIGH_VAR_DATA_MAX);
 };
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 213ec0be800b..d98923e3ff02 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -316,9 +316,19 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 	skb = skb_peek(list);
 	while (skb != NULL) {
 		struct sk_buff *skb_next = skb_peek_next(skb, list);
-		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
+		struct net_device *dev = skb->dev;
+
+		if (!net || net_eq(dev_net(dev), net)) {
+			struct in_device *in_dev;
+
+			rcu_read_lock();
+			in_dev = __in_dev_get_rcu(dev);
+			if (in_dev)
+				in_dev->arp_parms->qlen--;
+			rcu_read_unlock();
 			__skb_unlink(skb, list);
-			dev_put(skb->dev);
+
+			dev_put(dev);
 			kfree_skb(skb);
 		}
 		skb = skb_next;
@@ -1605,8 +1615,15 @@ static void neigh_proxy_process(struct timer_list *t)
 
 		if (tdif <= 0) {
 			struct net_device *dev = skb->dev;
+			struct in_device *in_dev;
 
+			rcu_read_lock();
+			in_dev = __in_dev_get_rcu(dev);
+			if (in_dev)
+				in_dev->arp_parms->qlen--;
+			rcu_read_unlock();
 			__skb_unlink(skb, &tbl->proxy_queue);
+
 			if (tbl->proxy_redo && netif_running(dev)) {
 				rcu_read_lock();
 				tbl->proxy_redo(skb);
@@ -1631,7 +1648,7 @@ void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 	unsigned long sched_next = jiffies +
 			prandom_u32_max(NEIGH_VAR(p, PROXY_DELAY));
 
-	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
+	if (p->qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
 		return;
 	}
@@ -1647,6 +1664,7 @@ void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 	skb_dst_drop(skb);
 	dev_hold(skb->dev);
 	__skb_queue_tail(&tbl->proxy_queue, skb);
+	p->qlen++;
 	mod_timer(&tbl->proxy_timer, sched_next);
 	spin_unlock(&tbl->proxy_queue.lock);
 }
@@ -1679,6 +1697,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 		refcount_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+		p->qlen = 0;
 		dev_hold_track(dev, &p->dev_tracker, GFP_KERNEL);
 		p->dev = dev;
 		write_pnet(&p->net, net);
@@ -1744,6 +1763,7 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	refcount_set(&tbl->parms.refcnt, 1);
 	tbl->parms.reachable_time =
 			  neigh_rand_reach_time(NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME));
+	tbl->parms.qlen = 0;
 
 	tbl->stats = alloc_percpu(struct neigh_statistics);
 	if (!tbl->stats)
-- 
2.36.1

