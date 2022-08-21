Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CC259B21D
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 07:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiHUFeb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 21 Aug 2022 01:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiHUFea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 01:34:30 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D021B13EA0
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 22:34:28 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id q10-20020a056e020c2a00b002dedb497c7fso6144362ilg.16
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 22:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc;
        bh=a+etxQMTB+vR5J4K1rcBznEYzEFIprZpeNGFNGTbBMY=;
        b=FY+EkrFDtJLQ4KiTmzYzPi9Bx/CVy7h07BXSlp7ufZlLBqDsurtwWL988SL5cCF0hV
         7SunqWmvD4vY2O9rfn3MeIhJIvetmwUJYDYaiVc9jt0TEK5+ngb4oVoiZORwDE8Gg9jt
         6tkl0UJ7wuSzo7a+EIppxLX+5fnPYFVf7cYv6/KHc8QlbNSNNH0bCKXDj085E5N6KX9u
         Ca6P85khQnlUPC8S6SEvkiizkpL1A80ChWPpzC9KY4TulNSWBaZXsynGVRr6As5YsEh8
         bJCCq45acsOF0MsEjCAzVDSdCvz/54fUzi9NvUsBwT6hXplzPf2bBxXE40l+zE86q6lZ
         eTmg==
X-Gm-Message-State: ACgBeo1FjZMBl3JLu3zihTIcKSwQMTKKRC9/yuWRLLBuxwY63+B7CjPi
        iMghCU+7Z+NoijJQOCX/pReCUWyY9D74Zym2bX8eUBkRsa1S
X-Google-Smtp-Source: AA6agR48w2x3OID+s9oHXffsyfKk30YfJGdt/O6WfKg5cTLowRFzkpnMlq+fj+9tQuX2KZUfJ10i5KnabXqYPfIonjnMvJ/nCgJO
MIME-Version: 1.0
X-Received: by 2002:a6b:6717:0:b0:688:d287:fa83 with SMTP id
 b23-20020a6b6717000000b00688d287fa83mr6227528ioc.71.1661060068138; Sat, 20
 Aug 2022 22:34:28 -0700 (PDT)
Date:   Sat, 20 Aug 2022 22:34:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fe8f805e6b9af20@google.com>
Subject: [syzbot] possible deadlock in rds_tcp_reset_callbacks
From:   syzbot <syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

HEAD commit:    8755ae45a9e8 Add linux-next specific files for 20220819
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=107cf485080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ead6107a3bbe3c62
dashboard link: https://syzkaller.appspot.com/bug?extid=78c55c7bc6f66e53dce2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e678cb080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f68e5b080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc1-next-20220819-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:3/46 is trying to acquire lock:
ffff888027dc40e8 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}, at: __flush_work+0xdd/0xae0 kernel/workqueue.c:3066

but task is already holding lock:
ffff88807e18da70 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1712 [inline]
ffff88807e18da70 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: rds_tcp_reset_callbacks+0x1bf/0x4d0 net/rds/tcp.c:169

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (k-sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0x36/0xf0 net/core/sock.c:3391
       lock_sock include/net/sock.h:1712 [inline]
       tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:3328
       rds_send_xmit+0x386/0x2540 net/rds/send.c:194
       rds_send_worker+0x92/0x2e0 net/rds/threads.c:200
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

-> #0 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5666 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
       __flush_work+0x105/0xae0 kernel/workqueue.c:3069
       __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
       rds_tcp_reset_callbacks+0x1cb/0x4d0 net/rds/tcp.c:171
       rds_tcp_accept_one+0x9d5/0xd10 net/rds/tcp_listen.c:203
       rds_tcp_accept_worker+0x55/0x80 net/rds/tcp.c:529
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(k-sk_lock-AF_INET6);
                               lock((work_completion)(&(&cp->cp_send_w)->work));
                               lock(k-sk_lock-AF_INET6);
  lock((work_completion)(&(&cp->cp_send_w)->work));

 *** DEADLOCK ***

4 locks held by kworker/u4:3/46:
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff8880275f7938 ((wq_completion)krdsd){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90000b77da8 ((work_completion)(&rtn->rds_tcp_accept_w)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff8880733c4088 (&tc->t_conn_path_lock){+.+.}-{3:3}, at: rds_tcp_accept_one+0x892/0xd10 net/rds/tcp_listen.c:195
 #3: ffff88807e18da70 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1712 [inline]
 #3: ffff88807e18da70 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: rds_tcp_reset_callbacks+0x1bf/0x4d0 net/rds/tcp.c:169

stack backtrace:
CPU: 1 PID: 46 Comm: kworker/u4:3 Not tainted 6.0.0-rc1-next-20220819-syzkaller #0
kworker/u4:3[46] cmdline: ��a�����
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Workqueue: krdsd rds_tcp_accept_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:122 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:140
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __flush_work+0x105/0xae0 kernel/workqueue.c:3069
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
 rds_tcp_reset_callbacks+0x1cb/0x4d0 net/rds/tcp.c:171
 rds_tcp_accept_one+0x9d5/0xd10 net/rds/tcp_listen.c:203
 rds_tcp_accept_worker+0x55/0x80 net/rds/tcp.c:529
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
