Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA31655D97
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 16:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiLYP5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 10:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiLYP5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 10:57:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77DD2BE1;
        Sun, 25 Dec 2022 07:57:36 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id t17so22091047eju.1;
        Sun, 25 Dec 2022 07:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dKOoFYMb23hz5hGId4Wz/IenSn26vXqIKiFsqflZL3w=;
        b=G4KJclbw5GwJaoCKFjIVpXJ+c8XB0NTbwbsigkAbGPGNtFPMZxsNeFywGxlAsugOsq
         NkUX0ibiNDXP8IiVenK1vFtLsL23TiDKe2BTOwnQNTYvVRINeBfWzS5bWrRQeO65M1ze
         4zM/dbJgTGwb3LCf5atAIp+Hm2z9aKKV/YaZx7xcEptk8imV2EFB/tGy8CEbyIKIBFzR
         J50eP1cwe1a5BfnojwKJyfVaGKxun45Ihxr8fBQORw1NWYfS+21p6LrjeZGtpxOpEq4d
         b9F/INPHLTYgJB7gqHdB/aeceeYu9inq5TlXkr0PbcCb2gLt0kHA8dvzdL4tfHYEEFmg
         lk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKOoFYMb23hz5hGId4Wz/IenSn26vXqIKiFsqflZL3w=;
        b=fk4V0isJJxuKQDTDz6XVezZ5EaY4FF4l7EVgl0PknHqRrP+rNM2R/gr34bnsYawizj
         j0ValTR2eExcOmqFMlgO8N5LE2nSy0VVTdr+s8IuguhVdbO4IDbbO4oqMA/ewmLgELfJ
         uMpSIU5UzwNJgmIFhnwfbIjdHZCnbWTPN2rZpS51GKHKN5si1QPsd61ZAnBUdAxEHuZV
         BzoajJERAdnnHwHizIaJ3AP3pdqZiNFRZU8Z7y+EuPCy90SWK2oTJj1jzFaPJ/yMf2cf
         glMVzPa7bdJriafj7pQBxvA/kWUPxdeVUJ8DZXIZWs+0m8XK2QB+Z99iG0A2eaKiS5aD
         uDYw==
X-Gm-Message-State: AFqh2kqzD4zRMKngv67Dj+v/gWFO6BhtvrAEhIHoN1I7AqyIrfRuPevi
        Dn9GD7yRCkQHSfxDWF2g8U5KaY/V3nBvfev/wD8=
X-Google-Smtp-Source: AMrXdXtNijvwutA6ANdLMosvdoUrJbJuHXtFWb3RoFGMSdC2EFjz2bT/l4tuccig/fJ05iLdUbZHsgaROUk6fDOH5SA=
X-Received: by 2002:a17:906:a383:b0:840:2076:5310 with SMTP id
 k3-20020a170906a38300b0084020765310mr1257471ejz.371.1671983854957; Sun, 25
 Dec 2022 07:57:34 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 25 Dec 2022 23:56:59 +0800
Message-ID: <CAO4mrfdy+3umc43dtHudvjU8ec-PzAhrwPNqXS3n1vxQN24nng@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in try_to_wake_up
To:     dhowells@redhat.com, marc.dionne@auristor.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developers,

Recently, when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit:  e45fb347b630 Linux 6.1.0-next-20221220
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1d2Bl86zvgz1mdE-cYUT3lnbPGAagNUZf/view?usp=share_link
kernel config: https://drive.google.com/file/d/1mMD6aopttKDGK4aYUlgiwAk6bOQHivd-/view?usp=share_link

