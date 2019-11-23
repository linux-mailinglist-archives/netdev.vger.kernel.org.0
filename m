Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8684107FBF
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKWSFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:05:11 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34538 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfKWSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:05:11 -0500
Received: by mail-il1-f197.google.com with SMTP id m12so9624524ilq.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:05:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m57d6pzMbnRE+E77SNnUVK48CZSyCuqXvxNHBd1sUpg=;
        b=UjYKxsuVTFX1ZwLGqD2wXz+Gj3HPiN0ihSTDZNWp8oXRvh/GrzTP7bgKL5sHqx7vok
         BpeTYJbdtd+RF2kLkbuTaAyhFBpX2Q+WDyyWzGzdfWnYteVo57KqULYwS56sto38mv3r
         Q7/bYw1jm4eG1rO72b0L4oxG0abF7xrJyZM9olA4irtoQUfW6mcxUdTCtY98ubUAkNHq
         WapcLNVUzKyX1uCeSemo/euVfFFHtejQVzTzopUJa413+mmQsQCyYgfX15J+QHcccYpK
         Vize7boBR/3kkGXeIifVI64jhTEHzgvdf4h4IgqOQGD01lrRVd8A1/5Z0B2f14LRGoVd
         fTdw==
X-Gm-Message-State: APjAAAXfG3U81ooOuCU7MuWGljpoQPjvaqNcpiNJzIRTRypK1smV5kq5
        EJPEkYKemqC+6Zb5dvZpGyh2QwiqdcS7dZkgueVoQF+mfbut
X-Google-Smtp-Source: APXvYqxw5FikGezlDJ6iFZJN/0R9hWPQ1CdQy5EbMecOvSWZ2tWu+7jJQttnrNArYfRZjONWb1MUuwLB2urjqtQkb/TTFKEAufph
MIME-Version: 1.0
X-Received: by 2002:a92:5c5d:: with SMTP id q90mr24932010ilb.22.1574532310177;
 Sat, 23 Nov 2019 10:05:10 -0800 (PST)
Date:   Sat, 23 Nov 2019 10:05:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000924780598075f4b@google.com>
Subject: KMSAN: uninit-value in __skb_checksum_complete (4)
From:   syzbot <syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    287021d5 Revert "lib/scatterlist: kmsan: don't squash cont..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=152c638ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
dashboard link: https://syzkaller.appspot.com/bug?extid=721b564cd88ebb710182
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1423f122e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __skb_checksum_complete+0x37b/0x530  
net/core/skbuff.c:2851
CPU: 0 PID: 12256 Comm: udevd Not tainted 5.4.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
  __skb_checksum_complete+0x37b/0x530 net/core/skbuff.c:2851
  nf_ip_checksum+0x567/0x770 net/netfilter/utils.c:36
  nf_nat_icmp_reply_translation+0x2ba/0x970 net/netfilter/nf_nat_proto.c:567
  nf_nat_ipv4_fn net/netfilter/nf_nat_proto.c:626 [inline]
  nf_nat_ipv4_local_fn+0x215/0x840 net/netfilter/nf_nat_proto.c:697
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0x18b/0x3f0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:260 [inline]
  __ip_local_out+0x69b/0x800 net/ipv4/ip_output.c:114
  ip_local_out net/ipv4/ip_output.c:123 [inline]
  ip_send_skb net/ipv4/ip_output.c:1558 [inline]
  ip_push_pending_frames+0x16f/0x460 net/ipv4/ip_output.c:1578
  icmp_push_reply+0x692/0x750 net/ipv4/icmp.c:389
  __icmp_send+0x2313/0x3080 net/ipv4/icmp.c:738
  ipv4_send_dest_unreach net/ipv4/route.c:1220 [inline]
  ipv4_link_failure+0x73c/0xaf0 net/ipv4/route.c:1227
  dst_link_failure include/net/dst.h:419 [inline]
  arp_error_report+0x106/0x1a0 net/ipv4/arp.c:293
  neigh_invalidate+0x359/0x8e0 net/core/neighbour.c:996
  neigh_timer_handler+0xda4/0x1450 net/core/neighbour.c:1082
  call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  </IRQ>
