Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D957CEB1A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfD2Tua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:50:30 -0400
Received: from mail.us.es ([193.147.175.20]:41686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbfD2Tu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:50:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6458B1031B2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EEF0DA713
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4BCBFDA711; Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A3E0DA702;
        Mon, 29 Apr 2019 21:50:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:50:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BFB7D4265A31;
        Mon, 29 Apr 2019 21:50:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH 2/9 net-next,v2] net: ipv6: add skbuff fraglist splitter
Date:   Mon, 29 Apr 2019 21:50:07 +0200
Message-Id: <20190429195014.4724-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190429195014.4724-1-pablo@netfilter.org>
References: <20190429195014.4724-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds skbuff fraglist split iterator. The API provides an
iterator to perform this transformation, it consists of:

* ip6_fraglist_init(), that initializes the internal state of the
  fraglist iterator.
* ip6_fraglist_prepare(), that restores the IPv6 header on the fragment.
* ip6_fraglist_next(), that retrieves the fragment from the fraglist and
  updates the internal state of the iterator to point to the next
  fragment in the fraglist.

The ip6_fraglist_iter object stores the internal state of the iterator.

This code has been extracted from ip6_fragment(). Symbols are also
exported to allow to reuse this iterator from the bridge codepath to
build its own refragmentation routine by reusing the existing codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix English typo in patch description.

 include/net/ipv6.h    |  25 ++++++++++
 net/ipv6/ip6_output.c | 132 +++++++++++++++++++++++++++++---------------------
 2 files changed, 102 insertions(+), 55 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index daf80863d3a5..acefbc718abe 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -154,6 +154,31 @@ struct frag_hdr {
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
+struct ip6_fraglist_iter {
+	struct ipv6hdr	*tmp_hdr;
+	struct sk_buff	*frag_list;
+	struct sk_buff	*frag;
+	int		offset;
+	unsigned int	hlen;
+	__be32		frag_id;
+	u8		nexthdr;
+};
+
+int ip6_fraglist_init(struct sk_buff *skb, unsigned int hlen, u8 *prevhdr,
+		      u8 nexthdr, __be32 frag_id,
+		      struct ip6_fraglist_iter *iter);
+void ip6_fraglist_prepare(struct sk_buff *skb, struct ip6_fraglist_iter *iter);
+
+static inline struct sk_buff *ip6_fraglist_next(struct ip6_fraglist_iter *iter)
+{
+	struct sk_buff *skb = iter->frag;
+
+	iter->frag = skb->next;
+	skb_mark_not_on_list(skb);
+
+	return skb;
+}
+
 #define IP6_REPLY_MARK(net, mark) \
 	((net)->ipv6.sysctl.fwmark_reflect ? (mark) : 0)
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index adef2236abe2..2567b22a888a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -592,6 +592,73 @@ static void ip6_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	skb_copy_secmark(to, from);
 }
 
