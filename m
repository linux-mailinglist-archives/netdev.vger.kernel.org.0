Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3A1D862B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbgERSXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:23:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:43922 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgERSXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:23:19 -0400
Received: by mail-il1-f199.google.com with SMTP id v14so10637559ilm.10
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VE/q/zOb79YRe/blnUpKKcdAGP9yqe5NK3iFhMeczSs=;
        b=FWtS0w1Q3jPS89aCkGt1MWmInE3EfdV77JwB1BRxT23Fz8jQ9h1JEYPw/FC3KIySMM
         X6cTwOUazNl+GE0MQw2hTk6jBpHKsGXmW0vUtFik106+Oq08dGj7GoRDqtg8Nnw2ESpj
         XMr6mL9h+JoXAInt6NX24ujjZLyQyTCG0ynSI7kKNFHPYLDqTPXkUF6j5Gz1eqQpGvsz
         /V8ulDRaYVEP49qmKmY4jKcsARijWG3eUGXIKhXBlAORKlzQQkoLgPWCg8CH0WYPGB58
         62ts1kR+ue8gYRaZnIVIvoKRYm/Us7HyUxne0dFJ7zE+kUxDXfr7X65u69JsIL5X7fUs
         lu4g==
X-Gm-Message-State: AOAM532GTAgA55QuJN7FRFFv3KpRjZjXdWYGbdJ0QnJyNnFr2R1VIbol
        6+CwF2FLcOoOM2RYenT37eg081OTjRq+n+s081k0XBlAqElg
X-Google-Smtp-Source: ABdhPJw3jqhA6oQMlWENcCbGd9dolHlf9BcFjk3ZNFE2XwmwQrkl8msmNDOzjdw9MqkoQ/H3IviKwoL91yGWNjAvStX/srV6lUvx
MIME-Version: 1.0
X-Received: by 2002:a92:b001:: with SMTP id x1mr7087287ilh.18.1589826197968;
 Mon, 18 May 2020 11:23:17 -0700 (PDT)
Date:   Mon, 18 May 2020 11:23:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8dd5305a5f041be@google.com>
Subject: KMSAN: uninit-value in pfifo_fast_dequeue
From:   syzbot <syzbot+ae62f326a5154c4b908f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a58741ac kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12def203e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=abbc202e1724cf37
dashboard link: https://syzkaller.appspot.com/bug?extid=ae62f326a5154c4b908f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1694ae75e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b970ade00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ae62f326a5154c4b908f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in kmsan_check_skb+0x3c/0x210 mm/kmsan/kmsan_hooks.c:299
CPU: 1 PID: 804 Comm: kworker/u4:27 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_check_skb+0x3c/0x210 mm/kmsan/kmsan_hooks.c:299
 pfifo_fast_dequeue+0xdb4/0xfd0 net/sched/sch_generic.c:658
 dequeue_skb net/sched/sch_generic.c:264 [inline]
 qdisc_restart net/sched/sch_generic.c:367 [inline]
 __qdisc_run+0x3f1/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:126 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit_accel+0x67/0x80 net/core/dev.c:4091
 macvlan_queue_xmit drivers/net/macvlan.c:537 [inline]
 macvlan_start_xmit+0x587/0xb50 drivers/net/macvlan.c:562
 __netdev_start_xmit include/linux/netdevice.h:4523 [inline]
 netdev_start_xmit include/linux/netdevice.h:4537 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3493
 __dev_queue_xmit+0x2f8d/0x3b20 net/core/dev.c:4052
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 batadv_send_skb_packet+0x59b/0x8c0 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2266
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2412
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3169 [inline]
 skb_cow_head include/linux/skbuff.h:3203 [inline]
 batadv_skb_head_push+0x234/0x350 net/batman-adv/soft-interface.c:74
 batadv_send_skb_packet+0x1a7/0x8c0 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2266
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2412
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:307 [inline]
 kmsan_alloc_page+0x12a/0x310 mm/kmsan/kmsan_shadow.c:336
 __alloc_pages_nodemask+0x5712/0x5e80 mm/page_alloc.c:4775
 __alloc_pages include/linux/gfp.h:498 [inline]
 __alloc_pages_node include/linux/gfp.h:511 [inline]
 alloc_pages_node include/linux/gfp.h:525 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4850 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4880
 __napi_alloc_skb+0x193/0xa60 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2874 [inline]
 page_to_skb+0x19f/0x1100 drivers/net/virtio_net.c:384
 receive_mergeable drivers/net/virtio_net.c:924 [inline]
 receive_buf+0xe79/0x8b30 drivers/net/virtio_net.c:1033
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x64b/0x19f0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6571 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6639
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Bytes 52-53 of 146 are uninitialized
Memory access of size 146 starts at ffff8ed3c0806c40
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
