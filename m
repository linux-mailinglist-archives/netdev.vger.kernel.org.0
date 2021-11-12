Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7944EC87
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhKLSWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:22:48 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:60312 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235265AbhKLSWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:22:47 -0500
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id D8CE62E1AA7;
        Fri, 12 Nov 2021 21:19:54 +0300 (MSK)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [2a02:6b8:c08:bd1e:0:640:7470:3316])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id foiYLd80Fd-JssaFwFF;
        Fri, 12 Nov 2021 21:19:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636741194; bh=fbQHbLuMsEQn9Dvgjn/pcSo68hFfp4QTWWtHkN1vGj4=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=wJmWyGOno9/5X4c+867tyOESHg9uehKEaal/CF6U+ZoO0PK0EhfAB6Z5Q1Czo6naz
         cS7DQjFMIJYCbYCA8P4HLe/bkxY5+bRhGPuL4tb/bDlog25r036DmF3qCfNNT5DyXR
         YaX8K1rJ0Jvq4WI+L+xjgF+CxhgojGgM1m+5doNE=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id vuM7zSALw5-JsxqK7aD;
        Fri, 12 Nov 2021 21:19:54 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     hmukos@yandex-team.ru
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v2 net-next 1/4] txhash: Make rethinking txhash behavior configurable via sysctl
Date:   Fri, 12 Nov 2021 21:19:36 +0300
Message-Id: <20211112181939.11329-2-hmukos@yandex-team.ru>
In-Reply-To: <20211112181939.11329-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a per ns sysctl that controls the txhash rethink behavior,
sk_rethink_txhash. When enabled, the same behavior is retained, when
disabled, rethink is not performed. Sysctl is enabled by default.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 include/net/netns/core.h    |  1 +
 include/net/sock.h          | 34 +++++++++++++++++++++-------------
 include/uapi/linux/socket.h |  3 +++
 net/core/net_namespace.c    |  2 ++
 net/core/sysctl_net_core.c  | 15 +++++++++++++--
 5 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 36c2d998a43c..00760e4efed7 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -10,6 +10,7 @@ struct netns_core {
 	struct ctl_table_header	*sysctl_hdr;
 
 	int	sysctl_somaxconn;
+	u8	sysctl_txrehash;
 
 #ifdef CONFIG_PROC_FS
 	int __percpu *sock_inuse;
diff --git a/include/net/sock.h b/include/net/sock.h
index 66a9a90f9558..cc83140d6502 100644
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
+	u8 rehash;
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
index a448a9b5bb2d..de7bf682092c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -359,6 +359,8 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_somaxconn = SOMAXCONN;
+	net->core.sysctl_txrehash = SOCK_TXREHASH_ENABLED;
+
 	return 0;
 }
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..f6194f04c06f 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -592,6 +592,15 @@ static struct ctl_table netns_core_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.proc_handler	= proc_dointvec_minmax
 	},
+	{
+		.procname	= "txrehash",
+		.data		= &init_net.core.sysctl_txrehash,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dou8vec_minmax,
+	},
 	{ }
 };
 
@@ -610,7 +619,7 @@ __setup("fb_tunnels=", fb_tunnels_only_for_init_net_sysctl_setup);
 
 static __net_init int sysctl_core_net_init(struct net *net)
 {
-	struct ctl_table *tbl;
+	struct ctl_table *tbl, *tmp;
 
 	tbl = netns_core_table;
 	if (!net_eq(net, &init_net)) {
@@ -618,7 +627,9 @@ static __net_init int sysctl_core_net_init(struct net *net)
 		if (tbl == NULL)
 			goto err_dup;
 
-		tbl[0].data = &net->core.sysctl_somaxconn;
+		for (tmp = tbl; tmp->procname; tmp++) {
+			tmp->data += (char *)net - (char *)&init_net;
+		}
 
 		/* Don't export any sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns) {
-- 
2.17.1

