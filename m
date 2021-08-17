Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB33EEF12
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhHQPX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:23:56 -0400
Received: from out1.migadu.com ([91.121.223.63]:42403 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232675AbhHQPXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 11:23:48 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629213791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YRDIrpoiP2TYN2AF9kIZ6gsIKbpG8tdAdC94qhQeGU4=;
        b=SJSJxx0/SDXGehEa6vbS1gq2dZe/5Q0+y8vuNpChZK/alzDG/S55UM7AC32QixiwuoFMa6
        IHr5BBqzBKZrBFQfXhdu5Zc+aWh59/Rd6I6K7StaimCFO9i4Eb062w51GVjiY05PbDCemm
        kUTWrTGuDD3hEtvF0xtZTvXE3Ht1pMI=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next v2] net: net_namespace: Optimize the code
Date:   Tue, 17 Aug 2021 23:23:00 +0800
Message-Id: <20210817152300.10698-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only one caller for ops_free(), so inline it.
Separate net_drop_ns() and net_free(), so the net_free()
can be called directly.
Add free_exit_list() helper function for free net_exit_list.

====================
v2:
 - v1 does not apply, rebase it.
====================

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/net_namespace.c | 52 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b5a767eddd5..a448a9b5bb2d 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -98,7 +98,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 	}
 
 	ng = net_alloc_generic();
-	if (ng == NULL)
+	if (!ng)
 		return -ENOMEM;
 
 	/*
@@ -148,13 +148,6 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	return err;
 }
 
-static void ops_free(const struct pernet_operations *ops, struct net *net)
-{
-	if (ops->id && ops->size) {
-		kfree(net_generic(net, *ops->id));
-	}
-}
-
 static void ops_pre_exit_list(const struct pernet_operations *ops,
 			      struct list_head *net_exit_list)
 {
@@ -184,7 +177,7 @@ static void ops_free_list(const struct pernet_operations *ops,
 	struct net *net;
 	if (ops->size && ops->id) {
 		list_for_each_entry(net, net_exit_list, exit_list)
-			ops_free(ops, net);
+			kfree(net_generic(net, *ops->id));
 	}
 }
 
@@ -433,15 +426,18 @@ static struct net *net_alloc(void)
 
 static void net_free(struct net *net)
 {
-	kfree(rcu_access_pointer(net->gen));
-	kmem_cache_free(net_cachep, net);
+	if (refcount_dec_and_test(&net->passive)) {
+		kfree(rcu_access_pointer(net->gen));
+		kmem_cache_free(net_cachep, net);
+	}
 }
 
 void net_drop_ns(void *p)
 {
-	struct net *ns = p;
-	if (ns && refcount_dec_and_test(&ns->passive))
-		net_free(ns);
+	struct net *net = (struct net *)p;
+
+	if (net)
+		net_free(net);
 }
 
 struct net *copy_net_ns(unsigned long flags,
@@ -479,7 +475,7 @@ struct net *copy_net_ns(unsigned long flags,
 put_userns:
 		key_remove_domain(net->key_domain);
 		put_user_ns(user_ns);
-		net_drop_ns(net);
+		net_free(net);
 dec_ucounts:
 		dec_net_namespaces(ucounts);
 		return ERR_PTR(rv);
@@ -611,7 +607,7 @@ static void cleanup_net(struct work_struct *work)
 		dec_net_namespaces(net->ucounts);
 		key_remove_domain(net->key_domain);
 		put_user_ns(net->user_ns);
-		net_drop_ns(net);
+		net_free(net);
 	}
 }
 
@@ -1120,6 +1116,14 @@ static int __init net_ns_init(void)
 
 pure_initcall(net_ns_init);
 
+static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
+{
+	ops_pre_exit_list(ops, net_exit_list);
+	synchronize_rcu();
+	ops_exit_list(ops, net_exit_list);
+	ops_free_list(ops, net_exit_list);
+}
+
 #ifdef CONFIG_NET_NS
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
@@ -1145,10 +1149,7 @@ static int __register_pernet_operations(struct list_head *list,
 out_undo:
 	/* If I have an error cleanup all namespaces I initialized */
 	list_del(&ops->list);
-	ops_pre_exit_list(ops, &net_exit_list);
-	synchronize_rcu();
-	ops_exit_list(ops, &net_exit_list);
-	ops_free_list(ops, &net_exit_list);
+	free_exit_list(ops, &net_exit_list);
 	return error;
 }
 
@@ -1161,10 +1162,8 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
-	ops_pre_exit_list(ops, &net_exit_list);
-	synchronize_rcu();
-	ops_exit_list(ops, &net_exit_list);
-	ops_free_list(ops, &net_exit_list);
+
+	free_exit_list(ops, &net_exit_list);
 }
 
 #else
@@ -1187,10 +1186,7 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	} else {
 		LIST_HEAD(net_exit_list);
 		list_add(&init_net.exit_list, &net_exit_list);
-		ops_pre_exit_list(ops, &net_exit_list);
-		synchronize_rcu();
-		ops_exit_list(ops, &net_exit_list);
-		ops_free_list(ops, &net_exit_list);
+		free_exit_list(ops, &net_exit_list);
 	}
 }
 
-- 
2.32.0

