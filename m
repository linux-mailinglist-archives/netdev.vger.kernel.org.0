Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC51191692
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgCXQgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:36:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47208 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727729AbgCXQgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585067809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G553MgXkjqfxAFOL182eCN5QdN4xVvwAKYveEs0gbDE=;
        b=g/o645wQrFDU2CBGMjsRNb15AxQxF2cX03Me6o6oeUe6Ejf8cosfu88VU+5xe7XMKxhjuI
        Vgdtd6Lm8CRtZ/fpgPQpW1LySduxej1+C0OLe2JN2LRLGrBST9ENcKpXQ32CI2cBkwQ3+h
        8XEs2G71kUNm2RA9WNiTCjVKPKTdvXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-o0F8ons0PTWIF5xLx4AZQQ-1; Tue, 24 Mar 2020 12:36:43 -0400
X-MC-Unique: o0F8ons0PTWIF5xLx4AZQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B986189D6C3;
        Tue, 24 Mar 2020 16:36:42 +0000 (UTC)
Received: from treble (unknown [10.10.119.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C89A95D9C5;
        Tue, 24 Mar 2020 16:36:40 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:36:38 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     syzbot <syzbot+f658387c977d467d9ec8@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org,
        shile.zhang@linux.alibaba.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org, netdev@vger.kernel.org
Subject: Re: BUG: stack guard page was hit in match_held_lock
Message-ID: <20200324163638.4avmqulots6x5rcb@treble>
References: <000000000000a4101c05a194dc8f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000a4101c05a194dc8f@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:40:12AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    cd607737 Merge tag '5.6-rc6-smb3-fixes' of git://git.samba..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14c1e139e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
> dashboard link: https://syzkaller.appspot.com/bug?extid=f658387c977d467d9ec8
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f658387c977d467d9ec8@syzkaller.appspotmail.com

This is the same as an earlier reported syzbot bug:

#syz dup: BUG: stack guard page was hit in deref_stack_reg

It's an apparent recursive loop in networking code.

> IPv6: ADDRCONF(NETDEV_CHANGE): vcan0: link becomes ready
> BUG: stack guard page was hit at 0000000018b957a1 (stack is 00000000956fd9c5..00000000246b71b0)
> kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 25649 Comm: syz-executor.5 Not tainted 5.6.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:match_held_lock+0xe/0x500 kernel/locking/lockdep.c:4012
> Code: 78 05 48 83 c4 08 c3 89 c7 89 44 24 04 e8 ca e6 ff ff 8b 44 24 04 48 83 c4 08 c3 90 48 b8 00 00 00 00 00 fc ff df 41 56 41 55 <41> 54 55 53 48 89 fb 48 83 c7 10 48 89 fa 48 83 ec 08 48 c1 ea 03
> RSP: 0018:ffffc90001420000 EFLAGS: 00010002
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88805adcac18 RSI: ffffffff897acc40 RDI: ffff88805adcac18
> RBP: ffff88805adca380 R08: ffff88805adca380 R09: ffffed1015ce7074
> R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: ffffed100b5b9582
> R13: ffff88805adcac18 R14: ffff88805adcac10 R15: ffffffff897acc40
> FS:  00007f3afe959700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc9000141fff8 CR3: 00000000a7ab3000 CR4: 00000000001426e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __lock_is_held kernel/locking/lockdep.c:4305 [inline]
>  lock_is_held_type+0x1a9/0x310 kernel/locking/lockdep.c:4521
>  lock_is_held include/linux/lockdep.h:361 [inline]
>  rcu_read_lock_sched_held+0x9c/0xd0 kernel/rcu/update.c:121
>  trace_rcu_utilization include/trace/events/rcu.h:27 [inline]
>  trace_rcu_utilization include/trace/events/rcu.h:27 [inline]
>  rcu_note_context_switch+0x104a/0x18f0 kernel/rcu/tree_plugin.h:291
>  __schedule+0x22a/0x1f90 kernel/sched/core.c:4018
>  preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:4235
>  ___preempt_schedule+0x16/0x18 arch/x86/entry/thunk_64.S:50
>  unwind_next_frame+0xdd3/0x19d0 arch/x86/kernel/unwind_orc.c:572
>  arch_stack_walk+0x74/0xd0 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  __kasan_kmalloc mm/kasan/common.c:515 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
>  kmem_cache_alloc_node_trace+0x161/0x790 mm/slab.c:3595
>  __do_kmalloc_node mm/slab.c:3615 [inline]
>  __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3630
>  __kmalloc_reserve.isra.0+0x39/0xe0 net/core/skbuff.c:142
>  pskb_expand_head+0x148/0x1020 net/core/skbuff.c:1627
>  netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1285
>  netlink_broadcast_filtered+0x5f/0xd40 net/netlink/af_netlink.c:1490
>  netlink_broadcast net/netlink/af_netlink.c:1535 [inline]
>  nlmsg_multicast include/net/netlink.h:968 [inline]
>  nlmsg_notify+0x90/0x250 net/netlink/af_netlink.c:2521
>  rtnl_notify net/core/rtnetlink.c:737 [inline]
>  rtmsg_ifinfo_send net/core/rtnetlink.c:3705 [inline]
>  rtmsg_ifinfo_event.part.0+0xb6/0xe0 net/core/rtnetlink.c:3720
>  rtmsg_ifinfo_event net/core/rtnetlink.c:5494 [inline]
>  rtnetlink_event+0x11e/0x150 net/core/rtnetlink.c:5487
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9099
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9083 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9080
>  netdev_sync_lower_features net/core/dev.c:8892 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9027
>  netdev_update_features+0x63/0xd0 net/core/dev.c:9082
>  dev_disable_lro+0x45/0x320 net/core/dev.c:1592
>  generic_xdp_install+0x23f/0x490 net/core/dev.c:5352
>  dev_xdp_install+0x203/0x250 net/core/dev.c:8615
>  dev_change_xdp_fd+0x2e1/0x600 net/core/dev.c:8722
>  do_setlink+0x2d4b/0x35e0 net/core/rtnetlink.c:2802
>  rtnl_group_changelink net/core/rtnetlink.c:3103 [inline]
>  __rtnl_newlink+0xc96/0x1590 net/core/rtnetlink.c:3257
>  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
>  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5436
>  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
>  __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45c849
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f3afe958c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f3afe9596d4 RCX: 000000000045c849
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
> RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000009f8 R14: 00000000004ccb00 R15: 000000000076bf0c
> Modules linked in:
> ---[ end trace a83229d339349b9e ]---
> RIP: 0010:match_held_lock+0xe/0x500 kernel/locking/lockdep.c:4012
> Code: 78 05 48 83 c4 08 c3 89 c7 89 44 24 04 e8 ca e6 ff ff 8b 44 24 04 48 83 c4 08 c3 90 48 b8 00 00 00 00 00 fc ff df 41 56 41 55 <41> 54 55 53 48 89 fb 48 83 c7 10 48 89 fa 48 83 ec 08 48 c1 ea 03
> RSP: 0018:ffffc90001420000 EFLAGS: 00010002
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88805adcac18 RSI: ffffffff897acc40 RDI: ffff88805adcac18
> RBP: ffff88805adca380 R08: ffff88805adca380 R09: ffffed1015ce7074
> R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: ffffed100b5b9582
> R13: ffff88805adcac18 R14: ffff88805adcac10 R15: ffffffff897acc40
> FS:  00007f3afe959700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc9000141fff8 CR3: 00000000a7ab3000 CR4: 00000000001426e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

-- 
Josh

