Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470802B8FA8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgKSJ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:58:43 -0500
Received: from aer-iport-2.cisco.com ([173.38.203.52]:38034 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgKSJ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4745; q=dns/txt; s=iport;
  t=1605779921; x=1606989521;
  h=from:to:cc:subject:date:message-id;
  bh=XpH5Llq5yqOXzUfAm72xjR7OmEhimEezllApczko3xg=;
  b=iBewRdPjFqN4VQdesa5jmEv/I95NGVxPhlzWMd/A2L+S12wiM+TqF+zI
   4Vf4e0JYwOvobsq/jnJVtcU2GifP8SxTDCa4VenFwZ+nm3ZwM4WBFu/Gc
   RuiGyZAQmFFwA+6kDgNwDfXQ5Km6UjrGbE6BkCslO2YP3Q6XbzdJ0pCvO
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,490,1596499200"; 
   d="scan'208";a="31245973"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Nov 2020 09:58:40 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 0AJ9wd5u019107;
        Thu, 19 Nov 2020 09:58:39 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, rdunlap@infradead.org,
        Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net v2] ipv6: Remove dependency of ipv6_frag_thdr_truncated on ipv6 module
Date:   Thu, 19 Nov 2020 10:58:33 +0100
Message-Id: <20201119095833.8409-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPV6=m
NF_DEFRAG_IPV6=y

ld: net/ipv6/netfilter/nf_conntrack_reasm.o: in function
`nf_ct_frag6_gather':
net/ipv6/netfilter/nf_conntrack_reasm.c:462: undefined reference to
`ipv6_frag_thdr_truncated'

Netfilter is depending on ipv6 symbol ipv6_frag_thdr_truncated. This
dependency is forcing IPV6=y.

Remove this dependency by moving ipv6_frag_thdr_truncated out of ipv6. This
is the same solution as used with a similar issues: Referring to
commit 70b095c843266 ("ipv6: remove dependency of nf_defrag_ipv6 on ipv6
module")

Fixes: 9d9e937b1c8b ("ipv6/netfilter: Discard first fragment not including all headers")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---

Notes:
    v2: Add Fixes tag and fix spelling in comment.

 include/net/ipv6.h                      |  2 --
 include/net/ipv6_frag.h                 | 30 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   | 31 +------------------------------
 4 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 637cc6d..bd1f396 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1064,8 +1064,6 @@ int ipv6_skip_exthdr(const struct sk_buff *, int start, u8 *nexthdrp,
 
 bool ipv6_ext_hdr(u8 nexthdr);
 
-bool ipv6_frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp);
-
 enum {
 	IP6_FH_F_FRAG		= (1 << 0),
 	IP6_FH_F_AUTH		= (1 << 1),
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index a21e8b1..851029e 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -108,5 +108,35 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	rcu_read_unlock();
 	inet_frag_put(&fq->q);
 }
+
+/* Check if the upper layer header is truncated in the first fragment. */
+static inline bool
+ipv6frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp)
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
+
 #endif
 #endif
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index b9cc0b3..c129ad3 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -459,7 +459,7 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	/* Discard the first fragment if it does not include all headers
 	 * RFC 8200, Section 4.5
 	 */
-	if (ipv6_frag_thdr_truncated(skb, fhoff, &nexthdr)) {
+	if (ipv6frag_thdr_truncated(skb, fhoff, &nexthdr)) {
 		pr_debug("Drop incomplete fragment\n");
 		return 0;
 	}
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index e3869ba..47a0dc4 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -318,35 +318,6 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	return -1;
 }
 
-/* Check if the upper layer header is truncated in the first fragment. */
-bool ipv6_frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp)
-{
-	u8 nexthdr = *nexthdrp;
-	__be16 frag_off;
-	int offset;
-
-	offset = ipv6_skip_exthdr(skb, start, &nexthdr, &frag_off);
-	if (offset < 0 || (frag_off & htons(IP6_OFFSET)))
-		return false;
-	switch (nexthdr) {
-	case NEXTHDR_TCP:
-		offset += sizeof(struct tcphdr);
-		break;
-	case NEXTHDR_UDP:
-		offset += sizeof(struct udphdr);
-		break;
-	case NEXTHDR_ICMP:
-		offset += sizeof(struct icmp6hdr);
-		break;
-	default:
-		offset += 1;
-	}
-	if (offset > skb->len)
-		return true;
-	return false;
-}
-EXPORT_SYMBOL(ipv6_frag_thdr_truncated);
-
 static int ipv6_frag_rcv(struct sk_buff *skb)
 {
 	struct frag_hdr *fhdr;
@@ -390,7 +361,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	 * the source of the fragment, with the Pointer field set to zero.
 	 */
 	nexthdr = hdr->nexthdr;
-	if (ipv6_frag_thdr_truncated(skb, skb_transport_offset(skb), &nexthdr)) {
+	if (ipv6frag_thdr_truncated(skb, skb_transport_offset(skb), &nexthdr)) {
 		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
 				IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
-- 
2.10.2

