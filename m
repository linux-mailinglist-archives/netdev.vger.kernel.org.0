Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A085737561C
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhEFPBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:01:41 -0400
Received: from m12-11.163.com ([220.181.12.11]:47165 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235008AbhEFPBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 11:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ClSwa
        n6SM+8zC9QsxPq4sN4EIGEeUwrSpnXtb/5CeI8=; b=psLRBtEOzR4fnVHFBiwnR
        Flm8HClg2wsB0isu8qp+16c3jOFam/rfRF+9FUaSNuJpx3R/3XbwBsxaixwzU3/p
        2UF6gFktDGj2nM5OJFuqV5ujt+juS/WiQyQYV47+8EtzyZ+DCplQx7SAwQi+B+Gx
        aszMTljbazC3wqtzKAjMFA=
Received: from mjs-Inspiron-3668.www.tendawifi.com (unknown [61.152.154.80])
        by smtp7 (Coremail) with SMTP id C8CowAAXZ688BJRgsn00bA--.15323S4;
        Thu, 06 May 2021 22:59:16 +0800 (CST)
From:   meijusan <meijusan@163.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        meijusan <meijusan@163.com>
Subject: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit set in iphdr
Date:   Thu,  6 May 2021 22:59:05 +0800
Message-Id: <20210506145905.3884-1-meijusan@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAAXZ688BJRgsn00bA--.15323S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFykXrW8ZFWDZrWkur4xtFb_yoW7Jr1fp3
        Z8K395Ja18JrnrAwn7JrWayw4Skw1vka4akr4Fy3yrA34qyryFqF92gFyYqF45Gr45Zr13
        try3t3y5Wr4DX37anT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jNMa5UUUUU=
X-Originating-IP: [61.152.154.80]
X-CM-SenderInfo: xphly3xvdqqiywtou0bp/1tbiFgWKHl44P6QkcwAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip frag with the iphdr flags reserved bit set,via router,ip frag reasm or
fragment,causing the reserved bit is reset to zero.

Keep reserved bit set is not modified in ip frag  defrag or fragment.

Signed-off-by: meijusan <meijusan@163.com>
---
 include/net/ip.h       |  3 ++-
 net/ipv4/ip_fragment.c |  9 +++++++++
 net/ipv4/ip_output.c   | 14 ++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index e20874059f82..ae0c75fca61d 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -134,7 +134,7 @@ struct ip_ra_chain {
 #define IP_DF		0x4000		/* Flag: "Don't Fragment"	*/
 #define IP_MF		0x2000		/* Flag: "More Fragments"	*/
 #define IP_OFFSET	0x1FFF		/* "Fragment Offset" part	*/
-
+#define IP_EVIL	0x8000		/* Flag: "reserve bit"	*/
 #define IP_FRAG_TIME	(30 * HZ)		/* fragment lifetime	*/
 
 struct msghdr;
@@ -194,6 +194,7 @@ struct ip_frag_state {
 	int		offset;
 	int		ptr;
 	__be16		not_last_frag;
+	bool		ip_evil;
 };
 
 void ip_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int ll_rs,
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cfeb8890f94e..52eb53007c48 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -62,6 +62,7 @@ struct ipq {
 	struct inet_frag_queue q;
 
 	u8		ecn; /* RFC3168 support */
+	bool		ip_evil; /*frag with evil bit set */
 	u16		max_df_size; /* largest frag with DF set seen */
 	int             iif;
 	unsigned int    rid;
@@ -88,6 +89,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 
 	q->key.v4 = *key;
 	qp->ecn = 0;
+	qp->ip_evil = false;
 	qp->peer = q->fqdir->max_dist ?
 		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1) :
 		NULL;
@@ -278,6 +280,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	unsigned int fragsize;
 	int err = -ENOENT;
 	u8 ecn;
+	bool  ip_evil;
 
 	if (qp->q.flags & INET_FRAG_COMPLETE)
 		goto err;
@@ -295,6 +298,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	offset &= IP_OFFSET;
 	offset <<= 3;		/* offset is in 8-byte chunks */
 	ihl = ip_hdrlen(skb);
+	ip_evil = flags & IP_EVIL ?  true : false;
 
 	/* Determine the position of this fragment. */
 	end = offset + skb->len - skb_network_offset(skb) - ihl;
@@ -350,6 +354,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	qp->q.stamp = skb->tstamp;
 	qp->q.meat += skb->len;
 	qp->ecn |= ecn;
+	qp->ip_evil = ip_evil;
 	add_frag_mem_limit(qp->q.fqdir, skb->truesize);
 	if (offset == 0)
 		qp->q.flags |= INET_FRAG_FIRST_IN;
@@ -451,6 +456,10 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 		iph->frag_off = 0;
 	}
 
+	/*when ip or bridge forward, keep the origin evil bit set*/
+	if (qp->ip_evil)
+		iph->frag_off |= htons(IP_EVIL);
+
 	ip_send_check(iph);
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMOKS);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3aab53beb4ea..a8a9a0af29b2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -610,6 +610,8 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
 	skb->len = first_len;
 	iph->tot_len = htons(first_len);
 	iph->frag_off = htons(IP_MF);
+	if (ntohs(iph->frag_off) & IP_EVIL)
+		iph->frag_off |= htons(IP_EVIL);
 	ip_send_check(iph);
 }
 EXPORT_SYMBOL(ip_fraglist_init);
@@ -631,6 +633,7 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 	unsigned int hlen = iter->hlen;
 	struct iphdr *iph = iter->iph;
 	struct sk_buff *frag;
+	bool ip_evil = false;
 
 	frag = iter->frag;
 	frag->ip_summed = CHECKSUM_NONE;
@@ -638,6 +641,8 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 	__skb_push(frag, hlen);
 	skb_reset_network_header(frag);
 	memcpy(skb_network_header(frag), iph, hlen);
+	if (ntohs(iph->frag_off) & IP_EVIL)
+		ip_evil = true;
 	iter->iph = ip_hdr(frag);
 	iph = iter->iph;
 	iph->tot_len = htons(frag->len);
@@ -646,6 +651,10 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 	iph->frag_off = htons(iter->offset >> 3);
 	if (frag->next)
 		iph->frag_off |= htons(IP_MF);
+
+	if (ip_evil)
+		iph->frag_off |= htons(IP_EVIL);
+
 	/* Ready, complete checksum */
 	ip_send_check(iph);
 }
@@ -667,6 +676,7 @@ void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
 
 	state->offset = (ntohs(iph->frag_off) & IP_OFFSET) << 3;
 	state->not_last_frag = iph->frag_off & htons(IP_MF);
+	state->ip_evil = (ntohs(iph->frag_off) & IP_EVIL) ? true : false;
 }
 EXPORT_SYMBOL(ip_frag_init);
 
@@ -752,6 +762,10 @@ struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
 	 */
 	if (state->left > 0 || state->not_last_frag)
 		iph->frag_off |= htons(IP_MF);
+
+	if (state->ip_evil)
+		iph->frag_off |= htons(IP_EVIL);
+
 	state->ptr += len;
 	state->offset += len;
 
-- 
2.25.1

