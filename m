Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD02DBC2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfE2LZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:25:52 -0400
Received: from mail.us.es ([193.147.175.20]:52966 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbfE2LZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:25:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 914C0C1B72
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81FCFDA714
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6DBFADA70A; Wed, 29 May 2019 13:25:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 342EDDA709;
        Wed, 29 May 2019 13:25:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 13:25:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E35CF4265A5B;
        Wed, 29 May 2019 13:25:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH net-next,v3 1/9] net: ipv4: add skbuff fraglist splitter
Date:   Wed, 29 May 2019 13:25:31 +0200
Message-Id: <20190529112539.2126-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190529112539.2126-1-pablo@netfilter.org>
References: <20190529112539.2126-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the skbuff fraglist splitter. This API provides an
iterator to transform the fraglist into single skbuff objects, it
consists of:

* ip_fraglist_init(), that initializes the internal state of the
  fraglist splitter.
* ip_fraglist_prepare(), that restores the IPv4 header on the
  fragments.
* ip_fraglist_next(), that retrieves the fragment from the fraglist and
  it updates the internal state of the splitter to point to the next
  fragment skbuff in the fraglist.

The ip_fraglist_iter object stores the internal state of the iterator.

This code has been extracted from ip_do_fragment(). Symbols are also
exported to allow to reuse this iterator from the bridge codepath to
build its own refragmentation routine by reusing the existing codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip.h     | 23 ++++++++++++++
 net/ipv4/ip_output.c | 88 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 78 insertions(+), 33 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d3cce7c3e8a..be899677504b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -165,6 +165,29 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		   int (*output)(struct net *, struct sock *, struct sk_buff *));
+
+struct ip_fraglist_iter {
+	struct sk_buff	*frag_list;
+	struct sk_buff	*frag;
+	struct iphdr	*iph;
+	int		offset;
+	unsigned int	hlen;
+};
+
+void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
+		      unsigned int hlen, struct ip_fraglist_iter *iter);
+void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter);
+
+static inline struct sk_buff *ip_fraglist_next(struct ip_fraglist_iter *iter)
+{
+	struct sk_buff *skb = iter->frag;
+
+	iter->frag = skb->next;
+	skb_mark_not_on_list(skb);
+
+	return skb;
+}
+
 void ip_send_check(struct iphdr *ip);
 int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index bfd0ca554977..d03eb4ae0dd4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -561,6 +561,54 @@ static int ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	return ip_do_fragment(net, sk, skb, output);
 }
 
+void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
+		      unsigned int hlen, struct ip_fraglist_iter *iter)
+{
+	unsigned int first_len = skb_pagelen(skb);
+
+	iter->frag_list = skb_shinfo(skb)->frag_list;
+	iter->frag = iter->frag_list;
+	skb_frag_list_init(skb);
+
+	iter->offset = 0;
+	iter->iph = iph;
+	iter->hlen = hlen;
+
+	skb->data_len = first_len - skb_headlen(skb);
+	skb->len = first_len;
+	iph->tot_len = htons(first_len);
+	iph->frag_off = htons(IP_MF);
+	ip_send_check(iph);
+}
+EXPORT_SYMBOL(ip_fraglist_init);
+
+void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
+{
+	unsigned int hlen = iter->hlen;
+	struct iphdr *iph = iter->iph;
+	struct sk_buff *frag;
+
+	frag = iter->frag;
+	frag->ip_summed = CHECKSUM_NONE;
+	skb_reset_transport_header(frag);
+	__skb_push(frag, hlen);
+	skb_reset_network_header(frag);
+	memcpy(skb_network_header(frag), iph, hlen);
+	iter->iph = ip_hdr(frag);
+	iph = iter->iph;
+	iph->tot_len = htons(frag->len);
+	ip_copy_metadata(frag, skb);
+	if (iter->offset == 0)
+		ip_options_fragment(frag);
+	iter->offset += skb->len - hlen;
+	iph->frag_off = htons(iter->offset >> 3);
+	if (frag->next)
+		iph->frag_off |= htons(IP_MF);
+	/* Ready, complete checksum */
+	ip_send_check(iph);
+}
+EXPORT_SYMBOL(ip_fraglist_prepare);
+
 /*
  *	This IP datagram is too large to be sent in one piece.  Break it up into
  *	smaller pieces (each of size equal to IP header plus
@@ -578,6 +626,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	int offset;
 	__be16 not_last_frag;
 	struct rtable *rt = skb_rtable(skb);
+	struct ip_fraglist_iter iter;
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
@@ -642,49 +691,22 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		}
 
 		/* Everything is OK. Generate! */
-
-		err = 0;
-		offset = 0;
-		frag = skb_shinfo(skb)->frag_list;
-		skb_frag_list_init(skb);
-		skb->data_len = first_len - skb_headlen(skb);
-		skb->len = first_len;
-		iph->tot_len = htons(first_len);
-		iph->frag_off = htons(IP_MF);
-		ip_send_check(iph);
+		ip_fraglist_init(skb, iph, hlen, &iter);
 
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
-			if (frag) {
-				frag->ip_summed = CHECKSUM_NONE;
-				skb_reset_transport_header(frag);
-				__skb_push(frag, hlen);
-				skb_reset_network_header(frag);
-				memcpy(skb_network_header(frag), iph, hlen);
-				iph = ip_hdr(frag);
-				iph->tot_len = htons(frag->len);
-				ip_copy_metadata(frag, skb);
-				if (offset == 0)
-					ip_options_fragment(frag);
-				offset += skb->len - hlen;
-				iph->frag_off = htons(offset>>3);
-				if (frag->next)
-					iph->frag_off |= htons(IP_MF);
-				/* Ready, complete checksum */
-				ip_send_check(iph);
-			}
+			if (iter.frag)
+				ip_fraglist_prepare(skb, &iter);
 
 			err = output(net, sk, skb);
 
 			if (!err)
 				IP_INC_STATS(net, IPSTATS_MIB_FRAGCREATES);
-			if (err || !frag)
+			if (err || !iter.frag)
 				break;
 
-			skb = frag;
-			frag = skb->next;
-			skb_mark_not_on_list(skb);
+			skb = ip_fraglist_next(&iter);
 		}
 
 		if (err == 0) {
@@ -692,7 +714,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			return 0;
 		}
 
-		kfree_skb_list(frag);
+		kfree_skb_list(iter.frag_list);
 
 		IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
 		return err;
-- 
2.11.0

