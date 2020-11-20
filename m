Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337EE2BA8C6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgKTLLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbgKTLLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 06:11:38 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C0FC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 03:11:37 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o15so9633705wru.6
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 03:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=T1sCuFGPmJIrg834QtNFcm2Npw1oR1DJJdJcFrQ+l0g=;
        b=R2BhDoX89FdlX37JS34vaDuKzSy7y4LuSpfIWI5CMbea5/TkwZ3hR8BCNDWUeEyNC0
         Xvt8r6pmsE1k5uDRi6ow3EGofasGZXICHcRlZZMW4oZpcN7rZPQx9x9U5WcKgaS5imtm
         tYs8uaW33GTBabNg+b6cUdTk9xuuPyfDGjBnP6wNpVItwgBPEdT4FupwHwZYdt1TDYRE
         AIUSTOLIPk0H9PQ3SvVcj0Y7vZdY0GsHYQHuYMMZjFAD0EqmlIXem9ZJ4uiphqQEuuAs
         J0z77o8HYniq3ofuFOYrqyCduljRIVE9bpOlqpfA9qDLEauZwDKfXfogtD8/shuHuGQC
         8MIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=T1sCuFGPmJIrg834QtNFcm2Npw1oR1DJJdJcFrQ+l0g=;
        b=Dz2hwBCmzfldXoCABEW/Dnw80ReUZ+m6Hlg0ktt1mHbYh5437KfJd+CK/o0Iiqg0tZ
         bO6X0qz02NYeHBt2nCeemJ9kiBAzvKTjIAZqNTPDhLYo0IfYUCnI1VtE9fViF8kMI+qJ
         cIEXQBJOERfzvfCVfkp5VfGQDJkSr4t1TaWSG8AjJoaOe/pBIXrKQoTeTr54TnaN4wPm
         AiS02xAdr6rnlD9epiK/XKChpDfCrGnfwAFo0zrnTC9v765QA4eyQWRowqhM0Bb1gyr+
         lWf1Y9QfjCa3LoPza03e0GP+Dr/XKz0MO+YHA37v/gu0VGOsXWjtzSGZcW+vC7mdVX+2
         +KPw==
X-Gm-Message-State: AOAM530xqxNs5vE5Z8BQwjTsC5xDJrNFpnMaixdCDU5J5rvAK8eQCMup
        TVNcBohSQsnFo0MFWc+W4urXeA==
X-Google-Smtp-Source: ABdhPJwITvz+cRtdRfJeFeArCpD4QthqMZBCRYtbHLt8u4G320KrWVcneR22wVqYRr4xOj/60unhWQ==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr14770627wrs.377.1605870696220;
        Fri, 20 Nov 2020 03:11:36 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id c62sm3755975wme.22.2020.11.20.03.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 03:11:35 -0800 (PST)
Date:   Fri, 20 Nov 2020 11:11:33 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201120111133.GA67501@rdias-suse-pc.lan>
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
socket exists, we drop the packet and discard the second child socket
to the same client.

Signed-off-by: Ricardo Dias <rdias@singlestore.com>
---
v8 (2020-11-20):
  * Implemented the approach suggested by Eric where we drop the packet
    in case we found an already existing socket for the same connection.
  * Updated the commit message to match the new approach.

v7 (2020-11-19):
  * Changed the approach to re-use the first (existing) socket created
    from thge syncookie. Instead of returning the existing socket in
    tcp_(v4|v6)_syn_recv_sock and continue the protocol state machine
    execution, tcp_(v4|v6)_syn_recv_sock signals that already exists a
    socket, and tells tcp_(v4|v6)_rcv to lookup the socket again in the
    established connections table.
    This new approach fixes the errors reported by Eric for the previous
    version of the patch.
  * Also fixes the memory leaks by making sure that the newly created
    socket in syn_recv_sock is destroyed in case an already existing
    socket exists.

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

 include/net/inet_hashtables.h   |  5 ++-
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/inet_hashtables.c      | 68 +++++++++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c             | 15 +++++++-
 net/ipv6/tcp_ipv6.c             | 13 ++++++-
 7 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 92560974ea67..ca6a3ea9057e 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -247,8 +247,9 @@ void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 			 unsigned long high_limit);
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h);
 
-bool inet_ehash_insert(struct sock *sk, struct sock *osk);
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk);
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk,
+			 bool *found_dup_sk);
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
index 239e54474b65..bd5d370ec51e 100644
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
@@ -510,10 +513,52 @@ static u32 inet_sk_port_offset(const struct sock *sk)
 					  inet->inet_dport);
 }
 
-/* insert a socket into ehash, and eventually remove another one
- * (The another one can be a SYN_RECV or TIMEWAIT
+/* Searches for an exsiting socket in the ehash bucket list.
+ * Returns true if found, false otherwise.
  */
-bool inet_ehash_insert(struct sock *sk, struct sock *osk)
+static bool inet_ehash_lookup_by_sk(struct sock *sk,
+				    struct hlist_nulls_head *list)
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
+				return true;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (sk->sk_family == AF_INET6) {
+			if (unlikely(INET6_MATCH(esk, net,
+						 &sk->sk_v6_daddr,
+						 &sk->sk_v6_rcv_saddr,
+						 ports, dif, sdif))) {
+				return true;
+			}
+		}
+#endif
+	}
+	return false;
+}
+
+/* Insert a socket into ehash, and eventually remove another one
+ * (The another one can be a SYN_RECV or TIMEWAIT)
+ * If an existing socket already exists, socket sk is not inserted,
+ * and sets found_dup_sk parameter to true.
+ */
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct hlist_nulls_head *list;
@@ -532,16 +577,23 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
 		ret = sk_nulls_del_node_init_rcu(osk);
+	} else if (found_dup_sk) {
+		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
+		if (*found_dup_sk)
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
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
-	bool ok = inet_ehash_insert(sk, osk);
+	bool ok = inet_ehash_insert(sk, osk, found_dup_sk);
 
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -585,7 +637,7 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
-		inet_ehash_nolisten(sk, osk);
+		inet_ehash_nolisten(sk, osk, NULL);
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -681,7 +733,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL);
+			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
 		}
@@ -760,7 +812,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
-		inet_ehash_nolisten(sk, (struct sock *)tw);
+		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 592c73962723..fe4259f8c207 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1492,6 +1492,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 				  bool *own_req)
 {
 	struct inet_request_sock *ireq;
+	bool found_dup_sk = false;
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
@@ -1565,12 +1566,22 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (likely(*own_req)) {
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
-		newinet->inet_opt = NULL;
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		} else {
+			newinet->inet_opt = NULL;
+		}
 	}
 	return newsk;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 305870a72352..925d61244f8f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1188,6 +1188,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct ipv6_txoptions *opt;
 	struct inet_sock *newinet;
+	bool found_dup_sk = false;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
@@ -1359,7 +1360,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1374,6 +1376,15 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 				skb_set_owner_r(newnp->pktoptions, newsk);
 			}
 		}
+	} else {
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		}
 	}
 
 	return newsk;
-- 
2.25.1

