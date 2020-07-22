Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35F522904A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgGVGDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:03:22 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40802 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgGVGDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:03:22 -0400
Received: by mail-il1-f198.google.com with SMTP id z16so332819ill.7
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qewiQyGL3IqTi25pirur6TTlTDfT/YuVT6Cr43auRm8=;
        b=pPdBVYOAS0L5v4vOKShdA9rNSQcetSPVnDS4vPVXQRxmy9zCBvgrYcgaXLohZS/gai
         m6P54eokvqBas3CvotUwx54S9PxauHpP/Hkfw5+a3HzZ2wOp8O+twy84Jcpg45aNtr8q
         iripq7rzygDhC+lxpoNtlhGquDHZizskIndQ3CoEI/H7n9t/F4vOvjWloFlK1+YpazPL
         fdoI8ij/ikhCgfw+ci7NQKjwyqW3QAYn0hp4vd3dgyz52S3bK+3nX9ktDg3cvJ4xLJZ2
         BsQSZFJzjUBgxw9eVRaNX4PpsMPaV1sVQqE3Wiw0yFBWjSq07IYDBkAmalvKxYKoN5mp
         Xj5Q==
X-Gm-Message-State: AOAM5312vi5uVX/BxRFbU4ht9xHSy9D42eHXH/FV2ABwXbUTxEEe8pHt
        QKDvntQzrYFK0eA9mVmpkcOfDXqta8GomYj8fogbboE6P82Q
X-Google-Smtp-Source: ABdhPJzYmim9ktgMXkp8pvt6+iCoKQ26mLH8PDcWEiMolCUcUPF8IcgLJl+ryu0e5ThHFcMwy5N58RfE4xkz1f28mvpjn/xoYCF1
MIME-Version: 1.0
X-Received: by 2002:a5e:8f4b:: with SMTP id x11mr29850087iop.90.1595397800692;
 Tue, 21 Jul 2020 23:03:20 -0700 (PDT)
Date:   Tue, 21 Jul 2020 23:03:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f93a705ab017f2c@google.com>
Subject: KMSAN: uninit-value in _copy_to_iter (3)
From:   syzbot <syzbot+81908a97abeec4f4f02d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    14525656 compiler.h: reinstate missing KMSAN_INIT
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=15996087100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c534a9fad6323722
dashboard link: https://syzkaller.appspot.com/bug?extid=81908a97abeec4f4f02d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1018fc7f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100846d7100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81908a97abeec4f4f02d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in kmsan_check_memory+0xd/0x10 mm/kmsan/kmsan_hooks.c:428
CPU: 0 PID: 8682 Comm: syz-executor281 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_check_memory+0xd/0x10 mm/kmsan/kmsan_hooks.c:428
 instrument_copy_to_user include/linux/instrumented.h:91 [inline]
 copyout lib/iov_iter.c:142 [inline]
 _copy_to_iter+0x3d4/0x26e0 lib/iov_iter.c:631
 copy_to_iter include/linux/uio.h:138 [inline]
 memcpy_to_msg include/linux/skbuff.h:3571 [inline]
 bcm_recvmsg+0x25a/0x740 net/can/bcm.c:1612
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 __sys_recvfrom+0xacd/0xae0 net/socket.c:2052
 __do_sys_recvfrom net/socket.c:2070 [inline]
 __se_sys_recvfrom+0x111/0x130 net/socket.c:2066
 __x64_sys_recvfrom+0x6e/0x90 net/socket.c:2066
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x448cd9
Code: Bad RIP value.
RSP: 002b:00007f5fbb95fd88 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00000000006dec68 RCX: 0000000000448cd9
RDX: 0000000000000032 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006dec60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dec6c
R13: ffffff7f00000001 R14: 0000000000000000 R15: 000000306e616376

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 skb_put_data include/linux/skbuff.h:2260 [inline]
 bcm_send_to_user+0x250/0x820 net/can/bcm.c:327
 bcm_tx_timeout_handler+0x5d0/0x620 net/can/bcm.c:413
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0xa61/0x1340 kernel/time/hrtimer.c:1584
 hrtimer_run_softirq+0x1b2/0x2b0 kernel/time/hrtimer.c:1601
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Local variable ----msg_head@bcm_tx_timeout_handler created at:
 bcm_tx_timeout_handler+0x4f/0x620 net/can/bcm.c:398
 bcm_tx_timeout_handler+0x4f/0x620 net/can/bcm.c:398

Bytes 12-15 of 50 are uninitialized
Memory access of size 50 starts at ffff88b629809600
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
