Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58635A3790
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiH0MQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 08:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiH0MQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 08:16:43 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB8F8C469;
        Sat, 27 Aug 2022 05:16:42 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-334dc616f86so94666797b3.8;
        Sat, 27 Aug 2022 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=xvQ/553e0fwNr/YlwFMDOp1bC2WqdzKB2HXZEwukGhQ=;
        b=J89GPu1sCOxP9yQ6m52w2u6C7CtPn9o6ymz2cF4+SyZpnxRWE6V3YLJQ61bfhLyOQi
         VK52uUmOt02qCpSdMLtRgjhjgjB2qNvMZauZU1M5PANBx/SgUZcFs7ev+/hA2HDbKAnt
         JK9stsQYb4xH+JJM5v3TZRn+1zXuFZuhVsR3z7zcq3nIbOn5Q8tROrjQQEJpne9l51IZ
         jsh713sF2Mji+8ZijNmv4tFNljRkrHlk0RasUmA17c7it0Ujj7InbUiNHG+0P+X6HCoS
         5DoEp4WbHnEHmUpLRUdIlem9sywiXCDWElyJfH4fe/zD+GyfI/6yEGCD+4rgprawLjo2
         18tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=xvQ/553e0fwNr/YlwFMDOp1bC2WqdzKB2HXZEwukGhQ=;
        b=O7ipfK67Z+MfAt/2Z5XjcPNkossrSoa3Z0I4rxuRBJkFH20fx6asIlPAPHWki/l8z/
         gSrz6vhF3rOMkCFL5NHobXtERdQ+jbvkINMbfdKHHcxnzXIWOPVP4HoMuAsfuNfXnQ1M
         N6uJH+9Xn8F4JyMAgw2hNCs32gZGnFh8fsadN4pOzrjUCAWwn1EN9s7N9OBPUZ6poY4G
         rqg5sLOjjYSZnFCxomzN24O+XuEJefcoZI+EHc2zUXd9BpEWDL45JHXJrVqa/YS/u+qp
         7Q4Qr3sSbqdgbfWGmad213bYLV+amOF6/omrxAm7XY1Gr0RGnPBhbxiZDMgq2GdheM4h
         jA0A==
X-Gm-Message-State: ACgBeo2ymWJ/hDM1b0tKwII91NOeJ0N+ZsffM/qxTboUE5sViPji+t4K
        R2yXyw02HD8+dHih98nCW32aM103JD93I0jc5Rpc/m/4JYAakNzw
X-Google-Smtp-Source: AA6agR4TxtbmnqfASdstyr2/pDAOTaobgz5skw9Ws6ZYzuWOvkSQxg/9kXxGHnnI2YwfQ+kPRt6x8c4Nj8PskLwDN+o=
X-Received: by 2002:a0d:cbd6:0:b0:340:c4ab:7cbb with SMTP id
 n205-20020a0dcbd6000000b00340c4ab7cbbmr1370196ywd.299.1661602601391; Sat, 27
 Aug 2022 05:16:41 -0700 (PDT)
MIME-Version: 1.0
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Sat, 27 Aug 2022 20:16:28 +0800
Message-ID: <CAO4S-meXAMrhR+SjGaNqWAs7C6j6fiyhHhGPk-Am94KsgisAfw@mail.gmail.com>
Subject: KASAN: use-after-free in notifier_call_chain
To:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using modified Syzkaller to fuzz the Linux kernel-5.19, the
following crash was triggered.

HEAD commit: 3d7cb6b04c3f Linux-5.19
git tree: upstream

console output:
https://drive.google.com/file/d/1vFxsfRPkb7zceLp-iG-gMaedQngemuLZ/view?usp=sharing
kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing

Sorry, I don't have a reproducer for this crash. May the symbolized
report help.

If you fix this issue, please add the following tag to the commit:
Reported-by Jiacheng Xu<578001344xu@gmail.com>.
==================================================================
BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200
kernel/notifier.c:75
Read of size 8 at addr ffff88810e670268 by task syz-executor/7496

