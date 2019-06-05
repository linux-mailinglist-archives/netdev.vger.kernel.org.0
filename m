Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985F035FAB
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfFEOzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:55:18 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:42635 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfFEOzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 10:55:18 -0400
Received: by mail-yw1-f73.google.com with SMTP id k142so22905742ywa.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 07:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VKRRPENs7ml+2PfTSz7fRwaPidY1NZCe4LnCpctxnGw=;
        b=En/WeXoP0lDURM0t+yTg/vdbHG0S4zlIptSQV3cvW4KtvzioGKoNSGQEQFE+CqWlFj
         APDJppyFiC1pnmYLk8cqDOaXmnOl0P5YGNwutRRsmu4hzh6VLO+8Ws8TD8ZUclYwwHX/
         YXxJIgI+JbePj4KwN3jVjx4vwF4N0aVKWxylj6ekNtPmxDPguG/Q3A3wxYuLxNX9Y67E
         c1WURW5J8lyxWp2aYtZletzxRjxlA2dYIs06gVHB/NE/GFgPDAf+jLDS01EdHod9UEeF
         wUKxl9VltcWAo/N5I58+X+YwQKaTpa78a9+832dvz5wjpfTCz9lJrESgDv44h1AO9+ae
         aHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VKRRPENs7ml+2PfTSz7fRwaPidY1NZCe4LnCpctxnGw=;
        b=GG0UO3W4M9YLvxXUmVVMypRhenDJCn2oTZZ7M4CBP3zx1/RREuydZ9EB7QFdOIDTKb
         VtbYxDtIyMAORQWKbREguijRZRwrpfQjaDYcopK7PQ2b91xtYdymbMWc4vnVi8Z8Sj0D
         9RqzKEVu4ZQuIsqQwgZqXRvPhgNZmdw34budDwGVuP5c0xZkz7WVsUOxsDs1ik3wB5dq
         fwLy9QAr0tgc9i/bfRkNiMiGVYtThxfOx0OyKpD3Iht0Cpzk3HqBeG1jtpu0KE+vDlbL
         EDpxWxXRN3TIpOAeDHCxlFoP43HJ2miDpqzoza96V3IBrTv+IWIUzWSHR/5xivSuwT+n
         L+KQ==
X-Gm-Message-State: APjAAAUcbRUpgKrPbSwFIoTujUIC0BWy6aMBBKv6gy3KFZm/rcK/JRjR
        3bodA05z0YtQ6J6rAqF8WVi2AsCfG85rJQ==
X-Google-Smtp-Source: APXvYqwnLGYx60x0PJA/0n/Hf/YYjsZTFAUF7PhHX06A1/LCHqrSb7jwK73v4I9wT7/VzZCOcxmPpT+uyGLgaQ==
X-Received: by 2002:a81:f111:: with SMTP id h17mr4607618ywm.36.1559746517151;
 Wed, 05 Jun 2019 07:55:17 -0700 (PDT)
Date:   Wed,  5 Jun 2019 07:55:09 -0700
In-Reply-To: <20190605145510.74527-1-edumazet@google.com>
Message-Id: <20190605145510.74527-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190605145510.74527-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v2 net-next 1/2] ipv6: tcp: enable flowlabel reflection in
 some RST packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When RST packets are sent because no socket could be found,
it makes sense to use flowlabel_reflect sysctl to decide
if a reflection of the flowlabel is requested.

This extends commit 22b6722bfa59 ("ipv6: Add sysctl for per
namespace flow label reflection"), for some TCP RST packets.

In order to provide full control of this new feature,
flowlabel_reflect becomes a bitmask.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.txt | 20 +++++++++++++++-----
 net/ipv6/af_inet6.c                    |  2 +-
 net/ipv6/sysctl_net_ipv6.c             |  3 +++
 net/ipv6/tcp_ipv6.c                    | 13 ++++++++++---
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index a73b3a02e49aa4e2a072e366845d36e30ffa44ea..f4b1043e92edc78e93a64eaec467ea615ee21eab 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1429,14 +1429,24 @@ flowlabel_state_ranges - BOOLEAN
 	FALSE: disabled
 	Default: true
 
-flowlabel_reflect - BOOLEAN
-	Automatically reflect the flow label. Needed for Path MTU
+flowlabel_reflect - INTEGER
+	Control flow label reflection. Needed for Path MTU
 	Discovery to work with Equal Cost Multipath Routing in anycast
 	environments. See RFC 7690 and:
 	https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
-	TRUE: enabled
-	FALSE: disabled
-	Default: FALSE
+
+	This is a mask of two bits.
+	1: enabled for established flows
+
+	Note that this prevents automatic flowlabel changes, as done
+	in "tcp: change IPv6 flow-label upon receiving spurious retransmission"
+	and "tcp: Change txhash on every SYN and RTO retransmit"
+
+	2: enabled for TCP RESET packets (no active listener)
+	If set, a RST packet sent in response to a SYN packet on a closed
+	port will reflect the incoming flow label.
+
+	Default: 0
 
 fib_multipath_hash_policy - INTEGER
 	Controls which hash policy to use for multipath routes.
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index cc6f8d0c625afea5b9b76014396fd8f4370ecf20..ceab2fe2833b9f571cd90725902671ef58a04726 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -212,7 +212,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->mc_loop	= 1;
 	np->mc_all	= 1;
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
-	np->repflow	= net->ipv6.sysctl.flowlabel_reflect;
+	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & 1;
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
 
 	/* Init the ipv4 part of the socket since we can have sockets
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index e15cd37024fd9786bc675754514f03f5a8c919c2..6d86fac472e7298cbd8df7aa0b190cf0087675e2 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,6 +23,7 @@
 
 static int zero;
 static int one = 1;
+static int three = 3;
 static int auto_flowlabels_min;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 
@@ -114,6 +115,8 @@ static struct ctl_table ipv6_table_template[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "max_dst_opts_number",
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index beaf284563015ef0677c39fc056e6ecde3518920..4ccb06ea8ce32d614fc0848e1c4e74b441fa1f2c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -916,15 +916,17 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
 #ifdef CONFIG_TCP_MD5SIG
 	const __u8 *hash_location = NULL;
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
 #endif
+	__be32 label = 0;
+	struct net *net;
 	int oif = 0;
 
 	if (th->rst)
@@ -936,6 +938,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (!sk && !ipv6_unicast_destination(skb))
 		return;
 
+	net = dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
@@ -949,7 +952,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 * Incoming packet is checked with md5 hash with finding key,
 		 * no RST generated if md5 hash doesn't match.
 		 */
-		sk1 = inet6_lookup_listener(dev_net(skb_dst(skb)->dev),
+		sk1 = inet6_lookup_listener(net,
 					   &tcp_hashinfo, NULL, 0,
 					   &ipv6h->saddr,
 					   th->source, &ipv6h->daddr,
@@ -979,9 +982,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk))
 			trace_tcp_send_reset(sk, skb);
+	} else {
+		if (net->ipv6.sysctl.flowlabel_reflect & 2)
+			label = ip6_flowlabel(ipv6h);
 	}
 
-	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0, 0);
+	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0,
+			     label);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
-- 
2.22.0.rc1.311.g5d7573a151-goog

