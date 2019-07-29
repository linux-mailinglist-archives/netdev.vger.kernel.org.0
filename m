Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DAC78F81
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfG2PiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:38:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51558 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfG2PiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:38:06 -0400
Received: by mail-io1-f72.google.com with SMTP id c5so67489007iom.18
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=U+NQmVnzZ0voXbnlBdKLop7GZ6b6TZwZ0Zr+Fsw5ZVM=;
        b=p2aePGQwCIStsF/ucmErGjSR1JUh0dVScHYE3d2sTEFTZQ1pJqf2wSQgrD2wnZ+kwi
         Pw+39gz+WjWlBSkBaMqCafgjieeQXpiT06GeeK/bPoTvSn64+OrCEwnP/DeZnKGitA8+
         q/qUbUw8cAPFaPGMgSRMEfUmglf92FT0SmgNCpx+mZr9/T6ALRZ7sM1dmICbnUCoJpKa
         sbaYB0UAL4zixq7yW9U+C2S9Wb/5Ql8FY853AT991pbaTMVunJekKf7gy7WTKXo/TLT8
         9zoZIGFRUss5dvXyPJdSpVEXPk3DpWetJMwej8wR1nmfZg4zhAKLo8qhl9OH6yJpsLwk
         8Xdg==
X-Gm-Message-State: APjAAAUGoXw2FYsgkN73cX7Cbo7eJNVEbmRo1rX0DtE/uhaDfebgWGBI
        TVcqBwVxD7u8YcpzHfErEBsnaEKEm8gsqk8/pc/CI+hett0X
X-Google-Smtp-Source: APXvYqwidnUb8zSkOCZg5nE/L9O4rgw7Ncy75ZIChL3V2IeHoNlBSYeE7S2y1e7n8HBloNaW1A5omV1IFeoJ7QA11MpGWy+OUO+n
MIME-Version: 1.0
X-Received: by 2002:a6b:ee12:: with SMTP id i18mr41089402ioh.172.1564414685668;
 Mon, 29 Jul 2019 08:38:05 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:38:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ef2b8058ed3ad5e@google.com>
