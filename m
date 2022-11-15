Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427626291EF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 07:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiKOGjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 01:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKOGjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 01:39:33 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0401EED8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 22:39:29 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id c129so13996150oia.0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 22:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N5T6udbwUxN4V+TXiuDemLgpVTtRJxIfuCHYRQZ2Wu0=;
        b=NW9bMyLgeFOxavEFypqZr5kYrIC7wN5sfm4r8Jq7xwg7IhTSFtZbIB0liBQJeVkAgB
         pMcyzrwx+C9tjtkeebZdl8qHvLH0fHRNHSf3Ez2g7ce6j4pvn1L8jUOOJfQ7hqpfFMp5
         0mN4P9YysVx2Dug1wtpv9FzKe2Bnco5z/ZSu+s7WF7uAgML5x3kFoJW4bis+2VbmbVxz
         aoYiChp+ySDG4am/TvfFLcEjIxKM5fcY4/YWD5UA2ZXAgWMvxzxYbi9FwPbtOCR5cn2X
         DihbBSQAVk423nu/SuLs13iCdmC31E6BcPaEvmgugAtRFGlg7mQW7+mqUeiLksEsx8zc
         8j+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N5T6udbwUxN4V+TXiuDemLgpVTtRJxIfuCHYRQZ2Wu0=;
        b=kHlKp72MXhG4fyZT6hUD4RqUn3Y9ZRklvo+clHemECIoh3otpzXUyqAWGnPO/vciYM
         6gjZMMKHQdjxRfLngZuNEAOdhn+6Zam91QKqnUcvJGhoQczuHpGu9NJkjsEp6k/AwdF0
         SOfmtbW+xlKbeYWdvibut+39WT4pofTvghrPG1mUODkXDkouiOJm0mSh1uKyd1Do4NzJ
         Qq25qwyR7uY4ZhiutZV6A2GcMVjwO/5yE6s2B9UyI4bTDsNNf9qel8k1d2hYcD58cSps
         Dn/nL0K1xSmzl4cBtTrLNMYPRB4Z+8Sn7mjs4AgDsLQJRjlHxPIEHRGrvKdYQyO62nYN
         OOAw==
X-Gm-Message-State: ANoB5pmUPY83gcR0E63qLAE46fVu6L0tQF3JIqYx5wdWWyg2zjSchn8a
        uFBc/uq1eQOYCg0m2l7tA6eNwPn4ILonQqPbGKEjzXkjgb1R+FyaWSjaHoKbOyQvyIITMf/tmn+
        VYFACZv5RQUs/gX2zrHLmIV4=
X-Google-Smtp-Source: AA0mqf5obzYTTmPfW9basmA4M39wBUXgkLIVoQaVU+L/8YM39aqSvSf5DQo4ii+i65YjkvUJWtW8OVZSQsEIEvDEPgM=
X-Received: by 2002:aca:6156:0:b0:359:cb71:328b with SMTP id
 v83-20020aca6156000000b00359cb71328bmr238367oib.282.1668494368589; Mon, 14
 Nov 2022 22:39:28 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dfcce005ed7c6c0b@google.com>
In-Reply-To: <000000000000dfcce005ed7c6c0b@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 15 Nov 2022 07:39:17 +0100
Message-ID: <CACT4Y+bPkFYqk21irsoZObV0WGstDH3OcfEB-3AY88+7WRKD0g@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in enqueue_timer
To:     syzbot <syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com>,
        krzysztof.kozlowski@linaro.org, linma@zju.edu.cn
Cc:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com, jack@suse.cz,
        keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yury.norov@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-ccpol: medium
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 at 07:25, syzbot
<syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    e01d50cbd6ee Merge tag 'vfio-v6.1-rc6' of https://github.c..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16301dae880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d53c245d72cb8f78
> dashboard link: https://syzkaller.appspot.com/bug?extid=6fd64001c20aa99e34a4
> compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com

+NFC/NCI maintainers

I think the root cause is in net/nfc/nci/core.c and suspect it can
manifest when a USB NFC device is disconnected.

