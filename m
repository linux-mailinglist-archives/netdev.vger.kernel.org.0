Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFBE12D4CC
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfL3WTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfL3WTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:36 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8136207E0;
        Mon, 30 Dec 2019 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743880;
        bh=jt3ovKUibWjI63aoyVOnuUzh0INyiceCCDZGfwCFGxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxkXNoeFqb/4jmP4gbfVacyQU+ZWgzxIayBDYEK048x+Zp5WnPDJHSMoMAflhnB1U
         p/wCp40kZVk/04Q71mAIWS5iOTHqeIv3EOCloc2wsM3fXxzf3U+WF99fWrPC7ojvRO
         XiC+mWNfekFC4+M9JitOiDjvH5/VBTLWXXTbW48o=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 4/9] tcp: Add l3index to tcp_md5sig_key and md5 functions
Date:   Mon, 30 Dec 2019 14:14:28 -0800
Message-Id: <20191230221433.2717-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add l3index to tcp_md5sig_key to represent the L3 domain of a key, and
add l3index to tcp_md5_do_add and tcp_md5_do_del to fill in the key.

With the key now based on an l3index, add the new parameter to the
lookup functions and consider the l3index when looking for a match.

The l3index comes from the skb when processing ingress packets leveraging
the helpers created for socket lookups, tcp_v4_sdif and inet_iif (and the
v6 variants). When the sdif index is set it means the packet ingressed a
device that is part of an L3 domain and inet_iif points to the VRF device.
For egress, the L3 domain is determined from the socket binding and
sk_bound_dev_if.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/tcp.h   | 24 +++++++++---------
 net/ipv4/tcp_ipv4.c | 68 +++++++++++++++++++++++++++++++++++---------------
 net/ipv6/tcp_ipv6.c | 72 +++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 113 insertions(+), 51 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e460ea7f767b..7df37e2fddca 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1532,8 +1532,9 @@ struct tcp_md5sig_key {
 	struct hlist_node	node;
 	u8			keylen;
 	u8			family; /* AF_INET or AF_INET6 */
-	union tcp_md5_addr	addr;
 	u8			prefixlen;
+	union tcp_md5_addr	addr;
+	int			l3index; /* set if key added with L3 scope */
 	u8			key[TCP_MD5SIG_MAXKEYLEN];
 	struct rcu_head		rcu;
 };
@@ -1577,34 +1578,33 @@ struct tcp_md5sig_pool {
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, const u8 *newkey, u8 newkeylen,
-		   gfp_t gfp);
+		   int family, u8 prefixlen, int l3index,
+		   const u8 *newkey, u8 newkeylen, gfp_t gfp);
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen);
+		   int family, u8 prefixlen, int l3index);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 					 const struct sock *addr_sk);
 
 #ifdef CONFIG_TCP_MD5SIG
 #include <linux/jump_label.h>
 extern struct static_key_false tcp_md5_needed;
-struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk,
+struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family);
 static inline struct tcp_md5sig_key *
