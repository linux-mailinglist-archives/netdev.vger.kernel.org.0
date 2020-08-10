Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E82024111B
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgHJTnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:43:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:46759 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgHJTnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:43:21 -0400
Received: by mail-il1-f199.google.com with SMTP id q19so1845250ilt.13
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 12:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q4XIII4ItMpbZBzsWBaW2VSwY396GC2DVgIcctGOLrU=;
        b=iUjEV5ztgd5B2VguVR/FOr9ySd8/5qo2bIl1lb4bN9qTuR3qN9d6X7xD6CVqxo+oFF
         0fPwdORSHrzvHUfcjtxP643xw21peAvkAq9SZK8jva+WrtAvyQiylDWp40hjSY6IPLTu
         ABVOdnUk0uugyHH3dXdBkHJvPp9mQajsH56HGS9yNE1ZL67e2hZMKsZUG3v8vPowG8BP
         LWKTfI2mrJDuf54NcNHrDNdXV70C6p7o7UHKSLkN1SzdHiu+o4xfSGtEzRDOW82i2gsG
         al1e8E1HdAeme9xktra9hxwe2pW484NhicG6+8opCvUImwp4EOsKrt8WCQoOzuNYaLH0
         BxLQ==
X-Gm-Message-State: AOAM532yoJzqFdbOUG2pl+n5C12pBFjBfIszXRUjS/CKFMrjRENAde1m
        LsunYTP3KC5/eAbBYyuKhs509pHL8nD8ZwOoZ00u5laYLRVO
X-Google-Smtp-Source: ABdhPJwPDSuYqrNEe8RXJK2WYBpIz8io+vrJbPfo1AlwLBTNnLtomuag30JrTw6Yp+B4PMhmiukL//W+4cXSioC8QQeqGHhluEio
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1489:: with SMTP id j9mr22367452jak.22.1597088599174;
 Mon, 10 Aug 2020 12:43:19 -0700 (PDT)
Date:   Mon, 10 Aug 2020 12:43:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0f1b605ac8b2a65@google.com>
Subject: BUG: stack guard page was hit in rcu_note_context_switch
From:   syzbot <syzbot+b7383bdcbe7b621b3b5f@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15cd14c2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=b7383bdcbe7b621b3b5f
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b7383bdcbe7b621b3b5f@syzkaller.appspotmail.com

BUG: stack guard page was hit at 00000000fdb29373 (stack is 00000000034a8817..00000000d99cd0c0)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 21798 Comm: syz-executor.1 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_note_context_switch+0x18/0x1600 kernel/rcu/tree_plugin.h:290
Code: 24 e8 dc ce 51 00 48 8b 04 24 eb b0 66 0f 1f 44 00 00 41 57 41 56 41 55 41 54 41 89 fc 55 53 48 c7 c3 00 6c 03 00 48 83 ec 48 <e8> f3 03 87 06 48 ba 00 00 00 00 00 fc ff df 89 c0 48 8d 3c c5 40
RSP: 0018:ffffc9001b0c7ff8 EFLAGS: 00010092
RAX: 0000000000040000 RBX: 0000000000036c00 RCX: ffffc90004f39000
RDX: 0000000000040000 RSI: ffffffff87e9d95c RDI: 0000000000000001
RBP: ffffc9001b0c8148 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880ae735e00 R14: 0000000000035e00 R15: ffffc9001b0c8000
FS:  00007fc671103700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9001b0c7fe8 CR3: 000000002757a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __schedule+0x227/0x2210 kernel/sched/core.c:4120
 preempt_schedule_irq+0xb0/0x150 kernel/sched/core.c:4477
 idtentry_exit_cond_resched arch/x86/entry/common.c:663 [inline]
 idtentry_exit_cond_rcu+0xc0/0xf0 arch/x86/entry/common.c:710
 asm_sysvec_reschedule_ipi+0x12/0x20 arch/x86/include/asm/idtentry.h:590
RIP: 0010:__unwind_start+0x5/0x800 arch/x86/kernel/unwind_orc.c:629
Code: 18 e9 38 ef ff ff 4c 89 ff e8 47 e7 7f 00 e9 aa ee ff ff e8 4d e7 7f 00 e9 9b f3 ff ff 0f 1f 84 00 00 00 00 00 41 57 49 89 ff <41> 56 41 55 4d 8d 6f 28 41 54 49 89 d4 ba 60 00 00 00 55 48 89 f5
RSP: 0018:ffffc9001b0c8240 EFLAGS: 00000246
RAX: ffff88802c10c440 RBX: ffffffff8162c090 RCX: ffffc9001b0c82d8
RDX: 0000000000000000 RSI: ffff88802c10c440 RDI: ffffc9001b0c8250
RBP: ffffc9001b0c82d8 R08: ffffed1004cf4400 R09: ffffed1004cf4500
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc9001b0c8308
R13: 0000000000000000 R14: ffff88802c10c440 R15: ffffc9001b0c8250
 unwind_start arch/x86/include/asm/unwind.h:60 [inline]
 arch_stack_walk+0x5e/0xf0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc_node mm/slab.c:3263 [inline]
 kmem_cache_alloc_node_trace+0x140/0x400 mm/slab.c:3593
 __do_kmalloc_node mm/slab.c:3615 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3630
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 pskb_expand_head+0x15a/0x1040 net/core/skbuff.c:1627
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1285
 netlink_broadcast_filtered+0x65/0xdc0 net/netlink/af_netlink.c:1490
 netlink_broadcast net/netlink/af_netlink.c:1535 [inline]
 nlmsg_multicast include/net/netlink.h:1020 [inline]
 nlmsg_notify+0x90/0x250 net/netlink/af_netlink.c:2512
 rtnl_notify net/core/rtnetlink.c:737 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:3726 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3741 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3729 [inline]
 rtnetlink_event+0x193/0x1d0 net/core/rtnetlink.c:5512
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
 netdev_change_features+0x61/0xb0 net/core/dev.c:9259
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x860/0xab6 drivers/net/team/team.c:3006
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 netdev_features_change net/core/dev.c:1443 [inline]
 netdev_sync_lower_features net/core/dev.c:9056 [inline]
 __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
Lost 431 message(s)!
---[ end trace a6003a1c0105b7e9 ]---
RIP: 0010:rcu_note_context_switch+0x18/0x1600 kernel/rcu/tree_plugin.h:290
Code: 24 e8 dc ce 51 00 48 8b 04 24 eb b0 66 0f 1f 44 00 00 41 57 41 56 41 55 41 54 41 89 fc 55 53 48 c7 c3 00 6c 03 00 48 83 ec 48 <e8> f3 03 87 06 48 ba 00 00 00 00 00 fc ff df 89 c0 48 8d 3c c5 40
RSP: 0018:ffffc9001b0c7ff8 EFLAGS: 00010092
RAX: 0000000000040000 RBX: 0000000000036c00 RCX: ffffc90004f39000
RDX: 0000000000040000 RSI: ffffffff87e9d95c RDI: 0000000000000001
RBP: ffffc9001b0c8148 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880ae735e00 R14: 0000000000035e00 R15: ffffc9001b0c8000
FS:  00007fc671103700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9001b0c7fe8 CR3: 000000002757a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
