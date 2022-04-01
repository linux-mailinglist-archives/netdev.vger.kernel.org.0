Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8243D4EF02C
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347108AbiDAOcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347265AbiDAOby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B40F288A9B;
        Fri,  1 Apr 2022 07:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B10161C33;
        Fri,  1 Apr 2022 14:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA64C2BBE4;
        Fri,  1 Apr 2022 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823294;
        bh=DN9lGBU+dPZ4HI6Xc4ExzVKjNqN1cQFTbSsuRZwJpyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixHm/L4PACJmNU7Ho3KlIqRa49XQFxxPRQtjuAMzgZonGAT6gKNiRyZN2rC1CyO8m
         hbwFeUy5T8YaBPwehRBp6Miiiu3GWMjcCiWU1ouE8s16GevHZxeXfa3EaAFV4XtFFz
         Kv3L34PRqNENgz4OThuogpyMWDy/BZmv0QhEFRky/UxH2gsWXf6SMfWD2j+nVeWq8e
         hvFrgYupoNWKIuHRkzigj/IG9+3c9qk/JT8w/rNaAJbczaKdUlJAxCeAt0W4nmMwbi
         Zag/vyOzDxlhtnw5cjR/eIb7TNP7fnx2RarMM1PTvH6ouKYohXlh5YawZZdbxehZqi
         mRLfDVQAk4klA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, akpm@linux-foundation.org, mhiramat@kernel.org,
        rostedt@goodmis.org, vbabka@suse.cz, ahalaney@redhat.com,
        wangkefeng.wang@huawei.com, linux@rasmusvillemoes.dk,
        keescook@chromium.org, mark-pk.tsai@mediatek.com,
        valentin.schneider@arm.com, peterz@infradead.org,
        bigeasy@linutronix.de, toke@redhat.com, imagedong@tencent.com,
        petrm@nvidia.com, memxor@gmail.com, arnd@arndb.de,
        changbin.du@intel.com, yajun.deng@linux.dev, hmukos@yandex-team.ru,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 046/149] net: initialize init_net earlier
Date:   Fri,  1 Apr 2022 10:23:53 -0400
Message-Id: <20220401142536.1948161-46-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9c1be1935fb68b2413796cdc03d019b8cf35ab51 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h |  6 ++++++
 init/main.c                 |  2 ++
 net/core/dev.c              |  3 +--
 net/core/net_namespace.c    | 17 +++++------------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5b61c462e534..374cc7b260fc 100644
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
index 65fa2e41a9c0..ada50f5a15e4 100644
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
index 1baab07820f6..91cf709c98b3 100644
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
index a5b5bb99c644..212e65add951 100644
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
@@ -1084,7 +1078,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	rtnl_set_sk_err(net, RTNLGRP_NSID, err);
 }
 
-static int __init net_ns_init(void)
+void __init net_ns_init(void)
 {
 	struct net_generic *ng;
 
@@ -1105,6 +1099,9 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
+#ifdef CONFIG_KEYS
+	init_net.key_domain = &init_net_key_domain;
+#endif
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
@@ -1119,12 +1116,8 @@ static int __init net_ns_init(void)
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
2.34.1

