Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5D4BAD73
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 00:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiBQXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 18:49:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiBQXtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 18:49:35 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2891746655
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:49:04 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so6938107pjm.2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGnzrz7GxC5VvjNkR6JmY+NSRiz9O2WQo/Mc3kUc/Ow=;
        b=KppTlSRetHw7BaeQA1DKOS4qYqdYcPnsB5Tp+jV6YnGC8TpjaC3BYHHk6koR8ig92k
         gA2JbVaFlJtn8edKqp473NLKVjRMdiciIgTLFlUEWh+TDlhsLZ9EgOzyTSlQQcLt8LSK
         Q6jcrvltW7Snpq9nXAIUTMXLlP/3Xa21dXbVMfAZpSgvOnpbm8FpSIuw3Out/GGs6qx6
         sAz0N2sLnAe/ctEPrWF+mLp7dyvo7uHEDHyPAeeB2us1mAkHDdwAXb+hS2cvGjWpHt9q
         pX0OAAA3EjfcBWvyGknsVT5wk8sTGvvxR7N0SU0AdISUdzLa3RIkiwzf96Jvqq0WSgo9
         VGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGnzrz7GxC5VvjNkR6JmY+NSRiz9O2WQo/Mc3kUc/Ow=;
        b=RIn18j0Ky0OXjYi9hR1tQlJXJ0mwtVgD6xtNeN1zMOX0Gqrj+62rnqDmLR8XOyq/uE
         5Fc3LATU2h5ju+d17CPEEZLAcEhnIjFnRRKxGirhGCtGsrR2qzAyiOERBmtVSYmLBNlR
         bQ8auUrXofKXvHoRrwhdXHmYLB0W9Nr4Y+wBWHctoolGxKq8dWcZJEkvMP95QFAdI/PC
         4OXCnQNVvYSG/SL/MkmCn1SW6SNVvhlfioN+aaAYHvuMOSQgBb3UQ7BnZ5WJyy/QGNtS
         QeT7jqrqt+fbv8w74ZZqZTwnEOZsCZO8S03ZS9gfvHTza1jOktINY1JarjF9uIJZ+DfG
         B+5A==
X-Gm-Message-State: AOAM530gIdC/DFs2UNPetdL2Z+SYz+x0AtgICMRLJ8A6qvQKRm0QcoKa
        TnThevGEGZL0iCV/hX2829E=
X-Google-Smtp-Source: ABdhPJwYJBJA9pjxwCHAfGmKnivrB7y2zhzTDywA/xEyq822dSczevHMbht1AArgNAfhqWIi10PuaA==
X-Received: by 2002:a17:90b:450b:b0:1b9:256c:6c7 with SMTP id iu11-20020a17090b450b00b001b9256c06c7mr5470553pjb.33.1645141724944;
        Thu, 17 Feb 2022 15:48:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5c60:79a8:8f41:618f])
        by smtp.gmail.com with ESMTPSA id ot12sm2960225pjb.22.2022.02.17.15.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 15:48:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ipv6: annotate some data-races around sk->sk_prot
Date:   Thu, 17 Feb 2022 15:48:41 -0800
Message-Id: <20220217234841.1222299-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

IPv6 has this hack changing sk->sk_prot when an IPv6 socket
is 'converted' to an IPv4 one with IPV6_ADDRFORM option.

This operation is only performed for TCP and UDP, knowing
their 'struct proto' for the two network families are populated
in the same way, and can not disappear while a reader
might use and dereference sk->sk_prot.

If we think about it all reads of sk->sk_prot while
either socket lock or RTNL is not acquired should be using READ_ONCE().

Also note that other layers like MPTCP, XFRM, CHELSIO_TLS also
write over sk->sk_prot.

BUG: KCSAN: data-race in inet6_recvmsg / ipv6_setsockopt

