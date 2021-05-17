Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF15382ABA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhEQLSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:18:36 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:38750 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbhEQLSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:18:33 -0400
Received: by mail-il1-f198.google.com with SMTP id f12-20020a056e0204ccb02901613aa15edfso6034296ils.5
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qIutiLp9e5u0sv/usbcappwKIGrnGatmcx89TkEPFE4=;
        b=sQmOUMSS7CviEFAnsW2mVYyjkzuYH4ZZ/Q1azXVBJO24G6R1c8tip5TaXjvBCwjbPZ
         0pCze3PndFomfArgQeaNmYg2WKFOQMGc8KEiyQr9KoezoDWz31osXqE0QPIwXm1oVHfd
         X7x5qfQvS91w/Soz0DPzgb09VXk+V6qWKLpHo2llvvPA1i87tsyynKFUMXps9o+nT6yB
         vegeDgMi8SPHAs3gWXPdxqIhgzZqmZRq9FHyqhxA1x/SFGoNCNZaSachz61VZgyW0j5r
         OwHdUpbqfCzwFfPMcAFouskq0hcOto6STptzLl0fHC8HUlwV+xaZVlWccrXoVDjwiwKX
         EUAw==
X-Gm-Message-State: AOAM533Me4HlYBjkhpcW7R6UwER4R4000Fkab1z5qxOTfK/xlRUaA5pS
        bYkWlBmbiV/ZG2KeeC3UwobWY+LS0ZpPeGzGSZtAjoRfnk+i
X-Google-Smtp-Source: ABdhPJxOhm03SLf1ALtQKySO9NNJtuefl9PBO/B8SXL7UJ8j7d9r82MkIZ5orlVsqYvzYCHsG3Hk7woOGaJIR2m7qUGDxaSwZswo
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2289:: with SMTP id d9mr40957824iod.198.1621250237426;
 Mon, 17 May 2021 04:17:17 -0700 (PDT)
Date:   Mon, 17 May 2021 04:17:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e727005c284bc8e@google.com>
Subject: [syzbot] possible deadlock in perf_event_ctx_lock_nested (2)
From:   syzbot <syzbot+4b71bb3365e7d5228913@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15552e1bd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=807beec6b4d66bf1
dashboard link: https://syzkaller.appspot.com/bug?extid=4b71bb3365e7d5228913

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b71bb3365e7d5228913@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/26566 is trying to acquire lock:
ffff88808aa32b58 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5069

but task is already holding lock:
ffff8880b9c3a4b0 (&cpuctx_mutex){+.+.}-{3:3}, at: perf_event_ctx_lock_nested+0x26c/0x480 kernel/events/core.c:1356

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&cpuctx_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:949 [inline]
       __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
       perf_event_init_cpu+0x172/0x3e0 kernel/events/core.c:13236
       perf_event_init+0x39d/0x408 kernel/events/core.c:13283
       start_kernel+0x2b6/0x496 init/main.c:1001
       secondary_startup_64_no_verify+0xb0/0xbb

-> #2 (pmus_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:949 [inline]
       __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
       perf_event_init_cpu+0xc4/0x3e0 kernel/events/core.c:13230
       cpuhp_invoke_callback+0x3b5/0x9a0 kernel/cpu.c:179
       cpuhp_invoke_callback_range kernel/cpu.c:654 [inline]
       cpuhp_up_callbacks kernel/cpu.c:682 [inline]
       _cpu_up+0x3ab/0x6b0 kernel/cpu.c:1301
       cpu_up kernel/cpu.c:1336 [inline]
       cpu_up+0xfe/0x1a0 kernel/cpu.c:1308
       bringup_nonboot_cpus+0xfe/0x130 kernel/cpu.c:1398
       smp_init+0x2e/0x145 kernel/smp.c:1090
       kernel_init_freeable+0x402/0x6cc init/main.c:1552
       kernel_init+0xd/0x1b8 init/main.c:1447
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #1 (cpu_hotplug_lock){++++}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       cpus_read_lock+0x40/0x130 kernel/cpu.c:297
       __static_key_slow_dec kernel/jump_label.c:254 [inline]
       static_key_slow_dec+0x4f/0xc0 kernel/jump_label.c:270
       sw_perf_event_destroy+0x99/0x140 kernel/events/core.c:9544
       _free_event+0x2ee/0x1380 kernel/events/core.c:4949
       put_event kernel/events/core.c:5043 [inline]
       perf_mmap_close+0x572/0xe10 kernel/events/core.c:6088
       remove_vma+0xae/0x170 mm/mmap.c:186
       remove_vma_list mm/mmap.c:2659 [inline]
       __do_munmap+0x74f/0x11a0 mm/mmap.c:2915
       do_munmap mm/mmap.c:2923 [inline]
       munmap_vma_range mm/mmap.c:604 [inline]
       mmap_region+0x85a/0x1730 mm/mmap.c:1756
       do_mmap+0xcff/0x11d0 mm/mmap.c:1587
       vm_mmap_pgoff+0x1b7/0x290 mm/util.c:519
       ksys_mmap_pgoff+0x4a8/0x620 mm/mmap.c:1638
       do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&mm->mmap_lock#2){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:2938 [inline]
       check_prevs_add kernel/locking/lockdep.c:3061 [inline]
       validate_chain kernel/locking/lockdep.c:3676 [inline]
       __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
       lock_acquire kernel/locking/lockdep.c:5512 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
       __might_fault mm/memory.c:5070 [inline]
       __might_fault+0x106/0x180 mm/memory.c:5055
       _copy_to_user+0x27/0x150 lib/usercopy.c:28
       copy_to_user include/linux/uaccess.h:200 [inline]
       _perf_ioctl+0x882/0x2650 kernel/events/core.c:5603
       perf_ioctl+0x76/0xb0 kernel/events/core.c:5683
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:1069 [inline]
       __se_sys_ioctl fs/ioctl.c:1055 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
       do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock#2 --> pmus_lock --> &cpuctx_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&cpuctx_mutex);
                               lock(pmus_lock);
                               lock(&cpuctx_mutex);
  lock(&mm->mmap_lock#2);

 *** DEADLOCK ***

1 lock held by syz-executor.0/26566:
 #0: ffff8880b9c3a4b0 (&cpuctx_mutex){+.+.}-{3:3}, at: perf_event_ctx_lock_nested+0x26c/0x480 kernel/events/core.c:1356

stack backtrace:
CPU: 1 PID: 26566 Comm: syz-executor.0 Not tainted 5.13.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2129
 check_prev_add kernel/locking/lockdep.c:2938 [inline]
 check_prevs_add kernel/locking/lockdep.c:3061 [inline]
 validate_chain kernel/locking/lockdep.c:3676 [inline]
 __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 __might_fault mm/memory.c:5070 [inline]
 __might_fault+0x106/0x180 mm/memory.c:5055
 _copy_to_user+0x27/0x150 lib/usercopy.c:28
 copy_to_user include/linux/uaccess.h:200 [inline]
 _perf_ioctl+0x882/0x2650 kernel/events/core.c:5603
 perf_ioctl+0x76/0xb0 kernel/events/core.c:5683
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f021b976188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000020000000 RSI: 0000000080082407 RDI: 0000000000000003
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffdd1a9f15f R14: 00007f021b976300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
