Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96F5AB01B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiIBMtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbiIBMsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26532D5735;
        Fri,  2 Sep 2022 05:35:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACB7621D8;
        Fri,  2 Sep 2022 12:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E65CC433D6;
        Fri,  2 Sep 2022 12:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122011;
        bh=RAQlFA1OIGDbziGH6iSCHQIyr2VXKo3315hzhKZgPwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK8nhtpw1DZU+QXbGbNsKUFPQ3jRHnyIphChQ7KYP/dHxVdYCA78S3oY07isTle8y
         EPZidTtkXpuuHNLyPIKGfjUXq3Ak7mKJKLYNOVvFmwvRhjWD/axQYdQxgHw6X02dsd
         c41QYZCnIrKzoju2hycsO3Uh6azYktKnWKxCm0P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        kernel@openvz.org, devel@openvz.org,
        "Denis V. Lunev" <den@openvz.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/73] neigh: fix possible DoS due to net iface start/stop loop
Date:   Fri,  2 Sep 2022 14:19:21 +0200
Message-Id: <20220902121406.312414201@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 66ba215cb51323e4e55e38fd5f250e0fae0cbc94 ]

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

v2:
	- do del_timer_sync() if queue is empty after pneigh_queue_purge()
v3:
	- rebase to net tree

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: kernel@openvz.org
Cc: devel@openvz.org
Investigated-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ff049733cceeb..f0be42c140b91 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -279,14 +279,23 @@ static int neigh_del_timer(struct neighbour *n)
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
+	while (skb != NULL) {
+		struct sk_buff *skb_next = skb_peek_next(skb, list);
+		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
+			__skb_unlink(skb, list);
+			dev_put(skb->dev);
+			kfree_skb(skb);
+		}
+		skb = skb_next;
 	}
+	spin_unlock_irqrestore(&list->lock, flags);
 }
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
@@ -357,9 +366,9 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
-
-	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	if (skb_queue_empty_lockless(&tbl->proxy_queue))
+		del_timer_sync(&tbl->proxy_timer);
 	return 0;
 }
 
@@ -1735,7 +1744,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	/* It is not clean... Fix it to unload IPv6 module safely */
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, NULL);
 	neigh_ifdown(tbl, NULL);
 	if (atomic_read(&tbl->entries))
 		pr_crit("neighbour leakage\n");
-- 
2.35.1



