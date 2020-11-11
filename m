Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06A62AEFFA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKKLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:50:39 -0500
Received: from aer-iport-1.cisco.com ([173.38.203.51]:60095 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgKKLuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6166; q=dns/txt; s=iport;
  t=1605095436; x=1606305036;
  h=from:to:cc:subject:date:message-id;
  bh=4199su7uBK8wp/VR0XBmY9yN9VAU3ulCdirTolmFEBM=;
  b=LxHRsmoPrfrQHUE04/G22SNtlwzH3Omfb3TvtPVgZxwJEnkmpHJDYceS
   wn53sjBoiRwhmNmJ+g9U2v1LvbEY+ZyMAvNCrulI1UywT1sy7be+STAAC
   K4CtpuO8XjfbrrO7mYQqgz1EE3YpvzmgurEuVL+CNSL4ckP0nF2z2JFmM
   w=;
X-IronPort-AV: E=Sophos;i="5.77,469,1596499200"; 
   d="scan'208";a="31035493"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 11 Nov 2020 11:50:33 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 0ABBoWdC001257;
        Wed, 11 Nov 2020 11:50:32 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net v4] ipv6/netfilter: Discard first fragment not including all headers
Date:   Wed, 11 Nov 2020 12:50:25 +0100
Message-Id: <20201111115025.28879-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets are processed even though the first fragment don't include all
headers through the upper layer header. This breaks TAHI IPv6 Core
Conformance Test v6LC.1.3.6.

Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
all headers through an Upper-Layer header, then that fragment should be
discarded and an ICMP Parameter Problem, Code 3, message should be sent to
the source of the fragment, with the Pointer field set to zero."

The fragment needs to be validated the same way it is done in
commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
include all headers") for ipv6. Wrap the validation into a common function,
ipv6_frag_thdr_truncated() to check for truncation in the upper layer
header. This validation does not fullfill all aspects of RFC 8200,
section 4.5, but is at the moment sufficient to pass mentioned TAHI test.

In netfilter, utilize the fragment offset returned by find_prev_fhdr() to
let ipv6_frag_thdr_truncated() start it's traverse from the fragment
header.

Return 0 to drop the fragment in the netfilter. This is the same behaviour
as used on other protocol errors in this function, e.g. when
nf_ct_frag6_queue() returns -EPROTO. The Fragment will later be picked up
by ipv6_frag_rcv() in reassembly.c. ipv6_frag_rcv() will then send an
appropriate ICMP Parameter Problem message back to the source.

References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
fragment don't include all headers")

Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---

Notes:
    v2: Wrap fragment validation code into exthdrs_code.c for use by both ipv6 and
    netfiter.
    
    v3: Remove unused variable frag_off from ipv6_frag_rcv().
    
    v4:
    a) Rename ipv6_frag_validate() to ipv6_frag_thdr_truncated() and invert
       returned bool values. Refrazing function comment.
    b) Move ipv6_frag_thdr_truncated() to reassembly.c
    c) Reverse conditions to return early and reduce indentation after
       ipv6_skip_exthdr() call.

 include/net/ipv6.h                      |  2 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c |  9 ++++++
 net/ipv6/reassembly.c                   | 55 +++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bd1f396..637cc6d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1064,6 +1064,8 @@ int ipv6_skip_exthdr(const struct sk_buff *, int start, u8 *nexthdrp,
 
 bool ipv6_ext_hdr(u8 nexthdr);
 
+bool ipv6_frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp);
+
 enum {
 	IP6_FH_F_FRAG		= (1 << 0),
 	IP6_FH_F_AUTH		= (1 << 1),
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 054d287..b9cc0b3 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -440,6 +440,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 {
 	u16 savethdr = skb->transport_header;
+	u8 nexthdr = NEXTHDR_FRAGMENT;
 	int fhoff, nhoff, ret;
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
@@ -455,6 +456,14 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
 		return 0;
 
+	/* Discard the first fragment if it does not include all headers
+	 * RFC 8200, Section 4.5
+	 */
+	if (ipv6_frag_thdr_truncated(skb, fhoff, &nexthdr)) {
+		pr_debug("Drop incomplete fragment\n");
+		return 0;
+	}
+
 	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
 		return -ENOMEM;
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index c8cf1bb..e3869ba 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -318,15 +318,43 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	return -1;
 }
 
+/* Check if the upper layer header is truncated in the first fragment. */
+bool ipv6_frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp)
+{
+	u8 nexthdr = *nexthdrp;
+	__be16 frag_off;
+	int offset;
+
+	offset = ipv6_skip_exthdr(skb, start, &nexthdr, &frag_off);
+	if (offset < 0 || (frag_off & htons(IP6_OFFSET)))
+		return false;
+	switch (nexthdr) {
+	case NEXTHDR_TCP:
+		offset += sizeof(struct tcphdr);
+		break;
+	case NEXTHDR_UDP:
+		offset += sizeof(struct udphdr);
+		break;
+	case NEXTHDR_ICMP:
+		offset += sizeof(struct icmp6hdr);
+		break;
+	default:
+		offset += 1;
+	}
+	if (offset > skb->len)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(ipv6_frag_thdr_truncated);
+
 static int ipv6_frag_rcv(struct sk_buff *skb)
 {
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
-	__be16 frag_off;
-	int iif, offset;
 	u8 nexthdr;
+	int iif;
 
 	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
 		goto fail_hdr;
@@ -362,24 +390,11 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	 * the source of the fragment, with the Pointer field set to zero.
 	 */
 	nexthdr = hdr->nexthdr;
-	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
-	if (offset >= 0) {
-		/* Check some common protocols' header */
-		if (nexthdr == IPPROTO_TCP)
-			offset += sizeof(struct tcphdr);
-		else if (nexthdr == IPPROTO_UDP)
-			offset += sizeof(struct udphdr);
-		else if (nexthdr == IPPROTO_ICMPV6)
-			offset += sizeof(struct icmp6hdr);
-		else
-			offset += 1;
-
-		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
-			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
-					IPSTATS_MIB_INHDRERRORS);
-			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
-			return -1;
-		}
+	if (ipv6_frag_thdr_truncated(skb, skb_transport_offset(skb), &nexthdr)) {
+		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
+				IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+		return -1;
 	}
 
 	iif = skb->dev ? skb->dev->ifindex : 0;
-- 
2.10.2

