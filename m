Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612395538C8
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiFURU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiFURU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:20:26 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0158827FDB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655832027; x=1687368027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n+EXOp41r80zet1Hk5CeOzZI5NMKvpnZcab3y/kUHsk=;
  b=kgBHJixQUPi4/WbPHTvLpFD7tjb8LribSrYhCCc3pIB6d287joppK1Lo
   LqPVL0l2rbxaqC2CDB/QikLtgPG66hfwlazNvYYh0xooz2eyavM4xjQ+t
   lqXhoo9pzNd2Igj3u5dcuNUrYHiIdj508j69ZunVhRe7RwujMho6OM9Xm
   8=;
X-IronPort-AV: E=Sophos;i="5.92,209,1650931200"; 
   d="scan'208";a="210320374"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 21 Jun 2022 17:20:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 9F78A1A007E;
        Tue, 21 Jun 2022 17:20:23 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:20:22 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:20:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 3/6] af_unix: Define a per-netns hash table.
Date:   Tue, 21 Jun 2022 10:19:10 -0700
Message-ID: <20220621171913.73401-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621171913.73401-1-kuniyu@amazon.com>
References: <20220621171913.73401-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a per netns hash table for AF_UNIX, which size is fixed
as UNIX_HASH_SIZE for now.

The first implementation defines a per-netns hash table as a single array
of lock and list:

	struct unix_hashbucket {
		spinlock_t		lock;
		struct hlist_head	head;
	};

	struct netns_unix {
		struct unix_hashbucket	*hash;
		...
	};

But, Eric pointed out memory cost that the structure has holes because of
sizeof(spinlock_t), which is 4 (or more if LOCKDEP is enabled). [0]  It
could be expensive on a host with thousands of netns and few AF_UNIX
sockets.  For this reason, a per-netns hash table uses two dense arrays.

	struct unix_table {
		spinlock_t		*locks;
		struct hlist_head	*buckets;
	};

	struct netns_unix {
		struct unix_table	table;
		...
	};

Note the length of the list has a significant impact rather than lock
contention, so having shared locks can be an option.  But, per-netns
locks and lists still perform better than the global locks and per-netns
lists. [1]

Also, this patch adds a change so that struct netns_unix disappears from
struct net if CONFIG_UNIX is disabled.

[0]: https://lore.kernel.org/netdev/CANn89iLVxO5aqx16azNU7p7Z-nz5NrnM5QTqOzueVxEnkVTxyg@mail.gmail.com/
[1]: https://lore.kernel.org/netdev/20220617175215.1769-1-kuniyu@amazon.com/

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/net_namespace.h |  2 ++
 include/net/netns/unix.h    |  6 ++++++
 net/unix/af_unix.c          | 38 +++++++++++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c4f5601f6e32..20a2992901c2 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -120,7 +120,9 @@ struct net {
 	struct netns_core	core;
 	struct netns_mib	mib;
 	struct netns_packet	packet;
+#if IS_ENABLED(CONFIG_UNIX)
 	struct netns_unix	unx;
+#endif
 	struct netns_nexthop	nexthop;
 	struct netns_ipv4	ipv4;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
index 91a3d7e39198..6f1a33df061d 100644
--- a/include/net/netns/unix.h
+++ b/include/net/netns/unix.h
@@ -5,8 +5,14 @@
 #ifndef __NETNS_UNIX_H__
 #define __NETNS_UNIX_H__
 
+struct unix_table {
+	spinlock_t		*locks;
+	struct hlist_head	*buckets;
+};
+
 struct ctl_table_header;
 struct netns_unix {
+	struct unix_table	table;
 	int			sysctl_max_dgram_qlen;
 	struct ctl_table_header	*ctl;
 };
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c0804ae9c96a..cdd12881a39d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3559,7 +3559,7 @@ static const struct net_proto_family unix_family_ops = {
 
 static int __net_init unix_net_init(struct net *net)
 {
-	int error = -ENOMEM;
+	int i;
 
 	net->unx.sysctl_max_dgram_qlen = 10;
 	if (unix_sysctl_register(net))
@@ -3567,18 +3567,44 @@ static int __net_init unix_net_init(struct net *net)
 
 #ifdef CONFIG_PROC_FS
 	if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
-			sizeof(struct seq_net_private))) {
-		unix_sysctl_unregister(net);
-		goto out;
+			     sizeof(struct seq_net_private)))
+		goto err_sysctl;
+#endif
+
+	net->unx.table.locks = kvmalloc_array(UNIX_HASH_SIZE,
+					      sizeof(spinlock_t), GFP_KERNEL);
+	if (!net->unx.table.locks)
+		goto err_proc;
+
+	net->unx.table.buckets = kvmalloc_array(UNIX_HASH_SIZE,
+						sizeof(struct hlist_head),
+						GFP_KERNEL);
+	if (!net->unx.table.buckets)
+		goto free_locks;
+
+	for (i = 0; i < UNIX_HASH_SIZE; i++) {
+		spin_lock_init(&net->unx.table.locks[i]);
+		INIT_HLIST_HEAD(&net->unx.table.buckets[i]);
 	}
+
+	return 0;
+
+free_locks:
+	kvfree(net->unx.table.locks);
+err_proc:
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("unix", net->proc_net);
+err_sysctl:
 #endif
-	error = 0;
+	unix_sysctl_unregister(net);
 out:
-	return error;
+	return -ENOMEM;
 }
 
 static void __net_exit unix_net_exit(struct net *net)
 {
+	kvfree(net->unx.table.buckets);
+	kvfree(net->unx.table.locks);
 	unix_sysctl_unregister(net);
 	remove_proc_entry("unix", net->proc_net);
 }
-- 
2.30.2

