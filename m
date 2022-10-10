Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C115FA2D6
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJJRoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJJRow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:44:52 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C914001;
        Mon, 10 Oct 2022 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665423890; x=1696959890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cEYe75lf39NbvHuzf7+Ww4Mv5GZJeDIvvrLUvbELky0=;
  b=mawTZGayKCZxBAnL/Yun2kI+198CuIZhPzNThJYAQPEJA219x2IbtvQq
   XHOCrwtAYChkxFMtAcDMkuRmfTOyNuJ/BDF5n7b+YcBdlZ3q15MUekjzJ
   H8x52OHaUtyb4yCA8G2YmQy+SzRhrq8bxqH4ZEV/5UeJ10epVdFzaJOyz
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,173,1661817600"; 
   d="scan'208";a="232124636"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 17:44:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 5B62FC0822;
        Mon, 10 Oct 2022 17:44:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 10 Oct 2022 17:44:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 10 Oct 2022 17:44:20 +0000
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 1/3] udp: Update reuse->has_conns under reuseport_lock.
Date:   Mon, 10 Oct 2022 10:43:49 -0700
Message-ID: <20221010174351.11024-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010174351.11024-1-kuniyu@amazon.com>
References: <20221010174351.11024-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/sock_reuseport.h | 23 +++++++++++++++++------
 net/ipv4/datagram.c          |  2 +-
 net/ipv4/udp.c               |  2 +-
 net/ipv6/datagram.c          |  2 +-
 net/ipv6/udp.c               |  2 +-
 5 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 473b0b0fa4ab..fe9779e6d90f 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -43,21 +43,32 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
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
 
+static inline void reuseport_has_conns_set(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return;
+
+	spin_lock(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	reuse->has_conns = 1;
+	spin_unlock(&reuseport_lock);
+}
+
 #endif  /* _SOCK_REUSEPORT_H */
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

