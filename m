Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BEEF5041
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKHPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:54:12 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:55701 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfKHPyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:54:12 -0500
Received: by mail-il1-f200.google.com with SMTP id n81so7231701ili.22
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 07:54:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=s332cRTbvTcjjlLB46ZkzaXl2NaFeaIwaT6ESHp+Drs=;
        b=ciNAFEa3qSzbxBypooSBlEap89+63LxiYIJ5l8xK8LnKw7gB5rMRSbra9An+FRqFOK
         wA/HoR4aT8gd3tHCfosI5gzHL7DucTc+RuriyP0soIaIhhLrcAanCm52SfKnov82yUfU
         F+vxoyYIv3PbPbbLOGK4yF6HuKEvwrZBAjUyPav7FTNE4KYkRGfJJiaCY0/PPqMqXH21
         X/HiuSvHd8329ImRn0REuumrqIA1fT7QuTTT4yOd/3B1blsriTxwdGJFye5ZnfC+U2ZZ
         5dHWNuBmg3xCwchFySSqIyTFy4bRglvFRSdshBIEPcCHBP9fr/eNH0b6DnK6jHVLiLOC
         guDw==
X-Gm-Message-State: APjAAAWLIZq7PSiiosmf0mrI8IzJdOKHHKbz2VW3Vkzn6Op7EdIDEYGb
        dXqyCIH3QWs4JrMkHgM+yybBDxBy6RPMqVmLzmkd2LkgajVw
X-Google-Smtp-Source: APXvYqzIc8qMPr+vhqnH6XJzsuF/upi1JbflEe2c6XqHSfDW5wG+XIWeG4APhbntX+YnhLgNg8sgrdIAAI6g8fUnSF9koOM5NU/M
MIME-Version: 1.0
X-Received: by 2002:a02:9641:: with SMTP id c59mr11764083jai.40.1573228449602;
 Fri, 08 Nov 2019 07:54:09 -0800 (PST)
Date:   Fri, 08 Nov 2019 07:54:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3a8e00596d7ca32@google.com>
Subject: KMSAN: uninit-value in kernel_sendmsg
From:   syzbot <syzbot+4b6f070bb7a8ea5420d4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, glider@google.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    124037e0 kmsan: drop inlines, rename do_kmsan_task_create()
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1648eb9d600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
dashboard link: https://syzkaller.appspot.com/bug?extid=4b6f070bb7a8ea5420d4
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4b6f070bb7a8ea5420d4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in rxrpc_send_keepalive+0x2fa/0x830  
net/rxrpc/output.c:655
CPU: 0 PID: 3367 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  kernel_sendmsg+0x2c9/0x440 net/socket.c:677
  rxrpc_send_keepalive+0x2fa/0x830 net/rxrpc/output.c:655
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
  rxrpc_peer_keepalive_worker+0xb82/0x1510 net/rxrpc/peer_event.c:430
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
  kmsan_internal_poison_shadow+0x53/0x100 mm/kmsan/kmsan.c:134
  kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:103
  slab_alloc_node mm/slub.c:2790 [inline]
  slab_alloc mm/slub.c:2799 [inline]
  kmem_cache_alloc_trace+0x8c5/0xd20 mm/slub.c:2816
  kmalloc include/linux/slab.h:552 [inline]
  __hw_addr_create_ex net/core/dev_addr_lists.c:30 [inline]
  __hw_addr_add_ex net/core/dev_addr_lists.c:76 [inline]
  __hw_addr_add net/core/dev_addr_lists.c:84 [inline]
  dev_addr_init+0x152/0x700 net/core/dev_addr_lists.c:464
  alloc_netdev_mqs+0x2a9/0x1650 net/core/dev.c:9150
  rtnl_create_link+0x559/0x1190 net/core/rtnetlink.c:2931
  __rtnl_newlink net/core/rtnetlink.c:3186 [inline]
  rtnl_newlink+0x2757/0x38d0 net/core/rtnetlink.c:3254
  rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
