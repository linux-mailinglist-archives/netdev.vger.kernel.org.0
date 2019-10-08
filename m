Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7DACF832
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfJHLbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:00 -0400
Received: from aer-iport-3.cisco.com ([173.38.203.53]:5453 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbfJHLbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=9234; q=dns/txt; s=iport;
  t=1570534260; x=1571743860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=k7wadwa+HMzl73kZna6g1BhX9xmZIC5QmkMh4hJw8ko=;
  b=dgVXUS05iMu29lt7E1oXbCpFL2WXF+C9FxmcIZ4XN74tt7KfkRM1bq+G
   7gQu7zaivMCbgi1DWKkqZioNSx0na1JX2LVCXGW5dE3925Px4sNRV8I29
   6lx9mZc5uhYw2xJ7zYL8TOzq1eIayr0ZkOyzG9H0mecJEAD9dBnIHxMtw
   4=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17686705"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:52 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe4x031991;
        Tue, 8 Oct 2019 11:23:51 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        Joe Stringer <joestringer@nicira.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 stable 01/10] netfilter: ipv6: nf_defrag: avoid/free clone operations
Date:   Tue,  8 Oct 2019 13:23:00 +0200
Message-Id: <20191008112309.9571-2-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 029f7f3b8701 ("netfilter: ipv6: nf_defrag: avoid/free clone
operations")
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Nov 18 23:32:39 2015 +0100

commit 6aafeef03b9d9ecf
("netfilter: push reasm skb through instead of original frag skbs")
changed ipv6 defrag to not use the original skbs anymore.

So rather than keeping the original skbs around just to discard them
afterwards just use the original skbs directly for the fraglist of
the newly assembled skb and remove the extra clone/free operations.

The skb that completes the fragment queue is morphed into a the
reassembled one instead, just like ipv4 defrag.

openvswitch doesn't need any additional skb_morph magic anymore to deal
with this situation so just remove that.

A followup patch can then also remove the NF_HOOK (re)invocation in
the ipv6 netfilter defrag hook.

Cc: Joe Stringer <joestringer@nicira.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |   1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c     | 106 +++++++++++-----------------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |   6 --
 net/openvswitch/conntrack.c                 |  14 ----
 4 files changed, 40 insertions(+), 87 deletions(-)

diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index fb7da5b..fcd20cf 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -6,7 +6,6 @@ void nf_defrag_ipv6_enable(void);
 int nf_ct_frag6_init(void);
 void nf_ct_frag6_cleanup(void);
 struct sk_buff *nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
-void nf_ct_frag6_consume_orig(struct sk_buff *skb);
 
 struct inet_frags_ctl;
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 664c84e..58dd6f6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -56,7 +56,6 @@ struct nf_ct_frag6_skb_cb
 {
 	struct inet6_skb_parm	h;
 	int			offset;
-	struct sk_buff		*orig;
 };
 
 #define NFCT_FRAG6_CB(skb)	((struct nf_ct_frag6_skb_cb *)((skb)->cb))
@@ -151,12 +150,6 @@ static inline u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
 	return 1 << (ipv6_get_dsfield(ipv6h) & INET_ECN_MASK);
 }
 
-static void nf_skb_free(struct sk_buff *skb)
-{
-	if (NFCT_FRAG6_CB(skb)->orig)
-		kfree_skb(NFCT_FRAG6_CB(skb)->orig);
-}
-
 static void nf_ct_frag6_expire(unsigned long data)
 {
 	struct frag_queue *fq;
@@ -350,9 +343,9 @@ err:
  *	the last and the first frames arrived and all the bits are here.
  */
 static struct sk_buff *
-nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
+nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *prev,  struct net_device *dev)
 {
-	struct sk_buff *fp, *op, *head = fq->q.fragments;
+	struct sk_buff *fp, *head = fq->q.fragments;
 	int    payload_len;
 	u8 ecn;
 
@@ -403,10 +396,38 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
 		clone->csum = 0;
 		clone->ip_summed = head->ip_summed;
 
-		NFCT_FRAG6_CB(clone)->orig = NULL;
 		add_frag_mem_limit(fq->q.net, clone->truesize);
 	}
 
+	/* morph head into last received skb: prev.
+	 *
+	 * This allows callers of ipv6 conntrack defrag to continue
+	 * to use the last skb(frag) passed into the reasm engine.
+	 * The last skb frag 'silently' turns into the full reassembled skb.
+	 *
+	 * Since prev is also part of q->fragments we have to clone it first.
+	 */
+	if (head != prev) {
+		struct sk_buff *iter;
+
+		fp = skb_clone(prev, GFP_ATOMIC);
+		if (!fp)
+			goto out_oom;
+
+		fp->next = prev->next;
+		skb_queue_walk(head, iter) {
+			if (iter->next != prev)
+				continue;
+			iter->next = fp;
+			break;
+		}
+
+		skb_morph(prev, head);
+		prev->next = head->next;
+		consume_skb(head);
+		head = prev;
+	}
+
 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
 	skb_network_header(head)[fq->nhoffset] = skb_transport_header(head)[0];
@@ -449,21 +470,6 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
 	fq->q.rb_fragments = RB_ROOT;
 	fq->q.fragments_tail = NULL;
 
