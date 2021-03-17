Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B9133E691
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCQCHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229947AbhCQCGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vupSkyPy2T+g1CP9pSXy9xKo5maKdIUC0V0+fT6LUlA=;
        b=XjP/bxe+R8NsKKGGkXMbprkxMcVgcfBvtaF/5NY39lPwpFWcmr4rAtncgklIMRIh+k+H5f
        9a6YHYWpKs9Z1ELCemRH3N5z8pBmxja9JYNwbNYTAQ8t47Nvq9MRkQecLF12slZiir1Ayi
        /jpNDJaO+qbufH/+/HMY88W4SiMn/2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-P9_29X8EOIOhi_4Z7Znyqw-1; Tue, 16 Mar 2021 22:06:35 -0400
X-MC-Unique: P9_29X8EOIOhi_4Z7Znyqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F373801817;
        Wed, 17 Mar 2021 02:06:33 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D9045C1A1;
        Wed, 17 Mar 2021 02:06:32 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 04/16] tipc: simplify signature of tipc_namtbl_publish()
Date:   Tue, 16 Mar 2021 22:06:11 -0400
Message-Id: <20210317020623.1258298-5-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

Using the new address structure tipc_uaddr, we simplify the signature
of function tipc_sk_publish() and tipc_namtbl_publish() so that fewer
parameters need to be passed around.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 10 +++---
 net/tipc/name_table.h |  6 ++--
 net/tipc/net.c        |  8 +++--
 net/tipc/node.c       | 29 ++++++++---------
 net/tipc/socket.c     | 73 +++++++++++++++++++++++--------------------
 5 files changed, 68 insertions(+), 58 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index c37cef09b54c..7b309fdd0090 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -740,9 +740,8 @@ void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 
 /* tipc_nametbl_publish - add service binding to name table
  */
-struct publication *tipc_nametbl_publish(struct net *net, u32 type, u32 lower,
-					 u32 upper, u32 scope, u32 port,
-					 u32 key)
+struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
+					 struct tipc_socket_addr *sk, u32 key)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct tipc_net *tn = tipc_net(net);
@@ -757,8 +756,9 @@ struct publication *tipc_nametbl_publish(struct net *net, u32 type, u32 lower,
 		goto exit;
 	}
 
