Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D33F5A05DF
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiHYBgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiHYBff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF4D979D6;
        Wed, 24 Aug 2022 18:35:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE1861ACE;
        Thu, 25 Aug 2022 01:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F8DC433D6;
        Thu, 25 Aug 2022 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391332;
        bh=z/uhC9Z16jR4A8onNZPzAkTldFPJ8DZ1qq+Ttlzh6ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM9YRp+RiElWxiFXonaXW6H4bL36Bvc7ThGdXq+ouYFSV6B326fOlXWCVQJLkFHgO
         7z8xf3ziUCG8Ql+aJRnxVIS4BpPpAlx8ZNyYKOqCo7aBNoGf1uuxkzRuiuBqPuX0SB
         jcvRegKd5s5tdOIV4uemEPTdbqS/ACR3QwrNnkD++idC8haMTdBIVUS+X5BkdPlR6i
         1g7RhNFJ5fj1nFMjSDnrZrJDdMEtcC5F3bsAI0isfGGBAf2EVd2sgLm4Tg+kKq+kf1
         X63FA4n6HUWoPlzAQTgJkOhweLcvKIWyz4KxF0zAvFcP/Ci2P4lnFbDEQPLqDso91c
         FsNdMo5ulxNzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Denis V. Lunev" <den@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
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
        Sasha Levin <sashal@kernel.org>, wangyuweihx@gmail.com
Subject: [PATCH AUTOSEL 5.19 17/38] neigh: fix possible DoS due to net iface start/stop loop
Date:   Wed, 24 Aug 2022 21:33:40 -0400
Message-Id: <20220825013401.22096-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Denis V. Lunev" <den@openvz.org>

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
index 54625287ee5b..19d99d1eff53 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -307,14 +307,23 @@ static int neigh_del_timer(struct neighbour *n)
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
@@ -385,9 +394,9 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
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
2.35.1

