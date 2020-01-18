Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4341D14166B
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgARH5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:57:16 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:41321 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgARH5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:57:10 -0500
Received: by mail-io1-f71.google.com with SMTP id m12so16627371ioh.8
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xtMFnElUS0Vc2pSnzKckZNRlgYXwaUOGecfse3Ze7zs=;
        b=hQ8IXFYUbY2P/xPzfA+RiuNJDM9Netls/q79IrsOduLVNjuxYI8aOmvng0ecY37+ox
         SbD24pUkcJafNDfXwr1s6d0evoYtJVsnypUojOwBve64ZNZZOf1SYJKAY4/LE6XFzrLO
         oj75qDCFrThog/tx0lnBh327XonDK/5VH8pQ9lt6yiwps8AKnW+pjjBHz6pYmXu9fE6j
         p7/8ud0S2lZAjknFIu9w7TrWkiWZQK9z+nGDkBoAhDMJj8rEgvF1xb1BLdRG8ZPqx83Y
         pXXeRHrIzJFxnYri53m1yI80s0yA4q14+nd9CemXBcV69UjPgeRaHE530SErFKiJavGk
         oQYw==
X-Gm-Message-State: APjAAAWrbDcMspIi3LQmotHg9lfRq9sA1ODUKieEQ48f2T1Jmm/30qRL
        PoWHQrTbwsPgXDGR69jA4PjyROzZHh4b0amwd7+6LKQJYQV5
X-Google-Smtp-Source: APXvYqzwMkunkiIw4OYEVqDWj5qI/Cr2cFw9y79byFa3jJ4Rpr/x/ZBXzoAr3MLDlrLR8dZJT1hbWCM8dtlXkR+vbn8ZOmcHwGmY
MIME-Version: 1.0
X-Received: by 2002:a92:b06:: with SMTP id b6mr2088053ilf.127.1579334229890;
 Fri, 17 Jan 2020 23:57:09 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1192b059c656701@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_port_add
From:   syzbot <syzbot+dfccdb2bdb4a12ad425e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, aryabinin@virtuozzo.com,
        coreteam@netfilter.org, davem@davemloft.net, elver@google.com,
        fw@strlen.de, gregkh@linuxfoundation.org, info@metux.net,
        jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=137ad6d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=dfccdb2bdb4a12ad425e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1642f095e00000

The bug was bisected to:

commit 751ad98d5f881df91ba47e013b82422912381e8e
Author: Marco Elver <elver@google.com>
Date:   Fri Jul 12 03:54:00 2019 +0000

    asm-generic, x86: add bitops instrumentation for KASAN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9ccc9e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16e9ccc9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e9ccc9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dfccdb2bdb4a12ad425e@syzkaller.appspotmail.com
Fixes: 751ad98d5f88 ("asm-generic, x86: add bitops instrumentation for KASAN")

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_do_add net/netfilter/ipset/ip_set_bitmap_port.c:74 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_add+0xef/0xe60 net/netfilter/ipset/ip_set_bitmap_gen.h:136
Read of size 8 at addr ffff88809a9d0780 by task syz-executor.0/9809

CPU: 1 PID: 9809 Comm: syz-executor.0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_port_do_add net/netfilter/ipset/ip_set_bitmap_port.c:74 [inline]
 bitmap_port_add+0xef/0xe60 net/netfilter/ipset/ip_set_bitmap_gen.h:136
 bitmap_port_uadt+0x65d/0x8a0 net/netfilter/ipset/ip_set_bitmap_port.c:199
 call_ad+0x1a0/0x5a0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad.isra.0+0x572/0xb20 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_uadd+0x37/0x50 net/netfilter/ipset/ip_set_core.c:1829
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f87b5e8bc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f87b5e8c6d4 RCX: 000000000045aff9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000008c8 R14: 00000000004c9dfc R15: 000000000075bf2c

Allocated by task 9806:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
 bitmap_port_create+0x3dc/0x7c0 net/netfilter/ipset/ip_set_bitmap_port.c:276
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9585:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_add_entry security/tomoyo/common.c:2045 [inline]
 tomoyo_supervisor+0xc2c/0xef0 security/tomoyo/common.c:2103
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x18e/0x210 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:674 [inline]
 tomoyo_find_next_domain+0x1354/0x1f6c security/tomoyo/domain.c:881
 tomoyo_bprm_check_security security/tomoyo/tomoyo.c:107 [inline]
 tomoyo_bprm_check_security+0x124/0x1a0 security/tomoyo/tomoyo.c:97
 security_bprm_check+0x63/0xb0 security/security.c:784
 search_binary_handler+0x71/0x570 fs/exec.c:1645
 exec_binprm fs/exec.c:1701 [inline]
 __do_execve_file.isra.0+0x1329/0x22b0 fs/exec.c:1821
 do_execveat_common fs/exec.c:1867 [inline]
 do_execve fs/exec.c:1884 [inline]
 __do_sys_execve fs/exec.c:1960 [inline]
 __se_sys_execve fs/exec.c:1955 [inline]
 __x64_sys_execve+0x8f/0xc0 fs/exec.c:1955
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809a9d0780
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff88809a9d0780, ffff88809a9d07a0)
The buggy address belongs to the page:
page:ffffea00026a7400 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff88809a9d0fc1
raw: 00fffe0000000200 ffffea0002a69b88 ffffea00028d3508 ffff8880aa4001c0
raw: ffff88809a9d0fc1 ffff88809a9d0000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809a9d0680: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809a9d0700: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff88809a9d0780: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                   ^
 ffff88809a9d0800: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809a9d0880: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
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
