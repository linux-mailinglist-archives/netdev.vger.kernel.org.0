Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24C1D194D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389209AbgEMPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:25:22 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33382 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732300AbgEMPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:25:16 -0400
Received: by mail-il1-f200.google.com with SMTP id b29so153051ilb.0
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FT3APWDHqwvaHL7ZFg7HtZts/18iRU9zbEsBrZ6b5QQ=;
        b=VuVj1b5R2UtCbPZAo+VjdpBe/XjiwNOZh/mTvF7IexMPNPC9LGQwZfhQnq66TUxLtv
         gBiHoljcVK+7zcbEu1LY3Urf8dRLXavlaOyif3fLe9+z66WYG7Ss1+8fW7I7zn5epXJF
         EMd/cGmcwgpf9ICBmA2za78TwpiFQuM3XLx47nfvmxwL2o4zZrfb/z+wLKktBB1C5HzQ
         Ys7bqCyvZ6DmVz9fmYrGw1oZys84dbZwA7ET2cdBYeE7Eq3ap8QdO4HUEUYobVGKz0xF
         R4bv2CE1PMacVpgJykBtWBo61zbbuIVVg+Pl+7FIbIeXm/9hWQzDx48nc17xJlSnVe+U
         7yww==
X-Gm-Message-State: AOAM5305TPA8zMzbTECPyVl/plsu48g960NNTqtt1FQjWghbLowluSqW
        wSOY58wOoDi5UD7niRM8tKK7kfaD/crKpnyjeDZBlcih7Rdj
X-Google-Smtp-Source: ABdhPJzjcYq8bKswc2ZjZl7o0Tylotf2/nbTABzfslYvwzPbgzrpENY8i0xXvb4cIzOhKd6lMPOHNe+zzRF9SnhZy3TNgNq28vxv
MIME-Version: 1.0
X-Received: by 2002:a92:8d49:: with SMTP id s70mr10231ild.54.1589383514058;
 Wed, 13 May 2020 08:25:14 -0700 (PDT)
Date:   Wed, 13 May 2020 08:25:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4796705a5892f6a@google.com>
Subject: KMSAN: kernel-infoleak in _copy_to_iter (5)
From:   syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sd@queasysnail.net,
        syzkaller-bugs@googlegroups.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    14bcee29 DO-NOT-SUBMIT: kmsan: block: nullb: handle read r..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1752af7c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f048d804e1a47a0
dashboard link: https://syzkaller.appspot.com/bug?extid=50ee810676e6a089487b
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c69b42100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f72658100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:251
CPU: 0 PID: 9041 Comm: syz-executor493 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:251
 copyout lib/iov_iter.c:145 [inline]
 _copy_to_iter+0x44f/0x2770 lib/iov_iter.c:633
 copy_to_iter include/linux/uio.h:138 [inline]
 simple_copy_to_iter net/core/datagram.c:519 [inline]
 __skb_datagram_iter+0x2bb/0x1220 net/core/datagram.c:425
 skb_copy_datagram_iter+0x292/0x2b0 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3537 [inline]
 packet_recvmsg+0x630/0x1c40 net/packet/af_packet.c:3378
 ____sys_recvmsg+0xf58/0x1020 net/socket.c:886
 ___sys_recvmsg net/socket.c:2627 [inline]
 do_recvmmsg+0x990/0x1e00 net/socket.c:2725
 __sys_recvmmsg net/socket.c:2804 [inline]
 __do_sys_recvmmsg net/socket.c:2827 [inline]
 __se_sys_recvmmsg+0x1d1/0x350 net/socket.c:2820
 __x64_sys_recvmmsg+0x62/0x80 net/socket.c:2820
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443ca9
Code: e8 8c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcf6171b28 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443ca9
RDX: 0000000000000002 RSI: 0000000020000a80 RDI: 0000000000000003
RBP: 00007ffcf6171b30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000142fb
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3171 [inline]
 skb_cow_head include/linux/skbuff.h:3205 [inline]
 batadv_skb_head_push+0x234/0x350 net/batman-adv/soft-interface.c:74
 batadv_send_skb_packet+0x1a7/0x8c0 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2268
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2414
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:280 [inline]
 kmsan_alloc_page+0xb9/0x180 mm/kmsan/kmsan_shadow.c:304
 __alloc_pages_nodemask+0x56a2/0x5dc0 mm/page_alloc.c:4848
 __alloc_pages include/linux/gfp.h:504 [inline]
 __alloc_pages_node include/linux/gfp.h:517 [inline]
 alloc_pages_node include/linux/gfp.h:531 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4923 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4953
 __napi_alloc_skb+0x193/0xa60 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2876 [inline]
 page_to_skb+0x1a2/0x1390 drivers/net/virtio_net.c:384
 receive_mergeable drivers/net/virtio_net.c:935 [inline]
 receive_buf+0xed6/0x8d50 drivers/net/virtio_net.c:1045
 virtnet_receive drivers/net/virtio_net.c:1335 [inline]
 virtnet_poll+0x64b/0x19f0 drivers/net/virtio_net.c:1440
 napi_poll net/core/dev.c:6572 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6640
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Bytes 52-53 of 146 are uninitialized
Memory access of size 146 starts at ffff898139239040
Data copied to user address 0000000020000980
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
