Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC792AEA3B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgKKHfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgKKHfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:35:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FEDC0613D4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:35:50 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r17so1564197wrw.1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=rO/szqiwm4BbNv2jP5Dr48sP1SrvXHFTDLJPTLj/rEc=;
        b=M20WWHx2s8CeBl2XFzu+2zpNnQSqrE4t2/2eFoOiUioYe9Va3CqZuj6bPGfuM70/bT
         E96luilA/PYfP2MqZ1TsbFZu6Zqr0VZItLYRKlYu1A+t6oVuMHG+1nTFdsd0//vttM+W
         f1ruXTk1FQdOzJgMmovnqqojtbf4cWB3nCzkb/W+3WS4uUjH5mxB5VLhSytdkCTrz1LC
         KFDapQpOdcizFG1io1Tdta+SGSMDypeT+Ak9XBMSespcDPTpGdoRUzNclHWgHK1Hr0Gd
         qIkGwiKRHCGoVwAgccpreqZ1WDEM15lRrUu0lXcsKKUhyMkKr4nFiN/HEc0EwZYK2Xqo
         cHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rO/szqiwm4BbNv2jP5Dr48sP1SrvXHFTDLJPTLj/rEc=;
        b=sbLPcRxIx9zLv3TYMiDKPM/3jpempgLDbpveTPIXdTqmO0aom/BHUJgR0vuFk0dqj+
         eZB4I6Vd7lzuVz4tnXxweVrgAQ5Gj01BswF4iL4UKXFWGBRjJF1bypITt3vv6wiBjjry
         Mt3RrlbXTjUuD2OnRvhxZGOn5xoZ4XWg0WFk+mECKLHiRGpMbnJ4f1HZccCNj4HkQmPk
         M57ChZ8oEErNIMgjBPxYomJ8F4jqN+FTwcezTLeQSYGCF71GREhiOyTt7NASSSgRPKXk
         Q9GByyWTt4AmxiyIh5nFPcyruxEs42uzPvUOXoUc9QFurfxvrJUuKD49McYVoDL0ska+
         qFdQ==
X-Gm-Message-State: AOAM531sxtdjlXqGbzyDM+er7+M8OuDZHRYrX0WMiX63vHoxr6o67GLb
        tTe1nglk8bY+IT2+LlvvqSM/mRTt3AQBaGlU3Jo=
X-Google-Smtp-Source: ABdhPJyIC0lJSq2TctrUPLfBwEMjrHC1CRWSWyTudU2odGVz8Z05a+oaO/9NBjGVR3zOXGzATTFnTQ==
X-Received: by 2002:adf:eacb:: with SMTP id o11mr18002030wrn.208.1605080149091;
        Tue, 10 Nov 2020 23:35:49 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id b1sm1472079wmd.43.2020.11.10.23.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 23:35:48 -0800 (PST)
Date:   Wed, 11 Nov 2020 07:35:46 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201111073546.GA1249399@rdias-suse-pc.lan>
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

 include/net/inet_hashtables.h |  6 +--
 net/dccp/ipv4.c               |  4 +-
 net/dccp/ipv6.c               |  4 +-
 net/ipv4/inet_hashtables.c    | 69 ++++++++++++++++++++++++++++++-----
 net/ipv4/syncookies.c         |  5 ++-
 net/ipv4/tcp_ipv4.c           | 10 ++++-
 net/ipv6/tcp_ipv6.c           | 17 ++++++++-
 7 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 92560974ea67..dffa345d52a7 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -247,9 +247,9 @@ void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 			 unsigned long high_limit);
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h);
 
-bool inet_ehash_insert(struct sock *sk, struct sock *osk);
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
-int __inet_hash(struct sock *sk, struct sock *osk);
+bool inet_ehash_insert(struct sock *sk, struct sock **osk);
+bool inet_ehash_nolisten(struct sock *sk, struct sock **osk);
+int __inet_hash(struct sock *sk, struct sock **osk);
 int inet_hash(struct sock *sk);
 void inet_unhash(struct sock *sk);
 
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 9c28c8251125..99bbba478991 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -400,6 +400,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 	struct inet_request_sock *ireq;
 	struct inet_sock *newinet;
 	struct sock *newsk;
+	struct sock *osk;
 
 	if (sk_acceptq_is_full(sk))
 		goto exit_overflow;
