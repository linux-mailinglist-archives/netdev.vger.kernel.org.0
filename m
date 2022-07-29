Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630D8584EEF
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiG2KhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiG2KhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:37:17 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E5080F67;
        Fri, 29 Jul 2022 03:37:16 -0700 (PDT)
Received: from dev010.ch-qa.sw.ru ([172.29.1.15])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1oHNL9-00Cf1E-If;
        Fri, 29 Jul 2022 12:35:55 +0200
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     "Denis V. Lunev" <den@openvz.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>, kernel@openvz.org
Subject: [PATCH 1/2] neigh: fix possible DoS due to net iface start/stop loop
Date:   Fri, 29 Jul 2022 13:35:58 +0300
Message-Id: <20220729103559.215140-2-alexander.mikhalitsyn@virtuozzo.com>
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

From: "Denis V. Lunev" <den@openvz.org>

Normal processing of ARP request (usually this is Ethernet broadcast
packet) coming to the host is looking like the following:
* the packet comes to arp_process() call and is passed through routing
  procedure
* the request is put into the queue using pneigh_enqueue() if
  corresponding ARP record is not local (common case for container
  records on the host)
* the request is processed by timer (within 80 jiffies by default) and
  ARP reply is sent from the same arp_process() using
  NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED condition (flag is set inside
  pneigh_enqueue())

And here the problem comes. Linux kernel calls pneigh_queue_purge()
which destroys the whole queue of ARP requests on ANY network interface
start/stop event through __neigh_ifdown().

This is actually not a problem within the original world as network
interface start/stop was accessible to the host 'root' only, which
could do more destructive things. But the world is changed and there
are Linux containers available. Here container 'root' has an access
to this API and could be considered as untrusted user in the hosting
(container's) world.

Thus there is an attack vector to other containers on node when
container's root will endlessly start/stop interfaces. We have observed
similar situation on a real production node when docker container was
doing such activity and thus other containers on the node become not
accessible.

The patch proposed doing very simple thing. It drops only packets from
the same namespace in the pneigh_queue_purge() where network interface
state change is detected. This is enough to prevent the problem for the
whole node preserving original semantics of the code.

Investigated-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
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
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 net/core/neighbour.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 54625287ee5b..213ec0be800b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -307,14 +307,24 @@ static int neigh_del_timer(struct neighbour *n)
 	return 0;
 }
 
-static void pneigh_queue_purge(struct sk_buff_head *list)
+static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 {
+	unsigned long flags;
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(list)) != NULL) {
-		dev_put(skb->dev);
-		kfree_skb(skb);
+	spin_lock_irqsave(&list->lock, flags);
+	skb = skb_peek(list);
+	while (skb) {
+		struct sk_buff *skb_next = skb_peek_next(skb, list);
+
+		if (!net || net_eq(dev_net(skb->dev), net)) {
+			__skb_unlink(skb, list);
+			dev_put(skb->dev);
+			kfree_skb(skb);
+		}
+		skb = skb_next;
 	}
+	spin_unlock_irqrestore(&list->lock, flags);
 }
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
@@ -386,8 +396,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
 
-	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
 	return 0;
 }
 
@@ -1787,7 +1796,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	cancel_delayed_work_sync(&tbl->managed_work);
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, NULL);
 	neigh_ifdown(tbl, NULL);
 	if (atomic_read(&tbl->entries))
 		pr_crit("neighbour leakage\n");
-- 
2.36.1

