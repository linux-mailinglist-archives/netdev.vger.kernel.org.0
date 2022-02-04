Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEBA4AA46E
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348740AbiBDXiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiBDXiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:38:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02FE022EBF
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:38:13 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so7508890pjb.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 15:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yw/ERKNo/KnGo1oNnb5gwvuJdNDxfPy9ncBi8+mXk1g=;
        b=G8ihuitmOh2IgrvecWg1SFPptyDbEI0qtiJ9zBejkRrGTZXkoJrWZ0/j+diWbkGwyX
         guC3ayBNZYffdUXgbbsdxszYVWqPE31tMmiClrD73hQSLKCde7/lgrWDz+7cc7T1WYe7
         I7fQElMz/gYE5EMdfYY83OOfHHBfFQiqVm10iJVf8vdqNGRdxfuTXQo8tg1IhMrKQYNl
         jxP1Fi21bkmNi4nxKLJiKd4xgCqNRsPXDeB1fduiZKcNdW1O6bjo+Z+HRXw4x9y1R3cd
         kyyS3VJ6CrC9qJjpSP7xI+9lcLo4qF1LfsgimoCRVc6/Y+EAmjo+6lYNYopEBP73YC+e
         5acQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yw/ERKNo/KnGo1oNnb5gwvuJdNDxfPy9ncBi8+mXk1g=;
        b=lehjNC8vAglBCb3HPaRMCRr5nD5COFc8sdiTG0xwCZrCQ+Z/WWXOQLQpP6drpTv4Vd
         asD+WdmR4XjdIKMheTpso7apGk0hLIAAO2/Z5LgVlHu8dzTbeJ7UVNjwNPAJP++JK0Ms
         Met85hYOOjr/u9HfQ9sIyECUGgU7c6SAS8HFRkBeG0+kzI/EIIuOyJMOcS0z7FJtLPhN
         cUEgUgKH8bERS0h8TuIRBSmjM4IZmHx9aoBU1hzzeNjQxpF18vFHVi/kf51ZwpaWmGJs
         KYKKVOyxV42Pk8xiaDKWvQ3ZDvADf6xanmSJszYRp9gIRH7UqDgJ1luO9EZ5qXhYUzVx
         /oBA==
X-Gm-Message-State: AOAM531Oh3XLlnbv+kcyr7kFIAzW9ogR2OGvD4HCeNpw9hjnOs4k2RPO
        afwWKwS4dv9w7G6f+JeNj/E=
X-Google-Smtp-Source: ABdhPJxyqTdcDGxBOeuQs6WNh1WcnXbcDI0kCwLI54w7oyfPMaTzcZNL4PgAxk37SqsbGHWjlUl7Bw==
X-Received: by 2002:a17:902:ecc5:: with SMTP id a5mr5782506plh.54.1644017893204;
        Fri, 04 Feb 2022 15:38:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id 16sm13810029pje.34.2022.02.04.15.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 15:38:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: initialize init_net earlier
Date:   Fri,  4 Feb 2022 15:38:09 -0800
Message-Id: <20220204233809.3082403-1-eric.dumazet@gmail.com>
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h |  6 ++++++
 init/main.c                 |  2 ++
 net/core/dev.c              |  3 +--
 net/core/net_namespace.c    | 17 +++++------------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5b61c462e534be468c81d2b0f4ef586b209dd4b8..2ecbd7c11c88e016b1a6a450f07ee2cd94048f62 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -513,4 +513,10 @@ static inline void fnhe_genid_bump(struct net *net)
 	atomic_inc(&net->fnhe_genid);
 }
 
+#ifdef CONFIG_NET
+void net_ns_init(void);
+#else
+static inline net_ns_init(void) {}
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

