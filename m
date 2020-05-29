Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC21E864A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgE2SIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2SIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:08:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC859C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:08:41 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z5so3529165qtz.16
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tbMs1lGQwQ+Jd8ZVvjnvV0XayB9v5t781YQyBOZ0mRI=;
        b=iXyOzZXX+WMpnzJiqa8whfHzXc4mWEJfWDZwQ5udYbeh81cc9pmnfvwUIw/ONuN9SW
         Aj7NjLKUg8VtRI6DTGLJdf3hV+BM/WdNXSyw/6f7K7ZDarqW4dN1bTUsGFo4lDXQwdaS
         s40hbeVu8Wlx86HH2TLABLJ1Q6oWM/RDnDZgF+Vzb84a7tzbAmvMfQVdppAk7On1ir4c
         x++H8R9aAV0pNr7Hx229aL5VJjTcF2luecCXVJCBhy9ZWN9IFAscPzSbZZCfgGZ11A5r
         rhwMpaSc/GYRMiRJqGmypa/qkbeSq+qhs7gvCkmkYd+fOP0Zx+wqvwXKehclvEj00f1l
         PIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tbMs1lGQwQ+Jd8ZVvjnvV0XayB9v5t781YQyBOZ0mRI=;
        b=YEFN1Hrs/JKpF8BrYi/2kYPcDVuydKrk/uJjBBWL0azArFdbVwytmiFb1alou5Na6l
         MwlTLWoFNTtwzgEtv45DZIbx8WhyP6/OOnujhLP8rWQRR1hNxyp8pyxui9EWIVNvoZBK
         JWXRv0lxJEl0JoFBPU3B7riXwsucAO3ErTh5OZSnuIZblZBmCu16HahQgA8/ec7j5zPs
         U4dqVTI5/+m3V8IENeeHwxmWnazFqZ3ZugbFqCkQwt8qgPL7SKNqUy8/E/VVK41jmHIu
         T8mIKdJU/6eqeejUJ3F1rpV33OF5GVN1fCyZEo4gAViQPZWnamnznAZ7d+HHycdI7tML
         1Eng==
X-Gm-Message-State: AOAM532i3jW9FRAAiI4FYc9qAar8zBmNvX0L5v37rrlM881wT6Gm/IM4
        oLT0xKemoZJXFgO9xg23gKFSpg5Io9ASiw==
X-Google-Smtp-Source: ABdhPJxEETvcfe01g8JGf1qXScyxr9SqyrauatQrDDPQ1h4QK5bGuGu/D7dLf6w1rL8NBXtpUVgOwvRbrzw9NQ==
X-Received: by 2002:a05:6214:1052:: with SMTP id l18mr9900287qvr.90.1590775720983;
 Fri, 29 May 2020 11:08:40 -0700 (PDT)
Date:   Fri, 29 May 2020 11:08:38 -0700
Message-Id: <20200529180838.107255-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH net] l2tp: do not use inet_hash()/inet_unhash()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        James Chapman <jchapman@katalix.com>,
        Andrii Nakryiko <andriin@fb.com>,
        syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/l2tp/l2tp_core.h |  1 +
 net/l2tp/l2tp_ip.c   | 31 ++++++++++++++++++++++++-------
 net/l2tp/l2tp_ip6.c  | 21 +++++++++++++--------
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 10cf7c3dcbb3fb1b27657588f3d1ba806cba737f..097c80c0e323777df997a189eb456e3ae6d26888 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,6 +231,7 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
 			 const struct l2tp_nl_cmd_ops *ops);
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+void l2tp_unhash(struct sock *sk);
 
 static inline void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
 {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 0d7c887a2b75db65afba7955a2bf9572a6a37786..80c09f3be92415c445258e4f3c59d6472dda3ae0 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -20,7 +20,6 @@
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/inet_common.h>
-#include <net/inet_hashtables.h>
 #include <net/tcp_states.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
@@ -209,18 +208,36 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	return 0;
 }
 
+static int l2tp_ip_hash(struct sock *sk)
+{
+	if (sk_unhashed(sk)) {
+		write_lock_bh(&l2tp_ip_lock);
+		sk_add_node(sk, &l2tp_ip_table);
+		write_unlock_bh(&l2tp_ip_lock);
+	}
+	return 0;
+}
+
+void l2tp_unhash(struct sock *sk)
+{
+	if (sk_unhashed(sk))
+		return;
+	write_lock_bh(&l2tp_ip_lock);
+	sk_del_node_init(sk);
+	write_unlock_bh(&l2tp_ip_lock);
+}
+EXPORT_SYMBOL(l2tp_unhash);
+
 static int l2tp_ip_open(struct sock *sk)
 {
 	/* Prevent autobind. We don't have ports. */
 	inet_sk(sk)->inet_num = IPPROTO_L2TP;
 
-	write_lock_bh(&l2tp_ip_lock);
-	sk_add_node(sk, &l2tp_ip_table);
-	write_unlock_bh(&l2tp_ip_lock);
-
+	l2tp_ip_hash(sk);
 	return 0;
 }
 
+
 static void l2tp_ip_close(struct sock *sk, long timeout)
 {
 	write_lock_bh(&l2tp_ip_lock);
@@ -594,8 +611,8 @@ static struct proto l2tp_ip_prot = {
 	.sendmsg	   = l2tp_ip_sendmsg,
 	.recvmsg	   = l2tp_ip_recvmsg,
 	.backlog_rcv	   = l2tp_ip_backlog_recv,
-	.hash		   = inet_hash,
-	.unhash		   = inet_unhash,
+	.hash		   = l2tp_ip_hash,
+	.unhash		   = l2tp_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip_sock),
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ip_setsockopt,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d148766f40d117c50fc28092173d3686428d1dfc..540c00206e0b054e3bca259148715499f7a1b495 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -20,8 +20,6 @@
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/inet_common.h>
-#include <net/inet_hashtables.h>
-#include <net/inet6_hashtables.h>
 #include <net/tcp_states.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
@@ -222,15 +220,22 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	return 0;
 }
 
+static int l2tp_ip6_hash(struct sock *sk)
+{
+	if (sk_unhashed(sk)) {
+		write_lock_bh(&l2tp_ip6_lock);
+		sk_add_node(sk, &l2tp_ip6_table);
+		write_unlock_bh(&l2tp_ip6_lock);
+	}
+	return 0;
+}
+
 static int l2tp_ip6_open(struct sock *sk)
 {
 	/* Prevent autobind. We don't have ports. */
 	inet_sk(sk)->inet_num = IPPROTO_L2TP;
 
-	write_lock_bh(&l2tp_ip6_lock);
-	sk_add_node(sk, &l2tp_ip6_table);
-	write_unlock_bh(&l2tp_ip6_lock);
-
+	l2tp_ip6_hash(sk);
 	return 0;
 }
 
@@ -728,8 +733,8 @@ static struct proto l2tp_ip6_prot = {
 	.sendmsg	   = l2tp_ip6_sendmsg,
 	.recvmsg	   = l2tp_ip6_recvmsg,
 	.backlog_rcv	   = l2tp_ip6_backlog_recv,
-	.hash		   = inet6_hash,
-	.unhash		   = inet_unhash,
+	.hash		   = l2tp_ip6_hash,
+	.unhash		   = l2tp_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip6_sock),
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ipv6_setsockopt,
-- 
2.27.0.rc2.251.g90737beb825-goog

