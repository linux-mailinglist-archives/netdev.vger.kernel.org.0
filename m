Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097F25FE4E
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfGDV7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:59:54 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:44429 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDV7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:59:53 -0400
Received: by mail-qt1-f177.google.com with SMTP id 44so5467589qtg.11
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ueu/SSCXdhaNzHSOXK+6ATPWeNJ2KQnjdf3IJwboYQY=;
        b=ZSCaLCYc+dIUYeg3NJlMxHLpepJbWpaSHj+QmSIMzus1NAa00CvwswTmcMOFH78Nok
         8HzK45D703Jp9DWfGhEC//bnmzNEAXd8M29f6W+kIId7j1qYo2q60o0uN4LgJPxrPl1H
         KSobCThPJnrnlXlwqg1yCjIkqypIEhZqRAoR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ueu/SSCXdhaNzHSOXK+6ATPWeNJ2KQnjdf3IJwboYQY=;
        b=sdP3paZEUhjf6PImWn7RdHbxP71vrTa/decL5nLve3HWLMk7GHeDn9XrA6lxzr1SHG
         Gy5+N0NlXMD1atxLpasIV9qJexzx2pBXElaR3qNfKiRzScLaev6J483W6PuYINFMwZSd
         vkT36PiiBD6uXGH/rRGZbhTB1NkHBJtdyqBxFLOQ0d8QrH086Tr6ZS+9S/3sqftzElCd
         b29H8zz9+XWcJpOgBR1KDOnmV97ppX90g12RlIh4Xw156ybydIwKa36AdRSSt1adqwuJ
         i0drv1ErxyzWLc/QK1IFI02xpn+CKdAISCJVFnePgNUn28Cx/aqGbWlOVfEMj622yfQ3
         PuZQ==
X-Gm-Message-State: APjAAAX0waC2FI9qbDrROeYXp3KFn50t1+DlWPhskDoAkaUaWSXjvPxW
        mwbt48+tizN0WxBoO32JNWkqexvKERI1mOXiGoBmbw==
X-Google-Smtp-Source: APXvYqxSTiL7QF/+1IbqK8BRLR7mN6vsI2+95vJl5soh3PhWFFg7XHHqMSQm44Xquy0EGhHzo1JOtoyPQhEXyQgJUZc=
X-Received: by 2002:aed:3a03:: with SMTP id n3mr63045qte.85.1562277592145;
 Thu, 04 Jul 2019 14:59:52 -0700 (PDT)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Thu, 4 Jul 2019 23:59:40 +0200
Message-ID: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
Subject: NEIGH: BUG, double timer add, state is 8
To:     David Miller <davem@davemloft.net>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Morning,

I found a way to hit an obscure BUG in the
net/core/neighbour.c:neigh_add_timer(), by piping two carefully
crafted messages into AF_NETLINK socket.

https://github.com/torvalds/linux/blob/v5.2-rc7/net/core/neighbour.c#L259

    if (unlikely(mod_timer(&n->timer, when))) {
        printk("NEIGH: BUG, double timer add, state is %x\n", n->nud_state);
        dump_stack();
     }

The repro is here:
https://gist.github.com/majek/d70297b9d72bc2e2b82145e122722a0c

wget https://gist.githubusercontent.com/majek/d70297b9d72bc2e2b82145e122722a0c/raw/9e140bcedecc28d722022f1da142a379a9b7a7b0/double_timer_add_bug.c

You need root for AF_NETLINK socket. I would lie if I said I
understand what these netlink messages actually do.

Tested under virtme, with 5.2-rc7 kernel.

Full stack trace:

