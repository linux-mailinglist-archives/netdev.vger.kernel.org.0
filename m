Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E12516353
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 11:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344441AbiEAJF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 05:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344408AbiEAJFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 05:05:54 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C959694A4
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 02:02:29 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id v11-20020a056e0213cb00b002cbcd972206so6022442ilj.11
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 02:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P+O7ufqa93FBYiLQsa6nwfl7FdghLuWW8u1OubTNuYI=;
        b=K31HRA+tRBoTS+2dKeBKzXvhk9+A1Zg6z8QstlqNc2zS8AP1OytEFoTjuKzh9z+wVp
         50K0Rcz29jy+5v7962GGRLzlfUkqyjxyIrcQQ8AeBJccDDxTid+5jgUMi/yVaL319ZXQ
         rQvqMsg2CyxaMOtEZV1CgN3E85yr79LvcVQVJ/Fe5CwWVWIezp07UaR/lt52Ll1GGZ9X
         lJ9w3AVpi8YDQ+TvRHDH+mEjRy3vZQ+K7xkFfa1whVZHDqPibrQJziiZRJMygZvRxfn3
         wgCwgxULD7poFuwdl+7UXv0uCmwb4CEXWYFftwTIRRQcSOrxOYoquqMnpAvBmVTGCcNe
         JUyQ==
X-Gm-Message-State: AOAM530FhwGT8dS56FA+FreDtGDrhG05hEVpywiQWFB/bda3/vxvcRpK
        ky1kSLs/X72COGdv5Yje9yCMdy66oGTcks+KC4LOJWOUcR4k
X-Google-Smtp-Source: ABdhPJzhyHTsyWv402caixLvYEVtRf13gwiTTXTH49NP3qoe21UZLQRQFSKjvg2ABwe+hchGf6oZ4NLykskFrc0aG0RZ5qch25H2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2148:b0:2cd:8c85:b5c0 with SMTP id
 d8-20020a056e02214800b002cd8c85b5c0mr2738688ilv.249.1651395748245; Sun, 01
 May 2022 02:02:28 -0700 (PDT)
Date:   Sun, 01 May 2022 02:02:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f537cc05ddef88db@google.com>
Subject: [syzbot] BUG: Bad page map (5)
From:   syzbot <syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bigeasy@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com
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

