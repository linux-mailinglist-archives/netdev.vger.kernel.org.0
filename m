Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B20598B16
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiHRS1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbiHRS1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:27:43 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A10CE4A6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847263; x=1692383263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z9kbmg3VYGz3Rl5PDKHwpcbe1kFAtaJ4dsktIXkdQMA=;
  b=sd8BG7+gojrIl+lN1rnUwOCvyEEscOxzV6Z9zE1MUh9NXOJuwwYx7sJY
   uH86AxKmmnAZ/TcLgr8+1CYxTMAtfC2OB5IqiJUCKmzq1m3ykDTUA8M7h
   2lWM4/afubdTf3e8IPuakMVAfL/sGsjtXQfbLV8tO/UcADbjtr03ERuF6
   M=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="219032728"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:27:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id E8FD4A28A7;
        Thu, 18 Aug 2022 18:27:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:27:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:27:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 01/17] net: Fix data-races around sysctl_[rw]mem_(max|default).
Date:   Thu, 18 Aug 2022 11:26:37 -0700
Message-ID: <20220818182653.38940-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_[rw]mem_(max|default), they can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/filter.c               | 4 ++--
 net/core/sock.c                 | 8 ++++----
 net/ipv4/ip_output.c            | 2 +-
 net/ipv4/tcp_output.c           | 2 +-
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e8508aaafd27..c4f14ad82029 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5034,14 +5034,14 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
 		/* Only some socketops are supported */
 		switch (optname) {
 		case SO_RCVBUF:
-			val = min_t(u32, val, sysctl_rmem_max);
+			val = min_t(u32, val, READ_ONCE(sysctl_rmem_max));
 			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 			WRITE_ONCE(sk->sk_rcvbuf,
 				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
-			val = min_t(u32, val, sysctl_wmem_max);
+			val = min_t(u32, val, READ_ONCE(sysctl_wmem_max));
 			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 			WRITE_ONCE(sk->sk_sndbuf,
diff --git a/net/core/sock.c b/net/core/sock.c
index 4cb957d934a2..303af52f3b79 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1101,7 +1101,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		val = min_t(u32, val, sysctl_wmem_max);
+		val = min_t(u32, val, READ_ONCE(sysctl_wmem_max));
 set_sndbuf:
 		/* Ensure val * 2 fits into an int, to prevent max_t()
 		 * from treating it as a negative value.
@@ -1133,7 +1133,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
+		__sock_set_rcvbuf(sk, min_t(u32, val, READ_ONCE(sysctl_rmem_max)));
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -3309,8 +3309,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	timer_setup(&sk->sk_timer, NULL, 0);
 
 	sk->sk_allocation	=	GFP_KERNEL;
-	sk->sk_rcvbuf		=	sysctl_rmem_default;
-	sk->sk_sndbuf		=	sysctl_wmem_default;
+	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
+	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
 	sk->sk_state		=	TCP_CLOSE;
 	sk_set_socket(sk, sock);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d7bd1daf022b..04e2034f2f8e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1730,7 +1730,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
-	sk->sk_sndbuf = sysctl_wmem_default;
+	sk->sk_sndbuf = READ_ONCE(sysctl_wmem_default);
 	ipc.sockc.mark = fl4.flowi4_mark;
 	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 78b654ff421b..290019de766d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -239,7 +239,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
 		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
-		space = max_t(u32, space, sysctl_rmem_max);
+		space = max_t(u32, space, READ_ONCE(sysctl_rmem_max));
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
 				      0, TCP_MAX_WSCALE);
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 9d43277b8b4f..a56fd0b5a430 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1280,12 +1280,12 @@ static void set_sock_size(struct sock *sk, int mode, int val)
 	lock_sock(sk);
 	if (mode) {
 		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
-			      sysctl_wmem_max);
+			      READ_ONCE(sysctl_wmem_max));
 		sk->sk_sndbuf = val * 2;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	} else {
 		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
-			      sysctl_rmem_max);
+			      READ_ONCE(sysctl_rmem_max));
 		sk->sk_rcvbuf = val * 2;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
-- 
2.30.2

