Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABEF2DA86
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfE2K0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:26:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40608 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfE2KZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:25:47 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVvmC-0003ix-TF; Wed, 29 May 2019 10:25:45 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] net: IP defrag: encapsulate rbtree defrag code into callable functions
Date:   Wed, 29 May 2019 12:25:41 +0200
Message-Id: <20190529102542.17742-4-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529102542.17742-1-stefan.bader@canonical.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Oskolkov <posk@google.com>

This is a refactoring patch: without changing runtime behavior,
it moves rbtree-related code from IPv4-specific files/functions
into .h/.c defrag files shared with IPv6 defragmentation code.

Signed-off-by: Peter Oskolkov <posk@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(backported from commit c23f35d19db3b36ffb9e04b08f1d91565d15f84f)
[smb: open code skb_mark_not_on_list(), context adjustments, use of
      IP_INC_STATS_BH instead of __IP_INC_STATS]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 include/net/inet_frag.h  |  16 ++-
 net/ipv4/inet_fragment.c | 293 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/ip_fragment.c   | 288 ++++----------------------------------
 3 files changed, 332 insertions(+), 265 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 6260ec146142..7c8b06302ade 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -75,8 +75,8 @@ struct inet_frag_queue {
 	struct timer_list	timer;
 	spinlock_t		lock;
 	atomic_t		refcnt;
-	struct sk_buff		*fragments;  /* Used in IPv6. */
-	struct rb_root		rb_fragments; /* Used in IPv4. */
+	struct sk_buff		*fragments;  /* used in 6lopwpan IPv6. */
+	struct rb_root		rb_fragments; /* Used in IPv4/IPv6. */
 	struct sk_buff		*fragments_tail;
 	struct sk_buff		*last_run_head;
 	ktime_t			stamp;
@@ -152,4 +152,16 @@ static inline void add_frag_mem_limit(struct netns_frags *nf, long val)
 
 extern const u8 ip_frag_ecn_table[16];
 
+/* Return values of inet_frag_queue_insert() */
+#define IPFRAG_OK	0
+#define IPFRAG_DUP	1
+#define IPFRAG_OVERLAP	2
+int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
+			   int offset, int end);
+void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
+			      struct sk_buff *parent);
+void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
+			    void *reasm_data);
+struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q);
+
 #endif
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index c03e5f5859e1..5c167efd54bd 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -24,6 +24,62 @@
 #include <net/sock.h>
 #include <net/inet_frag.h>
 #include <net/inet_ecn.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+/* Use skb->cb to track consecutive/adjacent fragments coming at
