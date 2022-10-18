Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28385603316
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJRTLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJRTLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:11:12 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CEE13F34
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666120272; x=1697656272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZqpZjG5Pq7+v3c5YOGsuh2sIL9DcqXjYLhBuncEnN8s=;
  b=MsQCtlQOfS7jmkY4PgndhAjEo1f+U3Wh2qIx1/QcMihtyQrWSy9LZEnK
   Qba1ZjNBERbcR+Fdj/Jb0RIir2hwnTR1fS5T793yx4A0hhYvjJEVoYaeQ
   kS4mYVoC+kfFbgUyvWzmMH2yEvFJFwY3KVzR+WvMH3RzApL/MyQbiq1Po
   E=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 19:11:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id F2D119FAE5;
        Tue, 18 Oct 2022 19:11:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 18 Oct 2022 19:11:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 18 Oct 2022 19:11:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH v1 net-next 1/5] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
Date:   Tue, 18 Oct 2022 12:09:52 -0700
Message-ID: <20221018190956.1308-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018190956.1308-1-kuniyu@amazon.com>
References: <20221018190956.1308-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

Now we can remove unnecessary inet6_destroy_sock() calls in
sk->sk_prot->destroy().

DCCP and SCTP have their own sk->sk_destruct() function, so we
change them separately in the following patches.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/ipv6/ping.c      |  6 ------
 net/ipv6/raw.c       |  2 --
 net/ipv6/tcp_ipv6.c  |  8 +-------
 net/ipv6/udp.c       |  2 --
 net/l2tp/l2tp_ip6.c  |  2 --
 net/mptcp/protocol.c | 10 ----------
 6 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 86c26e48d065..808983bc2ec9 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -23,11 +23,6 @@
 #include <linux/bpf-cgroup.h>
 #include <net/ping.h>
 
-static void ping_v6_destroy(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
-
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -205,7 +200,6 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
-	.destroy =	ping_v6_destroy,
 	.pre_connect =	ping_v6_pre_connect,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 722de9dd0ff7..a06a9f847db5 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1173,8 +1173,6 @@ static void raw6_destroy(struct sock *sk)
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
 	release_sock(sk);
-
-	inet6_destroy_sock(sk);
 }
 
 static int rawv6_init_sk(struct sock *sk)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2a3f9296df1e..f676be14e6b6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1966,12 +1966,6 @@ static int tcp_v6_init_sock(struct sock *sk)
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
@@ -2164,7 +2158,7 @@ struct proto tcpv6_prot = {
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
 	.init			= tcp_v6_init_sock,
-	.destroy		= tcp_v6_destroy_sock,
+	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d09f0ea5b8c..e3dde867d9d3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1661,8 +1661,6 @@ void udpv6_destroy_sock(struct sock *sk)
 			udp_encap_disable();
 		}
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 9dbd801ddb98..2478aa60145f 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -257,8 +257,6 @@ static void l2tp_ip6_destroy_sock(struct sock *sk)
 
 	if (tunnel)
 		l2tp_tunnel_delete(tunnel);
-
-	inet6_destroy_sock(sk);
 }
 
 static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f599ad44ed24..7cc9c542c768 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -17,9 +17,6 @@
 #include <net/protocol.h>
 #include <net/tcp.h>
 #include <net/tcp_states.h>
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-#include <net/transp_v6.h>
-#endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
 #include <asm/ioctls.h>
@@ -3898,12 +3895,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 
 static struct proto mptcp_v6_prot;
 
-static void mptcp_v6_destroy(struct sock *sk)
-{
-	mptcp_destroy(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct inet_protosw mptcp_v6_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
@@ -3919,7 +3910,6 @@ int __init mptcp_proto_v6_init(void)
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
-	mptcp_v6_prot.destroy = mptcp_v6_destroy;
 	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
 
 	err = proto_register(&mptcp_v6_prot, 1);
-- 
2.30.2