-	p = tipc_nametbl_insert_publ(net, type, lower, upper, scope,
-				     tipc_own_addr(net), port, key);
+	p = tipc_nametbl_insert_publ(net, ua->sr.type, ua->sr.lower,
+				     ua->sr.upper, ua->scope,
+				     sk->node, sk->ref, key);
 	if (p) {
 		nt->local_publ_count++;
 		skb = tipc_named_publish(net, p);
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index d9ad119f966b..47a8c266bcc8 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -42,6 +42,7 @@ struct tipc_subscription;
 struct tipc_plist;
 struct tipc_nlist;
 struct tipc_group;
+struct tipc_uaddr;
 
 /*
  * TIPC name types reserved for internal TIPC use (both current and planned)
@@ -120,9 +121,8 @@ void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
 bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 domain,
 			 struct list_head *dsts, int *dstcnt, u32 exclude,
 			 bool all);
-struct publication *tipc_nametbl_publish(struct net *net, u32 type, u32 lower,
-					 u32 upper, u32 scope, u32 port,
-					 u32 key);
+struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
+					 struct tipc_socket_addr *sk, u32 key);
 int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower, u32 upper,
 			  u32 key);
 struct publication *tipc_nametbl_insert_publ(struct net *net, u32 type,
diff --git a/net/tipc/net.c b/net/tipc/net.c
index a129f661bee3..3f927949bb23 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -125,6 +125,11 @@ int tipc_net_init(struct net *net, u8 *node_id, u32 addr)
 static void tipc_net_finalize(struct net *net, u32 addr)
 {
 	struct tipc_net *tn = tipc_net(net);
+	struct tipc_socket_addr sk = {0, addr};
+	struct tipc_uaddr ua;
+
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_CLUSTER_SCOPE,
+		   TIPC_NODE_STATE, addr, addr);
 
 	if (cmpxchg(&tn->node_addr, 0, addr))
 		return;
@@ -132,8 +137,7 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
 	tipc_mon_reinit_self(net);
-	tipc_nametbl_publish(net, TIPC_NODE_STATE, addr, addr,
-			     TIPC_CLUSTER_SCOPE, 0, addr);
+	tipc_nametbl_publish(net, &ua, &sk, addr);
 }
 
 void tipc_net_finalize_work(struct work_struct *work)
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 9c95ef4b6326..e24cdc13335d 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -398,21 +398,23 @@ static void tipc_node_write_unlock_fast(struct tipc_node *n)
 static void tipc_node_write_unlock(struct tipc_node *n)
 	__releases(n->lock)
 {
+	struct tipc_socket_addr sk;
 	struct net *net = n->net;
-	u32 addr = 0;
 	u32 flags = n->action_flags;
-	u32 link_id = 0;
-	u32 bearer_id;
 	struct list_head *publ_list;
+	struct tipc_uaddr ua;
+	u32 bearer_id;
 
 	if (likely(!flags)) {
 		write_unlock_bh(&n->lock);
 		return;
 	}
 
-	addr = n->addr;
-	link_id = n->link_id;
-	bearer_id = link_id & 0xffff;
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
+		   TIPC_LINK_STATE, n->addr, n->addr);
+	sk.ref = n->link_id;
+	sk.node = n->addr;
+	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 
 	n->action_flags &= ~(TIPC_NOTIFY_NODE_DOWN | TIPC_NOTIFY_NODE_UP |
@@ -421,20 +423,19 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, addr, n->capabilities);
+		tipc_publ_notify(net, publ_list, n->addr, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, addr, n->capabilities);
+		tipc_named_node_up(net, n->addr, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, addr, bearer_id);
-		tipc_nametbl_publish(net, TIPC_LINK_STATE, addr, addr,
-				     TIPC_NODE_SCOPE, link_id, link_id);
+		tipc_mon_peer_up(net, n->addr, bearer_id);
+		tipc_nametbl_publish(net, &ua, &sk, n->link_id);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, addr, bearer_id);
-		tipc_nametbl_withdraw(net, TIPC_LINK_STATE, addr,
-				      addr, link_id);
+		tipc_mon_peer_down(net, n->addr, bearer_id);
+		tipc_nametbl_withdraw(net, TIPC_LINK_STATE, n->addr,
+				      n->addr, n->link_id);
 	}
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index fe522d49f747..94847252a7b7 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -111,7 +111,6 @@ struct tipc_sock {
 	struct sock sk;
 	u32 conn_type;
 	u32 conn_instance;
-	int published;
 	u32 max_pkt;
 	u32 maxnagle;
 	u32 portid;
@@ -141,6 +140,7 @@ struct tipc_sock {
 	bool expect_ack;
 	bool nodelay;
 	bool group_is_open;
+	bool published;
 };
 
 static int tipc_sk_backlog_rcv(struct sock *sk, struct sk_buff *skb);
@@ -151,8 +151,7 @@ static int tipc_release(struct socket *sock);
 static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		       bool kern);
 static void tipc_sk_timeout(struct timer_list *t);
-static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
-			   struct tipc_service_range const *seq);
+static int tipc_sk_publish(struct tipc_sock *tsk, struct tipc_uaddr *ua);
 static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
 			    struct tipc_service_range const *seq);
 static int tipc_sk_leave(struct tipc_sock *tsk);
@@ -677,22 +676,31 @@ static int tipc_release(struct socket *sock)
  */
 static int __tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 {
-	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)skaddr;
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)skaddr;
 	struct tipc_sock *tsk = tipc_sk(sock->sk);
+	bool unbind = false;
 
 	if (unlikely(!alen))
 		return tipc_sk_withdraw(tsk, 0, NULL);
 
-	if (addr->addrtype == TIPC_SERVICE_ADDR)
-		addr->addr.nameseq.upper = addr->addr.nameseq.lower;
+	if (ua->addrtype == TIPC_SERVICE_ADDR) {
+		ua->addrtype = TIPC_SERVICE_RANGE;
+		ua->sr.upper = ua->sr.lower;
+	}
+	if (ua->scope < 0) {
+		unbind = true;
+		ua->scope = -ua->scope;
+	}
+	/* Users may still use deprecated TIPC_ZONE_SCOPE */
+	if (ua->scope != TIPC_NODE_SCOPE)
+		ua->scope = TIPC_CLUSTER_SCOPE;
 
 	if (tsk->group)
 		return -EACCES;
 
-	if (addr->scope >= 0)
-		return tipc_sk_publish(tsk, addr->scope, &addr->addr.nameseq);
-	else
-		return tipc_sk_withdraw(tsk, -addr->scope, &addr->addr.nameseq);
+	if (unbind)
+		return tipc_sk_withdraw(tsk, ua->scope, &ua->sr);
+	return tipc_sk_publish(tsk, ua);
 }
 
 int tipc_sk_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
