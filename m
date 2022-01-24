Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318D3499C17
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577238AbiAXV7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456636AbiAXVjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82081C0BD13F
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:12 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so273351pja.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Sf7XHeE7RTjlHyr1j7U5Y5D0po4rkD6i9I7tZP+8yQ=;
        b=jougAziTOAZP44kUPaEOuMNHww6BROUpwo2FuuLzXFSDJGxeHK9PxiuefsBUozo1L9
         7I3fqCZLJ0Kye+wXsA0zS5P7EEq7sF/sCB8lAG8bJcQ94+hNEHQGeoTub7o6zXMbuY9F
         FaamggLUg+IC9NPWfA7pIB55C1Qj+ulskhGM1273/4/gFxplK0KUD+gM19w2Q9+ihQA5
         eIt0dHQayEGpge47cIzlT0rXNHXhrSzczoZ3gfY02VKALiC/G6R0w8iDjEp2CVIo7gzY
         hW8LpOAXhQeANHp8U+mjVqBEpwKShhNwPq6yrlOYqPFXMHSAlwB5EyNlvhdqtyjwvrLU
         LQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Sf7XHeE7RTjlHyr1j7U5Y5D0po4rkD6i9I7tZP+8yQ=;
        b=BFW0IeOp35wr1DAjJ3PadX/h5ZkuRUBpM6y5fd2WcikZrEFm9Vc3Bd9zJ6AcH6+6Mi
         AAlPStWAtIKMycvQltJB+H/KcHPb2dyB/bgrhrNQItIJgrLeCuhChlDNR6PCp3n7SbhS
         yM/62zJ4lYi2M6Xw9veXZ3jcenA6qzbbhet+iqW343RB0JRbu3gn5ZI37JwXa7WbB/o7
         zYaUALbY586W8i2RxoLc/sUtEupErG+5x93kkwGKxcZSFZC3A4m5ZzihwtBZw7a/xgJN
         GsxP1PyAioNxnOhyhqo+kw+wxQCaQN3M6mAdsqFgApxJJOO2aYwxjEDlGmyJ2jIaF9Vt
         ZHkQ==
X-Gm-Message-State: AOAM533xyrk5lXmFnWFsg8D+8uLSVzphRLsEs1H7Pnz96uhjJ/BOtbie
        AeB+4T4uFQ0fWJcxd8/LSD0=
X-Google-Smtp-Source: ABdhPJzAReoOvbtyn1MpZxqSFylkebY9id2D+0pi5/XnCGiac+s11FtKTkBfw45u/15eJl4wKOkROw==
X-Received: by 2002:a17:902:a50f:b0:149:bc1a:2c98 with SMTP id s15-20020a170902a50f00b00149bc1a2c98mr15744317plq.35.1643055912012;
        Mon, 24 Jan 2022 12:25:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/6] ipv4: do not use per netns icmp sockets
Date:   Mon, 24 Jan 2022 12:24:55 -0800
Message-Id: <20220124202457.3450198-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Back in linux-2.6.25 (commit 4a6ad7a141cb "[NETNS]: Make icmp_sk per namespace."),
we added private per-cpu/per-netns ipv4 icmp sockets.

This adds memory and cpu costs, which do not seem needed.
Now typical servers have 256 or more cores, this adds considerable
tax to netns users.

icmp sockets are used from BH context, are not receiving packets,
and do not store any persistent state but the 'struct net' pointer.

