Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA64241EEF
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgHKRH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:07:26 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54376 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgHKRHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:07:15 -0400
Received: by mail-io1-f72.google.com with SMTP id z25so10191876ioh.21
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 10:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3ZPRrfgd4U28dH7RCjAGl0xrthCHCi5aVcTRVhPqTvM=;
        b=bIsKQ3TFgT27L73lWfxXKCl6myzNLiyUgmZitsnMTRI1LTej/F5H/aY6kyPJsjJIf+
         ZBYlvOYOSwQroNsnKITJDJKhx6a93w5A5Y8X/jrDAyNF4IxMK/fgqStYoyNz+8VS1xvj
         wv70vdwMIGgTelsuk+K5oEmU/S5k2DWyFw8GMZHWYBXzqaeAvhzlHMNQEAhU8547wPg8
         JCsNdsr4ZDQlc8QgDST4bUlI58aW3dGxZNhWpVsuF29jFolx5F9chgCjVoIzw6pf9lGj
         VukbXEiOs8xC8xXpQ7mPHM9BTXfHOQxRKCuAbAKEu9RGjldOQbmdoXT6qAiMEUqIkVRw
         jDhQ==
X-Gm-Message-State: AOAM531KIe3NtzyRZF3eZrSgacKF0ffFD7XsAHyuhnVKUkcbUwlpuA6H
        8YTGsyqJML92itytR6ANFmvCirgFmvrdsW9HFbKUq/3P+CTZ
X-Google-Smtp-Source: ABdhPJxK0j2N8H15/HLiv2i5ZMHye9rsVOvMWhuPkrGjHecyzW74B0tXTaV6lYOkeo5F0GQWDSisUUJz/C8OpJqjHcxr0bZjG/ZI
MIME-Version: 1.0
X-Received: by 2002:a92:d8d2:: with SMTP id l18mr21745562ilo.94.1597165634421;
 Tue, 11 Aug 2020 10:07:14 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:07:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004991e705ac9d1a83@google.com>
Subject: inconsistent lock state in sco_conn_del
From:   syzbot <syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f80535b9 Add linux-next specific files for 20200810
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=152ffd8a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2055bd0d83d5ee16
dashboard link: https://syzkaller.appspot.com/bug?extid=65684128cd7c35bc66a1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.8.0-next-20200810-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz-executor.5/11793 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff8880554ec0a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880554ec0a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  sco_sock_timeout+0x24/0x140 net/bluetooth/sco.c:83
  call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x2de/0xa24 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1090
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
  arch_local_irq_enable arch/x86/include/asm/paravirt.h:780 [inline]
  __local_bh_enable_ip+0x101/0x190 kernel/softirq.c:200
  spin_unlock_bh include/linux/spinlock.h:399 [inline]
  batadv_nc_purge_paths+0x2a5/0x3a0 net/batman-adv/network-coding.c:470
  batadv_nc_worker+0x868/0xe50 net/batman-adv/network-coding.c:721
  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
  kthread+0x3b5/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
irq event stamp: 33895
hardirqs last  enabled at (33895): [<ffffffff81b4172d>] kfree+0x1cd/0x2c0 mm/slab.c:3757
hardirqs last disabled at (33894): [<ffffffff81b415cf>] kfree+0x6f/0x2c0 mm/slab.c:3746
softirqs last  enabled at (30344): [<ffffffff88000f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
softirqs last disabled at (30333): [<ffffffff88000f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

3 locks held by syz-executor.5/11793:
 #0: ffff88805b990f40 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0xf5/0x1080 net/bluetooth/hci_core.c:1720
 #1: ffff88805b990078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_do_close+0x253/0x1080 net/bluetooth/hci_core.c:1757
 #2: ffffffff8a9a5c28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1435 [inline]
 #2: ffffffff8a9a5c28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xc7/0x220 net/bluetooth/hci_conn.c:1557

stack backtrace:
CPU: 0 PID: 11793 Comm: syz-executor.5 Not tainted 5.8.0-next-20200810-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:4020 [inline]
 valid_state kernel/locking/lockdep.c:3361 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
 mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3923 [inline]
 __lock_acquire+0x8cd/0x5640 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
 sco_disconn_cfm net/bluetooth/sco.c:1178 [inline]
 sco_disconn_cfm+0x62/0x80 net/bluetooth/sco.c:1171
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
 hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x15d/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ce69
Code: Bad RIP value.
RSP: 002b:00007fd132defcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000118bfc8 RCX: 000000000045ce69
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000118bfc8
RBP: 000000000118bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bfcc
R13: 00007ffd9693ba5f R14: 00007fd132df09c0 R15: 000000000118bfcc


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
