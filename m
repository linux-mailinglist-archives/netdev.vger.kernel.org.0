Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325CB3DC017
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhG3VI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:08:26 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39793 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhG3VIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:08:25 -0400
Received: by mail-io1-f69.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so6560404iot.6
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ezra53fJ9ovAmRTj95ODS6/rqWMOlHrXy6SIWRBmIqE=;
        b=Rp7Xi3cPPSJm18Q3fwpRVh4+RqZSwNA6FN3qUNAvyejHGRMq0p91ZA5W3PpI0Tgc2T
         Np26U++kQy6qpLofB8zq6XCMXIAtm2w9o26+zQbM25qBH0mDPwN47fWHRtUht/phz6i2
         SGtLcYNYvUGO7huU+Qx0dSDodorW7s+YtsI3n55fi/DtLtUY6UIQuSBxJoaqFzaxvywv
         uKKf7zgyhJcMwXOyG7uO2jfJ5kcw9rfPbGUhwHJQx+SPs91fbIZRpHBmWRSQ/xRhJmDh
         2jCL6Hr011aO/2qk1qaDRq4gHSihUmuzdIDZRGmPCIOcHf8hxvBJbunyh2v1MFDFy3FT
         HnHA==
X-Gm-Message-State: AOAM533eUvUMx7m6qdrSOEQfyiP6y8d1qnqCWF+skbA0ROvmFB629mSA
        GOl8HqJeKZ1AwCYbC4DJ/ehrz86EZRRRHKPX+iGIrSP6Rqef
X-Google-Smtp-Source: ABdhPJzl08nsf9LL1ms/XQOCdeiQ4I7sbo+awGg/+z9Et9Oq1oKi4pYR8FCGVHO56f5YYDc81cqWZ6nYq9ZQwmg9hDW9qmW4WLrc
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:528:: with SMTP id h8mr2849385ils.223.1627679300353;
 Fri, 30 Jul 2021 14:08:20 -0700 (PDT)
Date:   Fri, 30 Jul 2021 14:08:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008183f605c85d9e9c@google.com>
Subject: [syzbot] memory leak in packet_sendmsg
From:   syzbot <syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tannerlove@google.com,
        willemb@google.com, xie.he.0141@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff1176468d36 Linux 5.14-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15057fa2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ebfe83ba9ca8666
dashboard link: https://syzkaller.appspot.com/bug?extid=989efe781c74de1ddb54
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e54382300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com

