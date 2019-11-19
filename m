Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8E2101150
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKSCXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfKSCXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 21:23:34 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5392622310;
        Tue, 19 Nov 2019 02:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574130212;
        bh=XtUUkDB41QvXyTiezpg2Mj6UA4gS1zWal6Ulo2GKvwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bByUwrXrNkw6NP44h4m8tIQbP3cvdjPoYZk6XLUiGf7GXx7OYJtQZfF15L1sgsSeV
         WaVpoR6jkg8zh6+4DScTZYbQz+Ho8KenH+JKIFoOiya/P2VuVMmjZyTXaLCDHyVHon
         bT+/+mutzz3qlXJomaX8OPiTzg3sseb7gVUaxnho=
Date:   Mon, 18 Nov 2019 18:23:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        idosch@mellanox.com, kimbrownkd@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, petrm@mellanox.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wanghai26@huawei.com,
        yuehaibing@huawei.com
Subject: Re: INFO: task hung in io_wq_destroy
Message-ID: <20191119022330.GC3147@sol.localdomain>
References: <000000000000f86a4f0595fdb152@google.com>
 <f1a79e81-b41f-ba48-9bf3-aeae708f73ba@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1a79e81-b41f-ba48-9bf3-aeae708f73ba@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jens,

On Mon, Oct 28, 2019 at 03:00:08PM -0600, Jens Axboe wrote:
> This is fixed in my for-next branch for a few days at least, unfortunately
> linux-next is still on the old one. Next version should be better.

This is still occurring on linux-next.  Here's a report on next-20191115 from
https://syzkaller.appspot.com/text?tag=CrashReport&x=16fa3d1ce00000

INFO: task syz-executor.5:11684 can't die for more than 143 seconds.
syz-executor.5  D28160 11684   9114 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x8e1/0x1f30 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
 io_wq_destroy+0x22a/0x450 fs/io-wq.c:1068
 io_finish_async+0x128/0x1b0 fs/io_uring.c:3423
 io_ring_ctx_free fs/io_uring.c:4220 [inline]
 io_ring_ctx_wait_and_kill+0x2b7/0x810 fs/io_uring.c:4293
 io_uring_release+0x42/0x50 fs/io_uring.c:4301
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4141d1
Code: 65 00 31 d2 be 53 25 44 00 bf 09 3d 44 00 ff 15 95 57 24 00 b9 c0 99 65 00 31 d2 be 44 25 44 00 bf 09 3d 44 00 ff 15 7e 57 24 <00> b9 20 9b 65 00 31 d2 be ac 94 44 00 bf 09 3d 44 00 ff 15 67 57
RSP: 002b:00007ffc4b532100 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004141d1
RDX: 0000001b2d520000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000034194edd R09: 0000000034194ee1
R10: 00007ffc4b5321e0 R11: 0000000000000293 R12: 000000000075bf20
R13: 00000000000428a4 R14: 00000000007604b0 R15: 000000000075bf2c
INFO: task syz-executor.5:11684 blocked for more than 143 seconds.
      Not tainted 5.4.0-rc7-next-20191115 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.5  D28160 11684   9114 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x8e1/0x1f30 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
 io_wq_destroy+0x22a/0x450 fs/io-wq.c:1068
 io_finish_async+0x128/0x1b0 fs/io_uring.c:3423
 io_ring_ctx_free fs/io_uring.c:4220 [inline]
 io_ring_ctx_wait_and_kill+0x2b7/0x810 fs/io_uring.c:4293
 io_uring_release+0x42/0x50 fs/io_uring.c:4301
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4141d1
Code: 65 00 31 d2 be 53 25 44 00 bf 09 3d 44 00 ff 15 95 57 24 00 b9 c0 99 65 00 31 d2 be 44 25 44 00 bf 09 3d 44 00 ff 15 7e 57 24 <00> b9 20 9b 65 00 31 d2 be ac 94 44 00 bf 09 3d 44 00 ff 15 67 57
RSP: 002b:00007ffc4b532100 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004141d1
RDX: 0000001b2d520000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000034194edd R09: 0000000034194ee1
R10: 00007ffc4b5321e0 R11: 0000000000000293 R12: 000000000075bf20
R13: 00000000000428a4 R14: 00000000007604b0 R15: 000000000075bf2c

Showing all locks held in the system:
1 lock held by khungtaskd/834:
 #0: ffffffff88faccc0 (rcu_read_lock){....}, at: debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
3 locks held by kworker/u4:4/835:
 #0: ffff8880ae837358 (&rq->lock){-.-.}, at: newidle_balance+0xa28/0xe80 kernel/sched/fair.c:10049
 #1: ffffffff88faccc0 (rcu_read_lock){....}, at: __update_idle_core+0x45/0x3f0 kernel/sched/fair.c:5697
 #2: ffffffff88faccc0 (rcu_read_lock){....}, at: batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:405 [inline]
 #2: ffffffff88faccc0 (rcu_read_lock){....}, at: batadv_nc_worker+0xe3/0x760 net/batman-adv/network-coding.c:718
1 lock held by rsyslogd/8970:
 #0: ffff8880a9919b60 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110 fs/file.c:801
2 locks held by getty/9060:
 #0: ffff8880917eb090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f392e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9061:
 #0: ffff8880a4ab7090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f352e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9062:
 #0: ffff888096614090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f2d2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9063:
 #0: ffff8880a776f090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f152e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9064:
 #0: ffff8880a5f2b090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f312e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9065:
 #0: ffff88809145c090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f192e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9066:
 #0: ffff8880a05c6090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc90005f012e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 834 Comm: khungtaskd Not tainted 5.4.0-rc7-next-20191115 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:269 [inline]
 watchdog+0xc8f/0x1350 kernel/hung_task.c:353
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
