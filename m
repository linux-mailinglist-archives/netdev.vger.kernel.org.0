Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23931F699
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhBSJff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:35:35 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:44726 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhBSJfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:35:03 -0500
Received: by mail-il1-f197.google.com with SMTP id a9so3116584ilm.11
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 01:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JBkhTOlgg4bgMUFvQex3digvJ1qylRjH8RKIX1kE3zE=;
        b=AHKVJAOscuTolF/XWwJEdoYtSFLBOdcNEbiMUo3AytSeub/qQhKWEhT7qhmHB2oKIP
         qxi5uLUliLvIBtCv/ws3Xg3H75y4kV3Acr79R2ySS0mCNAjg98QBDoI2907r+SJA8mL0
         I+4lWhez3f7VkgqZ1f37lEeJc6Fjyut+KnMw2U20qcppKhkSjpDNx7394K3DdDcJLRmV
         Um8RFmQx6jesHJMPxaf3KkkMme2N0eu9qpYmXNvThB1+mrtJK5WLjjMZSxIuarZPZOXk
         A7HhxrXLq9jmptX+lHQaecObYBJqrVkSSRSz1G3+8ik2qoqKcsQF31jK5yxNXcEapxAB
         4Tzg==
X-Gm-Message-State: AOAM531d555+P3MR/Vcraq/dB+2P7hb8MnpdHci15NqMwlMrIwUjsCLe
        BudMLntLBzHvstu/vx9uhpKu+65XNOnw65Ddw4Xy1dXP2IX1
X-Google-Smtp-Source: ABdhPJzhg+gGkda6+yWcxuxaOqXS7Suxl1Hl03p1o31Q9Mq7NvAluP+hsUCKQkjT2czuYSAVE4iCL57IPYWYVWWKnXyUxC84KNDK
MIME-Version: 1.0
X-Received: by 2002:a92:c54e:: with SMTP id a14mr3209750ilj.285.1613727261512;
 Fri, 19 Feb 2021 01:34:21 -0800 (PST)
Date:   Fri, 19 Feb 2021 01:34:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fdd6805bbad28bf@google.com>
Subject: KASAN: use-after-free Read in ip6_pol_route (2)
From:   syzbot <syzbot+eeda6c04066577b6a84c@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c4762993 Merge branch 'skbuff-introduce-skbuff_heads-bulki..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=151e6df4d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=eeda6c04066577b6a84c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1008eed2d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113cb614d00000

The issue was bisected to:

commit 40947e13997a1cba4e875893ca6e5d5e61a0689d
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Feb 12 23:59:56 2021 +0000

    mptcp: schedule worker when subflow is closed

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17d2e7d2d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1432e7d2d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1032e7d2d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eeda6c04066577b6a84c@syzkaller.appspotmail.com
Fixes: 40947e13997a ("mptcp: schedule worker when subflow is closed")

==================================================================
BUG: KASAN: use-after-free in rt6_get_pcpu_route net/ipv6/route.c:1413 [inline]
BUG: KASAN: use-after-free in ip6_pol_route+0x1087/0x11c0 net/ipv6/route.c:2265
Read of size 4 at addr ffff8880130c3bb8 by task syz-executor292/8981

CPU: 1 PID: 8981 Comm: syz-executor292 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 rt6_get_pcpu_route net/ipv6/route.c:1413 [inline]
 ip6_pol_route+0x1087/0x11c0 net/ipv6/route.c:2265
 pol_lookup_func include/net/ip6_fib.h:579 [inline]
 fib6_rule_lookup+0x52a/0x6f0 net/ipv6/fib6_rules.c:120
 ip6_route_output_flags_noref+0x2e2/0x380 net/ipv6/route.c:2512
 ip6_route_output_flags+0x8b/0x310 net/ipv6/route.c:2525
 ip6_route_output include/net/ip6_route.h:98 [inline]
 ip6_dst_lookup_tail+0xb6e/0x1740 net/ipv6/ip6_output.c:1064
 ip6_dst_lookup_flow+0x8c/0x1d0 net/ipv6/ip6_output.c:1194
 tcp_v6_connect+0xdb3/0x1df0 net/ipv6/tcp_ipv6.c:283
 __inet_stream_connect+0x8c5/0xee0 net/ipv4/af_inet.c:661
 inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:725
 mptcp_stream_connect+0x156/0x800 net/mptcp/protocol.c:3200
 __sys_connect_file+0x155/0x1a0 net/socket.c:1835
 __sys_connect+0x161/0x190 net/socket.c:1852
 __do_sys_connect net/socket.c:1862 [inline]
 __se_sys_connect net/socket.c:1859 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1859
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449b09
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f791eff4318 EFLAGS: 00000246
 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00000000004cf4c8 RCX: 0000000000449b09
