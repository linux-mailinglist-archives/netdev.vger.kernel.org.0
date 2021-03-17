Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB86A33E68D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCQCGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229708AbhCQCGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20hFv09HkTXYW9Ka8daiCMA+6egd5Es0b7xYpC6naCQ=;
        b=T12Y5i07CuizWiKQNV04l84NxAMPP22E2X/hr0cBgQUbnE8oq+l6FTHxAvM/9cxNCUqgFV
        R/z0d9my0pAPZfxbv7Zy6qw396oi8tOWNyOqAxjZyaem1YBuk544KHzVet70sFmy1YXZRI
        WyBu2eM4knHfHTjCI3x2yQgRWsbSgqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-1hhY5EAfOkavfmm182nzXg-1; Tue, 16 Mar 2021 22:06:31 -0400
X-MC-Unique: 1hhY5EAfOkavfmm182nzXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ABD5100C618;
        Wed, 17 Mar 2021 02:06:29 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C29455C1A3;
        Wed, 17 Mar 2021 02:06:25 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 01/16] tipc: re-organize members of struct publication
Date:   Tue, 16 Mar 2021 22:06:08 -0400
Message-Id: <20210317020623.1258298-2-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

In a future commit we will introduce more members to struct publication.
In order to keep this structure comprehensible we now group some of
its current fields into the sub-structures where they really belong,
- A struct tipc_service_range for the functional address the publication
  is representing.
- A struct tipc_socket_addr for the socket bound to that service range.

We also rename the stack variable 'publ' to just 'p' in a few places.
This is just as easy to understand in the given context, and keeps the
number of wrapped code lines to a minimum.

There are no functional changes in this commit.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_distr.c | 66 +++++++++++++++++++++----------------------
 net/tipc/name_table.c | 66 +++++++++++++++++++++----------------------
 net/tipc/name_table.h | 17 ++++-------
 net/tipc/socket.c     | 40 +++++++++++++-------------
 4 files changed, 92 insertions(+), 97 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 6cf57c3bfa27..1070b04d1126 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -1,8 +1,9 @@
 /*
  * net/tipc/name_distr.c: TIPC name distribution code
  *
- * Copyright (c) 2000-2006, 2014, Ericsson AB
+ * Copyright (c) 2000-2006, 2014-2019, Ericsson AB
  * Copyright (c) 2005, 2010-2011, Wind River Systems
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -55,10 +56,10 @@ struct distr_queue_item {
  */
 static void publ_to_item(struct distr_item *i, struct publication *p)
 {
-	i->type = htonl(p->type);
-	i->lower = htonl(p->lower);
-	i->upper = htonl(p->upper);
-	i->port = htonl(p->port);
+	i->type = htonl(p->sr.type);
+	i->lower = htonl(p->sr.lower);
+	i->upper = htonl(p->sr.upper);
+	i->port = htonl(p->sk.ref);
 	i->key = htonl(p->key);
 }
 
@@ -90,20 +91,20 @@ static struct sk_buff *named_prepare_buf(struct net *net, u32 type, u32 size,
 /**
  * tipc_named_publish - tell other nodes about a new publication by this node
  * @net: the associated network namespace
- * @publ: the new publication
+ * @p: the new publication
  */
-struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
+struct sk_buff *tipc_named_publish(struct net *net, struct publication *p)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct distr_item *item;
 	struct sk_buff *skb;
 
-	if (publ->scope == TIPC_NODE_SCOPE) {
-		list_add_tail_rcu(&publ->binding_node, &nt->node_scope);
+	if (p->scope == TIPC_NODE_SCOPE) {
+		list_add_tail_rcu(&p->binding_node, &nt->node_scope);
 		return NULL;
 	}
 	write_lock_bh(&nt->cluster_scope_lock);
-	list_add_tail(&publ->binding_node, &nt->cluster_scope);
+	list_add_tail(&p->binding_node, &nt->cluster_scope);
 	write_unlock_bh(&nt->cluster_scope_lock);
 	skb = named_prepare_buf(net, PUBLICATION, ITEM_SIZE, 0);
 	if (!skb) {
@@ -113,25 +114,25 @@ struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
 	msg_set_named_seqno(buf_msg(skb), nt->snd_nxt++);
 	msg_set_non_legacy(buf_msg(skb));
 	item = (struct distr_item *)msg_data(buf_msg(skb));
-	publ_to_item(item, publ);
+	publ_to_item(item, p);
 	return skb;
 }
 
 /**
  * tipc_named_withdraw - tell other nodes about a withdrawn publication by this node
  * @net: the associated network namespace
- * @publ: the withdrawn publication
+ * @p: the withdrawn publication
  */
-struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *publ)
+struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *p)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct distr_item *item;
 	struct sk_buff *skb;
 
 	write_lock_bh(&nt->cluster_scope_lock);
