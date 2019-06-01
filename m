Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C61732054
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfFASYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:10 -0400
Received: from mail.us.es ([193.147.175.20]:40068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbfFASYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F11B9B60FF
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D34FDDA70A
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5F5D3FF2C7; Sat,  1 Jun 2019 20:23:57 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A901FF151;
        Sat,  1 Jun 2019 20:23:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0FBB54265A32;
        Sat,  1 Jun 2019 20:23:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/15] netfilter: conntrack, nat: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:34 +0200
Message-Id: <20190601182340.2662-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

like previous patches -- convert conntrack to use the core helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c |  2 +-
 net/netfilter/nf_conntrack_seqadj.c     |  4 ++--
 net/netfilter/nf_nat_helper.c           |  4 ++--
 net/netfilter/nf_nat_proto.c            | 24 ++++++++++++------------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5b8dde266412..07c5208a4ea0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -339,7 +339,7 @@ static bool sctp_error(struct sk_buff *skb,
 	if (state->hook == NF_INET_PRE_ROUTING &&
 	    state->net->ct.sysctl_checksum &&
 	    skb->ip_summed == CHECKSUM_NONE) {
-		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
+		if (skb_ensure_writable(skb, dataoff + sizeof(*sh))) {
 			logmsg = "nf_ct_sctp: failed to read header ";
 			goto out_invalid;
 		}
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index dc21a43cd145..3066449f8bd8 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -126,7 +126,7 @@ static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + tcph->doff * 4;
 
-	if (!skb_make_writable(skb, optend))
+	if (skb_ensure_writable(skb, optend))
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
@@ -176,7 +176,7 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
 	this_way  = &seqadj->seq[dir];
 	other_way = &seqadj->seq[!dir];
 
-	if (!skb_make_writable(skb, protoff + sizeof(*tcph)))
+	if (skb_ensure_writable(skb, protoff + sizeof(*tcph)))
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index ccc06f7539d7..03e8e2d79375 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -98,7 +98,7 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 	struct tcphdr *tcph;
 	int oldlen, datalen;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return false;
 
 	if (rep_len > match_len &&
@@ -148,7 +148,7 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	struct udphdr *udph;
 	int datalen, oldlen;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return false;
 
 	if (rep_len > match_len &&
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 84f5c90a7f21..04a6c1ac2526 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -73,7 +73,7 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 	struct udphdr *hdr;
 	bool do_csum;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -91,7 +91,7 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	struct udphdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -117,7 +117,7 @@ sctp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(*hdr))
 		hdrsize = sizeof(*hdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct sctphdr *)(skb->data + hdroff);
@@ -158,7 +158,7 @@ tcp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(struct tcphdr))
 		hdrsize = sizeof(struct tcphdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct tcphdr *)(skb->data + hdroff);
@@ -198,7 +198,7 @@ dccp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(struct dccp_hdr))
 		hdrsize = sizeof(struct dccp_hdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct dccp_hdr *)(skb->data + hdroff);
@@ -232,7 +232,7 @@ icmp_manip_pkt(struct sk_buff *skb,
 {
 	struct icmphdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
@@ -250,7 +250,7 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 {
 	struct icmp6hdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct icmp6hdr *)(skb->data + hdroff);
@@ -278,7 +278,7 @@ gre_manip_pkt(struct sk_buff *skb,
 
 	/* pgreh includes two optional 32bit fields which are not required
 	 * to be there.  That's where the magic '8' comes from */
-	if (!skb_make_writable(skb, hdroff + sizeof(*pgreh) - 8))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*pgreh) - 8))
 		return false;
 
 	greh = (void *)skb->data + hdroff;
@@ -350,7 +350,7 @@ static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 	struct iphdr *iph;
 	unsigned int hdroff;
 
-	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
+	if (skb_ensure_writable(skb, iphdroff + sizeof(*iph)))
 		return false;
 
 	iph = (void *)skb->data + iphdroff;
@@ -381,7 +381,7 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 	int hdroff;
 	u8 nexthdr;
 
-	if (!skb_make_writable(skb, iphdroff + sizeof(*ipv6h)))
+	if (skb_ensure_writable(skb, iphdroff + sizeof(*ipv6h)))
 		return false;
 
 	ipv6h = (void *)skb->data + iphdroff;
@@ -565,7 +565,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
 	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
 		return 0;
@@ -787,7 +787,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 
 	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
 	if (nf_ip6_checksum(skb, hooknum, hdrlen, IPPROTO_ICMPV6))
 		return 0;
-- 
2.11.0

