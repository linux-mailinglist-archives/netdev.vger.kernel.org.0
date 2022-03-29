Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F874EB617
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiC2WiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237752AbiC2WiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:38:24 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCA8205BE6;
        Tue, 29 Mar 2022 15:36:40 -0700 (PDT)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22TMZomb051290;
        Wed, 30 Mar 2022 07:35:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Wed, 30 Mar 2022 07:35:50 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22TMZo60051287
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 30 Mar 2022 07:35:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <385ce718-f965-4005-56b6-34922c4533b8@I-love.SAKURA.ne.jp>
Date:   Wed, 30 Mar 2022 07:35:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] possible deadlock in p9_write_work
Content-Language: en-US
To:     Andrew Perepechko <andrew.perepechko@hpe.com>,
        Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
References: <0000000000009523b605db620972@google.com>
Cc:     syzbot <syzbot+bde0f89deacca7c765b8@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <0000000000009523b605db620972@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

This seems to be an example of https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
introduced by "ext4: truncate during setxattr leads to kernel panic".

Please don't use schedule_work() if you need to use flush_scheduled_work().

On 2022/03/30 6:23, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8515d05bf6bc Add linux-next specific files for 20220328
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=155abcc3700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=530c68bef4e2b8a8
> dashboard link: https://syzkaller.appspot.com/bug?extid=bde0f89deacca7c765b8
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bde0f89deacca7c765b8@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.17.0-next-20220328-syzkaller #0 Not tainted
> ------------------------------------------------------
> kworker/1:1/26 is trying to acquire lock:
> ffff88807eece460 (sb_writers#3){.+.+}-{0:0}, at: p9_fd_write net/9p/trans_fd.c:428 [inline]
> ffff88807eece460 (sb_writers#3){.+.+}-{0:0}, at: p9_write_work+0x25e/0xca0 net/9p/trans_fd.c:479
> 
> but task is already holding lock:
> ffffc90000a1fda8 ((work_completion)(&m->wq)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 ((work_completion)(&m->wq)){+.+.}-{0:0}:
>        process_one_work+0x905/0x1610 kernel/workqueue.c:2265
>        worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>        kthread+0x2e9/0x3a0 kernel/kthread.c:376
>        ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
> 
> -> #2 ((wq_completion)events){+.+.}-{0:0}:
>        flush_workqueue+0x164/0x1440 kernel/workqueue.c:2831
>        flush_scheduled_work include/linux/workqueue.h:583 [inline]
>        ext4_put_super+0x99/0x1150 fs/ext4/super.c:1202
>        generic_shutdown_super+0x14c/0x400 fs/super.c:462
>        kill_block_super+0x97/0xf0 fs/super.c:1394
>        deactivate_locked_super+0x94/0x160 fs/super.c:332
>        deactivate_super+0xad/0xd0 fs/super.c:363
>        cleanup_mnt+0x3a2/0x540 fs/namespace.c:1186
>        task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>        resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>        exit_to_user_mode_loop kernel/entry/common.c:183 [inline]
>        exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:215
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:297 [inline]
>        syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:308
>        do_syscall_64+0x42/0x80 arch/x86/entry/common.c:86
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #1 (&type->s_umount_key#32){++++}-{3:3}:
>        down_read+0x98/0x440 kernel/locking/rwsem.c:1461
>        iterate_supers+0xdb/0x290 fs/super.c:692
>        drop_caches_sysctl_handler+0xdb/0x110 fs/drop_caches.c:62
>        proc_sys_call_handler+0x4a1/0x6e0 fs/proc/proc_sysctl.c:604
>        call_write_iter include/linux/fs.h:2080 [inline]
>        do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
>        do_iter_write+0x182/0x700 fs/read_write.c:852
>        vfs_iter_write+0x70/0xa0 fs/read_write.c:893
>        iter_file_splice_write+0x723/0xc70 fs/splice.c:689
>        do_splice_from fs/splice.c:767 [inline]
>        direct_splice_actor+0x110/0x180 fs/splice.c:936
>        splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
>        do_splice_direct+0x1a7/0x270 fs/splice.c:979
>        do_sendfile+0xae0/0x1240 fs/read_write.c:1246
>        __do_sys_sendfile64 fs/read_write.c:1305 [inline]
>        __se_sys_sendfile64 fs/read_write.c:1297 [inline]
>        __x64_sys_sendfile64+0x149/0x210 fs/read_write.c:1297
>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>        do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #0 (sb_writers#3){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3096 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3219 [inline]
>        validate_chain kernel/locking/lockdep.c:3834 [inline]
>        __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5060
>        lock_acquire kernel/locking/lockdep.c:5672 [inline]
>        lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5637
>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>        __sb_start_write include/linux/fs.h:1728 [inline]
>        sb_start_write include/linux/fs.h:1798 [inline]
>        file_start_write include/linux/fs.h:2815 [inline]
>        kernel_write fs/read_write.c:564 [inline]
>        kernel_write+0x2ac/0x540 fs/read_write.c:555
>        p9_fd_write net/9p/trans_fd.c:428 [inline]
>        p9_write_work+0x25e/0xca0 net/9p/trans_fd.c:479
>        process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>        worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>        kthread+0x2e9/0x3a0 kernel/kthread.c:376
>        ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   sb_writers#3 --> (wq_completion)events --> (work_completion)(&m->wq)
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock((work_completion)(&m->wq));
>                                lock((wq_completion)events);
>                                lock((work_completion)(&m->wq));
>   lock(sb_writers#3);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kworker/1:1/26:
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
>  #1: ffffc90000a1fda8 ((work_completion)(&m->wq)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
> 
> stack backtrace:
> CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 5.17.0-next-20220328-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events p9_write_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2176
>  check_prev_add kernel/locking/lockdep.c:3096 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3219 [inline]
>  validate_chain kernel/locking/lockdep.c:3834 [inline]
>  __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5060
>  lock_acquire kernel/locking/lockdep.c:5672 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5637
>  percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>  __sb_start_write include/linux/fs.h:1728 [inline]
>  sb_start_write include/linux/fs.h:1798 [inline]
>  file_start_write include/linux/fs.h:2815 [inline]
>  kernel_write fs/read_write.c:564 [inline]
>  kernel_write+0x2ac/0x540 fs/read_write.c:555
>  p9_fd_write net/9p/trans_fd.c:428 [inline]
>  p9_write_work+0x25e/0xca0 net/9p/trans_fd.c:479
>  process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>  kthread+0x2e9/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
>  </TASK>
> usb 4-1: new high-speed USB device number 72 using dummy_hcd
> usb 4-1: New USB device found, idVendor=1b3d, idProduct=0193, bcdDevice= 8.4d
> usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 4-1: config 0 descriptor??
> ftdi_sio 4-1:0.0: FTDI USB Serial Device converter detected
> usb 4-1: Detected FT232RL
> ftdi_sio ttyUSB0: Unable to read latency timer: -71
> ftdi_sio ttyUSB0: Unable to write latency timer: -71
> ftdi_sio 4-1:0.0: GPIO initialisation failed: -71
> usb 4-1: FTDI USB Serial Device converter now attached to ttyUSB0
> usb 4-1: USB disconnect, device number 72
> ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
> ftdi_sio 4-1:0.0: device disconnected
> usb 4-1: new high-speed USB device number 73 using dummy_hcd
> usb 4-1: New USB device found, idVendor=1b3d, idProduct=0193, bcdDevice= 8.4d
> usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 4-1: config 0 descriptor??
> ftdi_sio 4-1:0.0: FTDI USB Serial Device converter detected
> usb 4-1: Detected FT232RL
> ftdi_sio ttyUSB0: Unable to read latency timer: -71
> ftdi_sio ttyUSB0: Unable to write latency timer: -71
> ftdi_sio 4-1:0.0: GPIO initialisation failed: -71
> usb 4-1: FTDI USB Serial Device converter now attached to ttyUSB0
> usb 4-1: USB disconnect, device number 73
> ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
> ftdi_sio 4-1:0.0: device disconnected
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