Unfortunately, I do not have a reproducer for this crash. It seems
like when dereferencing p->pi_lock->raw_lock->val->counter, null ptr
deref is triggered.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: kernel NULL pointer dereference, address: 0000000000000834
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 56ef4067 P4D 56ef4067 PUD 58112067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
CPU: 0 PID: 12 Comm: ksoftirqd/0 Not tainted 6.1.0-next-20221220 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:arch_atomic_try_cmpxchg arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire
include/linux/atomic/atomic-instrumented.h:543 [inline]
RIP: 0010:queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
RIP: 0010:do_raw_spin_lock include/linux/spinlock.h:186 [inline]
RIP: 0010:__raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:111 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x4e/0xa0 kernel/locking/spinlock.c:162
Code: 48 c7 04 24 00 00 00 00 9c 8f 04 24 48 89 df e8 88 fb 8d fc 48
8b 1c 24 fa bd 01 00 00 00 bf 01 00 00 00 e8 a4 9c 66 fc 31 c0 <3e> 41
0f b1 2e 75 1c 65 48 8b 04 25 28 00 00 00 48 3b 44 24 08 75
RSP: 0018:ffffc90000497908 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffffffff84ad1b08
RDX: 0000000000000996 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0001c9000049790f R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000497908 R12: 0000000000000834
R13: ffffffff84446de0 R14: 0000000000000834 R15: ffff888061b71700
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000834 CR3: 0000000057b36000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 try_to_wake_up+0x3d/0x430 kernel/sched/core.c:4100
 rxrpc_wake_up_io_thread net/rxrpc/ar-internal.h:967 [inline]
 rxrpc_encap_rcv+0xc7/0xf0 net/rxrpc/io_thread.c:40
 udp_queue_rcv_one_skb+0x64c/0x750 net/ipv4/udp.c:2164
 udp_queue_rcv_skb+0x53d/0x5c0 net/ipv4/udp.c:2241
 __udp4_lib_mcast_deliver net/ipv4/udp.c:2333 [inline]
 __udp4_lib_rcv+0x1c66/0x1d00 net/ipv4/udp.c:2468
 udp_rcv+0x4b/0x50 net/ipv4/udp.c:2655
 ip_protocol_deliver_rcu+0x380/0x720 net/ipv4/ip_input.c:205
 ip_local_deliver_finish net/ipv4/ip_input.c:233 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ip_local_deliver+0x210/0x340 net/ipv4/ip_input.c:254
 dst_input include/net/dst.h:454 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:449 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ip_rcv+0x1b1/0x260 net/ipv4/ip_input.c:569
 __netif_receive_skb_one_core net/core/dev.c:5482 [inline]
 __netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
 process_backlog+0x23f/0x3b0 net/core/dev.c:5924
 __napi_poll+0x65/0x420 net/core/dev.c:6485
 napi_poll net/core/dev.c:6552 [inline]
 net_rx_action+0x37e/0x730 net/core/dev.c:6663
 __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
 run_ksoftirqd+0x1f/0x30 kernel/softirq.c:934
 smpboot_thread_fn+0x308/0x4a0 kernel/smpboot.c:164
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
CR2: 0000000000000834
---[ end trace 0000000000000000 ]---
RIP: 0010:arch_atomic_try_cmpxchg arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire
include/linux/atomic/atomic-instrumented.h:543 [inline]
RIP: 0010:queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
RIP: 0010:do_raw_spin_lock include/linux/spinlock.h:186 [inline]
RIP: 0010:__raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:111 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x4e/0xa0 kernel/locking/spinlock.c:162
Code: 48 c7 04 24 00 00 00 00 9c 8f 04 24 48 89 df e8 88 fb 8d fc 48
8b 1c 24 fa bd 01 00 00 00 bf 01 00 00 00 e8 a4 9c 66 fc 31 c0 <3e> 41
0f b1 2e 75 1c 65 48 8b 04 25 28 00 00 00 48 3b 44 24 08 75
RSP: 0018:ffffc90000497908 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffffffff84ad1b08
RDX: 0000000000000996 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0001c9000049790f R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000497908 R12: 0000000000000834
R13: ffffffff84446de0 R14: 0000000000000834 R15: ffff888061b71700
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000834 CR3: 0000000057b36000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 48 c7 04 24 00 00 00 movq   $0x0,(%rsp)
   7: 00
   8: 9c                   pushfq
   9: 8f 04 24             popq   (%rsp)
   c: 48 89 df             mov    %rbx,%rdi
   f: e8 88 fb 8d fc       callq  0xfc8dfb9c
  14: 48 8b 1c 24           mov    (%rsp),%rbx
  18: fa                   cli
  19: bd 01 00 00 00       mov    $0x1,%ebp
  1e: bf 01 00 00 00       mov    $0x1,%edi
  23: e8 a4 9c 66 fc       callq  0xfc669ccc
  28: 31 c0                 xor    %eax,%eax
* 2a: 3e 41 0f b1 2e       cmpxchg %ebp,%ds:(%r14) <-- trapping instruction
  2f: 75 1c                 jne    0x4d
  31: 65 48 8b 04 25 28 00 mov    %gs:0x28,%rax
  38: 00 00
  3a: 48 3b 44 24 08       cmp    0x8(%rsp),%rax
  3f: 75                   .byte 0x75

Best,
Wei
