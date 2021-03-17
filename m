Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822DC33E69B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhCQCHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhCQCG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4O6upttbg4iZg+KjGD+SvOtArfFyZ6zBkvKI8CylINU=;
        b=JIfKLPeZInLF7/Qplmaib/S5F/0Q7+AxTIpKmEsyTt+1UG4bDQbJ5fTBYX2GVdjL/PYgtq
        PTStz+m12MpGfhgT024qQnc8cTinqEAJQicrTESn11zt6xfskZAEZr+Q0IUfYS8PzovMaV
        1HktwYzzKO7fjb+sPutHEdFeujY6T/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-0hNcjm3XPDSMbczK3MY-zQ-1; Tue, 16 Mar 2021 22:06:51 -0400
X-MC-Unique: 0hNcjm3XPDSMbczK3MY-zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E76E3107ACCA;
        Wed, 17 Mar 2021 02:06:49 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C4735C1A1;
        Wed, 17 Mar 2021 02:06:46 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 14/16] tipc: simplify api between binding table and topology server
Date:   Tue, 16 Mar 2021 22:06:21 -0400
Message-Id: <20210317020623.1258298-15-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

The function tipc_report_overlap() is called from the binding table
with numerous parameters taken from an instance of struct publication.
A closer look reveals that it always is safe to send along a pointer
to the instance itself, and hence reduce the call signature. We do
that in this commit.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 21 ++++++---------
 net/tipc/subscr.c     | 59 +++++++++++++++++++++++--------------------
 net/tipc/subscr.h     | 11 +++-----
 3 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 73d9f49662e4..f648feae446f 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -358,9 +358,7 @@ static bool tipc_service_insert_publ(struct net *net,
 
 	/* Any subscriptions waiting for notification?  */
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
-		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper,
-					TIPC_PUBLISHED, p->sk.ref, p->sk.node,
-					p->scope, first);
+		tipc_sub_report_overlap(sub, p, TIPC_PUBLISHED, first);
 	}
 	res = true;
 exit:
@@ -453,9 +451,7 @@ static void tipc_service_subscribe(struct tipc_service *service,
 	/* Sort the publications before reporting */
 	list_sort(NULL, &publ_list, tipc_publ_sort);
 	list_for_each_entry_safe(p, tmp, &publ_list, list) {
-		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper,
-					TIPC_PUBLISHED, p->sk.ref, p->sk.node,
-					p->scope, true);
+		tipc_sub_report_overlap(sub, p, TIPC_PUBLISHED, true);
 		list_del_init(&p->list);
 	}
 }
@@ -511,8 +507,6 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 	struct publication *p = NULL;
 	struct service_range *sr;
 	struct tipc_service *sc;
-	u32 upper = ua->sr.upper;
-	u32 lower = ua->sr.lower;
 	bool last;
 
 	sc = tipc_service_find(net, ua);
@@ -530,8 +524,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 	/* Notify any waiting subscriptions */
 	last = list_empty(&sr->all_publ);
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
-		tipc_sub_report_overlap(sub, lower, upper, TIPC_WITHDRAWN,
-					sk->ref, sk->node, ua->scope, last);
+		tipc_sub_report_overlap(sub, p, TIPC_WITHDRAWN, last);
 	}
 
 	/* Remove service range item if this was its last publication */
@@ -540,7 +533,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 		kfree(sr);
 	}
 
-	/* Delete service item if this no more publications and subscriptions */
+	/* Delete service item if no more publications and subscriptions */
 	if (RB_EMPTY_ROOT(&sc->ranges) && list_empty(&sc->subscriptions)) {
 		hlist_del_init_rcu(&sc->service_list);
 		kfree_rcu(sc, rcu);
@@ -839,7 +832,8 @@ bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 	struct tipc_uaddr ua;
 	bool res = true;
 
-	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type, 0, 0);
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type,
+		   tipc_sub_read(s, seq.lower), tipc_sub_read(s, seq.upper));
 	spin_lock_bh(&tn->nametbl_lock);
 	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
@@ -870,7 +864,8 @@ void tipc_nametbl_unsubscribe(struct tipc_subscription *sub)
 	struct tipc_service *sc;
 	struct tipc_uaddr ua;
 
-	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type, 0, 0);
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type,
+		   tipc_sub_read(s, seq.lower), tipc_sub_read(s, seq.upper));
 	spin_lock_bh(&tn->nametbl_lock);
 	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index f6ad0005218c..5f8dc0e7488f 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2000-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2010-2013, Wind River Systems
