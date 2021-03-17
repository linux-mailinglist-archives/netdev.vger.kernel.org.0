Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE23A33E69C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCQCHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230028AbhCQCG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwAJYxhxoK65xZ3Ji6P66o29S56yrmzQDDZiWdiSebU=;
        b=MI3fDSV4oL695jXEsGPMnjx/kCKUIELGAU1KYPq9lCUPHbk5Ni13Hy/1VmRsQnso51rS3b
        +nV7P48cEOVn9DjVnh0o2DZdyCmCTyY6x1e66d4GNfKasdYBWzxURho4AM7qy322Dp7aoV
        mDev4uIESwYd1dHKNWIvIh84+GQtI9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-xf4y6D-wML628ikC8lEDpg-1; Tue, 16 Mar 2021 22:06:57 -0400
X-MC-Unique: xf4y6D-wML628ikC8lEDpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7444881431D;
        Wed, 17 Mar 2021 02:06:55 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739335C1A1;
        Wed, 17 Mar 2021 02:06:51 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 16/16] tipc: remove some unnecessary warnings
Date:   Tue, 16 Mar 2021 22:06:23 -0400
Message-Id: <20210317020623.1258298-17-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We move some warning printouts to more strategic locations to avoid
duplicates and yield more detailed information about the reported
problem.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_distr.c |  7 -------
 net/tipc/name_table.c | 30 ++++++++++++++++--------------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 9e2fab3569b5..bda902caa814 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -253,13 +253,6 @@ static void tipc_publ_purge(struct net *net, struct publication *p, u32 addr)
 	if (_p)
 		tipc_node_unsubscribe(net, &_p->binding_node, addr);
 	spin_unlock_bh(&tn->nametbl_lock);
-
-	if (_p != p) {
-		pr_err("Unable to remove publication from failed node\n"
-		       " (type=%u, lower=%u, node=%u, port=%u, key=%u)\n",
-		       p->sr.type, p->sr.lower, p->sk.node, p->sk.ref, p->key);
-	}
-
 	if (_p)
 		kfree_rcu(_p, rcu);
 }
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 98b8874ad2f7..6db9f9e7c0ac 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -337,6 +337,7 @@ static bool tipc_service_insert_publ(struct net *net,
 	u32 node = p->sk.node;
 	bool first = false;
 	bool res = false;
+	u32 key = p->key;
 
 	spin_lock_bh(&sc->lock);
 	sr = tipc_service_create_range(sc, p);
@@ -347,8 +348,12 @@ static bool tipc_service_insert_publ(struct net *net,
 
 	/* Return if the publication already exists */
 	list_for_each_entry(_p, &sr->all_publ, all_publ) {
-		if (_p->key == p->key && (!_p->sk.node || _p->sk.node == node))
+		if (_p->key == key && (!_p->sk.node || _p->sk.node == node)) {
+			pr_debug("Failed to bind duplicate %u,%u,%u/%u:%u/%u\n",
+				 p->sr.type, p->sr.lower, p->sr.upper,
+				 node, p->sk.ref, key);
 			goto exit;
+		}
 	}
 
 	if (in_own_node(net, p->sk.node))
@@ -475,17 +480,11 @@ struct publication *tipc_nametbl_insert_publ(struct net *net,
 {
 	struct tipc_service *sc;
 	struct publication *p;
-	u32 type = ua->sr.type;
 
 	p = tipc_publ_create(ua, sk, key);
 	if (!p)
 		return NULL;
 
-	if (ua->sr.lower > ua->sr.upper) {
-		pr_debug("Failed to bind illegal {%u,%u,%u} from node %u\n",
-			 type, ua->sr.lower, ua->sr.upper, sk->node);
-		return NULL;
-	}
 	sc = tipc_service_find(net, ua);
 	if (!sc)
 		sc = tipc_service_create(net, ua);
@@ -508,15 +507,15 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 
 	sc = tipc_service_find(net, ua);
 	if (!sc)
-		return NULL;
+		goto exit;
 
 	spin_lock_bh(&sc->lock);
 	sr = tipc_service_find_range(sc, ua);
 	if (!sr)
-		goto exit;
+		goto unlock;
 	p = tipc_service_remove_publ(sr, sk, key);
 	if (!p)
-		goto exit;
+		goto unlock;
 
 	/* Notify any waiting subscriptions */
 	last = list_empty(&sr->all_publ);
@@ -535,8 +534,14 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 		hlist_del_init_rcu(&sc->service_list);
 		kfree_rcu(sc, rcu);
 	}
-exit:
+unlock:
 	spin_unlock_bh(&sc->lock);
+exit:
+	if (!p) {
+		pr_err("Failed to remove unknown binding: %u,%u,%u/%u:%u/%u\n",
+		       ua->sr.type, ua->sr.lower, ua->sr.upper,
+		       sk->node, sk->ref, key);
+	}
 	return p;
 }
 
@@ -805,9 +810,6 @@ void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
 		skb = tipc_named_withdraw(net, p);
 		list_del_init(&p->binding_sock);
 		kfree_rcu(p, rcu);
-	} else {
-		pr_err("Failed to remove local publication {%u,%u,%u}/%u\n",
-		       ua->sr.type, ua->sr.lower, ua->sr.upper, key);
 	}
 	rc_dests = nt->rc_dests;
 	spin_unlock_bh(&tn->nametbl_lock);
-- 
2.29.2

