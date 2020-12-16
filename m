Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B552DC08E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLPM51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 07:57:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgLPM50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 07:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608123359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvnqyhkUs+O9JM4Ijw4aWtpwD224dnhWB1WsqsNuA+0=;
        b=IOne32uWFDj3FenGhIU3na3jy6SWhaRl2v3T8nRVj45LhkQE5qMX7yOGqLxvJyTV5tI2bC
        py6sqeltJcf8waEcqPg3BtZLybtrP6YsBE7n6yBS52Ex7HN637vYpi4y7od42Clt3E+sBx
        vKG7IeR75dzFnzAKFAMlTPW2W6DxK28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-iNAezxWrNKm6iQw0GMiM2g-1; Wed, 16 Dec 2020 07:55:55 -0500
X-MC-Unique: iNAezxWrNKm6iQw0GMiM2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1648107ACE4;
        Wed, 16 Dec 2020 12:55:53 +0000 (UTC)
Received: from [10.40.194.105] (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19D9B10023B3;
        Wed, 16 Dec 2020 12:55:50 +0000 (UTC)
Message-ID: <eb1a4c76c61031d0155bfe19cc7cb23c9d97506e.camel@redhat.com>
Subject: Re: general protection fault in taprio_dequeue_soft
From:   Davide Caratti <dcaratti@redhat.com>
To:     syzbot <syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
In-Reply-To: <000000000000bd226505b67d9989@google.com>
References: <000000000000bd226505b67d9989@google.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 16 Dec 2020 13:55:49 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 01:44 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7f376f19 Merge tag 'mtd/fixes-for-5.10-rc8' of git://git.k..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=13842287500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3416bb960d5c705d
> dashboard link: https://syzkaller.appspot.com/bug?extid=8971da381fb5a31f542d
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128c5745500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a1f123500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:taprio_dequeue_soft+0x22e/0xa40 net/sched/sch_taprio.c:544
> Code: 24 18 e8 d5 3e 4c fa 48 8b 44 24 10 80 38 00 0f 85 4c 07 00 00 48 8b 93 c0 02 00 00 49 63 c5 4c 8d 24 c2 4c 89 e0 48 c1 e8 03 <80> 3c 28 00 0f 85 3c 07 00 00 4d 8b 24 24 4d 85 e4 0f 84 87 03 00
> RSP: 0018:ffffc90000d90e08 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8880282e3800 RCX: ffffffff8723c557
> RDX: 0000000000000000 RSI: ffffffff8723c59b RDI: 0000000000000005
> RBP: dffffc0000000000 R08: 0000000000000001 R09: ffffffff8ebaf667
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000401 R15: ffff88801917e000
> FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000600 CR3: 0000000013cdc000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  dequeue_skb net/sched/sch_generic.c:263 [inline]
>  qdisc_restart net/sched/sch_generic.c:366 [inline]
>  __qdisc_run+0x1ae/0x15e0 net/sched/sch_generic.c:384
>  qdisc_run include/net/pkt_sched.h:131 [inline]
>  qdisc_run include/net/pkt_sched.h:123 [inline]
>  net_tx_action+0x4b9/0xbf0 net/core/dev.c:4915
>  __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
>  asm_call_irq_on_stack+0xf/0x20
>  </IRQ>
>  __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
>  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
>  do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
>  invoke_softirq kernel/softirq.c:393 [inline]
>  __irq_exit_rcu kernel/softirq.c:423 [inline]
>  irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
>  sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
> RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
> RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
> RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
> RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517
> Code: 5d 07 88 f8 84 db 75 ac e8 44 0f 88 f8 e8 bf cd 8d f8 e9 0c 00 00 00 e8 35 0f 88 f8 0f 00 2d 9e 86 c0 00 e8 29 0f 88 f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 84 07 88 f8 48 85 db
> RSP: 0018:ffffc90000d27d18 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffffffff19d8e91
> RDX: ffff888010d98000 RSI: ffffffff88e7f547 RDI: 0000000000000000
> RBP: ffff888014e50064 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
> R13: ffff888014e50000 R14: ffff888014e50064 R15: ffff88801747a804
>  acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:648
>  cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
>  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
>  call_cpuidle kernel/sched/idle.c:158 [inline]
>  cpuidle_idle_call kernel/sched/idle.c:239 [inline]
>  do_idle+0x3e1/0x590 kernel/sched/idle.c:299
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:395
>  start_secondary+0x266/0x340 arch/x86/kernel/smpboot.c:266
>  secondary_startup_64_no_verify+0xb0/0xbb
> Modules linked in:
> ---[ end trace 86b7dd17b9a0a261 ]---
> RIP: 0010:taprio_dequeue_soft+0x22e/0xa40 net/sched/sch_taprio.c:544
> Code: 24 18 e8 d5 3e 4c fa 48 8b 44 24 10 80 38 00 0f 85 4c 07 00 00 48 8b 93 c0 02 00 00 49 63 c5 4c 8d 24 c2 4c 89 e0 48 c1 e8 03 <80> 3c 28 00 0f 85 3c 07 00 00 4d 8b 24 24 4d 85 e4 0f 84 87 03 00
> RSP: 0018:ffffc90000d90e08 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8880282e3800 RCX: ffffffff8723c557
> RDX: 0000000000000000 RSI: ffffffff8723c59b RDI: 0000000000000005
> RBP: dffffc0000000000 R08: 0000000000000001 R09: ffffffff8ebaf667
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000401 R15: ffff88801917e000
> FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000600 CR3: 0000000013cdc000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

I think we need to flush "child" qdiscs before freeing them in
taprio_destroy(): I will try a small patch in the afternoon.
thanks!
-- 
davide