- * Copyright (c) 2020, Red Hat Inc
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -40,18 +40,26 @@
 #include "subscr.h"
 
 static void tipc_sub_send_event(struct tipc_subscription *sub,
-				u32 found_lower, u32 found_upper,
-				u32 event, u32 port, u32 node)
+				struct publication *p,
+				u32 event)
 {
+	struct tipc_subscr *s = &sub->evt.s;
 	struct tipc_event *evt = &sub->evt;
 
 	if (sub->inactive)
 		return;
 	tipc_evt_write(evt, event, event);
-	tipc_evt_write(evt, found_lower, found_lower);
-	tipc_evt_write(evt, found_upper, found_upper);
-	tipc_evt_write(evt, port.ref, port);
-	tipc_evt_write(evt, port.node, node);
+	if (p) {
+		tipc_evt_write(evt, found_lower, p->sr.lower);
+		tipc_evt_write(evt, found_upper, p->sr.upper);
+		tipc_evt_write(evt, port.ref, p->sk.ref);
+		tipc_evt_write(evt, port.node, p->sk.node);
+	} else {
+		tipc_evt_write(evt, found_lower, s->seq.lower);
+		tipc_evt_write(evt, found_upper, s->seq.upper);
+		tipc_evt_write(evt, port.ref, 0);
+		tipc_evt_write(evt, port.node, 0);
+	}
 	tipc_topsrv_queue_evt(sub->net, sub->conid, event, evt);
 }
 
@@ -61,24 +69,23 @@ static void tipc_sub_send_event(struct tipc_subscription *sub,
  * @found_lower: lower value to test
  * @found_upper: upper value to test
  *
- * Return: 1 if there is overlap, otherwise 0.
+ * Returns true if there is overlap, otherwise false.
  */
-int tipc_sub_check_overlap(struct tipc_service_range *seq, u32 found_lower,
-			   u32 found_upper)
+bool tipc_sub_check_overlap(struct tipc_service_range *sr,
+			    u32 found_lower, u32 found_upper)
 {
-	if (found_lower < seq->lower)
-		found_lower = seq->lower;
-	if (found_upper > seq->upper)
-		found_upper = seq->upper;
+	if (found_lower < sr->lower)
+		found_lower = sr->lower;
+	if (found_upper > sr->upper)
+		found_upper = sr->upper;
 	if (found_lower > found_upper)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 void tipc_sub_report_overlap(struct tipc_subscription *sub,
-			     u32 found_lower, u32 found_upper,
-			     u32 event, u32 port, u32 node,
-			     u32 scope, int must)
+			     struct publication *p,
+			     u32 event, bool must)
 {
 	struct tipc_subscr *s = &sub->evt.s;
 	u32 filter = tipc_sub_read(s, filter);
@@ -88,29 +95,25 @@ void tipc_sub_report_overlap(struct tipc_subscription *sub,
 	seq.lower = tipc_sub_read(s, seq.lower);
 	seq.upper = tipc_sub_read(s, seq.upper);
 
-	if (!tipc_sub_check_overlap(&seq, found_lower, found_upper))
+	if (!tipc_sub_check_overlap(&seq, p->sr.lower, p->sr.upper))
 		return;
-
 	if (!must && !(filter & TIPC_SUB_PORTS))
 		return;
-	if (filter & TIPC_SUB_CLUSTER_SCOPE && scope == TIPC_NODE_SCOPE)
+	if (filter & TIPC_SUB_CLUSTER_SCOPE && p->scope == TIPC_NODE_SCOPE)
 		return;
-	if (filter & TIPC_SUB_NODE_SCOPE && scope != TIPC_NODE_SCOPE)
+	if (filter & TIPC_SUB_NODE_SCOPE && p->scope != TIPC_NODE_SCOPE)
 		return;
 	spin_lock(&sub->lock);
-	tipc_sub_send_event(sub, found_lower, found_upper,
-			    event, port, node);
+	tipc_sub_send_event(sub, p, event);
 	spin_unlock(&sub->lock);
 }
 
 static void tipc_sub_timeout(struct timer_list *t)
 {
 	struct tipc_subscription *sub = from_timer(sub, t, timer);
-	struct tipc_subscr *s = &sub->evt.s;
 
 	spin_lock(&sub->lock);
-	tipc_sub_send_event(sub, s->seq.lower, s->seq.upper,
-			    TIPC_SUBSCR_TIMEOUT, 0, 0);
+	tipc_sub_send_event(sub, NULL, TIPC_SUBSCR_TIMEOUT);
 	sub->inactive = true;
 	spin_unlock(&sub->lock);
 }
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index 3ded27391d54..56769ce46e4d 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2012-2013, Wind River Systems
- * Copyright (c) 2020, Red Hat Inc
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -43,6 +43,7 @@
 #define TIPC_MAX_SUBSCR         65535
 #define TIPC_MAX_PUBL           65535
 
+struct publication;
 struct tipc_subscription;
 struct tipc_conn;
 
@@ -74,13 +75,9 @@ struct tipc_subscription *tipc_sub_subscribe(struct net *net,
 					     struct tipc_subscr *s,
 					     int conid);
 void tipc_sub_unsubscribe(struct tipc_subscription *sub);
-
-int tipc_sub_check_overlap(struct tipc_service_range *seq,
-			   u32 found_lower, u32 found_upper);
 void tipc_sub_report_overlap(struct tipc_subscription *sub,
-			     u32 found_lower, u32 found_upper,
-			     u32 event, u32 port, u32 node,
-			     u32 scope, int must);
+			     struct publication *p,
+			     u32 event, bool must);
 
 int __net_init tipc_topsrv_init_net(struct net *net);
 void __net_exit tipc_topsrv_exit_net(struct net *net);
-- 
2.29.2

