Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14D499C12
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380536AbiAXV7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456633AbiAXVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:40 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5463C0417D0
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:10 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b15so2411196plg.3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNxS8TBCqY8UJ60TjmZ6Gzdxol6+WtmgOAooWcnjlsY=;
        b=jt2JUF4Z5UoX7PyRhVuAZzq7XZJT/YTN8nn2qZUHRmprV7ivPHQ6elvlCFqdfOQhB3
         4wTjIBXhWltSx8XgTobzTkMF9A4W922560GoRHwY84aVX6u6ZDLcKfanpG0J1SRsP7sY
         P80IGUHju7r3QCy+h3z25pNihm1c9yIOKf7anai3qLXypk4SGWKHj5mc7uGhVfNh6KZA
         JR0clmstqf9zZE7u4gbC0i6IU2RrjFDkR8TwfzHFhSmsByJEC53JgZmpoNDzkr1hCPRf
         JX3Flm4Fe67GmGN7kJa4XSzPsQSuUD8kJ2igvqhBqOXN4rr7hbdLTDmsrX9h9mIY36lR
         I7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNxS8TBCqY8UJ60TjmZ6Gzdxol6+WtmgOAooWcnjlsY=;
        b=ICecVJGVbJIEdDrEM8N6hGIyHJkEYM3il+sy/vQqvzQDoJz/8AU33NQhefOeXIJs47
         AVTcIx7mkCJCKFOsy0BMiCZAXd70gqF30O1k5x41sUYBqW6BXEn808uhrOd8GkAj0LD+
         xXUT88jtV30xBommunSETrYNhHbYCmojgB5fW92NxIFvOST0rE4i7XIK9JEXehZ3AErp
         kMPvOIc1g+Ua9iTCTEtWXUCFK53vksBaiOZOnAAYfJwW/4V3L++4SJ/S3IjR7cZ5jRMa
         uBx2dR8TL7rAoVqbfkf8g6SyKLvipRnI2PN/1Lsk4MF8pId6cyfiO/UFvKHrM7LWNGql
         ofpA==
X-Gm-Message-State: AOAM531+CELYvHyV84YhWP11tpy//2xyNw2uud+9L8Nt5xn0sKdJnTyd
        gWtqOOkoP4Nt4ofkzvRvfsc=
X-Google-Smtp-Source: ABdhPJzUfXZ6KVPfia6ZOrHeIBXfmje5VtNlXKlTPZIfTimT4C9ylHEyDWGJI1DPMWr0LeBPqmyYAQ==
X-Received: by 2002:a17:90b:4f83:: with SMTP id qe3mr24040pjb.203.1643055910273;
        Mon, 24 Jan 2022 12:25:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/6] tcp/dccp: get rid of inet_twsk_purge()
Date:   Mon, 24 Jan 2022 12:24:54 -0800
Message-Id: <20220124202457.3450198-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Prior patches in the series made sure tw_timer_handler()
can be fired after netns has been dismantled/freed.

We no longer have to scan a potentially big TCP ehash
table at netns dismantle.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_timewait_sock.h |  2 --
 net/dccp/ipv4.c                  |  6 ----
 net/dccp/ipv6.c                  |  6 ----
 net/ipv4/inet_timewait_sock.c    | 47 --------------------------------
 net/ipv4/tcp_ipv4.c              |  2 --
 net/ipv6/tcp_ipv6.c              |  6 ----
 6 files changed, 69 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index b323db969b8b6df98ad84a9bb9aad646b4a8730c..463ae5d33eb09c40caeb4d039af268609b5e563b 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -110,8 +110,6 @@ static inline void inet_twsk_reschedule(struct inet_timewait_sock *tw, int timeo
 
 void inet_twsk_deschedule_put(struct inet_timewait_sock *tw);
 
-void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family);
-
 static inline
 struct net *twsk_net(const struct inet_timewait_sock *twsk)
 {
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 0ea29270d7e53730d14ec43654be8f956f891552..ae662567a6cb6a440c79a9805a2cd6d146ac5a29 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -1030,15 +1030,9 @@ static void __net_exit dccp_v4_exit_net(struct net *net)
 	inet_ctl_sock_destroy(pn->v4_ctl_sk);
 }
 
