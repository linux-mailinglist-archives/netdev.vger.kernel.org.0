Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25B2118219
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfLJIVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:21:19 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33021 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726062AbfLJIVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:21:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 982B54BCE5;
        Tue, 10 Dec 2019 19:21:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1575966074; bh=C1gK3wz2J+sb34nux7Nph48+tLut65Eme+poN/WLtNY=; b=d
        UtaIPEkBZ2XWYTVM7CocehdgNH1jjDthhU4n67TXn9Zbp6nXsjVwEoXjhBxQP4EN
        q9fsqC/kVZguZkIINF6XNOk/67rVY9PfSIA9gAXw6fAE2n38B86jqKdZrEv62ojC
        3FA6zfPX0gA8m4Ls0BVlBTxj18QdqsdJOmJLR2PFu0=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id deaeugbb7chc; Tue, 10 Dec 2019 19:21:14 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 7509A4BD36;
        Tue, 10 Dec 2019 19:21:14 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 4F6CA4BCE5;
        Tue, 10 Dec 2019 19:21:13 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 1/4] tipc: fix name table rbtree issues
Date:   Tue, 10 Dec 2019 15:21:02 +0700
Message-Id: <20191210082105.23905-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
References: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current rbtree for service ranges in the name table is built based
on the 'lower' & 'upper' range values resulting in a flaw in the rbtree
searching. Some issues have been observed in case of range overlapping:

Case #1: unable to withdraw a name entry:
After some name services are bound, all of them are withdrawn by user
but one remains in the name table forever. This corrupts the table and
that service becomes dummy i.e. no real port.
E.g.

                /
           {22, 22}
              /
             /
   --->  {10, 50}
           /  \
          /    \
    {10, 30}  {20, 60}

The node {10, 30} cannot be removed since the rbtree searching stops at
the node's ancestor i.e. {10, 50}, so starting from it will never reach
the finding node.

Case #2: failed to send data in some cases:
E.g. Two service ranges: {20, 60}, {10, 50} are bound. The rbtree for
this service will be one of the two cases below depending on the order
of the bindings:

        {20, 60}             {10, 50} <--
          /  \                 /  \
         /    \               /    \
    {10, 50}  NIL <--       NIL  {20, 60}

          (a)                    (b)

Now, try to send some data to service {30}, there will be two results:
(a): Failed, no route to host.
(b): Ok.

The reason is that the rbtree searching will stop at the pointing node
as shown above.

Case #3: Same as case #2b above but if the data sending's scope is
local and the {10, 50} is published by a peer node, then it will result
in 'no route to host' even though the other {20, 60} is for example on
the local node which should be able to get the data.

The issues are actually due to the way we built the rbtree. This commit
fixes it by introducing an additional field to each node - named 'max',
which is the largest 'upper' of that node subtree. The 'max' value for
each subtrees will be propagated correctly whenever a node is inserted/
removed or the tree is rebalanced by the augmented rbtree callbacks.

By this way, we can change the rbtree searching appoarch to solve the
issues above. Another benefit from this is that we can now improve the
searching for a next range matching e.g. in case of multicast, so get
rid of the unneeded looping over all nodes in the tree.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/name_table.c | 279 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 179 insertions(+), 100 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 92d04dc2a44b..359b2bc888cf 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -36,6 +36,7 @@
 
 #include <net/sock.h>
 #include <linux/list_sort.h>
+#include <linux/rbtree_augmented.h>
 #include "core.h"
 #include "netlink.h"
 #include "name_table.h"
@@ -51,6 +52,7 @@
  * @lower: service range lower bound
  * @upper: service range upper bound
  * @tree_node: member of service range RB tree
+ * @max: largest 'upper' in this node subtree
  * @local_publ: list of identical publications made from this node
  *   Used by closest_first lookup and multicast lookup algorithm
  * @all_publ: all publications identical to this one, whatever node and scope
@@ -60,6 +62,7 @@ struct service_range {
 	u32 lower;
 	u32 upper;
 	struct rb_node tree_node;
+	u32 max;
 	struct list_head local_publ;
 	struct list_head all_publ;
 };
@@ -84,6 +87,130 @@ struct tipc_service {
 	struct rcu_head rcu;
 };
 