2021/07/26 20:48:07 executed programs: 1
2021/07/26 20:48:13 executed programs: 3
2021/07/26 20:48:19 executed programs: 5
BUG: memory leak
unreferenced object 0xffff88810f41be00 (size 232):
  comm "dhclient", pid 4908, jiffies 4294938558 (age 1092.590s)
  hex dump (first 32 bytes):
    a0 6c 13 19 81 88 ff ff a0 6c 13 19 81 88 ff ff  .l.......l......
    00 00 83 1a 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff836e1e8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff836ec6ba>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff836ec6ba>] alloc_skb_with_frags+0x6a/0x2b0 net/core/skbuff.c:6019
    [<ffffffff836d9fa3>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2461
    [<ffffffff83bf47a2>] packet_alloc_skb net/packet/af_packet.c:2864 [inline]
    [<ffffffff83bf47a2>] packet_snd net/packet/af_packet.c:2959 [inline]
    [<ffffffff83bf47a2>] packet_sendmsg+0xbd2/0x2500 net/packet/af_packet.c:3044
    [<ffffffff836d0b46>] sock_sendmsg_nosec net/socket.c:703 [inline]
    [<ffffffff836d0b46>] sock_sendmsg+0x56/0x80 net/socket.c:723
    [<ffffffff836d0c67>] sock_write_iter+0xf7/0x180 net/socket.c:1056
    [<ffffffff81564527>] call_write_iter include/linux/fs.h:2114 [inline]
    [<ffffffff81564527>] new_sync_write+0x1d7/0x2b0 fs/read_write.c:518
    [<ffffffff81567ba1>] vfs_write+0x351/0x400 fs/read_write.c:605
    [<ffffffff81567f1b>] ksys_write+0x12b/0x160 fs/read_write.c:658
    [<ffffffff843b18b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843b18b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8881019ce500 (size 232):
  comm "kworker/1:1", pid 35, jiffies 4294938559 (age 1092.580s)
  hex dump (first 32 bytes):
    a0 d4 28 19 81 88 ff ff a0 d4 28 19 81 88 ff ff  ..(.......(.....
    00 00 cb 03 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff836e1e8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff836ec6ba>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff836ec6ba>] alloc_skb_with_frags+0x6a/0x2b0 net/core/skbuff.c:6019
    [<ffffffff836d9fa3>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2461
    [<ffffffff83b812d4>] mld_newpack+0x84/0x200 net/ipv6/mcast.c:1751
    [<ffffffff83b814f3>] add_grhead+0xa3/0xc0 net/ipv6/mcast.c:1854
    [<ffffffff83b82196>] add_grec+0x7b6/0x820 net/ipv6/mcast.c:1992
    [<ffffffff83b84643>] mld_send_cr net/ipv6/mcast.c:2118 [inline]
    [<ffffffff83b84643>] mld_ifc_work+0x273/0x750 net/ipv6/mcast.c:2655
    [<ffffffff81262669>] process_one_work+0x2c9/0x610 kernel/workqueue.c:2276
    [<ffffffff81262f59>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2422
    [<ffffffff8126c3b8>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff88810f41b300 (size 232):
  comm "kworker/1:1", pid 35, jiffies 4294938624 (age 1091.930s)
  hex dump (first 32 bytes):
    a0 ac 3f 19 81 88 ff ff a0 ac 3f 19 81 88 ff ff  ..?.......?.....
    00 00 cb 03 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff836e1e8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff83b6d076>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff83b6d076>] ndisc_alloc_skb+0x56/0xe0 net/ipv6/ndisc.c:420
    [<ffffffff83b7183a>] ndisc_send_ns+0xba/0x2f0 net/ipv6/ndisc.c:626
    [<ffffffff83b48b13>] addrconf_dad_work+0x643/0x900 net/ipv6/addrconf.c:4119
    [<ffffffff81262669>] process_one_work+0x2c9/0x610 kernel/workqueue.c:2276
    [<ffffffff81262f59>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2422
    [<ffffffff8126c3b8>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff88810dd97600 (size 232):
  comm "softirq", pid 0, jiffies 4294938659 (age 1091.580s)
  hex dump (first 32 bytes):
    a0 fc fb 16 81 88 ff ff a0 fc fb 16 81 88 ff ff  ................
    00 c0 84 03 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff836e1e8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff839f1aff>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff839f1aff>] __ip_append_data+0x12cf/0x1510 net/ipv4/ip_output.c:1109
    [<ffffffff839f429d>] ip_append_data net/ipv4/ip_output.c:1327 [inline]
    [<ffffffff839f429d>] ip_append_data net/ipv4/ip_output.c:1306 [inline]
    [<ffffffff839f429d>] ip_send_unicast_reply+0x33d/0x550 net/ipv4/ip_output.c:1718
    [<ffffffff83a33e6f>] tcp_v4_send_reset+0x3df/0x980 net/ipv4/tcp_ipv4.c:818
    [<ffffffff83a37442>] tcp_v4_rcv+0xf22/0x1620 net/ipv4/tcp_ipv4.c:2116
    [<ffffffff839e99b2>] ip_protocol_deliver_rcu+0x22/0x2c0 net/ipv4/ip_input.c:204
    [<ffffffff839e9cc1>] ip_local_deliver_finish+0x71/0x90 net/ipv4/ip_input.c:231
    [<ffffffff839e9e33>] NF_HOOK include/linux/netfilter.h:307 [inline]
    [<ffffffff839e9e33>] NF_HOOK include/linux/netfilter.h:301 [inline]
    [<ffffffff839e9e33>] ip_local_deliver+0x153/0x160 net/ipv4/ip_input.c:252
    [<ffffffff839e9016>] dst_input include/net/dst.h:458 [inline]
    [<ffffffff839e9016>] ip_sublist_rcv_finish+0x76/0x90 net/ipv4/ip_input.c:551
    [<ffffffff839e9723>] ip_list_rcv_finish net/ipv4/ip_input.c:601 [inline]
    [<ffffffff839e9723>] ip_sublist_rcv+0x293/0x340 net/ipv4/ip_input.c:609
    [<ffffffff839ea126>] ip_list_rcv+0x1c6/0x1f0 net/ipv4/ip_input.c:644
    [<ffffffff83713f01>] __netif_receive_skb_list_ptype net/core/dev.c:5541 [inline]
    [<ffffffff83713f01>] __netif_receive_skb_list_core+0x2b1/0x360 net/core/dev.c:5589
    [<ffffffff83714305>] __netif_receive_skb_list net/core/dev.c:5641 [inline]
    [<ffffffff83714305>] netif_receive_skb_list_internal+0x355/0x4a0 net/core/dev.c:5751
    [<ffffffff83715d52>] gro_normal_list net/core/dev.c:5905 [inline]
    [<ffffffff83715d52>] gro_normal_list net/core/dev.c:5901 [inline]
    [<ffffffff83715d52>] napi_complete_done+0xe2/0x2e0 net/core/dev.c:6627
    [<ffffffff828eb89d>] virtqueue_napi_complete drivers/net/virtio_net.c:337 [inline]
    [<ffffffff828eb89d>] virtnet_poll+0x52d/0x6a0 drivers/net/virtio_net.c:1546
    [<ffffffff83715f8d>] __napi_poll+0x3d/0x290 net/core/dev.c:7047



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