-	/* all original skbs are linked into the NFCT_FRAG6_CB(head).orig */
-	fp = skb_shinfo(head)->frag_list;
-	if (fp && NFCT_FRAG6_CB(fp)->orig == NULL)
-		/* at above code, head skb is divided into two skbs. */
-		fp = fp->next;
-
-	op = NFCT_FRAG6_CB(head)->orig;
-	for (; fp; fp = fp->next) {
-		struct sk_buff *orig = NFCT_FRAG6_CB(fp)->orig;
-
-		op->next = orig;
-		op = orig;
-		NFCT_FRAG6_CB(fp)->orig = NULL;
-	}
-
 	return head;
 
 out_oversize:
@@ -541,7 +547,6 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 
 struct sk_buff *nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct sk_buff *clone;
 	struct net_device *dev = skb->dev;
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
@@ -559,22 +564,12 @@ struct sk_buff *nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 use
 	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
 		return skb;
 
-	clone = skb_clone(skb, GFP_ATOMIC);
-	if (clone == NULL) {
-		pr_debug("Can't clone skb\n");
+	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
 		return skb;
-	}
 
-	NFCT_FRAG6_CB(clone)->orig = skb;
-
-	if (!pskb_may_pull(clone, fhoff + sizeof(*fhdr))) {
-		pr_debug("message is too short.\n");
-		goto ret_orig;
-	}
-
-	skb_set_transport_header(clone, fhoff);
-	hdr = ipv6_hdr(clone);
-	fhdr = (struct frag_hdr *)skb_transport_header(clone);
+	skb_set_transport_header(skb, fhoff);
+	hdr = ipv6_hdr(skb);
+	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
 	if (clone->len - skb_network_offset(clone) < IPV6_MIN_MTU &&
 	    fhdr->frag_off & htons(IP6_MF))
@@ -583,23 +578,20 @@ struct sk_buff *nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 use
 	skb_orphan(skb);
 	fq = fq_find(net, fhdr->identification, user, hdr,
 		     skb->dev ? skb->dev->ifindex : 0);
-	if (fq == NULL) {
-		pr_debug("Can't find and can't create new queue\n");
-		goto ret_orig;
-	}
-
+	if (fq == NULL)
+		return skb;
 	spin_lock_bh(&fq->q.lock);
 
-	if (nf_ct_frag6_queue(fq, clone, fhdr, nhoff) < 0) {
+	if (nf_ct_frag6_queue(fq, skb, fhdr, nhoff) < 0) {
 		spin_unlock_bh(&fq->q.lock);
 		pr_debug("Can't insert skb to queue\n");
 		inet_frag_put(&fq->q);
-		goto ret_orig;
+		return skb;
 	}
 
 	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
 	    fq->q.meat == fq->q.len) {
-		ret_skb = nf_ct_frag6_reasm(fq, dev);
+		ret_skb = nf_ct_frag6_reasm(fq, skb, dev);
 		if (ret_skb == NULL)
 			pr_debug("Can't reassemble fragmented packets\n");
 	}
@@ -607,26 +599,9 @@ struct sk_buff *nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 use
 
 	inet_frag_put(&fq->q);
 	return ret_skb;
-
-ret_orig:
-	kfree_skb(clone);
-	return skb;
 }
 EXPORT_SYMBOL_GPL(nf_ct_frag6_gather);
 
-void nf_ct_frag6_consume_orig(struct sk_buff *skb)
-{
-	struct sk_buff *s, *s2;
-
-	for (s = NFCT_FRAG6_CB(skb)->orig; s;) {
-		s2 = s->next;
-		s->next = NULL;
-		consume_skb(s);
-		s = s2;
-	}
-}
-EXPORT_SYMBOL_GPL(nf_ct_frag6_consume_orig);
-
 static int nf_ct_net_init(struct net *net)
 {
 	int res;
@@ -662,7 +637,6 @@ int nf_ct_frag6_init(void)
 
 	nf_frags.constructor = ip6_frag_init;
 	nf_frags.destructor = NULL;
-	nf_frags.skb_free = nf_skb_free;
 	nf_frags.qsize = sizeof(struct frag_queue);
 	nf_frags.frag_expire = nf_ct_frag6_expire;
 	nf_frags.frags_cache_name = nf_frags_cache_name;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 4fdbed5e..fb96b10 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -69,12 +69,6 @@ static unsigned int ipv6_defrag(void *priv,
 	if (reasm == NULL)
 		return NF_STOLEN;
 
-	/* error occurred or not fragmented */
-	if (reasm == skb)
-		return NF_ACCEPT;
-
-	nf_ct_frag6_consume_orig(reasm);
-
 	NF_HOOK_THRESH(NFPROTO_IPV6, state->hook, state->net, state->sk, reasm,
 		       state->in, state->out,
 		       state->okfn, NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 1829adb..6f5cbb7 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -326,21 +326,7 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 		if (!reasm)
 			return -EINPROGRESS;
 
-		if (skb == reasm) {
-			kfree_skb(skb);
-			return -EINVAL;
-		}
-
-		/* Don't free 'skb' even though it is one of the original
-		 * fragments, as we're going to morph it into the head.
-		 */
-		skb_get(skb);
-		nf_ct_frag6_consume_orig(reasm);
-
 		key->ip.proto = ipv6_hdr(reasm)->nexthdr;
-		skb_morph(skb, reasm);
-		skb->next = reasm->next;
-		consume_skb(reasm);
 		ovs_cb.mru = IP6CB(skb)->frag_max_size;
 #endif
 	} else {
-- 
2.10.2

