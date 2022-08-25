Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0D35A06CD
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiHYBqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiHYBpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2782B9D10D;
        Wed, 24 Aug 2022 18:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 396E3B824CF;
        Thu, 25 Aug 2022 01:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2254C433D6;
        Thu, 25 Aug 2022 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391609;
        bh=OgC7F0v8PGHE37eRWh5jyrs87XxYqgqDDauPfgr4s3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsMuvJADHq/AnXl5qcLltJsYeayzsxxrzchiNknibpFRN7s76CwP7WjAXd+0IAsCG
         H3Vn0avm5z4OoZQrfZbx2Zq0gw7U37mWzqQlUNQbDZXQ8lTKb+/rauBMe53VmLODfw
         Mraeqw9oYHZpxq46SfQ94HS8pYaaFl1oCOwabdqlg+phXHcJq8bfumiYUjimaJY68o
         WxMa7fgF+hFvQ0sJ8p7jrBtEZzK1QVrytLe3dPZ8XEmPTCC7YIiY6S5RgLbu3r2jEe
         drgtbRgTetsTG4rHTfZZHOrX8peQ7K81RGcSu0AYGqzowB105ZSEvukumV7SkU29BJ
         5DSLUULDXRkDQ==
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
Subject: [PATCH AUTOSEL 4.19 2/5] neigh: fix possible DoS due to net iface start/stop loop
Date:   Wed, 24 Aug 2022 21:39:56 -0400
Message-Id: <20220825014001.24008-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825014001.24008-1-sashal@kernel.org>
References: <20220825014001.24008-1-sashal@kernel.org>
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
index 6233e9856016..65e80aaa0948 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -224,14 +224,23 @@ static int neigh_del_timer(struct neighbour *n)
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
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev)
@@ -297,9 +306,9 @@ int neigh_ifdown(struct neigh_table *tbl, struct net_device *dev)
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev);
 	pneigh_ifdown_and_unlock(tbl, dev);
-
-	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	if (skb_queue_empty_lockless(&tbl->proxy_queue))
+		del_timer_sync(&tbl->proxy_timer);
 	return 0;
 }
 EXPORT_SYMBOL(neigh_ifdown);
@@ -1614,7 +1623,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
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

