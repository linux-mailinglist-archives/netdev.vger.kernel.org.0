Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8F415C49
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhIWKxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 06:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbhIWKxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 06:53:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F50C061574;
        Thu, 23 Sep 2021 03:51:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z14-20020a17090a8b8e00b0019cc29ceef1so6673614pjn.1;
        Thu, 23 Sep 2021 03:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3GI+pho7elX9hL7IWKWmBiGJm8kx46Kf+IQFVdHlpLQ=;
        b=ja8gNRjv897w4gwqtysDUJvgvNHXJlFnYv/Z07lSVOBh/RAWtC12CihMDQ7OTfwaqo
         FNceqvg3rFpmeMUcaAzi72czRXOBJrtnYfycoIHRqpFvbihUF5tM16vl0HT1rxe352cX
         nz5ytSqqW78FfVVKjogzZPjZNIGR4V6tImheG04L+dc5batF3VQqgkLO26q91/WamTzG
         5A3vGAhPeYP4+BQ7BMxLHfwy5rmoUwvjHm316HVgVIin8QueHTmmFHKAVvVWKADASFfk
         FaM2gEH17Qd7YxLW1im6jaESFeZWEFxthQcW3oNvxzUhP7HwvY/0QJu0r85I282zjqA8
         YGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3GI+pho7elX9hL7IWKWmBiGJm8kx46Kf+IQFVdHlpLQ=;
        b=xIdOsRDlRB3TKo9FuQptL5qxu1Q3cfttt8EL92bp4ZYTc3SLyRcVbsIGSvrQSz3nNH
         YuB9v8er8kUTJo9vU7SQH7FgUuE0bLy+rU71vzMGLFjbvfHMxEsj5nUsjHayL4xnGqGY
         kobgDAbkNuiLu3vYoCPm+7BQhkeF924Jw71bxGgxlOVkvuwqL6RZHFCxfLwe+2y+k3Yf
         4//66LL+uFpJn2wY9azK7KOZ6PZ259fzOMUg68uLVX8HZwNE3TFhhQtixxJaZ9xpr6F1
         NFQHSysQbJU8eWSEyML7FP+kCO5HEvmB+8AO8gtej0qYgNb5Z97kJnIbRV5sdcOXhnCk
         nFgA==
X-Gm-Message-State: AOAM532p1e/ZuY/Ic0qepuuPg4vjEVrGDYACS1GBk1xKvATAgrJO652+
        nk9BqYssIGMX7SYIYUVLb6oy8zzFZIOBW1JKIw==
X-Google-Smtp-Source: ABdhPJzZ0VunHJLFSuq1UBcSZZgEVxLqEi3CHtpjgFf+nBWL+C79Pba6HC1Ob2CGEB08OYQUiCp78saoWqxxN60GYO8=
X-Received: by 2002:a17:90b:124c:: with SMTP id gx12mr4672931pjb.106.1632394295972;
 Thu, 23 Sep 2021 03:51:35 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 23 Sep 2021 18:51:25 +0800
Message-ID: <CACkBjsbWBPD5qRBUNsGo0pURPs95sHLBqxf3Ueyqe72iVeLJEw@mail.gmail.com>
Subject: kernel BUG in __pskb_pull_tail
To:     davem@davemloft.net, kuba@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 92477dd1faa6 Merge tag 's390-5.15-ebpf-jit-fixes'
git tree: upstream
console output:
https://drive.google.com/file/d/1f2RLLaRmVwV9ffKgoHvMuXGSs-730rdm/view?usp=sharing
kernel config: https://drive.google.com/file/d/1KgvcM8i_3hQiOL3fUh3JFpYNQM4itvV4/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:2185!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 13386 Comm: syz-executor Not tainted 5.15.0-rc2+ #20
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:__pskb_pull_tail+0x559/0x5d0 net/core/skbuff.c:2184
Code: 00 00 4d 8b ac 24 c8 00 00 00 e9 0a ff ff ff e8 6d 4e cd fd 48
c7 c6 d0 cd 29 85 48 89 df e8 ae 55 e1 fd 0f 0b e8 57 4e cd fd <0f> 0b
89 45 c0 e8 4d 4e cd fd 8b 45 c0 44 89 f6 48 89 df 29 c6 e8
RSP: 0018:ffffc90000003af0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888017d3d000 RCX: 0000000000000100
RDX: ffff8881121cc500 RSI: ffffffff836a4329 RDI: ffff888018d0d6e8
RBP: ffffc90000003b40 R08: 0000000000082a20 R09: 00000000ffffffff
R10: ffffffff836a189d R11: 0000000000000000 R12: ffff888018d0d6e8
R13: 00000000000000c3 R14: 0000000000000140 R15: 00000000000002c0
FS:  00007fbde2a45700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400000 CR3: 0000000111c21000 CR4: 0000000000752ef0
DR0: 0afa2a56b5df4b30 DR1: 000000000000000c DR2: 4a2a504b7424fb1b
DR3: 000000000000004f DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 skb_condense+0x66/0x90 net/core/skbuff.c:6373
 ___pskb_trim+0x29a/0x4e0 net/core/skbuff.c:2119
 __pskb_trim include/linux/skbuff.h:2734 [inline]
 pskb_trim include/linux/skbuff.h:2741 [inline]
 sk_filter_trim_cap+0x3e1/0x420 net/core/filter.c:152
 tcp_filter net/ipv4/tcp_ipv4.c:1905 [inline]
 tcp_v4_rcv+0x1027/0x12e0 net/ipv4/tcp_ipv4.c:2066
 ip_protocol_deliver_rcu+0x51/0x410 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0xa0/0x180 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x8a/0x280 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:460 [inline]
 ip_rcv_finish+0xba/0x120 net/ipv4/ip_input.c:429
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_rcv+0x153/0x270 net/ipv4/ip_input.c:540
 __netif_receive_skb_one_core+0x67/0x90 net/core/dev.c:5436
 __netif_receive_skb+0x22/0x80 net/core/dev.c:5550
 process_backlog+0x8a/0x2c0 net/core/dev.c:6427
 __napi_poll+0x31/0x310 net/core/dev.c:6982
 napi_poll net/core/dev.c:7049 [inline]
 net_rx_action+0x357/0x410 net/core/dev.c:7136
 __do_softirq+0xe9/0x561 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0xe2/0x100 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x9e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x7/0x60 kernel/kcov.c:197
