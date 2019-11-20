Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087DE103173
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKTCPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:15:37 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32856 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727082AbfKTCPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:15:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id BF0574AE81;
        Wed, 20 Nov 2019 13:15:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1574216128; bh=+qTtJ
        HSJevjDSZPeNa0myrBDj/KvVTNkXc3Yn8Lcxq4=; b=Jf4NrfEp7qO/DwLnb/ivG
        h3vmlJsbgaKPB20q37Uwsnu7699Vl7bMMt5Lz9J5XduPoySiN9+DoPxDI5jRvmGu
        loYuP5vYAoTa24DyIpKlgJbIzxs2jpW87gy2cA63S5OEzcnqNY02H+WJKROPxR/E
        TIyUu8gXRGVUnsTvSuJm5U=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id n4fT5-OD6jpH; Wed, 20 Nov 2019 13:15:28 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 06FDD4AED4;
        Wed, 20 Nov 2019 13:15:26 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id AEE9F4AE81;
        Wed, 20 Nov 2019 13:15:25 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next] tipc: support in-order name publication events
Date:   Wed, 20 Nov 2019 09:15:19 +0700
Message-Id: <20191120021519.2690-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is observed that TIPC service binding order will not be kept in the
publication event report to user if the service is subscribed after the
bindings.

For example, services are bound by application in the following order:

Server: bound port A to {18888,66,66} scope 2
Server: bound port A to {18888,33,33} scope 2

Now, if a client subscribes to the service range (e.g. {18888, 0-100}),
it will get the 'TIPC_PUBLISHED' events in that binding order only when
the subscription is started before the bindings.
Otherwise, if started after the bindings, the events will arrive in the
opposite order:

Client: received event for published {18888,33,33}
Client: received event for published {18888,66,66}

For the latter case, it is clear that the bindings have existed in the
name table already, so when reported, the events' order will follow the
order of the rbtree binding nodes (- a node with lesser 'lower'/'upper'
range value will be first).

This is correct as we provide the tracking on a specific service status
(available or not), not the relationship between multiple services.
However, some users expect to see the same order of arriving events
irrespective of when the subscription is issued. This turns out to be
easy to fix. We now add functionality to ensure that publication events
always are issued in the same temporal order as the corresponding
bindings were performed.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/name_table.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 net/tipc/name_table.h |  4 ++++
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 66a65c2cdb23..898a4ad5909d 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -35,6 +35,7 @@
  */
 
 #include <net/sock.h>
+#include <linux/list_sort.h>
 #include "core.h"
 #include "netlink.h"
 #include "name_table.h"