+int ip6_fraglist_init(struct sk_buff *skb, unsigned int hlen, u8 *prevhdr,
+		      u8 nexthdr, __be32 frag_id,
+		      struct ip6_fraglist_iter *iter)
+{
+	unsigned int first_len;
+	struct frag_hdr *fh;
+
+	/* BUILD HEADER */
+	*prevhdr = NEXTHDR_FRAGMENT;
+	iter->tmp_hdr = kmemdup(skb_network_header(skb), hlen, GFP_ATOMIC);
+	if (!iter->tmp_hdr)
+		return -ENOMEM;
+
+	iter->frag_list = skb_shinfo(skb)->frag_list;
+	iter->frag = iter->frag_list;
+	skb_frag_list_init(skb);
+
+	iter->offset = 0;
+	iter->hlen = hlen;
+	iter->frag_id = frag_id;
+	iter->nexthdr = nexthdr;
+
+	__skb_pull(skb, hlen);
+	fh = __skb_push(skb, sizeof(struct frag_hdr));
+	__skb_push(skb, hlen);
+	skb_reset_network_header(skb);
+	memcpy(skb_network_header(skb), iter->tmp_hdr, hlen);
+
+	fh->nexthdr = nexthdr;
+	fh->reserved = 0;
+	fh->frag_off = htons(IP6_MF);
+	fh->identification = frag_id;
+
+	first_len = skb_pagelen(skb);
+	skb->data_len = first_len - skb_headlen(skb);
+	skb->len = first_len;
+	ipv6_hdr(skb)->payload_len = htons(first_len - sizeof(struct ipv6hdr));
+
+	return 0;
+}
+EXPORT_SYMBOL(ip6_fraglist_init);
+
+void ip6_fraglist_prepare(struct sk_buff *skb,
+			  struct ip6_fraglist_iter *iter)
+{
+	struct sk_buff *frag = iter->frag;
+	unsigned int hlen = iter->hlen;
+	struct frag_hdr *fh;
+
+	frag->ip_summed = CHECKSUM_NONE;
+	skb_reset_transport_header(frag);
+	fh = __skb_push(frag, sizeof(struct frag_hdr));
+	__skb_push(frag, hlen);
+	skb_reset_network_header(frag);
+	memcpy(skb_network_header(frag), iter->tmp_hdr, hlen);
+	iter->offset += skb->len - hlen - sizeof(struct frag_hdr);
+	fh->nexthdr = iter->nexthdr;
+	fh->reserved = 0;
+	fh->frag_off = htons(iter->offset);
+	if (frag->next)
+		fh->frag_off |= htons(IP6_MF);
+	fh->identification = iter->frag_id;
+	ipv6_hdr(frag)->payload_len = htons(frag->len - sizeof(struct ipv6hdr));
+	ip6_copy_metadata(frag, skb);
+}
+EXPORT_SYMBOL(ip6_fraglist_prepare);
+
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *))
 {
@@ -599,7 +666,6 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
-	struct ipv6hdr *tmp_hdr;
 	struct frag_hdr *fh;
 	unsigned int mtu, hlen, left, len, nexthdr_offset;
 	int hroom, troom;
@@ -651,6 +717,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	hroom = LL_RESERVED_SPACE(rt->dst.dev);
 	if (skb_has_frag_list(skb)) {
 		unsigned int first_len = skb_pagelen(skb);
+		struct ip6_fraglist_iter iter;
 		struct sk_buff *frag2;
 
 		if (first_len - hlen > mtu ||
@@ -678,74 +745,29 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			skb->truesize -= frag->truesize;
 		}
 
-		err = 0;
-		offset = 0;
-		/* BUILD HEADER */
-
-		*prevhdr = NEXTHDR_FRAGMENT;
-		tmp_hdr = kmemdup(skb_network_header(skb), hlen, GFP_ATOMIC);
-		if (!tmp_hdr) {
-			err = -ENOMEM;
+		err = ip6_fraglist_init(skb, hlen, prevhdr, nexthdr, frag_id,
+					&iter);
+		if (err < 0)
 			goto fail;
-		}
-		frag = skb_shinfo(skb)->frag_list;
-		skb_frag_list_init(skb);
-
-		__skb_pull(skb, hlen);
-		fh = __skb_push(skb, sizeof(struct frag_hdr));
-		__skb_push(skb, hlen);
-		skb_reset_network_header(skb);
-		memcpy(skb_network_header(skb), tmp_hdr, hlen);
-
-		fh->nexthdr = nexthdr;
-		fh->reserved = 0;
-		fh->frag_off = htons(IP6_MF);
-		fh->identification = frag_id;
-
-		first_len = skb_pagelen(skb);
-		skb->data_len = first_len - skb_headlen(skb);
-		skb->len = first_len;
-		ipv6_hdr(skb)->payload_len = htons(first_len -
-						   sizeof(struct ipv6hdr));
 
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
-			if (frag) {
-				frag->ip_summed = CHECKSUM_NONE;
-				skb_reset_transport_header(frag);
-				fh = __skb_push(frag, sizeof(struct frag_hdr));
-				__skb_push(frag, hlen);
-				skb_reset_network_header(frag);
-				memcpy(skb_network_header(frag), tmp_hdr,
-				       hlen);
-				offset += skb->len - hlen - sizeof(struct frag_hdr);
-				fh->nexthdr = nexthdr;
-				fh->reserved = 0;
-				fh->frag_off = htons(offset);
-				if (frag->next)
-					fh->frag_off |= htons(IP6_MF);
-				fh->identification = frag_id;
-				ipv6_hdr(frag)->payload_len =
-						htons(frag->len -
-						      sizeof(struct ipv6hdr));
-				ip6_copy_metadata(frag, skb);
-			}
+			if (iter.frag)
+				ip6_fraglist_prepare(skb, &iter);
 
 			err = output(net, sk, skb);
 			if (!err)
 				IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 					      IPSTATS_MIB_FRAGCREATES);
 
-			if (err || !frag)
+			if (err || !iter.frag)
 				break;
 
-			skb = frag;
-			frag = skb->next;
-			skb_mark_not_on_list(skb);
+			skb = ip6_fraglist_next(&iter);
 		}
 
-		kfree(tmp_hdr);
+		kfree(iter.tmp_hdr);
 
 		if (err == 0) {
 			IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
@@ -753,7 +775,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			return 0;
 		}
 
-		kfree_skb_list(frag);
+		kfree_skb_list(iter.frag_list);
 
 		IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 			      IPSTATS_MIB_FRAGFAILS);
-- 
2.11.0