Code: ff 00 75 10 65 48 8b 04 25 40 70 01 00 48 8b 80 28 15 00 00 c3
0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 65 8b 05 79 de c9 7e <89> c1
48 8b 34 24 65 48 8b 14 25 40 70 01 00 81 e1 00 01 00 00 a9
RSP: 0018:ffffc9000ab57c28 EFLAGS: 00000286
RAX: 0000000080000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881121cc500 RSI: ffffffff8555b286 RDI: 0000000000000000
RBP: ffffc9000ab57c60 R08: 0000000000000000 R09: 0000000000000001
R10: 00000000fffffffe R11: 000000000002fda0 R12: 0000000000000000
R13: ffffc9000ab57dc0 R14: ffff88807dc24b60 R15: 0000000000000001
 lru_add_drain_cpu+0x1c/0x450 mm/swap.c:594
 lru_add_drain+0xa0/0x200 mm/swap.c:702
 __pagevec_release+0x19/0x40 mm/swap.c:967
 pagevec_release include/linux/pagevec.h:81 [inline]
 __munlock_pagevec+0xce5/0x1150 mm/mlock.c:307
 munlock_vma_pages_range+0x3fc/0x720 mm/mlock.c:475
 mlock_fixup+0x16f/0x220 mm/mlock.c:552
 apply_vma_lock_flags+0x11a/0x170 mm/mlock.c:590
 __do_sys_munlock mm/mlock.c:723 [inline]
 __se_sys_munlock mm/mlock.c:712 [inline]
 __x64_sys_munlock+0x8d/0x120 mm/mlock.c:712
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x2000098a
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 98 4a 2a e9 2c b8 b6 4c 0f 05 <bf> 00
00 40 00 c4 a3 7b f0 c5 01 41 e2 e9 c4 22 e9 aa bb 3c 00 00
RSP: 002b:00007fbde2a44ba8 EFLAGS: 00000a87 ORIG_RAX: 0000000000000096
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000000002000098a
RDX: 0000000000004c01 RSI: 0000000000000003 RDI: 0000000000400000
RBP: 0000000000000013 R08: 0000000000000005 R09: 0000000000000006
R10: 0000000000000007 R11: 0000000000000a87 R12: 000000000000000b
R13: 000000000000000c R14: 000000000000000d R15: 00007ffe9d51e330
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 7c793e5154a72638 ]---
RIP: 0010:__pskb_pull_tail+0x559/0x5d0 net/core/skbuff.c:2184
Code: 00 00 4d 8b ac 24 c8 00 00 00 e9 0a ff ff ff e8 6d 4e cd fd 48
c7 c6 d0 cd 29 85 48 89 df e8 ae 55 e1 fd 0f 0b e8 57 4e cd fd <0f> 0b
89 45 c0 e8 4d 4e cd fd 8b 45 c0 44 89 f6 48 89 df 29 c6 e8
RSP: 0018:ffffc90000003af0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888017d3d000 RCX: 0000000000000100
RDX: ffff8881121cc500 RSI: ffffffff836a4329 RDI: ffff888018d0d6e8
RBP: ffffc90000003b40 R08: 0000000000082a20 R09: 00000000ffffffff
R10: ffffffff836a189d R11: 0000000000000000 R12: ffff888018d0d6e8
R13: 00000000000000c3 R14: 0000000000000140 R15: 00000000000002c0
FS:  00007fbde2a45700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400000 CR3: 0000000111c21000 CR4: 0000000000752ef0
DR0: 0afa2a56b5df4b30 DR1: 000000000000000c DR2: 4a2a504b7424fb1b
DR3: 000000000000004f DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
----------------
Code disassembly (best guess):
   0: ff 00                incl   (%rax)
   2: 75 10                jne    0x14
   4: 65 48 8b 04 25 40 70 mov    %gs:0x17040,%rax
   b: 01 00
   d: 48 8b 80 28 15 00 00 mov    0x1528(%rax),%rax
  14: c3                    retq
  15: 0f 1f 40 00          nopl   0x0(%rax)
  19: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
  20: 00 00 00
  23: 65 8b 05 79 de c9 7e mov    %gs:0x7ec9de79(%rip),%eax        # 0x7ec9dea3
* 2a: 89 c1                mov    %eax,%ecx <-- trapping instruction
  2c: 48 8b 34 24          mov    (%rsp),%rsi
  30: 65 48 8b 14 25 40 70 mov    %gs:0x17040,%rdx
  37: 01 00
  39: 81 e1 00 01 00 00    and    $0x100,%ecx
  3f: a9                    .byte 0xa9
