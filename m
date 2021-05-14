Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31138104E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhENTKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231302AbhENTKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22FFD6144B;
        Fri, 14 May 2021 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621019371;
        bh=PqJDk1+YGNhwagzGow4dnnsNttq2zfcBvwq2qAorHy4=;
        h=From:To:Cc:Subject:Date:From;
        b=WMcgTsbAxkF+PHTVTzKTNxzcnMaIvcK2T7NsJ1kJF8630huPx7nuVb4ykgbOA2NmW
         57EjdHCZ0/9q/mVjpNSj4OW6L64/Py26PiQJMsuFAhNaybiRQ0nH6vZUT0GVau8Hz5
         JwXBiGeoM76MmGpNlQINMdzg50OnIBviX7E75hcwZ1aTXVqHkMnOH9rEX5mLhXmGC2
         qoONMxHepgUHugjExqojkZNL6nqWmqtX5vtCvZZdnchCIe46G2FyudCyKMmwHr2BN1
         /sSEOMaw5BHDdUxcMh+loQIRruCnV1oTKQfd5E7kbxBGkA8rs2bqew3r6yEmXyBHr/
         oN+1OUqDmjPMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, rostedt@goodmis.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tcp: add tracepoint for checksum errors
Date:   Fri, 14 May 2021 12:09:29 -0700
Message-Id: <20210514190929.272348-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint for capturing TCP segments with
a bad checksum. This makes it easy to identify
sources of bad frames in the fleet (e.g. machines
with faulty NICs).

It should also help tools like IOvisor's tcpdrop.py
which are used today to get detailed information
about such packets.

We don't have a socket in many cases so we must
open code the address extraction based just on
the skb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/trace/events/tcp.h | 76 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c       |  1 +
 net/ipv4/tcp_ipv4.c        |  3 ++
 net/ipv6/tcp_ipv6.c        |  2 +
 4 files changed, 82 insertions(+)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index ba94857eea11..521059d8dc0a 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -295,6 +295,82 @@ TRACE_EVENT(tcp_probe,
 		  __entry->srtt, __entry->rcv_wnd, __entry->sock_cookie)
 );
 
+#define TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb)			\
+	do {								\
+		const struct tcphdr *th = (const struct tcphdr *)skb->data; \
+		struct sockaddr_in *v4 = (void *)__entry->saddr;	\
+									\
+		v4->sin_family = AF_INET;				\
+		v4->sin_port = th->source;				\
+		v4->sin_addr.s_addr = ip_hdr(skb)->saddr;		\
+		v4 = (void *)__entry->daddr;				\
+		v4->sin_family = AF_INET;				\
+		v4->sin_port = th->dest;				\
+		v4->sin_addr.s_addr = ip_hdr(skb)->daddr;		\
+	} while (0)
+
+#if IS_ENABLED(CONFIG_IPV6)
+
+#define TP_STORE_ADDR_PORTS_SKB(__entry, skb)				\
+	do {								\
+		const struct iphdr *iph = ip_hdr(skb);			\
+									\
+		if (iph->version == 6) {				\
+			const struct tcphdr *th = (const struct tcphdr *)skb->data; \
+			struct sockaddr_in6 *v6 = (void *)__entry->saddr; \
+									\
+			v6->sin6_family = AF_INET6;			\
+			v6->sin6_port = th->source;			\
+			v6->sin6_addr = ipv6_hdr(skb)->saddr;		\
+			v6 = (void *)__entry->daddr;			\
+			v6->sin6_family = AF_INET6;			\
+			v6->sin6_port = th->dest;			\
+			v6->sin6_addr = ipv6_hdr(skb)->daddr;		\
+		} else							\
+			TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb);	\
+	} while (0)
+
+#else
+
+#define TP_STORE_ADDR_PORTS_SKB(__entry, skb)		\
+	TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb)
+
+#endif
+
+/*
+ * tcp event with only skb
+ */
+DECLARE_EVENT_CLASS(tcp_event_skb,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+		__array(__u8, saddr, sizeof(struct sockaddr_in6))
+		__array(__u8, daddr, sizeof(struct sockaddr_in6))
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+
+		memset(__entry->saddr, 0, sizeof(struct sockaddr_in6));
+		memset(__entry->daddr, 0, sizeof(struct sockaddr_in6));
+
+		TP_STORE_ADDR_PORTS_SKB(__entry, skb);
+	),
+
+	TP_printk("src=%pISpc dest=%pISpc", __entry->saddr, __entry->daddr)
+);
+
+DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4cf4dd532d1c..cd52ce0a2a85 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5885,6 +5885,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	return;
 
 csum_error:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 312184cead57..4f5b68a90be9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1731,6 +1731,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 
 csum_err:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 	goto discard;
@@ -1801,6 +1802,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_checksum_complete(skb))) {
 		bh_unlock_sock(sk);
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		return true;
@@ -2098,6 +2100,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
 		__TCP_INC_STATS(net, TCP_MIB_INERRS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5f47c0b6e3de..4435fa342e7a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1538,6 +1538,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 	return 0;
 csum_err:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 	goto discard;
@@ -1754,6 +1755,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
 		__TCP_INC_STATS(net, TCP_MIB_INERRS);
-- 
2.31.1

