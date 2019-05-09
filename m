Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9F18F05
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEIR1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 13:27:07 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:53245 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfEIR1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 13:27:06 -0400
Received: by mail-it1-f200.google.com with SMTP id 73so2745997itl.2
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 10:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=g48Dhm3yLTEZrnSrkdwgyIF4w5hBUxYzeM4OkxKBLnc=;
        b=Ai6QsUUmL9hqHPbQosVWkzqoi3DDnkOy2YlQIy6dGbsUNjgYeVe2s1zLS6f7pvrcD6
         koCbF3YDZrbjYfOCnUUMmMgEAmZ6fEMJA2ZgsP4Db8c8wCMFS+F8TDqVRPNWo701Xc9I
         Ny7HQ9mxeQzFoC/JIunQZ7qbWb0Mf8CYlM58q0OocdxXX+xSCt/43T5F3ZH5xdLa8zse
         TvTf+MsKCNIzzZPAf0I8am0yKpP+rGInLcW+k8wYO1jWfa2+IK9d4IKnPAw8C6MtFGOX
         Tq5xb0cOh7VikSIXS0BK0ec8IANaVOAvP27fWBVH4LmyFVm0sDgOMPk6v4DYkfxsImse
         vVGQ==
X-Gm-Message-State: APjAAAWSzZsWRN1mWw0+dVPR5aTcI/1zaWoCFYZq543EoDk01pdHbPR9
        MQEaZnLpFWdG74cEezjFNvu9YnweyoxuqgmX25RK+KBqcqI9
X-Google-Smtp-Source: APXvYqzXAhnaZbPjX6PZnuEx+BfZwpai6VfZNHOUUBb+mWQTzrhb8xm63KISe+JenwX53s2M1ZwVVxOM+uH2ThTpQ856jPukPtIu
MIME-Version: 1.0
X-Received: by 2002:a6b:6405:: with SMTP id t5mr2818480iog.190.1557422826047;
 Thu, 09 May 2019 10:27:06 -0700 (PDT)
Date:   Thu, 09 May 2019 10:27:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fd863058877c251@google.com>
Subject: KASAN: slab-out-of-bounds Read in ip_append_data
From:   syzbot <syzbot+b8031b06e100c1c5292c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jon.maloy@ericsson.com, kafai@fb.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, yhs@fb.com,
        ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    80f23212 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1630988ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40a58b399941db7e
dashboard link: https://syzkaller.appspot.com/bug?extid=b8031b06e100c1c5292c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b4aec8a00000

The bug was bisected to:

commit 52dfae5c85a4c1078e9f1d5e8947d4a25f73dd81
Author: Jon Maloy <jon.maloy@ericsson.com>
Date:   Thu Mar 22 19:42:52 2018 +0000

     tipc: obtain node identity from interface by default

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10130c22a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12130c22a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14130c22a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b8031b06e100c1c5292c@syzkaller.appspotmail.com
Fixes: 52dfae5c85a4 ("tipc: obtain node identity from interface by default")

==================================================================
BUG: KASAN: slab-out-of-bounds in skb_queue_empty  
include/linux/skbuff.h:1478 [inline]
BUG: KASAN: slab-out-of-bounds in ip_append_data.part.0+0x16a/0x170  
net/ipv4/ip_output.c:1207
Read of size 8 at addr ffff8880a74d0bd4 by task udevd/7768

