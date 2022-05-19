Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5677A52CA66
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiESDfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiESDff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:35:35 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47779E0BA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:35:34 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id a3-20020a92c543000000b002d1108788a1so2388861ilj.4
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FZduYSQbHnoh/flOQg8bZDICLJ3s8djZmLyod5cweMs=;
        b=reRxgDUROy8pJ6aZOGklPMtKDRNpUoIl8AVfe7w2XywPFM/YJF/8NaC/S6Q/s2npGH
         Xt28h7rrDhLGWx3ZATpfZSDCFksmZAZB4VmEW3dkcIw74hR6Oj2XHo0/uNbf55Ry5tix
         YtWBsQH3vxDCCiQGq1oKRuz+WuEdNjEl2tKGOG98/H/PMAOsuApCyfWRYYgS8tNGLo0Z
         ryPi+jAMYN5TFNJcV7PJ5XGt7+GXee92bJxiwb/gADGFTqupeBsFDnkC9SUepKnvPwT8
         yIM9Z31M5mJ1CsM+XbfKl4eHJPLlF9F5yQD60Pwk1yG/Iu11STzL81lqHSaA8bU3f0+E
         LuKw==
X-Gm-Message-State: AOAM530uHF1ev+zp8fxdsueBDYZa/iq3N0U31eEd8EfKJQotCIlZZdH3
        tyglRtNoP4if7Wp4lMDe+oaS4dGWiglXvoFfqsZo+vWHU5VO
X-Google-Smtp-Source: ABdhPJy78FYRjW0NcwSl9cXiRscWNwA4oxbFbCkIKEMHarq2kYgnJ+8IR1o5MTqfomkAo5FkfOcFhYjVFmtpqxrTvzpQ74Kdi7q6
MIME-Version: 1.0
X-Received: by 2002:a05:6638:52e:b0:32a:e022:5a9e with SMTP id
 j14-20020a056638052e00b0032ae0225a9emr1569475jar.60.1652931333642; Wed, 18
 May 2022 20:35:33 -0700 (PDT)
Date:   Wed, 18 May 2022 20:35:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fae03b05df551046@google.com>
Subject: [syzbot] possible deadlock in rds_wake_sk_sleep (4)
From:   syzbot <syzbot+dcd73ff9291e6d34b3ab@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1e1b28b936ae Add linux-next specific files for 20220513
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10117426f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4eb3c0c4b289571
dashboard link: https://syzkaller.appspot.com/bug?extid=dcd73ff9291e6d34b3ab
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cc3759f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e9e209f00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e218c6f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13e218c6f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15e218c6f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcd73ff9291e6d34b3ab@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.18.0-rc6-next-20220513-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:1/11 is trying to acquire lock:
ffff88807603bc60 (&rs->rs_recv_lock){...-}-{2:2}, at: rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109