-tcp_md5_do_lookup(const struct sock *sk,
-		  const union tcp_md5_addr *addr,
-		  int family)
+tcp_md5_do_lookup(const struct sock *sk, int l3index,
+		  const union tcp_md5_addr *addr, int family)
 {
 	if (!static_branch_unlikely(&tcp_md5_needed))
 		return NULL;
-	return __tcp_md5_do_lookup(sk, addr, family);
+	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 #else
-static inline struct tcp_md5sig_key *tcp_md5_do_lookup(const struct sock *sk,
-					 const union tcp_md5_addr *addr,
-					 int family)
+static inline struct tcp_md5sig_key *
+tcp_md5_do_lookup(const struct sock *sk, int l3index,
+		  const union tcp_md5_addr *addr, int family)
 {
 	return NULL;
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 93f220793add..30b3f19d6301 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -702,13 +702,19 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
+		int l3index;
 
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and inet_iif is set to it.
+		 */
+		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-		key = tcp_md5_do_lookup(sk, addr, AF_INET);
+		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	} else if (hash_location) {
 		const union tcp_md5_addr *addr;
 		int sdif = tcp_v4_sdif(skb);
 		int dif = inet_iif(skb);
+		int l3index;
 
 		/*
 		 * active side is lost. Try to find listening socket through
@@ -725,8 +731,12 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!sk1)
 			goto out;
 
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and dif is set to it.
+		 */
+		l3index = sdif ? dif : 0;
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-		key = tcp_md5_do_lookup(sk1, addr, AF_INET);
+		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
@@ -911,6 +921,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
 	const union tcp_md5_addr *addr;
+	int l3index;
 
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
@@ -924,13 +935,14 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	 * Rcv.Wind.Shift bits:
 	 */
 	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+	l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent,
 			0,
-			tcp_md5_do_lookup(sk, addr, AF_INET),
+			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -990,7 +1002,7 @@ DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
 EXPORT_SYMBOL(tcp_md5_needed);
 
 /* Find the Key structure for an address.  */
-struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk,
+struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family)
 {
@@ -1010,7 +1022,8 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk,
 	hlist_for_each_entry_rcu(key, &md5sig->head, node) {
 		if (key->family != family)
 			continue;
-
+		if (key->l3index && key->l3index != l3index)
+			continue;
 		if (family == AF_INET) {
 			mask = inet_make_mask(key->prefixlen);
 			match = (key->addr.a4.s_addr & mask) ==
@@ -1034,7 +1047,8 @@ EXPORT_SYMBOL(__tcp_md5_do_lookup);
 
 static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 						      const union tcp_md5_addr *addr,
-						      int family, u8 prefixlen)
+						      int family, u8 prefixlen,
+						      int l3index)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1053,6 +1067,8 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 	hlist_for_each_entry_rcu(key, &md5sig->head, node) {
 		if (key->family != family)
 			continue;
+		if (key->l3index && key->l3index != l3index)
+			continue;
 		if (!memcmp(&key->addr, addr, size) &&
 		    key->prefixlen == prefixlen)
 			return key;
@@ -1064,23 +1080,26 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 					 const struct sock *addr_sk)
 {
 	const union tcp_md5_addr *addr;
+	int l3index;
 
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						 addr_sk->sk_bound_dev_if);
 	addr = (const union tcp_md5_addr *)&addr_sk->sk_daddr;
-	return tcp_md5_do_lookup(sk, addr, AF_INET);
+	return tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, const u8 *newkey, u8 newkeylen,
-		   gfp_t gfp)
+		   int family, u8 prefixlen, int l3index,
+		   const u8 *newkey, u8 newkeylen, gfp_t gfp)
 {
 	/* Add Key to the list */
 	struct tcp_md5sig_key *key;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen);
+	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
@@ -1112,6 +1131,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key->keylen = newkeylen;
 	key->family = family;
 	key->prefixlen = prefixlen;
+	key->l3index = l3index;
 	memcpy(&key->addr, addr,
 	       (family == AF_INET6) ? sizeof(struct in6_addr) :
 				      sizeof(struct in_addr));
@@ -1121,11 +1141,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 EXPORT_SYMBOL(tcp_md5_do_add);
 
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
-		   u8 prefixlen)
+		   u8 prefixlen, int l3index)
 {
 	struct tcp_md5sig_key *key;
 
-	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen);
+	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
 	if (!key)
 		return -ENOENT;
 	hlist_del_rcu(&key->node);
@@ -1158,6 +1178,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpm_addr;
 	const union tcp_md5_addr *addr;
 	u8 prefixlen = 32;
+	int l3index = 0;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
@@ -1178,12 +1199,12 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	addr = (union tcp_md5_addr *)&sin->sin_addr.s_addr;
 
 	if (!cmd.tcpm_keylen)
-		return tcp_md5_do_del(sk, addr, AF_INET, prefixlen);
+		return tcp_md5_do_del(sk, addr, AF_INET, prefixlen, l3index);
 
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen,
+	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
@@ -1311,11 +1332,16 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
 	const union tcp_md5_addr *addr;
-	int genhash;
 	unsigned char newhash[16];
+	int genhash, l3index;
+
+	/* sdif set, means packet ingressed via a device
+	 * in an L3 domain and dif is set to the l3mdev
+	 */
+	l3index = sdif ? dif : 0;
 
 	addr = (union tcp_md5_addr *)&iph->saddr;
-	hash_expected = tcp_md5_do_lookup(sk, addr, AF_INET);
+	hash_expected = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
@@ -1341,11 +1367,11 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
-		net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s\n",
+		net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
 				     &iph->saddr, ntohs(th->source),
 				     &iph->daddr, ntohs(th->dest),
 				     genhash ? " tcp_v4_calc_md5_hash failed"
-				     : "");
+				     : "", l3index);
 		return true;
 	}
 	return false;
@@ -1431,6 +1457,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 #ifdef CONFIG_TCP_MD5SIG
 	const union tcp_md5_addr *addr;
 	struct tcp_md5sig_key *key;
+	int l3index;
 #endif
 	struct ip_options_rcu *inet_opt;
 
@@ -1478,9 +1505,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	tcp_initialize_rcv_mss(newsk);
 
 #ifdef CONFIG_TCP_MD5SIG
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 	/* Copy over the MD5 key from the original socket */
 	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