-	list_del(&publ->binding_node);
+	list_del(&p->binding_node);
 	write_unlock_bh(&nt->cluster_scope_lock);
-	if (publ->scope == TIPC_NODE_SCOPE)
+	if (p->scope == TIPC_NODE_SCOPE)
 		return NULL;
 
 	skb = named_prepare_buf(net, WITHDRAWAL, ITEM_SIZE, 0);
@@ -142,7 +143,7 @@ struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *publ)
 	msg_set_named_seqno(buf_msg(skb), nt->snd_nxt++);
 	msg_set_non_legacy(buf_msg(skb));
 	item = (struct distr_item *)msg_data(buf_msg(skb));
-	publ_to_item(item, publ);
+	publ_to_item(item, p);
 	return skb;
 }
 
@@ -233,33 +234,32 @@ void tipc_named_node_up(struct net *net, u32 dnode, u16 capabilities)
 /**
  * tipc_publ_purge - remove publication associated with a failed node
  * @net: the associated network namespace
- * @publ: the publication to remove
+ * @p: the publication to remove
  * @addr: failed node's address
  *
  * Invoked for each publication issued by a newly failed node.
  * Removes publication structure from name table & deletes it.
  */
-static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
+static void tipc_publ_purge(struct net *net, struct publication *p, u32 addr)
 {
 	struct tipc_net *tn = tipc_net(net);
-	struct publication *p;
+	struct publication *_p;
 
 	spin_lock_bh(&tn->nametbl_lock);
-	p = tipc_nametbl_remove_publ(net, publ->type, publ->lower, publ->upper,
-				     publ->node, publ->key);
-	if (p)
-		tipc_node_unsubscribe(net, &p->binding_node, addr);
+	_p = tipc_nametbl_remove_publ(net, p->sr.type, p->sr.lower,
+				      p->sr.upper, p->sk.node, p->key);
+	if (_p)
+		tipc_node_unsubscribe(net, &_p->binding_node, addr);
 	spin_unlock_bh(&tn->nametbl_lock);
 
-	if (p != publ) {
+	if (_p != p) {
 		pr_err("Unable to remove publication from failed node\n"
 		       " (type=%u, lower=%u, node=0x%x, port=%u, key=%u)\n",
-		       publ->type, publ->lower, publ->node, publ->port,
-		       publ->key);
+		       p->sr.type, p->sr.lower, p->sk.node, p->sk.ref, p->key);
 	}
 
-	if (p)
-		kfree_rcu(p, rcu);
+	if (_p)
+		kfree_rcu(_p, rcu);
 }
 
 void tipc_publ_notify(struct net *net, struct list_head *nsub_list,
@@ -410,15 +410,15 @@ void tipc_named_reinit(struct net *net)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct tipc_net *tn = tipc_net(net);
-	struct publication *publ;
+	struct publication *p;
 	u32 self = tipc_own_addr(net);
 
 	spin_lock_bh(&tn->nametbl_lock);
 
-	list_for_each_entry_rcu(publ, &nt->node_scope, binding_node)
-		publ->node = self;
-	list_for_each_entry_rcu(publ, &nt->cluster_scope, binding_node)
-		publ->node = self;
+	list_for_each_entry_rcu(p, &nt->node_scope, binding_node)
+		p->sk.node = self;
+	list_for_each_entry_rcu(p, &nt->cluster_scope, binding_node)
+		p->sk.node = self;
 	nt->rc_dests = 0;
 	spin_unlock_bh(&tn->nametbl_lock);
 }
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index ee5ac40ea2b6..c2410ba7be5c 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2014-2018, Ericsson AB
  * Copyright (c) 2004-2008, 2010-2014, Wind River Systems
