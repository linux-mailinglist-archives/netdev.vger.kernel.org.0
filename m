Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43C5A1D81
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiHZAGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiHZAGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:06:39 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD454C7F83;
        Thu, 25 Aug 2022 17:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472399; x=1693008399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AMeidybKzTy6YY1kywsY9OZrxS2aZyZZxaWs+l8aFcM=;
  b=lgkJDvyf0jxpscjWHBkfy4CoIaohtSuz03OtuhB7EU9BtFHUNbHvILek
   ta4Xw/LRU5S5xQyi1PzYQOZ5YvciKR2s/CC+WpGUZRuxwcuay9hiSHiSt
   /HHWwmDtCfa6gIMPmai5JYpbsUqrkNbFYIo9LNQCBZaiDMjTe3K6I120h
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="253012392"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:06:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 3279398F7A;
        Fri, 26 Aug 2022 00:06:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:06:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:06:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 04/13] net: Introduce init2() for pernet_operations.
Date:   Thu, 25 Aug 2022 17:04:36 -0700
Message-ID: <20220826000445.46552-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new init function for pernet_operations, init2().

We call each init2() during clone() or unshare() only, where we can
access the parent netns for a child netns creation.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/net_namespace.h |  3 +++
 net/core/net_namespace.c    | 18 +++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 8c3587d5c308..3ca426649756 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -410,6 +410,8 @@ struct pernet_operations {
 	 * from register_pernet_subsys(), unregister_pernet_subsys()
 	 * register_pernet_device() and unregister_pernet_device().
 	 *
+	 * init2() is called during clone() or unshare() only.
+	 *
 	 * Exit methods using blocking RCU primitives, such as
 	 * synchronize_rcu(), should be implemented via exit_batch.
 	 * Then, destruction of a group of net requires single
@@ -422,6 +424,7 @@ struct pernet_operations {
 	 * the calls.
 	 */
 	int (*init)(struct net *net);
+	int (*init2)(struct net *net, struct net *old_net);
 	void (*pre_exit)(struct net *net);
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6b9f19122ec1..b120ff97d9f5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -116,7 +116,8 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 	return 0;
 }
 
-static int ops_init(const struct pernet_operations *ops, struct net *net)
+static int ops_init(const struct pernet_operations *ops,
+		    struct net *net, struct net *old_net)
 {
 	int err = -ENOMEM;
 	void *data = NULL;
@@ -133,6 +134,8 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	err = 0;
 	if (ops->init)
 		err = ops->init(net);
+	if (!err && ops->init2 && old_net)
+		err = ops->init2(net, old_net);
 	if (!err)
 		return 0;
 
@@ -301,7 +304,8 @@ EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 /*
  * setup_net runs the initializers for the network namespace object.
  */
-static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
+static __net_init int setup_net(struct net *net, struct net *old_net,
+				struct user_namespace *user_ns)
 {
 	/* Must be called with pernet_ops_rwsem held */
 	const struct pernet_operations *ops, *saved_ops;
@@ -323,7 +327,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	mutex_init(&net->ipv4.ra_mutex);
 
 	list_for_each_entry(ops, &pernet_list, list) {
-		error = ops_init(ops, net);
+		error = ops_init(ops, net, old_net);
 		if (error < 0)
 			goto out_undo;
 	}
@@ -469,7 +473,7 @@ struct net *copy_net_ns(unsigned long flags,
 	if (rv < 0)
 		goto put_userns;
 
-	rv = setup_net(net, user_ns);
+	rv = setup_net(net, old_net, user_ns);
 
 	up_read(&pernet_ops_rwsem);
 
@@ -1107,7 +1111,7 @@ void __init net_ns_init(void)
 	init_net.key_domain = &init_net_key_domain;
 #endif
 	down_write(&pernet_ops_rwsem);
-	if (setup_net(&init_net, &init_user_ns))
+	if (setup_net(&init_net, NULL, &init_user_ns))
 		panic("Could not setup the initial network namespace");
 
 	init_net_initialized = true;
@@ -1148,7 +1152,7 @@ static int __register_pernet_operations(struct list_head *list,
 
 			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
 			old = set_active_memcg(memcg);
-			error = ops_init(ops, net);
+			error = ops_init(ops, net, NULL);
 			set_active_memcg(old);
 			mem_cgroup_put(memcg);
 			if (error)
@@ -1188,7 +1192,7 @@ static int __register_pernet_operations(struct list_head *list,
 		return 0;
 	}
 
-	return ops_init(ops, &init_net);
+	return ops_init(ops, &init_net, NULL);
 }
 
 static void __unregister_pernet_operations(struct pernet_operations *ops)
-- 
2.30.2

