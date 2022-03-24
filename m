Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255C34E5C3B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 01:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346756AbiCXAPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 20:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345719AbiCXAPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 20:15:08 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F140E140A1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 17:13:37 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id u10-20020a5ec00a000000b00648e5804d5bso2059058iol.12
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 17:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V+6A96zcUHBo/1Vd9cbgrqSOLXByL/HQVaxu+/o75IY=;
        b=vwOw6xbK8vFkbH0XpsF1Wy+PH+NnooQIdVbG8u2d9L0jsvFTAF8jbwwl4qNRZgQEDE
         UxRylCg7vXFWugel5t840BRBpu8m6LS4GFmH0/6AKmmE3y1+G9DNbYotC9HtWcunJ32w
         SFLl/OFRaLm4x/r1WWWwetqA39R4tBkxIp30lnvimoCYCRDOKimtx7ADmj1/fQB/Ikfr
         EJvga0GYE64MoZDps/5BRHADlwt8qGwDxFwsMRDAegZUEmT/o+M0oyRAp8Lt9ZuQWEjp
         WHnc+3p/hcr3PxnCo7oieipDIqYAVQm/iE4IcyxfkU6oYR8eeAWF8P/27NjPhb7aw/Vy
         FEYg==
X-Gm-Message-State: AOAM532TlsuBhhB7iQFKipwV5YyMLXA8R++ne+OevQ7EmWzRbeQHUMIu
        BaTos/2ABLiLCJnzu8GG7kzgDy9XZbfNDgd7bSpEVX3aAK5V
X-Google-Smtp-Source: ABdhPJwhGqpJ45ABs6FnJ2w8RR9JPgROyxztusezrFVT7uaQWYKGlAH76DqYNK3/06j6SIAWT26iBIMGqNSJD5FDoOmpcIvLXPsd
MIME-Version: 1.0
X-Received: by 2002:a5d:848a:0:b0:648:b2f4:d5cd with SMTP id
 t10-20020a5d848a000000b00648b2f4d5cdmr1347523iom.53.1648080817286; Wed, 23
 Mar 2022 17:13:37 -0700 (PDT)
Date:   Wed, 23 Mar 2022 17:13:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000acf1e405daebb7c7@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in __tcp_transmit_skb
From:   syzbot <syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36c2e31ad25b net: geneve: add missing netlink policy and s..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17c308a5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a15e2288cf165c9
dashboard link: https://syzkaller.appspot.com/bug?extid=090d23ddbd5cd185c2e0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171eadbd700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cacda3700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 13fd5067 P4D 13fd5067 PUD 77ebc067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7423 Comm: syz-executor720 Not tainted 5.17.0-rc8-syzkaller-02803-g36c2e31ad25b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc900001d0a60 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801e00cd10 RCX: 0000000000000100
RDX: 1ffff11003c019a3 RSI: ffff8880155c5c80 RDI: ffff888014bac800
RBP: ffff888014bac800 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87bccdc7 R11: 0000000000000000 R12: ffff8880155c5c80
R13: 0000000000000000 R14: ffff888014bacf60 R15: ffff88807527012c
FS:  000055555733b3c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000757b0000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __tcp_transmit_skb+0x1098/0x38b0 net/ipv4/tcp_output.c:1371
 tcp_transmit_skb net/ipv4/tcp_output.c:1420 [inline]
 tcp_xmit_probe_skb+0x28c/0x320 net/ipv4/tcp_output.c:4006
 tcp_write_wakeup+0x1bd/0x610 net/ipv4/tcp_output.c:4059
 tcp_send_probe0+0x44/0x560 net/ipv4/tcp_output.c:4074
 tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
 tcp_write_timer_handler+0x9ed/0xbc0 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5607
Code: e4 a4 7e 83 f8 01 0f 85 b4 02 00 00 9c 58 f6 c4 02 0f 85 9f 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc90002eaf888 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff920005d5f13 RCX: 5ad5b746ce328923
RDX: 1ffff1100e5374eb RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8fe0c947
R10: fffffbfff1fc1928 R11: 0000000000000001 R12: 0000000000000002
R13: 0000000000000000 R14: ffffffff8bb84ca0 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:268 [inline]
 rcu_read_lock include/linux/rcupdate.h:694 [inline]
 fib_lookup.constprop.0+0x8f/0x460 include/net/ip_fib.h:377
 ip_route_output_key_hash_rcu+0xf54/0x2c80 net/ipv4/route.c:2737
 ip_route_output_key_hash+0x183/0x2f0 net/ipv4/route.c:2627
 __ip_route_output_key include/net/route.h:127 [inline]
 ip_route_output_flow+0x23/0x150 net/ipv4/route.c:2857
 ip_route_newports include/net/route.h:343 [inline]
 tcp_v4_connect+0x12a5/0x1d00 net/ipv4/tcp_ipv4.c:283
 __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
 inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
 smc_connect+0x230/0x450 net/smc/af_smc.c:1522
 __sys_connect_file+0x155/0x1a0 net/socket.c:1900
 __sys_connect+0x161/0x190 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f23b4ec0889
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffce8f74658 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007ffce8f746b0 RCX: 00007f23b4ec0889
RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000cf1c R09: 000000000000cf1c
R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffce8f746a0
R13: 000000000000cf1c R14: 00007ffce8f7469c R15: 431bde82d7b634db
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc900001d0a60 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801e00cd10 RCX: 0000000000000100
RDX: 1ffff11003c019a3 RSI: ffff8880155c5c80 RDI: ffff888014bac800
RBP: ffff888014bac800 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87bccdc7 R11: 0000000000000000 R12: ffff8880155c5c80
R13: 0000000000000000 R14: ffff888014bacf60 R15: ffff88807527012c
FS:  000055555733b3c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000757b0000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	e4 a4                	in     $0xa4,%al
   2:	7e 83                	jle    0xffffff87
   4:	f8                   	clc
   5:	01 0f                	add    %ecx,(%rdi)
   7:	85 b4 02 00 00 9c 58 	test   %esi,0x589c0000(%rdx,%rax,1)
   e:	f6 c4 02             	test   $0x2,%ah
  11:	0f 85 9f 02 00 00    	jne    0x2b6
  17:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  1d:	74 01                	je     0x20
  1f:	fb                   	sti
  20:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  27:	fc ff df
* 2a:	48 01 c3             	add    %rax,%rbx <-- trapping instruction
  2d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  34:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  3b:	00
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	84                   	.byte 0x84
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
