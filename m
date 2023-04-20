Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0786E8879
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjDTDNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbjDTDNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:13:22 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CF14691;
        Wed, 19 Apr 2023 20:12:58 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Q22kr2HFCz8xCX;
        Thu, 20 Apr 2023 11:12:04 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 11:12:55 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 4.19 3/5] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
Date:   Thu, 20 Apr 2023 11:12:52 +0800
Message-ID: <176cf4b84a47eaf155b4624dd2bd88e1ddd583f1.1681893438.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1681893438.git.william.xuanziyang@huawei.com>
References: <cover.1681893438.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit b5fc29233d28be7a3322848ebe73ac327559cdb9 upstream.

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

Now we can remove unnecessary inet6_destroy_sock() calls in
sk->sk_prot->destroy().

DCCP and SCTP have their own sk->sk_destruct() function, so we
change them separately in the following patches.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/ipv6/ping.c     | 6 ------
 net/ipv6/raw.c      | 2 --
 net/ipv6/tcp_ipv6.c | 8 +-------
 net/ipv6/udp.c      | 2 --
 net/l2tp/l2tp_ip6.c | 2 --
 5 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 23ae01715e7b..5c9be8594483 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -27,11 +27,6 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
-static void ping_v6_destroy(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
-
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -175,7 +170,6 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
-	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 44e9a240d607..8ed99732e24c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1259,8 +1259,6 @@ static void raw6_destroy(struct sock *sk)
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
 	release_sock(sk);
-
-	inet6_destroy_sock(sk);
 }
 
 static int rawv6_init_sk(struct sock *sk)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f69c1b83403b..033cf81f3483 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1792,12 +1792,6 @@ static int tcp_v6_init_sock(struct sock *sk)
 	return 0;
 }
 
-static void tcp_v6_destroy_sock(struct sock *sk)
-{
-	tcp_v4_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 #ifdef CONFIG_PROC_FS
 /* Proc filesystem TCPv6 sock list dumping. */
 static void get_openreq6(struct seq_file *seq,
@@ -1990,7 +1984,7 @@ struct proto tcpv6_prot = {
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
 	.init			= tcp_v6_init_sock,
-	.destroy		= tcp_v6_destroy_sock,
+	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 93c105d0a0c9..c9522a4fc949 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1501,8 +1501,6 @@ void udpv6_destroy_sock(struct sock *sk)
 		if (encap_destroy)
 			encap_destroy(sk);
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 9dae10d8880c..f3f0b4b7c386 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -272,8 +272,6 @@ static void l2tp_ip6_destroy_sock(struct sock *sk)
 
 	if (tunnel)
 		l2tp_tunnel_delete(tunnel);
-
-	inet6_destroy_sock(sk);
 }
 
 static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
-- 
2.25.1

