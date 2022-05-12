Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73865256E7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358444AbiELVPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358648AbiELVPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:15:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D495DD1F
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:15:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so8969845pjb.3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9k7KSz7fN+Q1qp/+CDBC/LhBFq9Ay67EDzB3BsVaAeQ=;
        b=fWnXULjRym35AYBdL36CDTM1y3MN3A+MX84EDii2nbRjBzzFQaSO3l34HBhjjxcrIw
         zOFbe/3T9B9GLjOk6EmbD51CTBQsyLHAvBocVJE11cvl10rSfGzQiPQt+lUsf5XJEDVz
         yEhuAnnFgHzYU03+FBamlx7GNsW3M0PmOeMC4hgiUhsJDNnFxaXf6IW5TYDilRPZHE7Q
         Bqc0mMHf4XBlPIquQfrgmLWQld0YHlWCKAEtHEPZ/nQx/IZPG4X/ThFP6/c14/3ALYyq
         A1lENN8OY6f6U2HIVX9EtYzfpswGbJlCkZyRQfMctYETFEQJ6zAGPOemfi0ECORfl6un
         +sCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9k7KSz7fN+Q1qp/+CDBC/LhBFq9Ay67EDzB3BsVaAeQ=;
        b=E4Hk6lyYCZtxyaQXN08RAvXRsSb1JGwps8SP9K7O6lbO3gTVtETR5PJ1EK/vUL4az6
         3bFc4XYvpYjD+VCzOg4BU//2OujE/cm1vmAfDBrjHPqct0DOmCTH3eF6nB0WUO9MeVZo
         EkttrQnGMKwQBqnSWZbvta4Aegu+YLzCLE+jEIx4pdWO0iif+kBs2Sj0QMmjGUueX64N
         NF0Rc85rn7Pp0Bv6TcmCdj9BXKRSoAuJQNURzynyTmOHi6+ircxLvdKYNhHLDgKCxpYw
         mygIvq98EmQ/bUgeQYUEe3fd0j0B8OH157UIqp3VO6tWSnG4gpHXYjUhN9RbkMEWPoKl
         Az8A==
X-Gm-Message-State: AOAM530tHrU6Qn+m5Ju3zchRDviR7eX6YGOLS+3QFglcgGw/fXuu9O3M
        8EWqk2dVIycMcrkIiCTINE2/MQvEZ10=
X-Google-Smtp-Source: ABdhPJx8pCEvub5IDFUnWJB1CDcpeNvGa0PYY+qOBMpQaZFzo67zWHWGOndlf51xUwtC7INtp+0LbA==
X-Received: by 2002:a17:90a:eb06:b0:1dd:5ea:1ea8 with SMTP id j6-20020a17090aeb0600b001dd05ea1ea8mr1425349pjz.106.1652390102376;
        Thu, 12 May 2022 14:15:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c0b4:779e:76dd:6916])
        by smtp.gmail.com with ESMTPSA id o22-20020a17090ac09600b001d9acbc3b4esm234209pjs.47.2022.05.12.14.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 14:15:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>
Subject: [PATCH net] Revert "tcp/dccp: get rid of inet_twsk_purge()"
Date:   Thu, 12 May 2022 14:14:56 -0700
Message-Id: <20220512211456.2680273-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commits:

0dad4087a86a2cbe177404dc73f18ada26a2c390 ("tcp/dccp: get rid of inet_twsk_purge()")
d507204d3c5cc57d9a8bdf0a477615bb59ea1611 ("tcp/dccp: add tw->tw_bslot")

As Leonard pointed out, a newly allocated netns can happen
to reuse a freed 'struct net'.

While TCP TW timers were covered by my patches, other things were not:

1) Lookups in rx path (INET_MATCH() and INET6_MATCH()), as they look
  at 4-tuple plus the 'struct net' pointer.

2) /proc/net/tcp[6] and inet_diag, same reason.

3) hashinfo->bhash[], same reason.

Fixing all this seems risky, lets instead revert.

In the future, we might have a per netns tcp hash table, or
a per netns list of timewait sockets...

Fixes: 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/inet_timewait_sock.h |  3 +-
 net/dccp/ipv4.c                  |  6 ++++
 net/dccp/ipv6.c                  |  6 ++++
 net/ipv4/inet_timewait_sock.c    | 58 ++++++++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c              |  2 ++
 net/ipv6/tcp_ipv6.c              |  6 ++++
 6 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 463ae5d33eb09c40caeb4d039af268609b5e563b..5b47545f22d39eb2dd9725ac37bd7d7a9016a03c 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -71,7 +71,6 @@ struct inet_timewait_sock {
 				tw_tos		: 8;
 	u32			tw_txhash;
 	u32			tw_priority;
-	u32			tw_bslot; /* bind bucket slot */
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
 };
@@ -110,6 +109,8 @@ static inline void inet_twsk_reschedule(struct inet_timewait_sock *tw, int timeo
 
 void inet_twsk_deschedule_put(struct inet_timewait_sock *tw);
 
+void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family);
+
 static inline
 struct net *twsk_net(const struct inet_timewait_sock *twsk)
 {
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index ae662567a6cb6a440c79a9805a2cd6d146ac5a29..0ea29270d7e53730d14ec43654be8f956f891552 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -1030,9 +1030,15 @@ static void __net_exit dccp_v4_exit_net(struct net *net)
 	inet_ctl_sock_destroy(pn->v4_ctl_sk);
 }
 
