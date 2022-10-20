Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83C2606C04
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJTXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:20:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD364FE922
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:20:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-369942dcdeeso4604377b3.0
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ga7C9SFxoP8tNRGtA4KzXfR9jtCt27KqRCZAhW7mvxQ=;
        b=rl30XmMbUM1FOJeH70TJWbg2DfjarNMJilvTGQJhsNjHQOE14ucidcajVOb8CMcC2h
         HGdo+xLCGl8fmlcIKp6uaxPrhNaSn55QWCiGLm6WYbHm8mkDMosTC2gRLiSggZMCI97j
         swkQO97LFcAe5CETCDJYX/JkMsmrOmA/STcHLRzMRXKhcE9RY+Wijm5KRocHUyZ2fh4u
         vmKTO3PKTF150TKXDwELQKPLvCUQSyuWV7YKA6SZImbPxQmLcwTATZ22BZ9mgWm/rac1
         EV+AkuqxL+vWIYolPFux3/VvYZNLRm27KdEzdiUuieMc4yCTD+M/P+mW5qNSLQP0uhQ8
         lx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ga7C9SFxoP8tNRGtA4KzXfR9jtCt27KqRCZAhW7mvxQ=;
        b=r8QBWDQf9E3Z4aezyzModgJmBLaaLvXTwyANHkdn53FG/sUFEKb/B04Tg6lWdGulLy
         2KV6JTCCHbdOXTFRZsLu840g1m4sdSXTgRGdJ5YCzJ6hZ9pO583LgOD92ofjQQCnnGsY
         79YvY9YJPu8l70V7OdNsC20cwh3E0hBHgQgQbaJ6Fnej4rDa9zkjiU2HYZ48nUYa/bIC
         YLsX10hGjLNTTiHbUKoS1Gv5YAiMUNVecycEj25fq8zAhbjuiJpwqwCFCLfz2NBjjXLU
         BQw1CqisvMLe/spzyJWPz8+DMRZ/5vIPB7QspelnPR+37Tv82J/goRDoEP3lkZ+7a4BD
         TFFA==
X-Gm-Message-State: ACrzQf3mGw1ZG73RtQmGZ9+wWv/sgbuv4u+Qeye5r6JZjYIi6t2jMe6/
        XbKsUSAQVsxSPvciFv3mPtGvQGEQTOtT2g==
X-Google-Smtp-Source: AMsMyM7EOZtmfpJJrzFj9jLU+cjvdByKNjj+cZfz62iP6goxa+8ohTp2PEGmJE0+CghhAGEsG7HyiV8646kGxw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:9e47:0:b0:361:468a:7221 with SMTP id
 n7-20020a819e47000000b00361468a7221mr14000586ywj.155.1666308021021; Thu, 20
 Oct 2022 16:20:21 -0700 (PDT)
Date:   Thu, 20 Oct 2022 23:20:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221020232018.3333414-1-edumazet@google.com>
Subject: [PATCH net-next] net: add a refcount tracker for kernel sockets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ffa84b5ffb37 ("net: add netns refcount tracker to struct sock")
added a tracker to sockets, but did not track kernel sockets.

We still have syzbot reports hinting about netns being destroyed
while some kernel TCP sockets had not been dismantled.

This patch tracks kernel sockets, and adds a ref_tracker_dir_print()
call to net_free() right before the netns is freed.

Normally, each layer is responsible for properly releasing its
kernel sockets before last call to net_free().

