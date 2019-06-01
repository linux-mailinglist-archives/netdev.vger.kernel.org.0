Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE093205A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFASYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:15 -0400
Received: from mail.us.es ([193.147.175.20]:40028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfFASYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F2282FEFA8
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB02BDA701
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90544FF2C1; Sat,  1 Jun 2019 20:23:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B32F1DA720;
        Sat,  1 Jun 2019 20:23:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 57C2F4265A32;
        Sat,  1 Jun 2019 20:23:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/15] netfilter: ipvs: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:33 +0200
Message-Id: <20190601182340.2662-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

It does the same thing, use it instead so we can remove skb_make_writable.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_app.c        |  4 ++--
 net/netfilter/ipvs/ip_vs_core.c       |  4 ++--
 net/netfilter/ipvs/ip_vs_ftp.c        |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_udp.c  |  4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c       | 12 ++++++------
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 7588aeaa605f..ba34ac25ee7b 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -363,7 +363,7 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (!skb_make_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
 		return 0;
 
 	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
@@ -440,7 +440,7 @@ static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (!skb_make_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
 		return 0;
 
 	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d1d7b2483fd7..90adca9a5510 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -898,7 +898,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	if (IPPROTO_TCP == protocol || IPPROTO_UDP == protocol ||
 	    IPPROTO_SCTP == protocol)
 		offset += 2 * sizeof(__u16);
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto out;
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1288,7 +1288,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 	IP_VS_DBG_PKT(11, af, pp, skb, iph->off, "Outgoing packet");
 
-	if (!skb_make_writable(skb, iph->len))
+	if (skb_ensure_writable(skb, iph->len))
 		goto drop;
 
 	/* mangle the packet */
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index fe69d46ff779..5cbefa927f09 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -273,7 +273,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 
 	/* Linear packets are much easier to deal with. */
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return 0;
 
 	if (cp->app_data == (void *) IP_VS_FTP_PASV) {
@@ -439,7 +439,7 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 
 	/* Linear packets are much easier to deal with. */
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return 0;
 
 	data = data_start = ip_vs_ftp_data_ptr(skb, ipvsh);
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index b58ddb7dffd1..a0921adc31a9 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -101,7 +101,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 #endif
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, sctphoff + sizeof(*sctph)))
+	if (skb_ensure_writable(skb, sctphoff + sizeof(*sctph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -148,7 +148,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 #endif
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, sctphoff + sizeof(*sctph)))
+	if (skb_ensure_writable(skb, sctphoff + sizeof(*sctph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 00ce07dda980..089ee592a955 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -163,7 +163,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - tcphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, tcphoff+sizeof(*tcph)))
+	if (skb_ensure_writable(skb, tcphoff + sizeof(*tcph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -241,7 +241,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - tcphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, tcphoff+sizeof(*tcph)))
+	if (skb_ensure_writable(skb, tcphoff + sizeof(*tcph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index 92c078abcb3e..de366aa3c03b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -153,7 +153,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - udphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, udphoff+sizeof(*udph)))
+	if (skb_ensure_writable(skb, udphoff + sizeof(*udph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -236,7 +236,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - udphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, udphoff+sizeof(*udph)))
+	if (skb_ensure_writable(skb, udphoff + sizeof(*udph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 8d6f94b67772..0b41d0504429 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -279,7 +279,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 		}
 
 		/* don't propagate ttl change to cloned packets */
-		if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return false;
 
 		ipv6_hdr(skb)->hop_limit--;
@@ -294,7 +294,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 		}
 
 		/* don't propagate ttl change to cloned packets */
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return false;
 
 		/* Decrease ttl */
@@ -796,7 +796,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+	if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -885,7 +885,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+	if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -1404,7 +1404,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -1493,7 +1493,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
-- 
2.11.0