CPU: 0 PID: 7496 Comm: syz-executor Not tainted 5.19.0 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:313 [inline]
 print_report.cold+0xe5/0x659 mm/kasan/report.c:429
 kasan_report+0x8a/0x1b0 mm/kasan/report.c:491
 notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
 call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10231 [inline]
 netdev_run_todo+0xbca/0x1110 net/core/dev.c:10345
 tun_detach drivers/net/tun.c:704 [inline]
 tun_chr_close+0xe0/0x180 drivers/net/tun.c:3455
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xe0/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xaf5/0x2da0 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 get_signal+0x2842/0x2870 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2270 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x174/0x260 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f952e895dfd
Code: Unable to access opcode bytes at RIP 0x7f952e895dd3.
RSP: 002b:00007f952f9afcd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f952e9bc210 RCX: 00007f952e895dfd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f952e9bc218
RBP: 00007f952e9bc218 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f952e9bc21c
R13: 00007ffda9eed5ff R14: 00007ffda9eed7a0 R15: 00007f952f9afdc0
 </TASK>

Allocated by task 6613:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:750
 slab_alloc_node mm/slub.c:3243 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
 kmem_cache_alloc+0x1be/0x460 mm/slub.c:3268
 kmem_cache_zalloc include/linux/slab.h:723 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0xea/0x660 net/core/net_namespace.c:458
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc8/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x450/0x920 kernel/fork.c:3165
 __do_sys_unshare kernel/fork.c:3236 [inline]
 __se_sys_unshare kernel/fork.c:3234 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3234
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 7516:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0x11d/0x190 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook mm/slub.c:1780 [inline]
 slab_free mm/slub.c:3536 [inline]
 kmem_cache_free+0xf6/0x490 mm/slub.c:3553
 net_free net/core/net_namespace.c:432 [inline]
 net_free+0x9b/0xd0 net/core/net_namespace.c:428
 cleanup_net+0x7e8/0xa90 net/core/net_namespace.c:615
 process_one_work+0x9cc/0x1650 kernel/workqueue.c:2289
 worker_thread+0x623/0x1070 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The buggy address belongs to the object at ffff88810e670000
 which belongs to the cache net_namespace of size 6784
The buggy address is located 616 bytes inside of
 6784-byte region [ffff88810e670000, ffff88810e671a80)

The buggy address belongs to the physical page:
page:ffffea0004399c00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x10e670
head:ffffea0004399c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000010200 0000000000000000 dead000000000122 ffff888011a14f00
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP
                 _COMP|__GFP_NOMEMALLOC), pid 6613, tgid 6613
(syz-executor), ts 47324843590, free_ts 46954173512
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook mm/page_alloc.c:2449 [inline]
 prep_new_page+0x297/0x330 mm/page_alloc.c:2456
 get_page_from_freelist+0x215f/0x3c50 mm/page_alloc.c:4202
 __alloc_pages+0x321/0x710 mm/page_alloc.c:5430
 alloc_pages+0x119/0x250 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab mm/slub.c:1969 [inline]
 new_slab+0x2a9/0x3f0 mm/slub.c:2029
 ___slab_alloc+0xd5a/0x1140 mm/slub.c:3031
 __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
 kmem_cache_alloc+0x386/0x460 mm/slub.c:3268
 kmem_cache_zalloc include/linux/slab.h:723 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0xea/0x660 net/core/net_namespace.c:458
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc8/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x450/0x920 kernel/fork.c:3165
 __do_sys_unshare kernel/fork.c:3236 [inline]
 __se_sys_unshare kernel/fork.c:3234 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3234
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x51f/0xd00 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x19/0x5b0 mm/page_alloc.c:3438
 do_slab_free mm/slub.c:3524 [inline]
 ___cache_free+0x12c/0x140 mm/slub.c:3543
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x13d/0x180 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:750
 slab_alloc_node mm/slub.c:3243 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmalloc+0x184/0x4c0 mm/slub.c:4442
 kmalloc include/linux/slab.h:605 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x1d1/0x590 security/tomoyo/file.c:723
 security_file_ioctl+0x50/0xb0 security/security.c:1551
 __do_sys_ioctl fs/ioctl.c:864 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88810e670100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88810e670180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88810e670200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff88810e670280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88810e670300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
