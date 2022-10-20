Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A984B60619F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJTN2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJTN2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:28:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FF01A1B03;
        Thu, 20 Oct 2022 06:28:41 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtSwn1g4qzmVDF;
        Thu, 20 Oct 2022 21:23:53 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 21:28:37 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <ast@kernel.org>, <martin.lau@kernel.org>,
        <kuniyu@amazon.com>, <asml.silence@gmail.com>,
        <imagedong@tencent.com>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next,v2] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date:   Thu, 20 Oct 2022 22:32:01 +0800
Message-ID: <20221020143201.339599-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
in tcp_add_backlog(), the variable limit is caculated by adding
sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
of int and overflow. This patch limits sk_rcvbuf and sk_sndbuf
to 0x7fff000 and transfers them to u32 to avoid signed-integer
overflow.

Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 include/net/sock.h  |  5 +++++
 net/core/sock.c     | 10 ++++++----
 net/ipv4/tcp_ipv4.c |  3 ++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e464f6409a7..cc2d6c4047c2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2529,6 +2529,11 @@ static inline void sk_wake_async(const struct sock *sk, int how, int band)
 #define SOCK_MIN_SNDBUF		(TCP_SKB_MIN_TRUESIZE * 2)
 #define SOCK_MIN_RCVBUF		 TCP_SKB_MIN_TRUESIZE
 
+/* limit sk_sndbuf and sk_rcvbuf to 0x7fff0000 to prevent overflow
+ * when adding sk_sndbuf, sk_rcvbuf and 64K in tcp_add_backlog()
+ */
+#define SOCK_MAX_SNDRCVBUF		(INT_MAX - 0xFFFF)
+
 static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 {
 	u32 val;
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c..33acc5e71100 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -950,7 +950,7 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
 	/* Ensure val * 2 fits into an int, to prevent max_t() from treating it
 	 * as a negative value.
 	 */
-	val = min_t(int, val, INT_MAX / 2);
+	val = min_t(int, val, SOCK_MAX_SNDRCVBUF / 2);
 	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 
 	/* We double it on the way in to account for "struct sk_buff" etc.
@@ -1142,7 +1142,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		/* Ensure val * 2 fits into an int, to prevent max_t()
 		 * from treating it as a negative value.
 		 */
-		val = min_t(int, val, INT_MAX / 2);
+		val = min_t(int, val, SOCK_MAX_SNDRCVBUF / 2);
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		WRITE_ONCE(sk->sk_sndbuf,
 			   max_t(int, val * 2, SOCK_MIN_SNDBUF));
@@ -3365,8 +3365,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	timer_setup(&sk->sk_timer, NULL, 0);
 
 	sk->sk_allocation	=	GFP_KERNEL;
-	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
-	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
+	sk->sk_rcvbuf		=	min_t(int, SOCK_MAX_SNDRCVBUF,
+					      READ_ONCE(sysctl_rmem_default));
+	sk->sk_sndbuf		=	min_t(int, SOCK_MAX_SNDRCVBUF,
+					      READ_ONCE(sysctl_wmem_default));
 	sk->sk_state		=	TCP_CLOSE;
 	sk_set_socket(sk, sock);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7a250ef9d1b7..5340733336a6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1878,7 +1878,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) +
+		(u32)READ_ONCE(sk->sk_sndbuf) + 64*1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.31.1