This debugging facility is enabled with CONFIG_NET_NS_REFCNT_TRACKER=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h | 30 ++++++++++++++++++++++--------
 net/core/net_namespace.c    |  5 +++++
 net/core/sock.c             | 14 ++++++++++++++
 net/netlink/af_netlink.c    | 11 +++++++++++
 net/rds/tcp.c               |  3 +++
 5 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 8c3587d5c308f048a3fbd681125f40ec86a00eb4..78beaa765c733665c035e99c5923334740a18770 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -92,7 +92,9 @@ struct net {
 
 	struct ns_common	ns;
 	struct ref_tracker_dir  refcnt_tracker;
-
+	struct ref_tracker_dir  notrefcnt_tracker; /* tracker for objects not
+						    * refcounted against netns
+						    */
 	struct list_head 	dev_base_head;
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
@@ -320,19 +322,31 @@ static inline int check_net(const struct net *net)
 #endif
 
 
-static inline void netns_tracker_alloc(struct net *net,
-				       netns_tracker *tracker, gfp_t gfp)
+static inline void __netns_tracker_alloc(struct net *net,
+					 netns_tracker *tracker,
+					 bool refcounted,
+					 gfp_t gfp)
 {
 #ifdef CONFIG_NET_NS_REFCNT_TRACKER
-	ref_tracker_alloc(&net->refcnt_tracker, tracker, gfp);
+	ref_tracker_alloc(refcounted ? &net->refcnt_tracker :
+				       &net->notrefcnt_tracker,
+			  tracker, gfp);
 #endif
 }
 
-static inline void netns_tracker_free(struct net *net,
-				      netns_tracker *tracker)
+static inline void netns_tracker_alloc(struct net *net, netns_tracker *tracker,
+				       gfp_t gfp)
+{
+	__netns_tracker_alloc(net, tracker, true, gfp);
+}
+
+static inline void __netns_tracker_free(struct net *net,
+					netns_tracker *tracker,
+					bool refcounted)
 {
 #ifdef CONFIG_NET_NS_REFCNT_TRACKER
-       ref_tracker_free(&net->refcnt_tracker, tracker);
+       ref_tracker_free(refcounted ? &net->refcnt_tracker :
+				     &net->notrefcnt_tracker, tracker);
 #endif
 }
 
@@ -346,7 +360,7 @@ static inline struct net *get_net_track(struct net *net,
 
 static inline void put_net_track(struct net *net, netns_tracker *tracker)
 {
-	netns_tracker_free(net, tracker);
+	__netns_tracker_free(net, tracker, true);
 	put_net(net);
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0ec2f5906a27c7f930e832835682d69a32e3c8e1..12c68edf768283e4f3ba74f0818618766c8f8d67 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -309,6 +309,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
 	refcount_set(&net->ns.count, 1);
 	ref_tracker_dir_init(&net->refcnt_tracker, 128);
+	ref_tracker_dir_init(&net->notrefcnt_tracker, 128);
 
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));
@@ -429,6 +430,10 @@ static void net_free(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
+
+		/* There should not be any trackers left there. */
+		ref_tracker_dir_exit(&net->notrefcnt_tracker);
+
 		kmem_cache_free(net_cachep, net);
 	}
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c0e44db1cfbaeb420f8b80ad7cf98..aa608dc0930b51ced01af4ff59ae5430da84dd9a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2094,6 +2094,9 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		if (likely(sk->sk_net_refcnt)) {
 			get_net_track(net, &sk->ns_tracker, priority);
 			sock_inuse_add(net, 1);
+		} else {
+			__netns_tracker_alloc(net, &sk->ns_tracker,
+					      false, priority);
 		}
 
 		sock_net_set(sk, net);
@@ -2149,6 +2152,9 @@ static void __sk_destruct(struct rcu_head *head)
 
 	if (likely(sk->sk_net_refcnt))
 		put_net_track(sock_net(sk), &sk->ns_tracker);
+	else
+		__netns_tracker_free(sock_net(sk), &sk->ns_tracker, false);
+
 	sk_prot_free(sk->sk_prot_creator, sk);
 }
 
@@ -2237,6 +2243,14 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	if (likely(newsk->sk_net_refcnt)) {
 		get_net_track(sock_net(newsk), &newsk->ns_tracker, priority);
 		sock_inuse_add(sock_net(newsk), 1);
+	} else {
+		/* Kernel sockets are not elevating the struct net refcount.
+		 * Instead, use a tracker to more easily detect if a layer
+		 * is not properly dismantling its kernel sockets at netns
+		 * destroy time.
+		 */
+		__netns_tracker_alloc(sock_net(newsk), &newsk->ns_tracker,
+				      false, priority);
 	}
 	sk_node_init(&newsk->sk_node);
 	sock_lock_init(newsk);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a662e8a5ff84a658e51d165e3a6da1e182ad6b38..f0c94d394ab194193a6c67b15ae6e700a6ffdf2d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -812,6 +812,17 @@ static int netlink_release(struct socket *sock)
 	}
 
 	sock_prot_inuse_add(sock_net(sk), &netlink_proto, -1);
+
+	/* Because struct net might disappear soon, do not keep a pointer. */
+	if (!sk->sk_net_refcnt && sock_net(sk) != &init_net) {
+		__netns_tracker_free(sock_net(sk), &sk->ns_tracker, false);
+		/* Because of deferred_put_nlk_sk and use of work queue,
+		 * it is possible  netns will be freed before this socket.
+		 */
+		sock_net_set(sk, &init_net);
+		__netns_tracker_alloc(&init_net, &sk->ns_tracker,
+				      false, GFP_KERNEL);
+	}
 	call_rcu(&nlk->rcu, deferred_put_nlk_sk);
 	return 0;
 }
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 4444fd82b66df7d54065893dc3d1aa02c3e2ef7c..c5b86066ff663f4250f2646b1eee80f9c7f30821 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -503,6 +503,9 @@ bool rds_tcp_tune(struct socket *sock)
 			release_sock(sk);
 			return false;
 		}
+		/* Update ns_tracker to current stack trace and refcounted tracker */
+		__netns_tracker_free(net, &sk->ns_tracker, false);
+
 		sk->sk_net_refcnt = 1;
 		netns_tracker_alloc(net, &sk->ns_tracker, GFP_KERNEL);
 		sock_inuse_add(net, 1);
-- 
2.38.0.135.g90850a2211-goog

