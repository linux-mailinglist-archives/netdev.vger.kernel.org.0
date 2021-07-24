Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02863D461D
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhGXHG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 03:06:58 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51765 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhGXHG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 03:06:57 -0400
Received: by mail-io1-f70.google.com with SMTP id z21-20020a5d84d50000b02904e00bb129f0so3489316ior.18
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 00:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4XG3PYSleC8EliCRO9+aVPrJ5jiqCH3K7OK1Vx67Dpw=;
        b=ZP+1KjMUaGx0wMcI/04Pjd5XtLsnME1Bl9yWrOxSpcYVwmf1uiZPesvos1uA5gNp/c
         VkmpuQDbmKoA1+BepPf4fN8SdWK4L87mdynBRl0doO5R+t8646s0KuPpybgIIx7H/gRg
         Uvg9etI9nA8o/h/N6ZTZMxhO2Zf/4mys0Q/EVbvhdS0TtZo76eyRW9BnwC0Dhkitw0XF
         ftIGR86AKdp1K6sF0YzvEyj0bW1v0PCEjrksKq/EV6KrN5F0x9uo6K1bIWgs1V8Yjc4M
         OiIC5WBrcqoWFqNLjchuaRk3ZFE8d/gLfkswX6yHsbGyD8CJnXEzFiKX5SVs1D0kZWPv
         bp3A==
X-Gm-Message-State: AOAM533CbfQJhamLe9b2RrbpJgj0ISJpByQJYTVVsN8NYmuAOnbZug8S
        KMpLxY6yQqQ9axjplERLp9QEIj/ihGmwfzGt+Fp+fSOxVKWC
X-Google-Smtp-Source: ABdhPJwt5vSsnNiOYajOEOhq70lFbdplj8PE/SqfAm3S8a9QfkRD3CwKgLlrlXRWjgy2JwqKF4cOzbO+9lP7NwH2HMgQx1tgBGcM
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2f09:: with SMTP id q9mr6846237iow.196.1627112849887;
 Sat, 24 Jul 2021 00:47:29 -0700 (PDT)
Date:   Sat, 24 Jul 2021 00:47:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d5cab05c7d9bb87@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in bpf_get_current_cgroup_id
From:   syzbot <syzbot+7ee5c2c09c284495371f@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d6371c76e20d bpf: Fix OOB read when printing XDP link fdinfo
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=146597f2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6da37c7627210105
dashboard link: https://syzkaller.appspot.com/bug?extid=7ee5c2c09c284495371f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126b7c40300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1616cf6a300000

The issue was bisected to:

commit 79a7f8bdb159d9914b58740f3d31d602a6e4aca8
Author: Alexei Starovoitov <ast@kernel.org>
Date:   Fri May 14 00:36:03 2021 +0000

    bpf: Introduce bpf_sys_bpf() helper and program type.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a73112300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a73112300000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a73112300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ee5c2c09c284495371f@syzkaller.appspotmail.com
Fixes: 79a7f8bdb159 ("bpf: Introduce bpf_sys_bpf() helper and program type.")

=============================
WARNING: suspicious RCU usage
5.14.0-rc1-syzkaller #0 Not tainted
-----------------------------
include/linux/cgroup.h:481 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
no locks held by syz-executor499/8468.

stack backtrace:
CPU: 1 PID: 8468 Comm: syz-executor499 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 task_css_set include/linux/cgroup.h:481 [inline]
 task_dfl_cgroup include/linux/cgroup.h:550 [inline]
 ____bpf_get_current_cgroup_id kernel/bpf/helpers.c:356 [inline]
 bpf_get_current_cgroup_id+0x1ce/0x210 kernel/bpf/helpers.c:354
 bpf_prog_08c4887f705f20b8+0x10/0x824
 bpf_dispatcher_nop_func include/linux/bpf.h:687 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:624 [inline]
 bpf_prog_test_run_syscall+0x2cf/0x5f0 net/bpf/test_run.c:954
 bpf_prog_test_run kernel/bpf/syscall.c:3207 [inline]
 __sys_bpf+0x1993/0x53b0 kernel/bpf/syscall.c:4487
 __do_sys_bpf kernel/bpf/syscall.c:4573 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4571 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4571
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44d6a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f32119dd318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004cb3e8 RCX: 000000000044d6a9
RDX: 0000000000000048 RSI: 0000000020000500 RDI: 000000000000000a
RBP: 00000000004cb3e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 656c6c616b7a7973
R13: 00007ffeb7672e8f R14: 00007f32119dd400 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
