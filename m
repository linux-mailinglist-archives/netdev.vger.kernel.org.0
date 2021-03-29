Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB334D434
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhC2Pnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:43:50 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42486 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhC2PnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:43:24 -0400
Received: by mail-io1-f71.google.com with SMTP id q7so11157766ioh.9
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zbz1GWPzsXMIz7magB8ds2w+jskTr7FfTGCtCmyR9Uo=;
        b=F5KQZcTss7uynZ8LZ9fqgQ19cfkMrPlqGMToxGDlzrxJrife133ErnFWSKaxBPgl26
         kKKHiz68AAG4RJJsmB5jHhEtLlPA/J33w7eyJJzv+lxeAC8oPlto1/44LqNk2B98gd6+
         V39826jQN9Zk3qE9vlJGHOgFD+PiBdzeSsgjXDRBxAuQHCDNdMbPg/ypOyBDLm24tvSG
         +IOsKxYZTsLu+4tdWumZ8/QndBIlClBQkioBZQIXTEcqmgemaBVmAvpy/UAGmaFVdD83
         tAmRaCDgeInR1lbgYl5/AUMoImIReLTIexxCGej8JAQR/Nx0OLPLOPBbPJ8C4u6l635A
         xiQw==
X-Gm-Message-State: AOAM532ArJAAPo9JIYwVlxPGB2wUAgQN4Lxl/ziLU8Wff+cUSLMXQ4W8
        LbrTYUbEIdOY8kPE3nBwVEVrT2zS+eUC6sL9qeRzdvbIKU3/
X-Google-Smtp-Source: ABdhPJxJv1gPFF8L+OfOolx14HI5NvWMOlhIQYhaFsRkhHYIMnjHKx5A6pE1QP0g1dE52ANAhs1kzqw/IGTzt26Qlduf83Ms+gVi
MIME-Version: 1.0
X-Received: by 2002:a92:c549:: with SMTP id a9mr21524884ilj.300.1617032604343;
 Mon, 29 Mar 2021 08:43:24 -0700 (PDT)
Date:   Mon, 29 Mar 2021 08:43:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8e51405beaebdde@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nfc_llcp_sock_unlink
From:   syzbot <syzbot+8b7c5fc0cfb74afee8d1@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    75887e88 Merge branch '40GbE' of git://git.kernel.org/pub/..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12d6bb06d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
dashboard link: https://syzkaller.appspot.com/bug?extid=8b7c5fc0cfb74afee8d1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c2db21d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1091d4bed00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12636d06d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11636d06d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16636d06d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b7c5fc0cfb74afee8d1@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
Read of size 8 at addr ffff888144614468 by task syz-executor242/8422

CPU: 0 PID: 8422 Comm: syz-executor242 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __raw_write_lock include/linux/rwlock_api_smp.h:210 [inline]
 _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:295
 nfc_llcp_sock_unlink+0x1d/0x1c0 net/nfc/llcp_core.c:32
 llcp_sock_release+0x286/0x580 net/nfc/llcp_sock.c:640
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43db99
Code: Unable to access opcode bytes at RIP 0x43db6f.
RSP: 002b:00007ffdd4d753e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004ae230 RCX: 000000000043db99
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 00000000004ae230
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 nfc_llcp_register_device+0x45/0x9d0 net/nfc/llcp_core.c:1572
 nfc_register_device+0x6d/0x360 net/nfc/core.c:1124
 nfcsim_device_new+0x345/0x5c1 drivers/nfc/nfcsim.c:408
 nfcsim_init+0x71/0x14d drivers/nfc/nfcsim.c:455
 do_one_initcall+0x103/0x650 init/main.c:1226
 do_initcall_level init/main.c:1299 [inline]
 do_initcalls init/main.c:1315 [inline]
 do_basic_setup init/main.c:1335 [inline]
 kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
 kernel_init+0xd/0x1b8 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 8422:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4213
 local_release net/nfc/llcp_core.c:175 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x194/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sk_free+0x78/0xa0 net/core/sock.c:1861
 sock_put include/net/sock.h:1803 [inline]
 llcp_sock_release+0x3c9/0x580 net/nfc/llcp_sock.c:644
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888144614000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff888144614000, ffff888144614800)
The buggy address belongs to the page:
page:ffffea0005118400 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888144616000 pfn:0x144610
head:ffffea0005118400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 ffffea00050f2008 ffffea00050f1e08 ffff888010842000
raw: ffff888144616000 0000000000080006 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888144614300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888144614380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888144614400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff888144614480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888144614500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
