Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5228AB76
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgJLBig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:38:36 -0400
Received: from correo.us.es ([193.147.175.20]:41740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbgJLBid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C22C4E7817
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4188DA789
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9733DA72F; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A258DA704;
        Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6C97741FF201;
        Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/6] netfilter: flowtable: reduce calls to pskb_may_pull()
Date:   Mon, 12 Oct 2020 03:38:19 +0200
Message-Id: <20201012013819.23128-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make two unfront calls to pskb_may_pull() to linearize the network and
transport header.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 12 +++-----
 net/netfilter/nf_flow_table_ip.c   | 45 +++++++++++++++++-------------
 2 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4f7a567c536e..513f78db3cb2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -395,8 +395,7 @@ static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -410,8 +409,7 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -449,8 +447,7 @@ int nf_flow_snat_port(const struct flow_offload *flow,
 	struct flow_ports *hdr;
 	__be16 port, new_port;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*hdr)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*hdr)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*hdr)))
 		return -1;
 
 	hdr = (void *)(skb_network_header(skb) + thoff);
@@ -481,8 +478,7 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 	struct flow_ports *hdr;
 	__be16 port, new_port;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*hdr)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*hdr)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*hdr)))
 		return -1;
 
 	hdr = (void *)(skb_network_header(skb) + thoff);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a3bca758b849..a698dbe28ef5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -25,9 +25,6 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 	if (proto != IPPROTO_TCP)
 		return 0;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
-		return -1;
-
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
 		flow_offload_teardown(flow);
@@ -42,8 +39,7 @@ static int nf_flow_nat_ip_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -57,8 +53,7 @@ static int nf_flow_nat_ip_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -167,8 +162,8 @@ static bool ip_has_options(unsigned int thoff)
 static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 			    struct flow_offload_tuple *tuple)
 {
+	unsigned int thoff, hdrsize;
 	struct flow_ports *ports;
-	unsigned int thoff;
 	struct iphdr *iph;
 
 	if (!pskb_may_pull(skb, sizeof(*iph)))
@@ -181,15 +176,22 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	    unlikely(ip_has_options(thoff)))
 		return -1;
 
-	if (iph->protocol != IPPROTO_TCP &&
-	    iph->protocol != IPPROTO_UDP)
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(struct udphdr);
+		break;
+	default:
 		return -1;
+	}
 
 	if (iph->ttl <= 1)
 		return -1;
 
 	thoff = iph->ihl * 4;
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, thoff + hdrsize))
 		return -1;
 
 	iph = ip_hdr(skb);
@@ -315,8 +317,7 @@ static int nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -332,8 +333,7 @@ static int nf_flow_nat_ipv6_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -439,24 +439,31 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 			      struct flow_offload_tuple *tuple)
 {
+	unsigned int thoff, hdrsize;
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
-	unsigned int thoff;
 
 	if (!pskb_may_pull(skb, sizeof(*ip6h)))
 		return -1;
 
 	ip6h = ipv6_hdr(skb);
 
-	if (ip6h->nexthdr != IPPROTO_TCP &&
-	    ip6h->nexthdr != IPPROTO_UDP)
+	switch (ip6h->nexthdr) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(struct udphdr);
+		break;
+	default:
 		return -1;
+	}
 
 	if (ip6h->hop_limit <= 1)
 		return -1;
 
 	thoff = sizeof(*ip6h);
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, thoff + hdrsize))
 		return -1;
 
 	ip6h = ipv6_hdr(skb);
-- 
2.20.1

