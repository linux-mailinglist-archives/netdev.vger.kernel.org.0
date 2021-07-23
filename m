Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADC23D3343
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhGWDUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234100AbhGWDRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5454960EE2;
        Fri, 23 Jul 2021 03:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012698;
        bh=lZUyKpH+XaUrUfrFrtmky8axs8NlfhJCXRbnLLaSzgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I37UazSodU3iKTHnTnKAoSi1YaijSMg7YEmk/ASNQDTm+L/Vmu2C82xyEzMuRrvpT
         y0jZ+cVV2lw9txL/TcDHvH+u4G/1lIN2L4Li8H5bJhZclXQnj+dmO7HYHgiqMb3izm
         Xdh/D7jGabRz6QqQ+wLEG5CSfay9772CvJo4PbsUx8wS9roNVFnGS2CLz3yIopdCfh
         WVP00JQGRw/Xw+F8Rfc/qv9x9pioYRnF44ESh/wHQijUU3wCm31B//HcKyQ4mwhvnj
         VmgakPyDM9I9G08gWUqrnYhMaTm/kvH688c/12NyD2em4sxZWLw9loeGzxD+18z1cs
         Oz0Vjku0cyaVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/14] net: annotate data race around sk_ll_usec
Date:   Thu, 22 Jul 2021 23:58:02 -0400
Message-Id: <20210723035813.531837-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0dbffbb5335a1e3aa6855e4ee317e25e669dd302 ]

sk_ll_usec is read locklessly from sk_can_busy_loop()
while another thread can change its value in sock_setsockopt()

This is correct but needs annotations.

BUG: KCSAN: data-race in __skb_try_recv_datagram / sock_setsockopt

write to 0xffff88814eb5f904 of 4 bytes by task 14011 on cpu 0:
 sock_setsockopt+0x1287/0x2090 net/core/sock.c:1175
 __sys_setsockopt+0x14f/0x200 net/socket.c:2100
 __do_sys_setsockopt net/socket.c:2115 [inline]
 __se_sys_setsockopt net/socket.c:2112 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2112
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88814eb5f904 of 4 bytes by task 14001 on cpu 1:
 sk_can_busy_loop include/net/busy_poll.h:41 [inline]
 __skb_try_recv_datagram+0x14f/0x320 net/core/datagram.c:273
 unix_dgram_recvmsg+0x14c/0x870 net/unix/af_unix.c:2101
 unix_seqpacket_recvmsg+0x5a/0x70 net/unix/af_unix.c:2067
 ____sys_recvmsg+0x15d/0x310 include/linux/uio.h:244
 ___sys_recvmsg net/socket.c:2598 [inline]
 do_recvmmsg+0x35c/0x9f0 net/socket.c:2692
 __sys_recvmmsg net/socket.c:2771 [inline]
 __do_sys_recvmmsg net/socket.c:2794 [inline]
 __se_sys_recvmmsg net/socket.c:2787 [inline]
 __x64_sys_recvmmsg+0xcf/0x150 net/socket.c:2787
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000101

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 14001 Comm: syz-executor.3 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/busy_poll.h | 2 +-
 net/core/sock.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 86e028388bad..9899b9af7f22 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -36,7 +36,7 @@ static inline bool net_busy_loop_on(void)
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
 {
-	return sk->sk_ll_usec && !signal_pending(current);
+	return READ_ONCE(sk->sk_ll_usec) && !signal_pending(current);
 }
 
 bool sk_busy_loop_end(void *p, unsigned long start_time);
diff --git a/net/core/sock.c b/net/core/sock.c
index 68f84fac63e0..452883b28aba 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1098,7 +1098,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			if (val < 0)
 				ret = -EINVAL;
 			else
-				sk->sk_ll_usec = val;
+				WRITE_ONCE(sk->sk_ll_usec, val);
 		}
 		break;
 #endif
-- 
2.30.2

