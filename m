Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B9114BB9
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 05:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLFEnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 23:43:50 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36618 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFEnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 23:43:50 -0500
Received: by mail-pg1-f202.google.com with SMTP id v10so3099360pgg.3
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 20:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=c4wxxLpZCdzxQqxDEf2LNiPu22HLAj3SqehdoFkQDqw=;
        b=v3rh/x/XSVHkkcSDCiRWNOoD8D1PrtnbjjzF45vb0bK5b/cZtxzJXkh70j2rnfHSMV
         EYwIrdrkDbrNtbsWSE3PvYxwgLjnENPmWwgBlh2rU1G+HRRGBEj5a1QW/mQZPejRkQLi
         y/WAElQ8AUR3XSiJmHD2km0thA2bBM5F9aO0PuecWf35SKS5jxEXS6obbD5trPREVDP9
         b1SG5ke16jrKq2X4WIdI9sh0VTa+haX3HSSqOxgfPF0rm2WbRYfpst3ddKOAXakfhwnc
         2ziNDLvX/84/o9KMQL6tWbt+XIQzKcmz3dkY3vRJd3CAq7SbgwDaEknoPw65H7foDrv4
         3HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=c4wxxLpZCdzxQqxDEf2LNiPu22HLAj3SqehdoFkQDqw=;
        b=VL68gGOvfxZADQKRQ4brVw8eT7n12N2bx4HDdLU6vEwsKkYPOKeZycnTnEPMKGCuB8
         Z4qgj3bw93Q79Id8BwyMTGyyJQTlLRoUbKOcTs0/sqkShBfUR1Z5LK2Xh9V7r9DLturP
         kl1COBhJoqKvLHAeanNv2oMaGppYmec8dlSmoIpJuwEP/pQH0TMTg4wbZYG6xlzKep1K
         kmqZcRxxDSyEeOe8GsUvdcGZyGPzssr7JMdK+IQlPc7tzRgemRRKqDj7Wqgcnt8ltdtr
         vHHmuUjDSscQkh8uCEMz5PCR4daXNEURi5bXZc2GQv0nduVtrDoEfJtA+6bLfhk5Q4LT
         OSPw==
X-Gm-Message-State: APjAAAWRfCtlVl0gbhlsvu2OMymyrQ092zhFlSgA1UI6B4II4f3come+
        V+1gwo+1iyuz9iMCN0XA0yrU9j8r+7NW4Q==
X-Google-Smtp-Source: APXvYqzhLKlv1JojtrbPd7EOhEj0Mk2PJ6WWiXlgPXZJsoJzj4s1PSTxN+Z295TzxtX04xkzZURaqqWAeXU5Sw==
X-Received: by 2002:a63:3104:: with SMTP id x4mr1348403pgx.369.1575607429239;
 Thu, 05 Dec 2019 20:43:49 -0800 (PST)
Date:   Thu,  5 Dec 2019 20:43:46 -0800
Message-Id: <20191206044346.155271-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] inet: protect against too small mtu values.
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot was once again able to crash a host by setting a very small mtu
on loopback device.

Let's make inetdev_valid_mtu() available in include/net/ip.h,
and use it in ip_setup_cork(), so that we protect both ip_append_page()
and __ip_append_data()

Also add a READ_ONCE() when the device mtu is read.

Pairs this lockless read with one WRITE_ONCE() in __dev_set_mtu(),
even if other code paths might write over this field.

Add a big comment in include/linux/netdevice.h about dev->mtu
needing READ_ONCE()/WRITE_ONCE() annotations.

Hopefully we will add the missing ones in followup patches.

[1]

refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 9464 at lib/refcount.c:22 refcount_warn_saturate+0x138/0x1f0 lib/refcount.c:22
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9464 Comm: syz-executor850 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x138/0x1f0 lib/refcount.c:22
Code: 06 31 ff 89 de e8 c8 f5 e6 fd 84 db 0f 85 6f ff ff ff e8 7b f4 e6 fd 48 c7 c7 e0 71 4f 88 c6 05 56 a6 a4 06 01 e8 c7 a8 b7 fd <0f> 0b e9 50 ff ff ff e8 5c f4 e6 fd 0f b6 1d 3d a6 a4 06 31 ff 89
RSP: 0018:ffff88809689f550 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e4336 RDI: ffffed1012d13e9c
RBP: ffff88809689f560 R08: ffff88809c50a3c0 R09: fffffbfff15d31b1
R10: fffffbfff15d31b0 R11: ffffffff8ae98d87 R12: 0000000000000001
R13: 0000000000040100 R14: ffff888099041104 R15: ffff888218d96e40
 refcount_add include/linux/refcount.h:193 [inline]
 skb_set_owner_w+0x2b6/0x410 net/core/sock.c:1999
 sock_wmalloc+0xf1/0x120 net/core/sock.c:2096
 ip_append_page+0x7ef/0x1190 net/ipv4/ip_output.c:1383
 udp_sendpage+0x1c7/0x480 net/ipv4/udp.c:1276
 inet_sendpage+0xdb/0x150 net/ipv4/af_inet.c:821
 kernel_sendpage+0x92/0xf0 net/socket.c:3794
 sock_sendpage+0x8b/0xc0 net/socket.c:936
 pipe_to_sendpage+0x2da/0x3c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x3ee/0x7c0 fs/splice.c:636
 splice_from_pipe+0x108/0x170 fs/splice.c:671
 generic_splice_sendpage+0x3c/0x50 fs/splice.c:842
 do_splice_from fs/splice.c:861 [inline]
 direct_splice_actor+0x123/0x190 fs/splice.c:1035
 splice_direct_to_actor+0x3b4/0xa30 fs/splice.c:990
 do_splice_direct+0x1da/0x2a0 fs/splice.c:1078
 do_sendfile+0x597/0xd00 fs/read_write.c:1464
 __do_sys_sendfile64 fs/read_write.c:1525 [inline]
 __se_sys_sendfile64 fs/read_write.c:1511 [inline]
 __x64_sys_sendfile64+0x1dd/0x220 fs/read_write.c:1511
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441409
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffb64c4f78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441409
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000005
RBP: 0000000000073b8a R08: 0000000000000010 R09: 0000000000000010
R10: 0000000000010001 R11: 0000000000000246 R12: 0000000000402180
R13: 0000000000402210 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

Fixes: 1470ddf7f8ce ("inet: Remove explicit write references to sk/inet in ip_append_data")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/linux/netdevice.h |  5 +++++
 include/net/ip.h          |  5 +++++
 net/core/dev.c            |  3 ++-
 net/ipv4/devinet.c        |  5 -----
 net/ipv4/ip_output.c      | 13 ++++++++-----
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cf0923579af4f50f60b1daa2aece483787e260cd..9ef20389622d7bbefbf5ab30a2897ba8b2290cb1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1881,6 +1881,11 @@ struct net_device {
 	unsigned char		if_port;
 	unsigned char		dma;
 
+	/* Note : dev->mtu is often read without holding a lock.
+	 * Writers usually hold RTNL.
+	 * It is recommended to use READ_ONCE() to annotate the reads,
+	 * and to use WRITE_ONCE() to annotate the writes.
+	 */
 	unsigned int		mtu;
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
diff --git a/include/net/ip.h b/include/net/ip.h
index 02d68e346f6729ddd5fb019ff70cdad6a46983a5..5b317c9f4470a93abae9cbe8e7dfd3e919aa8851 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -760,4 +760,9 @@ int ip_misc_proc_init(void);
 int rtm_getroute_parse_ip_proto(struct nlattr *attr, u8 *ip_proto, u8 family,
 				struct netlink_ext_ack *extack);
 
+static inline bool inetdev_valid_mtu(unsigned int mtu)
+{
+	return likely(mtu >= IPV4_MIN_MTU);
+}
+
 #endif	/* _IP_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index e7c027fb48084f4ff32a7d5b4d69100716ddabd9..2c277b8aba38bf348093967a0fe7dd1d0aca4796 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8188,7 +8188,8 @@ int __dev_set_mtu(struct net_device *dev, int new_mtu)
 	if (ops->ndo_change_mtu)
 		return ops->ndo_change_mtu(dev, new_mtu);
 
-	dev->mtu = new_mtu;
+	/* Pairs with all the lockless reads of dev->mtu in the stack */
+	WRITE_ONCE(dev->mtu, new_mtu);
 	return 0;
 }
 EXPORT_SYMBOL(__dev_set_mtu);
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4d2c89e0ce9574199a467d53ee8504876c..e4632bd2026d8ee9d4e4618fbbf3117648080fa4 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1496,11 +1496,6 @@ static void inetdev_changename(struct net_device *dev, struct in_device *in_dev)
 	}
 }
 
-static bool inetdev_valid_mtu(unsigned int mtu)
-{
-	return mtu >= IPV4_MIN_MTU;
-}
-
 static void inetdev_send_gratuitous_arp(struct net_device *dev,
 					struct in_device *in_dev)
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9d83cb320dcb77d803554b950adce0d655c043ae..14db1e0b8a6e120a9410669dd635c32b77637818 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1258,15 +1258,18 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 		cork->addr = ipc->addr;
 	}
 
-	/*
-	 * We steal reference to this route, caller should not release it
-	 */
-	*rtp = NULL;
 	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : rt->dst.dev->mtu;
+			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+
+	if (!inetdev_valid_mtu(cork->fragsize))
+		return -ENETUNREACH;
 
 	cork->gso_size = ipc->gso_size;
+
 	cork->dst = &rt->dst;
+	/* We stole this route, caller should not release it. */
+	*rtp = NULL;
+
 	cork->length = 0;
 	cork->ttl = ipc->ttl;
 	cork->tos = ipc->tos;
-- 
2.24.0.393.g34dc348eaf-goog

