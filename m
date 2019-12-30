Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF812D4CB
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfL3WTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbfL3WTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A202071E;
        Mon, 30 Dec 2019 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743879;
        bh=YfM/4J2pAFc9uxmz/r/Yc65eB/+OQIGieLfhvMyNjYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaawWerIVNRPP6EHVct8gI4xrq66WDVTHoxLpwsNGJ2fHR4qQ734m/yMdWq8dnDpD
         NuwIYP8kXbQI1CTXBelXrcEPw4F0n4MljtSYFMdMnINLWueGL2AAx/7MDzrqfppDUI
         42keI9apkgBPncxmuMSubSF6Voj3Q7CaAVZ6WzNc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/9] ipv4/tcp: Use local variable for tcp_md5_addr
Date:   Mon, 30 Dec 2019 14:14:25 -0800
Message-Id: <20191230221433.2717-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Extract the typecast to (union tcp_md5_addr *) to a local variable
rather than the current long, inline declaration with function calls.

No functional change intended.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6f52e5288a6f..c2bfff528578 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -701,9 +701,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
-		key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)
-					&ip_hdr(skb)->saddr, AF_INET);
+		const union tcp_md5_addr *addr;
+
+		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+		key = tcp_md5_do_lookup(sk, addr, AF_INET);
 	} else if (hash_location) {
+		const union tcp_md5_addr *addr;
+
 		/*
 		 * active side is lost. Try to find listening socket through
 		 * source port, and then find md5 key through listening socket.
@@ -720,8 +724,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!sk1)
 			goto out;
 
-		key = tcp_md5_do_lookup(sk1, (union tcp_md5_addr *)
-					&ip_hdr(skb)->saddr, AF_INET);
+		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+		key = tcp_md5_do_lookup(sk1, addr, AF_INET);
 		if (!key)
 			goto out;
 
@@ -905,6 +909,8 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	const union tcp_md5_addr *addr;
+
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
 	 */
@@ -916,14 +922,14 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	 * exception of <SYN> segments, MUST be right-shifted by
 	 * Rcv.Wind.Shift bits:
 	 */
+	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent,
 			0,
-			tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&ip_hdr(skb)->saddr,
-					  AF_INET),
+			tcp_md5_do_lookup(sk, addr, AF_INET),
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -1149,6 +1155,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpm_addr;
+	const union tcp_md5_addr *addr;
 	u8 prefixlen = 32;
 
 	if (optlen < sizeof(cmd))
@@ -1167,16 +1174,16 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			return -EINVAL;
 	}
 
+	addr = (union tcp_md5_addr *)&sin->sin_addr.s_addr;
+
 	if (!cmd.tcpm_keylen)
-		return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin->sin_addr.s_addr,
-				      AF_INET, prefixlen);
+		return tcp_md5_do_del(sk, addr, AF_INET, prefixlen);
 
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin->sin_addr.s_addr,
-			      AF_INET, prefixlen, cmd.tcpm_key, cmd.tcpm_keylen,
-			      GFP_KERNEL);
+	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen,
+			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
 static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -1301,11 +1308,12 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 	struct tcp_md5sig_key *hash_expected;
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
+	const union tcp_md5_addr *addr;
 	int genhash;
 	unsigned char newhash[16];
 
-	hash_expected = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&iph->saddr,
-					  AF_INET);
+	addr = (union tcp_md5_addr *)&iph->saddr;
+	hash_expected = tcp_md5_do_lookup(sk, addr, AF_INET);
 	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
@@ -1419,6 +1427,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
+	const union tcp_md5_addr *addr;
 	struct tcp_md5sig_key *key;
 #endif
 	struct ip_options_rcu *inet_opt;
@@ -1468,8 +1477,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Copy over the MD5 key from the original socket */
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&newinet->inet_daddr,
-				AF_INET);
+	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
+	key = tcp_md5_do_lookup(sk, addr, AF_INET);
 	if (key) {
 		/*
 		 * We're using one, so create a matching key
@@ -1477,8 +1486,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newinet->inet_daddr,
-			       AF_INET, 32, key->key, key->keylen, GFP_ATOMIC);
+		tcp_md5_do_add(newsk, addr, AF_INET, 32,
+			       key->key, key->keylen, GFP_ATOMIC);
 		sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
 	}
 #endif
-- 
2.11.0

