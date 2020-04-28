Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE651BC0C7
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgD1OLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:11:21 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53632 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgD1OLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:11:20 -0400
Received: by mail-io1-f72.google.com with SMTP id i26so24196470ioe.20
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 07:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UJV73waKHEvZqQ9MSDHh2BouYF5jGVfJChi/Qtj2l+I=;
        b=H/gWZpvE5XqQ8d4t2SFY6dbRnyD/76oHJtVkQL4eE8l8RS266iVbClPFRmiG/PCpcr
         +u+ObRBW4kmLuhNeHipbbzzY3UfNazHzJTvyrlV+5z89mMU94+/15Qh31a1VQV9Zw8aJ
         ZJEUAMjpSWpySuUO+Mr2VTEL3wlzTK5GD2NLBoMqhi4yWns3N//7aq9GaD+a0gVUS6mY
         LunjE0bxRnoBRZ5x2G31lerqvYzc8ofG6CfxoRYFMQFQKFA56iXSmSozpZY4aYeWOSTr
         baUADUogq6BqEK6nPbGp+32ASVMuJ7GPxZ9PCEqIjUFdDBhmTF8zIqjURLqP6KTvC+3a
         Cv1Q==
X-Gm-Message-State: AGi0PuadBKcaKcemdbKQSxKUqKNEnkrgVqCyQ4oIvp5IvMBeruAnIAG3
        IpZOC7btRo5cB2q0rtnH+IEFfPzzyjcXSQdQmoqF+skr7kl6
X-Google-Smtp-Source: APiQypJt7OHr1bHrWClE4QyKaksnuBnB2GtszBQ3TC/Y1aiOEo5XjU525iuL5z96j45LKN3s5nVwulA4FxxnLYDQTuO+O4APth4C
MIME-Version: 1.0
X-Received: by 2002:a92:5dc4:: with SMTP id e65mr26732931ilg.161.1588083076490;
 Tue, 28 Apr 2020 07:11:16 -0700 (PDT)
Date:   Tue, 28 Apr 2020 07:11:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5ec5105a45a6773@google.com>
Subject: KASAN: use-after-free Read in bcm_send_to_user
From:   syzbot <syzbot+842d1f5968e5096e4bde@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    51184ae3 Merge tag 'for-5.7-rc3-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11561e64100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b075813ec8b93cd
dashboard link: https://syzkaller.appspot.com/bug?extid=842d1f5968e5096e4bde
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+842d1f5968e5096e4bde@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:381 [inline]
BUG: KASAN: use-after-free in skb_put_data include/linux/skbuff.h:2286 [inline]
BUG: KASAN: use-after-free in bcm_send_to_user+0x32d/0x490 net/can/bcm.c:333
Read of size 72 at addr ffff888033886560 by task kworker/u4:1/21

CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 check_memory_region_inline mm/kasan/generic.c:187 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:193
 memcpy+0x20/0x60 mm/kasan/common.c:106
 memcpy include/linux/string.h:381 [inline]
 skb_put_data include/linux/skbuff.h:2286 [inline]
 bcm_send_to_user+0x32d/0x490 net/can/bcm.c:333
 bcm_rx_changed+0x24c/0x2e0 net/can/bcm.c:450
 bcm_rx_update_and_send+0x217/0x2c0 net/can/bcm.c:470
 bcm_rx_handler+0x588/0x6d0 net/can/bcm.c:664
 deliver net/can/af_can.c:569 [inline]
 can_rcv_filter+0x5be/0x8e0 net/can/af_can.c:630
 can_receive+0x290/0x520 net/can/af_can.c:656
 canfd_rcv+0x12a/0x1a0 net/can/af_can.c:703
 __netif_receive_skb_one_core+0xf5/0x160 net/core/dev.c:5188
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5302
 process_backlog+0x21e/0x7a0 net/core/dev.c:6134
 napi_poll net/core/dev.c:6572 [inline]
 net_rx_action+0x4c2/0x1070 net/core/dev.c:6640
 __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x192/0x1d0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1140
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
RIP: 0010:lock_acquire+0x267/0x8f0 kernel/locking/lockdep.c:4937
Code: 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 c6 05 00 00 48 83 3d d5 3c 3b 08 00 0f 84 65 04 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 03 44 24 08 48 c7
RSP: 0018:ffffc90000dd7b60 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1329804 RBX: ffff8880a97e8580 RCX: ffffffff81592beb
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000286
RBP: 0000000000000000 R08: 0000000000000001 R09: fffffbfff185cf3d
R10: ffffffff8c2e79e7 R11: fffffbfff185cf3c R12: 0000000000000002
R13: ffffffff899beb00 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
 rcu_read_lock include/linux/rcupdate.h:601 [inline]
 batadv_nc_process_nc_paths.part.0+0xec/0x3c0 net/batman-adv/network-coding.c:686
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:678 [inline]
 batadv_nc_worker+0x545/0x760 net/batman-adv/network-coding.c:727
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 6194:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 bcm_rx_setup net/can/bcm.c:1070 [inline]
 bcm_sendmsg+0x2274/0x406b net/can/bcm.c:1331
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 6191:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 bcm_release+0x208/0x660 net/can/bcm.c:1506
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1283
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff888033886400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 352 bytes inside of
 512-byte region [ffff888033886400, ffff888033886600)
The buggy address belongs to the page:
page:ffffea0000ce2180 refcount:1 mapcount:0 mapping:000000004d023c15 index:0xffff888033886800
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000250b0c8 ffffea0000c71ec8 ffff8880aa000a80
raw: ffff888033886800 ffff888033886000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888033886400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888033886480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888033886500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888033886580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888033886600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