@@ -66,6 +67,7 @@ struct service_range {
 /**
  * struct tipc_service - container for all published instances of a service type
  * @type: 32 bit 'type' value for service
+ * @publ_cnt: increasing counter for publications in this service
  * @ranges: rb tree containing all service ranges for this service
  * @service_list: links to adjacent name ranges in hash chain
  * @subscriptions: list of subscriptions for this service type
@@ -74,6 +76,7 @@ struct service_range {
  */
 struct tipc_service {
 	u32 type;
+	unsigned int publ_cnt;
 	struct rb_root ranges;
 	struct hlist_node service_list;
 	struct list_head subscriptions;
@@ -109,6 +112,7 @@ static struct publication *tipc_publ_create(u32 type, u32 lower, u32 upper,
 	INIT_LIST_HEAD(&publ->binding_node);
 	INIT_LIST_HEAD(&publ->local_publ);
 	INIT_LIST_HEAD(&publ->all_publ);
+	INIT_LIST_HEAD(&publ->list);
 	return publ;
 }
 
@@ -244,6 +248,8 @@ static struct publication *tipc_service_insert_publ(struct net *net,
 	p = tipc_publ_create(type, lower, upper, scope, node, port, key);
 	if (!p)
 		goto err;
+	/* Suppose there shouldn't be a huge gap btw publs i.e. >INT_MAX */
+	p->id = sc->publ_cnt++;
 	if (in_own_node(net, node))
 		list_add(&p->local_publ, &sr->local_publ);
 	list_add(&p->all_publ, &sr->all_publ);
@@ -277,6 +283,17 @@ static struct publication *tipc_service_remove_publ(struct service_range *sr,
 	return NULL;
 }
 
+#define publication_after(pa, pb) (((int)((pb)->id - (pa)->id) < 0))
+static int tipc_publ_sort(void *priv, struct list_head *a,
+			  struct list_head *b)
+{
+	struct publication *pa, *pb;
+
+	pa = container_of(a, struct publication, list);
+	pb = container_of(b, struct publication, list);
+	return publication_after(pa, pb);
+}
+
 /**
  * tipc_service_subscribe - attach a subscription, and optionally
  * issue the prescribed number of events if there is any service
@@ -286,36 +303,51 @@ static void tipc_service_subscribe(struct tipc_service *service,
 				   struct tipc_subscription *sub)
 {
 	struct tipc_subscr *sb = &sub->evt.s;
+	struct publication *p, *first, *tmp;
+	struct list_head publ_list;
 	struct service_range *sr;
 	struct tipc_name_seq ns;
-	struct publication *p;
 	struct rb_node *n;
-	bool first;
+	u32 filter;
 
 	ns.type = tipc_sub_read(sb, seq.type);
 	ns.lower = tipc_sub_read(sb, seq.lower);
 	ns.upper = tipc_sub_read(sb, seq.upper);
+	filter = tipc_sub_read(sb, filter);
 
 	tipc_sub_get(sub);
 	list_add(&sub->service_list, &service->subscriptions);
 
-	if (tipc_sub_read(sb, filter) & TIPC_SUB_NO_STATUS)
+	if (filter & TIPC_SUB_NO_STATUS)
 		return;
 
+	INIT_LIST_HEAD(&publ_list);
 	for (n = rb_first(&service->ranges); n; n = rb_next(n)) {
 		sr = container_of(n, struct service_range, tree_node);
 		if (sr->lower > ns.upper)
 			break;
 		if (!tipc_sub_check_overlap(&ns, sr->lower, sr->upper))
 			continue;
-		first = true;
 
+		first = NULL;
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
-			tipc_sub_report_overlap(sub, sr->lower, sr->upper,
-						TIPC_PUBLISHED,	p->port,
-						p->node, p->scope, first);
-			first = false;
+			if (filter & TIPC_SUB_PORTS)
+				list_add_tail(&p->list, &publ_list);
+			else if (!first || publication_after(first, p))
+				/* Pick this range's *first* publication */
+				first = p;
 		}
+		if (first)
+			list_add_tail(&first->list, &publ_list);
+	}
+
+	/* Sort the publications before reporting */
+	list_sort(NULL, &publ_list, tipc_publ_sort);
+	list_for_each_entry_safe(p, tmp, &publ_list, list) {
+		tipc_sub_report_overlap(sub, p->lower, p->upper,
+					TIPC_PUBLISHED, p->port, p->node,
+					p->scope, true);
+		list_del_init(&p->list);
 	}
 }
 
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index f79066334cc8..3d5da71ce41e 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -58,6 +58,7 @@ struct tipc_group;
  * @node: network address of publishing socket's node
  * @port: publishing port
  * @key: publication key, unique across the cluster
+ * @id: publication id
  * @binding_node: all publications from the same node which bound this one
  * - Remote publications: in node->publ_list
  *   Used by node/name distr to withdraw publications when node is lost
@@ -69,6 +70,7 @@ struct tipc_group;
  *   Used by closest_first and multicast receive lookup algorithms
  * @all_publ: all publications identical to this one, whatever node and scope
  *   Used by round-robin lookup algorithm
+ * @list: to form a list of publications in temporal order
  * @rcu: RCU callback head used for deferred freeing
  */
 struct publication {
@@ -79,10 +81,12 @@ struct publication {
 	u32 node;
 	u32 port;
 	u32 key;
+	unsigned int id;
 	struct list_head binding_node;
 	struct list_head binding_sock;
 	struct list_head local_publ;
 	struct list_head all_publ;
+	struct list_head list;
 	struct rcu_head rcu;
 };
 
-- 
2.13.7

