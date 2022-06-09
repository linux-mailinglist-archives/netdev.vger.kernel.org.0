Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2853F5447E9
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 11:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiFIJq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 05:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiFIJq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 05:46:27 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB0856391
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 02:46:24 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id e4-20020a056e020b2400b002d5509de6f3so5750169ilu.6
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 02:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=r2ZANtXKLgBrw9cLEi+ELcc0/5/2TOY51e/Gy+cG/H0=;
        b=GFsdpvIJ1o86f14LohdlZvxhRj05Vz3QxVMOE+sv0FjOTLfMZK5uAMhw3M8IkVyPHh
         XS56rmt7MvnZn+TY1j8sII4eLSa/f8mZWOrkNr6BosqKL0yIid2t4vDMiETzmBxlZuMh
         M4dJHZtIcfuX5EwVsfOMZD0p03NKUU2ifqAkNL8yD1OIRlgBYJWkgJYet4JMuKZ3U5pH
         XmpW33QIJCB3qohFf9c9JGz6r9+SykHDlVuYbhPfXm+7E4FVb/A4WTkjKKd0O5poQ7gL
         OJRUVHZurgVPBoDXB02c+iwocXG9tepk9+EK3gslPLZh3v1mLy7AkJjlKxWW4Z8LLHlm
         aJ8A==
X-Gm-Message-State: AOAM532cAhFoG91Z8euiZFC3ooVEQusXUjUyVhSWcwI1NmEdnQU8W5Jd
        KpwRQMf+Grg4rhkbbDoCZ4CJPYj53z0N/P+kT97fWrVhhDrA
X-Google-Smtp-Source: ABdhPJxn6q7R+ohxU+dNdGZR5NB51lBehJ62x9SsyJFrWCxCo28nxIc5rpgXgAarGEQMaDfakK35ezm+dHCNS/NYIbzX227vMQlo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c45:b0:2d3:bb0c:9559 with SMTP id
 d5-20020a056e021c4500b002d3bb0c9559mr22449974ilg.251.1654767983465; Thu, 09
 Jun 2022 02:46:23 -0700 (PDT)
Date:   Thu, 09 Jun 2022 02:46:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d71bc505e100b156@google.com>
Subject: [syzbot] BUG: stack guard page was hit in sys_bpf
From:   syzbot <syzbot+71b84016750069c7f146@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, idosch@nvidia.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f2906aa86338 Linux 5.19-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1117c8e3f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd131cc02ee620e
dashboard link: https://syzkaller.appspot.com/bug?extid=71b84016750069c7f146
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+71b84016750069c7f146@syzkaller.appspotmail.com

BUG: TASK stack guard page was hit at ffffc90009087fc8 (stack is ffffc90009088000..ffffc90009090000)
stack guard page: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 7417 Comm: syz-executor.0 Not tainted 5.19.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4591
Code: 00 00 00 90 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
RSP: 0018:ffffc90009087fd8 EFLAGS: 00010096
RAX: 000000000000000c RBX: ffffc90009088010 RCX: ffffffff815d25a2
RDX: dffffc0000000000 RSI: ffff88808a43cbc8 RDI: ffff88808a43c140
RBP: ffff88808a43cbea R08: 0000000000000000 R09: ffffffff906788cf
R10: fffffbfff20cf119 R11: 0000000000000001 R12: ffff88808a43cbc8
R13: 0000000000000008 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fc65d3f6700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009087fc8 CR3: 000000008f816000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000004 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mark_lock kernel/locking/lockdep.c:4596 [inline]
 mark_usage kernel/locking/lockdep.c:4553 [inline]
 __lock_acquire+0x8ab/0x5660 kernel/locking/lockdep.c:5007
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 local_lock_acquire include/linux/local_lock_internal.h:29 [inline]
 rmqueue_pcplist mm/page_alloc.c:3692 [inline]
 rmqueue mm/page_alloc.c:3730 [inline]
 get_page_from_freelist+0x4bf/0x3b70 mm/page_alloc.c:4195
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 kmem_getpages mm/slab.c:1363 [inline]
 cache_grow_begin+0x75/0x350 mm/slab.c:2569
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2942
 ____cache_alloc mm/slab.c:3024 [inline]
 ____cache_alloc mm/slab.c:3007 [inline]
 slab_alloc_node mm/slab.c:3227 [inline]
 kmem_cache_alloc_node_trace+0x518/0x5b0 mm/slab.c:3611
 __do_kmalloc_node mm/slab.c:3633 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3648
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1426 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3904
 rtmsg_ifinfo_event net/core/rtnetlink.c:3940 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3931 [inline]
 rtnetlink_event+0x123/0x1d0 net/core/rtnetlink.c:6140
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_change_features+0x61/0xb0 net/core/dev.c:9798
 team_compute_features drivers/net/team/team.c:1031 [inline]
 team_device_event+0x83a/0xa90 drivers/net/team/team.c:3012
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 netdev_features_change net/core/dev.c:1313 [inline]
 netdev_sync_lower_features net/core/dev.c:9574 [inline]
 __netdev_update_features+0xa42/0x1980 net/core/dev.c:9726
 netdev_update_features net/core/dev.c:9781 [inline]
 dev_disable_lro+0x8d/0x3e0 net/core/dev.c:1586
 generic_xdp_install+0x218/0x4a0 net/core/dev.c:5643
 dev_xdp_install+0xd5/0x2b0 net/core/dev.c:9101
 dev_xdp_attach+0xa30/0x12b0 net/core/dev.c:9249
 dev_xdp_attach_link net/core/dev.c:9268 [inline]
 bpf_xdp_link_attach+0x26d/0x430 net/core/dev.c:9437
 link_create kernel/bpf/syscall.c:4554 [inline]
 __sys_bpf+0x4dc6/0x5700 kernel/bpf/syscall.c:4987
 __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5019
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fc65c289109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc65d3f6168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fc65c39c2a0 RCX: 00007fc65c289109
RDX: 0000000000000010 RSI: 0000000020000880 RDI: 000000000000001c
RBP: 00007fc65c2e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc170a891f R14: 00007fc65d3f6300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4591
Code: 00 00 00 90 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
RSP: 0018:ffffc90009087fd8 EFLAGS: 00010096
RAX: 000000000000000c RBX: ffffc90009088010 RCX: ffffffff815d25a2
RDX: dffffc0000000000 RSI: ffff88808a43cbc8 RDI: ffff88808a43c140
RBP: ffff88808a43cbea R08: 0000000000000000 R09: ffffffff906788cf
R10: fffffbfff20cf119 R11: 0000000000000001 R12: ffff88808a43cbc8
R13: 0000000000000008 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fc65d3f6700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009087fc8 CR3: 000000008f816000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000004 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 90 41 57 41 56    	add    %dl,0x56415741(%rax)
   8:	41 55                	push   %r13
   a:	41 89 d5             	mov    %edx,%r13d
   d:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  14:	fc ff df
  17:	41 54                	push   %r12
  19:	49 89 f4             	mov    %rsi,%r12
  1c:	55                   	push   %rbp
  1d:	53                   	push   %rbx
  1e:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  25:	48 8d 5c 24 38       	lea    0x38(%rsp),%rbx
* 2a:	48 89 3c 24          	mov    %rdi,(%rsp) <-- trapping instruction
  2e:	48 c7 44 24 38 b3 8a 	movq   $0x41b58ab3,0x38(%rsp)
  35:	b5 41
  37:	48 c1 eb 03          	shr    $0x3,%rbx
  3b:	48                   	rex.W
  3c:	c7                   	.byte 0xc7
  3d:	44 24 40             	rex.R and $0x40,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