HEAD commit:    0966d385830d riscv: Fix auipc+jalr relocation range checks
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=10e1526cf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
dashboard link: https://syzkaller.appspot.com/bug?extid=915f3e317adb0e85835f
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
BUG: Bad page map in process syz-executor.0  pte:ffffaf80215a00f0 pmd:285e7c01
addr:00007fffbd3e6000 vm_flags:100400fb anon_vma:0000000000000000 mapping:ffffaf800ab1e058 index:3c
file:kcov fault:0x0 mmap:kcov_mmap readpage:0x0
CPU: 1 PID: 2051 Comm: syz-executor.0 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff803cdcdc>] print_bad_pte+0x3d4/0x4a0 mm/memory.c:563
[<ffffffff803d1622>] vm_normal_page+0x20c/0x22a mm/memory.c:626
[<ffffffff803dbb4e>] copy_present_pte mm/memory.c:949 [inline]
[<ffffffff803dbb4e>] copy_pte_range mm/memory.c:1074 [inline]
[<ffffffff803dbb4e>] copy_pmd_range mm/memory.c:1160 [inline]
[<ffffffff803dbb4e>] copy_pud_range mm/memory.c:1197 [inline]
[<ffffffff803dbb4e>] copy_p4d_range mm/memory.c:1221 [inline]
[<ffffffff803dbb4e>] copy_page_range+0x828/0x236c mm/memory.c:1294
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
BUG: Bad page map in process syz-executor.0  pte:ffffffff801110e4 pmd:285e7c01
addr:00007fffbd3e7000 vm_flags:100400fb anon_vma:0000000000000000 mapping:ffffaf800ab1e058 index:3d
file:kcov fault:0x0 mmap:kcov_mmap readpage:0x0
CPU: 1 PID: 2051 Comm: syz-executor.0 Tainted: G    B             5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff803cdcdc>] print_bad_pte+0x3d4/0x4a0 mm/memory.c:563
[<ffffffff803d1622>] vm_normal_page+0x20c/0x22a mm/memory.c:626
[<ffffffff803dbb4e>] copy_present_pte mm/memory.c:949 [inline]
[<ffffffff803dbb4e>] copy_pte_range mm/memory.c:1074 [inline]
[<ffffffff803dbb4e>] copy_pmd_range mm/memory.c:1160 [inline]
[<ffffffff803dbb4e>] copy_pud_range mm/memory.c:1197 [inline]
[<ffffffff803dbb4e>] copy_p4d_range mm/memory.c:1221 [inline]
[<ffffffff803dbb4e>] copy_page_range+0x828/0x236c mm/memory.c:1294
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
BUG: Bad page map in process syz-executor.0  pte:ffffffff801110e4 pmd:285e7c01
addr:00007fffbd3ef000 vm_flags:100400fb anon_vma:0000000000000000 mapping:ffffaf800ab1e058 index:45
file:kcov fault:0x0 mmap:kcov_mmap readpage:0x0
CPU: 1 PID: 2051 Comm: syz-executor.0 Tainted: G    B             5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff803cdcdc>] print_bad_pte+0x3d4/0x4a0 mm/memory.c:563
[<ffffffff803d1622>] vm_normal_page+0x20c/0x22a mm/memory.c:626
[<ffffffff803dbb4e>] copy_present_pte mm/memory.c:949 [inline]
[<ffffffff803dbb4e>] copy_pte_range mm/memory.c:1074 [inline]
[<ffffffff803dbb4e>] copy_pmd_range mm/memory.c:1160 [inline]
[<ffffffff803dbb4e>] copy_pud_range mm/memory.c:1197 [inline]
[<ffffffff803dbb4e>] copy_p4d_range mm/memory.c:1221 [inline]
[<ffffffff803dbb4e>] copy_page_range+0x828/0x236c mm/memory.c:1294
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
BUG: Bad page map in process syz-executor.0  pte:41b58ab3 pmd:285e7c01
addr:00007fffbd3f4000 vm_flags:100400fb anon_vma:0000000000000000 mapping:ffffaf800ab1e058 index:4a
file:kcov fault:0x0 mmap:kcov_mmap readpage:0x0
CPU: 1 PID: 2051 Comm: syz-executor.0 Tainted: G    B             5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff803cdcdc>] print_bad_pte+0x3d4/0x4a0 mm/memory.c:563
[<ffffffff803d1622>] vm_normal_page+0x20c/0x22a mm/memory.c:626
[<ffffffff803dbb4e>] copy_present_pte mm/memory.c:949 [inline]
[<ffffffff803dbb4e>] copy_pte_range mm/memory.c:1074 [inline]
[<ffffffff803dbb4e>] copy_pmd_range mm/memory.c:1160 [inline]
[<ffffffff803dbb4e>] copy_pud_range mm/memory.c:1197 [inline]
[<ffffffff803dbb4e>] copy_p4d_range mm/memory.c:1221 [inline]
[<ffffffff803dbb4e>] copy_page_range+0x828/0x236c mm/memory.c:1294
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
BUG: Bad page map in process syz-executor.0  pte:ffffffff8451f630 pmd:285e7c01
addr:00007fffbd3f5000 vm_flags:100400fb anon_vma:0000000000000000 mapping:ffffaf800ab1e058 index:4b
file:kcov fault:0x0 mmap:kcov_mmap readpage:0x0
CPU: 1 PID: 2051 Comm: syz-executor.0 Tainted: G    B             5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff803cdcdc>] print_bad_pte+0x3d4/0x4a0 mm/memory.c:563
[<ffffffff803d1622>] vm_normal_page+0x20c/0x22a mm/memory.c:626
[<ffffffff803dbb4e>] copy_present_pte mm/memory.c:949 [inline]
[<ffffffff803dbb4e>] copy_pte_range mm/memory.c:1074 [inline]
[<ffffffff803dbb4e>] copy_pmd_range mm/memory.c:1160 [inline]
[<ffffffff803dbb4e>] copy_pud_range mm/memory.c:1197 [inline]
[<ffffffff803dbb4e>] copy_p4d_range mm/memory.c:1221 [inline]
[<ffffffff803dbb4e>] copy_page_range+0x828/0x236c mm/memory.c:1294
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
Unable to handle kernel paging request at virtual address ffffaf847c9ffff8
Oops [#1]
Modules linked in:
CPU: 1 PID: 2051 Comm: syz-executor.0 Tainted: G    B             5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
epc : __nr_to_section include/linux/mmzone.h:1396 [inline]
epc : __pfn_to_section include/linux/mmzone.h:1480 [inline]
epc : pfn_swap_entry_to_page include/linux/swapops.h:252 [inline]
epc : copy_nonpresent_pte mm/memory.c:798 [inline]
epc : copy_pte_range mm/memory.c:1053 [inline]
epc : copy_pmd_range mm/memory.c:1160 [inline]
epc : copy_pud_range mm/memory.c:1197 [inline]
epc : copy_p4d_range mm/memory.c:1221 [inline]
epc : copy_page_range+0x1ade/0x236c mm/memory.c:1294
 ra : __nr_to_section include/linux/mmzone.h:1396 [inline]
 ra : __pfn_to_section include/linux/mmzone.h:1480 [inline]
 ra : pfn_swap_entry_to_page include/linux/swapops.h:252 [inline]
 ra : copy_nonpresent_pte mm/memory.c:798 [inline]
 ra : copy_pte_range mm/memory.c:1053 [inline]
 ra : copy_pmd_range mm/memory.c:1160 [inline]
 ra : copy_pud_range mm/memory.c:1197 [inline]
 ra : copy_p4d_range mm/memory.c:1221 [inline]
 ra : copy_page_range+0x1ade/0x236c mm/memory.c:1294
epc : ffffffff803dce04 ra : ffffffff803dce04 sp : ffffaf80215a3680
 gp : ffffffff85863ac0 tp : ffffaf8007409840 t0 : ffffaf80215a3830
 t1 : fffff5ef042b4705 t2 : 00007fff83b1f010 s0 : ffffaf80215a38e0
 s1 : ffffffff80110fdc a0 : ffffaf847c9ffff8 a1 : 0000000000000007
 a2 : 1ffff5f08f93ffff a3 : ffffffff803dce04 a4 : 0000000000000000
 a5 : ffffaf847c9ffff8 a6 : 0000000000f00000 a7 : ffffaf80215a382f
 s2 : ffffaf802159ffb0 s3 : ffffaf800f182fb0 s4 : 0000000000000000
 s5 : 7c1ffffffff00221 s6 : 001ffffffff00221 s7 : ffffaf847c9ffff8
 s8 : 000000000000001f s9 : 00007fffbd400000 s10: ffffaf800e521840
 s11: 00007fffbd3f6000 t3 : 000000000001fffe t4 : fffff5ef042b4704
 t5 : fffff5ef042b4706 t6 : 000000000002463c
status: 0000000000000120 badaddr: ffffaf847c9ffff8 cause: 000000000000000d
[<ffffffff80049bcc>] dup_mmap kernel/fork.c:612 [inline]
[<ffffffff80049bcc>] dup_mm+0xb5c/0xe10 kernel/fork.c:1451
[<ffffffff8004c7c6>] copy_mm kernel/fork.c:1503 [inline]
[<ffffffff8004c7c6>] copy_process+0x25da/0x3c34 kernel/fork.c:2164
[<ffffffff8004e106>] kernel_clone+0xee/0x920 kernel/fork.c:2555
[<ffffffff8004ea2a>] __do_sys_clone+0xf2/0x12e kernel/fork.c:2672
[<ffffffff8004ee4e>] sys_clone+0x32/0x44 kernel/fork.c:2640
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
