Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE22B2449
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKMTJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKMTJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:09:40 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52AEC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:09:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 33so11226150wrl.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=+iOLnrc0hvizg2xwbP3eUh2USfs+s6GfS50BoVNK02I=;
        b=SWZtNOfZbsiknKP3od9nqZOTwbz9eSLjGStDCTH+KqMjlDoEixkJ+hEqYS6SpCAc6v
         Pg9cBsboFR+XZmUcAd854qweTHRRTMNa/UnYRxIcy+7P2U1S6WWalcUXF96cbhREVuJc
         WaNC0ZrG1sUmBP5TTOCjq50cj9lhFoRcgrprcaBnU2K/JZuyzh51gQwTLPJmNVB8xEo+
         C3K6ZiXrkCS+bs92WjMyXcyqaG9PcsHJPp0UFlOw2c5TA5QofvWMfM2DrNjTxdKe28DX
         gTDN9o4PCYR1O3yOjzOyAon0XXMfIM/LPvjcVPfXVKZnjWPxJQIZ2JXbsKD8a/Ez5jWE
         hxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+iOLnrc0hvizg2xwbP3eUh2USfs+s6GfS50BoVNK02I=;
        b=UK9zZ4RvClLPlsJ9M6aYnw/6sXC4JIzv2vejINoUZIaHOP5evyoHgXt2aoBMB2xLhj
         byj/BAtdK/OwD7yjv9hv1mU0UXP/ubbdGmAETKebXQ4Elw6cPDcfbRpD3UFtp6JwlZ8e
         Je6gRYO/45wFIbS9MFkO/BLKD2QqnZ2zkwl0Pc0ICB7kkYdQLZQ7jbURblhv1ASUP1Bw
         qpNKUfr0fn8m5pw7sEVobQ7l42UgNQnhLyIvZtYW/dvMGUpPDWoGI8J/rBrWJWlBUk6U
         Q5So99N9KHormh4RaNbTmFKkLhJNurM0xp2XqEWyMbSb7CMRSlVDsNoPapLwtQy9rD9X
         9IzQ==
X-Gm-Message-State: AOAM53190IBrZp50W9289a8qQ3y7cueoKxJhNi9xnc38yR2/i08S11Nd
        om42gioV+8c1DY8Sg3xgi/JPSA==
X-Google-Smtp-Source: ABdhPJzOkka4AiKQgJ+oE5Uo3yi0uijqy+6QMIyvrW5He2tcKKDVZJiViKin69rCV0SuMZjzPKFDSg==
X-Received: by 2002:a5d:6411:: with SMTP id z17mr5319266wru.112.1605294578429;
        Fri, 13 Nov 2020 11:09:38 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id a18sm10638411wmm.22.2020.11.13.11.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 11:09:37 -0800 (PST)
Date:   Fri, 13 Nov 2020 19:09:35 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201113190935.GA106934@rdias-suse-pc.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the TCP stack is in SYN flood mode, the server child socket is
created from the SYN cookie received in a TCP packet with the ACK flag
set.

The child socket is created when the server receives the first TCP
packet with a valid SYN cookie from the client. Usually, this packet
corresponds to the final step of the TCP 3-way handshake, the ACK
packet. But is also possible to receive a valid SYN cookie from the
first TCP data packet sent by the client, and thus create a child socket
from that SYN cookie.

Since a client socket is ready to send data as soon as it receives the
SYN+ACK packet from the server, the client can send the ACK packet (sent
by the TCP stack code), and the first data packet (sent by the userspace
program) almost at the same time, and thus the server will equally
receive the two TCP packets with valid SYN cookies almost at the same
instant.

When such event happens, the TCP stack code has a race condition that
occurs between the momement a lookup is done to the established
connections hashtable to check for the existence of a connection for the
same client, and the moment that the child socket is added to the
established connections hashtable. As a consequence, this race condition
can lead to a situation where we add two child sockets to the
established connections hashtable and deliver two sockets to the
userspace program to the same client.

This patch fixes the race condition by checking if an existing child
socket exists for the same client when we are adding the second child
socket to the established connections socket. If an existing child
socket exists, we return that socket and use it to process the TCP
packet received, and discard the second child socket to the same client.

