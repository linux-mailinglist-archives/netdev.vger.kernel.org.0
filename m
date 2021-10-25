Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD25A43A4CF
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhJYUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhJYUkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:40:02 -0400
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21CAC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:37:39 -0700 (PDT)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id C4F1E2E0A48;
        Mon, 25 Oct 2021 23:36:00 +0300 (MSK)
Received: from sas1-db2fca0e44c8.qloud-c.yandex.net (2a02:6b8:c14:6696:0:640:db2f:ca0e [2a02:6b8:c14:6696:0:640:db2f:ca0e])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id B8JdgfHxYw-a0uGKj2J;
        Mon, 25 Oct 2021 23:36:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635194160; bh=WlLFkdH6tdC5Oeb4p1XrKjxae/DSwrs7TFmxiGB/0TM=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=BM0EjfeitIoB9UFSX+AK+vmTWYJqe0qBpHRyLj5yPe60AXEpkSss6lwjq+9I6RQix
         2tXZsqT4S5ABkr9u5lld/yaFXEl59jeHtAhdXhuNJwOfqXx9cejzfE1QdkVV3iTlh+
         I7Ot8t6bJaOGeyyDh/mDMq9TCAM9+VbjvYHddAo8=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (2a02:6b8:c07:895:0:696:abd4:0 [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-db2fca0e44c8.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id mklMLk28bQ-a00afUx6;
        Mon, 25 Oct 2021 23:36:00 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, tom@herbertland.com,
        mitradir@yandex-team.ru, zeil@yandex-team.ru, hmukos@yandex-team.ru
Subject: [RFC PATCH net-next 1/4] txhash: Make rethinking txhash behavior configurable via sysctl
Date:   Mon, 25 Oct 2021 23:35:18 +0300
Message-Id: <20211025203521.13507-2-hmukos@yandex-team.ru>
In-Reply-To: <20211025203521.13507-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a per ns sysctl that controls the txhash rethink behavior,
sk_rethink_txhash. When enabled, the same behavior is retained, when
disabled, rethink is not performed. Sysctl is disabled by default.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 include/net/netns/core.h    |  2 ++
 include/net/sock.h          | 34 +++++++++++++++++++++-------------
 include/uapi/linux/socket.h |  3 +++
 net/core/net_namespace.c    |  3 +++
 net/core/sysctl_net_core.c  |  7 +++++++
 5 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 36c2d998a43c..177980b46ed7 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -11,6 +11,8 @@ struct netns_core {
 
 	int	sysctl_somaxconn;
 
+	unsigned int sysctl_txrehash;
+
 #ifdef CONFIG_PROC_FS
 	int __percpu *sock_inuse;
 	struct prot_inuse __percpu *prot_inuse;
diff --git a/include/net/sock.h b/include/net/sock.h
index 66a9a90f9558..d8a73edb1629 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -577,6 +577,18 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 			   __tmp | SK_USER_DATA_NOCOPY);		\
 })
 
+static inline
+struct net *sock_net(const struct sock *sk)
+{
+	return read_pnet(&sk->sk_net);
+}
+
+static inline
+void sock_net_set(struct sock *sk, struct net *net)
+{
+	write_pnet(&sk->sk_net, net);
+}
+
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
  * or not whether his port will be reused by someone else. SK_FORCE_REUSE
@@ -1942,10 +1954,18 @@ static inline void sk_set_txhash(struct sock *sk)
 
 static inline bool sk_rethink_txhash(struct sock *sk)
 {
-	if (sk->sk_txhash) {
+	unsigned int rehash;
+
+	if (!sk->sk_txhash)
+		return false;
+
+	rehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
+
+	if (rehash) {
 		sk_set_txhash(sk);
 		return true;
 	}
+
 	return false;
 }
 
@@ -2596,18 +2616,6 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static inline
-struct net *sock_net(const struct sock *sk)
-{
-	return read_pnet(&sk->sk_net);
-}
-
-static inline
-void sock_net_set(struct sock *sk, struct net *net)
-{
-	write_pnet(&sk->sk_net, net);
-}
-
 static inline bool
 skb_sk_is_prefetched(struct sk_buff *skb)
 {
diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index eb0a9a5b6e71..0accd6102ece 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,4 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
+#define SOCK_TXREHASH_DISABLED	0
+#define SOCK_TXREHASH_ENABLED	1
+
 #endif /* _UAPI_LINUX_SOCKET_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a448a9b5bb2d..0d833b861f00 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -359,6 +359,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_somaxconn = SOMAXCONN;
+
+	net->core.sysctl_txrehash = SOCK_TXREHASH_DISABLED;
+
 	return 0;
 }
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..34144abbb6a0 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -592,6 +592,13 @@ static struct ctl_table netns_core_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.proc_handler	= proc_dointvec_minmax
 	},
+	{
+		.procname	= "txrehash",
+		.data		= &init_net.core.sysctl_txrehash,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{ }
 };
 
-- 
2.17.1