Subject: KMSAN: uninit-value in skb_pull_rcsum
From:   syzbot <syzbot+019264c4af66fbb45cac@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    beaab8a3 fix KASAN build
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=115ac27c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4db781fe35a84ef5
dashboard link: https://syzkaller.appspot.com/bug?extid=019264c4af66fbb45cac
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+019264c4af66fbb45cac@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in __skb_pull include/linux/skbuff.h:2224 [inline]
BUG: KMSAN: uninit-value in skb_pull_rcsum+0x2fb/0x500  
net/core/skbuff.c:3483
CPU: 1 PID: 15024 Comm: syz-executor.2 Not tainted 5.2.0+ #15
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  __skb_pull include/linux/skbuff.h:2224 [inline]
  skb_pull_rcsum+0x2fb/0x500 net/core/skbuff.c:3483
  __iptunnel_pull_header+0x14d/0xbc0 net/ipv4/ip_tunnel_core.c:94
  erspan_rcv net/ipv4/ip_gre.c:279 [inline]
  gre_rcv+0x6d9/0x1900 net/ipv4/ip_gre.c:415
  gre_rcv+0x2dd/0x3c0 net/ipv4/gre_demux.c:155
  ip_protocol_deliver_rcu+0x722/0xbc0 net/ipv4/ip_input.c:204
  ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ip_local_deliver+0x62a/0x7c0 net/ipv4/ip_input.c:252
  dst_input include/net/dst.h:439 [inline]
  ip_rcv_finish net/ipv4/ip_input.c:413 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ip_rcv+0x6c5/0x740 net/ipv4/ip_input.c:523
  __netif_receive_skb_one_core net/core/dev.c:5009 [inline]
  __netif_receive_skb net/core/dev.c:5123 [inline]
  process_backlog+0xef5/0x1410 net/core/dev.c:5934
  napi_poll net/core/dev.c:6357 [inline]
  net_rx_action+0x738/0x1940 net/core/dev.c:6423
  __do_softirq+0x4ad/0x858 kernel/softirq.c:293
  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1052
  </IRQ>
  do_softirq kernel/softirq.c:338 [inline]
  __local_bh_enable_ip+0x199/0x1e0 kernel/softirq.c:190
  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
  rcu_read_unlock_bh include/linux/rcupdate.h:682 [inline]
  ip_finish_output2+0x20dc/0x25d0 net/ipv4/ip_output.c:229
  ip_finish_output+0xd2a/0xfd0 net/ipv4/ip_output.c:315
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip_output+0x541/0x610 net/ipv4/ip_output.c:415
  dst_output include/net/dst.h:433 [inline]
  ip_local_out net/ipv4/ip_output.c:125 [inline]
  ip_send_skb net/ipv4/ip_output.c:1473 [inline]
  ip_push_pending_frames+0x243/0x460 net/ipv4/ip_output.c:1493
  raw_sendmsg+0x2df8/0x46d0 net/ipv4/raw.c:672
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  ___sys_sendmsg+0xe92/0x13c0 net/socket.c:2286
  __sys_sendmsg net/socket.c:2324 [inline]
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2331
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2331
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb0d4758c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459829
RDX: 0000000000000000 RSI: 0000000020003d00 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb0d47596d4
R13: 00000000004c7560 R14: 00000000004dcac0 R15: 00000000ffffffff

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:187 [inline]
  kmsan_internal_chain_origin+0xcc/0x150 mm/kmsan/kmsan.c:345
  kmsan_memcpy_memmove_metadata+0x9f9/0xe00 mm/kmsan/kmsan.c:278
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:298
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  pskb_expand_head+0x38a/0x19f0 net/core/skbuff.c:1510
  __skb_cow include/linux/skbuff.h:3036 [inline]
  skb_cow_head include/linux/skbuff.h:3070 [inline]
  ip_tunnel_xmit+0x2971/0x3320 net/ipv4/ip_tunnel.c:811
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  erspan_xmit+0x1ef8/0x35c0 net/ipv4/ip_gre.c:679
  __netdev_start_xmit include/linux/netdevice.h:4406 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3288 [inline]
  dev_hard_start_xmit+0x51a/0xab0 net/core/dev.c:3304
  sch_direct_xmit+0x56c/0x18c0 net/sched/sch_generic.c:309
  __dev_xmit_skb net/core/dev.c:3485 [inline]
  __dev_queue_xmit+0x1e53/0x4270 net/core/dev.c:3846
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3910
  neigh_resolve_output+0xab7/0xb50 net/core/neighbour.c:1486
  neigh_output include/net/neighbour.h:511 [inline]
  ip_finish_output2+0x1a8e/0x25d0 net/ipv4/ip_output.c:228
  ip_finish_output+0xd2a/0xfd0 net/ipv4/ip_output.c:315
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip_output+0x541/0x610 net/ipv4/ip_output.c:415
  dst_output include/net/dst.h:433 [inline]
  ip_local_out net/ipv4/ip_output.c:125 [inline]
  ip_send_skb net/ipv4/ip_output.c:1473 [inline]
  ip_push_pending_frames+0x243/0x460 net/ipv4/ip_output.c:1493
  raw_sendmsg+0x2df8/0x46d0 net/ipv4/raw.c:672
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  ___sys_sendmsg+0xe92/0x13c0 net/socket.c:2286
  __sys_sendmsg net/socket.c:2324 [inline]
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2331
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2331
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:187 [inline]
  kmsan_internal_poison_shadow+0x53/0xa0 mm/kmsan/kmsan.c:146
  kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:175
  slab_alloc_node mm/slub.c:2771 [inline]
  __kmalloc_node_track_caller+0xc8f/0xf10 mm/slub.c:4389
  __kmalloc_reserve net/core/skbuff.c:138 [inline]
  __alloc_skb+0x306/0xa10 net/core/skbuff.c:206
  alloc_skb include/linux/skbuff.h:1055 [inline]
  __ip_append_data+0x3901/0x52c0 net/ipv4/ip_output.c:1013
  ip_append_data+0x324/0x480 net/ipv4/ip_output.c:1228
  raw_sendmsg+0x2d02/0x46d0 net/ipv4/raw.c:666
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  ___sys_sendmsg+0xe92/0x13c0 net/socket.c:2286
  __sys_sendmsg net/socket.c:2324 [inline]
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2331
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2331
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
