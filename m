Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7733E68F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhCQCHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229739AbhCQCGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohDCFaLau9ipDe+tQvpc8ZBR6YQogrwEfq5Lnn8m3cg=;
        b=KKf2JQbNrxdECWR+1NYqv5ExCn26uvdZerk24LQOGeYBqcRLGmlupKxMyxfis+A7MfWLGG
        ZCscAL4CJmSKRJciIDUpLqObDcOCJ4atToJ/hGOEABFEKiN8JLuSfNAVJXvU7gk5ul015R
        hJtgTCzPQclcrurvKmDpgZ12ayM5wOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-Dncbc69GPBugaiFgAbxTkA-1; Tue, 16 Mar 2021 22:06:32 -0400
X-MC-Unique: Dncbc69GPBugaiFgAbxTkA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9431107ACCA;
        Wed, 17 Mar 2021 02:06:30 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BDA45C1A1;
        Wed, 17 Mar 2021 02:06:29 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 02/16] tipc: move creation of publication item one level up in call chain
Date:   Tue, 16 Mar 2021 22:06:09 -0400
Message-Id: <20210317020623.1258298-3-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We instantiate struct publication in tipc_nametbl_insert_publ()
instead of as currently in tipc_service_insert_publ(). This has the
advantage that we can pass a pointer to the publication struct to
the next call levels, instead of the numerous individual parameters
we pass on now. It also gives us a location to keep the contents of
the additional fields we will introduce in a later commit.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 65 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index c2410ba7be5c..c37cef09b54c 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -327,49 +327,48 @@ static struct service_range *tipc_service_create_range(struct tipc_service *sc,
 	return sr;
 }
 
-static struct publication *tipc_service_insert_publ(struct net *net,
-						    struct tipc_service *sc,
-						    u32 type, u32 lower,
-						    u32 upper, u32 scope,
-						    u32 node, u32 port,
-						    u32 key)
+static bool tipc_service_insert_publ(struct net *net,
+				     struct tipc_service *sc,
+				     struct publication *p)
 {
 	struct tipc_subscription *sub, *tmp;
 	struct service_range *sr;
-	struct publication *p;
+	struct publication *_p;
+	u32 node = p->sk.node;
 	bool first = false;
+	bool res = false;
 
-	sr = tipc_service_create_range(sc, lower, upper);
+	spin_lock_bh(&sc->lock);
+	sr = tipc_service_create_range(sc, p->sr.lower, p->sr.upper);
 	if (!sr)
-		goto  err;
+		goto  exit;
 
 	first = list_empty(&sr->all_publ);
 
 	/* Return if the publication already exists */
-	list_for_each_entry(p, &sr->all_publ, all_publ) {
-		if (p->key == key && (!p->sk.node || p->sk.node == node))
-			return NULL;
+	list_for_each_entry(_p, &sr->all_publ, all_publ) {
+		if (_p->key == p->key && (!_p->sk.node || _p->sk.node == node))
+			goto exit;
 	}
 
-	/* Create and insert publication */
-	p = tipc_publ_create(type, lower, upper, scope, node, port, key);
-	if (!p)
-		goto err;
-	/* Suppose there shouldn't be a huge gap btw publs i.e. >INT_MAX */
-	p->id = sc->publ_cnt++;
-	if (in_own_node(net, node))
+	if (in_own_node(net, p->sk.node))
 		list_add(&p->local_publ, &sr->local_publ);
 	list_add(&p->all_publ, &sr->all_publ);
+	p->id = sc->publ_cnt++;
 
 	/* Any subscriptions waiting for notification?  */
 	list_for_each_entry_safe(sub, tmp, &sc->subscriptions, service_list) {
-		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper, TIPC_PUBLISHED,
-					p->sk.ref, p->sk.node, p->scope, first);
+		tipc_sub_report_overlap(sub, p->sr.lower, p->sr.upper,
+					TIPC_PUBLISHED, p->sk.ref, p->sk.node,
+					p->scope, first);
 	}
-	return p;
-err:
-	pr_warn("Failed to bind to %u,%u,%u, no memory\n", type, lower, upper);
-	return NULL;
+	res = true;
+exit:
+	if (!res)
+		pr_warn("Failed to bind to %u,%u,%u\n",
+			p->sr.type, p->sr.lower, p->sr.upper);
+	spin_unlock_bh(&sc->lock);
+	return res;
 }
 
 /**
@@ -482,6 +481,10 @@ struct publication *tipc_nametbl_insert_publ(struct net *net, u32 type,
 	struct tipc_service *sc;
 	struct publication *p;
 
+	p = tipc_publ_create(type, lower, upper, scope, node, port, key);
+	if (!p)
+		return NULL;
+
 	if (scope > TIPC_NODE_SCOPE || lower > upper) {
 		pr_debug("Failed to bind illegal {%u,%u,%u} with scope %u\n",
 			 type, lower, upper, scope);
@@ -490,14 +493,10 @@ struct publication *tipc_nametbl_insert_publ(struct net *net, u32 type,
 	sc = tipc_service_find(net, type);
 	if (!sc)
 		sc = tipc_service_create(type, &nt->services[hash(type)]);
-	if (!sc)
-		return NULL;
-
-	spin_lock_bh(&sc->lock);
-	p = tipc_service_insert_publ(net, sc, type, lower, upper,
-				     scope, node, port, key);
-	spin_unlock_bh(&sc->lock);
-	return p;
+	if (sc && tipc_service_insert_publ(net, sc, p))
+		return p;
+	kfree(p);
+	return NULL;
 }
 
 struct publication *tipc_nametbl_remove_publ(struct net *net, u32 type,
-- 
2.29.2

