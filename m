Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3005316951
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhBJOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhBJOma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:42:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9AEC061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:41:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k22so1312374pll.6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MT7keg16HOD7Yj8F6crKSCJLg5paz35PgZJDP/CvKvw=;
        b=HztgfDSA+Jc/RGjvO34xfwKKAoHcgSxEQP5suNZKtGwdkKJaEyJmJ0BU+6Xe5FOrx4
         4EzEtVFyZeyr6V6ZPRl0TGjq0dghFtkVkei3DIsUfoukleJnVDQe3SzUrCBeW/tBVDHm
         q72FGW1F32T4lDHrJGn0HItCcXja9FuF+/ZZ3fzvJKG4jdIdVBVya7l498sJ03RjNYJE
         DOoPopRI27te7okhX/r5PN8K34YkpU2SveuLIr+jkHtj2/uUOxEsMiS5gQFgr64IzrqX
         Ciace1KunyyxxSLsHODdnZIuF+tdWjiEdI4TNqass3hQPxiopFbmWwHYZ2ub0cgXhssC
         jRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MT7keg16HOD7Yj8F6crKSCJLg5paz35PgZJDP/CvKvw=;
        b=DkCXHqqD64fQUj00luVfgI7NUiMWRnH1YY20gyZ7WpJqsmN3Ps4WCmN6Ps2jCxDISk
         XqnJO8Lo85EVSmKJAoKXuofwXFkSeNDxUwYLMqwF7+19SyXJpgG6XMQDqBEl8BSrdfox
         2CtRT9OsFhZ7W+IxNqy0PrQKSYGbM3cOdS35VNMQ3dfQ8DVlJB3EEBd0QkMhBD1/OAM8
         6276+HwhNS+uPLM+BCUNPY6f86iVBCHQJKTFsDmiNkFhSxIJD1UEdWqpT9xdYFe5yRFF
         hfAy6hykCta+FBNt5AmGW4W1+NuX8ahUgMQMPSwWSiOyWaLNOOaH9uoCQPpN2PgvZQxD
         Obow==
X-Gm-Message-State: AOAM5334bRVQX4yxed8654xXlxkfKc/ET1NO48MsmG2OipZjEWRtAsc2
        9iaXNqOXvk+SlismVjG5eg4=
X-Google-Smtp-Source: ABdhPJy8reKmE/Su8t7v2/7QDDtYVPZGcFiEhBna3sScZANCzPSlcNLlMQ3zouP2BVNy2klZekKgLA==
X-Received: by 2002:a17:902:d510:b029:e1:1040:3726 with SMTP id b16-20020a170902d510b02900e110403726mr3182410plg.59.1612968109026;
        Wed, 10 Feb 2021 06:41:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:48d8:4083:5be:90d7])
        by smtp.gmail.com with ESMTPSA id bk12sm2466873pjb.1.2021.02.10.06.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 06:41:48 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH net-next] net: initialize net->net_cookie at netns setup
Date:   Wed, 10 Feb 2021 06:41:44 -0800
Message-Id: <20210210144144.24284-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It is simpler to make net->net_cookie a plain u64
written once in setup_net() instead of looping
and using atomic64 helpers.

Lorenz Bauer wants to add SO_NETNS_COOKIE socket option
and this patch would makes his patch series simpler.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
---
 include/net/net_namespace.h |  4 +---
 net/core/filter.c           |  8 +++-----
 net/core/net_namespace.c    | 19 +++----------------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 29567875f4280116200f0676d6d619f3d9b46279..dcaee24a4d8773ff3bb2adbe5fe9136dfc186184 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -165,7 +165,7 @@ struct net {
 	struct netns_xfrm	xfrm;
 #endif
 
-	atomic64_t		net_cookie; /* written once */
+	u64			net_cookie; /* written once */
 
 #if IS_ENABLED(CONFIG_IP_VS)
 	struct netns_ipvs	*ipvs;
@@ -224,8 +224,6 @@ extern struct list_head net_namespace_list;
 struct net *get_net_ns_by_pid(pid_t pid);
 struct net *get_net_ns_by_fd(int fd);
 
-u64 __net_gen_cookie(struct net *net);
-
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
 void ipx_unregister_sysctl(void);
diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d66059702a7417ab844d4e8e5f4732c7..74bd401bf483d212884a026599167c1098e78d28 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4645,11 +4645,9 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 
 static u64 __bpf_get_netns_cookie(struct sock *sk)
 {
-#ifdef CONFIG_NET_NS
-	return __net_gen_cookie(sk ? sk->sk_net.net : &init_net);
-#else
-	return 0;
-#endif
+	const struct net *net = sk ? sock_net(sk) : &init_net;
+
+	return net->net_cookie;
 }
 
 BPF_CALL_1(bpf_get_netns_cookie_sock, struct sock *, ctx)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 2ef3b4557f40d72d27a1642d98f1e8f06caf9835..43b6ac4c44395b55c966f3fb9141c25bb91848cf 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -72,18 +72,6 @@ static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
 
 DEFINE_COOKIE(net_cookie);
 
-u64 __net_gen_cookie(struct net *net)
-{
-	while (1) {
-		u64 res = atomic64_read(&net->net_cookie);
-
-		if (res)
-			return res;
-		res = gen_cookie_next(&net_cookie);
-		atomic64_cmpxchg(&net->net_cookie, 0, res);
-	}
-}
-
 static struct net_generic *net_alloc_generic(void)
 {
 	struct net_generic *ng;
@@ -332,6 +320,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	refcount_set(&net->ns.count, 1);
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));
+	preempt_disable();
+	net->net_cookie = gen_cookie_next(&net_cookie);
+	preempt_enable();
 	net->dev_base_seq = 1;
 	net->user_ns = user_ns;
 	idr_init(&net->netns_ids);
@@ -1103,10 +1094,6 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
-	preempt_disable();
-	__net_gen_cookie(&init_net);
-	preempt_enable();
-
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
-- 
2.30.0.478.g8a0d178c01-goog

