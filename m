Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34ADA13CD96
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgAOT5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:57:46 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43252 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgAOT5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:57:45 -0500
Received: by mail-pf1-f201.google.com with SMTP id x199so11525000pfc.10
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 11:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sUqEIyiGgk2Qc3Nfsf/MhVjJNLXz5U1bapJ+AwLhEr4=;
        b=ALVZlqIELTGhHCLbUpklNEPSbhnOG1ZJpa3WaJ+aFQ5Nb4R4RWgKpwhzjvXFZeHt+T
         fFQSaxG0vsQOVsAuBzkkPOhD4dSCT1HDDJK58+Nm69JQalBuvOTW5CmQT2mf0IGgi/v/
         M+ArcdjQmRBIx/Ga9T4GW1lwWliUkyjP6YmCAAO+/XoJj4HKSX0kPbpDC4lQ7C8J8pww
         sS+eiJuPJZjc+1Kf0zoS5V/vki0G8QQHUTQJgBfwwzwczQ4gdmGkF9BzWFDdCtCWgMc5
         q9+yQxZyuXr4lOrfhOgSE0PTkANxPfE/NMMQjmAwqmSDY9Gu2Gz3j6p8NQSZcAaa7ZSz
         E0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sUqEIyiGgk2Qc3Nfsf/MhVjJNLXz5U1bapJ+AwLhEr4=;
        b=Lk6WL63vPG+InpnY4PqPHMH0v3NGebAU9Q1FFIDzbwZH2Zb7gIuONpwmis3htLi431
         rEA5DfCWlFoClbWitO6gPGriScpWX1yqYvGFsNw7o5gkZS+2b+EnFyhZ3LF8uttZc7Ug
         /DhXIXq0XPNVGCZSfmroShxr4V6ugyHrxL2owzDaZwajtr1nbYDK/ORi4qlhIxXdcxxt
         44kl1meX1Nqt0iuLeQs+Bl1knTPCm5clysqOl2L77HkvXUmjBG6F8l7Luv0hPaboDmE9
         V/PpzqplORsZzB0gt30c8vleeWMncVYlE2oFA0TEEHbdlTUggGAyyOERsaxxi7wWePOQ
         WDgQ==
X-Gm-Message-State: APjAAAUepYU/syIST/jG7hNcfHbxG/1BhV0FhresFy/2xcu4D+xS1LQX
        j8xOvLql27xUN3Af0/hLKpV8CLPHrWI06w==
X-Google-Smtp-Source: APXvYqzd/RC1ubEp/X+wCam9syUSCDaxNwAJbj7jg4GbVWIUwyLurCJ0bSb6LqM3dzoj59dku29qTBJNHIKGjw==
X-Received: by 2002:a63:c652:: with SMTP id x18mr35434432pgg.211.1579118264606;
 Wed, 15 Jan 2020 11:57:44 -0800 (PST)
Date:   Wed, 15 Jan 2020 11:57:41 -0800
Message-Id: <20200115195741.86879-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH net-next] netdevsim: fix nsim_fib6_rt_create() error path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems nsim_fib6_rt_create() intent was to return
either a valid pointer or an embedded error code.

BUG: unable to handle page fault for address: fffffffffffffff4
PGD 9870067 P4D 9870067 PUD 9872067 PMD 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 22851 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:jhash2 include/linux/jhash.h:125 [inline]
RIP: 0010:rhashtable_jhash2+0x76/0x2c0 lib/rhashtable.c:963
Code: b9 00 00 00 00 00 fc ff df 48 c1 e8 03 0f b6 14 08 4c 89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 30 02 00 00 49 8d 7e 04 <41> 8b 06 48 be 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6
RSP: 0018:ffffc90016127190 EFLAGS: 00010246
RAX: 0000000000000007 RBX: 00000000dfb3ab49 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff839ba7c8 RDI: fffffffffffffff8
RBP: ffffc900161271c0 R08: ffff8880951f8640 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 00000000dfb3ab49
R13: 00000000dfb3ab49 R14: fffffffffffffff4 R15: 0000000000000007
FS:  00007f40bfbc6700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffff4 CR3: 0000000093660000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rht_key_get_hash include/linux/rhashtable.h:133 [inline]
 rht_key_hashfn include/linux/rhashtable.h:159 [inline]
 rht_head_hashfn include/linux/rhashtable.h:174 [inline]
 __rhashtable_insert_fast.constprop.0+0xe15/0x1180 include/linux/rhashtable.h:723
 rhashtable_insert_fast include/linux/rhashtable.h:832 [inline]
 nsim_fib6_rt_add drivers/net/netdevsim/fib.c:603 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:658 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:719 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:744 [inline]
 nsim_fib_event_nb+0x1b16/0x2600 drivers/net/netdevsim/fib.c:772
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __atomic_notifier_call_chain+0xa6/0x1a0 kernel/notifier.c:173
 atomic_notifier_call_chain+0x2e/0x40 kernel/notifier.c:183
 call_fib_notifiers+0x173/0x2a0 net/core/fib_notifier.c:35
 call_fib6_notifiers+0x4b/0x60 net/ipv6/fib6_notifier.c:22
 call_fib6_entry_notifiers+0xfb/0x150 net/ipv6/ip6_fib.c:399
 fib6_add_rt2node net/ipv6/ip6_fib.c:1216 [inline]
 fib6_add+0x20cd/0x3ec0 net/ipv6/ip6_fib.c:1471
 __ip6_ins_rt+0x54/0x80 net/ipv6/route.c:1315
 ip6_ins_rt+0x96/0xd0 net/ipv6/route.c:1325
 __ipv6_dev_ac_inc+0x76f/0xb20 net/ipv6/anycast.c:324
 ipv6_sock_ac_join+0x4c1/0x790 net/ipv6/anycast.c:139
 do_ipv6_setsockopt.isra.0+0x3908/0x4290 net/ipv6/ipv6_sockglue.c:670
 ipv6_setsockopt+0xff/0x180 net/ipv6/ipv6_sockglue.c:944
 udpv6_setsockopt+0x68/0xb0 net/ipv6/udp.c:1564
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9

Fixes: 48bb9eb47b27 ("netdevsim: fib: Add dummy implementation for FIB offload")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 8f56289fc2eca738b17b78176b7fa4f5cb04bee5..f32d56ac3e80faaa9e30b6b6aea8cc1b49a6f947 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -467,7 +467,7 @@ nsim_fib6_rt_create(struct nsim_fib_data *data,
 
 	fib6_rt = kzalloc(sizeof(*fib6_rt), GFP_ATOMIC);
 	if (!fib6_rt)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	nsim_fib_rt_init(data, &fib6_rt->common, &rt->fib6_dst.addr,
 			 sizeof(rt->fib6_dst.addr), rt->fib6_dst.plen, AF_INET6,
@@ -650,8 +650,8 @@ static int nsim_fib6_rt_insert(struct nsim_fib_data *data,
 	int err;
 
 	fib6_rt = nsim_fib6_rt_create(data, fen6_info);
-	if (!fib6_rt)
-		return -ENOMEM;
+	if (IS_ERR(fib6_rt))
+		return PTR_ERR(fib6_rt);
 
 	fib6_rt_old = nsim_fib6_rt_lookup(&data->fib_rt_ht, fen6_info->rt);
 	if (!fib6_rt_old)
-- 
2.25.0.rc1.283.g88dfdc4193-goog