+#define service_range_upper(sr) ((sr)->upper)
+RB_DECLARE_CALLBACKS_MAX(static, sr_callbacks,
+			 struct service_range, tree_node, u32, max,
+			 service_range_upper)
+
+#define service_range_entry(rbtree_node)				\
+	(container_of(rbtree_node, struct service_range, tree_node))
+
+#define service_range_overlap(sr, start, end)				\
+	((sr)->lower <= (end) && (sr)->upper >= (start))
+
+/**
+ * service_range_foreach_match - iterate over tipc service rbtree for each
+ *                               range match
+ * @sr: the service range pointer as a loop cursor
+ * @sc: the pointer to tipc service which holds the service range rbtree
+ * @start, end: the range (end >= start) for matching
+ */
+#define service_range_foreach_match(sr, sc, start, end)			\
+	for (sr = service_range_match_first((sc)->ranges.rb_node,	\
+					    start,			\
+					    end);			\
+	     sr;							\
+	     sr = service_range_match_next(&(sr)->tree_node,		\
+					   start,			\
+					   end))
+
+/**
+ * service_range_match_first - find first service range matching a range
+ * @n: the root node of service range rbtree for searching
+ * @start, end: the range (end >= start) for matching
+ *
+ * Return: the leftmost service range node in the rbtree that overlaps the
+ * specific range if any. Otherwise, returns NULL.
+ */
+static struct service_range *service_range_match_first(struct rb_node *n,
+						       u32 start, u32 end)
+{
+	struct service_range *sr;
+	struct rb_node *l, *r;
+
+	/* Non overlaps in tree at all? */
+	if (!n || service_range_entry(n)->max < start)
+		return NULL;
+
+	while (n) {
+		l = n->rb_left;
+		if (l && service_range_entry(l)->max >= start) {
+			/* A leftmost overlap range node must be one in the left
+			 * subtree. If not, it has lower > end, then nodes on
+			 * the right side cannot satisfy the condition either.
+			 */
+			n = l;
+			continue;
+		}
+
+		/* No one in the left subtree can match, return if this node is
+		 * an overlap i.e. leftmost.
+		 */
+		sr = service_range_entry(n);
+		if (service_range_overlap(sr, start, end))
+			return sr;
+
+		/* Ok, try to lookup on the right side */
+		r = n->rb_right;
+		if (sr->lower <= end &&
+		    r && service_range_entry(r)->max >= start) {
+			n = r;
+			continue;
+		}
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * service_range_match_next - find next service range matching a range
+ * @n: a node in service range rbtree from which the searching starts
+ * @start, end: the range (end >= start) for matching
+ *
+ * Return: the next service range node to the given node in the rbtree that
+ * overlaps the specific range if any. Otherwise, returns NULL.
+ */
+static struct service_range *service_range_match_next(struct rb_node *n,
+						      u32 start, u32 end)
+{
+	struct service_range *sr;
+	struct rb_node *p, *r;
+
+	while (n) {
+		r = n->rb_right;
+		if (r && service_range_entry(r)->max >= start)
+			/* A next overlap range node must be one in the right
+			 * subtree. If not, it has lower > end, then any next
+			 * successor (- an ancestor) of this node cannot
+			 * satisfy the condition either.
+			 */
+			return service_range_match_first(r, start, end);
+
+		/* No one in the right subtree can match, go up to find an
+		 * ancestor of this node which is parent of a left-hand child.
+		 */
+		while ((p = rb_parent(n)) && n == p->rb_right)
+			n = p;
+		if (!p)
+			break;
+
+		/* Return if this ancestor is an overlap */
+		sr = service_range_entry(p);
+		if (service_range_overlap(sr, start, end))
+			return sr;
+
+		/* Ok, try to lookup more from this ancestor */
+		if (sr->lower <= end) {
+			n = p;
+			continue;
+		}
+		break;
+	}
+
+	return NULL;
+}
+
 static int hash(int x)
 {
 	return x & (TIPC_NAMETBL_SIZE - 1);
@@ -139,84 +266,51 @@ static struct tipc_service *tipc_service_create(u32 type, struct hlist_head *hd)
 	return service;
 }
 
-/**
- * tipc_service_first_range - find first service range in tree matching instance
- *
- * Very time-critical, so binary search through range rb tree
- */
-static struct service_range *tipc_service_first_range(struct tipc_service *sc,
-						      u32 instance)
-{
-	struct rb_node *n = sc->ranges.rb_node;
-	struct service_range *sr;
-
-	while (n) {
-		sr = container_of(n, struct service_range, tree_node);
-		if (sr->lower > instance)
-			n = n->rb_left;
-		else if (sr->upper < instance)
-			n = n->rb_right;
-		else
-			return sr;
-	}
-	return NULL;
-}
-
 /*  tipc_service_find_range - find service range matching publication parameters
  */
 static struct service_range *tipc_service_find_range(struct tipc_service *sc,
 						     u32 lower, u32 upper)
 {
-	struct rb_node *n = sc->ranges.rb_node;
 	struct service_range *sr;
 
-	sr = tipc_service_first_range(sc, lower);
-	if (!sr)
-		return NULL;
-
-	/* Look for exact match */
-	for (n = &sr->tree_node; n; n = rb_next(n)) {
-		sr = container_of(n, struct service_range, tree_node);
-		if (sr->upper == upper)
-			break;
+	service_range_foreach_match(sr, sc, lower, upper) {
+		/* Look for exact match */
+		if (sr->lower == lower && sr->upper == upper)
+			return sr;
 	}
-	if (!n || sr->lower != lower || sr->upper != upper)
-		return NULL;
 
-	return sr;
+	return NULL;
 }
 
 static struct service_range *tipc_service_create_range(struct tipc_service *sc,
 						       u32 lower, u32 upper)
 {
 	struct rb_node **n, *parent = NULL;
-	struct service_range *sr, *tmp;
+	struct service_range *sr;
 
 	n = &sc->ranges.rb_node;
 	while (*n) {
-		tmp = container_of(*n, struct service_range, tree_node);
 		parent = *n;
-		tmp = container_of(parent, struct service_range, tree_node);
-		if (lower < tmp->lower)
-			n = &(*n)->rb_left;
-		else if (lower > tmp->lower)
-			n = &(*n)->rb_right;
-		else if (upper < tmp->upper)
-			n = &(*n)->rb_left;
-		else if (upper > tmp->upper)
-			n = &(*n)->rb_right;
+		sr = service_range_entry(parent);
+		if (lower == sr->lower && upper == sr->upper)
+			return sr;
+		if (sr->max < upper)
+			sr->max = upper;
+		if (lower <= sr->lower)
+			n = &parent->rb_left;
 		else
-			return tmp;
+			n = &parent->rb_right;
 	}
 	sr = kzalloc(sizeof(*sr), GFP_ATOMIC);
 	if (!sr)
 		return NULL;
 	sr->lower = lower;
 	sr->upper = upper;
+	sr->max = upper;
 	INIT_LIST_HEAD(&sr->local_publ);
 	INIT_LIST_HEAD(&sr->all_publ);
 	rb_link_node(&sr->tree_node, parent, n);
-	rb_insert_color(&sr->tree_node, &sc->ranges);
+	rb_insert_augmented(&sr->tree_node, &sc->ranges, &sr_callbacks);
 	return sr;
 }
 
@@ -310,7 +404,6 @@ static void tipc_service_subscribe(struct tipc_service *service,
 	struct list_head publ_list;
 	struct service_range *sr;
 	struct tipc_name_seq ns;
-	struct rb_node *n;
 	u32 filter;
 
 	ns.type = tipc_sub_read(sb, seq.type);
@@ -325,13 +418,7 @@ static void tipc_service_subscribe(struct tipc_service *service,
 		return;
 
 	INIT_LIST_HEAD(&publ_list);
-	for (n = rb_first(&service->ranges); n; n = rb_next(n)) {
-		sr = container_of(n, struct service_range, tree_node);
-		if (sr->lower > ns.upper)
-			break;
-		if (!tipc_sub_check_overlap(&ns, sr->lower, sr->upper))
-			continue;
-
+	service_range_foreach_match(sr, service, ns.lower, ns.upper) {
 		first = NULL;
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			if (filter & TIPC_SUB_PORTS)
@@ -425,7 +512,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
 
 	/* Remove service range item if this was its last publication */
 	if (list_empty(&sr->all_publ)) {
-		rb_erase(&sr->tree_node, &sc->ranges);
+		rb_erase_augmented(&sr->tree_node, &sc->ranges, &sr_callbacks);
 		kfree(sr);
 	}
 
@@ -473,34 +560,39 @@ u32 tipc_nametbl_translate(struct net *net, u32 type, u32 instance, u32 *dnode)
 	rcu_read_lock();
 	sc = tipc_service_find(net, type);
 	if (unlikely(!sc))
-		goto not_found;
+		goto exit;
 
 	spin_lock_bh(&sc->lock);
-	sr = tipc_service_first_range(sc, instance);
-	if (unlikely(!sr))
-		goto no_match;
-
-	/* Select lookup algorithm: local, closest-first or round-robin */
-	if (*dnode == self) {
-		list = &sr->local_publ;
-		if (list_empty(list))
-			goto no_match;
-		p = list_first_entry(list, struct publication, local_publ);
-		list_move_tail(&p->local_publ, &sr->local_publ);
-	} else if (legacy && !*dnode && !list_empty(&sr->local_publ)) {
-		list = &sr->local_publ;
-		p = list_first_entry(list, struct publication, local_publ);
-		list_move_tail(&p->local_publ, &sr->local_publ);
-	} else {
-		list = &sr->all_publ;
-		p = list_first_entry(list, struct publication, all_publ);
-		list_move_tail(&p->all_publ, &sr->all_publ);
+	service_range_foreach_match(sr, sc, instance, instance) {
+		/* Select lookup algo: local, closest-first or round-robin */
+		if (*dnode == self) {
+			list = &sr->local_publ;
+			if (list_empty(list))
+				continue;
+			p = list_first_entry(list, struct publication,
+					     local_publ);
+			list_move_tail(&p->local_publ, &sr->local_publ);
+		} else if (legacy && !*dnode && !list_empty(&sr->local_publ)) {
+			list = &sr->local_publ;
+			p = list_first_entry(list, struct publication,
+					     local_publ);
+			list_move_tail(&p->local_publ, &sr->local_publ);
+		} else {
+			list = &sr->all_publ;
+			p = list_first_entry(list, struct publication,
+					     all_publ);
+			list_move_tail(&p->all_publ, &sr->all_publ);
+		}
+		port = p->port;
+		node = p->node;
+		/* Todo: as for legacy, pick the first matching range only, a
+		 * "true" round-robin will be performed as needed.
+		 */
+		break;
 	}
-	port = p->port;
-	node = p->node;
-no_match:
 	spin_unlock_bh(&sc->lock);
-not_found:
+
+exit:
 	rcu_read_unlock();
 	*dnode = node;
 	return port;
@@ -523,7 +615,8 @@ bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 scope,
 
 	spin_lock_bh(&sc->lock);
 
-	sr = tipc_service_first_range(sc, instance);
+	/* Todo: a full search i.e. service_range_foreach_match() instead? */
+	sr = service_range_match_first(sc->ranges.rb_node, instance, instance);
 	if (!sr)
 		goto no_match;
 
@@ -552,7 +645,6 @@ void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
-	struct rb_node *n;
 
 	rcu_read_lock();
 	sc = tipc_service_find(net, type);
@@ -560,13 +652,7 @@ void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
 		goto exit;
 
 	spin_lock_bh(&sc->lock);
-
-	for (n = rb_first(&sc->ranges); n; n = rb_next(n)) {
-		sr = container_of(n, struct service_range, tree_node);
-		if (sr->upper < lower)
-			continue;
-		if (sr->lower > upper)
-			break;
+	service_range_foreach_match(sr, sc, lower, upper) {
 		list_for_each_entry(p, &sr->local_publ, local_publ) {
 			if (p->scope == scope || (!exact && p->scope < scope))
 				tipc_dest_push(dports, 0, p->port);
@@ -587,7 +673,6 @@ void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
-	struct rb_node *n;
 
 	rcu_read_lock();
 	sc = tipc_service_find(net, type);
@@ -595,13 +680,7 @@ void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
 		goto exit;
 
 	spin_lock_bh(&sc->lock);
-
-	for (n = rb_first(&sc->ranges); n; n = rb_next(n)) {
-		sr = container_of(n, struct service_range, tree_node);
-		if (sr->upper < lower)
-			continue;
-		if (sr->lower > upper)
-			break;
+	service_range_foreach_match(sr, sc, lower, upper) {
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			tipc_nlist_add(nodes, p->node);
 		}
@@ -799,7 +878,7 @@ static void tipc_service_delete(struct net *net, struct tipc_service *sc)
 			tipc_service_remove_publ(sr, p->node, p->key);
 			kfree_rcu(p, rcu);
 		}
-		rb_erase(&sr->tree_node, &sc->ranges);
+		rb_erase_augmented(&sr->tree_node, &sc->ranges, &sr_callbacks);
 		kfree(sr);
 	}
 	hlist_del_init_rcu(&sc->service_list);
-- 
2.13.7

