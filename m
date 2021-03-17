Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79733E693
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCQCHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhCQCGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TD4d4AxORTDY9E8J5z22VZU1IV7C0MbL8s6sSYD/nhQ=;
        b=JYKK8S+wTbxTgcEz2uWx5MBEMfR6huae/NdGA28NBP0lhO6cPA3BYJsHc80cfzqMtj6eiO
        /fBcnfsCeDlbuap4lzfb5hLBkcWINQlhwxru678sOnrIY33H14rYMx98Y4wA5W/fjJqqIA
        bQQnygtV+3epZqlp6DYhNHbc549TXJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-uUnX9cdCMdugdZ9pl8lAwQ-1; Tue, 16 Mar 2021 22:06:38 -0400
X-MC-Unique: uUnX9cdCMdugdZ9pl8lAwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84F93817469;
        Wed, 17 Mar 2021 02:06:36 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 443155C1A1;
        Wed, 17 Mar 2021 02:06:35 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 06/16] tipc: simplify signature of tipc_nametbl_withdraw() functions
Date:   Tue, 16 Mar 2021 22:06:13 -0400
Message-Id: <20210317020623.1258298-7-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

Following the principles of the preceding commits, we reduce
the number of parameters passed along in tipc_sk_withdraw(),
tipc_nametbl_withdraw() and associated functions.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_distr.c | 11 ++++----
 net/tipc/name_table.c | 51 ++++++++++++++++++-----------------
 net/tipc/name_table.h | 11 ++++----
 net/tipc/node.c       |  3 +--
 net/tipc/socket.c     | 62 +++++++++++++++++++++----------------------
 5 files changed, 70 insertions(+), 68 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 727f8c54df6b..9e2fab3569b5 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -244,17 +244,19 @@ static void tipc_publ_purge(struct net *net, struct publication *p, u32 addr)
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct publication *_p;
+	struct tipc_uaddr ua;
 
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, p->scope, p->sr.type,
+		   p->sr.lower, p->sr.upper);
 	spin_lock_bh(&tn->nametbl_lock);
-	_p = tipc_nametbl_remove_publ(net, p->sr.type, p->sr.lower,
-				      p->sr.upper, p->sk.node, p->key);
+	_p = tipc_nametbl_remove_publ(net, &ua, &p->sk, p->key);
 	if (_p)
 		tipc_node_unsubscribe(net, &_p->binding_node, addr);
 	spin_unlock_bh(&tn->nametbl_lock);
 
 	if (_p != p) {
 		pr_err("Unable to remove publication from failed node\n"
-		       " (type=%u, lower=%u, node=0x%x, port=%u, key=%u)\n",
+		       " (type=%u, lower=%u, node=%u, port=%u, key=%u)\n",
 		       p->sr.type, p->sr.lower, p->sk.node, p->sk.ref, p->key);
 	}
 
