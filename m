Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F2C3AF398
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhFUSCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhFUSAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A37613C1;
        Mon, 21 Jun 2021 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298069;
        bh=+Ojwv5F+UxLZHrjTwUjXHAHeFxZdFCFjetfev3W+jko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LU2Kc6QN22ap1Cth93fH9i6H5GwDcaj8H1wa+ONAERr/OXwA8MZ2qD9ey3cw3yjF7
         /pK8NpC3RfmlTa59VnmQ3lRjoBsetZSas2nPJrvUV0FMKzOFQDO5aKjuVD+vURkY0i
         0a1o0+TA0ycXbs4LcFCO7H0qHdUh7k2nKv+ZWvj38tOphRN5+XDHMXUNdmz9iy9nfl
         zi0Du91sLJ06TAx2sFzODeAhNcASQAYHd6ej/yACop+YqwFmVvD+CkIO2uEPAAaVMt
         VPeRbaOeBx+YqpO87cf8wT6yQYTu89VD50asvdvgXQbeLE4LSh22K2R0HwHgGthQvl
         P6GF9rWNqhmwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/26] net/packet: annotate accesses to po->bind
Date:   Mon, 21 Jun 2021 13:53:49 -0400
Message-Id: <20210621175400.735800-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c7d2ef5dd4b03ed0ee1d13bc0c55f9cf62d49bd6 ]

tpacket_snd(), packet_snd(), packet_getname() and packet_seq_show()
can read po->num without holding a lock. This means other threads
can change po->num at the same time.

KCSAN complained about this known fact [1]
Add READ_ONCE()/WRITE_ONCE() to address the issue.

[1] BUG: KCSAN: data-race in packet_do_bind / packet_sendmsg

write to 0xffff888131a0dcc0 of 2 bytes by task 24714 on cpu 0:
 packet_do_bind+0x3ab/0x7e0 net/packet/af_packet.c:3181
 packet_bind+0xc3/0xd0 net/packet/af_packet.c:3255
 __sys_bind+0x200/0x290 net/socket.c:1637
 __do_sys_bind net/socket.c:1648 [inline]
 __se_sys_bind net/socket.c:1646 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1646
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888131a0dcc0 of 2 bytes by task 24719 on cpu 1:
 packet_snd net/packet/af_packet.c:2899 [inline]
 packet_sendmsg+0x317/0x3570 net/packet/af_packet.c:3040
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2433
 __do_sys_sendmsg net/socket.c:2442 [inline]
 __se_sys_sendmsg net/socket.c:2440 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2440
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x1200

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 24719 Comm: syz-executor.5 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fbc2d4dfddf0..e582799d4e85 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2656,7 +2656,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	}
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
-		proto	= po->num;
+		proto	= READ_ONCE(po->num);
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2869,7 +2869,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
-		proto	= po->num;
+		proto	= READ_ONCE(po->num);
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -3141,7 +3141,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 			/* prevents packet_notifier() from calling
 			 * register_prot_hook()
 			 */
-			po->num = 0;
+			WRITE_ONCE(po->num, 0);
 			__unregister_prot_hook(sk, true);
 			rcu_read_lock();
 			dev_curr = po->prot_hook.dev;
@@ -3151,7 +3151,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		}
 
 		BUG_ON(po->running);
-		po->num = proto;
+		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
 		if (unlikely(unlisted)) {
@@ -3496,7 +3496,7 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
-	sll->sll_protocol = po->num;
+	sll->sll_protocol = READ_ONCE(po->num);
 	sll->sll_pkttype = 0;
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
@@ -4405,7 +4405,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	was_running = po->running;
 	num = po->num;
 	if (was_running) {
-		po->num = 0;
+		WRITE_ONCE(po->num, 0);
 		__unregister_prot_hook(sk, false);
 	}
 	spin_unlock(&po->bind_lock);
@@ -4440,7 +4440,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	spin_lock(&po->bind_lock);
 	if (was_running) {
-		po->num = num;
+		WRITE_ONCE(po->num, num);
 		register_prot_hook(sk);
 	}
 	spin_unlock(&po->bind_lock);
@@ -4613,7 +4613,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   s,
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
-			   ntohs(po->num),
+			   ntohs(READ_ONCE(po->num)),
 			   po->ifindex,
 			   po->running,
 			   atomic_read(&s->sk_rmem_alloc),
-- 
2.30.2