CPU: 0 PID: 7768 Comm: udevd Not tainted 5.1.0+ #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  skb_queue_empty include/linux/skbuff.h:1478 [inline]
  ip_append_data.part.0+0x16a/0x170 net/ipv4/ip_output.c:1207
  ip_append_data+0x6e/0x90 net/ipv4/ip_output.c:1204
  icmp_push_reply+0x189/0x510 net/ipv4/icmp.c:375
  __icmp_send+0xaa1/0x1400 net/ipv4/icmp.c:737
  icmp_send include/net/icmp.h:47 [inline]
  __udp4_lib_rcv+0x1fe9/0x2ca0 net/ipv4/udp.c:2318
  udp_rcv+0x22/0x30 net/ipv4/udp.c:2477
  ip_protocol_deliver_rcu+0x3bc/0x940 net/ipv4/ip_input.c:211
  ip_local_deliver_finish+0x23b/0x390 net/ipv4/ip_input.c:238
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:259
  dst_input include/net/dst.h:439 [inline]
  ip_rcv_finish+0x1e1/0x300 net/ipv4/ip_input.c:420
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:530
  __netif_receive_skb_one_core+0x18d/0x1f0 net/core/dev.c:4990
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5104
  process_backlog+0x206/0x750 net/core/dev.c:5944
  napi_poll net/core/dev.c:6367 [inline]
  net_rx_action+0x4fa/0x1070 net/core/dev.c:6433
  __do_softirq+0x266/0x95a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:374 [inline]
  irq_exit+0x180/0x1d0 kernel/softirq.c:414
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x14a/0x570 arch/x86/kernel/apic/apic.c:1067
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:find_vma+0xe4/0x170 mm/mmap.c:2243
Code: 00 0f 85 8b 00 00 00 48 8b 5b 10 e8 f6 fe d2 ff 48 85 db 74 4c e8 ec  
fe d2 ff 48 8d 7b e8 48 89 f8 48 c1 e8 03 42 80 3c 38 00 <75> 58 4c 8b 73  
e8 4c 89 e6 4c 89 f7 e8 eb ff d2 ff 4d 39 e6 0f 87
RSP: 0000:ffff888090777e68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 1ffff110123db801 RBX: ffff888091edc020 RCX: ffffffff819d8a45
RDX: 0000000000000000 RSI: ffffffff819d8a24 RDI: ffff888091edc008
RBP: ffff888090777e90 R08: ffff888093a62500 R09: ffff888093a62da0
R10: ffff888093a62d80 R11: ffff888093a62500 R12: 00007ffd5ea48f40
R13: 0000000000000000 R14: 00007f6ebd0e3000 R15: dffffc0000000000
  do_user_addr_fault arch/x86/mm/fault.c:1418 [inline]
  __do_page_fault+0x375/0xda0 arch/x86/mm/fault.c:1523
  do_page_fault+0x71/0x581 arch/x86/mm/fault.c:1554
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1142
RIP: 0033:0x407821
Code: 02 00 00 e9 c7 fb ff ff 8b 54 24 68 85 d2 0f 89 e9 fb ff ff 48 83 7c  
24 40 00 0f 84 9c fa ff ff 48 8b 54 24 40 48 8b 44 24 58 <c6> 04 02 00 e9  
89 fa ff ff 66 0f 1f 44 00 00 be 02 00 00 00 44 89
RSP: 002b:00007ffd5ea45cf0 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000002215250 RCX: 00000000ffffffff
RDX: 00007ffd5ea48f40 RSI: 0000000000000002 RDI: 0000000000000007
RBP: 0000000000625500 R08: 00007ffd5ebb80b0 R09: 00007ffd5ebb8080
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd5ea45dc0
R13: 0000000000000001 R14: 00007ffd5ea45d54 R15: 0000000002215250

Allocated by task 7810:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc mm/slab.c:3357 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3519
  sk_prot_alloc+0x67/0x2e0 net/core/sock.c:1602
  sk_alloc+0x39/0xf70 net/core/sock.c:1662
  inet_create net/ipv4/af_inet.c:325 [inline]
  inet_create+0x36a/0xe10 net/ipv4/af_inet.c:251
  __sock_create+0x3e6/0x750 net/socket.c:1430
  sock_create_kern+0x3b/0x50 net/socket.c:1499
  inet_ctl_sock_create+0x9d/0x1f0 net/ipv4/af_inet.c:1624
  icmp_sk_init+0x11c/0x4c0 net/ipv4/icmp.c:1204
  ops_init+0xb6/0x410 net/core/net_namespace.c:129
  setup_net+0x2d3/0x740 net/core/net_namespace.c:315
  copy_net_ns+0x1df/0x340 net/core/net_namespace.c:438
  create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:107
  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:206
  ksys_unshare+0x440/0x980 kernel/fork.c:2661
  __do_sys_unshare kernel/fork.c:2729 [inline]
  __se_sys_unshare kernel/fork.c:2727 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2727
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8880a74d0680
  which belongs to the cache RAW of size 1352
The buggy address is located 12 bytes to the right of
  1352-byte region [ffff8880a74d0680, ffff8880a74d0bc8)
The buggy address belongs to the page:
page:ffffea00029d3400 count:1 mapcount:0 mapping:ffff88821ac8bc00 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002970088 ffffea000219cb88 ffff88821ac8bc00
raw: 0000000000000000 ffff8880a74d0080 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a74d0a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a74d0b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff8880a74d0b80: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
                                                  ^
  ffff8880a74d0c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a74d0c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