icmp_xmit_lock() already makes sure to lock the chosen per-cpu
socket.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h |  1 -
 net/ipv4/icmp.c          | 91 ++++++++++++++--------------------------
 2 files changed, 31 insertions(+), 61 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 78557643526e23985af5695b54076a399e5c9548..639a31638159b23e7ec1d16f621a7953b885729c 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -70,7 +70,6 @@ struct netns_ipv4 {
 	struct hlist_head	*fib_table_hash;
 	struct sock		*fibnl;
 
-	struct sock  * __percpu	*icmp_sk;
 	struct sock		*mc_autojoin_sk;
 
 	struct inet_peer_base	*peers;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b7e277d8a84d224cb9c034321e688d765d01c07f..72a375c7f4172d92af61eb9b5eb7da29b551b663 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -192,24 +192,14 @@ struct icmp_control {
 
 static const struct icmp_control icmp_pointers[NR_ICMP_TYPES+1];
 
-/*
- *	The ICMP socket(s). This is the most convenient way to flow control
- *	our ICMP output as well as maintain a clean interface throughout
- *	all layers. All Socketless IP sends will soon be gone.
- *
- *	On SMP we have one ICMP socket per-cpu.
- */
-static struct sock *icmp_sk(struct net *net)
-{
-	return this_cpu_read(*net->ipv4.icmp_sk);
-}
+static DEFINE_PER_CPU(struct sock *, ipv4_icmp_sk);
 
 /* Called with BH disabled */
 static inline struct sock *icmp_xmit_lock(struct net *net)
 {
 	struct sock *sk;
 
-	sk = icmp_sk(net);
+	sk = this_cpu_read(ipv4_icmp_sk);
 
 	if (unlikely(!spin_trylock(&sk->sk_lock.slock))) {
 		/* This can happen if the output path signals a
@@ -217,11 +207,13 @@ static inline struct sock *icmp_xmit_lock(struct net *net)
 		 */
 		return NULL;
 	}
+	sock_net_set(sk, net);
 	return sk;
 }
 
 static inline void icmp_xmit_unlock(struct sock *sk)
 {
+	sock_net_set(sk, &init_net);
 	spin_unlock(&sk->sk_lock.slock);
 }
 
@@ -363,14 +355,13 @@ static int icmp_glue_bits(void *from, char *to, int offset, int len, int odd,
 	return 0;
 }
 
-static void icmp_push_reply(struct icmp_bxm *icmp_param,
+static void icmp_push_reply(struct sock *sk,
+			    struct icmp_bxm *icmp_param,
 			    struct flowi4 *fl4,
 			    struct ipcm_cookie *ipc, struct rtable **rt)
 {
-	struct sock *sk;
 	struct sk_buff *skb;
 
-	sk = icmp_sk(dev_net((*rt)->dst.dev));
 	if (ip_append_data(sk, fl4, icmp_glue_bits, icmp_param,
 			   icmp_param->data_len+icmp_param->head_len,
 			   icmp_param->head_len,
@@ -452,7 +443,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	if (IS_ERR(rt))
 		goto out_unlock;
 	if (icmpv4_xrlim_allow(net, rt, &fl4, type, code))
-		icmp_push_reply(icmp_param, &fl4, &ipc, &rt);
+		icmp_push_reply(sk, icmp_param, &fl4, &ipc, &rt);
 	ip_rt_put(rt);
 out_unlock:
 	icmp_xmit_unlock(sk);
@@ -766,7 +757,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	if (!fl4.saddr)
 		fl4.saddr = htonl(INADDR_DUMMY);
 
-	icmp_push_reply(&icmp_param, &fl4, &ipc, &rt);
+	icmp_push_reply(sk, &icmp_param, &fl4, &ipc, &rt);
 ende:
 	ip_rt_put(rt);
 out_unlock:
@@ -1434,46 +1425,8 @@ static const struct icmp_control icmp_pointers[NR_ICMP_TYPES + 1] = {
 	},
 };
 
-static void __net_exit icmp_sk_exit(struct net *net)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.icmp_sk, i));
-	free_percpu(net->ipv4.icmp_sk);
-	net->ipv4.icmp_sk = NULL;
-}
-
 static int __net_init icmp_sk_init(struct net *net)
 {
-	int i, err;
-
-	net->ipv4.icmp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv4.icmp_sk)
-		return -ENOMEM;
-
-	for_each_possible_cpu(i) {
-		struct sock *sk;
-
-		err = inet_ctl_sock_create(&sk, PF_INET,
-					   SOCK_RAW, IPPROTO_ICMP, net);
-		if (err < 0)
-			goto fail;
-
-		*per_cpu_ptr(net->ipv4.icmp_sk, i) = sk;
-
-		/* Enough space for 2 64K ICMP packets, including
-		 * sk_buff/skb_shared_info struct overhead.
-		 */
-		sk->sk_sndbuf =	2 * SKB_TRUESIZE(64 * 1024);
-
-		/*
-		 * Speedup sock_wfree()
-		 */
-		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
-		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DONT;
-	}
-
 	/* Control parameters for ECHO replies. */
 	net->ipv4.sysctl_icmp_echo_ignore_all = 0;
 	net->ipv4.sysctl_icmp_echo_enable_probe = 0;
@@ -1499,18 +1452,36 @@ static int __net_init icmp_sk_init(struct net *net)
 	net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr = 0;
 
 	return 0;
-
-fail:
-	icmp_sk_exit(net);
-	return err;
 }
 
 static struct pernet_operations __net_initdata icmp_sk_ops = {
        .init = icmp_sk_init,
-       .exit = icmp_sk_exit,
 };
 
 int __init icmp_init(void)
 {
+	int err, i;
+
+	for_each_possible_cpu(i) {
+		struct sock *sk;
+
+		err = inet_ctl_sock_create(&sk, PF_INET,
+					   SOCK_RAW, IPPROTO_ICMP, &init_net);
+		if (err < 0)
+			return err;
+
+		per_cpu(ipv4_icmp_sk, i) = sk;
+
+		/* Enough space for 2 64K ICMP packets, including
+		 * sk_buff/skb_shared_info struct overhead.
+		 */
+		sk->sk_sndbuf =	2 * SKB_TRUESIZE(64 * 1024);
+
+		/*
+		 * Speedup sock_wfree()
+		 */
+		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DONT;
+	}
 	return register_pernet_subsys(&icmp_sk_ops);
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

