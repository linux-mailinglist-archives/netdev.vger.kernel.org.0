Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925A67146B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731891AbfGWIxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:53:14 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39395 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfGWIxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:53:14 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so80177379ioh.6
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 01:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MhjQXKLA4l3eKo+EelpewRDJf6MlXaudhfHLtIBD1M=;
        b=Q5o8fBuD3S5RbqFtH+SlfCtRmcPGVGsRzX5xodmqxzLsHAf8rYVM/+0BsjEbY1d2Ab
         nYz+bdn58jF0AxFDkd2O1knyEdt9u8V8pAIDqYKt/E+Ydyt36/BjXN2Np2h3dmKGoGVZ
         BrQjgNvumPDJ9SKHlvnNTERwEEVllyRDYPueb3LBHyoKVbd5xnYoEBXVsGU++Y9EL61v
         Z+EeypHRPIKLMpIG+TOX1KuDRA4FGjPC/zX/wzKIBrKFHv0+XQskJMyfks+P+V7IeRaf
         1Lhu6U0xZ3qRoIY5hiwouDuCb9JzO9Tdkkz5USMDkAEZIYWxnaMnVrDVfRRBmgQUGsDx
         JR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MhjQXKLA4l3eKo+EelpewRDJf6MlXaudhfHLtIBD1M=;
        b=ah3MZK5bNQ25/Lr5vlH9obBIDVvPDv4cwSfipUjPsEp/lwCErIDP12WBSdY6MWQYGm
         jJgbZ51kkgNGNE8h1qMyhHdbJEGJF6Szm19B6b3eUIj3jZxlrwp089Gjgw3StP/6On8n
         B0kCdzI+CRo/YEpW+dGUN0lZer2T0zn+Tl0J6z0rg8l52YzdfvsQESVPxRx23btSILu7
         2VqPDZjRdx02odm5P0ju0OvCutyoWsavVP8uj85lTk4Q6XhM50tDJf9eVVoZwVohD3ZG
         v7X/HY29GAPSnCsYjy6LuYe+cl93FsvT0RQJxUkE7/7s2AEARoemf0hVxv2S0+NfTzO3
         wzyg==
X-Gm-Message-State: APjAAAW3E5MYeHG9WA/wltdMPKu62fat0Si11a3OwnQT6DdgPPIyBGKE
        phLni6TQC7ruzTw8mGpjXoTpMDlXWexRkn9ZJXLc2jwGBT4=
X-Google-Smtp-Source: APXvYqws938JUMrM5HFKge/IHvzMAJSAXUOp9atSubpPbQ1747d2/4bDVtHfTqQe9gOoFKTK2wsue1/DHO6E3SL/rco=
X-Received: by 2002:a05:6638:303:: with SMTP id w3mr23883103jap.103.1563871992562;
 Tue, 23 Jul 2019 01:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e42667058e554371@google.com>
In-Reply-To: <000000000000e42667058e554371@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 10:53:01 +0200
Message-ID: <CACT4Y+axschTruDeODjr4OROU_+-7N-Xy00v1EXTO6j=+LJL3Q@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in nr_rx_frame (2)
To:     Ralf Baechle <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>,
        linux-hams <linux-hams@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+701728447042217b67c1@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:49 AM syzbot
<syzbot+701728447042217b67c1@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    3bfe1fc4 Merge tag 'for-5.3/dm-changes-2' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10413e34600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=21511d77e11db3cb
> dashboard link: https://syzkaller.appspot.com/bug?extid=701728447042217b67c1
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>
> Unfortunately, I don't have any reproducer for this crash yet.

+net/netrom/af_netrom.c maintainers


> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+701728447042217b67c1@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in atomic_read
> /./include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x7c/0x280
> /lib/refcount.c:123
> Read of size 4 at addr ffff88808ee52080 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0+ #35
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack /lib/dump_stack.c:77 [inline]
>   dump_stack+0x1d8/0x2f8 /lib/dump_stack.c:113
>   print_address_description+0x75/0x5b0 /mm/kasan/report.c:351
>   __kasan_report+0x14b/0x1c0 /mm/kasan/report.c:482
>   kasan_report+0x26/0x50 /mm/kasan/common.c:612
>   check_memory_region_inline /mm/kasan/generic.c:182 [inline]
>   check_memory_region+0x2cf/0x2e0 /mm/kasan/generic.c:192
>   __kasan_check_read+0x11/0x20 /mm/kasan/common.c:92
>   atomic_read /./include/asm-generic/atomic-instrumented.h:26 [inline]
>   refcount_inc_not_zero_checked+0x7c/0x280 /lib/refcount.c:123
>   refcount_inc_checked+0x15/0x50 /lib/refcount.c:156
>   sock_hold /./include/net/sock.h:649 [inline]
>   sk_add_node /./include/net/sock.h:701 [inline]
>   nr_insert_socket /net/netrom/af_netrom.c:137 [inline]
>   nr_rx_frame+0x17bc/0x1e40 /net/netrom/af_netrom.c:1023
>   nr_loopback_timer+0x6a/0x140 /net/netrom/nr_loopback.c:59
>   call_timer_fn+0xec/0x200 /kernel/time/timer.c:1322
>   expire_timers /kernel/time/timer.c:1366 [inline]
>   __run_timers+0x7cd/0x9c0 /kernel/time/timer.c:1685
>   run_timer_softirq+0x4a/0x90 /kernel/time/timer.c:1698
>   __do_softirq+0x333/0x7c4 /./arch/x86/include/asm/paravirt.h:777
>   invoke_softirq /kernel/softirq.c:373 [inline]
>   irq_exit+0x227/0x230 /kernel/softirq.c:413
>   exiting_irq /./arch/x86/include/asm/apic.h:537 [inline]
>   smp_apic_timer_interrupt+0x113/0x280 /arch/x86/kernel/apic/apic.c:1095
>   apic_timer_interrupt+0xf/0x20 /arch/x86/entry/entry_64.S:828
>   </IRQ>
> RIP: 0010:native_safe_halt+0xe/0x10 /./arch/x86/include/asm/irqflags.h:61
> Code: 06 fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 c4 41 06
> fa eb b0 90 90 e9 07 00 00 00 0f 00 2d 76 67 56 00 fb f4 <c3> 90 e9 07 00
> 00 00 0f 00 2d 66 67 56 00 f4 c3 90 90 55 48 89 e5
> RSP: 0018:ffff8880a98cfd38 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff11950db RBX: ffff8880a98bc340 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffffffff812d193a RDI: ffff8880a98bcb78
> RBP: ffff8880a98cfd40 R08: ffff8880a98bcb90 R09: ffffed1015317869
> R10: ffffed1015317869 R11: 0000000000000000 R12: 0000000000000001
> R13: 1ffff11015317868 R14: dffffc0000000000 R15: dffffc0000000000
>   arch_cpu_idle+0xa/0x10 /arch/x86/kernel/process.c:571
>   default_idle_call+0x59/0xa0 /kernel/sched/idle.c:94
>   cpuidle_idle_call /kernel/sched/idle.c:154 [inline]
>   do_idle+0x180/0x780 /kernel/sched/idle.c:263
>   cpu_startup_entry+0x25/0x30 /kernel/sched/idle.c:354
>   start_secondary+0x3f4/0x490 /arch/x86/kernel/smpboot.c:264
>   secondary_startup_64+0xa4/0xb0 /arch/x86/kernel/head_64.S:243
>
> Allocated by task 0:
>   save_stack /mm/kasan/common.c:69 [inline]
>   set_track /mm/kasan/common.c:77 [inline]
>   __kasan_kmalloc+0x11c/0x1b0 /mm/kasan/common.c:487
>   kasan_kmalloc+0x9/0x10 /mm/kasan/common.c:501
>   __do_kmalloc /mm/slab.c:3655 [inline]
>   __kmalloc+0x254/0x340 /mm/slab.c:3664
>   kmalloc /./include/linux/slab.h:557 [inline]
>   sk_prot_alloc+0xb0/0x290 /net/core/sock.c:1603
>   sk_alloc+0x38/0x950 /net/core/sock.c:1657
>   nr_make_new /net/netrom/af_netrom.c:476 [inline]
>   nr_rx_frame+0xabc/0x1e40 /net/netrom/af_netrom.c:959
>   nr_loopback_timer+0x6a/0x140 /net/netrom/nr_loopback.c:59
>   call_timer_fn+0xec/0x200 /kernel/time/timer.c:1322
>   expire_timers /kernel/time/timer.c:1366 [inline]
>   __run_timers+0x7cd/0x9c0 /kernel/time/timer.c:1685
>   run_timer_softirq+0x4a/0x90 /kernel/time/timer.c:1698
>   __do_softirq+0x333/0x7c4 /./arch/x86/include/asm/paravirt.h:777
>
> Freed by task 4044:
>   save_stack /mm/kasan/common.c:69 [inline]
>   set_track /mm/kasan/common.c:77 [inline]
>   __kasan_slab_free+0x12a/0x1e0 /mm/kasan/common.c:449
>   kasan_slab_free+0xe/0x10 /mm/kasan/common.c:457
>   __cache_free /mm/slab.c:3425 [inline]
>   kfree+0x115/0x200 /mm/slab.c:3756
>   sk_prot_free /net/core/sock.c:1640 [inline]
>   __sk_destruct+0x567/0x660 /net/core/sock.c:1726
>   sk_destruct /net/core/sock.c:1734 [inline]
>   __sk_free+0x317/0x3e0 /net/core/sock.c:1745
>   sk_free /net/core/sock.c:1756 [inline]
>   sock_put /./include/net/sock.h:1725 [inline]
>   sock_efree+0x60/0x80 /net/core/sock.c:2042
>   skb_release_head_state+0x100/0x220 /net/core/skbuff.c:652
>   skb_release_all /net/core/skbuff.c:663 [inline]
>   __kfree_skb+0x25/0x170 /net/core/skbuff.c:679
>   kfree_skb+0x6f/0xb0 /net/core/skbuff.c:697
>   nr_accept+0x4ef/0x650 /net/netrom/af_netrom.c:819
>   __sys_accept4+0x5bc/0x9a0 /net/socket.c:1750
>   __do_sys_accept /net/socket.c:1791 [inline]
>   __se_sys_accept /net/socket.c:1788 [inline]
>   __x64_sys_accept+0x7d/0x90 /net/socket.c:1788
>   do_syscall_64+0xfe/0x140 /arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff88808ee52000
>   which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 128 bytes inside of
>   2048-byte region [ffff88808ee52000, ffff88808ee52800)
> The buggy address belongs to the page:
> page:ffffea00023b9480 refcount:1 mapcount:0 mapping:ffff8880aa400e00
> index:0xffff88808ee53100 compound_mapcount: 0
> flags: 0x1fffc0000010200(slab|head)
> raw: 01fffc0000010200 ffffea0001732108 ffffea00025f5588 ffff8880aa400e00
> raw: ffff88808ee53100 ffff88808ee52000 0000000100000002 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff88808ee51f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88808ee52000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff88808ee52080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff88808ee52100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88808ee52180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e42667058e554371%40google.com.