- * Copyright (c) 2020, Red Hat Inc
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -234,24 +234,24 @@ static struct publication *tipc_publ_create(u32 type, u32 lower, u32 upper,
 					    u32 scope, u32 node, u32 port,
 					    u32 key)
 {
-	struct publication *publ = kzalloc(sizeof(*publ), GFP_ATOMIC);
+	struct publication *p = kzalloc(sizeof(*p), GFP_ATOMIC);
 
-	if (!publ)
+	if (!p)
 		return NULL;
 
-	publ->type = type;
-	publ->lower = lower;
-	publ->upper = upper;
-	publ->scope = scope;
-	publ->node = node;
-	publ->port = port;
-	publ->key = key;
-	INIT_LIST_HEAD(&publ->binding_sock);
-	INIT_LIST_HEAD(&publ->binding_node);
-	INIT_LIST_HEAD(&publ->local_publ);
-	INIT_LIST_HEAD(&publ->all_publ);
-	INIT_LIST_HEAD(&publ->list);
-	return publ;
+	p->sr.type = type;
+	p->sr.lower = lower;
+	p->sr.upper = upper;
+	p->scope = scope;
+	p->sk.node = node;
+	p->sk.ref = port;
+	p->key = key;
+	INIT_LIST_HEAD(&p->binding_sock);
+	INIT_LIST_HEAD(&p->binding_node);
+	INIT_LIST_HEAD(&p->local_publ);
+	INIT_LIST_HEAD(&p->all_publ);
+	INIT_LIST_HEAD(&p->list);
+	return p;
 }
 
 /**
@@ -347,7 +347,7 @@ static struct publication *tipc_service_insert_publ(struct net *net,
 
 	/* Return if the publication already exists */
 	list_for_each_entry(p, &sr->all_publ, all_publ) {
-		if (p->key == key && (!p->node || p->node == node))
+		if (p->key == key && (!p->sk.node || p->sk.node == node))
 			return NULL;
 	}
 
@@ -363,8 +363,8 @@ static struct publication *tipc_service_insert_publ(struct net *net,
 
 	/* Any subscriptions waiting for notification?  */
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
-		tipc_sub_report_overlap(sub, p->lower, p->upper, TIPC_PUBLISHED,
-					p->port, p->node, p->scope, first);
+		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper, TIPC_PUBLISHED,
+					p->sk.ref, p->sk.node, p->scope, first);
 	}
 	return p;
 err:
@@ -384,7 +384,7 @@ static struct publication *tipc_service_remove_publ(struct service_range *sr,
 	struct publication *p;
 
 	list_for_each_entry(p, &sr->all_publ, all_publ) {
-		if (p->key != key || (node && node != p->node))
+		if (p->key != key || (node && node != p->sk.node))
 			continue;
 		list_del(&p->all_publ);
 		list_del(&p->local_publ);
@@ -452,8 +452,8 @@ static void tipc_service_subscribe(struct tipc_service *service,
 	/* Sort the publications before reporting */
 	list_sort(NULL, &publ_list, tipc_publ_sort);
 	list_for_each_entry_safe(p, tmp, &publ_list, list) {
-		tipc_sub_report_overlap(sub, p->lower, p->upper,
-					TIPC_PUBLISHED, p->port, p->node,
+		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper,
+					TIPC_PUBLISHED, p->sk.ref, p->sk.node,
 					p->scope, true);
 		list_del_init(&p->list);
 	}
@@ -525,7 +525,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
 	last = list_empty(&sr->all_publ);
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
 		tipc_sub_report_overlap(sub, lower, upper, TIPC_WITHDRAWN,
-					p->port, node, p->scope, last);
+					p->sk.ref, node, p->scope, last);
 	}
 
 	/* Remove service range item if this was its last publication */
@@ -603,8 +603,8 @@ u32 tipc_nametbl_translate(struct net *net, u32 type, u32 instance, u32 *dnode)
 					     all_publ);
 			list_move_tail(&p->all_publ, &sr->all_publ);
 		}