-	key = tcp_md5_do_lookup(sk, addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	if (key) {
 		/*
 		 * We're using one, so create a matching key
@@ -1488,7 +1516,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, addr, AF_INET, 32,
+		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index,
 			       key->key, key->keylen, GFP_ATOMIC);
 		sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e94f23b61b62..71ad7d89be0f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -81,7 +81,8 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
 static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
 #else
 static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
-						   const struct in6_addr *addr)
+						   const struct in6_addr *addr,
+						   int l3index)
 {
 	return NULL;
 }
@@ -532,15 +533,22 @@ static void tcp_v6_reqsk_destructor(struct request_sock *req)
 
 #ifdef CONFIG_TCP_MD5SIG
 static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
-						   const struct in6_addr *addr)
+						   const struct in6_addr *addr,
+						   int l3index)
 {
-	return tcp_md5_do_lookup(sk, (union tcp_md5_addr *)addr, AF_INET6);
+	return tcp_md5_do_lookup(sk, l3index,
+				 (union tcp_md5_addr *)addr, AF_INET6);
 }
 
 static struct tcp_md5sig_key *tcp_v6_md5_lookup(const struct sock *sk,
 						const struct sock *addr_sk)
 {
-	return tcp_v6_md5_do_lookup(sk, &addr_sk->sk_v6_daddr);
+	int l3index;
+
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						 addr_sk->sk_bound_dev_if);
+	return tcp_v6_md5_do_lookup(sk, &addr_sk->sk_v6_daddr,
+				    l3index);
 }
 
 static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
@@ -548,6 +556,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
+	int l3index = 0;
 	u8 prefixlen;
 
 	if (optlen < sizeof(cmd))
@@ -572,9 +581,9 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (!cmd.tcpm_keylen) {
 		if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 			return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
-					      AF_INET, prefixlen);
+					      AF_INET, prefixlen, l3index);
 		return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-				      AF_INET6, prefixlen);
+				      AF_INET6, prefixlen, l3index);
 	}
 
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
@@ -582,12 +591,13 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
-				      AF_INET, prefixlen, cmd.tcpm_key,
-				      cmd.tcpm_keylen, GFP_KERNEL);
+				      AF_INET, prefixlen, l3index,
+				      cmd.tcpm_key, cmd.tcpm_keylen,
+				      GFP_KERNEL);
 
 	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-			      AF_INET6, prefixlen, cmd.tcpm_key,
-			      cmd.tcpm_keylen, GFP_KERNEL);
+			      AF_INET6, prefixlen, l3index,
+			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
 static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -706,10 +716,15 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 	struct tcp_md5sig_key *hash_expected;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
-	int genhash;
+	int genhash, l3index;
 	u8 newhash[16];
 
-	hash_expected = tcp_v6_md5_do_lookup(sk, &ip6h->saddr);
+	/* sdif set, means packet ingressed via a device
+	 * in an L3 domain and dif is set to the l3mdev
+	 */
+	l3index = sdif ? dif : 0;
+
+	hash_expected = tcp_v6_md5_do_lookup(sk, &ip6h->saddr, l3index);
 	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
@@ -733,10 +748,10 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
-		net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u\n",
+		net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
 				     genhash ? "failed" : "mismatch",
 				     &ip6h->saddr, ntohs(th->source),
-				     &ip6h->daddr, ntohs(th->dest));
+				     &ip6h->daddr, ntohs(th->dest), l3index);
 		return true;
 	}
 #endif
@@ -952,10 +967,17 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
-		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr);
+		int l3index;
+
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and inet_iif is set to it.
+		 */
+		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
+		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
 	} else if (hash_location) {
 		int dif = tcp_v6_iif_l3_slave(skb);
 		int sdif = tcp_v6_sdif(skb);
+		int l3index;
 
 		/*
 		 * active side is lost. Try to find listening socket through
@@ -972,7 +994,12 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!sk1)
 			goto out;
 
-		key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr);
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and dif is set to it.
+		 */
+		l3index = tcp_v6_sdif(skb) ? dif : 0;
+
+		key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr, l3index);
 		if (!key)
 			goto out;
 
@@ -1042,6 +1069,10 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	int l3index;
+
+	l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
+
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
 	 */
@@ -1056,7 +1087,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
-			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr),
+			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
 			0, 0, sk->sk_priority);
 }
 
@@ -1128,6 +1159,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key;
+	int l3index;
 #endif
 	struct flowi6 fl6;
 
@@ -1271,8 +1303,10 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	newinet->inet_rcv_saddr = LOOPBACK4_IPV6;
 
 #ifdef CONFIG_TCP_MD5SIG
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
+
 	/* Copy over the MD5 key from the original socket */
-	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr);
+	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
 	if (key) {
 		/* We're using one, so create a matching key
 		 * on the newsk structure. If we fail to get
@@ -1280,7 +1314,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		 * across. Shucks.
 		 */
 		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-			       AF_INET6, 128, key->key, key->keylen,
+			       AF_INET6, 128, l3index, key->key, key->keylen,
 			       sk_gfp_mask(sk, GFP_ATOMIC));
 	}
 #endif
-- 
2.11.0

