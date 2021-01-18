Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391572FA350
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393136AbhAROlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393079AbhAROkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:40:42 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE218C061757;
        Mon, 18 Jan 2021 06:40:00 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t6so8764675plq.1;
        Mon, 18 Jan 2021 06:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+E4QJbI5ohbqhEdy8Ep8gmkZ7hLL7GgbwHKJKePuegA=;
        b=EmOF57qh1P24Ku69Mp8y35f5YGaulMCb6YAtFbrxa3oLsMrkGu9BGwfYmv7f+/7Qx4
         +YweOlHbM9JXaorJQemFn8aU9XJCBuplO2J/OIlEECh/Lmf+roz/SeYaJr6lMRw0Jnrv
         nhGPKPyjRZd/GYX4JNyG+SLq1yCs9oJf5TpL8CwCp4LYFOt1gLSeBrii5n+ibuEi8CSU
         ZK+81eCE6LUChSxYo5ODOzKiOg+lQNc23NVAgUBYhzM4eKUhu13LcvsxoP6AGhXH5NQP
         COZkgshkZt1jJJelYKDK3Fk3HuIOarULURDIbGQ66on4f2I6FBEgBR+5xq6H752UeMGK
         hVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+E4QJbI5ohbqhEdy8Ep8gmkZ7hLL7GgbwHKJKePuegA=;
        b=Vs/i9SNA7W6mjP1zmJMXeHNVPvPNvtxzSGSpg5/J0mS4PQYpibwk9diPVThtvVLH8u
         6oGSc6l0mf1AAkBLAHbw4sOr3fwt/kBQ/3cIROPtb+ZFnBKT95Pptt25qLet1htyfmY0
         5RMBh449Aul0OX/g8mrVexGBZpPnNC2h6WYCnMUEV2PZwXYfgW0tcR5pdevNMVJ32j9d
         JpZEdKOWzGDb7a+zj29ptop9xOehEPmvF7xSF/T15DXduHQ9rEH8RQRNdXD/ns2fcGQl
         XqfRGFodcuTpBNDhoWph5ekUDAhCbIyEnlUp0i2XiaHyCl095K0Dow4wKyV53Jd6QDYK
         6JTg==
X-Gm-Message-State: AOAM533PwpjxqgjbTYqFuz4TR7CiN11Kvi5ZJFHc6XlW9QVgLRNqmCj1
        oXHT+wSliH1VbI0Tu88nA/7nRegsTmw=
X-Google-Smtp-Source: ABdhPJzD+eRjNQx9jEE8HPszk/X0G+/mLUjDE8E8Yo2q9z7zLkPxUXbC55CKu0XUaMyAC0dUuBG8hA==
X-Received: by 2002:a17:90b:1014:: with SMTP id gm20mr21105510pjb.5.1610980800513;
        Mon, 18 Jan 2021 06:40:00 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id f29sm15906756pgm.76.2021.01.18.06.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 06:39:59 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org, christian.brauner@ubuntu.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
Date:   Mon, 18 Jan 2021 22:39:31 +0800
Message-Id: <20210118143932.56069-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118143932.56069-1-dong.menglong@zte.com.cn>
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
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

