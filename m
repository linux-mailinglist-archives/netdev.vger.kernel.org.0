Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D63455342
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbhKRDSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 22:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbhKRDSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 22:18:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83DC061570;
        Wed, 17 Nov 2021 19:15:10 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so5714826pjj.0;
        Wed, 17 Nov 2021 19:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=tVH+ANs06Wfy5W6ZjG+wmEXeHmhH1/UzCvJA73QslpE=;
        b=JFrol9FX09JIk4s19qK0aEbF/dNHIl5qa7Vox5+bnt5s6yUMtZr+be+hQZRPNlwBnt
         GQZ9fecaT6+d645kfl9jnqj6MkMf24LunYeDjBf6/cKIMsHfA4VOj3ilI7PCJekrBTRG
         VSDcibP2F+TLSc88Xt27xbPPfzu2qY4Mnz0JwqjwpFhMU03FVDs8CwBfudAAimw0MXqu
         DnL2d7ITVEDw4NIPVv/ztRgUZz99nuEbptrRfCUsNGXhrDJvbKh22u/M2WK5rMBPo1Ih
         fLg19kl9rmNhFI6+OW+xTMJnfoibliT6Iq2otbYu49XdYmWa/OlsaIzWoUrtKDhXTLju
         TXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tVH+ANs06Wfy5W6ZjG+wmEXeHmhH1/UzCvJA73QslpE=;
        b=GxeLuPluwN4VSBENUpbM84teAvzWyzWcPsM6/uXLtVExy9ViD5bKG9FWZ4pPnJ5wi5
         kCcpM7B5VDJJs0GpBd47GbKsPc6D/Q6pwrfwK+48KuOvXPhlX/d1rPnNFny0QQimktXw
         xvklq2uoR1xotzsI6fMD1msoBX94MwMHmUfhqo1eZWOwyRWhv3viPaM+LN5AxdXxil7Q
         SBhD2zUlRORJVDxdKi68Xh9k+8n9GO/rNM3lXKzgnDsfDwVbMzhPG5jxHIUFK2Fxm+jI
         fbfDraTIgHfRIDfwAVv6rSpmU0IM6FNjL/02UOTAu3qzJYn7A3Gf39JuiN6zu0OomiFa
         8GWw==
X-Gm-Message-State: AOAM533u0o99TrPHJutcGzAz+aoELn9vySI8IrBwWGUe+U0O16zAQwD7
        5LrAuBwPJVxjKVfgGZMugNcTnuvWuupRHplZ4w==
X-Google-Smtp-Source: ABdhPJwOednNFUEmC8sxZI2ebEdLq5L3wUxQJxV+Pfo4YXh2jgFfgIh2IfBeurW5Mipy6CpsyQJ8fTLjMEpAs1rVUic=
X-Received: by 2002:a17:903:2348:b0:141:d60b:ee90 with SMTP id
 c8-20020a170903234800b00141d60bee90mr61833375plh.15.1637205309703; Wed, 17
 Nov 2021 19:15:09 -0800 (PST)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 18 Nov 2021 11:14:56 +0800
Message-ID: <CACkBjsbS6DQCgSz4c6gYS1CqgmF7=OCwm9=4vRxLHc3_uRbBRA@mail.gmail.com>
Subject: general protection fault in mpls_dev_sysctl_unregister
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiapeng.chong@linux.alibaba.com, l4stpr0gr4m@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 8ab774587903 Merge tag 'trace-v5.16-5'
git tree: upstream
console output: https://paste.ubuntu.com/p/47pQmsD3xY/plain/
kernel config: https://paste.ubuntu.com/p/cFf8tS9V8w/plain/
C reproducer: https://paste.ubuntu.com/p/Pkh4d4d9T4/plain/
Syzlang reproducer: https://paste.ubuntu.com/p/hBQDn8Kth7/plain/

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 2 PID: 1118 Comm: syz-executor Not tainted 5.16.0-rc1+ #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 fail_dump lib/fault-inject.c:52 [inline]
 should_fail.cold+0x5/0xa lib/fault-inject.c:146
 should_failslab+0x5/0x10 mm/slab_common.c:1320
 slab_pre_alloc_hook mm/slab.h:494 [inline]
 slab_alloc_node mm/slub.c:3148 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 __kmalloc+0x7e/0x3d0 mm/slub.c:4419
 kmalloc include/linux/slab.h:595 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 __register_sysctl_table+0xc3/0x1000 fs/proc/proc_sysctl.c:1318
 mpls_dev_sysctl_register+0x1b7/0x2d0 net/mpls/af_mpls.c:1421
 mpls_dev_notify+0x37c/0x730 net/mpls/af_mpls.c:1632
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2002 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1987
 call_netdevice_notifiers_extack net/core/dev.c:2014 [inline]
 call_netdevice_notifiers net/core/dev.c:2028 [inline]
 dev_change_name+0x439/0x690 net/core/dev.c:1285
 do_setlink+0x2d8c/0x39d0 net/core/rtnetlink.c:2699
 __rtnl_newlink+0xb07/0x1600 net/core/rtnetlink.c:3391
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x740 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0x100/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fcfbc2f9c4d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcfb9861c58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fcfbc4200a0 RCX: 00007fcfbc2f9c4d
RDX: 0000000000000000 RSI: 00000000200005c0 RDI: 000000000000000b
RBP: 00007fcfb9861c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000002f
R13: 00007ffd59fb09df R14: 00007ffd59fb0b80 R15: 00007fcfb9861dc0
 </TASK>
