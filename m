Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FED2B5A4C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKQHaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQHaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:30:00 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:29:59 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id h2so2265911wmm.0
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=R0Ki8EWYo2Qrzan6/t/OmPvxGXltjnZhGBEqlpV5qhM=;
        b=ciXyQJk/8c23mtmpoCwOTgNq23qnlSkjPYDSroswR5czomtmfCU/oHpqjvW31towui
         GJcv5o+Wwql43cN3Tw31m7Tr9XUyiFY+sRy5f+9rdO6jVlcJt5+Q7lGfTPvGmqiWtodQ
         5jyXFFFDLnt8YRPiv42zYmDuP324iawjwbN1eMwT+4HHC1IwCjiiFfgk5+2EodvzjPYc
         pMQQi21fpwpOM6w+SIjSXF6ac4BsT7rcZQj/wxWFO3Z2ZI+k9rDLlwlmM6aZMPPRee7/
         B9/riWDqlsdLuKldFc2y+extGjogdA6Kmw4nPZJBkzwx28dlO5qNnFsQkNcrY3wMYuhF
         yQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=R0Ki8EWYo2Qrzan6/t/OmPvxGXltjnZhGBEqlpV5qhM=;
        b=NZPTELbj6oMUu6Cy2YHO69TrQIwKtAFbUg9k6bbT9kTGgOU63TWvQC5jk6eV0JiMoL
         8o2bmnAE3P5qzG1v2eIJ1CiCdGHVkxoUN3TphlwWd7a2WfKKoBBsKj+tdFwE3fx46dNO
         JJHf4UNLz1cW/dys3JsTniJkDsUCoZ3t69KtdLzaGuWL5ibZi1B+Sc7V8JtDxbBK8hsQ
         ecdd4lmVD4S9ce3VUhlhbAyPV9StVZaCruz/Gpl+pj9qgqQFHBI1y/yyhejSFfws+mZS
         GHpUv5kjiJQGH42XR0KllpeRQ8dzRQuHTveQBTyJFZkGx3wCcshHVtfbfvf9BSK/gjql
         KrIA==
X-Gm-Message-State: AOAM533a7P64xRE794KALxN5yOKN6H/XVJ0qgcy9puTilj1Km8eyFHzt
        RCxVeR3anhu14QVF8ylY8IpSfw==
X-Google-Smtp-Source: ABdhPJyYuIBZf97qQMbskgNUhrxpMl3yHS5mwenWpQlUSxO6XJUn40DAdrbVnkT/73TW7lAhP82R3Q==
X-Received: by 2002:a1c:a445:: with SMTP id n66mr2851840wme.51.1605598198111;
        Mon, 16 Nov 2020 23:29:58 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id u85sm2277703wmu.43.2020.11.16.23.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:29:57 -0800 (PST)
Date:   Tue, 17 Nov 2020 07:29:55 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201117072955.GA1611867@rdias-suse-pc.lan>
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
v6 (2020-11-17):
  * Moved the ehash bucket list search for its own helper function.

v5 (2020-11-16):
 - Not considered for review -
 
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

 include/net/inet_hashtables.h   |  4 +-
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/inet_hashtables.c      | 72 +++++++++++++++++++++++++++++----
 net/ipv4/syncookies.c           |  5 ++-
 net/ipv4/tcp_ipv4.c             |  9 ++++-
 net/ipv6/tcp_ipv6.c             | 16 +++++++-
 8 files changed, 96 insertions(+), 16 deletions(-)

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
index 239e54474b65..3752c31b1fcd 100644
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
@@ -510,10 +513,56 @@ static u32 inet_sk_port_offset(const struct sock *sk)
 					  inet->inet_dport);
 }
 
-/* insert a socket into ehash, and eventually remove another one
- * (The another one can be a SYN_RECV or TIMEWAIT
+/* Searches for an exsiting socket in the ehash bucket list.
+ * Returns NULL if not found.
+ */
+static struct sock *inet_ehash_lookup_by_sk(struct sock *sk,
+					    struct hlist_nulls_head *list)
+{
+	const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
+	const int sdif = sk->sk_bound_dev_if;
+	const int dif = sk->sk_bound_dev_if;
+	const struct hlist_nulls_node *node;
+	struct net *net = sock_net(sk);
+	struct sock *esk;
+
+	INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
+
+	sk_nulls_for_each_rcu(esk, node, list) {
+		if (esk->sk_hash != sk->sk_hash)
+			continue;
+		if (sk->sk_family == AF_INET) {
+			if (unlikely(INET_MATCH(esk, net, acookie,
+						sk->sk_daddr,
+						sk->sk_rcv_saddr,
+						ports, dif, sdif))) {
+				refcount_inc(&esk->sk_refcnt);
+				goto found;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (sk->sk_family == AF_INET6) {
+			if (unlikely(INET6_MATCH(esk, net,
+						 &sk->sk_v6_daddr,
+						 &sk->sk_v6_rcv_saddr,
+						 ports, dif, sdif))) {
+				refcount_inc(&esk->sk_refcnt);
+				goto found;
+			}
+		}
+#endif
+	}
+	esk = NULL;
+found:
+	return esk;
+}
+
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
@@ -532,16 +581,23 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
 		ret = sk_nulls_del_node_init_rcu(osk);
+	} else if (esk) {
+		*esk = inet_ehash_lookup_by_sk(sk, list);
+		if (*esk)
+			ret = false;
 	}
+
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
+
 	spin_unlock(lock);
+
 	return ret;
 }
 
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk)
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, struct sock **esk)
 {
-	bool ok = inet_ehash_insert(sk, osk);
+	bool ok = inet_ehash_insert(sk, osk, esk);
 
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -585,7 +641,7 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
-		inet_ehash_nolisten(sk, osk);
+		inet_ehash_nolisten(sk, osk, NULL);
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -681,7 +737,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL);
+			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
 		}
@@ -760,7 +816,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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

