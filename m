Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C2C6A1824
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBXIl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjBXIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:41:58 -0500
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C2265314
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:41:55 -0800 (PST)
Received: by mail-il1-f206.google.com with SMTP id f8-20020a056e0212a800b00317170581e6so307214ilr.9
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:41:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42+zxhcIjqurH9yXr4q9+c6saZmwCPNHoGRo8tm+Di8=;
        b=to/olHAUB2GVxPc8x0PCGVVmpMnnmaddIPxsCHjxxRALdcPgRIwO0MEshrMLnwsx9R
         WL97Z4ZqK8lTmQGhLI63hGowZc5jnJQIfdGx91h4BJrSA/o7QQX+ltzklKDvIHnuXpVO
         yKdiVIhSrpRVf+D0+mOqtHGNgCw7a9SBfjFgKO/Cd816AW/wsQBTnumy+e5ouv0lcqyv
         kC+t4osXw4Ss1t/SKCC8P2QHEwkDcbo3aDK8k74J5/E1ZoeXXY0sqamArcLGwXQLf/uX
         3Oo/zAMM+Dq0rPlonFV75hxSXaL+5vsFhhtt7anZxhKug5cbh1GrRrtKneXeKE+KP1su
         1sgA==
X-Gm-Message-State: AO0yUKXFRcEKnd9r1sK1xo21DVo8h1fASsmS8E8l32U2qQ0y01TLHZq/
        1xTtZtKLHnBmZ//YjnQjwdI0Eyk4zM6aWFIBBfGyhv5gkscz
X-Google-Smtp-Source: AK7set+PaRgEGpIHwroObi54hVEeSixkpRiJ7SEjhm+E7z/Sl9b6Qd6b5GqfFv3eBI5LI8Ys12bUivmnpZU2ybnCFe6FZYEKxtk4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22ac:b0:3a7:e46f:2a32 with SMTP id
 z12-20020a05663822ac00b003a7e46f2a32mr5400439jas.6.1677228114827; Fri, 24 Feb
 2023 00:41:54 -0800 (PST)
Date:   Fri, 24 Feb 2023 00:41:54 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fddea605f56e19b5@google.com>
Subject: [syzbot] linux-next test error: possible deadlock in hci_cmd_sync_clear
From:   syzbot <syzbot+0dc69aab0bf17cdd4092@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d6d7ce9baaf Add linux-next specific files for 20230224
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159b1e44c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4fe68735401a6111
dashboard link: https://syzkaller.appspot.com/bug?extid=0dc69aab0bf17cdd4092
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f73e26755a73/disk-4d6d7ce9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e8a9e1fdaa91/vmlinux-4d6d7ce9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ad213a829368/bzImage-4d6d7ce9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0dc69aab0bf17cdd4092@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-next-20230224-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/5079 is trying to acquire lock:
ffff888022388880 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: __flush_work+0xdd/0xb60 kernel/workqueue.c:3167

but task is already holding lock:
ffff888022388920 (&hdev->cmd_sync_work_lock){+.+.}-{3:3}, at: hci_cmd_sync_clear+0x3c/0x2a0 net/bluetooth/hci_sync.c:653

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&hdev->cmd_sync_work_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       hci_cmd_sync_work+0x26f/0x450 net/bluetooth/hci_sync.c:287
       process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
       worker_thread+0x669/0x1090 kernel/workqueue.c:2537
       kthread+0x2e8/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

-> #0 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3098 [inline]
       check_prevs_add kernel/locking/lockdep.c:3217 [inline]
       validate_chain kernel/locking/lockdep.c:3832 [inline]
       __lock_acquire+0x2ec7/0x5d40 kernel/locking/lockdep.c:5056
       lock_acquire.part.0+0x11a/0x370 kernel/locking/lockdep.c:5669
       __flush_work+0x109/0xb60 kernel/workqueue.c:3170
       __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3261
       hci_cmd_sync_clear+0x48/0x2a0 net/bluetooth/hci_sync.c:654
       hci_unregister_dev+0x16b/0x580 net/bluetooth/hci_core.c:2696
       vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
       __fput+0x27c/0xa90 fs/file_table.c:321
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xb42/0x2b60 kernel/exit.c:869
       do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
       get_signal+0x2315/0x25b0 kernel/signal.c:2859
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
       __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hdev->cmd_sync_work_lock);
                               lock((work_completion)(&hdev->cmd_sync_work));
                               lock(&hdev->cmd_sync_work_lock);
  lock((work_completion)(&hdev->cmd_sync_work));

 *** DEADLOCK ***

1 lock held by syz-executor.0/5079:
 #0: ffff888022388920 (&hdev->cmd_sync_work_lock){+.+.}-{3:3}, at: hci_cmd_sync_clear+0x3c/0x2a0 net/bluetooth/hci_sync.c:653

stack backtrace:
CPU: 0 PID: 5079 Comm: syz-executor.0 Not tainted 6.2.0-next-20230224-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3098 [inline]
 check_prevs_add kernel/locking/lockdep.c:3217 [inline]
 validate_chain kernel/locking/lockdep.c:3832 [inline]
 __lock_acquire+0x2ec7/0x5d40 kernel/locking/lockdep.c:5056
 lock_acquire.part.0+0x11a/0x370 kernel/locking/lockdep.c:5669
 __flush_work+0x109/0xb60 kernel/workqueue.c:3170
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3261
 hci_cmd_sync_clear+0x48/0x2a0 net/bluetooth/hci_sync.c:654
 hci_unregister_dev+0x16b/0x580 net/bluetooth/hci_core.c:2696
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb42/0x2b60 kernel/exit.c:869
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
 get_signal+0x2315/0x25b0 kernel/signal.c:2859
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff20608d567
Code: Unable to access opcode bytes at 0x7ff20608d53d.
RSP: 002b:00007fffc36b4528 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: fffffffffffffffe RBX: 0000000000000003 RCX: 00007ff20608d567
RDX: 00007fffc36b45fc RSI: 000000000000000a RDI: 00007fffc36b45f0
RBP: 00007fffc36b45f0 R08: 00000000ffffffff R09: 00007fffc36b43c0
R10: 0000555555e77853 R11: 0000000000000246 R12: 00007ff2060e6b24
R13: 00007fffc36b56b0 R14: 0000555555e77810 R15: 00007fffc36b56f0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
