Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261DD33E69D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCQCHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhCQCG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q31Fei5PMCkg9i6BcRYbwAB6tRaMozhnW2b9lj1Ombg=;
        b=hRCHTUU1qWiK1StGnQ5wPvWwtijXxniMI/GCEmbrH1TQR1sKsXKunv6LwwvCRVwkbbu9kd
        wxC4j6wu0yyU0Z0z0tjOvI4FavcJ/tW+X6lcjo6SllsM8n4JVmZcMiooMzdD9gJlMAhKoQ
        4bW/DzND00RBqwYK8ePqfbvgw36huLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-ENIXQGLTNOeNeo0Hmas1OA-1; Tue, 16 Mar 2021 22:06:53 -0400
X-MC-Unique: ENIXQGLTNOeNeo0Hmas1OA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B63718D6A2A;
        Wed, 17 Mar 2021 02:06:51 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DAC85C1A1;
        Wed, 17 Mar 2021 02:06:50 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 15/16] tipc: add host-endian copy of user subscription to struct tipc_subscription
Date:   Tue, 16 Mar 2021 22:06:22 -0400
Message-Id: <20210317020623.1258298-16-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We reduce and localize the usage of the tipc_sub_xx() macros by adding a
corresponding member, with fields set in host-endian format, to struct
tipc_subscription.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 29 +++++++++++-----------------
 net/tipc/subscr.c     | 45 +++++++++++++++++++++++--------------------
 net/tipc/subscr.h     |  3 ++-
 3 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index f648feae446f..98b8874ad2f7 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -416,17 +416,14 @@ static int tipc_publ_sort(void *priv, struct list_head *a,
 static void tipc_service_subscribe(struct tipc_service *service,
 				   struct tipc_subscription *sub)
 {
-	struct tipc_subscr *sb = &sub->evt.s;
 	struct publication *p, *first, *tmp;
 	struct list_head publ_list;
 	struct service_range *sr;
-	struct tipc_service_range r;
-	u32 filter;
+	u32 filter, lower, upper;
 
-	r.type = tipc_sub_read(sb, seq.type);
-	r.lower = tipc_sub_read(sb, seq.lower);
-	r.upper = tipc_sub_read(sb, seq.upper);
-	filter = tipc_sub_read(sb, filter);
+	filter = sub->s.filter;
+	lower = sub->s.seq.lower;
+	upper = sub->s.seq.upper;
 
 	tipc_sub_get(sub);
 	list_add(&sub->service_list, &service->subscriptions);
@@ -435,7 +432,7 @@ static void tipc_service_subscribe(struct tipc_service *service,
 		return;
 
 	INIT_LIST_HEAD(&publ_list);
-	service_range_foreach_match(sr, service, r.lower, r.upper) {
+	service_range_foreach_match(sr, service, lower, upper) {
 		first = NULL;
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			if (filter & TIPC_SUB_PORTS)
@@ -826,14 +823,13 @@ void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
 bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 {
 	struct tipc_net *tn = tipc_net(sub->net);
-	struct tipc_subscr *s = &sub->evt.s;
-	u32 type = tipc_sub_read(s, seq.type);
+	u32 type = sub->s.seq.type;
 	struct tipc_service *sc;
 	struct tipc_uaddr ua;
 	bool res = true;
 
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type,
-		   tipc_sub_read(s, seq.lower), tipc_sub_read(s, seq.upper));
+		   sub->s.seq.lower, sub->s.seq.upper);
 	spin_lock_bh(&tn->nametbl_lock);
 	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
@@ -843,9 +839,8 @@ bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 		tipc_service_subscribe(sc, sub);
 		spin_unlock_bh(&sc->lock);
 	} else {
-		pr_warn("Failed to subscribe for {%u,%u,%u}\n", type,
-			tipc_sub_read(s, seq.lower),
-			tipc_sub_read(s, seq.upper));
+		pr_warn("Failed to subscribe for {%u,%u,%u}\n",
+			type, sub->s.seq.lower, sub->s.seq.upper);
 		res = false;
 	}
 	spin_unlock_bh(&tn->nametbl_lock);
@@ -859,13 +854,11 @@ bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 void tipc_nametbl_unsubscribe(struct tipc_subscription *sub)
 {
 	struct tipc_net *tn = tipc_net(sub->net);
-	struct tipc_subscr *s = &sub->evt.s;
-	u32 type = tipc_sub_read(s, seq.type);
 	struct tipc_service *sc;
 	struct tipc_uaddr ua;
 
-	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE, type,
-		   tipc_sub_read(s, seq.lower), tipc_sub_read(s, seq.upper));
+	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
+		   sub->s.seq.type, sub->s.seq.lower, sub->s.seq.upper);
 	spin_lock_bh(&tn->nametbl_lock);
 	sc = tipc_service_find(sub->net, &ua);
 	if (!sc)
diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 5f8dc0e7488f..8e00d739f03a 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -65,37 +65,32 @@ static void tipc_sub_send_event(struct tipc_subscription *sub,
 
 /**
  * tipc_sub_check_overlap - test for subscription overlap with the given values
- * @seq: tipc_name_seq to check
- * @found_lower: lower value to test
- * @found_upper: upper value to test
+ * @subscribed: the service range subscribed for
+ * @found: the service range we are checning for match
  *
  * Returns true if there is overlap, otherwise false.
  */
-bool tipc_sub_check_overlap(struct tipc_service_range *sr,
-			    u32 found_lower, u32 found_upper)
+static bool tipc_sub_check_overlap(struct tipc_service_range *subscribed,
+				   struct tipc_service_range *found)
 {
-	if (found_lower < sr->lower)
-		found_lower = sr->lower;
-	if (found_upper > sr->upper)
-		found_upper = sr->upper;
-	if (found_lower > found_upper)
-		return false;
-	return true;
+	u32 found_lower = found->lower;
+	u32 found_upper = found->upper;
+
+	if (found_lower < subscribed->lower)
+		found_lower = subscribed->lower;
+	if (found_upper > subscribed->upper)
+		found_upper = subscribed->upper;
+	return found_lower <= found_upper;
 }
 
 void tipc_sub_report_overlap(struct tipc_subscription *sub,
 			     struct publication *p,
 			     u32 event, bool must)
 {
-	struct tipc_subscr *s = &sub->evt.s;
-	u32 filter = tipc_sub_read(s, filter);
-	struct tipc_service_range seq;
-
-	seq.type = tipc_sub_read(s, seq.type);
-	seq.lower = tipc_sub_read(s, seq.lower);
-	seq.upper = tipc_sub_read(s, seq.upper);
+	struct tipc_service_range *sr = &sub->s.seq;
+	u32 filter = sub->s.filter;
 
-	if (!tipc_sub_check_overlap(&seq, p->sr.lower, p->sr.upper))
+	if (!tipc_sub_check_overlap(sr, &p->sr))
 		return;
 	if (!must && !(filter & TIPC_SUB_PORTS))
 		return;
@@ -137,12 +132,14 @@ struct tipc_subscription *tipc_sub_subscribe(struct net *net,
 					     struct tipc_subscr *s,
 					     int conid)
 {
+	u32 lower = tipc_sub_read(s, seq.lower);
+	u32 upper = tipc_sub_read(s, seq.upper);
 	u32 filter = tipc_sub_read(s, filter);
 	struct tipc_subscription *sub;
 	u32 timeout;
 
 	if ((filter & TIPC_SUB_PORTS && filter & TIPC_SUB_SERVICE) ||
-	    (tipc_sub_read(s, seq.lower) > tipc_sub_read(s, seq.upper))) {
+	    lower > upper) {
 		pr_warn("Subscription rejected, illegal request\n");
 		return NULL;
 	}
@@ -157,6 +154,12 @@ struct tipc_subscription *tipc_sub_subscribe(struct net *net,
 	sub->conid = conid;
 	sub->inactive = false;
 	memcpy(&sub->evt.s, s, sizeof(*s));
+	sub->s.seq.type = tipc_sub_read(s, seq.type);
+	sub->s.seq.lower = lower;
+	sub->s.seq.upper = upper;
+	sub->s.filter = filter;
+	sub->s.timeout = tipc_sub_read(s, timeout);
+	memcpy(sub->s.usr_handle, s->usr_handle, 8);
 	spin_lock_init(&sub->lock);
 	kref_init(&sub->kref);
 	if (!tipc_nametbl_subscribe(sub)) {
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index 56769ce46e4d..ddea6554ec46 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -60,12 +60,13 @@ struct tipc_conn;
  * @lock: serialize up/down and timer events
  */
 struct tipc_subscription {
+	struct tipc_subscr s;
+	struct tipc_event evt;
 	struct kref kref;
 	struct net *net;
 	struct timer_list timer;
 	struct list_head service_list;
 	struct list_head sub_list;
-	struct tipc_event evt;
 	int conid;
 	bool inactive;
 	spinlock_t lock;
-- 
2.29.2

