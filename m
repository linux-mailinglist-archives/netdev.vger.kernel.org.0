Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6DB46AF72
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378794AbhLGAzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378808AbhLGAzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:39 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C24C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:10 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 8so11760336pfo.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9YQkC001jm5+AZXpQuowUVkY71S7JFvjcdhVqMkJ144=;
        b=IMDJwshWO0G6hmdZptDA5Pf9KiGahHJIPG38RGx4+BhX7FQWGPYiRYwBOGz+TrVz0W
         d5JFEYhRvNSYTH3l45nC5EYX0jLEpeXl7xfs9pfTI4Z74z71EO5Oey2m6MyOAwbyKrEH
         Ypf/Hmo59JMuklyJVzyKRRbS4HTd/QJNXehZCRH6WYRAnAYa2FiCETa0huDd+e+EcYsA
         rdMlpVuKJZ0lGDTR1S5lkKGn6rjPju4Y11w7C5k2xF8mRYI/RUNreooH2oKZb3X+2Ai/
         51xTrUN2BJ/I1GScT++oNyc5JLdDgj86LmZbio3ISolGM+mgDcZQOoogr7eTGY4mRuDl
         HEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9YQkC001jm5+AZXpQuowUVkY71S7JFvjcdhVqMkJ144=;
        b=Jtxf7Gz+l0kRtsFSg9usOR+0HEN5z0PSza//61QSyc3Px09TCwldCKPTajMJUaz7Ja
         N4z7ojNAb8k2rXjn+ICwRhBOSb8OV/Pv6iA3dasHnSqdHGBBkyRTihPqjo+XH1Je3Dmq
         Nf2x3tALc0xaeFuRfLQIxJY8JufX1+UKpl3SoW1/U6lZyA0umUGZMAacFngycf2mxzKo
         DlZmIb+ma8O4QHK9XeRe9GxK9YKaJ/3FDfSHrwJODAXdArtEgllNsSgp58EvkgHg2GPO
         7LwAYG8MCbWk34YaQaUtqpdEVlzhvKlNczX+Ytr6j02bTsWdEXD/AfqGbY5xTGPuJhzq
         1ovQ==
X-Gm-Message-State: AOAM530xfij1Znf72/zA8dyfiYcvq1T9MySVk0rhJFGlS4fmEOjv4dyC
        HQsWzI5Pc+2bhUQCqVO+3qDGUH3kMNY=
X-Google-Smtp-Source: ABdhPJypKphAXfR0KJfNaojyjVYAJetINVvButfeLTPEvpyOfh1yMrDA+jAL5/mYsUJKVzZNZKTFPQ==
X-Received: by 2002:a63:e256:: with SMTP id y22mr6729166pgj.72.1638838329826;
        Mon, 06 Dec 2021 16:52:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 12/17] net: initialize init_net earlier
Date:   Mon,  6 Dec 2021 16:51:37 -0800
Message-Id: <20211207005142.1688204-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While testing the following patch in the series
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

Note that this following patchn in the series ("vfs: add netns refcount tracker
to struct fs_context") also will need net_ns_init() being called
before vfs_caches_init()

This saves around 4KB in .data section.

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
index bb984ed79de0ea49b9a298c209c0c2f7e6f70941..cb68bc48a682c73340ceca28c2ba02fac1dda09d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -99,6 +99,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <net/net_namespace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1113,6 +1114,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	key_init();
 	security_init();
 	dbg_late_init();
+	net_ns_init();
 	vfs_caches_init();
 	pagecache_init();
 	signals_init();
diff --git a/net/core/dev.c b/net/core/dev.c
index 4420086f3aeb34614fc8222206dff2b2caa31d02..2ee7c87aa2ec8638131169d73a3ec699d5b292b3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10720,8 +10720,7 @@ static int __net_init netdev_init(struct net *net)
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
 		     8 * sizeof_field(struct napi_struct, gro_bitmask));
 
-	if (net != &init_net)
-		INIT_LIST_HEAD(&net->dev_base_head);
+	INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b7171c40434985b869c1477975fc75447d78c3b..3ea5321430ee21af687510917da9b9aea5154e12 100644
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
@@ -1082,7 +1076,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	rtnl_set_sk_err(net, RTNLGRP_NSID, err);
 }
 
-static int __init net_ns_init(void)
+void __init net_ns_init(void)
 {
 	struct net_generic *ng;
 
@@ -1103,6 +1097,9 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
+#ifdef CONFIG_KEYS
+	init_net.key_domain = &init_net_key_domain;
+#endif
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
@@ -1117,12 +1114,8 @@ static int __init net_ns_init(void)
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
2.34.1.400.ga245620fadb-goog

