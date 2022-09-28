Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8035ED208
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiI1A3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiI1A3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:29:31 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46270111DD6;
        Tue, 27 Sep 2022 17:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664324970; x=1695860970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Di23evBkahKeOVuK/9bc1RLsAUaIIjqxoex4S/ZsBcE=;
  b=K7qTwUFktV/Jhov1FVgKZR22C4zexXGp9RlcVLzriZ73rJBLerc6a6gE
   /g5EwlSMP+ig3TsqC6K514t/LURss7FThW9SfVi+ppRjYY+GpiXnv9HDG
   l2lDg+G96gizgWQNPT4nvJgfUaKl4czt6OTzu+qhmRXh9Vq94yrcFZ+E0
   U=;
X-IronPort-AV: E=Sophos;i="5.93,350,1654560000"; 
   d="scan'208";a="1058688955"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 00:29:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 41887140FF4;
        Wed, 28 Sep 2022 00:29:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 00:29:08 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 28 Sep 2022 00:29:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net 5/5] tcp: Fix data races around icsk->icsk_af_ops.
Date:   Tue, 27 Sep 2022 17:27:41 -0700
Message-ID: <20220928002741.64237-6-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220928002741.64237-1-kuniyu@amazon.com>
References: <20220928002741.64237-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

setsockopt(IPV6_ADDRFORM) and tcp_v6_connect() change icsk->icsk_af_ops
under lock_sock(), but tcp_(get|set)sockopt() read it locklessly.  To
avoid load/store tearing, we need to add READ_ONCE() and WRITE_ONCE()
for the reads and writes.

Thanks to Eric Dumazet for providing the syzbot report:

BUG: KCSAN: data-race in tcp_setsockopt / tcp_v6_connect

write to 0xffff88813c624518 of 8 bytes by task 23936 on cpu 0:
tcp_v6_connect+0x5b3/0xce0 net/ipv6/tcp_ipv6.c:240
__inet_stream_connect+0x159/0x6d0 net/ipv4/af_inet.c:660
inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:724
__sys_connect_file net/socket.c:1976 [inline]
__sys_connect+0x197/0x1b0 net/socket.c:1993
__do_sys_connect net/socket.c:2003 [inline]
__se_sys_connect net/socket.c:2000 [inline]
__x64_sys_connect+0x3d/0x50 net/socket.c:2000
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88813c624518 of 8 bytes by task 23937 on cpu 1:
tcp_setsockopt+0x147/0x1c80 net/ipv4/tcp.c:3789
sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3585
__sys_setsockopt+0x212/0x2b0 net/socket.c:2252
__do_sys_setsockopt net/socket.c:2263 [inline]
__se_sys_setsockopt net/socket.c:2260 [inline]
__x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0xffffffff8539af68 -> 0xffffffff8539aff8

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23937 Comm: syz-executor.5 Not tainted
6.0.0-rc4-syzkaller-00331-g4ed9c1e971b1-dirty #0

Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 08/26/2022

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp.c           | 10 ++++++----
 net/ipv6/ipv6_sockglue.c |  3 ++-
 net/ipv6/tcp_ipv6.c      |  6 ++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e373dde1f46f..76b80d81fd6a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3795,8 +3795,9 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (level != SOL_TCP)
-		return icsk->icsk_af_ops->setsockopt(sk, level, optname,
-						     optval, optlen);
+		/* Paired with WRITE_ONCE() in do_ipv6_setsockopt() and tcp_v6_connect() */
+		return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
+								optval, optlen);
 	return do_tcp_setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(tcp_setsockopt);
@@ -4394,8 +4395,9 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (level != SOL_TCP)
-		return icsk->icsk_af_ops->getsockopt(sk, level, optname,
-						     optval, optlen);
+		/* Paired with WRITE_ONCE() in do_ipv6_setsockopt() and tcp_v6_connect() */
+		return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
+								optval, optlen);
 	return do_tcp_getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(tcp_getsockopt);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index a89db5872dc3..726d95859898 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -479,7 +479,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
-				icsk->icsk_af_ops = &ipv4_specific;
+				/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+				WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
 				sk->sk_socket->ops = &inet_stream_ops;
 				sk->sk_family = PF_INET;
 				tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e54eee80ce5f..8680aa83f0b9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -237,7 +237,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 		sin.sin_port = usin->sin6_port;
 		sin.sin_addr.s_addr = usin->sin6_addr.s6_addr32[3];
 
-		icsk->icsk_af_ops = &ipv6_mapped;
+		/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+		WRITE_ONCE(icsk->icsk_af_ops, &ipv6_mapped);
 		if (sk_is_mptcp(sk))
 			mptcpv6_handle_mapped(sk, true);
 		sk->sk_backlog_rcv = tcp_v4_do_rcv;
@@ -249,7 +250,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 		if (err) {
 			icsk->icsk_ext_hdr_len = exthdrlen;
-			icsk->icsk_af_ops = &ipv6_specific;
+			/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+			WRITE_ONCE(icsk->icsk_af_ops, &ipv6_specific);
 			if (sk_is_mptcp(sk))
 				mptcpv6_handle_mapped(sk, false);
 			sk->sk_backlog_rcv = tcp_v6_do_rcv;
-- 
2.30.2

