Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2C5FF391
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 20:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJNS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 14:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJNS0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 14:26:49 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF50E024
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 11:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665772008; x=1697308008;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RZzDrLQNDmNyaciuGxVZcq32zd1lSJJhlrx0Il7njjg=;
  b=p+YMWPzdLyFc0NcRIzStJWS1A6wWif8Y65KhpVjyeR8cpWOfTuYdaPwX
   lS9NaU0whSqAE0cptQghJ4Q3rfGvfMihCMn2eKCWy/t3rP/4c+NO2wX3b
   SrtaxvzQGKm3VOTmV4uE2aVFFBZcRiqzWzwHYMYDH5zwjngLuJQXra5bR
   M=;
X-IronPort-AV: E=Sophos;i="5.95,185,1661817600"; 
   d="scan'208";a="252115282"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 18:26:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id B4F2781434;
        Fri, 14 Oct 2022 18:26:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 14 Oct 2022 18:26:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 14 Oct 2022 18:26:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
CC:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net] udp: Update reuse->has_conns under reuseport_lock.
Date:   Fri, 14 Oct 2022 11:26:25 -0700
Message-ID: <20221014182625.89913-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we call connect() for a UDP socket in a reuseport group, we have
to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
could select a unconnected socket wrongly for packets sent to the
connected socket.

However, the current way to set has_conns is illegal and possible to
trigger that problem.  reuseport_has_conns() changes has_conns under
rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
it must do the update under the updater's lock, reuseport_lock, but
it doesn't for now.

For this reason, there is a race below where we fail to set has_conns
resulting in the wrong socket selection.  To avoid the race, let's split
the reader and updater with proper locking.

 cpu1                               cpu2
+----+                             +----+

__ip[46]_datagram_connect()        reuseport_grow()
.                                  .
|- reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
|  .                               |
|  |- rcu_read_lock()
|  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
|  |
|  |                               |  /* reuse->has_conns == 0 here */
|  |                               |- more_reuse->has_conns = reuse->has_conns
|  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
|  |                               |
|  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
|  |                               |                     more_reuse)
|  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
|
|- sk->sk_state = TCP_ESTABLISHED

Note the likely(reuse) in reuseport_has_conns_set() is always true,
but we put the test there for ease of review.  [0]

For the record, usually, sk_reuseport_cb is changed under lock_sock().
The only exception is reuseport_grow() & TCP reqsk migration case.

  1) shutdown() TCP listener, which is moved into the latter part of
     reuse->socks[] to migrate reqsk.

  2) New listen() overflows reuse->socks[] and call reuseport_grow().

  3) reuse->max_socks overflows u16 with the new listener.

  4) reuseport_grow() pops the old shutdown()ed listener from the array
     and update its sk->sk_reuseport_cb as NULL without lock_sock().

shutdown()ed TCP sk->sk_reuseport_cb can be changed without lock_sock(),
but, reuseport_has_conns_set() is called only for UDP under lock_sock(),
so likely(reuse) never be false in reuseport_has_conns_set().

[0]: https://lore.kernel.org/netdev/CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com/

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v3:
  * Add likely(reuse) in reuseport_has_conns_set()
  * Use _bh() locking in reuseport_has_conns_set()

v2: https://lore.kernel.org/netdev/20221012185243.88948-1-kuniyu@amazon.com/
  * Fix build failure for CONFIG_IPV6=m
  * Drop SO_INCOMING_CPU fix (will be sent for net-next after merge window)

v1: https://lore.kernel.org/netdev/20221010174351.11024-1-kuniyu@amazon.com/
---
 include/net/sock_reuseport.h | 11 +++++------
 net/core/sock_reuseport.c    | 16 ++++++++++++++++
 net/ipv4/datagram.c          |  2 +-
 net/ipv4/udp.c               |  2 +-
 net/ipv6/datagram.c          |  2 +-
 net/ipv6/udp.c               |  2 +-
 6 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 473b0b0fa4ab..efc9085c6892 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
-static inline bool reuseport_has_conns(struct sock *sk, bool set)
+static inline bool reuseport_has_conns(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
 	bool ret = false;
 
 	rcu_read_lock();
 	reuse = rcu_dereference(sk->sk_reuseport_cb);
-	if (reuse) {
-		if (set)
-			reuse->has_conns = 1;
-		ret = reuse->has_conns;
-	}
+	if (reuse && reuse->has_conns)
+		ret = true;
 	rcu_read_unlock();
 
 	return ret;
 }
 
+void reuseport_has_conns_set(struct sock *sk);
+
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 5daa1fa54249..fb90e1e00773 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -21,6 +21,22 @@ static DEFINE_IDA(reuseport_ida);
 static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
 			       struct sock_reuseport *reuse, bool bind_inany);
 
+void reuseport_has_conns_set(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return;
+
+	spin_lock_bh(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	if (likely(reuse))
+		reuse->has_conns = 1;
+	spin_unlock_bh(&reuseport_lock);
+}
+EXPORT_SYMBOL(reuseport_has_conns_set);
+
 static int reuseport_sock_index(struct sock *sk,
 				const struct sock_reuseport *reuse,
 				bool closed)
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 405a8c2aea64..5e66add7befa 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = prandom_u32();
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d63118ce5900..29228231b058 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -448,7 +448,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index df665d4e8f0f..5ecb56522f9d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 91e795bb9ade..56e4523a3004 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -182,7 +182,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
-- 
2.30.2

