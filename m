Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589D0239BFB
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHBUqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:46:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:43768 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbgHBUqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:46:21 -0400
Received: by mail-il1-f199.google.com with SMTP id f131so4965062ilh.10
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UR/ZO0hH6TY23jTg0tEYuIZyHB35kzhpcW94c67p/IY=;
        b=YMwFtS02E7HUoYcZrjs29sUv8m/yyfDcjBG0QP37/uFDMLSpmYrx8dvPCnClbASCxh
         yB8zECReKTKiLmTklU7CTuIAelrYyD9uxAe+M25N9yUHp0cNui63l5R6gzv6r7Ojo6Ux
         mhrpo9xIgmTQsFeJqQJrLPRExC5bsE+Mho67MCd3Ye9pLZIk91qxBDzw/ey5K9guBJGi
         4N2xRbGw1WzFNDNWq3W4NeqiSRrlOHuT6H8L9b3fQJ9behYBhKJwoKZxTosZ3OYag+K5
         G9BbsFfufeDls2stM/7LsR4Okorq50DnfcmiYxGHf+aq8vt+3jRFSWlgOIogXDnKlMZx
         xjyQ==
X-Gm-Message-State: AOAM531UZYJ2ctXNHvIF0PwvZ3xzNbBvKEwPTTiMs5dwGJzK1Zn5ZsNA
        D2FazAgMAp9sRjZ/k4muZpHnrCkq8jPayT9Jp2PiAbTiak8x
X-Google-Smtp-Source: ABdhPJz7QroLRzfyvDXIacdc4voPN0fxMrySmyqn0CFftkCfYMBM0YQGazUDxAJijzwoaYNvZzDHqwqhpHTS867zlK7eYtmTskSB
MIME-Version: 1.0
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr13874575iob.186.1596401179781;
 Sun, 02 Aug 2020 13:46:19 -0700 (PDT)
Date:   Sun, 02 Aug 2020 13:46:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003d6e8405abeb1da7@google.com>
Subject: KASAN: use-after-free Read in hci_send_acl
From:   syzbot <syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13482904900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=98228e7407314d2d4ba2
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152f1904900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1482dfca900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in hci_send_acl+0xabe/0xc60 net/bluetooth/hci_core.c:3991
Read of size 8 at addr ffff8880a6ff8818 by task kworker/u5:2/6855

CPU: 1 PID: 6855 Comm: kworker/u5:2 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 hci_send_acl+0xabe/0xc60 net/bluetooth/hci_core.c:3991
 l2cap_send_cmd+0x6d5/0x8a0 net/bluetooth/l2cap_core.c:949
 l2cap_send_move_chan_cfm_icid net/bluetooth/l2cap_core.c:4917 [inline]
 l2cap_move_fail net/bluetooth/l2cap_core.c:5401 [inline]
 l2cap_move_channel_rsp net/bluetooth/l2cap_core.c:5440 [inline]
 l2cap_bredr_sig_cmd net/bluetooth/l2cap_core.c:5719 [inline]
 l2cap_sig_channel net/bluetooth/l2cap_core.c:6418 [inline]
 l2cap_recv_frame+0x6936/0xae10 net/bluetooth/l2cap_core.c:7660
 l2cap_recv_acldata+0x7f6/0x8e0 net/bluetooth/l2cap_core.c:8313
 hci_acldata_packet net/bluetooth/hci_core.c:4520 [inline]
 hci_rx_work+0x4c7/0xb10 net/bluetooth/hci_core.c:4710
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6855:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_chan_create+0x9b/0x330 net/bluetooth/hci_conn.c:1692
 l2cap_conn_add.part.0+0x1e/0xe10 net/bluetooth/l2cap_core.c:7699
 l2cap_conn_add net/bluetooth/l2cap_core.c:8139 [inline]
 l2cap_connect_cfm+0x23b/0x1090 net/bluetooth/l2cap_core.c:8097
 hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
 hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
 hci_event_packet+0x3e01/0x86f5 net/bluetooth/hci_event.c:6061
 hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Freed by task 6855:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
 hci_event_packet+0x319a/0x86f5 net/bluetooth/hci_event.c:6188
 hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880a6ff8800
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 24 bytes inside of
 128-byte region [ffff8880a6ff8800, ffff8880a6ff8880)
The buggy address belongs to the page:
page:ffffea00029bfe00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a6ff8c00
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002934388 ffff8880aa001540 ffff8880aa000700
raw: ffff8880a6ff8c00 ffff8880a6ff8000 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a6ff8700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a6ff8780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a6ff8800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880a6ff8880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a6ff8900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
