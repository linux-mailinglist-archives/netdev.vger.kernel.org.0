Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718FA56636
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfFZKFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:05:34 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:42564 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfFZKFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:05:32 -0400
Received: by mail-pg1-f201.google.com with SMTP id d3so1333904pgc.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jy8fMYv2YTidla/wjAp8GpZbS6xd0gNc7Fo6eo7yPlg=;
        b=Gd9Qoh1VJZQM/AjfN6x75sCYpUpRR6iy/lmiqhgGkgB2yjLts6S3Cusd1crXpTBMJX
         6WG4jmmq+xs5zd2wFhqWI3gpFLT/T6jbSuc1G8/1BYpwgxDNZBK2EOZN4kA8zrUuB7AE
         AUdWmbaMJk5rV+pk6Um+nL151n2U53rr8qqjOEbpNjdq8XikyXOt2TEKg5Juv0zGVIzm
         jF7MlsM9oInxtceNgucp0QrroChtltiBn+HeA9dfgbjFbZrLvu31dp4JfOETibzx7Scj
         1Meu9YS5gl8BLC7Rmd9fX+hTGdh2ZbNuP5rLN9vvlCF0VqBPT9mNgGKGsiFoXBmZt0hw
         4D8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jy8fMYv2YTidla/wjAp8GpZbS6xd0gNc7Fo6eo7yPlg=;
        b=AdbC9DHWtI1N1uHBgrwIXXIXFnoB57KBMSGvhAAfCQeTviQOMFDJTPIVSF0PJUZvID
         dOj4HXkk5y5UfRNNTEj372hLfhYPjgnbdXFNDjTGjPxCFnV39qjACf++LkOsovk0Sfqi
         Gu1KiGB9Mf9fdEwqkhIHerAeIP8B1v5CZcH244S4kFbh+pRltcvIu4bubVdbldwJNR0o
         mw1VzIvW7HFdmgKgwJ74iOe5iQg8r7HhVd2916C8mnQEKB/FWTKnu/yNqSNe+T8V1Ozt
         /z99gHybuHitRb1A5h5kHGrfo+vE7mw84iVwumQnyQhliOtNs6JPJ5meXAvpvFUaUYhX
         Anvw==
X-Gm-Message-State: APjAAAU8r2bKiy466UQx6yyWSa7vWypem+wJGWbWR+bQbC0+k1n9xeOj
        780QDYxpUzHmAdyqaHzxIOfQ8xuBTpZpHg==
X-Google-Smtp-Source: APXvYqz93+VltsqNtGt4qeL7fd50mlmsjOlDnWhggF015LBhL6I7r1VZ0GdymsShIUNVAJqK13jE30+vCCgikA==
X-Received: by 2002:a65:6089:: with SMTP id t9mr2116536pgu.170.1561543531469;
 Wed, 26 Jun 2019 03:05:31 -0700 (PDT)
Date:   Wed, 26 Jun 2019 03:05:28 -0700
Message-Id: <20190626100528.218097-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ipv6: fix suspicious RCU usage in rt6_dump_route()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reminded us that rt6_nh_dump_exceptions() needs to be called
with rcu_read_lock()

net/ipv6/route.c:1593 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor609/8966:
 #0: 00000000b7dbe288 (rtnl_mutex){+.+.}, at: netlink_dump+0xe7/0xfb0 net/netlink/af_netlink.c:2199
 #1: 00000000f2d87c21 (&(&tb->tb6_lock)->rlock){+...}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
 #1: 00000000f2d87c21 (&(&tb->tb6_lock)->rlock){+...}, at: fib6_dump_table.isra.0+0x37e/0x570 net/ipv6/ip6_fib.c:533

stack backtrace:
CPU: 0 PID: 8966 Comm: syz-executor609 Not tainted 5.2.0-rc5+ #43
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5250
 fib6_nh_get_excptn_bucket+0x18e/0x1b0 net/ipv6/route.c:1593
 rt6_nh_dump_exceptions+0x45/0x4d0 net/ipv6/route.c:5541
 rt6_dump_route+0x904/0xc50 net/ipv6/route.c:5640
 fib6_dump_node+0x168/0x280 net/ipv6/ip6_fib.c:467
 fib6_walk_continue+0x4a9/0x8e0 net/ipv6/ip6_fib.c:1986
 fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:2034
 fib6_dump_table.isra.0+0x38a/0x570 net/ipv6/ip6_fib.c:534
 inet6_dump_fib+0x93c/0xb00 net/ipv6/ip6_fib.c:624
 rtnl_dump_all+0x295/0x490 net/core/rtnetlink.c:3445
 netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
 __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:226 [inline]
 rtnetlink_rcv_msg+0x73d/0xb00 net/core/rtnetlink.c:5182
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:646 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:665
 sock_write_iter+0x27c/0x3e0 net/socket.c:994
 call_write_iter include/linux/fs.h:1872 [inline]
 new_sync_write+0x4d3/0x770 fs/read_write.c:483
 __vfs_write+0xe1/0x110 fs/read_write.c:496
 vfs_write+0x20c/0x580 fs/read_write.c:558
 ksys_write+0x14f/0x290 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:620
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc8e134978 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401b9
RDX: 000000000000001c RSI: 0000000020000000 RDI: 00

Fixes: 1e47b4837f3b ("ipv6: Dump route exceptions if requested")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index be5e65c97652d0c34d209f85c8295d6faf871990..c59e97cf9d25da3084098572896178b71fb28fe6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5632,6 +5632,7 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 							   .count = 0 };
 		int err;
 
+		rcu_read_lock();
 		if (rt->nh) {
 			err = nexthop_for_each_fib6_nh(rt->nh,
 						       rt6_nh_dump_exceptions,
@@ -5639,6 +5640,7 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 		} else {
 			err = rt6_nh_dump_exceptions(rt->fib6_nh, &w);
 		}
+		rcu_read_unlock();
 
 		if (err)
 			return count += w.count;
-- 
2.22.0.410.gd8fdbe21b5-goog

