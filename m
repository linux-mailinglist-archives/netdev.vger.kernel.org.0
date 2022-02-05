Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD44AAA52
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380517AbiBERBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 12:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiBERBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 12:01:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C095C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 09:01:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id om8so741018pjb.5
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 09:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDLSgxhWsfmnXVqh2Fw60fWmZUR1WAPhE5phlgLvMlA=;
        b=Qct5NqaVgZFmUO1oTH5Qe19Jc39t97gr8IkMGoEmWdyPhAbZear3nuxynwX0zOLWRM
         ycLMxIt4Ri0v7Fssc/XDIbezB+BVPSDriV1NEMCYRQGADubETpYBJUJxpbHRy7mJGN8h
         QanjrNS0fIUOOliKXO92XvH0oAx04wP30Ye3UciRYf9HjNAQn2crywEfkvwRJDhLb1BF
         99ZRX54rFxkAPb9m2ZrCxnNpFwZI2jz4DFrCVjqPpqfUaYer73wu/QJq12IVWHpSzQFa
         OEQukDkHFdtW8R4E3hr7tTbdfNMjN0ttqqt8HuUNoDhK7i3vUJ7bGD2hdOsBdhvNBYot
         ndNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDLSgxhWsfmnXVqh2Fw60fWmZUR1WAPhE5phlgLvMlA=;
        b=KDczbxympzxXNUUCIiiDmDxttSwDY6EnGWt32WeKDdavWfe3shF+I/VWAjt7gUOQbN
         RoKtaOPCGsJ7liGl6R2pMvu3IcsgY1zNVmB4qPlXRppKk2U3L+ki6lU+wQ2rVgCY3ef0
         +wcXk5LqZSjm54+0+aZT9HaOALw2ibCxQ57YtIAgg36sVxWMsBRHm4ASN4lgp3xbZ9Vi
         0kzMaafawzmW9HD0dBXgTOyUhyXY258veABA/YVwdqeCFrflGkPuFEcnWzeiQXKS0wiZ
         2iUaSoXNRu3R9eSgvFrJsZpVRC2h8+vLqBvKr4/FsxGOUrGHgWuduCzr7w0hKC3Q47i8
         Bjdw==
X-Gm-Message-State: AOAM533hgckdKdZc7ZlxWNkRiOAd432EsksPLVtA6xamxRVeQ6aaIZFy
        ElswCazEdjXt+M47fS/6jfsCN0fQizc=
X-Google-Smtp-Source: ABdhPJxxaelNSzwKDTHZGuxTN4aevXfwK41YJ3GTdtWWXzKSbNVWtTVYt0M/hj0mc4zV6kH2V6AukA==
X-Received: by 2002:a17:902:e88d:: with SMTP id w13mr8943303plg.122.1644080488735;
        Sat, 05 Feb 2022 09:01:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8eb:b7ed:dbe7:a81f])
        by smtp.gmail.com with ESMTPSA id a1sm4176835pgm.83.2022.02.05.09.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:01:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] net: initialize init_net earlier
Date:   Sat,  5 Feb 2022 09:01:25 -0800
Message-Id: <20220205170125.3562935-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While testing a patch that will follow later
("net: add netns refcount tracker to struct nsproxy")
I found that devtmpfs_init() was called before init_net
was initialized.

This is a bug, because devtmpfs_setup() calls
ksys_unshare(CLONE_NEWNS);

This has the effect of increasing init_net refcount,
which will be later overwritten to 1, as part of setup_net(&init_net)

We had too many prior patches [1] trying to work around the root cause.

Really, make sure init_net is in BSS section, and that net_ns_init()
is called earlier at boot time.

Note that another patch ("vfs: add netns refcount tracker
to struct fs_context") also will need net_ns_init() being called
before vfs_caches_init()

As a bonus, this patch saves around 4KB in .data section.

[1]

f8c46cb39079 ("netns: do not call pernet ops for not yet set up init_net namespace")
b5082df8019a ("net: Initialise init_net.count to 1")
734b65417b24 ("net: Statically initialize init_net.dev_base_head")

v2: fixed a build error reported by kernel build bots (CONFIG_NET=n)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h |  6 ++++++
 init/main.c                 |  2 ++
 net/core/dev.c              |  3 +--
 net/core/net_namespace.c    | 17 +++++------------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5b61c462e534be468c81d2b0f4ef586b209dd4b8..374cc7b260fcdf15a8fc2c709d0b0fc6d99e8c5c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -513,4 +513,10 @@ static inline void fnhe_genid_bump(struct net *net)
 	atomic_inc(&net->fnhe_genid);
 }
 
+#ifdef CONFIG_NET
+void net_ns_init(void);
+#else
+static inline void net_ns_init(void) {}
+#endif
+
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/init/main.c b/init/main.c
index 65fa2e41a9c0904131525d504f3ec86add44f141..ada50f5a15e4397e45b0e5c06bab051b1ce193d9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -99,6 +99,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <net/net_namespace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1116,6 +1117,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	key_init();
 	security_init();
 	dbg_late_init();
+	net_ns_init();
 	vfs_caches_init();
 	pagecache_init();
 	signals_init();
diff --git a/net/core/dev.c b/net/core/dev.c
index 1eaa0b88e3ba5d800484656f2c3420af57050294..f662c6a7d7b49b836a05efc74aeffc7fc9e4e147 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10732,8 +10732,7 @@ static int __net_init netdev_init(struct net *net)
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
 		     8 * sizeof_field(struct napi_struct, gro_bitmask));
 
-	if (net != &init_net)
-		INIT_LIST_HEAD(&net->dev_base_head);
+	INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 8711350085d6b55a4f3da19bc69e521f9efb7861..0ec2f5906a27c7f930e832835682d69a32e3c8e1 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -44,13 +44,7 @@ EXPORT_SYMBOL_GPL(net_rwsem);
 static struct key_tag init_net_key_domain = { .usage = REFCOUNT_INIT(1) };
 #endif
 
-struct net init_net = {
-	.ns.count	= REFCOUNT_INIT(1),
-	.dev_base_head	= LIST_HEAD_INIT(init_net.dev_base_head),
-#ifdef CONFIG_KEYS
-	.key_domain	= &init_net_key_domain,
-#endif
-};
+struct net init_net;
 EXPORT_SYMBOL(init_net);
 
 static bool init_net_initialized;
@@ -1087,7 +1081,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	rtnl_set_sk_err(net, RTNLGRP_NSID, err);
 }
 
-static int __init net_ns_init(void)
+void __init net_ns_init(void)
 {
 	struct net_generic *ng;
 
@@ -1108,6 +1102,9 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
+#ifdef CONFIG_KEYS
+	init_net.key_domain = &init_net_key_domain;
+#endif
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
@@ -1122,12 +1119,8 @@ static int __init net_ns_init(void)
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl_net_dumpid,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-
-	return 0;
 }
 
-pure_initcall(net_ns_init);
-
 static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
 {
 	ops_pre_exit_list(ops, net_exit_list);
-- 
2.35.0.263.gb82422642f-goog