-static void __net_exit dccp_v4_exit_batch(struct list_head *net_exit_list)
-{
-	inet_twsk_purge(&dccp_hashinfo, AF_INET);
-}
-
 static struct pernet_operations dccp_v4_ops = {
 	.init	= dccp_v4_init_net,
 	.exit	= dccp_v4_exit_net,
-	.exit_batch = dccp_v4_exit_batch,
 	.id	= &dccp_v4_pernet_id,
 	.size   = sizeof(struct dccp_v4_pernet),
 };
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fa663518fa0e465458b7486ad0cd0672425f08b0..eab3bd1ee9a0a0064c04ff97fd8363e60daa0079 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1115,15 +1115,9 @@ static void __net_exit dccp_v6_exit_net(struct net *net)
 	inet_ctl_sock_destroy(pn->v6_ctl_sk);
 }
 
-static void __net_exit dccp_v6_exit_batch(struct list_head *net_exit_list)
-{
-	inet_twsk_purge(&dccp_hashinfo, AF_INET6);
-}
-
 static struct pernet_operations dccp_v6_ops = {
 	.init   = dccp_v6_init_net,
 	.exit   = dccp_v6_exit_net,
-	.exit_batch = dccp_v6_exit_batch,
 	.id	= &dccp_v6_pernet_id,
 	.size   = sizeof(struct dccp_v6_pernet),
 };
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index e37e4852711c52bf8f6d01877297266cd19294ed..71808c7a7025c0a3a811b629a7796ad148152a4c 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -255,50 +255,3 @@ void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo, bool rearm)
 	}
 }
 EXPORT_SYMBOL_GPL(__inet_twsk_schedule);
-
-void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
-{
-	struct inet_timewait_sock *tw;
-	struct sock *sk;
-	struct hlist_nulls_node *node;
-	unsigned int slot;
-
-	for (slot = 0; slot <= hashinfo->ehash_mask; slot++) {
-		struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
-restart_rcu:
-		cond_resched();
-		rcu_read_lock();
-restart:
-		sk_nulls_for_each_rcu(sk, node, &head->chain) {
-			if (sk->sk_state != TCP_TIME_WAIT)
-				continue;
-			tw = inet_twsk(sk);
-			if ((tw->tw_family != family) ||
-				refcount_read(&twsk_net(tw)->ns.count))
-				continue;
-
-			if (unlikely(!refcount_inc_not_zero(&tw->tw_refcnt)))
-				continue;
-
-			if (unlikely((tw->tw_family != family) ||
-				     refcount_read(&twsk_net(tw)->ns.count))) {
-				inet_twsk_put(tw);
-				goto restart;
-			}
-
-			rcu_read_unlock();
-			local_bh_disable();
-			inet_twsk_deschedule_put(tw);
-			local_bh_enable();
-			goto restart_rcu;
-		}
-		/* If the nulls value we got at the end of this lookup is
-		 * not the expected one, we must restart lookup.
-		 * We probably met an item that was moved to another chain.
-		 */
-		if (get_nulls_value(node) != slot)
-			goto restart;
-		rcu_read_unlock();
-	}
-}
-EXPORT_SYMBOL_GPL(inet_twsk_purge);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b3f34e366b27f7f1aece164aa485b1e9a7248d93..8e94b99882044d3d9927d83512d18f34dc2f5b43 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3239,8 +3239,6 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	inet_twsk_purge(&tcp_hashinfo, AF_INET);
-
 	list_for_each_entry(net, net_exit_list, exit_list)
 		tcp_fastopen_ctx_destroy(net);
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 075ee8a2df3b7f3759f69f1b1256f2e8c9c700c1..1e55ee98dfedac67a591a8a04ce98f334a4b8b7c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2237,15 +2237,9 @@ static void __net_exit tcpv6_net_exit(struct net *net)
 	inet_ctl_sock_destroy(net->ipv6.tcp_sk);
 }
 
-static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
-{
-	inet_twsk_purge(&tcp_hashinfo, AF_INET6);
-}
-
 static struct pernet_operations tcpv6_net_ops = {
 	.init	    = tcpv6_net_init,
 	.exit	    = tcpv6_net_exit,
-	.exit_batch = tcpv6_net_exit_batch,
 };
 
 int __init tcpv6_init(void)
-- 
2.35.0.rc0.227.g00780c9af4-goog

