Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C3F214D25
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgGEOdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:33:39 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54037 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgGEOdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:33:39 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4D10541169;
        Sun,  5 Jul 2020 22:28:35 +0800 (CST)
From:   wenxu@ucloud.cn
To:     davem@davemloft.net, pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add nf_ct_frag_gather support
Date:   Sun,  5 Jul 2020 22:28:30 +0800
Message-Id: <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01DQkJCQk5DS0hDSEhZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw5FTFQAi9PDD0dATYjNzocVlZVQk5CQyhJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kwg6Phw5Qz5RLE1KLz81LTUD
        KwEKFAhVSlVKTkJIQk5CSEpOT0lIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJMQ0s3Bg++
X-HM-Tid: 0a731f60f7822086kuqy4d10541169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_ct_frag_gather for conntrack defrag and it will
elide the CB clear when packets are defragmented by
connection tracking

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/ipv4/nf_defrag_ipv4.h |   2 +
 net/ipv4/netfilter/nf_defrag_ipv4.c         | 314 ++++++++++++++++++++++++++++
 2 files changed, 316 insertions(+)

diff --git a/include/net/netfilter/ipv4/nf_defrag_ipv4.h b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
index bcbd724..b3ac92b 100644
--- a/include/net/netfilter/ipv4/nf_defrag_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
@@ -4,5 +4,7 @@
 
 struct net;
 int nf_defrag_ipv4_enable(struct net *);
+int nf_ct_frag_gather(struct net *net, struct sk_buff *skb,
+		      u32 user, u16 *frag_max_size);
 
 #endif /* _NF_DEFRAG_IPV4_H */
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 8115611..a4ac207 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -11,6 +11,7 @@
 #include <net/netns/generic.h>
 #include <net/route.h>
 #include <net/ip.h>
+#include <net/inet_frag.h>
 
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
@@ -22,6 +23,319 @@
 
 static DEFINE_MUTEX(defrag4_mutex);
 
