Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB4DF37A9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfKGSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:55:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:53305 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKGSzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:55:11 -0500
Received: by mail-io1-f69.google.com with SMTP id w8so2611446iol.20
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CrOGoLpkQ7edTFXJaYgjIRwF9NvIsDG1DIF9OLeSRgU=;
        b=msHOWa2HiXUFiP2teN9ttrs8v6V6D4+u1XHmTXzahddtJCrTrdumFDYRdpTIw1f9hB
         Hjj70YHfMaC01rLAKXTgSNA4iLe2fi3rJ+Rcgo/O72w+34J/viDLLIsqw+/KYiEtkskP
         gL4vraY91wHiUKIpdy6yW28bHOJ4Z5LpsiiQsvpTJ293ZupRDXM3KlLuSD+yCWFgKZzV
         n64/B2FVwrISZMqHo+1943Cxem+SVPjBkwXeaskz59mGOtA+tq/Ob8H4/agZxq0+qJHg
         RhwFB+j7OrrMb0/WZvNi3IuK5eFo1RVW4+Z94rONj3tzHHc1T3bbIpN3P4AWtPvOlEJ0
         RApg==
X-Gm-Message-State: APjAAAWOy2VybwSok7mforbPAgQ1wPlN84qF2QXwMbLOsLMhLLOYHnF9
        5kl36AFBlQ9wLyZr+SOEP07SQUKPKvXRz9qdFWmuATZVoKGd
X-Google-Smtp-Source: APXvYqy9T0uOUbjvUKq32W8sfGCq7RmnOHgddJurrEAce23apz1kVdNIWzPQYweYYrOKwQcSwgELG7ztymtwYMzR0LRR86KjnFl7
MIME-Version: 1.0
X-Received: by 2002:a92:3651:: with SMTP id d17mr6511423ilf.268.1573152909219;
 Thu, 07 Nov 2019 10:55:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 10:55:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054e19d0596c63465@google.com>
Subject: KCSAN: data-race in pcpu_alloc / pcpu_free_area (2)
From:   syzbot <syzbot+0b3bfb9cbec193033650@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, elver@google.com,
        fw@strlen.de, kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    05f22368 x86, kcsan: Enable KCSAN for x86
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=17f9952f600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87d111955f40591f
dashboard link: https://syzkaller.appspot.com/bug?extid=0b3bfb9cbec193033650
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0b3bfb9cbec193033650@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_bridge: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
==================================================================
BUG: KCSAN: data-race in pcpu_alloc / pcpu_free_area

write to 0xffffffff86046740 of 4 bytes by task 7371 on cpu 0:
  pcpu_update_empty_pages mm/percpu.c:575 [inline]
  pcpu_block_update_hint_free mm/percpu.c:1012 [inline]
  pcpu_free_area+0x448/0x6a0 mm/percpu.c:1267
  free_percpu mm/percpu.c:1975 [inline]
  free_percpu+0x152/0x440 mm/percpu.c:1955
  xt_percpu_counter_free+0x82/0xa0 net/netfilter/x_tables.c:1862
  cleanup_entry+0x12a/0x160 net/ipv6/netfilter/ip6_tables.c:672
  __do_replace+0x439/0x510 net/ipv6/netfilter/ip6_tables.c:1102
  do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
  do_ip6t_set_ctl+0x26d/0x311 net/ipv6/netfilter/ip6_tables.c:1681
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x6e/0xb0 net/netfilter/nf_sockopt.c:115
  ipv6_setsockopt net/ipv6/ipv6_sockglue.c:949 [inline]
  ipv6_setsockopt+0x119/0x130 net/ipv6/ipv6_sockglue.c:933
  tcp_setsockopt net/ipv4/tcp.c:3148 [inline]
  tcp_setsockopt+0x7c/0xc0 net/ipv4/tcp.c:3142
  sock_common_setsockopt+0x67/0x90 net/core/sock.c:3147
  __sys_setsockopt+0x1ce/0x370 net/socket.c:2084
  __do_sys_setsockopt net/socket.c:2100 [inline]
  __se_sys_setsockopt net/socket.c:2097 [inline]
  __x64_sys_setsockopt+0x70/0x90 net/socket.c:2097
  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffffffff86046740 of 4 bytes by task 44 on cpu 1:
  pcpu_alloc+0x3b0/0xcf0 mm/percpu.c:1729
  __alloc_percpu_gfp+0x31/0x50 mm/percpu.c:1783
  fib_nh_common_init+0x58/0x1e0 net/ipv4/fib_semantics.c:572
  fib6_nh_init+0x2aa/0xee0 net/ipv6/route.c:3466
  ip6_route_info_create+0x913/0xd40 net/ipv6/route.c:3655
  ip6_route_add+0x30/0xd0 net/ipv6/route.c:3695
  addrconf_add_mroute+0x177/0x1a0 net/ipv6/addrconf.c:2459
  addrconf_add_dev+0x100/0x170 net/ipv6/addrconf.c:2477
  addrconf_dev_config+0x170/0x280 net/ipv6/addrconf.c:3351
  addrconf_notify+0x1fa/0x1480 net/ipv6/addrconf.c:3595
  notifier_call_chain+0xd7/0x160 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x37/0x50 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x48/0xc0 net/core/dev.c:1749

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 44 Comm: kworker/1:1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events linkwatch_event
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