4,147643,57161310899,-;NEIGH: BUG, double timer add, state is 8
4,147644,57161311114,-;CPU: 0 PID: 266 Comm: xxx Not tainted 5.2.0-rc7kvm+ #6
4,147645,57161311260,-;Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
4,147646,57161311401,-;Call Trace:
4,147647,57161311616,-; dump_stack (linux/lib/dump_stack.c:115)
4,147648,57161311771,-; neigh_add_timer
(linux/net/core/neighbour.c:265 linux/net/core/neighbour.c:259)
4,147649,57161311878,-; __neigh_event_send (linux/net/core/neighbour.c:1143)
4,147650,57161312043,-; ? lockdep_hardirqs_on
(linux/kernel/locking/lockdep.c:3218
linux/kernel/locking/lockdep.c:3263)
4,147651,57161312205,-; ? __local_bh_enable_ip
(linux/arch/x86/include/asm/paravirt.h:777 linux/kernel/softirq.c:194)
4,147652,57161312311,-; ? neigh_lookup
(linux/include/linux/rcupdate.h:213 linux/include/linux/rcupdate.h:680
linux/net/core/neighbour.c:539)
4,147653,57161312454,-; ? trace_hardirqs_on
(linux/kernel/trace/trace_preemptirq.c:32)
4,147654,57161312579,-; ? neigh_lookup (linux/net/core/neighbour.c:1106)
4,147655,57161312700,-; ? __local_bh_enable_ip
(linux/arch/x86/include/asm/paravirt.h:777 linux/kernel/softirq.c:194)
4,147656,57161312804,-; ? neigh_lookup (linux/net/core/neighbour.c:541)
4,147657,57161312949,-; ? udp_gro_receive.cold.8 (linux/net/ipv4/arp.c:216)
4,147658,57161313087,-; neigh_add (linux/include/net/neighbour.h:445
linux/net/core/neighbour.c:1963)
4,147659,57161313216,-; ? neigh_xmit (linux/net/core/neighbour.c:1850)
4,147660,57161313346,-; ? __sanitizer_cov_trace_const_cmp8
(linux/kernel/kcov.c:198)
4,147661,57161313522,-; ? neigh_xmit (linux/net/core/neighbour.c:1850)
4,147662,57161313644,-; rtnetlink_rcv_msg (linux/net/core/rtnetlink.c:5214)
4,147663,57161313751,-; ? rtnetlink_put_metrics
(linux/net/core/rtnetlink.c:5117)
4,147664,57161313875,-; ? find_held_lock (linux/kernel/locking/lockdep.c:3898)
4,147665,57161314023,-; netlink_rcv_skb (linux/net/netlink/af_netlink.c:2483)
4,147666,57161314152,-; ? rtnetlink_put_metrics
(linux/net/core/rtnetlink.c:5117)
4,147667,57161314311,-; ? netlink_ack (linux/net/netlink/af_netlink.c:2459)
4,147668,57161314416,-; ? netlink_deliver_tap
(linux/net/netlink/af_netlink.c:333)
4,147669,57161314538,-; rtnetlink_rcv (linux/net/core/rtnetlink.c:5233)
4,147670,57161314701,-; netlink_unicast
(linux/net/netlink/af_netlink.c:1308
linux/net/netlink/af_netlink.c:1333)
4,147671,57161314811,-; ? netlink_attachskb
(linux/net/netlink/af_netlink.c:1318)
4,147672,57161315093,-; ? _copy_from_iter_full (linux/lib/iov_iter.c:780)
4,147673,57161315239,-; netlink_sendmsg (linux/net/netlink/af_netlink.c:1922)
4,147674,57161315349,-; ? netlink_unicast (linux/net/netlink/af_netlink.c:1848)
4,147675,57161315543,-; ? apparmor_socket_sendmsg
(linux/security/apparmor/lsm.c:937)
4,147676,57161315690,-; ? netlink_unicast (linux/net/netlink/af_netlink.c:1848)
4,147677,57161315838,-; sock_sendmsg (linux/net/socket.c:646
linux/net/socket.c:665)
4,147678,57161315983,-; ___sys_sendmsg (linux/net/socket.c:2286)
4,147679,57161316105,-; ? trace_hardirqs_on
(linux/kernel/trace/trace_preemptirq.c:32)
4,147680,57161316247,-; ? copy_msghdr_from_user (linux/net/socket.c:2214)
4,147681,57161316361,-; ? __wake_up_common_lock (linux/kernel/sched/wait.c:125)
4,147682,57161316470,-; ? __wake_up_common (linux/kernel/sched/wait.c:112)
4,147683,57161316584,-; ? _raw_write_unlock_irq
(linux/arch/x86/include/asm/paravirt.h:777
linux/include/linux/rwlock_api_smp.h:267
linux/kernel/locking/spinlock.c:343)
4,147684,57161316757,-; ? trace_hardirqs_on
(linux/kernel/trace/trace_preemptirq.c:32)
4,147685,57161316867,-; ? __wake_up (linux/kernel/sched/wait.c:147)
4,147686,57161316985,-; ? netlink_bind (linux/net/netlink/af_netlink.c:981)
4,147687,57161317096,-; ? netlink_setsockopt
(linux/net/netlink/af_netlink.c:981)
4,147688,57161317223,-; ? kasan_check_read (linux/mm/kasan/common.c:95)
4,147689,57161317346,-; ? __fget_light
(linux/include/linux/compiler.h:194
linux/arch/x86/include/asm/atomic.h:31
linux/include/asm-generic/atomic-instrumented.h:27
linux/fs/file.c:770)
4,147690,57161317454,-; ? __sanitizer_cov_trace_const_cmp8
(linux/kernel/kcov.c:198)
4,147691,57161317561,-; ? sockfd_lookup_light (linux/net/socket.c:505)
4,147692,57161317685,-; __sys_sendmsg (linux/net/socket.c:2326)
4,147693,57161317821,-; ? __ia32_sys_shutdown (linux/net/socket.c:2312)
4,147694,57161317927,-; ? __fd_install
(linux/arch/x86/include/asm/preempt.h:84
linux/include/linux/rcupdate.h:724 linux/fs/file.c:608)
4,147695,57161318050,-; ? fd_install (linux/fs/file.c:614)
4,147696,57161318162,-; ? entry_SYSCALL_64_after_hwframe
(linux/arch/x86/entry/entry_64.S:177)
4,147697,57161318270,-; ? lockdep_hardirqs_on
(linux/kernel/locking/lockdep.c:3218
linux/kernel/locking/lockdep.c:3263)
4,147698,57161318413,-; __x64_sys_sendmsg (linux/net/socket.c:2331)
4,147699,57161318532,-; do_syscall_64 (linux/arch/x86/entry/common.c:301)
4,147700,57161318640,-; entry_SYSCALL_64_after_hwframe
(linux/arch/x86/entry/entry_64.S:177)
4,147701,57161318768,-;RIP: 0033:0x7f7c28863d04
4,147702,57161318901,-;Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
b5 0f 1f 80 00 00 00 00 48 8d 05 01 dc 2c 00 8b 00 85 c0 75 13 b8 2e
00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 41 89 d4
53 48 89 f5
All code
========
0: 00 f7 add %dh,%bh
2: d8 64 89 02 fsubs 0x2(%rcx,%rcx,4)
6: 48 c7 c0 ff ff ff ff mov $0xffffffffffffffff,%rax
d: eb b5 jmp 0xffffffffffffffc4
f: 0f 1f 80 00 00 00 00 nopl 0x0(%rax)
16: 48 8d 05 01 dc 2c 00 lea 0x2cdc01(%rip),%rax # 0x2cdc1e
1d: 8b 00 mov (%rax),%eax
1f: 85 c0 test %eax,%eax
21: 75 13 jne 0x36
23: b8 2e 00 00 00 mov $0x2e,%eax
28: 0f 05 syscall
2a:* 48 3d 00 f0 ff ff cmp $0xfffffffffffff000,%rax <-- trapping instruction
30: 77 54 ja 0x86
32: f3 c3 repz retq
34: 66 90 xchg %ax,%ax
36: 41 54 push %r12
38: 55 push %rbp
39: 41 89 d4 mov %edx,%r12d
3c: 53 push %rbx
3d: 48 89 f5 mov %rsi,%rbp

Code starting with the faulting instruction
===========================================
0: 48 3d 00 f0 ff ff cmp $0xfffffffffffff000,%rax
6: 77 54 ja 0x5c
8: f3 c3 repz retq
a: 66 90 xchg %ax,%ax
c: 41 54 push %r12
e: 55 push %rbp
f: 41 89 d4 mov %edx,%r12d
12: 53 push %rbx
13: 48 89 f5 mov %rsi,%rbp
4,147703,57161319051,-;RSP: 002b:00007ffd5901b648 EFLAGS: 00000246
ORIG_RAX: 000000000000002e
4,147704,57161319210,-;RAX: ffffffffffffffda RBX: 000000000000003b
RCX: 00007f7c28863d04
4,147705,57161319369,-;RDX: 0000000000000000 RSI: 00007ffd5901b710
RDI: 0000000000000006
4,147706,57161319495,-;RBP: 0000000000000006 R08: 0000000000000010
R09: 0000000000000000
4,147707,57161319664,-;R10: 00007ffd5901b758 R11: 0000000000000246
R12: 00007f7c28cc3f70
4,147708,57161319771,-;R13: 00007ffd5901d790 R14: 0000000000000000
R15: 00007ffd5901b750

Cheers,
    Marek