@@ -309,8 +311,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 			return true;
 		}
 	} else if (dtype == WITHDRAWAL) {
-		p = tipc_nametbl_remove_publ(net, ua.sr.type, ua.sr.lower,
-					     ua.sr.upper, node, key);
+		p = tipc_nametbl_remove_publ(net, &ua, &sk, key);
 		if (p) {
 			tipc_node_unsubscribe(net, &p->binding_node, node);
 			kfree_rcu(p, rcu);
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 146c478143a6..5676b8d4f08f 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -366,16 +366,18 @@ static bool tipc_service_insert_publ(struct net *net,
 
 /**
  * tipc_service_remove_publ - remove a publication from a service
- * @sr: service_range to remove publication from
- * @node: target node
+ * @r: service_range to remove publication from
+ * @sk: address publishing socket
  * @key: target publication key
  */
-static struct publication *tipc_service_remove_publ(struct service_range *sr,
-						    u32 node, u32 key)
+static struct publication *tipc_service_remove_publ(struct service_range *r,
+						    struct tipc_socket_addr *sk,
+						    u32 key)
 {
 	struct publication *p;
+	u32 node = sk->node;
 
-	list_for_each_entry(p, &sr->all_publ, all_publ) {
+	list_for_each_entry(p, &r->all_publ, all_publ) {
 		if (p->key != key || (node && node != p->sk.node))
 			continue;
 		list_del(&p->all_publ);
@@ -493,16 +495,20 @@ struct publication *tipc_nametbl_insert_publ(struct net *net,
 	return NULL;
 }
 
-struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
-					     u32 lower, u32 upper,
-					     u32 node, u32 key)
+struct publication *tipc_nametbl_remove_publ(struct net *net,
+					     struct tipc_uaddr *ua,
+					     struct tipc_socket_addr *sk,
+					     u32 key)
 {
-	struct tipc_service *sc = tipc_service_find(net, type);
 	struct tipc_subscription *sub, *tmp;
-	struct service_range *sr = NULL;
 	struct publication *p = NULL;
+	struct service_range *sr;
+	struct tipc_service *sc;
+	u32 upper = ua->sr.upper;
+	u32 lower = ua->sr.lower;
 	bool last;
 
+	sc = tipc_service_find(net, ua->sr.type);
 	if (!sc)
 		return NULL;
 
@@ -510,7 +516,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
 	sr = tipc_service_find_range(sc, lower, upper);
 	if (!sr)
 		goto exit;
-	p = tipc_service_remove_publ(sr, node, key);
+	p = tipc_service_remove_publ(sr, sk, key);
 	if (!p)
 		goto exit;
 
@@ -518,7 +524,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
 	last = list_empty(&sr->all_publ);
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
 		tipc_sub_report_overlap(sub, lower, upper, TIPC_WITHDRAWN,
-					p->sk.ref, node, p->scope, last);
+					sk->ref, sk->node, ua->scope, last);
 	}
 
 	/* Remove service range item if this was its last publication */
@@ -768,24 +774,22 @@ struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 /**
  * tipc_nametbl_withdraw - withdraw a service binding
  * @net: network namespace
- * @type: service type
- * @lower: service range lower bound
- * @upper: service range upper bound
+ * @ua: service address/range being unbound
+ * @sk: address of the socket being unbound from
  * @key: target publication key
  */
-int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower,
-			  u32 upper, u32 key)
+void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
+			   struct tipc_socket_addr *sk, u32 key)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct tipc_net *tn = tipc_net(net);
-	u32 self = tipc_own_addr(net);
 	struct sk_buff *skb = NULL;
 	struct publication *p;
 	u32 rc_dests;
 
 	spin_lock_bh(&tn->nametbl_lock);
 
-	p = tipc_nametbl_remove_publ(net, type, lower, upper, self, key);
+	p = tipc_nametbl_remove_publ(net, ua, sk, key);
 	if (p) {
 		nt->local_publ_count--;
 		skb = tipc_named_withdraw(net, p);
@@ -793,16 +797,13 @@ int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower,
 		kfree_rcu(p, rcu);
 	} else {
 		pr_err("Failed to remove local publication {%u,%u,%u}/%u\n",
-		       type, lower, upper, key);
+		       ua->sr.type, ua->sr.lower, ua->sr.upper, key);
 	}
 	rc_dests = nt->rc_dests;
 	spin_unlock_bh(&tn->nametbl_lock);
 
-	if (skb) {
+	if (skb)
 		tipc_node_broadcast(net, skb, rc_dests);
-		return 1;
-	}
-	return 0;
 }
 
 /**
@@ -900,7 +901,7 @@ static void tipc_service_delete(struct net *net, struct tipc_service *sc)
 	spin_lock_bh(&sc->lock);
 	rbtree_postorder_for_each_entry_safe(sr, tmpr, &sc->ranges, tree_node) {
 		list_for_each_entry_safe(p, tmp, &sr->all_publ, all_publ) {
-			tipc_service_remove_publ(sr, p->sk.node, p->key);
+			tipc_service_remove_publ(sr, &p->sk, p->key);
 			kfree_rcu(p, rcu);
 		}
 		rb_erase_augmented(&sr->tree_node, &sc->ranges, &sr_callbacks);
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index c8b026e56e81..5a7c83d22ef9 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -123,15 +123,16 @@ bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 domain,
 			 bool all);
 struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 					 struct tipc_socket_addr *sk, u32 key);
-int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower, u32 upper,
-			  u32 key);
+void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
+			   struct tipc_socket_addr *sk, u32 key);
 struct publication *tipc_nametbl_insert_publ(struct net *net,
 					     struct tipc_uaddr *ua,
 					     struct tipc_socket_addr *sk,
 					     u32 key);
-struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
-					     u32 lower, u32 upper,
-					     u32 node, u32 key);
+struct publication *tipc_nametbl_remove_publ(struct net *net,
+					     struct tipc_uaddr *ua,
+					     struct tipc_socket_addr *sk,
+					     u32 key);
 bool tipc_nametbl_subscribe(struct tipc_subscription *s);
 void tipc_nametbl_unsubscribe(struct tipc_subscription *s);
 int tipc_nametbl_init(struct net *net);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index e24cdc13335d..0daf3be11ed1 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -434,8 +434,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
 		tipc_mon_peer_down(net, n->addr, bearer_id);
-		tipc_nametbl_withdraw(net, TIPC_LINK_STATE, n->addr,
-				      n->addr, n->link_id);
+		tipc_nametbl_withdraw(net, &ua, &sk, n->link_id);
 	}
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 94847252a7b7..7f5722d3b3d0 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -152,8 +152,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		       bool kern);
 static void tipc_sk_timeout(struct timer_list *t);
 static int tipc_sk_publish(struct tipc_sock *tsk, struct tipc_uaddr *ua);
-static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
-			    struct tipc_service_range const *seq);
+static int tipc_sk_withdraw(struct tipc_sock *tsk, struct tipc_uaddr *ua);
 static int tipc_sk_leave(struct tipc_sock *tsk);
 static struct tipc_sock *tipc_sk_lookup(struct net *net, u32 portid);
 static int tipc_sk_insert(struct tipc_sock *tsk);
@@ -643,7 +642,7 @@ static int tipc_release(struct socket *sock)
 	__tipc_shutdown(sock, TIPC_ERR_NO_PORT);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 	tipc_sk_leave(tsk);
-	tipc_sk_withdraw(tsk, 0, NULL);
+	tipc_sk_withdraw(tsk, NULL);
 	__skb_queue_purge(&tsk->mc_method.deferredq);
 	sk_stop_timer(sk, &sk->sk_timer);
 	tipc_sk_remove(tsk);
@@ -681,7 +680,7 @@ static int __tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 	bool unbind = false;
 
 	if (unlikely(!alen))
-		return tipc_sk_withdraw(tsk, 0, NULL);
+		return tipc_sk_withdraw(tsk, NULL);
 
 	if (ua->addrtype == TIPC_SERVICE_ADDR) {
 		ua->addrtype = TIPC_SERVICE_RANGE;
@@ -699,7 +698,7 @@ static int __tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 		return -EACCES;
 
 	if (unbind)
-		return tipc_sk_withdraw(tsk, ua->scope, &ua->sr);
+		return tipc_sk_withdraw(tsk, ua);
 	return tipc_sk_publish(tsk, ua);
 }
 
@@ -2923,38 +2922,37 @@ static int tipc_sk_publish(struct tipc_sock *tsk, struct tipc_uaddr *ua)
 	return 0;
 }
 
-static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
-			    struct tipc_service_range const *seq)
+static int tipc_sk_withdraw(struct tipc_sock *tsk, struct tipc_uaddr *ua)
 {
 	struct net *net = sock_net(&tsk->sk);
-	struct publication *p;
-	struct publication *safe;
+	struct publication *safe, *p;
+	struct tipc_uaddr _ua;
 	int rc = -EINVAL;
 
-	if (scope != TIPC_NODE_SCOPE)
-		scope = TIPC_CLUSTER_SCOPE;
-
 	list_for_each_entry_safe(p, safe, &tsk->publications, binding_sock) {
-		if (seq) {
-			if (p->scope != scope)
-				continue;
-			if (p->sr.type != seq->type)
-				continue;
-			if (p->sr.lower != seq->lower)
-				continue;
-			if (p->sr.upper != seq->upper)
-				break;
-			tipc_nametbl_withdraw(net, p->sr.type, p->sr.lower,
-					      p->sr.upper, p->key);
-			rc = 0;
-			break;
+		if (!ua) {
+			tipc_uaddr(&_ua, TIPC_SERVICE_RANGE, p->scope,
+				   p->sr.type, p->sr.lower, p->sr.upper);
+			tipc_nametbl_withdraw(net, &_ua, &p->sk, p->key);
+			continue;
 		}
-		tipc_nametbl_withdraw(net, p->sr.type, p->sr.lower,
-				      p->sr.upper, p->key);
+		/* Unbind specific publication */
+		if (p->scope != ua->scope)
+			continue;
+		if (p->sr.type != ua->sr.type)
+			continue;
+		if (p->sr.lower != ua->sr.lower)
+			continue;
+		if (p->sr.upper != ua->sr.upper)
+			break;
+		tipc_nametbl_withdraw(net, ua, &p->sk, p->key);
 		rc = 0;
+		break;
 	}
-	if (list_empty(&tsk->publications))
+	if (list_empty(&tsk->publications)) {
 		tsk->published = 0;
+		rc = 0;
+	}
 	return rc;
 }
 
@@ -3109,15 +3107,17 @@ static int tipc_sk_leave(struct tipc_sock *tsk)
 {
 	struct net *net = sock_net(&tsk->sk);
 	struct tipc_group *grp = tsk->group;
-	struct tipc_service_range seq;
+	struct tipc_uaddr ua;
 	int scope;
 
 	if (!grp)
 		return -EINVAL;
-	tipc_group_self(grp, &seq, &scope);
+	ua.addrtype = TIPC_SERVICE_RANGE;
+	tipc_group_self(grp, &ua.sr, &scope);
+	ua.scope = scope;
 	tipc_group_delete(net, grp);
 	tsk->group = NULL;
-	tipc_sk_withdraw(tsk, scope, &seq);
+	tipc_sk_withdraw(tsk, &ua);
 	return 0;
 }
 
-- 
2.29.2

