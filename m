Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8591220388
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfEPKfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 06:35:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51560 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfEPKfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 06:35:07 -0400
Received: by mail-io1-f71.google.com with SMTP id i20so2293464ioo.18
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 03:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ogi4Zx9YKcEIb3tc3T3zeOW92HZiBY/I1YpoRF0AIfw=;
        b=AhiBhmLjOOiXJCClamtYhYFsEvBaG49GmwkvAk/ViaRq3gTkDfMMWaqeIWXqHR2OLm
         H9S5Y/hA0aleAZ8OyqsCryvjDIpgHpgQmJoOwXoS/jVZZ5lkIjDHmA2i9iPibZkoA6kn
         SeVRRMnC43f3ZBCoOH/NX3Z1whF9xpRPAGWRQ53s6bLyy9TLsEVobUWUZJj71Yj8XWsj
         JkQT20MxtZeKYRMev6Ice8x1Czs/TuXvyhxAfXwVJsUS4HpKDKTnUu1FzjIIrSUO9a2F
         GnPrudloQuLuDeo8E1PrDkibPkkzYpBXzXIzuTfGdjKu+7FohQaWxyG5R6IOR01i9juQ
         JWJw==
X-Gm-Message-State: APjAAAUvhZjQgc/Bz54qOtRsvH6D6AfdeJM0aQUb1sRXP8ndttBySCBH
        pzCfbuDCiV19MdZVP8MWPomYeudHYjdURJvjRPYi3nDyKhNc
X-Google-Smtp-Source: APXvYqy/km2xk0VlmCUiEVpTpP+aBex2sJKgvPvIo3Wuiw0LVsmIi0xRW8hj3b80c46hq5VOiJe0e/2U+yMec4lafVq8gXpCDCSu
MIME-Version: 1.0
X-Received: by 2002:a6b:e718:: with SMTP id b24mr25879886ioh.213.1558002906701;
 Thu, 16 May 2019 03:35:06 -0700 (PDT)
Date:   Thu, 16 May 2019 03:35:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d028b30588fed102@google.com>
Subject: KASAN: use-after-free Write in xfrm_hash_rebuild
From:   syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    601e6bcc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1534f3d0a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4005028a9d5ddac8
dashboard link: https://syzkaller.appspot.com/bug?extid=0165480d4ef07360eeda
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __write_once_size  
include/linux/compiler.h:220 [inline]
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:713 [inline]
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455  
[inline]
BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xfff/0x10f0  
net/xfrm/xfrm_policy.c:1317
Write of size 8 at addr ffff888098529100 by task kworker/0:0/5

CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.1.0+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events xfrm_hash_rebuild
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
  __write_once_size include/linux/compiler.h:220 [inline]
  __hlist_del include/linux/list.h:713 [inline]
  hlist_del_rcu include/linux/rculist.h:455 [inline]
  xfrm_hash_rebuild+0xfff/0x10f0 net/xfrm/xfrm_policy.c:1317
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2268
  worker_thread+0x98/0xe40 kernel/workqueue.c:2414
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 8152:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  kmem_cache_alloc_node_trace+0x153/0x720 mm/slab.c:3630
  kmalloc_node include/linux/slab.h:585 [inline]
  kzalloc_node include/linux/slab.h:753 [inline]
  __get_vm_area_node+0x12b/0x3a0 mm/vmalloc.c:1401
  __vmalloc_node_range+0xd4/0x790 mm/vmalloc.c:1840
  __vmalloc_node mm/vmalloc.c:1900 [inline]
  __vmalloc_node_flags mm/vmalloc.c:1914 [inline]
  vzalloc+0x6b/0x90 mm/vmalloc.c:1959
  alloc_counters.isra.0+0x53/0x690 net/ipv6/netfilter/ip6_tables.c:819
  copy_entries_to_user net/ipv4/netfilter/arp_tables.c:674 [inline]
  get_entries net/ipv4/netfilter/arp_tables.c:861 [inline]
  do_arpt_get_ctl+0x4a0/0x820 net/ipv4/netfilter/arp_tables.c:1482
  nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
  nf_getsockopt+0x80/0xe0 net/netfilter/nf_sockopt.c:122
  ip_getsockopt net/ipv4/ip_sockglue.c:1574 [inline]
  ip_getsockopt+0x176/0x1d0 net/ipv4/ip_sockglue.c:1554
  tcp_getsockopt net/ipv4/tcp.c:3623 [inline]
  tcp_getsockopt+0x95/0xf0 net/ipv4/tcp.c:3617
  sock_common_getsockopt+0x9a/0xe0 net/core/sock.c:3089
  __sys_getsockopt+0x168/0x250 net/socket.c:2115
  __do_sys_getsockopt net/socket.c:2126 [inline]
  __se_sys_getsockopt net/socket.c:2123 [inline]
  __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2123
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8152:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3463 [inline]
  kfree+0xcf/0x230 mm/slab.c:3786
  __vunmap+0x704/0x9c0 mm/vmalloc.c:1617
  __vfree+0x41/0xd0 mm/vmalloc.c:1658
  vfree+0x5f/0x90 mm/vmalloc.c:1688
  copy_entries_to_user net/ipv4/netfilter/arp_tables.c:706 [inline]
  get_entries net/ipv4/netfilter/arp_tables.c:861 [inline]
  do_arpt_get_ctl+0x67b/0x820 net/ipv4/netfilter/arp_tables.c:1482
  nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
  nf_getsockopt+0x80/0xe0 net/netfilter/nf_sockopt.c:122
  ip_getsockopt net/ipv4/ip_sockglue.c:1574 [inline]
  ip_getsockopt+0x176/0x1d0 net/ipv4/ip_sockglue.c:1554
  tcp_getsockopt net/ipv4/tcp.c:3623 [inline]
  tcp_getsockopt+0x95/0xf0 net/ipv4/tcp.c:3617
  sock_common_getsockopt+0x9a/0xe0 net/core/sock.c:3089
  __sys_getsockopt+0x168/0x250 net/socket.c:2115
  __do_sys_getsockopt net/socket.c:2126 [inline]
  __se_sys_getsockopt net/socket.c:2123 [inline]
  __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2123
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888098529100
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
  64-byte region [ffff888098529100, ffff888098529140)
The buggy address belongs to the page:
page:ffffea0002614a40 count:1 mapcount:0 mapping:ffff8880aa400340  
index:0xffff888098529600
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002a22fc8 ffffea00026d2888 ffff8880aa400340
raw: ffff888098529600 ffff888098529000 000000010000001b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888098529000: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
  ffff888098529080: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> ffff888098529100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff888098529180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff888098529200: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
