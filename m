Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FBEBD458
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 23:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbfIXV3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 17:29:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35378 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbfIXV3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 17:29:13 -0400
Received: by mail-io1-f70.google.com with SMTP id r5so5299658iop.2
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 14:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mS845iILd2BseKwn2omvPzHxzOiYhHBoI9CSHpIk/Rk=;
        b=RJhWGiR0W0GY8MWe7UXWpoko/20QMnA01mz1N3Mdrf7r1QYh2ultMGz25t5aZgoYnR
         WRK+FNtzugNqgixnksx33eZ3/onZqy51GNSF4iiNwAkN3m7P8ZEyKI9ta8MvnUfUEyha
         aPUeT7EU54in2bfsAhUuj5zk+vlysQTm40mN0akLOYBV2wRgY5tyd9zFNqEUbwDW8XAC
         BBBTN9xn6cCiFO5ELePecELKfu0lLItwUzcDaen4vdxkN9ef6a8JYqz6fwNr3LBq4cY2
         ZvnmYAUlCUbEOAI2eGW2Sgbs5dw2GRAAHDiyeav2dKwEiaiqlWOVQcYc8/uAN6Fu/+2R
         2A8g==
X-Gm-Message-State: APjAAAXL6GaUmVcxsx1eUTu1XSp1ifdm3PA5kUtgPjT9Cchie2Dlwq34
        uHD2NEokJP03yKh0bNBJ1s7NiJEishJb8BwL3/Sm5YNOSvv/
X-Google-Smtp-Source: APXvYqy1GcvgrKf5bcUIFo92L39a7t8pfjpMNGfFfpE2TaUD3xKk50O26lreHGYluOFoMULqiOXTMTEsdDtgCawv7B3O0+Rbc4GL
MIME-Version: 1.0
X-Received: by 2002:a6b:7a06:: with SMTP id h6mr5123580iom.231.1569360548967;
 Tue, 24 Sep 2019 14:29:08 -0700 (PDT)
Date:   Tue, 24 Sep 2019 14:29:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000bf1e50593533a38@google.com>
Subject: memory leak in copy_net_ns
From:   syzbot <syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com>
To:     a.p.zijlstra@chello.nl, acme@redhat.com, andi@firstfloor.org,
        davem@davemloft.net, dhowells@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        jolsa@kernel.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, syzkaller-bugs@googlegroups.com,
        tyhicks@canonical.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5ad18b2e Merge branch 'siginfo-linus' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1239e6a0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=13fb75d3ba8bfd9
dashboard link: https://syzkaller.appspot.com/bug?extid=3b3296d032353c33184b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116c6a87a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14587d10600000

The bug was bisected to:

commit 195bc0f8443d8d564ae95d2e9c19ac0edfd647c3
Author: Namhyung Kim <namhyung@kernel.org>
Date:   Tue Sep 13 07:45:50 2016 +0000

     perf ui/stdio: Rename print_hierarchy_header()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16162df0600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15162df0600000
console output: https://syzkaller.appspot.com/x/log.txt?x=11162df0600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com
Fixes: 195bc0f8443d ("perf ui/stdio: Rename print_hierarchy_header()")

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.400s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.390s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.220s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.220s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.470s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.460s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.290s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.290s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.550s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.540s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.370s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.370s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.620s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.610s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.440s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.440s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.690s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.680s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.510s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.510s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.760s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.750s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.580s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.580s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.840s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.830s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.660s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.660s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
   comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.910s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811cfb2080 (size 96):
   comm "syz-executor902", pid 7069, jiffies 4294944351 (age 28.900s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 4d bc 82 ff ff ff ff  ........PM......
     00 00 00 00 00 00 00 00 00 39 bc 82 ff ff ff ff  .........9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740

BUG: memory leak
unreferenced object 0xffff888115e047c0 (size 32):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.730s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000a83ed741>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
     [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
     [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ccd4e80 (size 96):
   comm "syz-executor902", pid 7079, jiffies 4294944368 (age 28.730s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 c0 4d bc 82 ff ff ff ff  .........M......
     00 00 00 00 00 00 00 00 70 39 bc 82 ff ff ff ff  ........p9......
   backtrace:
     [<00000000b0b6ab9a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b0b6ab9a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b0b6ab9a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b0b6ab9a>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000f96917f7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000f96917f7>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000032c54692>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000032c54692>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000cdbb5464>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000cdbb5464>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000cdbb5464>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000ca33d229>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000003b071c4d>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d9c14042>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<000000004119a586>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000004957a648>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<0000000044bb7165>] ops_init+0x4c/0x160 net/core/net_namespace.c:137
     [<000000002d8e331b>] setup_net+0xde/0x230 net/core/net_namespace.c:323
     [<000000003547ad16>] copy_net_ns+0x123/0x220  
net/core/net_namespace.c:458
     [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
     [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
     [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
     [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
