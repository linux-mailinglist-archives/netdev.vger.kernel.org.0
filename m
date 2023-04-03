Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758BA6D3CCE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 07:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjDCFWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 01:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjDCFWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 01:22:50 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B529C179
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 22:22:47 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x17so36476020lfu.5
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 22:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680499365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M7PS34rsXi89NUFznKPRDudlqNiFzosjAF97dG2rfiI=;
        b=TofFXGwydmBbP3pjCLS+d7hnhi+dhEFLHklk6VVEPDJ5GzaZliDOyws6zr4DPa/WAv
         SYxgeJUj+V4qsihZ90Nav5OWmrpuOUrFmnl0rpMOmPA9GLo2Io9S/OEwKoBtskhHhxWi
         jblNfJWA0d+cSNKaPTeQcoEpPBTdAhEwPtmPZ/zexzUA4ipkTwgZNzFbEuMx++yijUs0
         /3D+6rWIbXVvyWz2lXFsWADJtVRcqCIiMBT/mq9T+ITWbTmHBZ2uvbxPOe9Rp6aBepKM
         XlMrsNxb4b8vFoyy13AAEzbCeKgI99lUMdyYsKm/JC+EiLIMg5B4DuZCCMXT3AizcgBj
         4yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680499365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M7PS34rsXi89NUFznKPRDudlqNiFzosjAF97dG2rfiI=;
        b=4uSBKmHketDdE32P4rBLS13uVbj/tVzofPuLQxyhY9dIYSm4XBh2OaLWfmcXvYZxVL
         p7z0CBeRMbUaVJnKkEXcF9IRqfHcJvbEOJTLFLZVnsxsudKZfDH21HUWKYBVLJrxdgGQ
         9oLgnvdtRtnD65HVBn238IWeGQgSCGvGneoM9POiar0igwTrZpKHhJMtFsETbdXLSkp0
         1Yf6igItCcr1QGcoD2iS5PvB7nxcee56io2xWA41OSDUjdG50xEEqx+cg6Lo0cT6YRa4
         DxV60KLw7pfhLQt00/75pRbBm0JNWc+MDNQXK/gKNb2IjTqpX43hXiCjyNjvyA/0lyZI
         lmOQ==
X-Gm-Message-State: AAQBX9dJ8zragWD/LuVlEsuZu8iRg3jVg+Yb8Erqj+U91kwyLI6d4+yt
        EvxvotKwAcEqDateDlXyce4iuaNHF/BbTjAg4jAd3A==
X-Google-Smtp-Source: AKy350aPh+Wp3Y1Xswr7yzvyL3xo4BMbcovbxaN9WClCdyg/PDF9zvXUYDHb/QV6SxTdiWpljLSInEhI3wBABBy6eyQ=
X-Received: by 2002:ac2:5a5c:0:b0:4e8:46a1:21a7 with SMTP id
 r28-20020ac25a5c000000b004e846a121a7mr10335978lfn.6.1680499364660; Sun, 02
 Apr 2023 22:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000220dbf05f850c188@google.com>
In-Reply-To: <000000000000220dbf05f850c188@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 3 Apr 2023 07:22:31 +0200
Message-ID: <CACT4Y+a7g5vioot7=FyqX3xyNj7p4=V76-eRQHAgEzvphtPU3g@mail.gmail.com>
Subject: Re: [syzbot] [wireless?] KASAN: slab-use-after-free Read in is_dynamic_key
To:     syzbot <syzbot+c599a813ad1dab060558@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-13.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Apr 2023 at 03:56, syzbot
<syzbot+c599a813ad1dab060558@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a6d9e3034536 Add linux-next specific files for 20230330
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15955acdc80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aceb117f7924508e
> dashboard link: https://syzkaller.appspot.com/bug?extid=c599a813ad1dab060558
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ec1f900ea929/disk-a6d9e303.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/fabbf89c0d22/vmlinux-a6d9e303.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1ed05d6192fa/bzImage-a6d9e303.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c599a813ad1dab060558@syzkaller.appspotmail.com

#syz dup: KASAN: slab-use-after-free Read in class_register


