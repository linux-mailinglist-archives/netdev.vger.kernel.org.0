Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E2733E69A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhCQCHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhCQCGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4h+o/wYT3Cd/JaKXrCLf8dVUA7XfpS35FI8JTQpUSo=;
        b=SUl5jUpLfht1VV/s0Gpp7AbW3PwAgqzllV8TdIp0rj2ak24neUfaVH5s1DjQySVg+vYu4i
        D8tM02lkk72arLWLflpXvQ7o7jNlLK4Idkv5/sNX9qneZs2dMxV5+OFcI7Uij+areHjwGL
        EAurBjzMsJTyX/cNn1j2gcm+vu6tGUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-0dn_u41SMeyLK6ejcuniXg-1; Tue, 16 Mar 2021 22:06:47 -0400
X-MC-Unique: 0dn_u41SMeyLK6ejcuniXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 555FA760C0;
        Wed, 17 Mar 2021 02:06:46 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A0C95C1A1;
        Wed, 17 Mar 2021 02:06:45 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 13/16] tipc: simplify signature of tipc_find_service()
Date:   Tue, 16 Mar 2021 22:06:20 -0400
Message-Id: <20210317020623.1258298-14-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We reduce the signature of tipc_find_service() and
tipc_create_service(). The reason for doing this might not
be obvious, but we plan to let struct tipc_uaddr contain
information that is relevant for these functions in a later
commit.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 62 ++++++++++++++++++++++++++-----------------
 net/tipc/name_table.h |  2 +-
 net/tipc/socket.c     |  2 +-
 3 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index f6a1b78a807e..73d9f49662e4 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -249,25 +249,30 @@ static struct publication *tipc_publ_create(struct tipc_uaddr *ua,
 
 /**
  * tipc_service_create - create a service structure for the specified 'type'
- * @type: service type
- * @hd: name_table services list
+ * @net: network namespace
+ * @ua: address representing the service to be bound
  *
  * Allocates a single range structure and sets it to all 0's.
  */
-static struct tipc_service *tipc_service_create(u32 type, struct hlist_head *hd)
+static struct tipc_service *tipc_service_create(struct net *net,
+						struct tipc_uaddr *ua)
 {
-	struct tipc_service *service = kzalloc(sizeof(*service), GFP_ATOMIC);
+	struct name_table *nt = tipc_name_table(net);
+	struct tipc_service *service;
+	struct hlist_head *hd;
 
+	service = kzalloc(sizeof(*service), GFP_ATOMIC);
 	if (!service) {
 		pr_warn("Service creation failed, no memory\n");
 		return NULL;
 	}
 
 	spin_lock_init(&service->lock);
-	service->type = type;
+	service->type = ua->sr.type;
 	service->ranges = RB_ROOT;
 	INIT_HLIST_NODE(&service->service_list);
 	INIT_LIST_HEAD(&service->subscriptions);
+	hd = &nt->services[hash(ua->sr.type)];
 	hlist_add_head_rcu(&service->service_list, hd);
 	return service;
 }
@@ -455,15 +460,16 @@ static void tipc_service_subscribe(struct tipc_service *service,
 	}
 }
 
-static struct tipc_service *tipc_service_find(struct net *net, u32 type)
+static struct tipc_service *tipc_service_find(struct net *net,
+					      struct tipc_uaddr *ua)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct hlist_head *service_head;
 	struct tipc_service *service;
 
-	service_head = &nt->services[hash(type)];
+	service_head = &nt->services[hash(ua->sr.type)];
 	hlist_for_each_entry_rcu(service, service_head, service_list) {
-		if (service->type == type)
+		if (service->type == ua->sr.type)
 			return service;
 	}
 	return NULL;
@@ -474,7 +480,6 @@ struct publication *tipc_nametbl_insert_publ(struct net *net,
 					     struct tipc_socket_addr *sk,
 					     u32 key)
 {
-	struct name_table *nt = tipc_name_table(net);
 	struct tipc_service *sc;
 	struct publication *p;
 	u32 type = ua->sr.type;
@@ -488,9 +493,9 @@ struct publication *tipc_nametbl_insert_publ(struct net *net,
 			 type, ua->sr.lower, ua->sr.upper, sk->node);
 		return NULL;
 	}
-	sc = tipc_service_find(net, type);
+	sc = tipc_service_find(net, ua);
 	if (!sc)
-		sc = tipc_service_create(type, &nt->services[hash(type)]);
+		sc = tipc_service_create(net, ua);
 	if (sc && tipc_service_insert_publ(net, sc, p))
 		return p;
 	kfree(p);
@@ -510,7 +515,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 	u32 lower = ua->sr.lower;
 	bool last;
 
-	sc = tipc_service_find(net, ua->sr.type);
+	sc = tipc_service_find(net, ua);
 	if (!sc)
 		return NULL;
 
@@ -582,7 +587,7 @@ bool tipc_nametbl_lookup_anycast(struct net *net,
 		return true;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, ua->sr.type);