+ * the end of the queue. Nodes in the rb-tree queue will
+ * contain "runs" of one or more adjacent fragments.
+ *
+ * Invariants:
+ * - next_frag is NULL at the tail of a "run";
+ * - the head of a "run" has the sum of all fragment lengths in frag_run_len.
+ */
+struct ipfrag_skb_cb {
+	union {
+		struct inet_skb_parm	h4;
+		struct inet6_skb_parm	h6;
+	};
+	struct sk_buff		*next_frag;
+	int			frag_run_len;
+};
+
+#define FRAG_CB(skb)		((struct ipfrag_skb_cb *)((skb)->cb))
+
+static void fragcb_clear(struct sk_buff *skb)
+{
+	RB_CLEAR_NODE(&skb->rbnode);
+	FRAG_CB(skb)->next_frag = NULL;
+	FRAG_CB(skb)->frag_run_len = skb->len;
+}
+
+/* Append skb to the last "run". */
+static void fragrun_append_to_last(struct inet_frag_queue *q,
+				   struct sk_buff *skb)
+{
+	fragcb_clear(skb);
+
+	FRAG_CB(q->last_run_head)->frag_run_len += skb->len;
+	FRAG_CB(q->fragments_tail)->next_frag = skb;
+	q->fragments_tail = skb;
+}
+
+/* Create a new "run" with the skb. */
+static void fragrun_create(struct inet_frag_queue *q, struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct ipfrag_skb_cb) > sizeof(skb->cb));
+	fragcb_clear(skb);
+
+	if (q->last_run_head)
+		rb_link_node(&skb->rbnode, &q->last_run_head->rbnode,
+			     &q->last_run_head->rbnode.rb_right);
+	else
+		rb_link_node(&skb->rbnode, NULL, &q->rb_fragments.rb_node);
+	rb_insert_color(&skb->rbnode, &q->rb_fragments);
+
+	q->fragments_tail = skb;
+	q->last_run_head = skb;
+}
 
 /* Given the OR values of all fragments, apply RFC 3168 5.3 requirements
  * Value : 0xff if frame should be dropped.
@@ -130,6 +186,28 @@ static void inet_frag_destroy_rcu(struct rcu_head *head)
 	kmem_cache_free(f->frags_cachep, q);
 }
 
+unsigned int inet_frag_rbtree_purge(struct rb_root *root)
+{
+	struct rb_node *p = rb_first(root);
+	unsigned int sum = 0;
+
+	while (p) {
+		struct sk_buff *skb = rb_entry(p, struct sk_buff, rbnode);
+
+		p = rb_next(p);
+		rb_erase(&skb->rbnode, root);
+		while (skb) {
+			struct sk_buff *next = FRAG_CB(skb)->next_frag;
+
+			sum += skb->truesize;
+			kfree_skb(skb);
+			skb = next;
+		}
+	}
+	return sum;
+}
+EXPORT_SYMBOL(inet_frag_rbtree_purge);
+
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
 	struct sk_buff *fp;
@@ -231,3 +309,218 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf, void *key)
 	return fq;
 }
 EXPORT_SYMBOL(inet_frag_find);
+
+int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
+			   int offset, int end)
+{
+	struct sk_buff *last = q->fragments_tail;
+
+	/* RFC5722, Section 4, amended by Errata ID : 3089
+	 *                          When reassembling an IPv6 datagram, if
+	 *   one or more its constituent fragments is determined to be an
+	 *   overlapping fragment, the entire datagram (and any constituent
+	 *   fragments) MUST be silently discarded.
+	 *
+	 * Duplicates, however, should be ignored (i.e. skb dropped, but the
+	 * queue/fragments kept for later reassembly).
+	 */
+	if (!last)
+		fragrun_create(q, skb);  /* First fragment. */
+	else if (last->ip_defrag_offset + last->len < end) {
+		/* This is the common case: skb goes to the end. */
+		/* Detect and discard overlaps. */
+		if (offset < last->ip_defrag_offset + last->len)
+			return IPFRAG_OVERLAP;
+		if (offset == last->ip_defrag_offset + last->len)
+			fragrun_append_to_last(q, skb);
+		else
+			fragrun_create(q, skb);
+	} else {
+		/* Binary search. Note that skb can become the first fragment,
+		 * but not the last (covered above).
+		 */
+		struct rb_node **rbn, *parent;
+
+		rbn = &q->rb_fragments.rb_node;
+		do {
+			struct sk_buff *curr;
+			int curr_run_end;
+
+			parent = *rbn;
+			curr = rb_to_skb(parent);
+			curr_run_end = curr->ip_defrag_offset +
+					FRAG_CB(curr)->frag_run_len;
+			if (end <= curr->ip_defrag_offset)
+				rbn = &parent->rb_left;
+			else if (offset >= curr_run_end)
+				rbn = &parent->rb_right;
+			else if (offset >= curr->ip_defrag_offset &&
+				 end <= curr_run_end)
+				return IPFRAG_DUP;
+			else
+				return IPFRAG_OVERLAP;
+		} while (*rbn);
+		/* Here we have parent properly set, and rbn pointing to
+		 * one of its NULL left/right children. Insert skb.
+		 */
+		fragcb_clear(skb);
+		rb_link_node(&skb->rbnode, parent, rbn);
+		rb_insert_color(&skb->rbnode, &q->rb_fragments);
+	}
+
+	skb->ip_defrag_offset = offset;
+
+	return IPFRAG_OK;
+}
+EXPORT_SYMBOL(inet_frag_queue_insert);
+
+void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
+			      struct sk_buff *parent)
+{
+	struct sk_buff *fp, *head = skb_rb_first(&q->rb_fragments);
+	struct sk_buff **nextp;
+	int delta;
+
+	if (head != skb) {
+		fp = skb_clone(skb, GFP_ATOMIC);
+		if (!fp)
+			return NULL;
+		FRAG_CB(fp)->next_frag = FRAG_CB(skb)->next_frag;
+		if (RB_EMPTY_NODE(&skb->rbnode))
+			FRAG_CB(parent)->next_frag = fp;
+		else
+			rb_replace_node(&skb->rbnode, &fp->rbnode,
+					&q->rb_fragments);
+		if (q->fragments_tail == skb)
+			q->fragments_tail = fp;
+		skb_morph(skb, head);
+		FRAG_CB(skb)->next_frag = FRAG_CB(head)->next_frag;
+		rb_replace_node(&head->rbnode, &skb->rbnode,
+				&q->rb_fragments);
+		consume_skb(head);
+		head = skb;
+	}
+	WARN_ON(head->ip_defrag_offset != 0);
+
+	delta = -head->truesize;
+
+	/* Head of list must not be cloned. */
+	if (skb_unclone(head, GFP_ATOMIC))
+		return NULL;
+
+	delta += head->truesize;
+	if (delta)
+		add_frag_mem_limit(q->net, delta);
+
+	/* If the first fragment is fragmented itself, we split
+	 * it to two chunks: the first with data and paged part
+	 * and the second, holding only fragments.
+	 */
+	if (skb_has_frag_list(head)) {
+		struct sk_buff *clone;
+		int i, plen = 0;
+
+		clone = alloc_skb(0, GFP_ATOMIC);
+		if (!clone)
+			return NULL;
+		skb_shinfo(clone)->frag_list = skb_shinfo(head)->frag_list;
+		skb_frag_list_init(head);
+		for (i = 0; i < skb_shinfo(head)->nr_frags; i++)
+			plen += skb_frag_size(&skb_shinfo(head)->frags[i]);
+		clone->data_len = head->data_len - plen;
+		clone->len = clone->data_len;
+		head->truesize += clone->truesize;
+		clone->csum = 0;
+		clone->ip_summed = head->ip_summed;
+		add_frag_mem_limit(q->net, clone->truesize);
+		skb_shinfo(head)->frag_list = clone;
+		nextp = &clone->next;
+	} else {
+		nextp = &skb_shinfo(head)->frag_list;
+	}
+
+	return nextp;
+}
+EXPORT_SYMBOL(inet_frag_reasm_prepare);
+
+void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
+			    void *reasm_data)
+{
+	struct sk_buff **nextp = (struct sk_buff **)reasm_data;
+	struct rb_node *rbn;
+	struct sk_buff *fp;
+
+	skb_push(head, head->data - skb_network_header(head));
+
+	/* Traverse the tree in order, to build frag_list. */
+	fp = FRAG_CB(head)->next_frag;
+	rbn = rb_next(&head->rbnode);
+	rb_erase(&head->rbnode, &q->rb_fragments);
+	while (rbn || fp) {
+		/* fp points to the next sk_buff in the current run;
+		 * rbn points to the next run.
+		 */
+		/* Go through the current run. */
+		while (fp) {
+			*nextp = fp;
+			nextp = &fp->next;
+			fp->prev = NULL;
+			memset(&fp->rbnode, 0, sizeof(fp->rbnode));
+			fp->sk = NULL;
+			head->data_len += fp->len;
+			head->len += fp->len;
+			if (head->ip_summed != fp->ip_summed)
+				head->ip_summed = CHECKSUM_NONE;
+			else if (head->ip_summed == CHECKSUM_COMPLETE)
+				head->csum = csum_add(head->csum, fp->csum);
+			head->truesize += fp->truesize;
+			fp = FRAG_CB(fp)->next_frag;
+		}
+		/* Move to the next run. */
+		if (rbn) {
+			struct rb_node *rbnext = rb_next(rbn);
+
+			fp = rb_to_skb(rbn);
+			rb_erase(rbn, &q->rb_fragments);
+			rbn = rbnext;
+		}
+	}
+	sub_frag_mem_limit(q->net, head->truesize);
+
+	*nextp = NULL;
+	head->next = NULL;
+	head->prev = NULL;
+	head->tstamp = q->stamp;
+}
+EXPORT_SYMBOL(inet_frag_reasm_finish);
+
+struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q)
+{
+	struct sk_buff *head;
+
+	if (q->fragments) {
+		head = q->fragments;
+		q->fragments = head->next;
+	} else {
+		struct sk_buff *skb;
+
+		head = skb_rb_first(&q->rb_fragments);
+		if (!head)
+			return NULL;
+		skb = FRAG_CB(head)->next_frag;
+		if (skb)
+			rb_replace_node(&head->rbnode, &skb->rbnode,
+					&q->rb_fragments);
+		else
+			rb_erase(&head->rbnode, &q->rb_fragments);
+		memset(&head->rbnode, 0, sizeof(head->rbnode));
+		barrier();
+	}
+	if (head == q->fragments_tail)
+		q->fragments_tail = NULL;
+
+	sub_frag_mem_limit(q->net, head->truesize);
+
+	return head;
+}
+EXPORT_SYMBOL(inet_frag_pull_head);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index a53652c8c0fd..726fdd1998b7 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -58,57 +58,6 @@
 static int sysctl_ipfrag_max_dist __read_mostly = 64;
 static const char ip_frag_cache_name[] = "ip4-frags";
 