general protection fault, probably for non-canonical address
0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 2 PID: 1118 Comm: syz-executor Not tainted 5.16.0-rc1+ #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:mpls_dev_sysctl_unregister+0x6e/0xc0 net/mpls/af_mpls.c:1440
Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5c 48 b8 00 00 00
00 00 fc ff df 49 8b 6c 24 18 48 8d 7d 20 48 89 fa 48 c1 ea 03 <80> 3c
02 00 75 35 4c 8b 75 20 48 89 ef e8 e0 1f df ff 4c 89 f7 e8
RSP: 0018:ffffc9000798ecd0 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: ffff88810b7be000 RCX: 0000000000040000
RDX: 0000000000000004 RSI: ffff88802b3b9cc0 RDI: 0000000000000020
RBP: 0000000000000000 R08: ffffffff88fd2d73 R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff1b210c2 R12: ffff8880220cf480
R13: ffff888107523480 R14: ffff8880220cf480 R15: ffffffff8d76fb20
FS:  00007fcfb9862700(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9511730358 CR3: 0000000104e4e000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 mpls_dev_notify+0x371/0x730 net/mpls/af_mpls.c:1631
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2002 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1987
 call_netdevice_notifiers_extack net/core/dev.c:2014 [inline]
 call_netdevice_notifiers net/core/dev.c:2028 [inline]
 dev_change_name+0x439/0x690 net/core/dev.c:1285
 do_setlink+0x2d8c/0x39d0 net/core/rtnetlink.c:2699
 __rtnl_newlink+0xb07/0x1600 net/core/rtnetlink.c:3391
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x740 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0x100/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fcfbc2f9c4d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcfb9861c58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fcfbc4200a0 RCX: 00007fcfbc2f9c4d
RDX: 0000000000000000 RSI: 00000000200005c0 RDI: 000000000000000b
RBP: 00007fcfb9861c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000002f
R13: 00007ffd59fb09df R14: 00007ffd59fb0b80 R15: 00007fcfb9861dc0
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 7b6ee0d94ba006f4 ]---
RIP: 0010:mpls_dev_sysctl_unregister+0x6e/0xc0 net/mpls/af_mpls.c:1440
Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5c 48 b8 00 00 00
00 00 fc ff df 49 8b 6c 24 18 48 8d 7d 20 48 89 fa 48 c1 ea 03 <80> 3c
02 00 75 35 4c 8b 75 20 48 89 ef e8 e0 1f df ff 4c 89 f7 e8
RSP: 0018:ffffc9000798ecd0 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: ffff88810b7be000 RCX: 0000000000040000
RDX: 0000000000000004 RSI: ffff88802b3b9cc0 RDI: 0000000000000020
RBP: 0000000000000000 R08: ffffffff88fd2d73 R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff1b210c2 R12: ffff8880220cf480
R13: ffff888107523480 R14: ffff8880220cf480 R15: ffffffff8d76fb20
FS:  00007fcfb9862700(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9511730358 CR3: 0000000104e4e000 CR4: 0000000000350ee0
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:    df 48 89                 fisttps -0x77(%rax)
   3:    fa                       cli
   4:    48 c1 ea 03              shr    $0x3,%rdx
   8:    80 3c 02 00              cmpb   $0x0,(%rdx,%rax,1)
   c:    75 5c                    jne    0x6a
   e:    48 b8 00 00 00 00 00     movabs $0xdffffc0000000000,%rax
  15:    fc ff df
  18:    49 8b 6c 24 18           mov    0x18(%r12),%rbp
  1d:    48 8d 7d 20              lea    0x20(%rbp),%rdi
  21:    48 89 fa                 mov    %rdi,%rdx
  24:    48 c1 ea 03              shr    $0x3,%rdx
* 28:    80 3c 02 00              cmpb   $0x0,(%rdx,%rax,1) <--
trapping instruction
  2c:    75 35                    jne    0x63
  2e:    4c 8b 75 20              mov    0x20(%rbp),%r14
  32:    48 89 ef                 mov    %rbp,%rdi
  35:    e8 e0 1f df ff           callq  0xffdf201a
  3a:    4c 89 f7                 mov    %r14,%rdi
  3d:    e8                       .byte 0xe8