RDX: 000000000000001c RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000004cf4c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cf4cc
R13: 00007ffeaa51511f R14: 00007f791eff4400 R15: 0000000000022000

Allocated by task 8626:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:209 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2892 [inline]
 slab_alloc mm/slub.c:2900 [inline]
 kmem_cache_alloc+0x1c6/0x440 mm/slub.c:2905
 dst_alloc+0x9e/0x650 net/core/dst.c:93
 ip6_dst_alloc+0x2e/0x100 net/ipv6/route.c:358
 ip6_rt_pcpu_alloc net/ipv6/route.c:1386 [inline]
 rt6_make_pcpu_route net/ipv6/route.c:1434 [inline]
 ip6_pol_route+0x910/0x11c0 net/ipv6/route.c:2268
 pol_lookup_func include/net/ip6_fib.h:579 [inline]
 fib6_rule_lookup+0x52a/0x6f0 net/ipv6/fib6_rules.c:120
 ip6_route_output_flags_noref+0x2e2/0x380 net/ipv6/route.c:2512
 ip6_route_output_flags+0x8b/0x310 net/ipv6/route.c:2525
 ip6_route_output include/net/ip6_route.h:98 [inline]
 ip6_dst_lookup_tail+0xb6e/0x1740 net/ipv6/ip6_output.c:1064
 ip6_dst_lookup_flow+0x8c/0x1d0 net/ipv6/ip6_output.c:1194
 tcp_v6_connect+0xdb3/0x1df0 net/ipv6/tcp_ipv6.c:283
 __inet_stream_connect+0x8c5/0xee0 net/ipv4/af_inet.c:661
 inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:725
 mptcp_stream_connect+0x156/0x800 net/mptcp/protocol.c:3200
 __sys_connect_file+0x155/0x1a0 net/socket.c:1835
 __sys_connect+0x161/0x190 net/socket.c:1852
 __do_sys_connect net/socket.c:1862 [inline]
 __se_sys_connect net/socket.c:1859 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1859
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 18:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3143 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3159
 dst_destroy+0x2bc/0x3c0 net/core/dst.c:129
 rcu_do_batch kernel/rcu/tree.c:2489 [inline]
 rcu_core+0x5eb/0xf00 kernel/rcu/tree.c:2723
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:343

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xc5/0xf0 mm/kasan/generic.c:344
 __call_rcu kernel/rcu/tree.c:2965 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3038
 dst_release net/core/dst.c:179 [inline]
 dst_release+0x79/0xe0 net/core/dst.c:169
 sk_dst_set include/net/sock.h:1999 [inline]
 sk_dst_reset include/net/sock.h:2011 [inline]
 ipv6_update_options+0x18c/0x3e0 net/ipv6/ipv6_sockglue.c:114
 ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:383 [inline]
 do_ipv6_setsockopt.constprop.0+0x940/0x41f0 net/ipv6/ipv6_sockglue.c:657
 ipv6_setsockopt+0xd6/0x180 net/ipv6/ipv6_sockglue.c:1003
 tcp_setsockopt+0x136/0x2440 net/ipv4/tcp.c:3636
 mptcp_setsockopt+0x612/0x780 net/mptcp/protocol.c:2862
 __sys_setsockopt+0x2db/0x610 net/socket.c:2115
 __do_sys_setsockopt net/socket.c:2126 [inline]
 __se_sys_setsockopt net/socket.c:2123 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2123
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880130c3b40
 which belongs to the cache ip6_dst_cache of size 232
The buggy address is located 120 bytes inside of
 232-byte region [ffff8880130c3b40, ffff8880130c3c28)
The buggy address belongs to the page:
page:000000007c3a5b1c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x130c3
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888020ff5500
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880130c3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff8880130c3b00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff8880130c3b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff8880130c3c00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff8880130c3c80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
