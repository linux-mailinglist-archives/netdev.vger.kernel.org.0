Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D58371E56
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhECRVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:21:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52971 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhECRVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 13:21:14 -0400
Received: by mail-il1-f198.google.com with SMTP id s2-20020a056e0210c2b0290196bac26c2cso5025617ilj.19
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 10:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IaLwSAlCAkwIV8aH0MiazbmbvKJrXYiGrbTABtoSizM=;
        b=kEtsZ1B9mxZ1sfzBHoO4SNfUpg1+1UfQixjPkb2K+GtzD1X1/A7lYs4v5TFZeiUSnd
         ginTqjt/Ui7SzYunJg3ND2V7yDmClyidiXLFYvUpqpFfuD3GwuGH2zJoBGmNn7l4qi5h
         7uW24SM0+uK+SU2OvtmBMHKlCrb7yWL9ic3pAZA3NRItDu1CsxXXcKygldVl3oHWyGFC
         uIrx9DvMVyFUYRn9+3Ch0wxcdrBwD/ylgcIKb/J76O4TNrGCgVxq1FqcQfr36UeOl7pC
         EEi5LhAAbzbQSPtrbVFjoLWrkCh4IEBuGHuL4nzvVKY/ELuQJZGFaI50LHG4X35npXQ6
         HueA==
X-Gm-Message-State: AOAM531oU9Vxwwuss/Ts8PNyE/kxycWEr+WaGj8IX9J3YNswJEwp/oKS
        2ODqg7jKWMW55adKkzr1JA2rOp+MaIcwffWH84zzaEXhk6Iy
X-Google-Smtp-Source: ABdhPJycz2XLkjHbhliGqjnXWzI80M9F9/U/yrCPQrUHd/RWsJNFOEtVW6fNfObLWwqF1WZmXG5iTwuW758ynXb4g6INmQQNSaCo
MIME-Version: 1.0
X-Received: by 2002:a92:c005:: with SMTP id q5mr16225105ild.202.1620062420942;
 Mon, 03 May 2021 10:20:20 -0700 (PDT)
Date:   Mon, 03 May 2021 10:20:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d488205c1702d78@google.com>
Subject: [syzbot] memory leak in nf_hook_entries_grow (2)
From:   syzbot <syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9ccce092 Merge tag 'for-linus-5.13-ofs-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=141aec93d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ab124e5617a0cfa
dashboard link: https://syzkaller.appspot.com/bug?extid=050de9f900eb45b94ef9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bd921ed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888128e8efc0 (size 64):
  comm "syz-executor.1", pid 8445, jiffies 4294969756 (age 19.530s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 8a a5 83 ff ff ff ff  ................
    00 f6 f4 27 81 88 ff ff 00 40 5a 28 81 88 ff ff  ...'.....@Z(....
  backtrace:
    [<ffffffff8146e301>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146e301>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381be3b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381be3b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381be3b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381be3b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381c19d>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381c45f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381c4f9>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a56452>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a58a7d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838b85a9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838b86d7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a575b2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a57b34>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff8381e3b7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff83986b9a>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff83986b9a>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399b06b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366dc23>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366de02>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366de02>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366de02>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff888128f2fb80 (size 64):
  comm "syz-executor.1", pid 8445, jiffies 4294969756 (age 19.530s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 8a a5 83 ff ff ff ff  ................
    00 f6 f4 27 81 88 ff ff 50 40 5a 28 81 88 ff ff  ...'....P@Z(....
  backtrace:
    [<ffffffff8146e301>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146e301>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381be3b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381be3b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381be3b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381be3b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381c19d>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381c45f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381c4f9>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a56452>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a58a7d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838b85a9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838b86d7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a575b2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a57b34>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff8381e3b7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff83986b9a>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff83986b9a>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399b06b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366dc23>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366de02>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366de02>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366de02>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88812249b100 (size 64):
  comm "kworker/u4:1", pid 24, jiffies 4294970575 (age 11.350s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 8a a5 83 ff ff ff ff  ................
    00 f6 f4 27 81 88 ff ff 28 40 5a 28 81 88 ff ff  ...'....(@Z(....
  backtrace:
    [<ffffffff8146e301>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146e301>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381b1ad>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381b1ad>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381b1ad>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381b1ad>] __nf_hook_entries_try_shrink+0xfd/0x210 net/netfilter/core.c:248
    [<ffffffff8381b96b>] __nf_unregister_net_hook+0x17b/0x280 net/netfilter/core.c:483
    [<ffffffff8381baf2>] nf_unregister_net_hook+0x82/0xb0 net/netfilter/core.c:502
    [<ffffffff8368fca1>] ops_exit_list+0x41/0x80 net/core/net_namespace.c:175
    [<ffffffff83690861>] cleanup_net+0x2c1/0x4d0 net/core/net_namespace.c:595
    [<ffffffff8125e109>] process_one_work+0x2c9/0x600 kernel/workqueue.c:2275
    [<ffffffff8125e9f9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2421
    [<ffffffff81266268>] kthread+0x178/0x1b0 kernel/kthread.c:313
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
