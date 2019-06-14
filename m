Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAE045368
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFNEWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:22:49 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:36404 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNEWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:22:49 -0400
Received: by mail-ot1-f73.google.com with SMTP id b64so615965otc.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 21:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=29gdIvzBqOOrpiwyb6jnmZKHmXeKs8PHD7X77mXmZ7k=;
        b=dJHAvTs4Eqp/A6IBexjiuqfmoA7LK1MMBXMXu2C1V0o+stnJbsEsxpasG6TaGl3yYl
         AyjcrzK/vF9wFWdB6pKfz3t1/9gi6PSYbc7P71ERhlyNzGcY2W3PDIr3zZ1SPeltW7Pe
         ZEPdSJHkuEwtQ3b1kPteePTwFfuQ6E6Tc9awIXEX1WiO1/oBIm46CxbijVcyYsAG82i1
         GG++fdRJRHsHs0QgK3HYNnyQlem7D3HGoTOO7mS1fv0RtN3b1Kw3N3i5wwkJIHqAtnw2
         JqPjYQmXBmb3RC+YBsKLXeRQp1f0F3q+wDZ6wCUNA1dBIPXtCc4wIkzj5un6Id4diTHs
         d2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=29gdIvzBqOOrpiwyb6jnmZKHmXeKs8PHD7X77mXmZ7k=;
        b=fD63dd5oH3hGzMW8wvjWOzqzXgV4QvnBkljvRMPZcbH/CzWm+gdubQrTJWarAeb6n1
         CMUhubmoQuVxQj9yBCDVkTutrX1C4l3doA6RKJukERkAUqVCj/Hre+wFfSVvu536ggg0
         o61MNrUSwZtWiCH0/fS46shpL9myIkdcLiyMpiXWgh/TFMDkzi/NoRMi2jDGFIG7AFTy
         U4xmIEmmubFaqY4PTosg5FaS2mu4xtAdB76ImNn3xbKBNdCmyfdRlAGjL2MmRi5V8ed6
         ApTg8T/med92RzRrr2ek0PeFBUxBtG/mJzRGi1Wrv94OEzkIeD2VAC9eijlOYgFLjYuw
         wFqg==
X-Gm-Message-State: APjAAAUs7unYts91yzIFrF3Vm3RoOz2Y4LW21akEa126r4Dpzh8L+8Zu
        lFlu1S0rEVtVSGvkm5M8hwmtnJsHTioGJg==
X-Google-Smtp-Source: APXvYqzQHO8Zq0IdWt3MHBHS9hTGMRhjQM0uCYe128SeLDawtB531iR11NGrL4KLQwZOUJI1JiKi1PqPfo0O2w==
X-Received: by 2002:aca:ab13:: with SMTP id u19mr623903oie.127.1560486159387;
 Thu, 13 Jun 2019 21:22:39 -0700 (PDT)
Date:   Thu, 13 Jun 2019 21:22:35 -0700
Message-Id: <20190614042235.15918-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next] ipv4: tcp: fix ACK/RST sent with a transmit delay
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we want to set a EDT time for the skb we want to send
via ip_send_unicast_reply(), we have to pass a new parameter
and initialize ipc.sockc.transmit_time with it.

This fixes the EDT time for ACK/RST packets sent on behalf of
a TIME_WAIT socket.

Fixes: a842fe1425cb ("tcp: add optional per socket transmit delay")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h     |  2 +-
 include/net/tcp.h    |  9 ++++++---
 net/ipv4/ip_output.c |  3 ++-
 net/ipv4/tcp_ipv4.c  | 14 +++++++++-----
 net/ipv6/tcp_ipv6.c  |  2 +-
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 6dbf88ea07f1a99a1f9e58d7e5c22e3b5da5df96..29d89de39822288f7b61d20c96374cfed5f6b8fb 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -279,7 +279,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len);
+			   unsigned int len, u64 transmit_time);
 
 #define IP_INC_STATS(net, field)	SNMP_INC_STATS64((net)->mib.ip_statistics, field)
 #define __IP_INC_STATS(net, field)	__SNMP_INC_STATS64((net)->mib.ip_statistics, field)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 49a178b8d5b2fafcbbeda53506ea38e3adb0f9dd..96e0e53ff4408d13d4b062f0f81f94552660b68e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2240,15 +2240,18 @@ static inline void tcp_add_tx_delay(struct sk_buff *skb,
 		skb->skb_mstamp_ns += (u64)tp->tcp_tx_delay * NSEC_PER_USEC;
 }
 
-static inline void tcp_set_tx_time(struct sk_buff *skb,
-				   const struct sock *sk)
+/* Compute Earliest Departure Time for some control packets
+ * like ACK or RST for TIME_WAIT or non ESTABLISHED sockets.
+ */
+static inline u64 tcp_transmit_time(const struct sock *sk)
 {
 	if (static_branch_unlikely(&tcp_tx_delay_enabled)) {
 		u32 delay = (sk->sk_state == TCP_TIME_WAIT) ?
 			tcp_twsk(sk)->tw_tx_delay : tcp_sk(sk)->tcp_tx_delay;
 
-		skb->skb_mstamp_ns = tcp_clock_ns() + (u64)delay * NSEC_PER_USEC;
+		return tcp_clock_ns() + (u64)delay * NSEC_PER_USEC;
 	}
+	return 0;
 }
 
 #endif	/* _TCP_H */
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f5636ab0b9c32fa47eaa5417fec7cdc47e4dabc2..e0ac39072a9c8fc755d2904d5f61ae49ac3c416f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1632,7 +1632,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len)
+			   unsigned int len, u64 transmit_time)
 {
 	struct ip_options_data replyopts;
 	struct ipcm_cookie ipc;
@@ -1648,6 +1648,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	ipcm_init(&ipc);
 	ipc.addr = daddr;
+	ipc.sockc.transmit_time = transmit_time;
 
 	if (replyopts.opt.opt.optlen) {
 		ipc.opt = &replyopts.opt;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1b7e9e1fbd3be3670a7fe9da4978f7a2e0959f58..633e8244ed5b6abe4964f8f078961dcbef17a296 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -662,8 +662,9 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	int genhash;
 	struct sock *sk1 = NULL;
 #endif
-	struct net *net;
+	u64 transmit_time = 0;
 	struct sock *ctl_sk;
+	struct net *net;
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -770,12 +771,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
-		tcp_set_tx_time(skb, sk);
+		transmit_time = tcp_transmit_time(sk);
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
-			      &arg, arg.iov[0].iov_len);
+			      &arg, arg.iov[0].iov_len,
+			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
@@ -810,6 +812,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
 	struct sock *ctl_sk;
+	u64 transmit_time;
 
 	memset(&rep.th, 0, sizeof(struct tcphdr));
 	memset(&arg, 0, sizeof(arg));
@@ -863,11 +866,12 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
-	tcp_set_tx_time(skb, sk);
+	transmit_time = tcp_transmit_time(sk);
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
-			      &arg, arg.iov[0].iov_len);
+			      &arg, arg.iov[0].iov_len,
+			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5606b2131b653572f8ef6cdb6af5a118d5f4934d..408d9ec2697154e840a26675765e8a9c1636ada4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -892,7 +892,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		} else {
 			mark = sk->sk_mark;
 		}
-		tcp_set_tx_time(buff, sk);
+		buff->tstamp = tcp_transmit_time(sk);
 	}
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, skb->mark) ?: mark;
 	fl6.fl6_dport = t1->dest;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

