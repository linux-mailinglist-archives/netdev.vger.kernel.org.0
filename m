Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC68D499C16
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577223AbiAXV7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456643AbiAXVjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60C1C0419C0
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:14 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id h5so8746987pfv.13
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6CydK47Ky2gdeZ9+T+LmQeSomVA0WgcQeU/YTKDdi8s=;
        b=jYzcYUqib3aKPT93H/ctey0ingTEMyOMa5/LbyTPBGOe7eP8fdf47cDW0+bMpSxhzn
         L0CU7czQAanHqE7PpQA4PuNqkKp36q9qnadsWZVMnfAnZxqujK3YhRjqYDmBJD8LWsaU
         HVQREReCnhLOjvZPKlEBQBXMY6vJ+BhVSwyhckiqrWeWkrm9ABCx/S8h1C/NeRJRkuJe
         UI+pzo5JNBOergWK4wrNYUyMBcA58A8iDxR6Bq06oKI2raLRSELmTA1Jyg0h0hA6zouA
         ou+UDhDlwL5Mv/o17sKf3Ef5QAVDNDp/BatOdzrgt1xj1LKb/YWjHzmJBLLlC3dFhD+G
         367Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6CydK47Ky2gdeZ9+T+LmQeSomVA0WgcQeU/YTKDdi8s=;
        b=5aqahau96XvQcyskuUKLafXiGpk6Zm0ql2AaTiMLlOyoiiAvl+Cx0IseS0jrwe+/Kq
         jMH5COcCnrdSw7twnUWi0y+1EBw7BZAiao/Iq1a30t8eDmFwiUupLnEj55ke9cZ3EuJl
         8aasS8ckTzEb4YRFXdssA6X4WSGWoDsDtJPPdq9aGWYMoAY77hKdXxYilD51uaT1Pszz
         nRAsHVM/qSKTwMELAPOxheC6YxjP7unTcJs1YwLD4FcpfDvT9vtqBnsUNDSXZRO33f62
         yFTqf8kvp0hbbVw3HRiLtKpnFKaMzN1csUE1Pd5uanoXwQSvIgZ/Z6TW2fmDT4AXYgSy
         W/9Q==
X-Gm-Message-State: AOAM530zRZONHUPpJVS/GhyhwzF6JJY0pzJMlBWkW/xAw56da8hy51e9
        MRP0LPZhBR+m36urBCDXnIg=
X-Google-Smtp-Source: ABdhPJxGTSj4Eihgh3PbLQO9jLOVDi3IAAS6NCn8lncnZ96ZIzulOQd1US8e9YehsZIJfSMy+40Vvw==
X-Received: by 2002:a63:120b:: with SMTP id h11mr12715676pgl.611.1643055914282;
        Mon, 24 Jan 2022 12:25:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/6] ipv6: do not use per netns icmp sockets