write to 0xffff8881386f7aa8 of 8 bytes by task 26932 on cpu 0:
 do_ipv6_setsockopt net/ipv6/ipv6_sockglue.c:492 [inline]
 ipv6_setsockopt+0x3758/0x3910 net/ipv6/ipv6_sockglue.c:1019
 udpv6_setsockopt+0x85/0x90 net/ipv6/udp.c:1649
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3489
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881386f7aa8 of 8 bytes by task 26911 on cpu 1:
 inet6_recvmsg+0x7a/0x210 net/ipv6/af_inet6.c:659
 ____sys_recvmsg+0x16c/0x320
 ___sys_recvmsg net/socket.c:2674 [inline]
 do_recvmmsg+0x3f5/0xae0 net/socket.c:2768
 __sys_recvmmsg net/socket.c:2847 [inline]
 __do_sys_recvmmsg net/socket.c:2870 [inline]
 __se_sys_recvmmsg net/socket.c:2863 [inline]
 __x64_sys_recvmmsg+0xde/0x160 net/socket.c:2863
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffffffff85e0e980 -> 0xffffffff85e01580

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 26911 Comm: syz-executor.3 Not tainted 5.17.0-rc2-syzkaller-00316-g0457e5153e0e-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/af_inet6.c      | 24 ++++++++++++++++++------
 net/ipv6/ipv6_sockglue.c |  6 ++++--
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 8fe7900f1949911b32326fb166ae20912a59c215..7d7b7523d126539d8e5c84e4603ec16889a15498 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -441,11 +441,14 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
 	u32 flags = BIND_WITH_LOCK;
+	const struct proto *prot;
 	int err = 0;
 
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
 	/* If the socket has its own bind function then use it. */
-	if (sk->sk_prot->bind)
-		return sk->sk_prot->bind(sk, uaddr, addr_len);
+	if (prot->bind)
+		return prot->bind(sk, uaddr, addr_len);
 
 	if (addr_len < SIN6_LEN_RFC2133)
 		return -EINVAL;
@@ -555,6 +558,7 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
+	const struct proto *prot;
 
 	switch (cmd) {
 	case SIOCADDRT:
@@ -572,9 +576,11 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCSIFDSTADDR:
 		return addrconf_set_dstaddr(net, argp);
 	default:
-		if (!sk->sk_prot->ioctl)
+		/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+		prot = READ_ONCE(sk->sk_prot);
+		if (!prot->ioctl)
 			return -ENOIOCTLCMD;
-		return sk->sk_prot->ioctl(sk, cmd, arg);
+		return prot->ioctl(sk, cmd, arg);
 	}
 	/*NOTREACHED*/
 	return 0;
@@ -636,11 +642,14 @@ INDIRECT_CALLABLE_DECLARE(int udpv6_sendmsg(struct sock *, struct msghdr *,
 int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
 	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
-	return INDIRECT_CALL_2(sk->sk_prot->sendmsg, tcp_sendmsg, udpv6_sendmsg,
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	return INDIRECT_CALL_2(prot->sendmsg, tcp_sendmsg, udpv6_sendmsg,
 			       sk, msg, size);
 }
 
@@ -650,13 +659,16 @@ int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		  int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 	int addr_len = 0;
 	int err;
 
 	if (likely(!(flags & MSG_ERRQUEUE)))
 		sock_rps_record_flow(sk);
 
-	err = INDIRECT_CALL_2(sk->sk_prot->recvmsg, tcp_recvmsg, udpv6_recvmsg,
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	err = INDIRECT_CALL_2(prot->recvmsg, tcp_recvmsg, udpv6_recvmsg,
 			      sk, msg, size, flags & MSG_DONTWAIT,
 			      flags & ~MSG_DONTWAIT, &addr_len);
 	if (err >= 0)
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index a733803a710cf1f94ec05466adf388ab0fb346e6..222f6bf220ba0d08bdde1464a1d383f819b3fe34 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -475,7 +475,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 
-				sk->sk_prot = &tcp_prot;
+				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
 				sk->sk_family = PF_INET;
@@ -489,7 +490,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 
-				sk->sk_prot = prot;
+				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
 			}
-- 
2.35.1.265.g69c8d7142f-goog

