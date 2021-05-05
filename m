Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A33735A6
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhEEHe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhEEHe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 03:34:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33977C061574;
        Wed,  5 May 2021 00:33:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so362803pjy.3;
        Wed, 05 May 2021 00:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BUAPIm3iMwQwqfPMRN4i1+zE77O5pOfChKH66VkGfDQ=;
        b=X6iJm4caK45zSkCB2gggbLhoLyOSqpO8rHWLIIeInanGflnr+kFjAs9aPsUoLn98//
         7IpQrcXnJbXQQhAvOUQlj5dh6lfQPUYYwXv+9nwmeXz+XSMDPAPa9kqT8rilOaYRqWaq
         dnkrdiitxMsyQL90rv4Zn/fvMCT4I5twS9hlt6B1rB6FAUulizW2lJNl8sAPTFj+VIle
         S7PugNCz4lg135XAQf+JMLHsXi+h4aPFuAuVIRBWbDdtT7nia0RssiKT6kWQbuG3M15a
         p4qcP3pxYhQnRmBCF/EZ0GJ5UZkThA/X312M1JUf60iK4V34W5YJB/KD3mG3HA8GKHiR
         1nAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BUAPIm3iMwQwqfPMRN4i1+zE77O5pOfChKH66VkGfDQ=;
        b=OZz/3WKplbOFcUg3SZhaf2bgN1AdVaEJQtTsdS/IRJ4SPtBDP4MsZULUN81aPGDE+B
         Xzt5VGvt37wibgvbwOBwWqzCuCIGU3sH7a6cxcuoTSZig4oe2HfaCIZii8qe/TBcdvAy
         Z4Sa4p1zRK+27jSXE5KLAZ61dJZYmC141bYKQ5cN6cCE87EEeetIQrcqgJKAsryz1Q+R
         l4o1dgLcOJlLQJPu82HXnNNixa5DZN700OqCSUtBJe2SAaWkjRoga160AKMZnTGIrsdP
         qBHvpiinBXAfzA4ufxW87mJoLpBBSFyPH3L7rw0qxNwF23c7+Nz2grTzJtvqTvP/v8+5
         zbEw==
X-Gm-Message-State: AOAM532YPzVCxxmWW8zijQbM7tzVJI0rvoXEBMyG1/iW9gpE79gSAExD
        pS630dH5IlYuGNBkJ0J91xU=
X-Google-Smtp-Source: ABdhPJwbIYGzwJWIyFRWmHnr6CcLzKGuX5QhmS2n/xsVtiDUDoFnFYkrdqDisYJUhoFa5YGQnVB4gw==
X-Received: by 2002:a17:90a:1b0b:: with SMTP id q11mr33576413pjq.181.1620200009686;
        Wed, 05 May 2021 00:33:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3f07:f342:703:2279])
        by smtp.gmail.com with ESMTPSA id r32sm5488839pgm.49.2021.05.05.00.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 00:33:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netfilter: nfnetlink: add a missing rcu_read_unlock()
Date:   Wed,  5 May 2021 00:33:24 -0700
Message-Id: <20210505073324.1985884-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Reported by syzbot :
BUG: sleeping function called from invalid context at include/linux/sched/mm.h:201
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 26899, name: syz-executor.5
1 lock held by syz-executor.5/26899:
 #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_get_subsys net/netfilter/nfnetlink.c:148 [inline]
 #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_rcv_msg+0x1da/0x1300 net/netfilter/nfnetlink.c:226
Preemption disabled at:
[<ffffffff8917799e>] preempt_schedule_irq+0x3e/0x90 kernel/sched/core.c:5533
CPU: 1 PID: 26899 Comm: syz-executor.5 Not tainted 5.12.0-next-20210504-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8338
 might_alloc include/linux/sched/mm.h:201 [inline]
 slab_pre_alloc_hook mm/slab.h:500 [inline]
 slab_alloc_node mm/slub.c:2845 [inline]
 kmem_cache_alloc_node+0x33d/0x3e0 mm/slub.c:2960
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:413
 alloc_skb include/linux/skbuff.h:1107 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x1ed/0xaa0 net/netlink/af_netlink.c:2437
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2508
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:650
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa8a03ee188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000480 RDI: 0000000000000004
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007fffe864480f R14: 00007fa8a03ee300 R15: 0000000000022000

================================================
WARNING: lock held when returning to user space!
5.12.0-next-20210504-syzkaller #0 Tainted: G        W
------------------------------------------------
syz-executor.5/26899 is leaving the kernel with locks still held!
1 lock held by syz-executor.5/26899:
 #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_get_subsys net/netfilter/nfnetlink.c:148 [inline]
 #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_rcv_msg+0x1da/0x1300 net/netfilter/nfnetlink.c:226
------------[ cut here ]------------
WARNING: CPU: 0 PID: 26899 at kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0xfd/0x16e0 kernel/rcu/tree_plugin.h:359
Modules linked in:
CPU: 0 PID: 26899 Comm: syz-executor.5 Tainted: G        W         5.12.0-next-20210504-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_note_context_switch+0xfd/0x16e0 kernel/rcu/tree_plugin.h:359
Code: 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2e 0d 00 00 8b bd cc 03 00 00 85 ff 7e 02 <0f> 0b 65 48 8b 2c 25 00 f0 01 00 48 8d bd cc 03 00 00 48 b8 00 00
RSP: 0000:ffffc90002fffdb0 EFLAGS: 00010002
RAX: 0000000000000007 RBX: ffff8880b9c36080 RCX: ffffffff8dc99bac
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000001
RBP: ffff88808b9d1c80 R08: 0000000000000000 R09: ffffffff8dc96917
R10: fffffbfff1b92d22 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88808b9d1c80 R14: ffff88808b9d1c80 R15: ffffc90002ff8000
FS:  00007fa8a03ee700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f09896ed000 CR3: 0000000032070000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __schedule+0x214/0x23e0 kernel/sched/core.c:5044
 schedule+0xcf/0x270 kernel/sched/core.c:5226
 exit_to_user_mode_loop kernel/entry/common.c:162 [inline]
 exit_to_user_mode_prepare+0x13e/0x280 kernel/entry/common.c:208
 irqentry_exit_to_user_mode+0x5/0x40 kernel/entry/common.c:314
 asm_sysvec_reschedule_ipi+0x12/0x20 arch/x86/include/asm/idtentry.h:637
RIP: 0033:0x4665f9

Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nfnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index d7a9628b6cee50783dc033f17bc6492abe0d176d..e8dbd8379027e32cf3440624e8bb8622df1328a9 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -295,6 +295,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_unlock(subsys_id);
 			break;
 		default:
+			rcu_read_unlock();
 			err = -EINVAL;
 			break;
 		}
-- 
2.31.1.527.g47e6f16901-goog

