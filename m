Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D40499C18
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577259AbiAXV7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456649AbiAXVjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52995C0613A7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:17 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d18so4274258plg.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySlUS0rUDwK62yVJf2rN33yPK8KDaorlC/HRAX7+p4w=;
        b=hu7vnhUxLxJ3FKtKigjKIGC3UyA6PJKoJi9CIXE6yVh4OfiTMbuF/3OqyhxmXAfanF
         rOqxeiqTFmo75BTEW8LDEcG8tveAjQsHqh2rLBSdlmcrLay8OZDgdc3oNUhbCtusC5KN
         8ybp18qNPBu8zlDYhOq1BAsdrftosLNKZQhmv24QD4xdU3y/Cd6jBoeBOtk8VCx5y37i
         t1hARtlbz6+H4T22NSjTYl6yWvxN5OhpOwxR7zrmA2uu9rmi4o9QHnEWlZNeTtdtyFY8
         XhTn69KZSjrSnAual3iClGePdvlx+Rt9vtyQcGwQnQVS0kurYTfnSzDApqyzaxk1eOMJ
         4DGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySlUS0rUDwK62yVJf2rN33yPK8KDaorlC/HRAX7+p4w=;
        b=4hofR7ea03C9Su+BK4bdYJzI+8wR0LjFKjKBJM0ylo34knq8Vqu5LPpjT2htDm7SjK
         Rp8+0gVG0ych2oFMsNoLbchR7ABCsaJwevXJ4Vz595yHg3YfJM3vzOIaomqw7kL9P76M
         0gQJbhz6xERfbBvninozeNsq85rLApX8iz+C/yLBWNxWx/vRo5bh1ITH1+Ju2atA8Vnd
         7W19QVbB3cnS2pyFYVn75n3KLppoIzugDIaOk0CF4gHExHpXZpAvExCCU6A3kwGEsox3
         ENbcQph4SayrXsnSjjAgG9KWwMcFruHyEYA7VNYatBUGgdXPWUUTR6EvbHIci7Tc7knj
         R+tQ==
X-Gm-Message-State: AOAM531064rxs8YgRO82nArh3Fkh6a2+3YFCb1NpHbuRteD+XuY4UATA
        QnqpK6BojkoCeUJgmlR/Qwo=
X-Google-Smtp-Source: ABdhPJzVPrwdQMweof3gpkLwzDICMm0P2NfovynBbl+TaTl57leUTJIMbkq691n9dAjbDesSaySr5Q==
X-Received: by 2002:a17:90a:a90:: with SMTP id 16mr32207pjw.125.1643055916844;
        Mon, 24 Jan 2022 12:25:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/6] ipv4/tcp: do not use per netns ctl sockets
Date:   Mon, 24 Jan 2022 12:24:57 -0800
Message-Id: <20220124202457.3450198-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP ipv4 uses per-cpu/per-netns ctl sockets in order to send
RST and some ACK packets (on behalf of TIMEWAIT sockets).

This adds memory and cpu costs, which do not seem needed.
Now typical servers have 256 or more cores, this adds considerable
tax to netns users.

tcp sockets are used from BH context, are not receiving packets,
and do not store any persistent state but the 'struct net' pointer
in order to be able to use IPv4 output functions.

Note that I attempted a related change in the past, that had
to be hot-fixed in commit bdbbb8527b6f ("ipv4: tcp: get rid of ugly unicast_sock")

This patch could very well surface old bugs, on layers not
taking care of sk->sk_kern_sock properly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h |  1 -
 net/ipv4/tcp_ipv4.c      | 61 ++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 639a31638159b23e7ec1d16f621a7953b885729c..22b4c6df1d2b383cd10dd3dc11cf8c39388c50bf 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -73,7 +73,6 @@ struct netns_ipv4 {
 	struct sock		*mc_autojoin_sk;
 
 	struct inet_peer_base	*peers;
-	struct sock  * __percpu	*tcp_sk;
 	struct fqdir		*fqdir;
 
 	u8 sysctl_icmp_echo_ignore_all;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8e94b99882044d3d9927d83512d18f34dc2f5b43..a7d83ceea42076e89862619f4b0cd7ae9277e7de 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -91,6 +91,8 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 struct inet_hashinfo tcp_hashinfo;
 EXPORT_SYMBOL(tcp_hashinfo);
 
+static DEFINE_PER_CPU(struct sock *, ipv4_tcp_sk);
+
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
 {
 	return secure_tcp_seq(ip_hdr(skb)->daddr,
@@ -810,7 +812,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.tos = ip_hdr(skb)->tos;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
@@ -825,6 +828,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
@@ -908,7 +912,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.tos = tos;
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
 	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
@@ -921,6 +926,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
 }
@@ -3111,41 +3117,14 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
-	int cpu;
-
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-
-	for_each_possible_cpu(cpu)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.tcp_sk, cpu));
-	free_percpu(net->ipv4.tcp_sk);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
 {
-	int res, cpu, cnt;
-
-	net->ipv4.tcp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv4.tcp_sk)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		struct sock *sk;
-
-		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
-					   IPPROTO_TCP, net);
-		if (res)
-			goto fail;
-		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
-
-		/* Please enforce IP_DF and IPID==0 for RST and
-		 * ACK sent in SYN-RECV and TIME-WAIT state.
-		 */
-		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
-
-		*per_cpu_ptr(net->ipv4.tcp_sk, cpu) = sk;
-	}
+	int cnt;
 
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
@@ -3229,10 +3208,6 @@ static int __net_init tcp_sk_init(struct net *net)
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
 	return 0;
-fail:
-	tcp_sk_exit(net);
-
-	return res;
 }
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
@@ -3324,6 +3299,24 @@ static void __init bpf_iter_register(void)
 
 void __init tcp_v4_init(void)
 {
+	int cpu, res;
+
+	for_each_possible_cpu(cpu) {
+		struct sock *sk;
+
+		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
+					   IPPROTO_TCP, &init_net);
+		if (res)
+			panic("Failed to create the TCP control socket.\n");
+		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+		/* Please enforce IP_DF and IPID==0 for RST and
+		 * ACK sent in SYN-RECV and TIME-WAIT state.
+		 */
+		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
+
+		per_cpu(ipv4_tcp_sk, cpu) = sk;
+	}
 	if (register_pernet_subsys(&tcp_sk_ops))
 		panic("Failed to create the TCP control socket.\n");
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

