Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71E4EB2B5
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbiC2ReL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiC2ReK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1569319ABF3
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648575146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OH2jjEeCeBwvrhWqlPmHl1sTbHQcDW6wOkkEAs7QN4o=;
        b=TZSzaVtMTalvnRFjBw4PnxnWz4h/GRXtz9IkVVgA2yB3bcRkLtxVz9Z36ARD+sOCoFinly
        02qtO5OU2BN2H1ts778Wf8cqxjYLj4xLkFlx8gb58B9emcWgN2yzX9SPhjVFpUBSZlJAL2
        6KWV7QhHuMt4PYJSKNZ5Yu4qIrNyyOA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-gvBNw9yyOlyqHSjEE_y48g-1; Tue, 29 Mar 2022 13:32:21 -0400
X-MC-Unique: gvBNw9yyOlyqHSjEE_y48g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10F56803DB8;
        Tue, 29 Mar 2022 17:32:21 +0000 (UTC)
Received: from fenrir.redhat.com (unknown [10.22.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CA8E40CF8F7;
        Tue, 29 Mar 2022 17:32:19 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next] tipc: clarify meaning of 'inactive' field in struct tipc_subscription
Date:   Tue, 29 Mar 2022 13:32:18 -0400
Message-Id: <20220329173218.1737499-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

struct tipc_subscription has a boolean field 'inactive' which purpose
is not immediately obvious. When the subscription timer expires we are
still in interrupt context, and cannot easily just delete the
subscription. We therefore delay that action until the expiration
event has reached the work queue context where it is being sent to the
user. However, in the meantime other events may occur, which must be
suppressed to avoid any unexpected behavior.

We now clarify this with renaming the field and adding a comment.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/subscr.c | 10 ++++++----
 net/tipc/subscr.h |  4 ++--
 net/tipc/topsrv.c |  7 ++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 05d49ad81290..094a5bf5145c 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2000-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2010-2013, Wind River Systems
- * Copyright (c) 2020-2021, Red Hat Inc
+ * Copyright (c) 2020-2022, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -46,7 +46,7 @@ static void tipc_sub_send_event(struct tipc_subscription *sub,
 	struct tipc_subscr *s = &sub->evt.s;
 	struct tipc_event *evt = &sub->evt;
 
-	if (sub->inactive)
+	if (sub->expired)
 		return;
 	tipc_evt_write(evt, event, event);
 	if (p) {
@@ -109,7 +109,9 @@ static void tipc_sub_timeout(struct timer_list *t)
 
 	spin_lock(&sub->lock);
 	tipc_sub_send_event(sub, NULL, TIPC_SUBSCR_TIMEOUT);
-	sub->inactive = true;
+
+	/* Block for more events until sub can be deleted from work context */
+	sub->expired = true;
 	spin_unlock(&sub->lock);
 }
 
@@ -152,7 +154,7 @@ struct tipc_subscription *tipc_sub_subscribe(struct net *net,
 	INIT_LIST_HEAD(&sub->sub_list);
 	sub->net = net;
 	sub->conid = conid;
-	sub->inactive = false;
+	sub->expired = false;
 	memcpy(&sub->evt.s, s, sizeof(*s));
 	sub->s.seq.type = tipc_sub_read(s, seq.type);
 	sub->s.seq.lower = lower;
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index 60b877531b66..1af00c69cd6c 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2012-2013, Wind River Systems
- * Copyright (c) 2020-2021, Red Hat Inc
+ * Copyright (c) 2020-2022, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -69,7 +69,7 @@ struct tipc_subscription {
 	struct list_head service_list;
 	struct list_head sub_list;
 	int conid;
-	bool inactive;
+	bool expired;
 	spinlock_t lock;
 };
 
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae9..2d0e044a2524 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2012-2013, Wind River Systems
  * Copyright (c) 2017-2018, Ericsson AB
+ * Copyright (c) 2020-2022, Redhat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -105,7 +106,7 @@ struct tipc_conn {
 
 /* An entry waiting to be sent */
 struct outqueue_entry {
-	bool inactive;
+	bool expired;
 	struct tipc_event evt;
 	struct list_head list;
 };
@@ -261,7 +262,7 @@ static void tipc_conn_send_to_sock(struct tipc_conn *con)
 		evt = &e->evt;
 		spin_unlock_bh(&con->outqueue_lock);
 
-		if (e->inactive)
+		if (e->expired)
 			tipc_conn_delete_sub(con, &evt->s);
 
 		memset(&msg, 0, sizeof(msg));
@@ -325,7 +326,7 @@ void tipc_topsrv_queue_evt(struct net *net, int conid,
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
 	if (!e)
 		goto err;
-	e->inactive = (event == TIPC_SUBSCR_TIMEOUT);
+	e->expired = (event == TIPC_SUBSCR_TIMEOUT);
 	memcpy(&e->evt, evt, sizeof(*evt));
 	spin_lock_bh(&con->outqueue_lock);
 	list_add_tail(&e->list, &con->outqueue);
-- 
2.31.1