Signed-off-by: Ricardo Dias <rdias@singlestore.com>
---
v4 (2020-11-12):
  * Added `struct sock **esk) parameter to `inet_ehash_insert`.
  * Fixed ref count increment in `inet_ehash_insert`.
  * Fixed callers of inet_ehash_nolisten.

v3 (2020-11-11):
  * Fixed IPv6 handling in inet_ehash_insert
  * Removed unecessary comparison while traversing the ehash bucket
    list.
 
v2 (2020-11-09):
  * Changed the author's email domain.
  * Removed the helper function inet_ehash_insert_chk_dup and moved the
    logic to the existing inet_ehash_insert.
  * Updated the callers of iner_ehash_nolisten to deal with the new
    logic.

 include/net/inet_hashtables.h   |  4 +--
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/inet_hashtables.c      | 64 ++++++++++++++++++++++++++++-----
 net/ipv4/syncookies.c           |  5 ++-
 net/ipv4/tcp_ipv4.c             |  9 ++++-
 net/ipv6/tcp_ipv6.c             | 16 ++++++++-
 8 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 92560974ea67..b0abc4dd6d49 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -247,8 +247,8 @@ void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 			 unsigned long high_limit);
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h);
 
-bool inet_ehash_insert(struct sock *sk, struct sock *osk);
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, struct sock **esk);
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, struct sock **esk);
 int __inet_hash(struct sock *sk, struct sock *osk);
 int inet_hash(struct sock *sk);
 void inet_unhash(struct sock *sk);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 9c28c8251125..098bae35ab76 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -427,7 +427,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	if (*own_req)
 		ireq->ireq_opt = NULL;
 	else
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index ef4ab28cfde0..78ee1b5acf1f 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -533,7 +533,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		dccp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
 		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index b457dd2d6c75..df26489e4f6c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -787,7 +787,7 @@ static void reqsk_queue_hash_req(struct request_sock *req,
 	timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
 	mod_timer(&req->rsk_timer, jiffies + timeout);
 
-	inet_ehash_insert(req_to_sk(req), NULL);
+	inet_ehash_insert(req_to_sk(req), NULL, NULL);
 	/* before letting lookups find us, make sure all req fields
 	 * are committed to memory and refcnt initialized.
 	 */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 239e54474b65..bb2fb9385e83 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -20,6 +20,9 @@
 #include <net/addrconf.h>
 #include <net/inet_connection_sock.h>
 #include <net/inet_hashtables.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/inet6_hashtables.h>
+#endif
 #include <net/secure_seq.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -510,17 +513,27 @@ static u32 inet_sk_port_offset(const struct sock *sk)
 					  inet->inet_dport);
 }
 
-/* insert a socket into ehash, and eventually remove another one
- * (The another one can be a SYN_RECV or TIMEWAIT
+/* Insert a socket into ehash, and eventually remove another one
+ * (The another one can be a SYN_RECV or TIMEWAIT)
+ * If an existing socket already exists, it returns that socket
+ * through the esk parameter.
  */
-bool inet_ehash_insert(struct sock *sk, struct sock *osk)
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, struct sock **esk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct hlist_nulls_head *list;
 	struct inet_ehash_bucket *head;
-	spinlock_t *lock;
+	const struct hlist_nulls_node *node;
+	struct sock *_esk;
+	spinlock_t *lock; /* protects hashinfo socket entry */
+	struct net *net = sock_net(sk);
+	const int dif = sk->sk_bound_dev_if;
+	const int sdif = sk->sk_bound_dev_if;
 	bool ret = true;
 
+	INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
+	const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
+
 	WARN_ON_ONCE(!sk_unhashed(sk));
 
 	sk->sk_hash = sk_ehashfn(sk);
@@ -532,16 +545,49 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
 		ret = sk_nulls_del_node_init_rcu(osk);
+	} else if (esk) {
+		sk_nulls_for_each_rcu(_esk, node, list) {
+			if (_esk->sk_hash != sk->sk_hash)
+				continue;
+			if (sk->sk_family == AF_INET) {
+				if (unlikely(INET_MATCH(_esk, net, acookie,
+							sk->sk_daddr,
+							sk->sk_rcv_saddr,
+							ports, dif, sdif))) {
+					refcount_inc(&_esk->sk_refcnt);
+					goto found;
+				}
+			}
+#if IS_ENABLED(CONFIG_IPV6)
+			else if (sk->sk_family == AF_INET6) {
+				if (unlikely(INET6_MATCH(_esk, net,
+							 &sk->sk_v6_daddr,
+							 &sk->sk_v6_rcv_saddr,
+							 ports, dif, sdif))) {
+					refcount_inc(&_esk->sk_refcnt);
+					goto found;
+				}
+			}
+#endif
+		}
+
 	}
+	_esk = NULL;
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
+
+found:
 	spin_unlock(lock);
+	if (_esk) {
+		*esk = _esk;
+		ret = false;
+	}
 	return ret;
 }
 
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk)
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, struct sock **esk)
 {
-	bool ok = inet_ehash_insert(sk, osk);
+	bool ok = inet_ehash_insert(sk, osk, esk);
 
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -585,7 +631,7 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
-		inet_ehash_nolisten(sk, osk);
+		inet_ehash_nolisten(sk, osk, NULL);
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -681,7 +727,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL);
+			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
 		}
@@ -760,7 +806,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
-		inet_ehash_nolisten(sk, (struct sock *)tw);
+		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index e03756631541..c4bb895085f0 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -208,7 +208,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 
 	child = icsk->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
 						 NULL, &own_req);
-	if (child) {
+	if (child && own_req) {
 		refcount_set(&req->rsk_refcnt, 1);
 		tcp_sk(child)->tsoffset = tsoff;
 		sock_rps_save_rxhash(child, skb);
@@ -223,6 +223,9 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 
 		bh_unlock_sock(child);
 		sock_put(child);
+	}  else if (child && !own_req) {
+		__reqsk_free(req);
+		return child;
 	}
 	__reqsk_free(req);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 592c73962723..875b5310fc25 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1501,6 +1501,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	int l3index;
 #endif
 	struct ip_options_rcu *inet_opt;
+	struct sock *esk = NULL;
 
 	if (sk_acceptq_is_full(sk))
 		goto exit_overflow;
@@ -1565,11 +1566,17 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), &esk);
 	if (likely(*own_req)) {
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
+		if (!req_unhash && esk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			newsk = esk;
+		}
 		newinet->inet_opt = NULL;
 	}
 	return newsk;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 305870a72352..dd64ec3b8a43 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1190,6 +1190,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
+	struct sock *esk = NULL;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key;
 	int l3index;
@@ -1206,6 +1207,12 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		if (!newsk)
 			return NULL;
+		else if (!req_unhash && !own_req) {
+			/* We're returning an existing child socket, probably
+			 * created by a previous syncookie ACK.
+			 */
+			return newsk;
+		}
 
 		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
 
@@ -1359,7 +1366,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), &esk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1374,6 +1381,13 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 				skb_set_owner_r(newnp->pktoptions, newsk);
 			}
 		}
+	} else {
+		if (!req_unhash && esk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			newsk = esk;
+		}
 	}
 
 	return newsk;
-- 
2.25.1

