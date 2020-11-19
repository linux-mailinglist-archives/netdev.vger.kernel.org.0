Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104372B9B79
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgKSTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgKSTYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:24:47 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10F9C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:24:46 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id o15so7655076wru.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=H194UvTaEViEzek9BQyx8ak0xxrUN5jyVfcOpdSfD9w=;
        b=Nb+mggIyTvGlAG9avqg+lan3M9/iovawoxEIR2qPjkEVqzqBlt3hjJP6ovho40hbbF
         +RJLNHxmf1I9G/8MSfBXpZvoJRgdoP2lXDNED+j7sqCUheqs1r3pUuQV/p/W5HlvQbUU
         dH5MJ3qeEHkB2Nd8lcXNSN0gJ5wUHocRTjri1ulQ28Yhk9xvG+JDoU8yIMFornWe0dq5
         15b3R9520jEuwYRLbv8vBpMSd65RUL/BdaiZFv0nYVbwGbx71y6kn7CyG05J+REv8h99
         QIC0TA6jfrUQoIJAn123HFBzpd8cgcCOOK5wAouhRDm2MvYurU1nChF2t0hb48dSm/Py
         plkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=H194UvTaEViEzek9BQyx8ak0xxrUN5jyVfcOpdSfD9w=;
        b=Ew1H3cwwW5JFqE+NoYKMLflxneiOWxl/AtGuxB/lRwBQ08LMVznGFhZfD/trexKq8O
         XZ0e+wfOu/2sjlSWgkDg8yz0PCbCrxiPDwZWUoYz9NOqk9+B2X+CUIe5eMK9I00o4RmA
         9WJgFTefGeiwC/Emk68l4AtQJEWArFzZv0ygWXjaapXq1f9djVBZrDIr5xIt4IgrRe/i
         WRqI2mUir6yfG2WAN3QIcNeFdrWMkm79OKIIsyIEeorudljbkBIG7Sdmb47fbCrYOglo
         gtpoKybbseLTi71SAGML7P3NgRuLOJ90Q+GFMTa0TBGzs5T4LlQVo/npn7slYDRPadBa
         FgtQ==
X-Gm-Message-State: AOAM533MMXjLm1DQoZRnVJ5cDUEY6URD7c/F4EkRdSBGUqaXCU7C5EBg
        qaRCssGY99sdsiYfpKUywo+Wvw==
X-Google-Smtp-Source: ABdhPJwQHQG9uMZ65wTKsw827QrhyPW2+V03RkkDI2EQDf3HL0unVHzTZEGp3GBLL+m7Gj6Z2HZtSw==
X-Received: by 2002:adf:e945:: with SMTP id m5mr11301174wrn.98.1605813885427;
        Thu, 19 Nov 2020 11:24:45 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id c6sm1314668wrh.74.2020.11.19.11.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 11:24:44 -0800 (PST)
Date:   Thu, 19 Nov 2020 19:24:42 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201119192442.GA820741@rdias-suse-pc.lan>
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
 include/net/tcp.h               |  9 +++--
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/inet_hashtables.c      | 68 +++++++++++++++++++++++++++++----
 net/ipv4/syncookies.c           | 10 +++--
 net/ipv4/tcp_ipv4.c             | 41 +++++++++++++++++---
 net/ipv6/syncookies.c           |  5 ++-
 net/ipv6/tcp_ipv6.c             | 39 +++++++++++++++++--
 10 files changed, 153 insertions(+), 30 deletions(-)

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
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eab6c7510b5b..ff144d3ead2f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -465,10 +465,12 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb);
 /* From syncookies.c */
 struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 				 struct request_sock *req,
-				 struct dst_entry *dst, u32 tsoff);
+				 struct dst_entry *dst, u32 tsoff,
+				 bool *found_dup_sk);
 int __cookie_v4_check(const struct iphdr *iph, const struct tcphdr *th,
 		      u32 cookie);
-struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
+struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
+			     bool *found_dup_sk);
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 					    struct sock *sk, struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
@@ -562,7 +564,8 @@ bool cookie_ecn_ok(const struct tcp_options_received *opt,
 /* From net/ipv6/syncookies.c */
 int __cookie_v6_check(const struct ipv6hdr *iph, const struct tcphdr *th,
 		      u32 cookie);
-struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb);
+struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb,
+			     bool *found_dup_sk);
 
 u32 __cookie_v6_init_sequence(const struct ipv6hdr *iph,
 			      const struct tcphdr *th, u16 *mssp);
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
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index e03756631541..5026aded8e42 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -200,7 +200,8 @@ EXPORT_SYMBOL_GPL(__cookie_v4_check);
 
 struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 				 struct request_sock *req,
-				 struct dst_entry *dst, u32 tsoff)
+				 struct dst_entry *dst, u32 tsoff,
+				 bool *found_dup_sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sock *child;
@@ -223,6 +224,8 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 
 		bh_unlock_sock(child);
 		sock_put(child);
+	}  else if (!own_req) {
+		*found_dup_sk = true;
 	}
 	__reqsk_free(req);
 
@@ -320,7 +323,8 @@ EXPORT_SYMBOL_GPL(cookie_tcp_reqsk_alloc);
  * Output is listener if incoming packet would not create a child
  *           NULL if memory could not be allocated.
  */
-struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
+struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
+			     bool *found_dup_sk)
 {
 	struct ip_options *opt = &TCP_SKB_CB(skb)->header.h4.opt;
 	struct tcp_options_received tcp_opt;
@@ -436,7 +440,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	ireq->rcv_wscale  = rcv_wscale;
 	ireq->ecn_ok = cookie_ecn_ok(&tcp_opt, sock_net(sk), &rt->dst);
 
-	ret = tcp_get_cookie_sock(sk, skb, req, &rt->dst, tsoff);
+	ret = tcp_get_cookie_sock(sk, skb, req, &rt->dst, tsoff, found_dup_sk);
 	/* ip_queue_xmit() depends on our flow being setup
 	 * Normal sockets get it right from inet_csk_route_child_sock()
 	 */
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 592c73962723..0e7ae6895099 100644
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
 
@@ -1589,13 +1600,14 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(tcp_v4_syn_recv_sock);
 
-static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb)
+static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb,
+					bool *found_dup_sk)
 {
 #ifdef CONFIG_SYN_COOKIES
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (!th->syn)
-		sk = cookie_v4_check(sk, skb);
+		sk = cookie_v4_check(sk, skb, found_dup_sk);
 #endif
 	return sk;
 }
@@ -1625,6 +1637,7 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
  */
 int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	bool found_dup_sk = false;
 	struct sock *rsk;
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1647,7 +1660,16 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		goto csum_err;
 
 	if (sk->sk_state == TCP_LISTEN) {
-		struct sock *nsk = tcp_v4_cookie_check(sk, skb);
+		struct sock *nsk = tcp_v4_cookie_check(sk, skb, &found_dup_sk);
+
+		if (found_dup_sk) {
+			/* Returning 1 here means that tcp_v4_rcv should lookup
+			 * for an established socket again because we just
+			 * found out that a previous socket already exists for
+			 * the same SYN cookie.
+			 */
+			return 1;
+		}
 
 		if (!nsk)
 			goto discard;
@@ -1891,6 +1913,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	int dif = inet_iif(skb);
 	const struct iphdr *iph;
 	const struct tcphdr *th;
+	struct net_device *dev;
 	bool refcounted;
 	struct sock *sk;
 	int ret;
@@ -2006,10 +2029,18 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
 
+	dev = skb->dev;
 	skb->dev = NULL;
 
 	if (sk->sk_state == TCP_LISTEN) {
 		ret = tcp_v4_do_rcv(sk, skb);
+		if (ret == 1) {
+			skb->dev = dev;
+			tcp_v4_restore_cb(skb);
+			if (refcounted)
+				sock_put(sk);
+			goto lookup;
+		}
 		goto put_and_return;
 	}
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e796a64be308..3994d0396691 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -125,7 +125,8 @@ int __cookie_v6_check(const struct ipv6hdr *iph, const struct tcphdr *th,
 }
 EXPORT_SYMBOL_GPL(__cookie_v6_check);
 
-struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
+struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb,
+			     bool *found_dup_sk)
 {
 	struct tcp_options_received tcp_opt;
 	struct inet_request_sock *ireq;
@@ -249,7 +250,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	ireq->rcv_wscale = rcv_wscale;
 	ireq->ecn_ok = cookie_ecn_ok(&tcp_opt, sock_net(sk), dst);
 
-	ret = tcp_get_cookie_sock(sk, skb, req, dst, tsoff);
+	ret = tcp_get_cookie_sock(sk, skb, req, dst, tsoff, found_dup_sk);
 out:
 	return ret;
 out_free:
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 305870a72352..cdf2b94e3e43 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1125,13 +1125,14 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 }
 
 
-static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
+static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb,
+					bool *found_dup_sk)
 {
 #ifdef CONFIG_SYN_COOKIES
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (!th->syn)
-		sk = cookie_v6_check(sk, skb);
+		sk = cookie_v6_check(sk, skb, found_dup_sk);
 #endif
 	return sk;
 }
@@ -1188,6 +1189,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct ipv6_txoptions *opt;
 	struct inet_sock *newinet;
+	bool found_dup_sk = false;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
@@ -1359,7 +1361,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1374,6 +1377,15 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
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
@@ -1399,6 +1411,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
+	bool found_dup_sk = false;
 	struct tcp_sock *tp;
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
@@ -1456,7 +1469,16 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		goto csum_err;
 
 	if (sk->sk_state == TCP_LISTEN) {
-		struct sock *nsk = tcp_v6_cookie_check(sk, skb);
+		struct sock *nsk = tcp_v6_cookie_check(sk, skb, &found_dup_sk);
+
+		if (found_dup_sk) {
+			/* Returning 1 here means that tcp_v6_rcv should lookup
+			 * for an established socket again because we just
+			 * found out that a previous socket already exists for
+			 * the same SYN cookie.
+			 */
+			return 1;
+		}
 
 		if (!nsk)
 			goto discard;
@@ -1554,6 +1576,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
 	const struct ipv6hdr *hdr;
+	struct net_device *dev;
 	bool refcounted;
 	struct sock *sk;
 	int ret;
@@ -1664,10 +1687,18 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
 
+	dev = skb->dev;
 	skb->dev = NULL;
 
 	if (sk->sk_state == TCP_LISTEN) {
 		ret = tcp_v6_do_rcv(sk, skb);
+		if (ret == 1) {
+			skb->dev = dev;
+			tcp_v6_restore_cb(skb);
+			if (refcounted)
+				sock_put(sk);
+			goto lookup;
+		}
 		goto put_and_return;
 	}
 
-- 
2.25.1

