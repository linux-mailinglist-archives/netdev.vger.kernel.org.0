Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240173AF457
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhFUSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234291AbhFUSFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A5861361;
        Mon, 21 Jun 2021 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298174;
        bh=mmU/kR2om690Kl2wS4pMgv5x4TQtymKK0Qc78BQGgeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daJ3rOsbWuDml6H3AwjPPbceENNg2DxdVSVZY968di2xH20MOOko14BF0tXHnFdG6
         meqn3lRcuPt9s4Cj9TVu3NsoGBzPD4sK3S/cCH2SMWnf2tp1CCLfd6229ZCuPaOZ/G
         JUXj75IpwKtqrm9tO3RI8oZUjEwnkaPd5AjEcETUE1aASyPXWz9tq71McQZ16+7AYE
         P0oxsmpGRtxtM4fYRzR6yg9+Xw35K9zZWpTNZHKRvr+xJ+RtjMHFcRwvecMUlhjxD3
         4mVznnD/F7yh4x7nECubrBsT4NNwDbwpwnyPUnOu0x9sZZC49wVb9AyiOc3pb+P9/D
         Emlf8cy7JZjPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/9] inet: annotate date races around sk->sk_txhash
Date:   Mon, 21 Jun 2021 13:56:02 -0400
Message-Id: <20210621175608.736581-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175608.736581-1-sashal@kernel.org>
References: <20210621175608.736581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b71eaed8c04f72a919a9c44e83e4ee254e69e7f3 ]

UDP sendmsg() path can be lockless, it is possible for another
thread to re-connect an change sk->sk_txhash under us.

There is no serious impact, but we can use READ_ONCE()/WRITE_ONCE()
pair to document the race.

BUG: KCSAN: data-race in __ip4_datagram_connect / skb_set_owner_w

write to 0xffff88813397920c of 4 bytes by task 30997 on cpu 1:
 sk_set_txhash include/net/sock.h:1937 [inline]
 __ip4_datagram_connect+0x69e/0x710 net/ipv4/datagram.c:75
 __ip6_datagram_connect+0x551/0x840 net/ipv6/datagram.c:189
 ip6_datagram_connect+0x2a/0x40 net/ipv6/datagram.c:272
 inet_dgram_connect+0xfd/0x180 net/ipv4/af_inet.c:580
 __sys_connect_file net/socket.c:1837 [inline]
 __sys_connect+0x245/0x280 net/socket.c:1854
 __do_sys_connect net/socket.c:1864 [inline]
 __se_sys_connect net/socket.c:1861 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1861
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88813397920c of 4 bytes by task 31039 on cpu 0:
 skb_set_hash_from_sk include/net/sock.h:2211 [inline]
 skb_set_owner_w+0x118/0x220 net/core/sock.c:2101
 sock_alloc_send_pskb+0x452/0x4e0 net/core/sock.c:2359
 sock_alloc_send_skb+0x2d/0x40 net/core/sock.c:2373
 __ip6_append_data+0x1743/0x21a0 net/ipv6/ip6_output.c:1621
 ip6_make_skb+0x258/0x420 net/ipv6/ip6_output.c:1983
 udpv6_sendmsg+0x160a/0x16b0 net/ipv6/udp.c:1527
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:642
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

value changed: 0xbca3c43d -> 0xfdb309e0

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 31039 Comm: syz-executor.2 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 31198b32d912..1b657a3a30b5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1728,7 +1728,8 @@ static inline u32 net_tx_rndhash(void)
 
 static inline void sk_set_txhash(struct sock *sk)
 {
-	sk->sk_txhash = net_tx_rndhash();
+	/* This pairs with READ_ONCE() in skb_set_hash_from_sk() */
+	WRITE_ONCE(sk->sk_txhash, net_tx_rndhash());
 }
 
 static inline void sk_rethink_txhash(struct sock *sk)
@@ -1980,9 +1981,12 @@ static inline void sock_poll_wait(struct file *filp,
 
 static inline void skb_set_hash_from_sk(struct sk_buff *skb, struct sock *sk)
 {
-	if (sk->sk_txhash) {
+	/* This pairs with WRITE_ONCE() in sk_set_txhash() */
+	u32 txhash = READ_ONCE(sk->sk_txhash);
+
+	if (txhash) {
 		skb->l4_hash = 1;
-		skb->hash = sk->sk_txhash;
+		skb->hash = txhash;
 	}
 }
 
-- 
2.30.2

