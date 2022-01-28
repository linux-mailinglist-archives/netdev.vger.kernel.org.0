Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABA49FCA1
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbiA1PRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242121AbiA1PRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:17:02 -0500
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51CAC061714;
        Fri, 28 Jan 2022 07:17:01 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id ECDAA2E126C;
        Fri, 28 Jan 2022 18:16:55 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id u7ORZg515c-GsHS93j1;
        Fri, 28 Jan 2022 18:16:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643383015; bh=nvIS+XjMM1FsEGmdhedLIjy6DcBqplNYuRUynacDwG4=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=eorY3pzvN3lNCBfZfOdQFDVGsCY2zaIvBb85UIwpFC/QoXzwNaaIqXzSN+sk/lA2N
         UVhnO6/4G6bJjmJXOOPXJYZzXdlyM+KlqkAUbpS3dlukiCwZc8QxDwwSsmOud9dffW
         KMTE0VRlbFCJys6SQhZ9MB40MUDDHDyF32Nbdyq4=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IrjHL3bpzz-GsIOSIEZ;
        Fri, 28 Jan 2022 18:16:54 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v3 1/4] txhash: Make rethinking txhash behavior configurable via sysctl
Date:   Fri, 28 Jan 2022 18:15:59 +0300
Message-Id: <20220128151602.2748-2-hmukos@yandex-team.ru>
In-Reply-To: <20220128151602.2748-1-hmukos@yandex-team.ru>
References: <20220128151602.2748-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a per ns sysctl that controls the txhash rethink behavior,
sk_rethink_txhash. When enabled, the same behavior is retained, when
disabled, rethink is not performed. Sysctl is enabled by default.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/core.h    |  1 +
 include/net/sock.h          | 34 +++++++++++++++++++++-------------
 include/uapi/linux/socket.h |  3 +++
 net/core/net_namespace.c    |  2 ++
 net/core/sysctl_net_core.c  | 14 ++++++++++++--
 5 files changed, 39 insertions(+), 15 deletions(-)

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
index c8496c1142c9..01491631b20e 100644
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
@@ -618,7 +627,8 @@ static __net_init int sysctl_core_net_init(struct net *net)
 		if (tbl == NULL)
 			goto err_dup;
 
-		tbl[0].data = &net->core.sysctl_somaxconn;
+		for (tmp = tbl; tmp->procname; tmp++)
+			tmp->data += (char *)net - (char *)&init_net;
 
 		/* Don't export any sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns) {
-- 
2.17.1

