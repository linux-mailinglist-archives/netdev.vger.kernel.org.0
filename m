Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504721B21B9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgDUIcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:32:22 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40717 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgDUIcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:32:17 -0400
Received: by mail-io1-f69.google.com with SMTP id k4so15756556ios.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 01:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zs84KBEwoiZzkV1elKVL+hbmgxjHFsJTU0rQsqKvHXI=;
        b=GzaUWYIuZt6oldzFtF+07ctbZhqWslweGS8MIE/dmn+NChFqhdJiEUHycaxwnYyKuC
         YXM3u19pPPR2l2e/i0ZJdWoPutblgv/bEN2tnEyL8vPvaf05KL/PbzafsGJV9pDt+1Td
         pQIdW8IiBhfRLjUvh0NqmZfQVoNwdCQvkNcuSS20V4aFc1P7Ehel/CcsobDthucjZvLj
         5kiYZvv1rI4ihYoor/MXOR5A74Id0qpowPrgEdaNTy1h9EQHekXArCYMTZ+uyLYHhSn4
         vI5TDaAsy9Hjec0Tg4xlYPLtc+jXFTPrS2/GQOPEjToRnQYkhdhGoW2WswCF8P3Q8T8/
         h4KA==
X-Gm-Message-State: AGi0PuYoZ5t/wn/DPEsvE/1ecwFf8WMk7RGysSvVxMJi7c3EnNmUIZ2+
        019oxiGU+J7/eQsBO4D8rMTJlmmlWl9CXahoRQEpPvLMnyJz
X-Google-Smtp-Source: APiQypKbOIUrFb9qrng3wMsLHSMTLqFjQBl+iGMmoxvU59LaHBteEJbzFgORJpiKt97KWVuMHSgrQbUQU9k33E9Jshh1AfeeoUuj
MIME-Version: 1.0
X-Received: by 2002:a92:8f94:: with SMTP id r20mr19481956ilk.220.1587457934821;
 Tue, 21 Apr 2020 01:32:14 -0700 (PDT)
Date:   Tue, 21 Apr 2020 01:32:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d0f6905a3c8daff@google.com>
Subject: KASAN: use-after-free Read in veth_xmit
From:   syzbot <syzbot+25b0a550077446957f19@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, toshiaki.makita1@gmail.com,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    50cc09c1 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153684bbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
dashboard link: https://syzkaller.appspot.com/bug?extid=25b0a550077446957f19
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+25b0a550077446957f19@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:199 [inline]
BUG: KASAN: use-after-free in veth_xmit+0x84e/0x8a0 drivers/net/veth.c:303
Read of size 8 at addr ffff8880001c1190 by task kworker/u4:5/7840

CPU: 0 PID: 7840 Comm: kworker/u4:5 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 __read_once_size include/linux/compiler.h:199 [inline]
 veth_xmit+0x84e/0x8a0 drivers/net/veth.c:303
 __netdev_start_xmit include/linux/netdevice.h:4533 [inline]
 netdev_start_xmit include/linux/netdevice.h:4547 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x1a4/0x9b0 net/core/dev.c:3493
 __dev_queue_xmit+0x25e1/0x30a0 net/core/dev.c:4052
 batadv_send_skb_packet+0x4a9/0x5f0 net/batman-adv/send.c:108
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x693/0x7c0 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 7188:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 __kmalloc_reserve.isra.0+0x39/0xe0 net/core/skbuff.c:142
 __alloc_skb+0xef/0x5a0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1133 [inline]
 sk_stream_alloc_skb net/ipv4/tcp.c:876 [inline]
 sk_stream_alloc_skb+0x106/0xc70 net/ipv4/tcp.c:853
 tcp_sendmsg_locked+0xcb0/0x3210 net/ipv4/tcp.c:1283
 tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1433
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write+0x4a2/0x700 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x1ee/0x250 fs/read_write.c:612
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 7188:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 skb_free_head+0x8b/0xa0 net/core/skbuff.c:590
 skb_release_data+0x42e/0x8b0 net/core/skbuff.c:610
 skb_release_all+0x46/0x60 net/core/skbuff.c:664
 __kfree_skb+0x11/0x20 net/core/skbuff.c:678
 sk_wmem_free_skb include/net/sock.h:1530 [inline]
 tcp_rtx_queue_unlink_and_free include/net/tcp.h:1842 [inline]
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3169 [inline]
 tcp_ack+0x1c01/0x5830 net/ipv4/tcp_input.c:3696
 tcp_rcv_established+0x174a/0x1d90 net/ipv4/tcp_input.c:5644
 tcp_v4_do_rcv+0x605/0x8b0 net/ipv4/tcp_ipv4.c:1621
 sk_backlog_rcv include/net/sock.h:996 [inline]
 __release_sock+0x134/0x3a0 net/core/sock.c:2460
 release_sock+0x54/0x1b0 net/core/sock.c:2976
 tcp_sendmsg+0x36/0x40 net/ipv4/tcp.c:1434
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write+0x4a2/0x700 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x1ee/0x250 fs/read_write.c:612
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff8880001c1000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 400 bytes inside of
 1024-byte region [ffff8880001c1000, ffff8880001c1400)
The buggy address belongs to the page:
page:ffffea0000007040 refcount:1 mapcount:0 mapping:00000000e97284cd index:0x0
flags: 0x7ffe0000000200(slab)
raw: 007ffe0000000200 ffffea0000edb7c8 ffffea0001bc84c8 ffff8880aa000c40
raw: 0000000000000000 ffff8880001c1000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880001c1080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880001c1100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880001c1180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880001c1200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880001c1280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
