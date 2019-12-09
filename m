Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB01171B7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLIQdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:05 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57319 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfLIQdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:03 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy1-0001up-2z; Mon, 09 Dec 2019 17:33:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 03/13] can: j1939: j1939_sk_bind(): take priv after lock is held
Date:   Mon,  9 Dec 2019 17:32:46 +0100
Message-Id: <20191209163256.12000-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

syzbot reproduced following crash:

===============================================================================
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9844 Comm: syz-executor.0 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
RIP: 0010:__lock_acquire+0x1254/0x4a00 kernel/locking/lockdep.c:3828
Code: 00 0f 85 96 24 00 00 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41
5f 5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02
00 0f 85 0b 28 00 00 49 81 3e 20 19 78 8a 0f 84 5f ee ff
RSP: 0018:ffff888099c3fb48 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000218 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff888099c3fc60 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff146e1d0 R11: ffff888098720400 R12: 00000000000010c0
R13: 0000000000000000 R14: 00000000000010c0 R15: 0000000000000000
FS:  00007f0559e98700(0000) GS:ffff8880ae800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe4d89e0000 CR3: 0000000099606000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:343 [inline]
 j1939_jsk_del+0x32/0x210 net/can/j1939/socket.c:89
 j1939_sk_bind+0x2ea/0x8f0 net/can/j1939/socket.c:448
 __sys_bind+0x239/0x290 net/socket.c:1648
 __do_sys_bind net/socket.c:1659 [inline]
 __se_sys_bind net/socket.c:1657 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1657
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0559e97c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a679
RDX: 0000000000000018 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0559e986d4
R13: 00000000004c09e9 R14: 00000000004d37d0 R15: 00000000ffffffff
Modules linked in:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 9844 at kernel/locking/mutex.c:1419
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427
===============================================================================

This issues was caused by null pointer deference. Where j1939_sk_bind()
was using currently not existing priv.

Possible scenario may look as following:
cpu0                                    cpu1
bind()
                                        bind()
 j1939_sk_bind()
                                         j1939_sk_bind()
  priv = jsk->priv;
                                         priv = jsk->priv;
  lock_sock(sock->sk);
  priv = j1939_netdev_start(ndev);
  j1939_jsk_add(priv, jsk);
    jsk->priv = priv;
  relase_sock(sock->sk);
                                         lock_sock(sock->sk);
                                         j1939_jsk_del(priv, jsk);
                                         ..... ooops ......

With this patch we move "priv = jsk->priv;" after the lock, to avoid
assigning of wrong priv pointer.

Reported-by: syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index de09b0a65791..f7587428febd 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -423,9 +423,9 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 {
 	struct sockaddr_can *addr = (struct sockaddr_can *)uaddr;
 	struct j1939_sock *jsk = j1939_sk(sock->sk);
-	struct j1939_priv *priv = jsk->priv;
-	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
+	struct j1939_priv *priv;
+	struct sock *sk;
+	struct net *net;
 	int ret = 0;
 
 	ret = j1939_sk_sanity_check(addr, len);
@@ -434,6 +434,10 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	lock_sock(sock->sk);
 
+	priv = jsk->priv;
+	sk = sock->sk;
+	net = sock_net(sk);
+
 	/* Already bound to an interface? */
 	if (jsk->state & J1939_SOCK_BOUND) {
 		/* A re-bind() to a different interface is not
-- 
2.24.0

