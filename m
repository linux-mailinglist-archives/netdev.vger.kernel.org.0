Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A862F91B9
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 11:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbhAQKYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 05:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbhAQKYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 05:24:15 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92829C061573;
        Sun, 17 Jan 2021 02:23:35 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id i63so1351603pfg.7;
        Sun, 17 Jan 2021 02:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+E4QJbI5ohbqhEdy8Ep8gmkZ7hLL7GgbwHKJKePuegA=;
        b=YXu6zAPsIcJQjmoZ5rrfjFyB0os9Q6ATLb5gkb5xQj7J/WSpcIK76V5PsYyFgs227a
         pvNkA9IIzIsfmxxsWHaZqKvL/1OSH/WHK4RAPBhu/UZ3sQUIfYbgSeZqiY24AINzWY7R
         FwzFhdzh7RGs/UDsXOkQfGfAYY950nm25UWQ7tL4DBTnOGacha9fpsHbmBIPxQXIGzdQ
         W4xHJxlCRIiGZtBHNriAMluRZsVn9Q2Fmd2ADGQqoU+Fd+coZWfdtDXi4El4aYmvu4I3
         QQm6UI1vozWVRJ7DhdANrTjCl9F5prnnWiFMPCwAbSgYukg+nU7Gnr8MbPjnokdrsdtP
         9seg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+E4QJbI5ohbqhEdy8Ep8gmkZ7hLL7GgbwHKJKePuegA=;
        b=QAqZwzR4MOdRyn4f4X09/bkoi562kZw6wHLhd69VvkvjZLHFH8kzcwfUVR84rVs7aI
         jILKUQWnV32afcJIKWRO3QxzSUBy903MZUjPI613BgxaopJN+1vtnA3DAef9ov7BI9Oe
         NyWKQABAlX8b+h/IW+8tyYlXh+sBDvNCHxz5eEUPxaR4gpxxFsAmrvo2e1tYMa+1OUc7
         id7aMGJ+4/gBT1OFeI0E61Iv4rw5dox8DEQkfhu3gGY3W8BbK04IHtsvhdIo6O9Jnuyu
         bpQ3vmzgye4QONab+hjlhiw9YaJEbJK0lCPz75cTSJhp9zoMj90EGvv1L9mrSlyqnUkG
         bSdQ==
X-Gm-Message-State: AOAM532fMy7xh2xI7Zi23LkpJngqndlFtXtDuD4a5gaKsptd6yZgG+OJ
        mA6LZHLE16Fpk2Eymw9Jvvm3ZuJIUHE=
X-Google-Smtp-Source: ABdhPJxO04dZ+FbJ0b9PEqhLexo+731nBggBj97OCieSmVMgrFDuqFtU9ElMu+wlzntyKOZdcEowyQ==
X-Received: by 2002:a63:5b1a:: with SMTP id p26mr21376893pgb.76.1610879015027;
        Sun, 17 Jan 2021 02:23:35 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id 72sm13307892pfw.177.2021.01.17.02.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 02:23:34 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, gnault@redhat.com, ast@kernel.org,
        nicolas.dichtel@6wind.com, ap420073@gmail.com, edumazet@google.com,
        pabeni@redhat.com, jakub@cloudflare.com, bjorn.topel@intel.com,
        keescook@chromium.org, viro@zeniv.linux.org.uk, rdna@fb.com,
        maheshb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
Date:   Sun, 17 Jan 2021 18:23:19 +0800
Message-Id: <20210117102319.193756-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

For now, sysctl_wmem_default and sysctl_rmem_default are globally
unified. It's not convenient in some case. For example, when we
use docker and try to control the default udp socket receive buffer
for each container.

For that reason, make sysctl_wmem_default and sysctl_rmem_default
per-namespace.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/net/netns/core.h   |  2 ++
 include/net/sock.h         |  3 ---
 net/core/net_namespace.c   |  2 ++
 net/core/sock.c            |  6 ++----
 net/core/sysctl_net_core.c | 32 ++++++++++++++++----------------
 net/ipv4/ip_output.c       |  2 +-
 6 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 36c2d998a43c..317b47df6d08 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -9,6 +9,8 @@ struct netns_core {
 	/* core sysctls */
 	struct ctl_table_header	*sysctl_hdr;
 
+	int sysctl_wmem_default;
+	int sysctl_rmem_default;
 	int	sysctl_somaxconn;
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/net/sock.h b/include/net/sock.h
index bdc4323ce53c..b846a6d24459 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2653,9 +2653,6 @@ extern __u32 sysctl_rmem_max;
 extern int sysctl_tstamp_allow_data;
 extern int sysctl_optmem_max;
 
-extern __u32 sysctl_wmem_default;
-extern __u32 sysctl_rmem_default;
-
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 2ef3b4557f40..eb4ea99131d6 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -374,6 +374,8 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
 static int __net_init net_defaults_init_net(struct net *net)
 {
+	net->core.sysctl_rmem_default = SK_RMEM_MAX;
+	net->core.sysctl_wmem_default = SK_WMEM_MAX;
 	net->core.sysctl_somaxconn = SOMAXCONN;
 	return 0;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd..2421e4ea1915 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -270,8 +270,6 @@ __u32 sysctl_wmem_max __read_mostly = SK_WMEM_MAX;
 EXPORT_SYMBOL(sysctl_wmem_max);
 __u32 sysctl_rmem_max __read_mostly = SK_RMEM_MAX;
 EXPORT_SYMBOL(sysctl_rmem_max);
-__u32 sysctl_wmem_default __read_mostly = SK_WMEM_MAX;
-__u32 sysctl_rmem_default __read_mostly = SK_RMEM_MAX;
 
 /* Maximal space eaten by iovec or ancillary data plus some space */
 int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
@@ -2970,8 +2968,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	timer_setup(&sk->sk_timer, NULL, 0);
 
 	sk->sk_allocation	=	GFP_KERNEL;
-	sk->sk_rcvbuf		=	sysctl_rmem_default;
-	sk->sk_sndbuf		=	sysctl_wmem_default;
+	sk->sk_rcvbuf		=	sock_net(sk)->core.sysctl_rmem_default;
+	sk->sk_sndbuf		=	sock_net(sk)->core.sysctl_wmem_default;
 	sk->sk_state		=	TCP_CLOSE;
 	sk_set_socket(sk, sock);
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 966d976dee84..5c1c75e42a09 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -326,22 +326,6 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_rcvbuf,
 	},
-	{
-		.procname	= "wmem_default",
-		.data		= &sysctl_wmem_default,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_sndbuf,
-	},
-	{
-		.procname	= "rmem_default",
-		.data		= &sysctl_rmem_default,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_rcvbuf,
-	},
 	{
 		.procname	= "dev_weight",
 		.data		= &weight_p,
@@ -584,6 +568,22 @@ static struct ctl_table netns_core_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.proc_handler	= proc_dointvec_minmax
 	},
+	{
+		.procname	= "wmem_default",
+		.data		= &init_net.core.sysctl_wmem_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_sndbuf,
+	},
+	{
+		.procname	= "rmem_default",
+		.data		= &init_net.core.sysctl_rmem_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_rcvbuf,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2ed0b01f72f0..0fbdcda6f314 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1709,7 +1709,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
-	sk->sk_sndbuf = sysctl_wmem_default;
+	sk->sk_sndbuf = sock_net(sk)->core.sysctl_wmem_default;
 	ipc.sockc.mark = fl4.flowi4_mark;
 	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
-- 
2.30.0

