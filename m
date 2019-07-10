Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401D764328
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfGJH5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:57:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54768 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfGJH5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:57:07 -0400
Received: by mail-io1-f71.google.com with SMTP id n8so1932206ioo.21
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 00:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+lTVTuw6O1MSfCK2nEH1bVUi6NL9+pa7PR7NWxOXdXY=;
        b=T+JmW8u7yOTJfsI18KYMEIqh8lSvFMjYn4L5kM/LRLppQIWmfzVkj1Y5HHrmr8HB7J
         FQZo16ubipQdCcFYxUlSTpwtMo04oitldikXxxIxVoHFkRDTBImRX+IKm60HC0d9yQY6
         yioD+tZkrxu/rK6+IqvKm2juKvCM7aebL+zyW+K9JWZdes6QtPehQovyfhaXRePU/r4o
         7YE2GZJMZ0y1AkE5dYbEg2ULopZ7dc4GyQtJmy+AjjRJYtd97A/F975M0abzBgtOoYri
         rGdqR50lY3ZKiODcJGhv0dgaAG6cuBOAnTCy+ePSyN19oOtexGIrM6ewPWxsVjrrcJ8Q
         6G2g==
X-Gm-Message-State: APjAAAUkaM7y2fj+sxEJzgNqPVT+GbpTZAVWboKqq5vK3c4ztGlLYfL6
        WJM/Jirmmh6DGcRWmm4l0klml2RzUZCFZcLuwYO46zJwRVpE
X-Google-Smtp-Source: APXvYqwbIiNSUipcWIYvVXJpGOmWf1CD1knlY/6PMMGzOuak0A0UxogWTjnA/EY4l4nJUJgOP5z+wYsLVRfszm7a7YJxYO/s82lB
MIME-Version: 1.0
X-Received: by 2002:a5e:8704:: with SMTP id y4mr29911990ioj.135.1562745426213;
 Wed, 10 Jul 2019 00:57:06 -0700 (PDT)
Date:   Wed, 10 Jul 2019 00:57:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001092e058d4f067f@google.com>
Subject: general protection fault in rcu_core
From:   syzbot <syzbot+73ac69a8f7a5e5c126f1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bp@alien8.de, daniel@iogearbox.net,
        drake@endlessm.com, hpa@zytor.com, jacob.jun.pan@linux.intel.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, puwen@hygon.cn,
        rppt@linux.vnet.ibm.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4608a726 Add linux-next specific files for 20190709
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14458387a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a02e36d356a9a17
dashboard link: https://syzkaller.appspot.com/bug?extid=73ac69a8f7a5e5c126f1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128e3217a00000