-/* Use skb->cb to track consecutive/adjacent fragments coming at
- * the end of the queue. Nodes in the rb-tree queue will
- * contain "runs" of one or more adjacent fragments.
- *
- * Invariants:
- * - next_frag is NULL at the tail of a "run";
- * - the head of a "run" has the sum of all fragment lengths in frag_run_len.
- */
-struct ipfrag_skb_cb {
-	struct inet_skb_parm	h;
-	struct sk_buff		*next_frag;
-	int			frag_run_len;
-};
-
-#define FRAG_CB(skb)		((struct ipfrag_skb_cb *)((skb)->cb))
-
-static void ip4_frag_init_run(struct sk_buff *skb)
-{
-	BUILD_BUG_ON(sizeof(struct ipfrag_skb_cb) > sizeof(skb->cb));
-
-	FRAG_CB(skb)->next_frag = NULL;
-	FRAG_CB(skb)->frag_run_len = skb->len;
-}
-
-/* Append skb to the last "run". */
-static void ip4_frag_append_to_last_run(struct inet_frag_queue *q,
-					struct sk_buff *skb)
-{
-	RB_CLEAR_NODE(&skb->rbnode);
-	FRAG_CB(skb)->next_frag = NULL;
-
-	FRAG_CB(q->last_run_head)->frag_run_len += skb->len;
-	FRAG_CB(q->fragments_tail)->next_frag = skb;
-	q->fragments_tail = skb;
-}
-
-/* Create a new "run" with the skb. */
-static void ip4_frag_create_run(struct inet_frag_queue *q, struct sk_buff *skb)
-{
-	if (q->last_run_head)
-		rb_link_node(&skb->rbnode, &q->last_run_head->rbnode,
-			     &q->last_run_head->rbnode.rb_right);
-	else
-		rb_link_node(&skb->rbnode, NULL, &q->rb_fragments.rb_node);
-	rb_insert_color(&skb->rbnode, &q->rb_fragments);
-
-	ip4_frag_init_run(skb);
-	q->fragments_tail = skb;
-	q->last_run_head = skb;
-}
-
 /* Describe an entry in the "incomplete datagrams" queue. */
 struct ipq {
 	struct inet_frag_queue q;
@@ -212,27 +161,9 @@ static void ip_expire(unsigned long arg)
 	 * pull the head out of the tree in order to be able to
 	 * deal with head->dev.
 	 */
-	if (qp->q.fragments) {
-		head = qp->q.fragments;
-		qp->q.fragments = head->next;
-	} else {
-		head = skb_rb_first(&qp->q.rb_fragments);
-		if (!head)
-			goto out;
-		if (FRAG_CB(head)->next_frag)
-			rb_replace_node(&head->rbnode,
-					&FRAG_CB(head)->next_frag->rbnode,
-					&qp->q.rb_fragments);
-		else
-			rb_erase(&head->rbnode, &qp->q.rb_fragments);
-		memset(&head->rbnode, 0, sizeof(head->rbnode));
-		barrier();
-	}
-	if (head == qp->q.fragments_tail)
-		qp->q.fragments_tail = NULL;
-
-	sub_frag_mem_limit(qp->q.net, head->truesize);
-
+	head = inet_frag_pull_head(&qp->q);
+	if (!head)
+		goto out;
 	head->dev = dev_get_by_index_rcu(net, qp->iif);
 	if (!head->dev)
 		goto out;
@@ -345,12 +276,10 @@ static int ip_frag_reinit(struct ipq *qp)
 static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 {
 	struct net *net = container_of(qp->q.net, struct net, ipv4.frags);
-	struct rb_node **rbn, *parent;
-	struct sk_buff *skb1, *prev_tail;
-	int ihl, end, skb1_run_end;
+	int ihl, end, flags, offset;
+	struct sk_buff *prev_tail;
 	struct net_device *dev;
 	unsigned int fragsize;
-	int flags, offset;
 	int err = -ENOENT;
 	u8 ecn;
 
@@ -414,62 +343,13 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	/* Makes sure compiler wont do silly aliasing games */
 	barrier();
 
-	/* RFC5722, Section 4, amended by Errata ID : 3089
-	 *                          When reassembling an IPv6 datagram, if
-	 *   one or more its constituent fragments is determined to be an
-	 *   overlapping fragment, the entire datagram (and any constituent
-	 *   fragments) MUST be silently discarded.
-	 *
-	 * We do the same here for IPv4 (and increment an snmp counter) but
-	 * we do not want to drop the whole queue in response to a duplicate
-	 * fragment.
-	 */
-
-	err = -EINVAL;
-	/* Find out where to put this fragment.  */
 	prev_tail = qp->q.fragments_tail;
-	if (!prev_tail)
-		ip4_frag_create_run(&qp->q, skb);  /* First fragment. */
-	else if (prev_tail->ip_defrag_offset + prev_tail->len < end) {
-		/* This is the common case: skb goes to the end. */
-		/* Detect and discard overlaps. */
-		if (offset < prev_tail->ip_defrag_offset + prev_tail->len)
-			goto overlap;
-		if (offset == prev_tail->ip_defrag_offset + prev_tail->len)
-			ip4_frag_append_to_last_run(&qp->q, skb);
-		else
-			ip4_frag_create_run(&qp->q, skb);
-	} else {
-		/* Binary search. Note that skb can become the first fragment,
-		 * but not the last (covered above).
-		 */
-		rbn = &qp->q.rb_fragments.rb_node;
-		do {
-			parent = *rbn;
-			skb1 = rb_to_skb(parent);
-			skb1_run_end = skb1->ip_defrag_offset +
-				       FRAG_CB(skb1)->frag_run_len;
-			if (end <= skb1->ip_defrag_offset)
-				rbn = &parent->rb_left;
-			else if (offset >= skb1_run_end)
-				rbn = &parent->rb_right;
-			else if (offset >= skb1->ip_defrag_offset &&
-				 end <= skb1_run_end)
-				goto err; /* No new data, potential duplicate */
-			else
-				goto overlap; /* Found an overlap */
-		} while (*rbn);
-		/* Here we have parent properly set, and rbn pointing to
-		 * one of its NULL left/right children. Insert skb.
-		 */
-		ip4_frag_init_run(skb);
-		rb_link_node(&skb->rbnode, parent, rbn);
-		rb_insert_color(&skb->rbnode, &qp->q.rb_fragments);
-	}
+	err = inet_frag_queue_insert(&qp->q, skb, offset, end);
+	if (err)
+		goto insert_error;
 
 	if (dev)
 		qp->iif = dev->ifindex;
-	skb->ip_defrag_offset = offset;
 
 	qp->q.stamp = skb->tstamp;
 	qp->q.meat += skb->len;
@@ -502,10 +382,15 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	return -EINPROGRESS;
 
-overlap:
+insert_error:
+	if (err == IPFRAG_DUP) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
 	IP_INC_STATS_BH(net, IPSTATS_MIB_REASM_OVERLAPS);
 discard_qp:
 	inet_frag_kill(&qp->q);
+	IP_INC_STATS_BH(net, IPSTATS_MIB_REASMFAILS);
 err:
 	kfree_skb(skb);
 	return err;
@@ -517,13 +402,8 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 {
 	struct net *net = container_of(qp->q.net, struct net, ipv4.frags);
 	struct iphdr *iph;
-	struct sk_buff *fp, *head = skb_rb_first(&qp->q.rb_fragments);
-	struct sk_buff **nextp; /* To build frag_list. */
-	struct rb_node *rbn;
-	int len;
-	int ihlen;
-	int delta;
-	int err;
+	void *reasm_data;
+	int len, err;
 	u8 ecn;
 
 	ipq_kill(qp);
@@ -534,116 +414,20 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 		goto out_fail;
 	}
 	/* Make the one we just received the head. */
-	if (head != skb) {
-		fp = skb_clone(skb, GFP_ATOMIC);
-		if (!fp)
-			goto out_nomem;
-		FRAG_CB(fp)->next_frag = FRAG_CB(skb)->next_frag;
-		if (RB_EMPTY_NODE(&skb->rbnode))
-			FRAG_CB(prev_tail)->next_frag = fp;
-		else
-			rb_replace_node(&skb->rbnode, &fp->rbnode,
-					&qp->q.rb_fragments);
-		if (qp->q.fragments_tail == skb)
-			qp->q.fragments_tail = fp;
-		skb_morph(skb, head);
-		FRAG_CB(skb)->next_frag = FRAG_CB(head)->next_frag;
-		rb_replace_node(&head->rbnode, &skb->rbnode,
-				&qp->q.rb_fragments);
-		consume_skb(head);
-		head = skb;
-	}
-
-	WARN_ON(head->ip_defrag_offset != 0);
-
-	/* Allocate a new buffer for the datagram. */
-	ihlen = ip_hdrlen(head);
-	len = ihlen + qp->q.len;
+	reasm_data = inet_frag_reasm_prepare(&qp->q, skb, prev_tail);
+	if (!reasm_data)
+		goto out_nomem;
 
+	len = ip_hdrlen(skb) + qp->q.len;
 	err = -E2BIG;
 	if (len > 65535)
 		goto out_oversize;
 
-	delta = - head->truesize;
+	inet_frag_reasm_finish(&qp->q, skb, reasm_data);
+	skb->dev = dev;
+	IPCB(skb)->frag_max_size = max(qp->max_df_size, qp->q.max_size);
 
-	/* Head of list must not be cloned. */
-	if (skb_unclone(head, GFP_ATOMIC))
-		goto out_nomem;
-
-	delta += head->truesize;
-	if (delta)
-		add_frag_mem_limit(qp->q.net, delta);
-
-	/* If the first fragment is fragmented itself, we split
-	 * it to two chunks: the first with data and paged part
-	 * and the second, holding only fragments. */
-	if (skb_has_frag_list(head)) {
-		struct sk_buff *clone;
-		int i, plen = 0;
-
-		clone = alloc_skb(0, GFP_ATOMIC);
-		if (!clone)
-			goto out_nomem;
-		skb_shinfo(clone)->frag_list = skb_shinfo(head)->frag_list;
-		skb_frag_list_init(head);
-		for (i = 0; i < skb_shinfo(head)->nr_frags; i++)
-			plen += skb_frag_size(&skb_shinfo(head)->frags[i]);
-		clone->len = clone->data_len = head->data_len - plen;
-		head->truesize += clone->truesize;
-		clone->csum = 0;
-		clone->ip_summed = head->ip_summed;
-		add_frag_mem_limit(qp->q.net, clone->truesize);
-		skb_shinfo(head)->frag_list = clone;
-		nextp = &clone->next;
-	} else {
-		nextp = &skb_shinfo(head)->frag_list;
-	}
-
-	skb_push(head, head->data - skb_network_header(head));
-
-	/* Traverse the tree in order, to build frag_list. */
-	fp = FRAG_CB(head)->next_frag;
-	rbn = rb_next(&head->rbnode);
-	rb_erase(&head->rbnode, &qp->q.rb_fragments);
-	while (rbn || fp) {
-		/* fp points to the next sk_buff in the current run;
-		 * rbn points to the next run.
-		 */
-		/* Go through the current run. */
-		while (fp) {
-			*nextp = fp;
-			nextp = &fp->next;
-			fp->prev = NULL;
-			memset(&fp->rbnode, 0, sizeof(fp->rbnode));
-			fp->sk = NULL;
-			head->data_len += fp->len;
-			head->len += fp->len;
-			if (head->ip_summed != fp->ip_summed)
-				head->ip_summed = CHECKSUM_NONE;
-			else if (head->ip_summed == CHECKSUM_COMPLETE)
-				head->csum = csum_add(head->csum, fp->csum);
-			head->truesize += fp->truesize;
-			fp = FRAG_CB(fp)->next_frag;
-		}
-		/* Move to the next run. */
-		if (rbn) {
-			struct rb_node *rbnext = rb_next(rbn);
-
-			fp = rb_to_skb(rbn);
-			rb_erase(rbn, &qp->q.rb_fragments);
-			rbn = rbnext;
-		}
-	}
-	sub_frag_mem_limit(qp->q.net, head->truesize);
-
-	*nextp = NULL;
-	head->next = NULL;
-	head->prev = NULL;
-	head->dev = dev;
-	head->tstamp = qp->q.stamp;
-	IPCB(head)->frag_max_size = max(qp->max_df_size, qp->q.max_size);
-
-	iph = ip_hdr(head);
+	iph = ip_hdr(skb);
 	iph->tot_len = htons(len);
 	iph->tos |= ecn;
 
@@ -656,7 +440,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 	 * from one very small df-fragment and one large non-df frag.
 	 */
 	if (qp->max_df_size == qp->q.max_size) {
-		IPCB(head)->flags |= IPSKB_FRAG_PMTU;
+		IPCB(skb)->flags |= IPSKB_FRAG_PMTU;
 		iph->frag_off = htons(IP_DF);
 	} else {
 		iph->frag_off = 0;
@@ -754,28 +538,6 @@ struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 }
 EXPORT_SYMBOL(ip_check_defrag);
 
-unsigned int inet_frag_rbtree_purge(struct rb_root *root)
-{
-	struct rb_node *p = rb_first(root);
-	unsigned int sum = 0;
-
-	while (p) {
-		struct sk_buff *skb = rb_entry(p, struct sk_buff, rbnode);
-
-		p = rb_next(p);
-		rb_erase(&skb->rbnode, root);
-		while (skb) {
-			struct sk_buff *next = FRAG_CB(skb)->next_frag;
-
-			sum += skb->truesize;
-			kfree_skb(skb);
-			skb = next;
-		}
-	}
-	return sum;
-}
-EXPORT_SYMBOL(inet_frag_rbtree_purge);
-
 #ifdef CONFIG_SYSCTL
 static int dist_min;
 
-- 
2.17.1