-		port = p->port;
-		node = p->node;
+		port = p->sk.ref;
+		node = p->sk.node;
 		/* Todo: as for legacy, pick the first matching range only, a
 		 * "true" round-robin will be performed as needed.
 		 */
@@ -643,9 +643,9 @@ bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 scope,
 	list_for_each_entry(p, &sr->all_publ, all_publ) {
 		if (p->scope != scope)
 			continue;
-		if (p->port == exclude && p->node == self)
+		if (p->sk.ref == exclude && p->sk.node == self)
 			continue;
-		tipc_dest_push(dsts, p->node, p->port);
+		tipc_dest_push(dsts, p->sk.node, p->sk.ref);
 		(*dstcnt)++;
 		if (all)
 			continue;
@@ -675,7 +675,7 @@ void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
 	service_range_foreach_match(sr, sc, lower, upper) {
 		list_for_each_entry(p, &sr->local_publ, local_publ) {
 			if (p->scope == scope || (!exact && p->scope < scope))
-				tipc_dest_push(dports, 0, p->port);
+				tipc_dest_push(dports, 0, p->sk.ref);
 		}
 	}
 	spin_unlock_bh(&sc->lock);
@@ -702,7 +702,7 @@ void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
 	spin_lock_bh(&sc->lock);
 	service_range_foreach_match(sr, sc, lower, upper) {
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
-			tipc_nlist_add(nodes, p->node);
+			tipc_nlist_add(nodes, p->sk.node);
 		}
 	}
 	spin_unlock_bh(&sc->lock);
@@ -731,7 +731,7 @@ void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			if (p->scope != scope)
 				continue;
-			tipc_group_add_member(grp, p->node, p->port, p->lower);
+			tipc_group_add_member(grp, p->sk.node, p->sk.ref, p->sr.lower);
 		}
 	}
 	spin_unlock_bh(&sc->lock);
@@ -909,7 +909,7 @@ static void tipc_service_delete(struct net *net, struct tipc_service *sc)
 	spin_lock_bh(&sc->lock);
 	rbtree_postorder_for_each_entry_safe(sr, tmpr, &sc->ranges, tree_node) {
 		list_for_each_entry_safe(p, tmp, &sr->all_publ, all_publ) {
-			tipc_service_remove_publ(sr, p->node, p->key);
+			tipc_service_remove_publ(sr, p->sk.node, p->key);
 			kfree_rcu(p, rcu);
 		}
 		rb_erase_augmented(&sr->tree_node, &sc->ranges, &sr_callbacks);
@@ -993,9 +993,9 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 			goto publ_msg_full;
 		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_SCOPE, p->scope))
 			goto publ_msg_full;
-		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_NODE, p->node))
+		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_NODE, p->sk.node))
 			goto publ_msg_full;
