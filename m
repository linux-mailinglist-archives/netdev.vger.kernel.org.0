Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5D433655
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbhJSMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:52:36 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36502 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhJSMwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:52:35 -0400
Received: by mail-il1-f199.google.com with SMTP id c17-20020a92c791000000b0025929f440f0so10078691ilk.3
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bFZmoTBRl1R1qYVXczghINGlIPTaUfOP94TF4bR5q2Q=;
        b=yXDjTXii0Yj9n9kkEbAFJBTkZJxADqITAfQ0DYxkkvoEDo/uF9hS/3RRxYkHh2NJ01
         ZM88gwK9kPRu4826MIEHIgnNqmr5CF+YgOdRFFfsetniu+rRtVODYWNePQ+HrHkoynWk
         yg9udq7CzhJJ7n8JvryPVCC9gD64tdVbnVYw5cL5x5DydERyd2M0RilpBlXzCdxdFXGU
         u/ijfmMQvUxKZa/UGY4FV07qwk52gcC9i7RK/88qKp98FYGPeLAVFWxnpN9RY0HTf6S2
         od3+5L2rVkupAnPaRV2urCj3vlcMLiR0y9hFCqQbowpPvAz5Ouwsy5TtJmt+UMOD+qpY
         86Zw==
X-Gm-Message-State: AOAM531HoZba1D/nfROAWuVJKFlenHF5Um2W85iNaMk4ZpIMZEpSk6kH
        y3xKTO1skT3SEMayPZPyaeynjZX/WyiziTgvbPAEmmfppniq
X-Google-Smtp-Source: ABdhPJw+uxCUYWF5tbRGkCVF+1A0ZsW/FYvAv+CVSHoENSvNrVk69XQJ5tVs6n3O0t3lc53aK1UeQyPutzRHhzT/Q+W3o+eEnK97
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr4114717jak.148.1634647822011;
 Tue, 19 Oct 2021 05:50:22 -0700 (PDT)
Date:   Tue, 19 Oct 2021 05:50:22 -0700
In-Reply-To: <0000000000007e727005c284bc8e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3972705ceb41add@google.com>
Subject: Re: [syzbot] possible deadlock in perf_event_ctx_lock_nested (2)
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    60e8840126bd Add linux-next specific files for 20211018
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15c92b80b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4bd44cafcda7632e
dashboard link: https://syzkaller.appspot.com/bug?extid=4b71bb3365e7d5228913
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eccf58b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b71bb3365e7d5228913@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.15.0-rc5-next-20211018-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.1/30066 is trying to acquire lock:
ffff88807cb88f28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa1/0x170 mm/memory.c:5243

but task is already holding lock:
ffff8880b9c3fab0 (&cpuctx_mutex){+.+.}-{3:3}, at: perf_event_ctx_lock_nested+0x23a/0x490 kernel/events/core.c:1357

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&cpuctx_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:599 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:732
       perf_event_init_cpu+0x172/0x3e0 kernel/events/core.c:13325
       perf_event_init+0x39d/0x408 kernel/events/core.c:13372
       start_kernel+0x2bb/0x49b init/main.c:1063
       secondary_startup_64_no_verify+0xb0/0xbb

