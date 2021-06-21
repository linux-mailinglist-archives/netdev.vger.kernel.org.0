Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6123AF287
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhFURzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhFURyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98276611BD;
        Mon, 21 Jun 2021 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297944;
        bh=2lgbJh8Az+7qTJCmxPPrj7ttLaeTbIsUx94vAk0dpvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrJ1qedeZOCXg/n3IO7x9KkIA7LIVpBkahN1nRCmGn2BTO1TiGTengbwBwiynIzaU
         IseFTxL3vIjUZEYGNU3/wpTV+InB3EutjK/9DfSrTvSfRsS+YvpXxDBJ2woIsWmoLe
         RU29/DAdGvSX7Wx3Ci5s3HwY9CVu2TuBGB5gHnxZl6dDnpFE6pZZ1o1cwRmwSAowj5
         1/P2aBlrB3fhQ/rwN5fbmW4Wi6mHtlWdexhRNJZHXUDm+fh77pcHBy13eLkJ+JoLWO
         es1m0BpnFj7JjB67yYM6u3vmzMFfI5BE0goMjztekM6UW0Na5A8Tky0Ov+020mXfJs
         sJ+7Gfbckrm+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 16/39] inet: annotate data race in inet_send_prepare() and inet_dgram_connect()
Date:   Mon, 21 Jun 2021 13:51:32 -0400
Message-Id: <20210621175156.735062-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dcd01eeac14486b56a790f5cce9b823440ba5b34 ]

Both functions are known to be racy when reading inet_num
as we do not want to grab locks for the common case the socket
has been bound already. The race is resolved in inet_autobind()
by reading again inet_num under the socket lock.

syzbot reported:
BUG: KCSAN: data-race in inet_send_prepare / udp_lib_get_port

write to 0xffff88812cba150e of 2 bytes by task 24135 on cpu 0:
 udp_lib_get_port+0x4b2/0xe20 net/ipv4/udp.c:308
 udp_v6_get_port+0x5e/0x70 net/ipv6/udp.c:89
 inet_autobind net/ipv4/af_inet.c:183 [inline]
 inet_send_prepare+0xd0/0x210 net/ipv4/af_inet.c:807
 inet6_sendmsg+0x29/0x80 net/ipv6/af_inet6.c:639
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88812cba150e of 2 bytes by task 24132 on cpu 1:
 inet_send_prepare+0x21/0x210 net/ipv4/af_inet.c:806
 inet6_sendmsg+0x29/0x80 net/ipv6/af_inet6.c:639
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x9db4

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 24132 Comm: syz-executor.2 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1355e6c0d567..faa7856c7fb0 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -575,7 +575,7 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 			return err;
 	}
 
-	if (!inet_sk(sk)->inet_num && inet_autobind(sk))
+	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
 		return -EAGAIN;
 	return sk->sk_prot->connect(sk, uaddr, addr_len);
 }
@@ -803,7 +803,7 @@ int inet_send_prepare(struct sock *sk)
 	sock_rps_record_flow(sk);
 
 	/* We may need to bind the socket. */
-	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
+	if (data_race(!inet_sk(sk)->inet_num) && !sk->sk_prot->no_autobind &&
 	    inet_autobind(sk))
 		return -EAGAIN;
 
-- 
2.30.2