but task is already holding lock:
ffff88801a9f6100 (&rm->m_rs_lock){..-.}-{2:2}, at: rds_send_remove_from_sock+0x340/0x9e0 net/rds/send.c:628

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rm->m_rs_lock){..-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       rds_message_purge net/rds/message.c:138 [inline]
       rds_message_put+0x1d9/0xc20 net/rds/message.c:180
       rds_inc_put net/rds/recv.c:82 [inline]
       rds_inc_put+0x13a/0x1a0 net/rds/recv.c:76
       rds_clear_recv_queue+0x147/0x350 net/rds/recv.c:767
       rds_release+0xd4/0x3b0 net/rds/af_rds.c:73
       __sock_release+0xcd/0x280 net/socket.c:650
       sock_close+0x18/0x20 net/socket.c:1365
       __fput+0x277/0x9d0 fs/file_table.c:317
       task_work_run+0xdd/0x1a0 kernel/task_work.c:177
       ptrace_notify+0x114/0x140 kernel/signal.c:2353
       ptrace_report_syscall include/linux/ptrace.h:420 [inline]
       ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
       syscall_exit_work kernel/entry/common.c:249 [inline]
       syscall_exit_to_user_mode_prepare+0xdb/0x230 kernel/entry/common.c:276
       __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
       syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
       do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

-> #0 (&rs->rs_recv_lock){...-}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5665 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
       __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:160 [inline]
       _raw_read_lock_irqsave+0x45/0x90 kernel/locking/spinlock.c:236
       rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109
       rds_send_remove_from_sock+0xb9/0x9e0 net/rds/send.c:634
       rds_send_path_drop_acked+0x2ef/0x3d0 net/rds/send.c:710
       rds_tcp_write_space+0x1b1/0x690 net/rds/tcp_send.c:198
       tcp_new_space net/ipv4/tcp_input.c:5451 [inline]
       tcp_check_space net/ipv4/tcp_input.c:5470 [inline]
       tcp_check_space+0x3d0/0x800 net/ipv4/tcp_input.c:5464
       tcp_data_snd_check net/ipv4/tcp_input.c:5479 [inline]
       tcp_rcv_established+0x8c4/0x20e0 net/ipv4/tcp_input.c:5986
       tcp_v4_do_rcv+0x66c/0x980 net/ipv4/tcp_ipv4.c:1659
       sk_backlog_rcv include/net/sock.h:1050 [inline]
       __release_sock+0x134/0x3b0 net/core/sock.c:2832
       release_sock+0x54/0x1b0 net/core/sock.c:3387
       rds_send_xmit+0x143f/0x2540 net/rds/send.c:422
       rds_send_worker+0x92/0x2e0 net/rds/threads.c:200
       process_one_work+0x996/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e9/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:297

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rm->m_rs_lock);
                               lock(&rs->rs_recv_lock);
                               lock(&rm->m_rs_lock);
  lock(&rs->rs_recv_lock);

 *** DEADLOCK ***

5 locks held by kworker/u4:1/11:
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888024ca6938 ((wq_completion)krdsd){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90000107da8 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff8880781d0d30 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1680 [inline]
 #2: ffff8880781d0d30 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:3215
 #3: ffff8880781d0fb8 (k-clock-AF_INET){++.-}-{2:2}, at: rds_tcp_write_space+0x25/0x690 net/rds/tcp_send.c:184
 #4: ffff88801a9f6100 (&rm->m_rs_lock){..-.}-{2:2}, at: rds_send_remove_from_sock+0x340/0x9e0 net/rds/send.c:628

stack backtrace:
CPU: 0 PID: 11 Comm: kworker/u4:1 Not tainted 5.18.0-rc6-next-20220513-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krdsd rds_send_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:160 [inline]
 _raw_read_lock_irqsave+0x45/0x90 kernel/locking/spinlock.c:236
 rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109
 rds_send_remove_from_sock+0xb9/0x9e0 net/rds/send.c:634
 rds_send_path_drop_acked+0x2ef/0x3d0 net/rds/send.c:710
 rds_tcp_write_space+0x1b1/0x690 net/rds/tcp_send.c:198
 tcp_new_space net/ipv4/tcp_input.c:5451 [inline]
 tcp_check_space net/ipv4/tcp_input.c:5470 [inline]
 tcp_check_space+0x3d0/0x800 net/ipv4/tcp_input.c:5464
 tcp_data_snd_check net/ipv4/tcp_input.c:5479 [inline]
 tcp_rcv_established+0x8c4/0x20e0 net/ipv4/tcp_input.c:5986
 tcp_v4_do_rcv+0x66c/0x980 net/ipv4/tcp_ipv4.c:1659
 sk_backlog_rcv include/net/sock.h:1050 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2832
 release_sock+0x54/0x1b0 net/core/sock.c:3387
 rds_send_xmit+0x143f/0x2540 net/rds/send.c:422
 rds_send_worker+0x92/0x2e0 net/rds/threads.c:200
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:297
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
