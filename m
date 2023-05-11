Return-Path: <netdev+bounces-1706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 709AB6FEEF6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B8A52815F8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9835D1C743;
	Thu, 11 May 2023 09:35:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331591C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847FAC4339E;
	Thu, 11 May 2023 09:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683797707;
	bh=g8sb9pf4OKwGdWHzdapCjTXp8I1OFygag9Q8PZORahs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHXVPjmlfzrVD2wTjoicsASB/iaPmxRUN10zX4y7+7iWpgxaszdJBk0gZLpWXZwh8
	 kz2q/9xbx68fAgX7FDTW6vYac1vB3lglbkQaL9Q5QkuiCp7H99Y9l+rSvxFmWtPebE
	 HNkhDxj42/PzZYtGcfgbY71+GYI71Yiwz5+r1QQX0fNZ9m77OuRYpJywUXAm6ryq0C
	 yjQQXTyFz9cbzRFKvomB3fE3o7YufDwiRs3pwbqOFmh1GB1O/BzJHLQ3TT4DWB7Djz
	 KidzK1QoG37lXvTRqpxJAQp1sZYL1Z4BSOV5PmLHcFVLNiV8hRXmk2YKAs+UjGESwE
	 5WL6auT8x80Qw==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
Date: Thu, 11 May 2023 11:34:54 +0200
Message-Id: <20230511093456.672221-3-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
References: <20230511093456.672221-1-atenart@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using IPv4/TCP, skb->hash comes from sk->sk_txhash except in
TIME_WAIT and SYN_RECV where it's not set in the reply skb from
ip_send_unicast_reply. Those packets will have a mismatched hash with
others from the same flow as their hashes will be 0. IPv6 does not have
the same issue as the hash is set from the socket txhash in those cases.

This commits sets the hash in the reply skb from ip_send_unicast_reply,
which makes the IPv4 code behaving like IPv6.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/net/ip.h     |  2 +-
 net/ipv4/ip_output.c |  4 +++-
 net/ipv4/tcp_ipv4.c  | 14 +++++++++-----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..749735171e2c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -280,7 +280,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len, u64 transmit_time);
+			   unsigned int len, u64 transmit_time, u32 txhash);
 
 #define IP_INC_STATS(net, field)	SNMP_INC_STATS64((net)->mib.ip_statistics, field)
 #define __IP_INC_STATS(net, field)	__SNMP_INC_STATS64((net)->mib.ip_statistics, field)
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61892268e8a6..a1bead441026 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1692,7 +1692,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len, u64 transmit_time)
+			   unsigned int len, u64 transmit_time, u32 txhash)
 {
 	struct ip_options_data replyopts;
 	struct ipcm_cookie ipc;
@@ -1755,6 +1755,8 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 								arg->csum));
 		nskb->ip_summed = CHECKSUM_NONE;
 		nskb->mono_delivery_time = !!transmit_time;
+		if (txhash)
+			skb_set_hash(nskb, txhash, PKT_HASH_TYPE_L4);
 		ip_push_pending_frames(sk, &fl4);
 	}
 out:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e..8fd4b548d448 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -692,6 +692,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	u64 transmit_time = 0;
 	struct sock *ctl_sk;
 	struct net *net;
+	u32 txhash = 0;
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -829,12 +830,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
 		xfrm_sk_clone_policy(ctl_sk, sk);
+		txhash = (sk->sk_state == TCP_TIME_WAIT) ?
+			 inet_twsk(sk)->tw_txhash : sk->sk_txhash;
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
 			      &arg, arg.iov[0].iov_len,
-			      transmit_time);
+			      transmit_time, txhash);
 
 	ctl_sk->sk_mark = 0;
 	xfrm_sk_free_policy(ctl_sk);
@@ -857,7 +860,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			    struct sk_buff *skb, u32 seq, u32 ack,
 			    u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key,
-			    int reply_flags, u8 tos)
+			    int reply_flags, u8 tos, u32 txhash)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct {
@@ -933,7 +936,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
 			      &arg, arg.iov[0].iov_len,
-			      transmit_time);
+			      transmit_time, txhash);
 
 	ctl_sk->sk_mark = 0;
 	sock_net_set(ctl_sk, &init_net);
@@ -954,7 +957,8 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tw->tw_bound_dev_if,
 			tcp_twsk_md5_key(tcptw),
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			tw->tw_tos
+			tw->tw_tos,
+			tw->tw_txhash
 			);
 
 	inet_twsk_put(tw);
@@ -987,7 +991,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			0,
 			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			ip_hdr(skb)->tos);
+			ip_hdr(skb)->tos, tcp_rsk(req)->txhash);
 }
 
 /*
-- 
2.40.1


