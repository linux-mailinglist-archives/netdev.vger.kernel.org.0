Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D20247A573
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 08:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhLTHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 02:41:26 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:33751 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbhLTHlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 02:41:25 -0500
Received: by mail-il1-f200.google.com with SMTP id w1-20020a056e021a6100b0029f42663adcso4744419ilv.0
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 23:41:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RytUdnzVGkCTxVVyLQox42i7D0tYk89snCrw0fjmvko=;
        b=22QFoBqUEh8YfGcPP/ZlQTZ16nCrDrpkGlp5YiAxoReeyTYGo5gr3ohWaTPlEzclXP
         +IL6KRBxFvzvO2aCRnHon4lm4mFkrscBxwE+TLXKNeve+v3bNcBK/LDb0xPi7SImUpa1
         glSSXxUqsp/NwDp6skca8ypHj8Xyl0smj0daL4yjQJbMM5XNEXEQQg7BBJ1po9dMyhO1
         uT7MiAOLiRQXUAHjd5/yXWRbXdIbtW9GFaGjxSKEyZeY9UBz5EVZH18KTbCVvJvqNjjp
         GNcqleFYAE0ZmJaIsDt1heMqjsCv12JQzjSaNMDWYFPMJYIJmvrOTDbRVgclQrSIlW//
         AXsQ==
X-Gm-Message-State: AOAM532NFanri2/qim3B/ZKEQxn7pjB8LlFr/5GJr+wdtkrMgIgNZXrD
        3wTusVHYrKCKJtIXP5uV2jXZ4VARfhxqMNpRZSqVafMwpTPY
X-Google-Smtp-Source: ABdhPJzICsA6qDPBF+mKbLrfqRVchCfqb00wsIltL+sOGZotjPXUJvuV9XAYiXTL6RNrqNBTWh8kQKMyQTGr/yFWw+iX0+xU+sYo
MIME-Version: 1.0
X-Received: by 2002:a05:6638:168a:: with SMTP id f10mr2413086jat.279.1639986084902;
 Sun, 19 Dec 2021 23:41:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 23:41:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006fee605d38f0418@google.com>
Subject: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_prog_put
From:   syzbot <syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lmb@cloudflare.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9eaa88c7036e Merge tag 'libata-5.16-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ed4143b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10f3f669b8093e95
dashboard link: https://syzkaller.appspot.com/bug?extid=bb73e71cf4b8fd376a4f
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112d6ca5b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17393549b00000

The issue was bisected to:

commit 38207a5e81230d6ffbdd51e5fa5681be5116dcae
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Fri Nov 19 18:14:17 2021 +0000

    bpf, sockmap: Attach map progs to psock early for feature probes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13532e85b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d32e85b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17532e85b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641

CPU: 1 PID: 3641 Comm: syz-executor020 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 __dump_stack lib/dump_stack.c:88 [inline] lib/dump_stack.c:106
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106 lib/dump_stack.c:106
 print_address_description+0x65/0x380 mm/kasan/report.c:247 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 __kasan_report mm/kasan/report.c:433 [inline] mm/kasan/report.c:450
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
 __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
 __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
 bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
 bpf_prog_release+0x37/0x40 kernel/bpf/syscall.c:1837 kernel/bpf/syscall.c:1837
 __fput+0x3fc/0x870 fs/file_table.c:280 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 exit_task_work include/linux/task_work.h:32 [inline] kernel/exit.c:832
 do_exit+0x705/0x24f0 kernel/exit.c:832 kernel/exit.c:832
 do_group_exit+0x168/0x2d0 kernel/exit.c:929 kernel/exit.c:929
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:940 kernel/exit.c:940
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:938 kernel/exit.c:938
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:938 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3b90ccd1d9
Code: Unable to access opcode bytes at RIP 0x7f3b90ccd1af.
RSP: 002b:00007ffdeec58318 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f3b90d41330 RCX: 00007f3b90ccd1d9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc4 R09: 00007ffdeec58390
R10: 00007ffdeec58390 R11: 0000000000000246 R12: 00007f3b90d41330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>


Memory state around the buggy address:
 ffffc90000e75f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e75f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc90000e76000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                        ^
 ffffc90000e76080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e76100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
