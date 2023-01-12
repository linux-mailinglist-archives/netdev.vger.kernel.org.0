Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C454E667F94
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbjALTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbjALTpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:45:25 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C6025F3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:39:37 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so14423194ilh.22
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eo/N/LBiGFgmNgJk/2vZn4x6VJgF0Ie165FrN6AxRj4=;
        b=feSSP/wEgzl9xNFxJQxYiFl3crwPjMfk4Tw7fs+p9Bc/mhc/SWaOdW/7JMRcAFGL2M
         YlmpPVpeEJeygrvFt/sFFdCTurFt41acpjYsAqqTOTv8oVY1yDW7/tN/5WUBk6Wzrp9l
         5QXzriDpxxel2JrdOlIBzx2AiPYDGaVrQl+hsRbKs0leFj9OpDwf+pIDyAPy+KXEC+l8
         izBWQVlE51X7UYIIhwDm6pYSBbTkRbu3WyylBv66i+1ltaXzDFl7N3KKtYDyiK20zW0u
         Fb+PLHunEg9wYoxwPtZuEIdsXR/egi/NHqtmJd0kIrdumtw2/d8uZjlIEylFq61H7Bh4
         lORQ==
X-Gm-Message-State: AFqh2kpojU6x07d6AxHqbg2WxCq4bawHjURzPL7MZwaH4Pzew1NFm1ZP
        KHBqGnTUT7/BAYuWJ4yVXrpVbQc32TxKg/gvuJaQSwEYVzLX
X-Google-Smtp-Source: AMrXdXve9XCmqdMojD1kQmgVRDIQEXJIdenBjdyFCbE6JFFt+K1RfVASSS5CojXKxHks4Pf8Bvzt/WjAIuTxI1rtQXbJoV/NYB52
MIME-Version: 1.0
X-Received: by 2002:a02:6a2e:0:b0:38c:87aa:4590 with SMTP id
 l46-20020a026a2e000000b0038c87aa4590mr9616951jac.33.1673552376932; Thu, 12
 Jan 2023 11:39:36 -0800 (PST)
Date:   Thu, 12 Jan 2023 11:39:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0b41905f2164644@google.com>
Subject: [syzbot] KASAN: use-after-free Read in sock_def_wakeup
From:   syzbot <syzbot+d0b651ccb99ec9dfb265@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15758fbe480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
dashboard link: https://syzkaller.appspot.com/bug?extid=d0b651ccb99ec9dfb265
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1663f4a6480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147293a4480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d0b651ccb99ec9dfb265@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:100
Read of size 8 at addr ffff88802c2fe8f0 by task syz-executor198/5085

CPU: 1 PID: 5085 Comm: syz-executor198 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xc0/0xf0 mm/kasan/report.c:517
 __wake_up_common+0x637/0x650 kernel/sched/wait.c:100
 __wake_up_common_lock+0xd4/0x140 kernel/sched/wait.c:138
 sock_def_wakeup+0xea/0x2d0 net/core/sock.c:3274
 sctp_cmd_new_state net/sctp/sm_sideeffect.c:922 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1334 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1199 [inline]
 sctp_do_sm+0x4080/0x5290 net/sctp/sm_sideeffect.c:1170
 sctp_primitive_ABORT+0x9f/0xc0 net/sctp/primitive.c:104
 sctp_close+0x23f/0x940 net/sctp/socket.c:1524
 inet_release+0x132/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x50/0x70 net/ipv6/af_inet6.c:489
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb17/0x2a90 kernel/exit.c:867
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 __do_sys_exit_group kernel/exit.c:1023 [inline]
 __se_sys_exit_group kernel/exit.c:1021 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ffbdc4ba909
Code: Unable to access opcode bytes at 0x7ffbdc4ba8df.
RSP: 002b:00007fffe16dc638 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffbdc52e290 RCX: 00007ffbdc4ba909
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffbdc52e290
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 5085:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 33:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
 io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
 io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff88802c2fe8c0
 which belongs to the cache io_kiocb of size 216
The buggy address is located 48 bytes inside of
 216-byte region [ffff88802c2fe8c0, ffff88802c2fe998)

The buggy address belongs to the physical page:
page:ffffea0000b0bf80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2c2fe
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff88801c496640 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 5085, tgid 5085 (syz-executor198), ts 57450140651, free_ts 57437968497
 prep_new_page mm/page_alloc.c:2549 [inline]
 get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
 __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
 kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1451 [inline]
 free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page_list+0x176/0xcd0 mm/page_alloc.c:3528
 release_pages+0xcb1/0x1330 mm/swap.c:1072
 tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:97
 tlb_flush_mmu_free mm/mmu_gather.c:292 [inline]
 tlb_flush_mmu mm/mmu_gather.c:299 [inline]
 tlb_finish_mmu+0x14b/0x7e0 mm/mmu_gather.c:391
 exit_mmap+0x202/0x7c0 mm/mmap.c:3100
 __mmput+0x128/0x4c0 kernel/fork.c:1212
 mmput+0x60/0x70 kernel/fork.c:1234
 exec_mmap fs/exec.c:1034 [inline]
 begin_new_exec+0x1027/0x2f80 fs/exec.c:1293
 load_elf_binary+0x801/0x4ff0 fs/binfmt_elf.c:1001
 search_binary_handler fs/exec.c:1736 [inline]
 exec_binprm fs/exec.c:1778 [inline]
 bprm_execve fs/exec.c:1853 [inline]
 bprm_execve+0x7fd/0x1ae0 fs/exec.c:1809
 do_execveat_common+0x72c/0x880 fs/exec.c:1960
 do_execve fs/exec.c:2034 [inline]
 __do_sys_execve fs/exec.c:2110 [inline]
 __se_sys_execve fs/exec.c:2105 [inline]
 __x64_sys_execve+0x93/0xc0 fs/exec.c:2105
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88802c2fe780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802c2fe800: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
>ffff88802c2fe880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                             ^
 ffff88802c2fe900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802c2fe980: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