+static void __net_exit dccp_v4_exit_batch(struct list_head *net_exit_list)
+{
+	inet_twsk_purge(&dccp_hashinfo, AF_INET);
+}
+
 static struct pernet_operations dccp_v4_ops = {
 	.init	= dccp_v4_init_net,
 	.exit	= dccp_v4_exit_net,
+	.exit_batch = dccp_v4_exit_batch,
 	.id	= &dccp_v4_pernet_id,
 	.size   = sizeof(struct dccp_v4_pernet),
 };
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index eab3bd1ee9a0a0064c04ff97fd8363e60daa0079..fa663518fa0e465458b7486ad0cd0672425f08b0 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1115,9 +1115,15 @@ static void __net_exit dccp_v6_exit_net(struct net *net)
 	inet_ctl_sock_destroy(pn->v6_ctl_sk);
 }
 
+static void __net_exit dccp_v6_exit_batch(struct list_head *net_exit_list)
+{
+	inet_twsk_purge(&dccp_hashinfo, AF_INET6);
+}
+
 static struct pernet_operations dccp_v6_ops = {
 	.init   = dccp_v6_init_net,
 	.exit   = dccp_v6_exit_net,
+	.exit_batch = dccp_v6_exit_batch,
 	.id	= &dccp_v6_pernet_id,
 	.size   = sizeof(struct dccp_v6_pernet),
 };
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 9e0bbd02656013e6e8be5765a7b86fc16e6bf831..0ec501845cb3bb51082f8091b4e0ebb32f83bf33 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -52,7 +52,8 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	spin_unlock(lock);
 
 	/* Disassociate with bind bucket. */
-	bhead = &hashinfo->bhash[tw->tw_bslot];
+	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), tw->tw_num,
+			hashinfo->bhash_size)];
 
 	spin_lock(&bhead->lock);
 	inet_twsk_bind_unhash(tw, hashinfo);
@@ -111,12 +112,8 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	   Note, that any socket with inet->num != 0 MUST be bound in
 	   binding cache, even if it is closed.
 	 */
-	/* Cache inet_bhashfn(), because 'struct net' might be no longer
-	 * available later in inet_twsk_kill().
-	 */
-	tw->tw_bslot = inet_bhashfn(twsk_net(tw), inet->inet_num,
-				    hashinfo->bhash_size);
-	bhead = &hashinfo->bhash[tw->tw_bslot];
+	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
+			hashinfo->bhash_size)];
 	spin_lock(&bhead->lock);
 	tw->tw_tb = icsk->icsk_bind_hash;
 	WARN_ON(!icsk->icsk_bind_hash);
@@ -257,3 +254,50 @@ void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo, bool rearm)
 	}
 }
 EXPORT_SYMBOL_GPL(__inet_twsk_schedule);
+
+void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
+{
+	struct inet_timewait_sock *tw;
+	struct sock *sk;
+	struct hlist_nulls_node *node;
+	unsigned int slot;
+
+	for (slot = 0; slot <= hashinfo->ehash_mask; slot++) {
+		struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
+restart_rcu:
+		cond_resched();
+		rcu_read_lock();
+restart:
+		sk_nulls_for_each_rcu(sk, node, &head->chain) {
+			if (sk->sk_state != TCP_TIME_WAIT)
+				continue;
+			tw = inet_twsk(sk);
+			if ((tw->tw_family != family) ||
+				refcount_read(&twsk_net(tw)->ns.count))
+				continue;
+
+			if (unlikely(!refcount_inc_not_zero(&tw->tw_refcnt)))
+				continue;
+
+			if (unlikely((tw->tw_family != family) ||
+				     refcount_read(&twsk_net(tw)->ns.count))) {
+				inet_twsk_put(tw);
+				goto restart;
+			}
+
+			rcu_read_unlock();
+			local_bh_disable();
+			inet_twsk_deschedule_put(tw);
+			local_bh_enable();
+			goto restart_rcu;
+		}
+		/* If the nulls value we got at the end of this lookup is
+		 * not the expected one, we must restart lookup.
+		 * We probably met an item that was moved to another chain.
+		 */
+		if (get_nulls_value(node) != slot)
+			goto restart;
+		rcu_read_unlock();
+	}
+}
+EXPORT_SYMBOL_GPL(inet_twsk_purge);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f9cec624068dfa1d218357d7e88c89459d7d54f4..457f5b5d5d4a95c06eca82db1dbe7822cb4d040c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3173,6 +3173,8 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
+	inet_twsk_purge(&tcp_hashinfo, AF_INET);
+
 	list_for_each_entry(net, net_exit_list, exit_list)
 		tcp_fastopen_ctx_destroy(net);
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 13678d3908fac9990e5b0c0df87fa4cca685baaf..faaddaf43c90b96e7a2bc9fbad7941ae5ada1b3c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2207,9 +2207,15 @@ static void __net_exit tcpv6_net_exit(struct net *net)
 	inet_ctl_sock_destroy(net->ipv6.tcp_sk);
 }
 
+static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
+{
+	inet_twsk_purge(&tcp_hashinfo, AF_INET6);
+}
+
 static struct pernet_operations tcpv6_net_ops = {
 	.init	    = tcpv6_net_init,
 	.exit	    = tcpv6_net_exit,
+	.exit_batch = tcpv6_net_exit_batch,
 };
 
 int __init tcpv6_init(void)
-- 
2.36.0.550.gb090851708-goog

