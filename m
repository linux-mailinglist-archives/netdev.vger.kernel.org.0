Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB171EF78E
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgFEM1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgFEM03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668FA207D3;
        Fri,  5 Jun 2020 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359988;
        bh=y3iudsv8kozWffz/xN23JmqgvUxt40YMFKzvx83ZykI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWyUF/sRY3OVOqVQbkFsWKKmIjqsW3brhDOYgPlSC2qzWZGUIOCq789aNQWDKWXNQ
         cBesuxer78khcNYY6yYZUrytksgZkIx6a6KLyxp95bM70C9wv4+oOv9PGx6NIoFPy/
         bdH7+FTlzb+zmLCM+zTN/JkgUC+Dk8upKelt7zWI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        James Chapman <jchapman@katalix.com>,
        Andrii Nakryiko <andriin@fb.com>,
        syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/6] l2tp: do not use inet_hash()/inet_unhash()
Date:   Fri,  5 Jun 2020 08:26:20 -0400
Message-Id: <20200605122620.2882962-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122620.2882962-1-sashal@kernel.org>
References: <20200605122620.2882962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 02c71b144c811bcdd865e0a1226d0407d11357e8 ]

syzbot recently found a way to crash the kernel [1]

Issue here is that inet_hash() & inet_unhash() are currently
only meant to be used by TCP & DCCP, since only these protocols
provide the needed hashinfo pointer.

L2TP uses a single list (instead of a hash table)

This old bug became an issue after commit 610236587600
("bpf: Add new cgroup attach type to enable sock modifications")
since after this commit, sk_common_release() can be called
while the L2TP socket is still considered 'hashed'.

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sk_common_release+0xba/0x370 net/core/sock.c:3210
 inet_create net/ipv4/af_inet.c:390 [inline]
 inet_create+0x966/0xe00 net/ipv4/af_inet.c:248
 __sock_create+0x3cb/0x730 net/socket.c:1428
 sock_create net/socket.c:1479 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1521
 __do_sys_socket net/socket.c:1530 [inline]
 __se_sys_socket net/socket.c:1528 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441e29
Code: e8 fc b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdce184148 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441e29
RDX: 0000000000000073 RSI: 0000000000000002 RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000402c30 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 23b6578228ce553e ]---
RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ip.c  | 29 ++++++++++++++++++++++-------
 net/l2tp/l2tp_ip6.c | 30 ++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4a88c4eb2301..3817c3554641 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -24,7 +24,6 @@
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/inet_common.h>
-#include <net/inet_hashtables.h>
 #include <net/tcp_states.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
@@ -208,15 +207,31 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	return 0;
 }
 
-static int l2tp_ip_open(struct sock *sk)
+static int l2tp_ip_hash(struct sock *sk)
 {
-	/* Prevent autobind. We don't have ports. */
-	inet_sk(sk)->inet_num = IPPROTO_L2TP;
+	if (sk_unhashed(sk)) {
+		write_lock_bh(&l2tp_ip_lock);
+		sk_add_node(sk, &l2tp_ip_table);
+		write_unlock_bh(&l2tp_ip_lock);
+	}
+	return 0;
+}
 
+static void l2tp_ip_unhash(struct sock *sk)
+{
+	if (sk_unhashed(sk))
+		return;
 	write_lock_bh(&l2tp_ip_lock);
-	sk_add_node(sk, &l2tp_ip_table);
+	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip_lock);
+}
+
+static int l2tp_ip_open(struct sock *sk)
+{
+	/* Prevent autobind. We don't have ports. */
+	inet_sk(sk)->inet_num = IPPROTO_L2TP;
 
+	l2tp_ip_hash(sk);
 	return 0;
 }
 
@@ -598,8 +613,8 @@ static struct proto l2tp_ip_prot = {
 	.sendmsg	   = l2tp_ip_sendmsg,
 	.recvmsg	   = l2tp_ip_recvmsg,
 	.backlog_rcv	   = l2tp_ip_backlog_recv,
-	.hash		   = inet_hash,
-	.unhash		   = inet_unhash,
+	.hash		   = l2tp_ip_hash,
+	.unhash		   = l2tp_ip_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip_sock),
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ip_setsockopt,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 28274f397c55..76ef758db112 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -24,8 +24,6 @@
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/inet_common.h>
-#include <net/inet_hashtables.h>
-#include <net/inet6_hashtables.h>
 #include <net/tcp_states.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
@@ -221,15 +219,31 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	return 0;
 }
 
-static int l2tp_ip6_open(struct sock *sk)
+static int l2tp_ip6_hash(struct sock *sk)
 {
-	/* Prevent autobind. We don't have ports. */
-	inet_sk(sk)->inet_num = IPPROTO_L2TP;
+	if (sk_unhashed(sk)) {
+		write_lock_bh(&l2tp_ip6_lock);
+		sk_add_node(sk, &l2tp_ip6_table);
+		write_unlock_bh(&l2tp_ip6_lock);
+	}
+	return 0;
+}
 
+static void l2tp_ip6_unhash(struct sock *sk)
+{
+	if (sk_unhashed(sk))
+		return;
 	write_lock_bh(&l2tp_ip6_lock);
-	sk_add_node(sk, &l2tp_ip6_table);
+	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip6_lock);
+}
+
+static int l2tp_ip6_open(struct sock *sk)
+{
+	/* Prevent autobind. We don't have ports. */
+	inet_sk(sk)->inet_num = IPPROTO_L2TP;
 
+	l2tp_ip6_hash(sk);
 	return 0;
 }
 
@@ -732,8 +746,8 @@ static struct proto l2tp_ip6_prot = {
 	.sendmsg	   = l2tp_ip6_sendmsg,
 	.recvmsg	   = l2tp_ip6_recvmsg,
 	.backlog_rcv	   = l2tp_ip6_backlog_recv,
-	.hash		   = inet6_hash,
-	.unhash		   = inet_unhash,
+	.hash		   = l2tp_ip6_hash,
+	.unhash		   = l2tp_ip6_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip6_sock),
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ipv6_setsockopt,
-- 
2.25.1