> ==================================================================
> BUG: KASAN: slab-use-after-free in is_dynamic_key.part.0+0x1de/0x1f0 kernel/locking/lockdep.c:1264
> Read of size 8 at addr ffff888035beeb60 by task kworker/u4:9/5292
>
> CPU: 1 PID: 5292 Comm: kworker/u4:9 Not tainted 6.3.0-rc4-next-20230330-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
>  print_report mm/kasan/report.c:462 [inline]
>  kasan_report+0x11c/0x130 mm/kasan/report.c:572
>  is_dynamic_key.part.0+0x1de/0x1f0 kernel/locking/lockdep.c:1264
>  is_dynamic_key kernel/locking/lockdep.c:883 [inline]
>  register_lock_class+0xbe3/0x1120 kernel/locking/lockdep.c:1297
>  __lock_acquire+0x10a/0x5df0 kernel/locking/lockdep.c:4951
>  lock_acquire.part.0+0x11c/0x370 kernel/locking/lockdep.c:5691
>  __flush_workqueue+0x118/0x13a0 kernel/workqueue.c:2925
>  drain_workqueue+0x1c1/0x3e0 kernel/workqueue.c:3090
>  destroy_workqueue+0xc8/0x8e0 kernel/workqueue.c:4558
>  tipc_crypto_stop+0x4a4/0x510 net/tipc/crypto.c:1525
>  tipc_exit_net+0x8c/0x110 net/tipc/core.c:119
>  ops_exit_list+0xb0/0x170 net/core/net_namespace.c:170
>  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:614
>  process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
>  worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
>  kthread+0x33e/0x440 kernel/kthread.c:379
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
>
> Allocated by task 11762:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:374 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:333 [inline]
>  __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:680 [inline]
>  class_register+0x55/0x530 drivers/base/class.c:165
>  class_create+0x99/0x100 drivers/base/class.c:249
>  init_usb_class drivers/usb/core/file.c:91 [inline]
>  usb_register_dev+0x4e7/0x860 drivers/usb/core/file.c:179
>  usblp_probe+0xc91/0x16d0 drivers/usb/class/usblp.c:1208
>  usb_probe_interface+0x30f/0x960 drivers/usb/core/driver.c:396
>  call_driver_probe drivers/base/dd.c:579 [inline]
>  really_probe+0x240/0xca0 drivers/base/dd.c:658
>  __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:795
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:825
>  __device_attach_driver+0x1d4/0x2e0 drivers/base/dd.c:953
>  bus_for_each_drv+0x149/0x1d0 drivers/base/bus.c:457
>  __device_attach+0x1e4/0x4b0 drivers/base/dd.c:1025
>  bus_probe_device+0x17c/0x1c0 drivers/base/bus.c:532
>  device_add+0x11c4/0x1c50 drivers/base/core.c:3616
>  usb_set_configuration+0x10ee/0x1af0 drivers/usb/core/message.c:2171
>  usb_generic_driver_probe+0xcf/0x130 drivers/usb/core/generic.c:238
>  usb_probe_device+0xd8/0x2c0 drivers/usb/core/driver.c:293
>  call_driver_probe drivers/base/dd.c:579 [inline]
>  really_probe+0x240/0xca0 drivers/base/dd.c:658
>  __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:795
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:825
>  __device_attach_driver+0x1d4/0x2e0 drivers/base/dd.c:953
>  bus_for_each_drv+0x149/0x1d0 drivers/base/bus.c:457
>  __device_attach+0x1e4/0x4b0 drivers/base/dd.c:1025
>  bus_probe_device+0x17c/0x1c0 drivers/base/bus.c:532
>  device_add+0x11c4/0x1c50 drivers/base/core.c:3616
>  usb_new_device+0xcb2/0x19d0 drivers/usb/core/hub.c:2575
>  hub_port_connect drivers/usb/core/hub.c:5407 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5551 [inline]
>  port_event drivers/usb/core/hub.c:5711 [inline]
>  hub_event+0x2d9e/0x4e40 drivers/usb/core/hub.c:5793
>  process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
>  process_scheduled_works kernel/workqueue.c:2468 [inline]
>  worker_thread+0x881/0x10c0 kernel/workqueue.c:2554
>  kthread+0x33e/0x440 kernel/kthread.c:379
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>
> Freed by task 11762:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:162 [inline]
>  slab_free_hook mm/slub.c:1781 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>  slab_free mm/slub.c:3787 [inline]
>  __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3800
>  kobject_cleanup lib/kobject.c:683 [inline]
>  kobject_release lib/kobject.c:714 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x1c2/0x4d0 lib/kobject.c:731
>  kset_unregister+0x64/0x80 lib/kobject.c:880
>  class_destroy+0x3c/0x50 drivers/base/class.c:273
>  release_usb_class drivers/usb/core/file.c:108 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  destroy_usb_class drivers/usb/core/file.c:116 [inline]
>  usb_deregister_dev+0x274/0x320 drivers/usb/core/file.c:245
>  usblp_disconnect+0x4a/0x330 drivers/usb/class/usblp.c:1396
>  usb_unbind_interface+0x1dc/0x8e0 drivers/usb/core/driver.c:458
>  device_remove drivers/base/dd.c:569 [inline]
>  device_remove+0x11f/0x170 drivers/base/dd.c:561
>  __device_release_driver drivers/base/dd.c:1267 [inline]
>  device_release_driver_internal+0x443/0x610 drivers/base/dd.c:1290
>  bus_remove_device+0x22c/0x420 drivers/base/bus.c:574
>  device_del+0x48a/0xb80 drivers/base/core.c:3802
>  usb_disable_device+0x35a/0x7b0 drivers/usb/core/message.c:1420
>  usb_disconnect+0x2db/0x8a0 drivers/usb/core/hub.c:2238
>  hub_port_connect drivers/usb/core/hub.c:5246 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5551 [inline]
>  port_event drivers/usb/core/hub.c:5711 [inline]
>  hub_event+0x1fbf/0x4e40 drivers/usb/core/hub.c:5793
>  process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
>  worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
>  kthread+0x33e/0x440 kernel/kthread.c:379
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>
> Last potentially related work creation:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
>  insert_work+0x48/0x360 kernel/workqueue.c:1365
>  __queue_work+0x5c6/0xfb0 kernel/workqueue.c:1526
>  queue_work_on+0xf2/0x110 kernel/workqueue.c:1554
>  ops_exit_list+0xb0/0x170 net/core/net_namespace.c:170
>  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:614
>  process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
>  worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
>  kthread+0x33e/0x440 kernel/kthread.c:379
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>
> The buggy address belongs to the object at ffff888035bee800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 864 bytes inside of
>  freed 1024-byte region [ffff888035bee800, ffff888035beec00)
>
> The buggy address belongs to the physical page:
> page:ffffea0000d6fa00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888035bec800 pfn:0x35be8
> head:ffffea0000d6fa00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> page_type: 0xffffffff()
> raw: 00fff00000010200 ffff888012441dc0 ffffea0000d29810 ffffea00005faa10
> raw: ffff888035bec800 000000000010000c 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 11694, tgid 11684 (syz-executor.2), ts 1151559040316, free_ts 1151272040314
>  prep_new_page mm/page_alloc.c:1729 [inline]
>  get_page_from_freelist+0xf75/0x2aa0 mm/page_alloc.c:3493
>  __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4759
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2283
>  alloc_slab_page mm/slub.c:1851 [inline]
>  allocate_slab+0x28e/0x380 mm/slub.c:1998
>  new_slab mm/slub.c:2051 [inline]
>  ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>  __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
>  __slab_alloc_node mm/slub.c:3345 [inline]
>  slab_alloc_node mm/slub.c:3442 [inline]
>  __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3491
>  kmalloc_trace+0x26/0xe0 mm/slab_common.c:1057
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:680 [inline]
>  ip_vs_est_add_kthread+0x1bd/0x820 net/netfilter/ipvs/ip_vs_est.c:327
>  ip_vs_start_estimator+0x244/0x420 net/netfilter/ipvs/ip_vs_est.c:499
>  ip_vs_control_net_init_sysctl net/netfilter/ipvs/ip_vs_ctl.c:4380 [inline]
>  ip_vs_control_net_init+0x1426/0x19f0 net/netfilter/ipvs/ip_vs_ctl.c:4466
>  __ip_vs_init+0x21f/0x530 net/netfilter/ipvs/ip_vs_core.c:2310
>  ops_init+0xb9/0x6b0 net/core/net_namespace.c:136
>  setup_net+0x5d1/0xc50 net/core/net_namespace.c:339
>  copy_net_ns+0x4ee/0x8e0 net/core/net_namespace.c:491
>  create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1302 [inline]
>  free_unref_page_prepare+0x4d8/0xb80 mm/page_alloc.c:2555
>  free_unref_page+0x33/0x370 mm/page_alloc.c:2650
>  __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
>  qlink_free mm/kasan/quarantine.c:166 [inline]
>  qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
>  kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
>  __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
>  kasan_slab_alloc include/linux/kasan.h:186 [inline]
>  slab_post_alloc_hook mm/slab.h:711 [inline]
>  slab_alloc_node mm/slub.c:3452 [inline]
>  slab_alloc mm/slub.c:3460 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
>  kmem_cache_alloc+0x17c/0x3b0 mm/slub.c:3476
>  getname_flags.part.0+0x50/0x4f0 fs/namei.c:140
>  getname_flags+0x9e/0xe0 include/linux/audit.h:321
>  getname fs/namei.c:219 [inline]
>  __do_sys_symlinkat fs/namei.c:4440 [inline]
>  __se_sys_symlinkat fs/namei.c:4437 [inline]
>  __x64_sys_symlinkat+0x7b/0xc0 fs/namei.c:4437
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Memory state around the buggy address:
>  ffff888035beea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888035beea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888035beeb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                        ^
>  ffff888035beeb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888035beec00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
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
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000220dbf05f850c188%40google.com.