Date:   Mon, 24 Jan 2022 12:24:56 -0800
Message-Id: <20220124202457.3450198-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Back in linux-2.6.25 (commit 98c6d1b261e7 "[NETNS]: Make icmpv6_sk per namespace.",
we added private per-cpu/per-netns ipv6 icmp sockets.

This adds memory and cpu costs, which do not seem needed.
Now typical servers have 256 or more cores, this adds considerable
tax to netns users.

icmp sockets are used from BH context, are not receiving packets,
and do not store any persistent state but the 'struct net' pointer.

icmpv6_xmit_lock() already makes sure to lock the chosen per-cpu
socket.

This patch has a considerable impact on the number of netns
that the worker thread in cleanup_net() can dismantle per second,
because ip6mr_sk_done() is no longer called, meaning we no longer
acquire the rtnl mutex, competing with other threads adding new netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv6.h |  1 -
 net/ipv6/icmp.c          | 62 +++++++---------------------------------
 2 files changed, 10 insertions(+), 53 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a4b55038031652601444e46006c489a4e23b0ab7..30cdfc4e1615424b1c691b53499a1987d7fd0496 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -88,7 +88,6 @@ struct netns_ipv6 {
 	struct fib6_table       *fib6_local_tbl;
 	struct fib_rules_ops    *fib6_rules_ops;
 #endif
-	struct sock * __percpu	*icmp_sk;
 	struct sock             *ndisc_sk;
 	struct sock             *tcp_sk;
 	struct sock             *igmp_sk;
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 96c5cc0f30cebb02280a8384e34234701989f0d6..e6b978ea0e87fe595121a977d2030a308437eff3 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -69,17 +69,7 @@
 
 #include <linux/uaccess.h>
 
-/*
- *	The ICMP socket(s). This is the most convenient way to flow control
- *	our ICMP output as well as maintain a clean interface throughout
- *	all layers. All Socketless IP sends will soon be gone.
- *
- *	On SMP we have one ICMP socket per-cpu.
- */
-static struct sock *icmpv6_sk(struct net *net)
-{
-	return this_cpu_read(*net->ipv6.icmp_sk);
-}
+static DEFINE_PER_CPU(struct sock *, ipv6_icmp_sk);
 
 static int icmpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		       u8 type, u8 code, int offset, __be32 info)
@@ -110,11 +100,11 @@ static const struct inet6_protocol icmpv6_protocol = {
 };
 
 /* Called with BH disabled */
-static __inline__ struct sock *icmpv6_xmit_lock(struct net *net)
+static struct sock *icmpv6_xmit_lock(struct net *net)
 {
 	struct sock *sk;
 
-	sk = icmpv6_sk(net);
+	sk = this_cpu_read(ipv6_icmp_sk);
 	if (unlikely(!spin_trylock(&sk->sk_lock.slock))) {
 		/* This can happen if the output path (f.e. SIT or
 		 * ip6ip6 tunnel) signals dst_link_failure() for an
@@ -122,11 +112,13 @@ static __inline__ struct sock *icmpv6_xmit_lock(struct net *net)
 		 */
 		return NULL;
 	}
+	sock_net_set(sk, net);
 	return sk;
 }
 
-static __inline__ void icmpv6_xmit_unlock(struct sock *sk)
+static void icmpv6_xmit_unlock(struct sock *sk)
 {
+	sock_net_set(sk, &init_net);
 	spin_unlock(&sk->sk_lock.slock);
 }
 
@@ -1034,59 +1026,27 @@ void icmpv6_flow_init(struct sock *sk, struct flowi6 *fl6,
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 }
 
-static void __net_exit icmpv6_sk_exit(struct net *net)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv6.icmp_sk, i));
-	free_percpu(net->ipv6.icmp_sk);
-}
-
-static int __net_init icmpv6_sk_init(struct net *net)
+int __init icmpv6_init(void)
 {
 	struct sock *sk;
 	int err, i;
 
-	net->ipv6.icmp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv6.icmp_sk)
-		return -ENOMEM;
-
 	for_each_possible_cpu(i) {
 		err = inet_ctl_sock_create(&sk, PF_INET6,
-					   SOCK_RAW, IPPROTO_ICMPV6, net);
+					   SOCK_RAW, IPPROTO_ICMPV6, &init_net);
 		if (err < 0) {
 			pr_err("Failed to initialize the ICMP6 control socket (err %d)\n",
 			       err);
-			goto fail;
+			return err;
 		}
 
-		*per_cpu_ptr(net->ipv6.icmp_sk, i) = sk;
+		per_cpu(ipv6_icmp_sk, i) = sk;
 
 		/* Enough space for 2 64K ICMP packets, including
 		 * sk_buff struct overhead.
 		 */
 		sk->sk_sndbuf = 2 * SKB_TRUESIZE(64 * 1024);
 	}
-	return 0;
-
- fail:
-	icmpv6_sk_exit(net);
-	return err;
-}
-
-static struct pernet_operations icmpv6_sk_ops = {
-	.init = icmpv6_sk_init,
-	.exit = icmpv6_sk_exit,
-};
-
-int __init icmpv6_init(void)
-{
-	int err;
-
-	err = register_pernet_subsys(&icmpv6_sk_ops);
-	if (err < 0)
-		return err;
 
 	err = -EAGAIN;
 	if (inet6_add_protocol(&icmpv6_protocol, IPPROTO_ICMPV6) < 0)
@@ -1101,14 +1061,12 @@ int __init icmpv6_init(void)
 	inet6_del_protocol(&icmpv6_protocol, IPPROTO_ICMPV6);
 fail:
 	pr_err("Failed to register ICMP6 protocol\n");
-	unregister_pernet_subsys(&icmpv6_sk_ops);
 	return err;
 }
 
 void icmpv6_cleanup(void)
 {
 	inet6_unregister_icmp_sender(icmp6_send);
-	unregister_pernet_subsys(&icmpv6_sk_ops);
 	inet6_del_protocol(&icmpv6_protocol, IPPROTO_ICMPV6);
 }
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