+	sc = tipc_service_find(net, ua);
 	if (unlikely(!sc))
 		goto exit;
 
@@ -635,7 +640,7 @@ bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
 
 	*dstcnt = 0;
 	rcu_read_lock();
-	sc = tipc_service_find(net, ua->sa.type);
+	sc = tipc_service_find(net, ua);
 	if (unlikely(!sc))
 		goto exit;
 
@@ -679,7 +684,7 @@ void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
 	u32 scope = ua->scope;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, ua->sr.type);
+	sc = tipc_service_find(net, ua);
 	if (!sc)
 		goto exit;
 
@@ -708,7 +713,7 @@ void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
 	struct publication *p;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, ua->sr.type);
+	sc = tipc_service_find(net, ua);
 	if (!sc)
 		goto exit;
 
@@ -726,7 +731,7 @@ void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
 /* tipc_nametbl_build_group - build list of communication group members
  */
 void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
-			      u32 type, u32 scope)
+			      struct tipc_uaddr *ua)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
@@ -734,7 +739,7 @@ void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 	struct rb_node *n;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, type);
+	sc = tipc_service_find(net, ua);
 	if (!sc)
 		goto exit;
 
@@ -742,9 +747,10 @@ void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 	for (n = rb_first(&sc->ranges); n; n = rb_next(n)) {
 		sr = container_of(n, struct service_range, tree_node);
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
-			if (p->scope != scope)
+			if (p->scope != ua->scope)
 				continue;
-			tipc_group_add_member(grp, p->sk.node, p->sk.ref, p->sr.lower);
+			tipc_group_add_member(grp, p->sk.node, p->sk.ref,
+					      p->sr.lower);
 		}
 	}
 	spin_unlock_bh(&sc->lock);
@@ -826,17 +832,18 @@ void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
  */
 bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 {
-	struct name_table *nt = tipc_name_table(sub->net);
 	struct tipc_net *tn = tipc_net(sub->net);
 	struct tipc_subscr *s = &sub->evt.s;
 	u32 type = tipc_sub_read(s, seq.type);
 	struct tipc_service *sc;
+	struct tipc_uaddr ua;
 	bool res = true;
 
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type, 0, 0);
 	spin_lock_bh(&tn->nametbl_lock);
-	sc = tipc_service_find(sub->net, type);
+	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
-		sc = tipc_service_create(type, &nt->services[hash(type)]);
+		sc = tipc_service_create(sub->net, &ua);
 	if (sc) {
 		spin_lock_bh(&sc->lock);
 		tipc_service_subscribe(sc, sub);
@@ -861,9 +868,11 @@ void tipc_nametbl_unsubscribe(struct tipc_subscription *sub)
 	struct tipc_subscr *s = &sub->evt.s;
 	u32 type = tipc_sub_read(s, seq.type);
 	struct tipc_service *sc;
+	struct tipc_uaddr ua;
 
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type, 0, 0);
 	spin_lock_bh(&tn->nametbl_lock);
-	sc = tipc_service_find(sub->net, type);
+	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
 		goto exit;
 
@@ -1052,6 +1061,7 @@ static int tipc_nl_service_list(struct net *net, struct tipc_nl_msg *msg,
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_service *service = NULL;
 	struct hlist_head *head;
+	struct tipc_uaddr ua;
 	int err;
 	int i;
 
@@ -1065,7 +1075,9 @@ static int tipc_nl_service_list(struct net *net, struct tipc_nl_msg *msg,
 
 		if (*last_type ||
 		    (!i && *last_key && (*last_lower == *last_key))) {
-			service = tipc_service_find(net, *last_type);
+			tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
+				   *last_type, *last_lower, *last_lower);
+			service = tipc_service_find(net, &ua);
 			if (!service)
 				return -EPIPE;
 		} else {
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index b20b694c1284..c7c9a3ddd420 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -120,7 +120,7 @@ bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
 			       struct list_head *dsts, int *dstcnt,
 			       u32 exclude, bool mcast);
 void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
-			      u32 type, u32 domain);
+			      struct tipc_uaddr *ua);
 struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 					 struct tipc_socket_addr *sk, u32 key);
 void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index a7f86f22c03a..117a472a8e61 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3075,9 +3075,9 @@ static int tipc_sk_join(struct tipc_sock *tsk, struct tipc_group_req *mreq)
 	msg_set_lookup_scope(hdr, mreq->scope);
 	msg_set_nametype(hdr, mreq->type);
 	msg_set_dest_droppable(hdr, true);
-	tipc_nametbl_build_group(net, grp, mreq->type, mreq->scope);
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, mreq->scope,
 		   mreq->type, mreq->instance, mreq->instance);
+	tipc_nametbl_build_group(net, grp, &ua);
 	rc = tipc_sk_publish(tsk, &ua);
 	if (rc) {
 		tipc_group_delete(net, grp);
-- 
2.29.2