-> #2 (pmus_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:599 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:732
       perf_event_init_cpu+0xc4/0x3e0 kernel/events/core.c:13319
       cpuhp_invoke_callback+0x3b5/0x9a0 kernel/cpu.c:190
       cpuhp_invoke_callback_range kernel/cpu.c:665 [inline]
       cpuhp_up_callbacks kernel/cpu.c:693 [inline]
       _cpu_up+0x3b0/0x790 kernel/cpu.c:1368
       cpu_up kernel/cpu.c:1404 [inline]
       cpu_up+0xfe/0x1a0 kernel/cpu.c:1376
       bringup_nonboot_cpus+0xfe/0x130 kernel/cpu.c:1470
       smp_init+0x2e/0x145 kernel/smp.c:1092
       kernel_init_freeable+0x477/0x73a init/main.c:1618
       kernel_init+0x1a/0x1d0 init/main.c:1515
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #1 (cpu_hotplug_lock){++++}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       cpus_read_lock+0x3e/0x140 kernel/cpu.c:308
       wake_up_all_idle_cpus+0x13/0x80 kernel/smp.c:1173
       cpu_latency_qos_apply kernel/power/qos.c:249 [inline]
       cpu_latency_qos_remove_request.part.0+0xc4/0x2f0 kernel/power/qos.c:328
       cpu_latency_qos_remove_request+0x65/0x80 kernel/power/qos.c:330
       snd_pcm_hw_params+0x1481/0x1990 sound/core/pcm_native.c:784
       snd_pcm_kernel_ioctl+0x164/0x310 sound/core/pcm_native.c:3355
       snd_pcm_oss_change_params_locked+0x1936/0x3a60 sound/core/oss/pcm_oss.c:947
       snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1091 [inline]
       snd_pcm_oss_mmap+0x442/0x550 sound/core/oss/pcm_oss.c:2910
       call_mmap include/linux/fs.h:2164 [inline]
       mmap_region+0xd8c/0x1650 mm/mmap.c:1787
       do_mmap+0x869/0xfb0 mm/mmap.c:1575
       vm_mmap_pgoff+0x1b7/0x290 mm/util.c:519
       ksys_mmap_pgoff+0x49f/0x620 mm/mmap.c:1624
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&mm->mmap_lock#2){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3063 [inline]
       check_prevs_add kernel/locking/lockdep.c:3186 [inline]
       validate_chain kernel/locking/lockdep.c:3801 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5027
       lock_acquire kernel/locking/lockdep.c:5637 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
       __might_fault mm/memory.c:5244 [inline]
       __might_fault+0x104/0x170 mm/memory.c:5229
       _copy_to_user+0x27/0x150 lib/usercopy.c:28
       copy_to_user include/linux/uaccess.h:200 [inline]
       perf_read_group kernel/events/core.c:5329 [inline]
       __perf_read kernel/events/core.c:5396 [inline]
       perf_read+0x736/0x900 kernel/events/core.c:5415
       do_loop_readv_writev fs/read_write.c:750 [inline]
       do_loop_readv_writev fs/read_write.c:737 [inline]
       do_iter_read+0x501/0x760 fs/read_write.c:792
       vfs_readv+0xe5/0x150 fs/read_write.c:910
       do_readv+0x139/0x300 fs/read_write.c:947
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
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

1 lock held by syz-executor.1/30066:
 #0: ffff8880b9c3fab0 (&cpuctx_mutex){+.+.}-{3:3}, at: perf_event_ctx_lock_nested+0x23a/0x490 kernel/events/core.c:1357

stack backtrace:
CPU: 0 PID: 30066 Comm: syz-executor.1 Not tainted 5.15.0-rc5-next-20211018-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2143
 check_prev_add kernel/locking/lockdep.c:3063 [inline]
 check_prevs_add kernel/locking/lockdep.c:3186 [inline]
 validate_chain kernel/locking/lockdep.c:3801 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __might_fault mm/memory.c:5244 [inline]
 __might_fault+0x104/0x170 mm/memory.c:5229
 _copy_to_user+0x27/0x150 lib/usercopy.c:28
 copy_to_user include/linux/uaccess.h:200 [inline]
 perf_read_group kernel/events/core.c:5329 [inline]
 __perf_read kernel/events/core.c:5396 [inline]
 perf_read+0x736/0x900 kernel/events/core.c:5415
 do_loop_readv_writev fs/read_write.c:750 [inline]
 do_loop_readv_writev fs/read_write.c:737 [inline]
 do_iter_read+0x501/0x760 fs/read_write.c:792
 vfs_readv+0xe5/0x150 fs/read_write.c:910
 do_readv+0x139/0x300 fs/read_write.c:947
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f78228c6a39
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7821ffa188 EFLAGS: 00000246 ORIG_RAX: 0000000000000013
RAX: ffffffffffffffda RBX: 00007f78229ca0e0 RCX: 00007f78228c6a39
RDX: 0000000000000001 RSI: 00000000200002c0 RDI: 0000000000000007
RBP: 00007f7822920c5f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd71dc7def R14: 00007f7821ffa300 R15: 0000000000022000
 </TASK>