RIP: 0010:kmsan_slab_alloc+0xd5/0x120 mm/kmsan/kmsan_hooks.c:92
Code: 0a ba 01 00 00 00 e8 6a e7 ff ff 65 ff 0d 17 05 fd 7d 65 8b 05 10 05  
fd 7d 85 c0 75 30 e8 73 6e 37 ff 4c 89 65 c8 ff 75 c8 9d <65> 48 8b 04 25  
28 00 00 00 48 3b 45 d8 75 0d 48 83 c4 18 5b 41 5c
RSP: 0018:ffff888104a5fb48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff888069bbb000 RCX: 0000000000000401
RDX: 0000000000000400 RSI: 0000000000000000 RDI: ffff888069bbb000
RBP: ffff888104a5fb80 R08: 0000000000000002 R09: ffff888077c93000
R10: 0000000000000004 R11: ffffffff82579470 R12: 0000000000000246
R13: ffff88812f8068c0 R14: 0000000000000dc0 R15: ffff88812f8068c0
  slab_alloc_node mm/slub.c:2799 [inline]
  slab_alloc mm/slub.c:2808 [inline]
  kmem_cache_alloc_trace+0x8b6/0xd10 mm/slub.c:2825
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  kernfs_iop_get_link+0xcb/0xc40 fs/kernfs/symlink.c:135
  vfs_readlink+0x20d/0x6e0 fs/namei.c:4728
  do_readlinkat+0x406/0x520 fs/stat.c:411
  __do_sys_readlink fs/stat.c:432 [inline]
  __se_sys_readlink+0x99/0xc0 fs/stat.c:429
  __x64_sys_readlink+0x4a/0x70 fs/stat.c:429
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x7faf01efa577
Code: f0 ff ff 77 02 f3 c3 48 8b 15 bd 38 2b 00 f7 d8 64 89 02 83 c8 ff c3  
90 90 90 90 90 90 90 90 90 90 90 90 b8 59 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 01 c3 48 8b 0d 91 38 2b 00 31 d2 48 29 c2 64
RSP: 002b:00007ffee58d72b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000059
RAX: ffffffffffffffda RBX: 00007ffee58d7af0 RCX: 00007faf01efa577
RDX: 0000000000000400 RSI: 00007ffee58d76c0 RDI: 00007ffee58d72c0
RBP: 0000000000000200 R08: 000000000042033b R09: 00007faf01f4ec20
R10: 7269762f73656369 R11: 0000000000000206 R12: 00000000017c4e10
R13: 0000000000625500 R14: 00000000017bf250 R15: 000000000000000b

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x180 mm/kmsan/kmsan.c:319
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:254
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:274
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  csum_partial_copy+0xae/0x100 lib/checksum.c:174
  skb_copy_and_csum_bits+0x214/0x10b0 net/core/skbuff.c:2738
  icmp_glue_bits+0x16b/0x380 net/ipv4/icmp.c:352
  __ip_append_data+0x41c3/0x52c0 net/ipv4/ip_output.c:1132
  ip_append_data+0x324/0x480 net/ipv4/ip_output.c:1313
  icmp_push_reply+0x210/0x750 net/ipv4/icmp.c:370
  __icmp_send+0x2313/0x3080 net/ipv4/icmp.c:738
  ipv4_send_dest_unreach net/ipv4/route.c:1220 [inline]
  ipv4_link_failure+0x73c/0xaf0 net/ipv4/route.c:1227
  dst_link_failure include/net/dst.h:419 [inline]
  arp_error_report+0x106/0x1a0 net/ipv4/arp.c:293
  neigh_invalidate+0x359/0x8e0 net/core/neighbour.c:996
  neigh_timer_handler+0xda4/0x1450 net/core/neighbour.c:1082
  call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
  arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
  kmsan_slab_alloc+0xd5/0x120 mm/kmsan/kmsan_hooks.c:92
  slab_alloc_node mm/slub.c:2799 [inline]
  slab_alloc mm/slub.c:2808 [inline]
  kmem_cache_alloc_trace+0x8b6/0xd10 mm/slub.c:2825
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  kernfs_iop_get_link+0xcb/0xc40 fs/kernfs/symlink.c:135
  vfs_readlink+0x20d/0x6e0 fs/namei.c:4728
  do_readlinkat+0x406/0x520 fs/stat.c:411
  __do_sys_readlink fs/stat.c:432 [inline]
  __se_sys_readlink+0x99/0xc0 fs/stat.c:429
  __x64_sys_readlink+0x4a/0x70 fs/stat.c:429
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x180 mm/kmsan/kmsan.c:319
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:254
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:274
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  skb_put_data include/linux/skbuff.h:2217 [inline]
  sctp_packet_pack net/sctp/output.c:470 [inline]
  sctp_packet_transmit+0x1d9e/0x4250 net/sctp/output.c:597
  sctp_outq_flush_transports net/sctp/outqueue.c:1146 [inline]
  sctp_outq_flush+0x1823/0x5d80 net/sctp/outqueue.c:1194
  sctp_outq_uncork+0xd0/0xf0 net/sctp/outqueue.c:757
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1781 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1184 [inline]
  sctp_do_sm+0x8fe1/0x9720 net/sctp/sm_sideeffect.c:1155
  sctp_generate_heartbeat_event+0x3c6/0x5a0 net/sctp/sm_sideeffect.c:391
  call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
  spin_unlock_irq include/linux/spinlock.h:388 [inline]
  alloc_pid+0xd06/0xd50 kernel/pid.c:229
  copy_process+0x446d/0x89f0 kernel/fork.c:2031
  _do_fork+0x25c/0xeb0 kernel/fork.c:2368
  __do_sys_clone kernel/fork.c:2523 [inline]
  __se_sys_clone+0x32a/0x370 kernel/fork.c:2504
  __x64_sys_clone+0x62/0x80 kernel/fork.c:2504
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x180 mm/kmsan/kmsan.c:319
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:254
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:274
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  skb_put_data include/linux/skbuff.h:2217 [inline]
  sctp_addto_chunk net/sctp/sm_make_chunk.c:1494 [inline]
  sctp_make_heartbeat+0x612/0x9e0 net/sctp/sm_make_chunk.c:1164
  sctp_sf_heartbeat net/sctp/sm_statefuns.c:990 [inline]
  sctp_sf_sendbeat_8_3+0x18d/0xb10 net/sctp/sm_statefuns.c:1034
  sctp_do_sm+0x2b2/0x9720 net/sctp/sm_sideeffect.c:1152
  sctp_generate_heartbeat_event+0x3c6/0x5a0 net/sctp/sm_sideeffect.c:391
  call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
  spin_unlock_irq include/linux/spinlock.h:388 [inline]
  alloc_pid+0xd06/0xd50 kernel/pid.c:229
  copy_process+0x446d/0x89f0 kernel/fork.c:2031
  _do_fork+0x25c/0xeb0 kernel/fork.c:2368
  __do_sys_clone kernel/fork.c:2523 [inline]
  __se_sys_clone+0x32a/0x370 kernel/fork.c:2504
  __x64_sys_clone+0x62/0x80 kernel/fork.c:2504
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x180 mm/kmsan/kmsan.c:319
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:254
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:274
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  sctp_make_heartbeat+0x3e9/0x9e0 net/sctp/sm_make_chunk.c:1156
  sctp_sf_heartbeat net/sctp/sm_statefuns.c:990 [inline]
  sctp_sf_sendbeat_8_3+0x18d/0xb10 net/sctp/sm_statefuns.c:1034
  sctp_do_sm+0x2b2/0x9720 net/sctp/sm_sideeffect.c:1152
  sctp_generate_heartbeat_event+0x3c6/0x5a0 net/sctp/sm_sideeffect.c:391
  call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
  spin_unlock_irq include/linux/spinlock.h:388 [inline]
  alloc_pid+0xd06/0xd50 kernel/pid.c:229
  copy_process+0x446d/0x89f0 kernel/fork.c:2031
  _do_fork+0x25c/0xeb0 kernel/fork.c:2368
  __do_sys_clone kernel/fork.c:2523 [inline]
  __se_sys_clone+0x32a/0x370 kernel/fork.c:2504
  __x64_sys_clone+0x62/0x80 kernel/fork.c:2504
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x180 mm/kmsan/kmsan.c:319
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:254
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:274
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  sctp_transport_init net/sctp/transport.c:47 [inline]
  sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
  sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
  sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]
  sctp_process_init+0x162b/0x3e30 net/sctp/sm_make_chunk.c:2345
  sctp_sf_do_5_1D_ce+0xe0f/0x30d0 net/sctp/sm_statefuns.c:767
  sctp_do_sm+0x2b2/0x9720 net/sctp/sm_sideeffect.c:1152
  sctp_endpoint_bh_rcv+0xda2/0x1050 net/sctp/endpointola.c:394
  sctp_inq_push+0x300/0x420 net/sctp/inqueue.c:80
  sctp_rcv+0x3a6d/0x54e0 net/sctp/input.c:256
  ip_protocol_deliver_rcu+0x70f/0xbd0 net/ipv4/ip_input.c:204
  ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ip_local_deliver+0x62a/0x7c0 net/ipv4/ip_input.c:252
  dst_input include/net/dst.h:442 [inline]
  ip_rcv_finish net/ipv4/ip_input.c:413 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ip_rcv+0x6c5/0x740 net/ipv4/ip_input.c:523
  __netif_receive_skb_one_core net/core/dev.c:5010 [inline]
  __netif_receive_skb net/core/dev.c:5124 [inline]
  process_backlog+0xef5/0x1410 net/core/dev.c:5955
  napi_poll net/core/dev.c:6392 [inline]
  net_rx_action+0x7a6/0x1aa0 net/core/dev.c:6460
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  run_ksoftirqd+0x25/0x40 kernel/softirq.c:607
  smpboot_thread_fn+0x4a3/0x990 kernel/smpboot.c:165
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----addr.i@sctp_process_init
Variable was created at:
  sctp_process_param net/sctp/sm_make_chunk.c:2495 [inline]
  sctp_process_init+0x603/0x3e30 net/sctp/sm_make_chunk.c:2345
  sctp_process_param net/sctp/sm_make_chunk.c:2495 [inline]
  sctp_process_init+0x603/0x3e30 net/sctp/sm_make_chunk.c:2345
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