-		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_REF, p->port))
+		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_REF, p->sk.ref))
 			goto publ_msg_full;
 		if (nla_put_u32(msg->skb, TIPC_NLA_PUBL_KEY, p->key))
 			goto publ_msg_full;
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 5a82a01369d6..d9ad119f966b 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2014-2018, Ericsson AB
  * Copyright (c) 2004-2005, 2010-2011, Wind River Systems
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -50,13 +51,10 @@ struct tipc_group;
 #define TIPC_NAMETBL_SIZE	1024	/* must be a power of 2 */
 
 /**
- * struct publication - info about a published (name or) name sequence
- * @type: name sequence type
- * @lower: name sequence lower bound
- * @upper: name sequence upper bound
+ * struct publication - info about a published service address or range
+ * @sr: service range represented by this publication
+ * @sk: address of socket bound to this publication
  * @scope: scope of publication, TIPC_NODE_SCOPE or TIPC_CLUSTER_SCOPE
- * @node: network address of publishing socket's node
- * @port: publishing port
  * @key: publication key, unique across the cluster
  * @id: publication id
  * @binding_node: all publications from the same node which bound this one
@@ -74,12 +72,9 @@ struct tipc_group;
  * @rcu: RCU callback head used for deferred freeing
  */
 struct publication {
-	u32 type;
-	u32 lower;
-	u32 upper;
+	struct tipc_service_range sr;
+	struct tipc_socket_addr sk;
 	u32 scope;
-	u32 node;
-	u32 port;
 	u32 key;
 	u32 id;
 	struct list_head binding_node;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index cebcc104dc70..fe522d49f747 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2001-2007, 2012-2019, Ericsson AB
  * Copyright (c) 2004-2008, 2010-2013, Wind River Systems
- * Copyright (c) 2020, Red Hat Inc
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2923,30 +2923,30 @@ static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
 			    struct tipc_service_range const *seq)
 {
 	struct net *net = sock_net(&tsk->sk);
-	struct publication *publ;
+	struct publication *p;
 	struct publication *safe;
 	int rc = -EINVAL;
 
 	if (scope != TIPC_NODE_SCOPE)
 		scope = TIPC_CLUSTER_SCOPE;
 
-	list_for_each_entry_safe(publ, safe, &tsk->publications, binding_sock) {
+	list_for_each_entry_safe(p, safe, &tsk->publications, binding_sock) {
 		if (seq) {
-			if (publ->scope != scope)
+			if (p->scope != scope)
 				continue;
-			if (publ->type != seq->type)
+			if (p->sr.type != seq->type)
 				continue;
-			if (publ->lower != seq->lower)
+			if (p->sr.lower != seq->lower)
 				continue;
-			if (publ->upper != seq->upper)
+			if (p->sr.upper != seq->upper)
 				break;
-			tipc_nametbl_withdraw(net, publ->type, publ->lower,
-					      publ->upper, publ->key);
+			tipc_nametbl_withdraw(net, p->sr.type, p->sr.lower,
+					      p->sr.upper, p->key);
 			rc = 0;
 			break;
 		}
-		tipc_nametbl_withdraw(net, publ->type, publ->lower,
-				      publ->upper, publ->key);
+		tipc_nametbl_withdraw(net, p->sr.type, p->sr.lower,
+				      p->sr.upper, p->key);
 		rc = 0;
 	}
 	if (list_empty(&tsk->publications))
@@ -3711,11 +3711,11 @@ static int __tipc_nl_add_sk_publ(struct sk_buff *skb,
 
 	if (nla_put_u32(skb, TIPC_NLA_PUBL_KEY, publ->key))
 		goto attr_msg_cancel;
-	if (nla_put_u32(skb, TIPC_NLA_PUBL_TYPE, publ->type))
+	if (nla_put_u32(skb, TIPC_NLA_PUBL_TYPE, publ->sr.type))
 		goto attr_msg_cancel;
-	if (nla_put_u32(skb, TIPC_NLA_PUBL_LOWER, publ->lower))
+	if (nla_put_u32(skb, TIPC_NLA_PUBL_LOWER, publ->sr.lower))
 		goto attr_msg_cancel;
-	if (nla_put_u32(skb, TIPC_NLA_PUBL_UPPER, publ->upper))
+	if (nla_put_u32(skb, TIPC_NLA_PUBL_UPPER, publ->sr.upper))
 		goto attr_msg_cancel;
 
 	nla_nest_end(skb, attrs);
@@ -3863,9 +3863,9 @@ bool tipc_sk_filtering(struct sock *sk)
 		p = list_first_entry_or_null(&tsk->publications,
 					     struct publication, binding_sock);
 		if (p) {
-			type = p->type;
-			lower = p->lower;
-			upper = p->upper;
+			type = p->sr.type;
+			lower = p->sr.lower;
+			upper = p->sr.upper;
 		}
 	}
 
@@ -3964,9 +3964,9 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 	if (tsk->published) {
 		p = list_first_entry_or_null(&tsk->publications,
 					     struct publication, binding_sock);
-		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->type : 0);
-		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->lower : 0);
-		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->upper : 0);
+		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->sr.type : 0);
+		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->sr.lower : 0);
+		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->sr.upper : 0);
 	}
 	i += scnprintf(buf + i, sz - i, " | %u", tsk->snd_win);
 	i += scnprintf(buf + i, sz - i, " %u", tsk->rcv_win);
-- 
2.29.2