> ==================================================================
> BUG: KASAN: use-after-free in hlist_add_head include/linux/list.h:929 [inline]
> BUG: KASAN: use-after-free in enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
> Write at addr f9ff000024df6058 by task syz-fuzzer/2256
> Pointer tag: [f9], memory tag: [fe]
>
> CPU: 1 PID: 2256 Comm: syz-fuzzer Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace.part.0+0xe0/0xf0 arch/arm64/kernel/stacktrace.c:156
>  dump_backtrace arch/arm64/kernel/stacktrace.c:162 [inline]
>  show_stack+0x18/0x40 arch/arm64/kernel/stacktrace.c:163
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x68/0x84 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:284 [inline]
>  print_report+0x1a8/0x4a0 mm/kasan/report.c:395
>  kasan_report+0x94/0xb4 mm/kasan/report.c:495
>  __do_kernel_fault+0x164/0x1e0 arch/arm64/mm/fault.c:320
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_tag_check_fault+0x78/0x8c arch/arm64/mm/fault.c:749
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  hlist_add_head include/linux/list.h:929 [inline]
>  enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
>  mod_timer+0x14/0x20 kernel/time/timer.c:1161
>  mrp_periodic_timer_arm net/802/mrp.c:614 [inline]
>  mrp_periodic_timer+0xa0/0xc0 net/802/mrp.c:627
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  __el1_irq arch/arm64/kernel/entry-common.c:472 [inline]
>  el1_interrupt+0x38/0x6c arch/arm64/kernel/entry-common.c:486
>  el1h_64_irq_handler+0x18/0x2c arch/arm64/kernel/entry-common.c:491
>  el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:577
>  arch_local_irq_enable arch/arm64/include/asm/irqflags.h:35 [inline]
>  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
>  _raw_spin_unlock_irq+0x10/0x50 kernel/locking/spinlock.c:202
>  do_signal arch/arm64/kernel/signal.c:1071 [inline]
>  do_notify_resume+0x25c/0x13b0 arch/arm64/kernel/signal.c:1124
>  prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>  exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>  el0_interrupt+0x100/0x104 arch/arm64/kernel/entry-common.c:719
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
>
> Allocated by task 20941:
>  kasan_save_stack+0x2c/0x60 mm/kasan/common.c:45
>  save_stack_info+0x38/0x130 mm/kasan/tags.c:104
>  kasan_save_alloc_info+0x14/0x20 mm/kasan/tags.c:138
>  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>  __kasan_kmalloc+0x9c/0xb0 mm/kasan/common.c:380
>  kasan_kmalloc include/linux/kasan.h:211 [inline]
>  kmalloc_trace+0x5c/0x70 mm/slab_common.c:1050
>  kmalloc include/linux/slab.h:553 [inline]
>  kzalloc include/linux/slab.h:689 [inline]
>  nci_allocate_device net/nfc/nci/core.c:1157 [inline]
>  nci_allocate_device+0x5c/0x170 net/nfc/nci/core.c:1143
>  virtual_ncidev_open+0x54/0xe0 drivers/nfc/virtual_ncidev.c:139
>  misc_open+0x124/0x170 drivers/char/misc.c:143
>  chrdev_open+0xc0/0x260 fs/char_dev.c:414
>  do_dentry_open+0x13c/0x4d0 fs/open.c:882
>  vfs_open+0x2c/0x40 fs/open.c:1013
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x568/0xee0 fs/namei.c:3713
>  do_filp_open+0x80/0x130 fs/namei.c:3740
>  do_sys_openat2+0xb4/0x16c fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_sys_openat fs/open.c:1342 [inline]
>  __se_sys_openat fs/open.c:1337 [inline]
>  __arm64_sys_openat+0x64/0xb0 fs/open.c:1337
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:52
>  el0_svc_common.constprop.0+0x44/0xec arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x2c/0xd0 arch/arm64/kernel/syscall.c:206
>  el0_svc+0x2c/0xb0 arch/arm64/kernel/entry-common.c:637
>  el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
>
> Freed by task 20952:
>  kasan_save_stack+0x2c/0x60 mm/kasan/common.c:45
>  save_stack_info+0x38/0x130 mm/kasan/tags.c:104
>  kasan_save_free_info+0x18/0x30 mm/kasan/tags.c:143
>  ____kasan_slab_free.constprop.0+0x1b8/0x230 mm/kasan/common.c:236
>  __kasan_slab_free+0x10/0x1c mm/kasan/common.c:244
>  kasan_slab_free include/linux/kasan.h:177 [inline]
>  slab_free_hook mm/slub.c:1724 [inline]
>  slab_free_freelist_hook+0xbc/0x1fc mm/slub.c:1750
>  slab_free mm/slub.c:3661 [inline]
>  __kmem_cache_free+0x16c/0x2ec mm/slub.c:3674
>  kfree+0x60/0xb0 mm/slab_common.c:1007
>  nci_free_device+0x30/0x40 net/nfc/nci/core.c:1205
>  virtual_ncidev_close+0x74/0x80 drivers/nfc/virtual_ncidev.c:167
>  __fput+0x78/0x260 fs/file_table.c:320
>  ____fput+0x10/0x20 fs/file_table.c:348
>  task_work_run+0x80/0xe0 kernel/task_work.c:179
>  get_signal+0xc8/0x7a4 kernel/signal.c:2635
>  do_signal arch/arm64/kernel/signal.c:1071 [inline]
>  do_notify_resume+0x178/0x13b0 arch/arm64/kernel/signal.c:1124
>  prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>  exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>  el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
>  el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
>
> The buggy address belongs to the object at ffff000024df6000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 88 bytes inside of
>  2048-byte region [ffff000024df6000, ffff000024df6800)
>
> The buggy address belongs to the physical page:
> page:00000000909ac9e4 refcount:1 mapcount:0 mapping:0000000000000000 index:0xf9ff000024df6000 pfn:0x64df0
> head:00000000909ac9e4 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x1ffc00000010200(slab|head|node=0|zone=0|lastcpupid=0x7ff|kasantag=0x0)
> raw: 01ffc00000010200 0000000000000000 dead000000000122 fdff000002c01600
> raw: f9ff000024df6000 000000008010000d 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff000024df5e00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>  ffff000024df5f00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
> >ffff000024df6000: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>                                   ^
>  ffff000024df6100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>  ffff000024df6200: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
> ==================================================================
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B              6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001824 x12: 000000000000080c
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 00000000000018a8 x12: 0000000000000838
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 000000000000192c x12: 0000000000000864
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 00000000000019b0 x12: 0000000000000890
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001a34 x12: 00000000000008bc
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001ab8 x12: 00000000000008e8
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001b3c x12: 0000000000000914
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001bc0 x12: 0000000000000940
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001c44 x12: 000000000000096c
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001cc8 x12: 0000000000000998
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> __do_kernel_fault: 72220 callbacks suppressed
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001d4f x12: 00000000000009c5
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001dd3 x12: 00000000000009f1
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001e57 x12: 0000000000000a1d
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001edb x12: 0000000000000a49
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001f5f x12: 0000000000000a75
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000001fe3 x12: 0000000000000aa1
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 0000000000002067 x12: 0000000000000acd
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 00000000000020eb x12: 0000000000000af9
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 000000000000216f x12: 0000000000000b25
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 00000000000021f3 x12: 0000000000000b51
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : ffff00007fbcba10 x4 : 0000000000000000 x3 : ffff80007592d000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0xcc/0xf4 kernel/softirq.c:650
>  irq_exit_rcu+0x10/0x20 kernel/softirq.c:662
>  el0_interrupt+0x54/0x104 arch/arm64/kernel/entry-common.c:717
>  __el0_irq_handler_common+0x18/0x2c arch/arm64/kernel/entry-common.c:724
>  el0t_64_irq_handler+0x10/0x20 arch/arm64/kernel/entry-common.c:729
>  el0t_64_irq+0x198/0x19c arch/arm64/kernel/entry.S:582
> ---[ end trace 0000000000000000 ]---
> __do_kernel_fault: 73126 callbacks suppressed
> ------------[ cut here ]------------
> Ignoring spurious kernel translation fault at virtual address ffff80007592d000
> WARNING: CPU: 1 PID: 2256 at arch/arm64/mm/fault.c:369 __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> Modules linked in:
> CPU: 1 PID: 2256 Comm: syz-fuzzer Tainted: G    B   W          6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> lr : __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
> sp : ffff80000800bbc0
> x29: ffff80000800bbc0 x28: f3ff000004672f40 x27: 0000000000000008
> x26: ffff80000a29c008 x25: ffff80000a2a2cc0 x24: ffff80000a2c3388
> x23: 00000000a04000c9 x22: 0000000000000025 x21: ffff80007592d000
> x20: ffff80000800bc80 x19: 0000000097c18005 x18: 00000000fffffffe
> x17: 6666207373657264 x16: 6461206c61757472 x15: 697620746120746c
> x14: ffff80000a2eda70 x13: 000000000000227d x12: 0000000000000b7f
> x11: 2073736572646461 x10: ffff80000a39da70 x9 : 00000000ffffe000
> x8 : ffff80000a2eda70 x7 : ffff80000a39da70 x6 : 0000000000000000
> x5 : 0000000000017ff4 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : f3ff000004672f40
> Call trace:
>  __do_kernel_fault+0x1ac/0x1e0 arch/arm64/mm/fault.c:369
>  do_bad_area arch/arm64/mm/fault.c:473 [inline]
>  do_translation_fault+0x50/0xc0 arch/arm64/mm/fault.c:691
>  do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
>  el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
>  el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
>  el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
>  get_work_pool kernel/workqueue.c:741 [inline]
>  __queue_work+0xf4/0x4a0 kernel/workqueue.c:1458
>  queue_work_on+0x6c/0x90 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  nci_cmd_timer+0x28/0x34 net/nfc/nci/core.c:615
>  call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
>  expire_timers+0x98/0xc4 kernel/time/timer.c:1519
>  __run_timers kernel/time/timer.c:1790 [inline]
>  __run_timers kernel/time/timer.c:1763 [inline]
>  run_timer_softirq+0xf4/0x254 kernel/time/timer.c:1803
>  _stext+0x124/0x2a4
>  ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
>  call_on_irq_stack+0x2c/0x5c arch/arm64/kernel/entry.S:889
>  do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
>  invoke_softirq kernel/softirq.c:452 [inline]
>  __irq_exit_rcu+0x
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000dfcce005ed7c6c0b%40google.com.
