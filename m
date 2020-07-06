Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00B9215723
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgGFMT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:19:27 -0400
Received: from mail.katalix.com ([3.9.82.81]:57868 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgGFMT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 08:19:26 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2020 08:19:24 EDT
Received: from localhost (unknown [IPv6:2a02:8010:6359:1:21b:21ff:fe6a:7e96])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 4639E91532;
        Mon,  6 Jul 2020 13:12:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1594037579; bh=ZXkw1YtEWr4ltdw99ajOOAdNlxU8aRIXOVUh/7lathY=;
        h=Date:From:To:Cc:Subject:From;
        b=wg708B9ahUJN0uD8o3ejbCZsi5smBpNwP46DnqQnu8TsBF9crkgDy1eErJ1bUljxD
         WX44fRPwra4NU8joQYqdVNlCIFmWyB4IhF4KKbRqmYbVjUHwz1O+wVK9y0GDi1HbSf
         JjcmzqaxPstWCDt9mIVFreHIb+xm0JOH/uqHKWLUO/EbKdJub7WvmxCPE8PnsINAJF
         pR4eIxE/cJCgEac0j8bdScjUBB6O1nkZrCg1pgwVwAI8hBdhupnntMxrRe4biA7p8V
         Rm18py7oiMXojXYFwH3WZ2uLNh90l+h71sfYTyp4glkQXV+Bmgype4st9iw15Tf5VQ
         piK2+lW+lOa4w==
Date:   Mon, 6 Jul 2020 13:12:59 +0100
From:   James Chapman <jchapman@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com
Subject: [PATCH net] l2tp: add sk_reuseport checks to l2tp_validate_socket
Message-ID: <20200706121259.GA20199@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is able to trigger a BUG_ON in l2tp by setting SO_REUSEPORT on
a UDP socket which is then used by l2tp. However, the bug occurs only
if the kernel has CONFIG_BPF_SYSCALL enabled.

kernel BUG at net/l2tp/l2tp_core.c:1572!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:l2tp_session_free+0x1ee/0x1f0 net/l2tp/l2tp_core.c:1572
Code: 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c b8 fe ff ff 4c 89 e7 e8 03 64 37 fa e9 ab fe ff ff e8 d9 7f f8 f9 0f 0b e8 d2 7f f8 f9 <0f> 0b 55 41 57 41 56 41 55 41 54 53 49 89 fe 48 bd 00 00 00 00 00
RSP: 0018:ffffc90000da8da8 EFLAGS: 00010246
RAX: ffffffff877c235e RBX: 0000000000000000 RCX: ffff8880a99f4340
RDX: 0000000080000101 RSI: 0000000000000000 RDI: 0000000042114dda
RBP: ffff8880a7958238 R08: ffffffff877c220d R09: ffffed1014f2b01a
R10: ffffed1014f2b01a R11: 0000000000000000 R12: ffff8880a6f77800
R13: dffffc0000000000 R14: ffff8880a7958000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049f410 CR3: 0000000009279000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __sk_destruct+0x50/0x740 net/core/sock.c:1785
 rcu_do_batch kernel/rcu/tree.c:2396 [inline]
 rcu_core+0x90c/0x1200 kernel/rcu/tree.c:2623
 __do_softirq+0x268/0x80c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x223/0x230 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1107
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 80 e1 07 80 c1 03 38 c1 7c bc 48 89 df e8 9a 17 9b f9 eb b2 cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 56 46 4a 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 46 46 4a 00 f4 c3 cc cc 41 56 53 65
RSP: 0018:ffffc90000d3fd60 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff12577b9 RBX: 0000000000000000 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a99f4ba4
RBP: 1ffff1104351244e R08: ffffffff817a4660 R09: ffffed101533e869
R10: ffffed101533e869 R11: 0000000000000000 R12: 0000000000000001
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffff88821a892270
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt+0x87/0xe0 drivers/acpi/processor_idle.c:111
 acpi_idle_do_entry drivers/acpi/processor_idle.c:525 [inline]
 acpi_idle_enter+0x3f4/0xac0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0x2d7/0x7b0 drivers/cpuidle/cpuidle.c:234
 cpuidle_enter+0x59/0x90 drivers/cpuidle/cpuidle.c:345
 call_cpuidle kernel/sched/idle.c:117 [inline]
 cpuidle_idle_call kernel/sched/idle.c:207 [inline]
 do_idle+0x49c/0x650 kernel/sched/idle.c:269
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:365
 start_secondary+0x213/0x240 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
Modules linked in:
---[ end trace 1d65b89c4fe927df ]---
RIP: 0010:l2tp_session_free+0x1ee/0x1f0 net/l2tp/l2tp_core.c:1572
Code: 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c b8 fe ff ff 4c 89 e7 e8 03 64 37 fa e9 ab fe ff ff e8 d9 7f f8 f9 0f 0b e8 d2 7f f8 f9 <0f> 0b 55 41 57 41 56 41 55 41 54 53 49 89 fe 48 bd 00 00 00 00 00
RSP: 0018:ffffc90000da8da8 EFLAGS: 00010246
RAX: ffffffff877c235e RBX: 0000000000000000 RCX: ffff8880a99f4340
RDX: 0000000080000101 RSI: 0000000000000000 RDI: 0000000042114dda
RBP: ffff8880a7958238 R08: ffffffff877c220d R09: ffffed1014f2b01a
R10: ffffed1014f2b01a R11: 0000000000000000 R12: ffff8880a6f77800
R13: dffffc0000000000 R14: ffff8880a7958000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049f410 CR3: 0000000009279000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

The bug is triggered by a simple sequence:

 [pid 21579] socket(AF_PPPOX, SOCK_STREAM, 1) = 3
 [pid 21579] socket(AF_INET6, SOCK_DGRAM|SOCK_CLOEXEC, IPPROTO_IP) = 4
 [pid 21579] setsockopt(4, SOL_SOCKET, SO_REUSEPORT, [11], 4) = 0
 [pid 21579] bind(4, {sa_family=AF_INET6, sin6_port=htons(20000), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::", &sin6_addr), sin6_scope_id=0}, 28) = 0
 [pid 21579] connect(3, {sa_family=AF_PPPOX, sa_data="\1\0\0\0\0\0\0\0\4\0\0\0\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\n\0N \0\0\0\7\0\0\0\0\0\0\0\0\0\0\377\377\254\24\24\22\377\3\0\0"}, 58) = 0
 [pid 21579] close(3)                    = 0
 [pid 21579] close(4)                    = 0

The crash occurs in the socket destroy path. bpf_sk_reuseport_detach
assumes ownership of sk_user_data if sk_reuseport is set and writes a
NULL pointer to the memory pointed to by
sk_user_data. bpf_sk_reuseport_detach is called via
udp_lib_unhash. l2tp does its socket cleanup through sk_destruct,
which fetches private data through sk_user_data. The BUG_ON fires
because this data has been corrupted.

Prevent this crash by adding a check for sk_reuseport in
l2tp_validate_socket. l2tp won't be able to use SO_REUSEPORT.

This brings up two questions:

 1. If CONFIG_BPF_SYSCALL is enabled, should the SO_REUSEPORT setsockopt
    handler check that sk_user_data isn't already set on the socket?
    This crash could also occur if SO_REUSEPORT were set after the
    socket is initialised by l2tp.

 2. Should the reuseport code have a dedicated member of struct sock
    to use instead of sk_user_data such that SO_REUSEPORT can be used
    by UDP encap socket users like l2tp?

Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
Signed-off-by: James Chapman <jchapman@katalix.com>
Cc: Guillaume Nault <gnault@redhat.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/l2tp/l2tp_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6d7ef78c88af..5bfd046326ca 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1465,6 +1465,9 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 	    (encap == L2TP_ENCAPTYPE_IP && sk->sk_protocol != IPPROTO_L2TP))
 		return -EPROTONOSUPPORT;
 
+	if (sk->sk_reuseport)
+		return -EPROTONOSUPPORT;
+
 	if (sk->sk_user_data)
 		return -EBUSY;
 
-- 
2.17.1

