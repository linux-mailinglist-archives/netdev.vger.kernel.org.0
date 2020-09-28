Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A5C27A892
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgI1H1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:27:37 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:52124 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgI1H10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:27:26 -0400
Received: by mail-il1-f207.google.com with SMTP id e3so78420ilq.18
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NCkNaomJtuG8Ixkq0sPPguZMyC8HytnM7a0RscFm9Jc=;
        b=NLFiIbpNx7eMeJRU3vsaUf6swRq6X2Om+7Bu9946gziCBN4MkLMSa5KWbFeYkz/6Pz
         F+cGKQv/KWshAW6MGrv+/4OfcevhwGSnqXZEHOs4c7CBwndWB8kAZSDh4CPowkzIRPWe
         QnFE2pWhaouN2VZZ1oJnn95dTnXBZ3HDNuWUY+NHq3K+W+UG/UU0otFaSx7kmFkzAp4/
         e/oe+lBLzR0L8fpCz6ENxK0xTg9XHX8boJeokLczhcBkbkl6+uOKo/uT6ePOjon2Lyx+
         kwJ/Z5uwCCHFW0W7Qytpd1kHpNhIhJZmKM2+JeZIUjW2KbU532011W+KAwUiQ4Zt5DYD
         5jgg==
X-Gm-Message-State: AOAM533zNeeHS5dw4Z3k4tEVkGlGkocm0IHrXjoJ2MjeJ6iKx4ca4l2M
        pj18N/sI88OAlclbhZZFZnAFIsaDiHVX3Pr3nhxCkNn+h2AB
X-Google-Smtp-Source: ABdhPJzItk4Uh0W6cDwSXiw8cDz9ZlXp6DQZfJNm3HckGO07a0OULgqJiOJSCsPNBAp87ljdpSInHeHcxqrbj5ahk7FTMp6hbrfx
MIME-Version: 1.0
X-Received: by 2002:a02:a816:: with SMTP id f22mr148732jaj.118.1601278044624;
 Mon, 28 Sep 2020 00:27:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:27:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000095d3605b05a9909@google.com>
Subject: KASAN: use-after-free Read in tcf_action_init
From:   syzbot <syzbot+9f43bb6a66ff96a21931@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        enric.balletbo@collabora.com, groeck@chromium.org,
        gwendal@chromium.org, jhs@mojatatu.com, jic23@kernel.org,
        jiri@resnulli.us, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    171d4ff7 Merge tag 'mmc-v5.9-rc4-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105fbac5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=9f43bb6a66ff96a21931
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cb8f8b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12af2c81900000

The issue was bisected to:

commit 974e6f02e27e1b46c6c5e600e70ced25079f73eb
Author: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Date:   Mon Aug 1 09:54:35 2016 +0000

    iio: cros_ec_sensors_core: Add common functions for the ChromeOS EC Sensor Hub.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fe49d3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13fe49d3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15fe49d3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f43bb6a66ff96a21931@syzkaller.appspotmail.com
Fixes: 974e6f02e27e ("iio: cros_ec_sensors_core: Add common functions for the ChromeOS EC Sensor Hub.")

netlink: 32 bytes leftover after parsing attributes in process `syz-executor211'.
==================================================================
BUG: KASAN: use-after-free in tcf_action_destroy net/sched/act_api.c:724 [inline]
BUG: KASAN: use-after-free in tcf_action_init+0x231/0x3d0 net/sched/act_api.c:1058
Read of size 8 at addr ffff888097225c00 by task syz-executor211/7086

CPU: 0 PID: 7086 Comm: syz-executor211 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 tcf_action_destroy net/sched/act_api.c:724 [inline]
 tcf_action_init+0x231/0x3d0 net/sched/act_api.c:1058
 tcf_action_add net/sched/act_api.c:1451 [inline]
 tc_ctl_action+0x2c7/0x7e0 net/sched/act_api.c:1504
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44abe9
Code: e8 dc 13 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb 0b fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f842a305ce8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006e0c48 RCX: 000000000044abe9
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006e0c40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e0c4c
R13: 00007ffcf73121ef R14: 00007f842a3069c0 R15: 00000000006e0c4c

Allocated by task 7086:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3655 [inline]
 __kmalloc+0x205/0x300 mm/slab.c:3664
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc+0x16/0x30 include/linux/slab.h:666
 tcf_idr_create+0x56/0x5e0 net/sched/act_api.c:408
 tcf_connmark_init+0x230/0x7d0 net/sched/act_connmark.c:126
 tcf_action_init_1+0x7dc/0xce0 net/sched/act_api.c:984
 tcf_action_init+0x114/0x3d0 net/sched/act_api.c:1043
 tcf_action_add net/sched/act_api.c:1451 [inline]
 tc_ctl_action+0x2c7/0x7e0 net/sched/act_api.c:1504
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 7088:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x113/0x200 mm/slab.c:3756
 tcf_idr_release_unsafe net/sched/act_api.c:284 [inline]
 tcf_del_walker net/sched/act_api.c:310 [inline]
 tcf_generic_walker+0x6f8/0xbc0 net/sched/act_api.c:339
 tca_action_flush net/sched/act_api.c:1278 [inline]
 tca_action_gd+0x135a/0x18f0 net/sched/act_api.c:1385
 tc_ctl_action+0x395/0x7e0 net/sched/act_api.c:1512
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888097225c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff888097225c00, ffff888097225e00)
The buggy address belongs to the page:
page:00000000598892c8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x97225
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028423c8 ffffea00028bbc48 ffff8880aa440600
raw: 0000000000000000 ffff888097225000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888097225b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888097225b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888097225c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888097225c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888097225d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
