Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D82E8C1F
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 13:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbhACMZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 07:25:50 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55688 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbhACMZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 07:25:49 -0500
Received: by mail-il1-f197.google.com with SMTP id c13so25009865ilg.22
        for <netdev@vger.kernel.org>; Sun, 03 Jan 2021 04:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JxEz3J7WNF7qxaYqaA97oNHNmaRMGEICdOK6HDaJm9o=;
        b=CK72bwvxxFIvo3kPK8Ju6F9Xi3XW71XsjbXyb2HQSIuWSboRwC4GAudNcGy+9kDAwc
         3+2YeWDmQyGfE4mX2C8Wk+HlN7weJrTQGTGWVFCEr8qvYfc8m/N+cRDiotxJTF7RpMHI
         XNQF9ft3wgGlD7MmbX5r9S1Ez05TREidBsh+IJDkiVNvty2nCwgGBOPqpLUoSxsyf1lt
         p0gKNPaPIBjhC8T51M03yAeKKJ4Bp0ckQbRRcLzQV3xF90SArBagB3tZGLCF/AcVHayp
         SsQZyDxAOuks1ovEkmfNiltCSyCx3+z3RFKIXETWISq5bPZj2bITWC8xQG0tnCyPs3Rd
         c6JQ==
X-Gm-Message-State: AOAM533eKf3JpyE3Mswn0/qkLYael0W9rTuSZ7l1feQvTuuLIeBPOwNX
        AllJBnibs4ayq4Qk1oTisbcxn85epqqzA81HvwDPKkfzx4dA
X-Google-Smtp-Source: ABdhPJxuhij1mXWX6SaVE1qPSswEztaBOVWeUdNATOSIwg7mTtE8cmeFth+tSnyZo+G5g3URDPQAxYtOeKNxyIDZsdpgBvQHrnQJ
MIME-Version: 1.0
X-Received: by 2002:a92:d7d2:: with SMTP id g18mr66769055ilq.2.1609676707631;
 Sun, 03 Jan 2021 04:25:07 -0800 (PST)
Date:   Sun, 03 Jan 2021 04:25:07 -0800
In-Reply-To: <CAKK_rcjc6L7hXwRoAAsx8Xr0TVCCy5VjfmYe3kPjTgFDDObmVA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c977005b7fe109c@google.com>
Subject: Re: memory leak in qrtr_tun_open
From:   syzbot <syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jeliantsurux@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in rxrpc_lookup_local

BUG: memory leak
unreferenced object 0xffff8881180f2400 (size 256):
  comm "syz-executor.2", pid 8876, jiffies 4294943434 (age 397.880s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 40 a6 17 81 88 ff ff  .........@......
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117a3fe00 (size 256):
  comm "syz-executor.5", pid 8877, jiffies 4294943441 (age 397.810s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 40 ee 17 81 88 ff ff  .........@......
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117964600 (size 256):
  comm "syz-executor.1", pid 8873, jiffies 4294943442 (age 397.800s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 c0 d3 17 81 88 ff ff  ................
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881174d7500 (size 256):
  comm "syz-executor.6", pid 8880, jiffies 4294943451 (age 397.710s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 00 f4 16 81 88 ff ff  ................
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881180f2400 (size 256):
  comm "syz-executor.2", pid 8876, jiffies 4294943434 (age 405.890s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 40 a6 17 81 88 ff ff  .........@......
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117a3fe00 (size 256):
  comm "syz-executor.5", pid 8877, jiffies 4294943441 (age 405.830s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 40 ee 17 81 88 ff ff  .........@......
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117964600 (size 256):
  comm "syz-executor.1", pid 8873, jiffies 4294943442 (age 405.820s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 c0 d3 17 81 88 ff ff  ................
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881174d7500 (size 256):
  comm "syz-executor.6", pid 8880, jiffies 4294943451 (age 405.730s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 00 f4 16 81 88 ff ff  ................
  backtrace:
    [<00000000e05e32c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000e05e32c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000e05e32c5>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<00000000e05e32c5>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000003c4c54a1>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<0000000096bb7b73>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<00000000a1205710>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<000000008360f61f>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000b8ad32fd>] setup_net+0xdb/0x2d0 net/core/net_namespace.c:342
    [<0000000088fe666c>] copy_net_ns+0x14b/0x320 net/core/net_namespace.c:483
    [<000000006b972415>] create_new_namespaces+0x199/0x4e0 kernel/nsproxy.c:110
    [<00000000eeacf563>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:231
    [<00000000af0a761d>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2949
    [<000000006aa354b4>] __do_sys_unshare kernel/fork.c:3017 [inline]
    [<000000006aa354b4>] __se_sys_unshare kernel/fork.c:3015 [inline]
    [<000000006aa354b4>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3015
    [<00000000dac4b013>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000058f76570>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



Tested on:

commit:         509a1542 Merge tag '5.10-rc6-smb3-fixes' of git://git.samb..
git tree:       https://github.com/google/kasan.git
console output: https://syzkaller.appspot.com/x/log.txt?x=10d28e93500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94a2a43fcd7d2ae5
dashboard link: https://syzkaller.appspot.com/bug?extid=5d6e4af21385f5cfc56a
compiler:       gcc (GCC) 10.1.0-syz 20200507
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15ec6448d00000