@@ -427,7 +428,8 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	osk = req_to_sk(req_unhash);
+	*own_req = inet_ehash_nolisten(newsk, &osk);
 	if (*own_req)
 		ireq->ireq_opt = NULL;
 	else
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index ef4ab28cfde0..91a825c00a97 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -407,6 +407,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	struct inet_sock *newinet;
 	struct dccp6_sock *newdp6;
 	struct sock *newsk;
+	struct sock *osk;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		/*
@@ -533,7 +534,8 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		dccp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	osk = req_to_sk(req_unhash);
+	*own_req = inet_ehash_nolisten(newsk, &osk);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
 		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 239e54474b65..1fce64f7f0dc 100644
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
+ * through the osk parameter.
  */
-bool inet_ehash_insert(struct sock *sk, struct sock *osk)
+bool inet_ehash_insert(struct sock *sk, struct sock **osk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct hlist_nulls_head *list;
 	struct inet_ehash_bucket *head;
-	spinlock_t *lock;
+	const struct hlist_nulls_node *node;
+	struct sock *esk;
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
@@ -529,17 +542,53 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
 
 	spin_lock(lock);
-	if (osk) {
-		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
+	if (osk && *osk) {
+		WARN_ON_ONCE(sk->sk_hash != (*osk)->sk_hash);
+		ret = sk_nulls_del_node_init_rcu(*osk);
+	} else if (osk && !*osk) {
+		sk_nulls_for_each_rcu(esk, node, list) {
+			if (esk->sk_hash != sk->sk_hash)
+				continue;
+			if (sk->sk_family == AF_INET) {
+				if (unlikely(INET_MATCH(esk, net, acookie,
+							sk->sk_daddr,
+							sk->sk_rcv_saddr,
+							ports, dif, sdif))) {
+					if (unlikely(!refcount_inc_not_zero(&esk->sk_refcnt)))
+						goto out;
+					goto found;
+				}
+			}
+#if IS_ENABLED(CONFIG_IPV6)
+			else if (sk->sk_family == AF_INET6) {
+				if (unlikely(INET6_MATCH(esk, net,
+							 &sk->sk_v6_daddr,
+							 &sk->sk_v6_rcv_saddr,
+							 ports, dif, sdif))) {
+					if (unlikely(!refcount_inc_not_zero(&esk->sk_refcnt)))
+						goto out;
+					goto found;
+				}
+			}
+#endif
+		}
+
 	}
+out:
+	esk = NULL;
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
+
+found:
 	spin_unlock(lock);
+	if (esk) {
+		*osk = esk;
+		ret = false;
+	}
 	return ret;
 }
 
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk)
+bool inet_ehash_nolisten(struct sock *sk, struct sock **osk)
 {
 	bool ok = inet_ehash_insert(sk, osk);
 
@@ -578,7 +627,7 @@ static int inet_reuseport_add_sock(struct sock *sk,
 	return reuseport_alloc(sk, inet_rcv_saddr_any(sk));
 }
 
-int __inet_hash(struct sock *sk, struct sock *osk)
+int __inet_hash(struct sock *sk, struct sock **osk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct inet_listen_hashbucket *ilb;
@@ -760,7 +809,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
-		inet_ehash_nolisten(sk, (struct sock *)tw);
+		inet_ehash_nolisten(sk, (struct sock **)&tw);
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
index 592c73962723..7daaea30fc30 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1501,6 +1501,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	int l3index;
 #endif
 	struct ip_options_rcu *inet_opt;
+	struct sock *osk;
 
 	if (sk_acceptq_is_full(sk))
 		goto exit_overflow;
@@ -1565,11 +1566,18 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	osk = req_to_sk(req_unhash);
+	*own_req = inet_ehash_nolisten(newsk, &osk);
 	if (likely(*own_req)) {
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
+		if (!req_unhash && osk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			newsk = osk;
+		}
 		newinet->inet_opt = NULL;
 	}
 	return newsk;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 305870a72352..376dc75395c5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1190,6 +1190,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
+	struct sock *osk;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key;
 	int l3index;
@@ -1206,6 +1207,12 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		if (!newsk)
 			return NULL;
+		else if (!own_req) {
+			/* We're returning an existing child socket, probably
+			 * created by a previous syncookie ACK.
+			 */
+			return newsk;
+		}
 
 		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
 
@@ -1359,7 +1366,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	osk = req_to_sk(req_unhash);
+	*own_req = inet_ehash_nolisten(newsk, &osk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1374,6 +1382,13 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 				skb_set_owner_r(newnp->pktoptions, newsk);
 			}
 		}
+	} else {
+		if (!req_unhash && osk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			newsk = osk;
+		}
 	}
 
 	return newsk;
-- 
2.25.1

