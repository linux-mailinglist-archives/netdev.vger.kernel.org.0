Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43C14A0110
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344248AbiA1Toi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 14:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiA1Toh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 14:44:37 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E269C061714;
        Fri, 28 Jan 2022 11:44:37 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 6FF832E1A69;
        Fri, 28 Jan 2022 22:44:34 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id EI0HIYyCCB-iXHCj8PR;
        Fri, 28 Jan 2022 22:44:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643399074; bh=um1S0G9QsEs9DUcgMsjWQ0RIRIHZwre/TWy3edM7oqk=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=nHVkjNPJTj3ADue1SP1PMPSw/H0kbGySq8mB5HmaeWY82cwVm24BdfZXne6Weit/M
         BMpiV7x8b/9RBNj/2iCiWUjIKJBYcyuL+0WRs8oAVutOUIrH76hDbxLJWObYJMIYY6
         e81uZbQV0vBxJhjzMEF/EtNoB6I0ndAWo1OjyNVA=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id AubVxLDYQ9-iWIGklMG;
        Fri, 28 Jan 2022 22:44:33 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v4 1/5] txhash: Make rethinking txhash behavior configurable via sysctl
Date:   Fri, 28 Jan 2022 22:44:04 +0300
Message-Id: <20220128194408.17742-2-hmukos@yandex-team.ru>
In-Reply-To: <20220128194408.17742-1-hmukos@yandex-team.ru>
References: <20220128194408.17742-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a per ns sysctl that controls the txhash rethink behavior:
net.core.txrehash. When enabled, the same behavior is retained,
when disabled, rethink is not performed. Sysctl is enabled by default.

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
index 552bc25b1933..388244e315e7 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -10,6 +10,7 @@ struct netns_core {
 	struct ctl_table_header	*sysctl_hdr;
 
 	int	sysctl_somaxconn;
+	u8	sysctl_txrehash;
 
 #ifdef CONFIG_PROC_FS
 	struct prot_inuse __percpu *prot_inuse;
diff --git a/include/net/sock.h b/include/net/sock.h
index ff9b508d9c5f..0540e1b2aeb0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -587,6 +587,18 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
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
@@ -2054,10 +2066,18 @@ static inline void sk_set_txhash(struct sock *sk)
 
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
 
@@ -2704,18 +2724,6 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
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
index c53d9aab38ab..8711350085d6 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -364,6 +364,8 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_somaxconn = SOMAXCONN;
+	net->core.sysctl_txrehash = SOCK_TXREHASH_ENABLED;
+
 	return 0;
 }
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7b4d485aac7a..dbeb8ecbcd98 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -593,6 +593,15 @@ static struct ctl_table netns_core_table[] = {
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
 
@@ -611,7 +620,7 @@ __setup("fb_tunnels=", fb_tunnels_only_for_init_net_sysctl_setup);
 
 static __net_init int sysctl_core_net_init(struct net *net)
 {
-	struct ctl_table *tbl;
+	struct ctl_table *tbl, *tmp;
 
 	tbl = netns_core_table;
 	if (!net_eq(net, &init_net)) {
@@ -619,7 +628,8 @@ static __net_init int sysctl_core_net_init(struct net *net)
 		if (tbl == NULL)
 			goto err_dup;
 
-		tbl[0].data = &net->core.sysctl_somaxconn;
+		for (tmp = tbl; tmp->procname; tmp++)
+			tmp->data += (char *)net - (char *)&init_net;
 
 		/* Don't export any sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns) {
-- 
2.17.1

