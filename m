Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55291354B21
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhDFDPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:15:22 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55376 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhDFDPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:15:21 -0400
Received: by mail-io1-f70.google.com with SMTP id e15so12129610ioe.22
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 20:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MTyOa4fPHpq0/87Y0jha96oeT+k49mXnNFosEwUFhYM=;
        b=UKBVpUKt2StTqe48YE3zRqDF26rE6+gRdFK9MY8iTAgFwf63wBXrG+JSwzkxDhQjV9
         51btf48be0fIYGvvNp2doGEFP1Y5R1KzwBMNz96z/AnOVMOuYp1VD8MZO/h3kj54qrFl
         FnayfU4szGA9lwccvr0eYCJiYoGuSk834Ga6fCFKe8qQKCGFIggRxWu7I/OfkFehijky
         hCpBDJgJsQzkiFiHJ0dSMs3U5mAR3Y0JrcfH4hWMYb0ZEq8CixFjsPO0XW1W11vGXXWI
         Azj58LqZXGF5VcQkgQ+3YcsAwhY8sW5IRSqahu0jy5tybvD5etxGjs4Grt36ctwcnz7j
         x8vg==
X-Gm-Message-State: AOAM533ufQ4fJjRKaA1rE83OKIEJKflr2X21sdQrY5Z+yyT+mtplJnT2
        M8nUaWw0/nMY6UJ6BegCP8KnoiJxdGX+fNBCLpVWO65OmPSe
X-Google-Smtp-Source: ABdhPJwPSrXl7HFg867qIRVRxBEkrgbX5jpNhzU39JujPTlQD6QrJugZ8Sc6gLmr7agK725QXp1a/bvAiENuOXzM/i0vBygw/dsg
MIME-Version: 1.0
X-Received: by 2002:a5d:89d9:: with SMTP id a25mr22242262iot.69.1617678912805;
 Mon, 05 Apr 2021 20:15:12 -0700 (PDT)
Date:   Mon, 05 Apr 2021 20:15:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f560e805bf453804@google.com>
Subject: [syzbot] KASAN: use-after-free Write in sk_psock_stop
From:   syzbot <syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bp@alien8.de, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hpa@zytor.com, jakub@cloudflare.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lmb@cloudflare.com, mark.rutland@arm.com, masahiroy@kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f07669df libbpf: Remove redundant semi-colon
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1564f0e2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=7b6548ae483d6f4c64ae
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16462311d00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c1c9ced00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c1c9ced00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c1c9ced00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
Read of size 8 at addr ffff888024f66238 by task syz-executor.1/14202

CPU: 0 PID: 14202 Comm: syz-executor.1 Not tainted 5.12.0-rc4-syzkaller #0
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
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 sk_psock_stop+0x2f/0x4d0 net/core/skmsg.c:750
 sock_map_close+0x172/0x390 net/core/sock_map.c:1534
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1bde3a3188 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffe6eb13bbf R14: 00007f1bde3a3300 R15: 0000000000022000

Allocated by task 14202:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc_node include/linux/slab.h:572 [inline]
 kzalloc_node include/linux/slab.h:695 [inline]
 sk_psock_init+0xaf/0x730 net/core/skmsg.c:668
 sock_map_link+0xbf4/0x1020 net/core/sock_map.c:286
 sock_hash_update_common+0xe2/0xa60 net/core/sock_map.c:993
 sock_map_update_elem_sys+0x561/0x680 net/core/sock_map.c:596
 bpf_map_update_value.isra.0+0x36b/0x8d0 kernel/bpf/syscall.c:167
 map_update_elem kernel/bpf/syscall.c:1129 [inline]
 __do_sys_bpf+0x2d6e/0x4f40 kernel/bpf/syscall.c:4384
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9712:
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
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 rcu_work_rcufn+0x58/0x80 kernel/workqueue.c:1733
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x74a/0x12f0 kernel/rcu/tree.c:2794
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3114
 queue_rcu_work+0x82/0xa0 kernel/workqueue.c:1753
 sk_psock_put include/linux/skmsg.h:446 [inline]
 sock_map_unref+0x109/0x190 net/core/sock_map.c:182
 sock_hash_delete_from_link net/core/sock_map.c:918 [inline]
 sock_map_unlink net/core/sock_map.c:1480 [inline]
 sock_map_remove_links+0x389/0x530 net/core/sock_map.c:1492
 sock_map_close+0x12f/0x390 net/core/sock_map.c:1532
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888024f66000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 568 bytes inside of
 2048-byte region [ffff888024f66000, ffff888024f66800)
The buggy address belongs to the page:
page:ffffea000093d800 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888024f60000 pfn:0x24f60
head:ffffea000093d800 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 ffffea0000951000 0000000200000002 ffff888010842000
raw: ffff888024f60000 0000000080080007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888024f66100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888024f66180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888024f66200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888024f66280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888024f66300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
