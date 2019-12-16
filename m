Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE39121981
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfLPSzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:55:18 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:35454 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLPSzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:55:10 -0500
Received: by mail-il1-f200.google.com with SMTP id t15so7242499ilh.2
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QhybUPK5dBxJRNVhNZp635X6gV1GXZrb9PVTVcRMOV0=;
        b=o122dpOaGinaLhBcM2NT71TzCUZrQmyQQrKTPCNrQr5diXnlp5OYOv3o81FRmtc2uj
         6DC7piE5dTm62dbwiNhcI3UwX1382OV9xKW+5X3MOPtVng42ObVFxppKbSU+KKo8SWjo
         bncj9/VMpN1cO/0QrCAgT0M6ZBUwQ+SgNCgquayIoBpmTJgnpZswWXPHqT/jXvm3sJrb
         jFC0RcRm6Of3/HxaxpVtKzCXYWf0ygOLCsPrLaPhEdctJmdkiqPT72HuFuQPy2fkmnAI
         FvJ71P2E4u5nFejVJHkve7rvcjPljiOV49YQ8jI3s9e85AeHFWiEgJUc3Qe8oLu+FZFK
         KoXg==
X-Gm-Message-State: APjAAAXXp6RGHMBENayWZwh0q4gNAfc+y/rKoaBnQ6YhdjLs+I/Ew02D
        vHZ56mlEg/7Atauo05nyvlLo3qqb5ypgphkpE9tl9jWYPrvz
X-Google-Smtp-Source: APXvYqxL9sLrdmkQsKbPzrqZeGTCbaPmI/H5FdoSBqDnHKRDPR2hKKG8X++2ls4MeEZntVP9IxrexO00M8AAnRF/wVW0oYPB0bX2
MIME-Version: 1.0
X-Received: by 2002:a92:1699:: with SMTP id 25mr2541404ilw.234.1576522509519;
 Mon, 16 Dec 2019 10:55:09 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:55:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000292dd60599d6c001@google.com>
Subject: memory leak in _sctp_make_chunk
From:   syzbot <syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    07c4b9e9 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b03f96e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf3a35184a3ed64
dashboard link: https://syzkaller.appspot.com/bug?extid=107c4aff5f392bf1517f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144935a6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176c2361e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 29.950s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 29.950s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 29.950s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.020s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.020s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.020s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.090s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.090s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.090s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.160s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.160s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.160s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.230s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.230s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.230s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.300s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.300s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.300s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.370s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.370s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.370s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111bd0700 (size 224):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.440s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 c0 4c 53 11 81 88 ff ff  .........LS.....
   backtrace:
     [<00000000912cc8e3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000912cc8e3>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000912cc8e3>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000912cc8e3>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3575
     [<0000000010c4e31e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888111eabc00 (size 512):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.440s)
   hex dump (first 32 bytes):
     07 00 00 08 3c 2d 00 1e 2b 00 00 00 31 31 3a 30  ....<-..+...11:0
     39 3a 32 36 23 20 70 72 6f 66 69 6c 65 3d 30 20  9:26# profile=0
   backtrace:
     [<00000000f3daff16>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f3daff16>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000f3daff16>] slab_alloc_node mm/slab.c:3263 [inline]
     [<00000000f3daff16>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3593
     [<000000001eece319>] __do_kmalloc_node mm/slab.c:3615 [inline]
     [<000000001eece319>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3630
     [<00000000c6ac598b>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000879c0222>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000c69717ec>] alloc_skb include/linux/skbuff.h:1049 [inline]
     [<00000000c69717ec>] _sctp_make_chunk+0x51/0x120  
net/sctp/sm_make_chunk.c:1394
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888111b9f700 (size 256):
   comm "syz-executor974", pid 7118, jiffies 4294954926 (age 30.440s)
   hex dump (first 32 bytes):
     00 f7 b9 11 81 88 ff ff 00 f7 b9 11 81 88 ff ff  ................
     01 00 00 00 00 00 00 00 18 f7 b9 11 81 88 ff ff  ................
   backtrace:
     [<000000005dbe2b50>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005dbe2b50>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005dbe2b50>] slab_alloc mm/slab.c:3320 [inline]
     [<000000005dbe2b50>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3484
     [<000000001d5acae3>] kmem_cache_zalloc include/linux/slab.h:660 [inline]
     [<000000001d5acae3>] sctp_chunkify+0x2c/0xa0  
net/sctp/sm_make_chunk.c:1332
     [<00000000ada5bf03>] _sctp_make_chunk+0xb0/0x120  
net/sctp/sm_make_chunk.c:1405
     [<0000000098c40eef>] sctp_make_control net/sctp/sm_make_chunk.c:1441  
[inline]
     [<0000000098c40eef>] sctp_make_shutdown+0x4c/0xc0  
net/sctp/sm_make_chunk.c:864
     [<0000000019ed61c1>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1435  
[inline]
     [<0000000019ed61c1>] sctp_side_effects net/sctp/sm_sideeffect.c:1189  
[inline]
     [<0000000019ed61c1>] sctp_do_sm+0xf4f/0x1da0  
net/sctp/sm_sideeffect.c:1160
     [<00000000c34b32c2>] sctp_assoc_bh_rcv+0x166/0x250  
net/sctp/associola.c:1045
     [<00000000fdcbee1b>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:80
     [<000000002b119f75>] sctp_backlog_rcv+0x84/0x3d0 net/sctp/input.c:344
     [<00000000ad5696f2>] sk_backlog_rcv include/net/sock.h:949 [inline]
     [<00000000ad5696f2>] __release_sock+0xab/0x110 net/core/sock.c:2437
     [<00000000a7bc65ae>] release_sock+0x37/0xd0 net/core/sock.c:2953
     [<00000000c411aefa>] inet_shutdown+0xa8/0x150 net/ipv4/af_inet.c:898
     [<00000000b8775f62>] __sys_shutdown+0x68/0xb0 net/socket.c:2193
     [<000000003f1a0d0e>] __do_sys_shutdown net/socket.c:2201 [inline]
     [<000000003f1a0d0e>] __se_sys_shutdown net/socket.c:2199 [inline]
     [<000000003f1a0d0e>] __x64_sys_shutdown+0x1a/0x20 net/socket.c:2199
     [<000000007a408433>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<0000000017fd31b8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
