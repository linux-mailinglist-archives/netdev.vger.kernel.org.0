Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590C81C85E7
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 11:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEGJgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:36:17 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:47010 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgEGJgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 05:36:16 -0400
Received: by mail-il1-f199.google.com with SMTP id g17so5349723iln.13
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 02:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zgr12NG/96S5pfuI0okSGWF9x6WfA1Zy9V4M4WnWAMM=;
        b=mfJSBIffB5bIJU4HFJBq0KW/NqPUJpF2NbWKtS8DULKey3wV4tt2hEIVN3klUfYvfT
         FvQgCao5WQCpHFRlk17W+hAwqiFNgllg0FsayeLir014weynizYgPqwroKTDc7BY2iXZ
         D5rzsrO3yPQS+7n2pb7nmUvoqCDQ8gG/7ldrQLqZaqo6MjWjmDKfQYEinRFqRZY/I5qe
         WbOHiFqcTWrKlCbZyWYPLi0UPI4O19nVq7TjsIKERcKHDwo4LZOwpo88MmAe4ijweM/Q
         yKuslfMBJKlVShF49IDbNHgA5SOlygR/TvSfB6SLgtwDK6ZfOLgKBpeL9NE5aW8GwbGV
         vyTA==
X-Gm-Message-State: AGi0Puag1n0ZYnFydr7WHKHp10WCadlmZfXcSKX3LHV8G+VJDCh4dk/u
        ucnPhLrUfdxDveN/ptOBaycvllJLMSoQqGKJsqBakXOiMbbx
X-Google-Smtp-Source: APiQypJUExR5SSgw0gyrpqPlg6LOLXBmXfah4Ewhloj32cSZgjhr8+4KKOwzOxYkPeUrgIepVI9nKfDmy+bwCbmD5rUFzEg7sNu1
MIME-Version: 1.0
X-Received: by 2002:a92:d1c4:: with SMTP id u4mr12749363ilg.183.1588844173612;
 Thu, 07 May 2020 02:36:13 -0700 (PDT)
Date:   Thu, 07 May 2020 02:36:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000925dda05a50b9c13@google.com>
Subject: KASAN: use-after-free Read in rpc_net_ns
From:   syzbot <syzbot+22b5ef302c7c40d94ea8@syzkaller.appspotmail.com>
To:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        neilb@suse.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f66ed1eb Merge tag 'iomap-5.7-fixes-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a4fa9c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b075813ec8b93cd
dashboard link: https://syzkaller.appspot.com/bug?extid=22b5ef302c7c40d94ea8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12315918100000

The bug was bisected to:

commit 7c4310ff56422ea43418305d22bbc5fe19150ec4
Author: NeilBrown <neilb@suse.de>
Date:   Fri Apr 3 03:33:41 2020 +0000

    SUNRPC: defer slow parts of rpc_free_client() to a workqueue.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12176e60100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11176e60100000
console output: https://syzkaller.appspot.com/x/log.txt?x=16176e60100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+22b5ef302c7c40d94ea8@syzkaller.appspotmail.com
Fixes: 7c4310ff5642 ("SUNRPC: defer slow parts of rpc_free_client() to a workqueue.")

IPv6: ADDRCONF(NETDEV_CHANGE): veth1_vlan: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth0_vlan: link becomes ready
==================================================================
BUG: KASAN: use-after-free in rpc_net_ns+0x222/0x230 net/sunrpc/clnt.c:1506
Read of size 8 at addr ffff8880a7c888d8 by task kworker/0:3/2690

CPU: 0 PID: 2690 Comm: kworker/0:3 Not tainted 5.7.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events rpc_free_client_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 rpc_net_ns+0x222/0x230 net/sunrpc/clnt.c:1506
 rpc_clnt_remove_pipedir net/sunrpc/clnt.c:111 [inline]
 rpc_free_client_work+0x1a/0x60 net/sunrpc/clnt.c:892
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8372:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x161/0x7a0 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 xprt_alloc+0x2d/0x800 net/sunrpc/xprt.c:1658
 xs_setup_xprt.part.0+0x56/0x2e0 net/sunrpc/xprtsock.c:2735
 xs_setup_xprt net/sunrpc/xprtsock.c:2906 [inline]
 xs_setup_udp+0x9e/0x890 net/sunrpc/xprtsock.c:2850
 xprt_create_transport+0xf9/0x480 net/sunrpc/xprt.c:1905
 rpc_create+0x282/0x680 net/sunrpc/clnt.c:581
 nfs_create_rpc_client+0x4eb/0x680 fs/nfs/client.c:535
 nfs_init_client fs/nfs/client.c:652 [inline]
 nfs_init_client+0x6d/0xf0 fs/nfs/client.c:639
 nfs_get_client+0x1098/0x1430 fs/nfs/client.c:429
 nfs_init_server+0x305/0xf00 fs/nfs/client.c:691
 nfs_create_server+0x15c/0x700 fs/nfs/client.c:978
 nfs_try_get_tree+0x166/0x8d0 fs/nfs/super.c:922
 nfs_get_tree+0x95a/0x13a0 fs/nfs/fs_context.c:1291
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2816 [inline]
 do_mount+0x1306/0x1b30 fs/namespace.c:3141
 __do_sys_mount fs/namespace.c:3350 [inline]
 __se_sys_mount fs/namespace.c:3327 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3327
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 23:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free_bulk+0x7d/0x280 mm/slab.c:3721
 kfree_bulk include/linux/slab.h:412 [inline]
 kfree_rcu_work+0x1a1/0x480 kernel/rcu/tree.c:2859
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a7c88000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2264 bytes inside of
 4096-byte region [ffff8880a7c88000, ffff8880a7c89000)
The buggy address belongs to the page:
page:ffffea00029f2200 refcount:1 mapcount:0 mapping:00000000862db9cd index:0x0 head:ffffea00029f2200 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00029ca708 ffffea00029a1c88 ffff8880aa002000
raw: 0000000000000000 ffff8880a7c88000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a7c88780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a7c88800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a7c88880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff8880a7c88900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a7c88980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