The bug was bisected to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1155a96fa00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1355a96fa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1555a96fa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+73ac69a8f7a5e5c126f1@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9817 Comm: blkid Not tainted 5.2.0-next-20190709 #34
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:lookup_object lib/debugobjects.c:193 [inline]
RIP: 0010:debug_object_active_state lib/debugobjects.c:900 [inline]
RIP: 0010:debug_object_active_state+0x16e/0x350 lib/debugobjects.c:885
Code: 1a 4c 89 e0 48 c1 e8 03 80 3c 08 00 0f 85 6c 01 00 00 4d 8b 24 24 4d  
85 e4 74 6a 4d 8d 44 24 18 83 c3 01 4c 89 c7 48 c1 ef 03 <80> 3c 0f 00 0f  
85 17 01 00 00 4d 3b 7c 24 18 75 c6 49 8d 7c 24 10
RSP: 0018:ffff8880ae809d00 EFLAGS: 00010802
RAX: 1ffffffff0c4eadc RBX: 0000000000000005 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000286 RDI: 1dc43d1fffffc920
RBP: ffff8880ae809de8 R08: ee21e8fffffe4901 R09: ffffed1015d0138d
R10: ffffffff8a9b1768 R11: 0000000000000003 R12: ee21e8fffffe48e9
R13: 1ffff11015d013a4 R14: ffffffff88dab220 R15: ffff8880a21f7f58
FS:  00007f3fd76fc740(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3fd72daa20 CR3: 000000008fe3c000 CR4: 00000000001406f0
Call Trace:
  <IRQ>
  debug_rcu_head_unqueue kernel/rcu/rcu.h:185 [inline]
  rcu_do_batch kernel/rcu/tree.c:2113 [inline]
  rcu_core+0x745/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:767  
[inline]
RIP: 0010:console_unlock+0xdab/0xf10 kernel/printk/printk.c:2467
Code: 88 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 30 48 83  
3d 42 4a 77 07 00 74 1f e8 7b ab 16 00 48 8b 7d 98 57 9d <0f> 1f 44 00 00  
e9 64 fa ff ff e8 c6 ea 50 00 e9 0e f5 ff ff e8 5c
RSP: 0018:ffff8880991bf2b8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: ffff8880a7e1e000 RBX: 0000000000000200 RCX: 1ffffffff134a59e
RDX: 0000000000000000 RSI: ffffffff815b9995 RDI: 0000000000000293
RBP: ffff8880991bf340 R08: ffff8880a7e1e000 R09: fffffbfff1349f60
R10: fffffbfff1349f5f R11: ffffffff89a4faff R12: 0000000000000001
R13: ffffffff843434b0 R14: dffffc0000000000 R15: ffffffff893cb710
  vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1986
  vprintk_default+0x28/0x30 kernel/printk/printk.c:2013
  vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
  printk+0xba/0xed kernel/printk/printk.c:2046
  __warn_printk+0x9b/0xf3 kernel/panic.c:630
  debug_mutex_wake_waiter+0x1d7/0x330 kernel/locking/mutex-debug.c:41
  __mutex_unlock_slowpath+0x3d5/0x6b0 kernel/locking/mutex.c:1241
  mutex_unlock+0xd/0x10 kernel/locking/mutex.c:714
  kobj_lookup+0x250/0x460 drivers/base/map.c:123
  get_gendisk+0x4d/0x390 block/genhd.c:869
  bdev_get_gendisk fs/block_dev.c:1100 [inline]
  __blkdev_get+0x457/0x1660 fs/block_dev.c:1493
  blkdev_get+0xc4/0x990 fs/block_dev.c:1652
  blkdev_open+0x205/0x290 fs/block_dev.c:1810
  do_dentry_open+0x4df/0x1250 fs/open.c:778
  vfs_open+0xa0/0xd0 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x10e9/0x4630 fs/namei.c:3533
  do_filp_open+0x1a1/0x280 fs/namei.c:3563
  do_sys_open+0x3fe/0x5d0 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f3fd7004120
Code: 48 8b 15 1b 4d 2b 00 f7 d8 64 89 02 83 c8 ff c3 90 90 90 90 90 90 90  
90 90 90 83 3d d5 a4 2b 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 31 c3 48 83 ec 08 e8 5e 8c 01 00 48 89 04 24
RSP: 002b:00007ffc2fe70dc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3fd7004120
RDX: 00007ffc2fe72f33 RSI: 0000000000000000 RDI: 00007ffc2fe72f33
RBP: 0000000000000000 R08: 0000000000000078 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000001882030
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
Modules linked in:
---[ end trace d75a73838ffe8a54 ]---
RIP: 0010:lookup_object lib/debugobjects.c:193 [inline]
RIP: 0010:debug_object_active_state lib/debugobjects.c:900 [inline]
RIP: 0010:debug_object_active_state+0x16e/0x350 lib/debugobjects.c:885
Code: 1a 4c 89 e0 48 c1 e8 03 80 3c 08 00 0f 85 6c 01 00 00 4d 8b 24 24 4d  
85 e4 74 6a 4d 8d 44 24 18 83 c3 01 4c 89 c7 48 c1 ef 03 <80> 3c 0f 00 0f  
85 17 01 00 00 4d 3b 7c 24 18 75 c6 49 8d 7c 24 10
RSP: 0018:ffff8880ae809d00 EFLAGS: 00010802
RAX: 1ffffffff0c4eadc RBX: 0000000000000005 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000286 RDI: 1dc43d1fffffc920
RBP: ffff8880ae809de8 R08: ee21e8fffffe4901 R09: ffffed1015d0138d
R10: ffffffff8a9b1768 R11: 0000000000000003 R12: ee21e8fffffe48e9
R13: 1ffff11015d013a4 R14: ffffffff88dab220 R15: ffff8880a21f7f58
FS:  00007f3fd76fc740(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3fd72daa20 CR3: 000000008fe3c000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
