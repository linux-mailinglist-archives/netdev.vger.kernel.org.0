Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4942154EE07
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378825AbiFPXs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiFPXs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:48:56 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665B62A34
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655423335; x=1686959335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=49b8UVFVbTWQk/bn+BX/q7YE4LBhVh1yKHkX5mXzre8=;
  b=hiLZ0NkIyKADv0DY5D+SfmpPGH7FJA54NwfBizussoVL9hgGYPjETePl
   6vJUtNqUdSZUyuU8LOxAt5xj2Z2A4xsDyuHSnG99gwWjvhmzIyo9CDA52
   p8UMhka5C94f4IEJDu9pQmlozwipLKnD57ubS8hCE0bhIO22hcWVZge+r
   I=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="202787023"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 16 Jun 2022 23:48:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id BF8061A0CEA;
        Thu, 16 Jun 2022 23:48:38 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:48:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.26) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:48:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
Date:   Thu, 16 Jun 2022 16:47:11 -0700
Message-ID: <20220616234714.4291-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616234714.4291-1-kuniyu@amazon.com>
References: <20220616234714.4291-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a per netns hash table for AF_UNIX.

Note that its size is fixed as UNIX_HASH_SIZE for now.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/af_unix.h    |  5 +++++
 include/net/netns/unix.h |  2 ++
 net/unix/af_unix.c       | 40 ++++++++++++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index acb56e463db1..0a17e49af0c9 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -24,6 +24,11 @@ extern unsigned int unix_tot_inflight;
 extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
 extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
 
+struct unix_hashbucket {
+	spinlock_t		lock;
+	struct hlist_head	head;
+};
+
 struct unix_address {
 	refcount_t	refcnt;
 	int		len;
diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
index 91a3d7e39198..975c4e3f8a5b 100644
--- a/include/net/netns/unix.h
+++ b/include/net/netns/unix.h
@@ -5,8 +5,10 @@
 #ifndef __NETNS_UNIX_H__
 #define __NETNS_UNIX_H__
 
+struct unix_hashbucket;
 struct ctl_table_header;
 struct netns_unix {
+	struct unix_hashbucket	*hash;
 	int			sysctl_max_dgram_qlen;
 	struct ctl_table_header	*ctl;
 };
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c0804ae9c96a..3c07702e2349 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3559,7 +3559,7 @@ static const struct net_proto_family unix_family_ops = {
 
 static int __net_init unix_net_init(struct net *net)
 {
-	int error = -ENOMEM;
+	int i;
 
 	net->unx.sysctl_max_dgram_qlen = 10;
 	if (unix_sysctl_register(net))
@@ -3567,18 +3567,35 @@ static int __net_init unix_net_init(struct net *net)
 
 #ifdef CONFIG_PROC_FS
 	if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
-			sizeof(struct seq_net_private))) {
-		unix_sysctl_unregister(net);
-		goto out;
+			     sizeof(struct seq_net_private)))
+		goto err_sysctl;
+#endif
+
+	net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
+				GFP_KERNEL);
+	if (!net->unx.hash)
+		goto err_proc;
+
+	for (i = 0; i < UNIX_HASH_SIZE; i++) {
+		INIT_HLIST_HEAD(&net->unx.hash[i].head);
+		spin_lock_init(&net->unx.hash[i].lock);
 	}
+
+	return 0;
+
+err_proc:
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("unix", net->proc_net);
 #endif
-	error = 0;
+err_sysctl:
+	unix_sysctl_unregister(net);
 out:
-	return error;
+	return -ENOMEM;
 }
 
 static void __net_exit unix_net_exit(struct net *net)
 {
+	kfree(net->unx.hash);
 	unix_sysctl_unregister(net);
 	remove_proc_entry("unix", net->proc_net);
 }
@@ -3666,6 +3683,16 @@ static int __init af_unix_init(void)
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
+	init_net.unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
+				    GFP_KERNEL);
+	if (!init_net.unx.hash)
+		goto out;
+
+	for (i = 0; i < UNIX_HASH_SIZE; i++) {
+		INIT_HLIST_HEAD(&init_net.unx.hash[i].head);
+		spin_lock_init(&init_net.unx.hash[i].lock);
+	}
+
 	for (i = 0; i < UNIX_HASH_SIZE; i++)
 		spin_lock_init(&unix_table_locks[i]);
 
@@ -3699,6 +3726,7 @@ static void __exit af_unix_exit(void)
 	proto_unregister(&unix_dgram_proto);
 	proto_unregister(&unix_stream_proto);
 	unregister_pernet_subsys(&unix_net_ops);
+	kfree(init_net.unx.hash);
 }
 
 /* Earlier than device_initcall() so that other drivers invoking
-- 
2.30.2

