Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4313F4B0A4D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiBJKJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:09:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbiBJKJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:09:29 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0D3FD8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:09:29 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id d3-20020a92d783000000b002bdfbe72c13so3629470iln.6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:09:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=H26uhXqNf/HlXPlFIZtr8pmKxHk/dt5G+KNL6a6flEY=;
        b=dlUjtxPQUuC0uRGNyrZIxNkqrZ5K7H4JxZUuha33psUs7NGPWL/bKq+rc01iSL8K/f
         OI//gEV1NOiDRl67g70aBy6r6e7z5tYNJyOY+4EFqAb/XeME/+hfVrGfvDk9wsnUv4gl
         ti2wLZt9onFMQr7ONVu/LNJ251DYZ95xvtj7oxiSroE9OTz+itlSCeYlOgMDKuhp8eT8
         N70kOlVbzM379s7CYjha4SvzAcLPNEfmbjnZVLo+py/hab4wHBVIp8O7EaxR0tmWDzl4
         FQk/wS4FmO9wb1ZxVYQ9hqX2yvmuc8RHjoZ98UDe1IvkXy24BotVCbWq0eyNqfCM75mJ
         ri/A==
X-Gm-Message-State: AOAM533qeySt4iL1QiJpWjc/SsGWoKXi8swdffvLi/gyeqvaoUu+QCS3
        ESChC6oYV9R0OPZ7p7MVewsrZdvffkvd7QJDi2wwJrEmALLi
X-Google-Smtp-Source: ABdhPJwI8syl2er5tsXbTrN7FkI8sR4wbX6x0AppvYliZ9wZDmvIk4PegggX7v+PvzrQoenNXd+c/WeOJWXZLZGN23TwQcpJ0BYc
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e91:: with SMTP id m17mr3446789iow.96.1644487768576;
 Thu, 10 Feb 2022 02:09:28 -0800 (PST)
Date:   Thu, 10 Feb 2022 02:09:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000489d6105d7a7255e@google.com>
Subject: [syzbot] KCSAN: data-race in perf_event_update_userpage /
 perf_event_update_userpage (5)
From:   syzbot <syzbot+df838a721c117d596976@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
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

HEAD commit:    dcb85f85fa6f gcc-plugins/stackleak: Use noinstr in favor o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f2e20c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a83209f215159f48
dashboard link: https://syzkaller.appspot.com/bug?extid=df838a721c117d596976
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df838a721c117d596976@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in perf_event_update_userpage / perf_event_update_userpage

write to 0xffff88812430e020 of 8 bytes by task 11328 on cpu 1:
 perf_event_update_userpage+0x328/0x3b0 kernel/events/core.c:5941
 cpu_clock_event_add+0x11d/0x130 kernel/events/core.c:10780
 event_sched_in+0x781/0xe60 kernel/events/core.c:2601
 group_sched_in kernel/events/core.c:2637 [inline]
 merge_sched_in kernel/events/core.c:3802 [inline]
 visit_groups_merge+0x943/0x1a50 kernel/events/core.c:3746
 ctx_flexible_sched_in kernel/events/core.c:3844 [inline]
 ctx_sched_in+0x221/0x240 kernel/events/core.c:3892
 perf_event_sched_in kernel/events/core.c:2741 [inline]
 perf_event_context_sched_in kernel/events/core.c:3943 [inline]
 __perf_event_task_sched_in+0x37c/0x8d0 kernel/events/core.c:3986
 perf_event_task_sched_in include/linux/perf_event.h:1213 [inline]
 finish_task_switch+0x1ef/0x280 kernel/sched/core.c:4861
 context_switch kernel/sched/core.c:4989 [inline]
 __schedule+0x43a/0x690 kernel/sched/core.c:6295
 preempt_schedule_common kernel/sched/core.c:6461 [inline]
 __cond_resched+0x3f/0x90 kernel/sched/core.c:8174
 might_resched include/linux/kernel.h:110 [inline]
 might_alloc include/linux/sched/mm.h:256 [inline]
 slab_pre_alloc_hook mm/slab.h:705 [inline]
 slab_alloc mm/slab.c:3298 [inline]
 kmem_cache_alloc+0x45/0x320 mm/slab.c:3499
 kmem_cache_zalloc include/linux/slab.h:705 [inline]
 __proc_create+0x3cf/0x6a0 fs/proc/generic.c:426
 _proc_mkdir+0x5c/0xf0 fs/proc/generic.c:487
 proc_net_mkdir include/linux/proc_fs.h:226 [inline]
 nfs_fs_proc_net_init+0x79/0x140 fs/nfs/client.c:1329
 nfs_net_init+0x19/0x20 fs/nfs/inode.c:2346
 ops_init+0x1e7/0x230 net/core/net_namespace.c:140
 setup_net+0x29b/0x7e0 net/core/net_namespace.c:330
 copy_net_ns+0x2a9/0x450 net/core/net_namespace.c:474
 create_new_namespaces+0x231/0x560 kernel/nsproxy.c:110
 copy_namespaces+0x116/0x160 kernel/nsproxy.c:178
 copy_process+0x1428/0x2f30 kernel/fork.c:2167
 kernel_clone+0x15c/0x6a0 kernel/fork.c:2555
 __do_sys_clone kernel/fork.c:2672 [inline]
 __se_sys_clone kernel/fork.c:2656 [inline]
 __x64_sys_clone+0xc6/0xf0 kernel/fork.c:2656
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff88812430e020 of 8 bytes by task 11341 on cpu 0:
 perf_event_update_userpage+0x328/0x3b0 kernel/events/core.c:5941
 perf_mmap+0xcd6/0xe50 kernel/events/core.c:6419
 call_mmap include/linux/fs.h:2079 [inline]
 mmap_region+0xb04/0x10b0 mm/mmap.c:1793
 do_mmap+0x781/0xc20 mm/mmap.c:1582
 vm_mmap_pgoff+0x117/0x1f0 mm/util.c:519
 ksys_mmap_pgoff+0x265/0x320 mm/mmap.c:1630
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000000000000000 -> 0x000000000135f629

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 11341 Comm: syz-executor.4 Not tainted 5.17.0-rc2-syzkaller-00167-gdcb85f85fa6f-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