+/* Describe an entry in the "incomplete datagrams" queue. */
+struct ipq {
+	struct inet_frag_queue q;
+
+	u8		ecn; /* RFC3168 support */
+	u16		max_df_size; /* largest frag with DF set seen */
+	int             iif;
+	unsigned int    rid;
+	struct inet_peer *peer;
+};
+
+static void ipq_kill(struct ipq *ipq)
+{
+	inet_frag_kill(&ipq->q);
+}
+
+static void ipq_put(struct ipq *ipq)
+{
+	inet_frag_put(&ipq->q);
+}
+
+static bool nf_ct_frag_coalesce_ok(const struct ipq *qp)
+{
+	return qp->q.key.v4.user == IP_DEFRAG_LOCAL_DELIVER;
+}
+
+static u8 nf_ct_frag_ecn(u8 tos)
+{
+	return 1 << (tos & INET_ECN_MASK);
+}
+
+static int nf_ct_frag_too_far(struct ipq *qp)
+{
+	struct inet_peer *peer = qp->peer;
+	unsigned int max = qp->q.fqdir->max_dist;
+	unsigned int start, end;
+
+	int rc;
+
+	if (!peer || !max)
+		return 0;
+
+	start = qp->rid;
+	end = atomic_inc_return(&peer->rid);
+	qp->rid = end;
+
+	rc = qp->q.fragments_tail && (end - start) > max;
+
+	return rc;
+}
+
+static int nf_ct_frag_reinit(struct ipq *qp)
+{
+	unsigned int sum_truesize = 0;
+
+	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
+		refcount_inc(&qp->q.refcnt);
+		return -ETIMEDOUT;
+	}
+
+	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
+	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
+
+	qp->q.flags = 0;
+	qp->q.len = 0;
+	qp->q.meat = 0;
+	qp->q.rb_fragments = RB_ROOT;
+	qp->q.fragments_tail = NULL;
+	qp->q.last_run_head = NULL;
+	qp->iif = 0;
+	qp->ecn = 0;
+
+	return 0;
+}
+
+static struct ipq *ip_find(struct net *net, struct iphdr *iph,
+			   u32 user, int vif)
+{
+	struct frag_v4_compare_key key = {
+		.saddr = iph->saddr,
+		.daddr = iph->daddr,
+		.user = user,
+		.vif = vif,
+		.id = iph->id,
+		.protocol = iph->protocol,
+	};
+	struct inet_frag_queue *q;
+
+	q = inet_frag_find(net->ipv4.fqdir, &key);
+	if (!q)
+		return NULL;
+
+	return container_of(q, struct ipq, q);
+}
+
+static int nf_ct_frag_reasm(struct ipq *qp, struct sk_buff *skb,
+			    struct sk_buff *prev_tail, struct net_device *dev,
+			    u16 *frag_max_size)
+{
+	struct iphdr *iph;
+	void *reasm_data;
+	int len, err;
+	u8 ecn;
+
+	ipq_kill(qp);
+
+	ecn = ip_frag_ecn_table[qp->ecn];
+	if (unlikely(ecn == 0xff)) {
+		err = -EINVAL;
+		goto out_fail;
+	}
+
+	/* Make the one we just received the head. */
+	reasm_data = inet_frag_reasm_prepare(&qp->q, skb, prev_tail);
+	if (!reasm_data)
+		goto out_nomem;
+
+	len = ip_hdrlen(skb) + qp->q.len;
+	err = -E2BIG;
+	if (len > 65535)
+		goto out_oversize;
+
+	inet_frag_reasm_finish(&qp->q, skb, reasm_data,
+			       nf_ct_frag_coalesce_ok(qp));
+
+	skb->dev = dev;
+	if (frag_max_size)
+		*frag_max_size = max(qp->max_df_size, qp->q.max_size);
+
+	iph = ip_hdr(skb);
+	iph->tot_len = htons(len);
+	iph->tos |= ecn;
+
+	/* When we set IP_DF on a refragmented skb we must also force a
+	 * call to ip_fragment to avoid forwarding a DF-skb of size s while
+	 * original sender only sent fragments of size f (where f < s).
+	 *
+	 * We only set DF/IPSKB_FRAG_PMTU if such DF fragment was the largest
+	 * frag seen to avoid sending tiny DF-fragments in case skb was built
+	 * from one very small df-fragment and one large non-df frag.
+	 */
+	if (qp->max_df_size == qp->q.max_size)
+		iph->frag_off = htons(IP_DF);
+	else
+		iph->frag_off = 0;
+
+	ip_send_check(iph);
+
+	qp->q.rb_fragments = RB_ROOT;
+	qp->q.fragments_tail = NULL;
+	qp->q.last_run_head = NULL;
+	return 0;
+
+out_nomem:
+	net_dbg_ratelimited("queue_glue: no memory for gluing queue %p\n", qp);
+	err = -ENOMEM;
+	goto out_fail;
+out_oversize:
+	net_info_ratelimited("Oversized IP packet from %pI4\n", &qp->q.key.v4.saddr);
+out_fail:
+	return err;
+}
+
+static int nf_ct_frag_queue(struct ipq *qp, struct sk_buff *skb, u16 *frag_max_size)
+{
+	int ihl, end, flags, offset;
+	struct sk_buff *prev_tail;
+	struct net_device *dev;
+	unsigned int fragsize;
+	int err = -ENOENT;
+	u8 ecn;
+
+	if (qp->q.flags & INET_FRAG_COMPLETE)
+		goto err;
+
+	if (unlikely(nf_ct_frag_too_far(qp))) {
+		err = nf_ct_frag_reinit(qp);
+		if (unlikely(err)) {
+			ipq_kill(qp);
+			goto err;
+		}
+	}
+
+	ecn = nf_ct_frag_ecn(ip_hdr(skb)->tos);
+	offset = ntohs(ip_hdr(skb)->frag_off);
+	flags = offset & ~IP_OFFSET;
+	offset &= IP_OFFSET;
+	offset <<= 3;		/* offset is in 8-byte chunks */
+	ihl = ip_hdrlen(skb);
+
+	/* Determine the position of this fragment. */
+	end = offset + skb->len - skb_network_offset(skb) - ihl;
+	err = -EINVAL;
+
+	/* Is this the final fragment? */
+	if ((flags & IP_MF) == 0) {
+		/* If we already have some bits beyond end
+		 * or have different end, the segment is corrupted.
+		 */
+		if (end < qp->q.len ||
+		    ((qp->q.flags & INET_FRAG_LAST_IN) && end != qp->q.len))
+			goto discard_qp;
+		qp->q.flags |= INET_FRAG_LAST_IN;
+		qp->q.len = end;
+	} else {
+		if (end & 7) {
+			end &= ~7;
+			if (skb->ip_summed != CHECKSUM_UNNECESSARY)
+				skb->ip_summed = CHECKSUM_NONE;
+		}
+		if (end > qp->q.len) {
+			/* Some bits beyond end -> corruption. */
+			if (qp->q.flags & INET_FRAG_LAST_IN)
+				goto discard_qp;
+			qp->q.len = end;
+		}
+	}
+	if (end == offset)
+		goto discard_qp;
+
+	err = -ENOMEM;
+	if (!pskb_pull(skb, skb_network_offset(skb) + ihl))
+		goto discard_qp;
+
+	err = pskb_trim_rcsum(skb, end - offset);
+	if (err)
+		goto discard_qp;
+
+	/* Note : skb->rbnode and skb->dev share the same location. */
+	dev = skb->dev;
+	/* Makes sure compiler wont do silly aliasing games */
+	barrier();
+
+	prev_tail = qp->q.fragments_tail;
+	err = inet_frag_queue_insert(&qp->q, skb, offset, end);
+	if (err)
+		goto insert_error;
+
+	if (dev)
+		qp->iif = dev->ifindex;
+
+	qp->q.stamp = skb->tstamp;
+	qp->q.meat += skb->len;
+	qp->ecn |= ecn;
+	add_frag_mem_limit(qp->q.fqdir, skb->truesize);
+	if (offset == 0)
+		qp->q.flags |= INET_FRAG_FIRST_IN;
+
+	fragsize = skb->len + ihl;
+
+	if (fragsize > qp->q.max_size)
+		qp->q.max_size = fragsize;
+
+	if (ip_hdr(skb)->frag_off & htons(IP_DF) &&
+	    fragsize > qp->max_df_size)
+		qp->max_df_size = fragsize;
+
+	if (qp->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
+	    qp->q.meat == qp->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		err = nf_ct_frag_reasm(qp, skb, prev_tail, dev, frag_max_size);
+		skb->_skb_refdst = orefdst;
+		if (err)
+			inet_frag_kill(&qp->q);
+		return err;
+	}
+
+	skb_dst_drop(skb);
+	return -EINPROGRESS;
+
+insert_error:
+	if (err == IPFRAG_DUP) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+	err = -EINVAL;
+discard_qp:
+	inet_frag_kill(&qp->q);
+err:
+	kfree_skb(skb);
+	return err;
+}
+
+int nf_ct_frag_gather(struct net *net, struct sk_buff *skb,
+		      u32 user, u16 *frag_max_size)
+{
+	struct net_device *dev = skb->dev ? : skb_dst(skb)->dev;
+	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct ipq *qp;
+
+	skb_orphan(skb);
+
+	/* Lookup (or create) queue header */
+	qp = ip_find(net, ip_hdr(skb), user, vif);
+	if (qp) {
+		int ret;
+
+		spin_lock(&qp->q.lock);
+
+		ret = nf_ct_frag_queue(qp, skb, frag_max_size);
+
+		spin_unlock(&qp->q.lock);
+		ipq_put(qp);
+		return ret;
+	}
+
+	kfree_skb(skb);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(nf_ct_frag_gather);
+
 static int nf_ct_ipv4_gather_frags(struct net *net, struct sk_buff *skb,
 				   u_int32_t user)
 {
-- 
1.8.3.1

