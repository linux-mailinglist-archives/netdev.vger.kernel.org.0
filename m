Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E808440FD9
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 18:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhJaRoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 13:44:00 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:34450 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhJaRn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 13:43:57 -0400
Received: by mail-il1-f198.google.com with SMTP id j8-20020a056e02154800b0025ac677b446so8689650ilu.1
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 10:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xn2VPDHyczbj/6eKQO8PUyqqrb+LWwudCU/o8kfDPBk=;
        b=Xpm8JS4PsifAH6svXSIy7o82fmP7DQCC8UKZtSSENMw4/jaPiK0Zb/OrDHm514R8jX
         2+scAu0tD9Fu/yAgI8bpjT0/GOtB5k6r0ce69ZSUYc6pGxB0Juhss0t/5WRnVkvHBmA4
         h+sJUtTRQqxrsc5cac07gn4b7So1xDmOT3gIrv+5/ovg/RksEPGD33HWomFuVG2w30rV
         BsGB7029bgoiabofjHx4CKvMWcPeD6TVNFBgHljoX8klssAMsKPJ+VQIMIVSQ1i5xMVo
         GiEeCI9kgw1DVXL7qPrMCudJM7UKBvNH5xr/XtT59gzEigxsZ6FPm95L+VbAKgq9cRw6
         DvOQ==
X-Gm-Message-State: AOAM5334gTKlAUpbPSakgM4880EWdn4F6zT8O8YphHKFoVs9A/PC8tGh
        JweJWRoqJ379HPgQuYOfmeRCIhrBzhwLeBhy722HLhEmLWLk
X-Google-Smtp-Source: ABdhPJxzQ2/toHlxMzf91rZ11FY4t4Ldv56Gktj2rsE+yPXKuvRJLqItCNXBMFIe7y99njaaRL8IkQJ4qY1jSne6PrAIvE367T4s
MIME-Version: 1.0
X-Received: by 2002:a92:c74a:: with SMTP id y10mr9962613ilp.122.1635702084959;
 Sun, 31 Oct 2021 10:41:24 -0700 (PDT)
Date:   Sun, 31 Oct 2021 10:41:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb843a05cfa99111@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in __put_task_struct
From:   syzbot <syzbot+30a60157d4ef222fd5e2@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org,
        asml.silence@gmail.com, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, christian@brauner.io, daniel@iogearbox.net,
        david@redhat.com, ebiederm@xmission.com, io-uring@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        npiggin@gmail.com, peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xiaoguang.wang@linux.alibaba.com,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1413226ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cea91ee10b0cd274
dashboard link: https://syzkaller.appspot.com/bug?extid=30a60157d4ef222fd5e2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ba3e2b00000

The issue was bisected to:

commit 34ced75ca1f63fac6148497971212583aa0f7a87
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Mon Oct 25 05:38:48 2021 +0000

    io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d8286ab00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d8286ab00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d8286ab00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+30a60157d4ef222fd5e2@syzkaller.appspotmail.com
Fixes: 34ced75ca1f6 ("io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request")

------------[ cut here ]------------
ODEBUG: free active (active state 1) object type: rcu_head hint: 0x0
WARNING: CPU: 0 PID: 6915 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 6915 Comm: kworker/0:1 Not tainted 5.15.0-rc7-next-20211029-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_fallback_req_func
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 00 4f bf 89 4c 89 ee 48 c7 c7 00 43 bf 89 e8 88 45 2e 05 <0f> 0b 83 05 05 c1 9f 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc900033a7a98 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88801a799d40 RSI: ffffffff815f3788 RDI: fffff52000674f45
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ed55e R11: 0000000000000000 R12: ffffffff896d62a0
R13: ffffffff89bf4940 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff9fb60898 CR3: 000000000b48e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:992 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1023
 slab_free_hook mm/slub.c:1698 [inline]
 slab_free_freelist_hook+0xeb/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kmem_cache_free+0x92/0x5e0 mm/slub.c:3529
 __put_task_struct+0x277/0x400 kernel/fork.c:810
 put_task_struct_many include/linux/sched/task.h:120 [inline]
 io_put_task fs/io_uring.c:1773 [inline]
 __io_free_req+0x2a3/0x3c5 fs/io_uring.c:2037
 io_fallback_req_func+0xf9/0x1ae fs/io_uring.c:1335
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
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
