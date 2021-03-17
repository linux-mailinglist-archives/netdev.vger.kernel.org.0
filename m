Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF75B33E692
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhCQCHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhCQCGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yhhq1apYPobKxSMx2hsuF3HG+/ahiA6j/U8O/6b3/00=;
        b=HQNbo64M/IRt7nJ+oYZlZbmFgzTEkE3XIJK2+4WjjwnpH8O4+PmdX+eBxvjiwgVXOR+Spy
        TdPIQjUifZYoEP8gHgNeai6PUdG18ZzlC8qb0khVm+T8bVFNiaarC/QM5C85oGBW3RAvBw
        B+a+VY8Pj5pbVSPEPFZkZiAEs7tgphk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-KLbQTx89PBK8ypwvQ6c35g-1; Tue, 16 Mar 2021 22:06:36 -0400
X-MC-Unique: KLbQTx89PBK8ypwvQ6c35g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1794B760C4;
        Wed, 17 Mar 2021 02:06:35 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A548B5C1A1;
        Wed, 17 Mar 2021 02:06:33 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 05/16] tipc: simplify call signatures for publication creation
Date:   Tue, 16 Mar 2021 22:06:12 -0400
Message-Id: <20210317020623.1258298-6-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We simplify the call signatures for tipc_nametbl_insert_publ() and
tipc_publ_create() so that fewer parameters are passed around.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_distr.c | 23 ++++++++++++-----------
 net/tipc/name_table.c | 42 +++++++++++++++++-------------------------
 net/tipc/name_table.h |  9 +++++----
 3 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 1070b04d1126..727f8c54df6b 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -293,30 +293,31 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 				u32 node, u32 dtype)
 {
 	struct publication *p = NULL;
-	u32 lower = ntohl(i->lower);
-	u32 upper = ntohl(i->upper);
-	u32 type = ntohl(i->type);
-	u32 port = ntohl(i->port);
+	struct tipc_socket_addr sk;
+	struct tipc_uaddr ua;
 	u32 key = ntohl(i->key);
 
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_CLUSTER_SCOPE,
+		   ntohl(i->type), ntohl(i->lower), ntohl(i->upper));
+	sk.ref = ntohl(i->port);
+	sk.node = node;
+
 	if (dtype == PUBLICATION) {
-		p = tipc_nametbl_insert_publ(net, type, lower, upper,
-					     TIPC_CLUSTER_SCOPE, node,
-					     port, key);
+		p = tipc_nametbl_insert_publ(net, &ua, &sk, key);
 		if (p) {
 			tipc_node_subscribe(net, &p->binding_node, node);
 			return true;
 		}
 	} else if (dtype == WITHDRAWAL) {
-		p = tipc_nametbl_remove_publ(net, type, lower,
-					     upper, node, key);
+		p = tipc_nametbl_remove_publ(net, ua.sr.type, ua.sr.lower,
+					     ua.sr.upper, node, key);
 		if (p) {
 			tipc_node_unsubscribe(net, &p->binding_node, node);
 			kfree_rcu(p, rcu);
 			return true;
 		}
-		pr_warn_ratelimited("Failed to remove binding %u,%u from %x\n",
-				    type, lower, node);
+		pr_warn_ratelimited("Failed to remove binding %u,%u from %u\n",
+				    ua.sr.type, ua.sr.lower, node);
 	} else {
 		pr_warn("Unrecognized name table message received\n");
 	}
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 7b309fdd0090..146c478143a6 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -222,16 +222,12 @@ static int hash(int x)
 
 /**
  * tipc_publ_create - create a publication structure
- * @type: name sequence type
- * @lower: name sequence lower bound
- * @upper: name sequence upper bound
- * @scope: publication scope
- * @node: network address of publishing socket
- * @port: publishing port
+ * @ua: the service range the user is binding to
+ * @sk: the address of the socket that is bound
  * @key: publication key
  */
-static struct publication *tipc_publ_create(u32 type, u32 lower, u32 upper,
-					    u32 scope, u32 node, u32 port,
+static struct publication *tipc_publ_create(struct tipc_uaddr *ua,
+					    struct tipc_socket_addr *sk,
 					    u32 key)
 {
 	struct publication *p = kzalloc(sizeof(*p), GFP_ATOMIC);
@@ -239,12 +235,9 @@ static struct publication *tipc_publ_create(u32 type, u32 lower, u32 upper,
 	if (!p)
 		return NULL;
 
-	p->sr.type = type;
-	p->sr.lower = lower;
-	p->sr.upper = upper;
-	p->scope = scope;
-	p->sk.node = node;
-	p->sk.ref = port;
+	p->sr = ua->sr;
+	p->sk = *sk;
+	p->scope = ua->scope;
 	p->key = key;
 	INIT_LIST_HEAD(&p->binding_sock);
 	INIT_LIST_HEAD(&p->binding_node);
@@ -472,22 +465,23 @@ static struct tipc_service *tipc_service_find(struct net *net, u32 type)
 	return NULL;
 };
 
-struct publication *tipc_nametbl_insert_publ(struct net *net, u32 type,
-					     u32 lower, u32 upper,
-					     u32 scope, u32 node,
-					     u32 port, u32 key)
+struct publication *tipc_nametbl_insert_publ(struct net *net,
+					     struct tipc_uaddr *ua,
+					     struct tipc_socket_addr *sk,
+					     u32 key)
 {
 	struct name_table *nt = tipc_name_table(net);
 	struct tipc_service *sc;
 	struct publication *p;
+	u32 type = ua->sr.type;
 
-	p = tipc_publ_create(type, lower, upper, scope, node, port, key);
+	p = tipc_publ_create(ua, sk, key);
 	if (!p)
 		return NULL;
 
-	if (scope > TIPC_NODE_SCOPE || lower > upper) {
-		pr_debug("Failed to bind illegal {%u,%u,%u} with scope %u\n",
-			 type, lower, upper, scope);
+	if (ua->sr.lower > ua->sr.upper) {
+		pr_debug("Failed to bind illegal {%u,%u,%u} from node %u\n",
+			 type, ua->sr.lower, ua->sr.upper, sk->node);
 		return NULL;
 	}
 	sc = tipc_service_find(net, type);
@@ -756,9 +750,7 @@ struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 		goto exit;
 	}
 
-	p = tipc_nametbl_insert_publ(net, ua->sr.type, ua->sr.lower,
-				     ua->sr.upper, ua->scope,
-				     sk->node, sk->ref, key);
+	p = tipc_nametbl_insert_publ(net, ua, sk, key);
 	if (p) {
 		nt->local_publ_count++;
 		skb = tipc_named_publish(net, p);
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 47a8c266bcc8..c8b026e56e81 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -75,7 +75,7 @@ struct tipc_uaddr;
 struct publication {
 	struct tipc_service_range sr;
 	struct tipc_socket_addr sk;
-	u32 scope;
+	u16 scope;
 	u32 key;
 	u32 id;
 	struct list_head binding_node;
@@ -125,9 +125,10 @@ struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 					 struct tipc_socket_addr *sk, u32 key);
 int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower, u32 upper,
 			  u32 key);
-struct publication *tipc_nametbl_insert_publ(struct net *net, u32 type,
-					     u32 lower, u32 upper, u32 scope,
-					     u32 node, u32 ref, u32 key);
+struct publication *tipc_nametbl_insert_publ(struct net *net,
+					     struct tipc_uaddr *ua,
+					     struct tipc_socket_addr *sk,
+					     u32 key);
 struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
 					     u32 lower, u32 upper,
 					     u32 node, u32 key);
-- 
2.29.2

