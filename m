Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDF12A64C2
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgKDNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:01:54 -0500
Received: from aer-iport-1.cisco.com ([173.38.203.51]:3919 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgKDNBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:01:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3128; q=dns/txt; s=iport;
  t=1604494912; x=1605704512;
  h=from:to:cc:subject:date:message-id;
  bh=Xedl5loCyFTqDwsd8vz4oe/M0aI9zoTGkjKi7JduHxw=;
  b=V8bH9mbLpzVOusQGubPwAzkyF4+dDwsqDDJftpQvbt5BlWEGD+XgYHU8
   UNQVy9zOiM93boAQoIxubY7gDHOK2HQkPxFLgoLgRhBUAALXRQZKBoQGi
   69x56oxuh0pYWcnp+7Ulqz3mVUoFMw49SJjz9d/OmO++bLxd5A4GIBUfC
   w=;
X-IronPort-AV: E=Sophos;i="5.77,450,1596499200"; 
   d="scan'208";a="30856083"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Nov 2020 13:01:51 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 0A4D1o83028097;
        Wed, 4 Nov 2020 13:01:50 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net] ipv6/netfilter: Discard first fragment not including all headers
Date:   Wed,  4 Nov 2020 14:01:28 +0100
Message-Id: <20201104130128.14619-1-geokohma@cisco.com>
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

Utilize the fragment offset returned by find_prev_fhdr() to let
ipv6_skip_exthdr() start it's traverse from the fragment header.
Apply the same logic for checking that all headers are included as used
in commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
include all headers"). Check that TCP, UDP and ICMP headers are completely
included in the fragment and all other headers are included with at least
one byte.

Return 0 to drop the fragment. This is the same behaviour as used on other
protocol errors in this function, e.g. when nf_ct_frag6_queue() returns
-EPROTO. The Fragment will later be picked up by ipv6_frag_rcv() in
reassembly.c. ipv6_frag_rcv() will then send an appropriate ICMP Parameter
Problem message back to the source.

References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
fragment don't include all headers")
Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 054d287..dffa3a8 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -440,11 +440,13 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 {
 	u16 savethdr = skb->transport_header;
-	int fhoff, nhoff, ret;
+	int fhoff, nhoff, ret, offset;
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
 	struct ipv6hdr *hdr;
 	u8 prevhdr;
+	u8 nexthdr = NEXTHDR_FRAGMENT;
+	__be16 frag_off;
 
 	/* Jumbo payload inhibits frag. header */
 	if (ipv6_hdr(skb)->payload_len == 0) {
@@ -455,6 +457,30 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
 		return 0;
 
+	/* Discard the first fragment if it does not include all headers
+	 * RFC 8200, Section 4.5
+	 */
+	offset = ipv6_skip_exthdr(skb, fhoff, &nexthdr, &frag_off);
+	if (offset >= 0 && !(frag_off & htons(IP6_OFFSET))) {
+		switch (nexthdr) {
+		case NEXTHDR_TCP:
+			offset += sizeof(struct tcphdr);
+			break;
+		case NEXTHDR_UDP:
+			offset += sizeof(struct udphdr);
+			break;
+		case NEXTHDR_ICMP:
+			offset += sizeof(struct icmp6hdr);
+			break;
+		default:
+			offset += 1;
+		}
+		if (offset > skb->len) {
+			pr_debug("Drop incomplete fragment\n");
+			return 0;
+		}
+	}
+
 	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
 		return -ENOMEM;
 
-- 
2.10.2