@@ -707,18 +715,17 @@ int tipc_sk_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 
 static int tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 {
-	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)skaddr;
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)skaddr;
+	u32 atype = ua->addrtype;
 
 	if (alen) {
-		if (alen < sizeof(struct sockaddr_tipc))
+		if (!tipc_uaddr_valid(ua, alen))
 			return -EINVAL;
-		if (addr->family != AF_TIPC)
+		if (atype == TIPC_SOCKET_ADDR)
 			return -EAFNOSUPPORT;
-		if (addr->addrtype > TIPC_SERVICE_ADDR)
-			return -EAFNOSUPPORT;
-		if (addr->addr.nameseq.type < TIPC_RESERVED_TYPES) {
+		if (ua->sr.type < TIPC_RESERVED_TYPES) {
 			pr_warn_once("Can't bind to reserved service type %u\n",
-				     addr->addr.nameseq.type);
+				     ua->sr.type);
 			return -EACCES;
 		}
 	}
@@ -2891,31 +2898,28 @@ static void tipc_sk_timeout(struct timer_list *t)
 	sock_put(sk);
 }
 
-static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
-			   struct tipc_service_range const *seq)
+static int tipc_sk_publish(struct tipc_sock *tsk, struct tipc_uaddr *ua)
 {
 	struct sock *sk = &tsk->sk;
 	struct net *net = sock_net(sk);
-	struct publication *publ;
+	struct tipc_socket_addr skaddr;
+	struct publication *p;
 	u32 key;
 
-	if (scope != TIPC_NODE_SCOPE)
-		scope = TIPC_CLUSTER_SCOPE;
-
 	if (tipc_sk_connected(sk))
 		return -EINVAL;
 	key = tsk->portid + tsk->pub_count + 1;
 	if (key == tsk->portid)
 		return -EADDRINUSE;
-
-	publ = tipc_nametbl_publish(net, seq->type, seq->lower, seq->upper,
-				    scope, tsk->portid, key);
-	if (unlikely(!publ))
+	skaddr.ref = tsk->portid;
+	skaddr.node = tipc_own_addr(net);
+	p = tipc_nametbl_publish(net, ua, &skaddr, key);
+	if (unlikely(!p))
 		return -EINVAL;
 
-	list_add(&publ->binding_sock, &tsk->publications);
+	list_add(&p->binding_sock, &tsk->publications);
 	tsk->pub_count++;
-	tsk->published = 1;
+	tsk->published = true;
 	return 0;
 }
 
@@ -3067,13 +3071,15 @@ static int tipc_sk_join(struct tipc_sock *tsk, struct tipc_group_req *mreq)
 	struct net *net = sock_net(&tsk->sk);
 	struct tipc_group *grp = tsk->group;
 	struct tipc_msg *hdr = &tsk->phdr;
-	struct tipc_service_range seq;
+	struct tipc_uaddr ua;
 	int rc;
 
 	if (mreq->type < TIPC_RESERVED_TYPES)
 		return -EACCES;
 	if (mreq->scope > TIPC_NODE_SCOPE)
 		return -EINVAL;
+	if (mreq->scope != TIPC_NODE_SCOPE)
+		mreq->scope = TIPC_CLUSTER_SCOPE;
 	if (grp)
 		return -EACCES;
 	grp = tipc_group_create(net, tsk->portid, mreq, &tsk->group_is_open);
@@ -3083,11 +3089,10 @@ static int tipc_sk_join(struct tipc_sock *tsk, struct tipc_group_req *mreq)
 	msg_set_lookup_scope(hdr, mreq->scope);
 	msg_set_nametype(hdr, mreq->type);
 	msg_set_dest_droppable(hdr, true);
-	seq.type = mreq->type;
-	seq.lower = mreq->instance;
-	seq.upper = seq.lower;
 	tipc_nametbl_build_group(net, grp, mreq->type, mreq->scope);
-	rc = tipc_sk_publish(tsk, mreq->scope, &seq);
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, mreq->scope,
+		   mreq->type, mreq->instance, mreq->instance);
+	rc = tipc_sk_publish(tsk, &ua);
 	if (rc) {
 		tipc_group_delete(net, grp);
 		tsk->group = NULL;
-- 
2.29.2

