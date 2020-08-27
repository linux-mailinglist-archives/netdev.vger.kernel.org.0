Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C85253D50
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 07:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgH0FpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 01:45:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51617 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgH0FpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 01:45:17 -0400
Received: by mail-io1-f71.google.com with SMTP id g6so2937003ioc.18
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 22:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AOnJK58KWAgjckYsBB0yMrRGuMXnsjy16cofVkiVrV0=;
        b=jxtIiyome9sBOmM5BpLe1YfMvEgkNus1Wi5l9xp/Juevnh0jTRNdD4RliUuFzevpV6
         7d7VCxY4DMXXKB7KhDSsTfGWVrfZl40YcXi58ES6aToQlWvRxE8QMd7hzn51f0ydxYp/
         i0oX4N4AfRK4xjYWZwxyYX3FzustoWqn5wb64SYdLImcl0w/UthX4q82CBDrUIr81Bun
         2U/42rIo+ksBfKIL6X8Xdn99a2uQSRTSUGPmR6T2vAbuJ6v2uGWMjROEQZCNnV66TPRn
         tcwyR7tTKGS6J2coofPgYGQC45mPn4k5SUTIT78dOXFQI3CpbnE70Rx7iArHX12zJQZs
         Rkiw==
X-Gm-Message-State: AOAM530asmORfqmD9TZg3AGW6ZaCYpx/P/vEtNS5ThWu/T6JmOE2rwXL
        mnjnIbdi46eYRhuxmoIMs30R6bgKt7PKdyiq55qdcjoDGdNO
X-Google-Smtp-Source: ABdhPJxVMcCYi0n2+hu7wGOwaonrfV3/g00xVzHNfTVQoH598Vl+9+Fsj+Bky7V9IUFN4v3+QRE+q7R2RWPfZiXwmddgVt6jiWhW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c71:: with SMTP id f17mr15347923ilj.98.1598507115751;
 Wed, 26 Aug 2020 22:45:15 -0700 (PDT)
Date:   Wed, 26 Aug 2020 22:45:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce2f6d05add5705a@google.com>
Subject: BUG: stack guard page was hit in __zone_watermark_ok
From:   syzbot <syzbot+144d1f35995353c5779c@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jiri@mellanox.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    85eb5bc3 net: atheros: switch from 'pci_' to 'dma_' API
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14e32139900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=144d1f35995353c5779c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+144d1f35995353c5779c@syzkaller.appspotmail.com

BUG: stack guard page was hit at 00000000b2f481cf (stack is 000000009cbf9546..0000000099742d14)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 29993 Comm: syz-executor.4 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:instrument_atomic_read include/linux/instrumented.h:56 [inline]
RIP: 0010:atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
RIP: 0010:atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
RIP: 0010:zone_page_state include/linux/vmstat.h:217 [inline]
RIP: 0010:__zone_watermark_unusable_free mm/page_alloc.c:3508 [inline]
RIP: 0010:__zone_watermark_ok+0x23f/0x3f0 mm/page_alloc.c:3529
Code: c4 28 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8d bc 24 98 06 00 00 be 08 00 00 00 4c 89 4c 24 20 4c 89 54 24 18 89 54 24 10 <4c> 89 44 24 08 48 89 3c 24 e8 33 78 08 00 48 8b 3c 24 48 b8 00 00
RSP: 0018:ffffc900169f7ff0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88812fffc498
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88812fffbe00
R13: 0000000000000040 R14: 0000000000000002 R15: 0000000000000000
FS:  00007f98bc4db700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900169f7fe8 CR3: 00000002063a9000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 zone_watermark_fast mm/page_alloc.c:3612 [inline]
 get_page_from_freelist+0x102f/0x37f0 mm/page_alloc.c:3785
 __alloc_pages_slowpath.constprop.0+0x322/0x2860 mm/page_alloc.c:4592
 __alloc_pages_nodemask+0x62c/0x790 mm/page_alloc.c:4901
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 kmem_getpages mm/slab.c:1376 [inline]
 cache_grow_begin+0x71/0x430 mm/slab.c:2590
 cache_alloc_refill+0x27b/0x340 mm/slab.c:2962
 ____cache_alloc mm/slab.c:3045 [inline]
 ____cache_alloc mm/slab.c:3028 [inline]
 slab_alloc_node mm/slab.c:3241 [inline]
 kmem_cache_alloc_node_trace+0x3de/0x400 mm/slab.c:3592
 __do_kmalloc_node mm/slab.c:3614 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3629
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1085 [inline]
 nlmsg_new include/net/netlink.h:944 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3804
 rtmsg_ifinfo_event net/core/rtnetlink.c:3840 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3831 [inline]
 rtnetlink_event+0x123/0x1d0 net/core/rtnetlink.c:5614
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
 bond_compute_features+0x562/0xa80 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x871/0xb80 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9371 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9502
 netdev_change_features+0x61/0xb0 net/core/dev.c:9574
Lost 504 message(s)!
---[ end trace 99fc362a1b5e94a8 ]---
RIP: 0010:instrument_atomic_read include/linux/instrumented.h:56 [inline]
RIP: 0010:atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
RIP: 0010:atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
RIP: 0010:zone_page_state include/linux/vmstat.h:217 [inline]
RIP: 0010:__zone_watermark_unusable_free mm/page_alloc.c:3508 [inline]
RIP: 0010:__zone_watermark_ok+0x23f/0x3f0 mm/page_alloc.c:3529
Code: c4 28 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8d bc 24 98 06 00 00 be 08 00 00 00 4c 89 4c 24 20 4c 89 54 24 18 89 54 24 10 <4c> 89 44 24 08 48 89 3c 24 e8 33 78 08 00 48 8b 3c 24 48 b8 00 00
RSP: 0018:ffffc900169f7ff0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88812fffc498
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88812fffbe00
R13: 0000000000000040 R14: 0000000000000002 R15: 0000000000000000
FS:  00007f98bc4db700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900169f7fe8 CR3: 00000002063a9000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
