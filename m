Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4BA6447F8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiLFP0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiLFP0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:26:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4276DED;
        Tue,  6 Dec 2022 07:26:14 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m19so20733043edj.8;
        Tue, 06 Dec 2022 07:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+t4lRmvuP+usUZlk2JLcnWJTJvLfZrC6fX7qkvrWGoU=;
        b=F/YOy35jsCGCf2cmwHOOtG0nXSfO4POa0zBTNmrTOOFOEUF7ZWGF8bqEI/wzjeeJpm
         EAocKv7y7OfL8DQwXRdwYe3onUs4DrOvLDo06EZy6SqpD/t17OGyGmv91JzXqarSZrbn
         hv6QjcBVtHHumIK67Ba8bx1CmcBxS0toLaIXUEZeOxM8WjvuZ5G5IO62LF6Y3EV3H+Uu
         AVvAFISP8choFz6vflaKjrWhjNeyKydo1fWCLivsmZRHLZVYnJ/pZ4uELtAtkwc5zmh6
         1Fb3DD7sRx1bYzkSplYVQX7T8XI1G4Vrq5T3XKVWXbyDKEa6KEZ497Hw38pmyJ4TTl4J
         3iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+t4lRmvuP+usUZlk2JLcnWJTJvLfZrC6fX7qkvrWGoU=;
        b=a734OCsAHLjZuAWv8Y+AnuD2OmgHMVVrsqJXKjPdBdfdghxA6xE/ddPJXtu9MTlVsD
         RhkW0seKow3SHerg6pF+T7736o/4OvUUXq3w2k4sKmtAnmL5k0TfNO/fjEvbQw/gaPEg
         +aotcAEKbONxH8R85NfWMLQGn3SFBVdLtjH8HeLbYdZg2JEXO4xMoqmcKSIG09h7bC/a
         DT0oHjGzz2S+c9s5emEYmvlXEBS0Fk423yBB3AzIM03Loj9f89QuLo1pDqDHihvrz+nB
         LKTou8cWPpXKxx7xhFgFVQYiKC/BhYDXu9vAdx9tAK6N4JqbCHKuS5a+0kh3X4yLIeeS
         gBkw==
X-Gm-Message-State: ANoB5plPbWhKqU7GQiiYcJ3nakMu89mhgUoBEVrzlGvVEphmelBjil9t
        Oek6UQZlYVpP14zx+Huz4oTgw+CWlRiuuXei2JI=
X-Google-Smtp-Source: AA0mqf6t/VFxHQkD8l5o8bjbVKaGw5qFlExaBszHIi21ZJRnCAhVqEgWwcpkZi/hBI8aCFaUZl+e8AyxyCzNXcPdRbI=
X-Received: by 2002:a05:6402:528f:b0:461:9cbd:8fba with SMTP id
 en15-20020a056402528f00b004619cbd8fbamr54978909edb.19.1670340372396; Tue, 06
 Dec 2022 07:26:12 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Tue, 6 Dec 2022 23:25:36 +0800
Message-ID: <CAO4mrfcV_07hbj8NUuZrA8FH-kaRsrFy-2metecpTuE5kKHn5w@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request in can_rcv_filter
To:     socketcan@hartkopp.net, mkl@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developers,

Recently, when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit: 147307c69ba
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1_c7TZ6WzCT-VLBimUP3xnkMpJPhjOAPY/view?usp=share_link
kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link

Unfortunately, I didn't have a reproducer for this crash.

I'm wondering if there is a data race between can_receive and
sock_close, which leads to the invalid null value of dev and
dev_rcv_lists. I hope the following report is helpful.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: unable to handle page fault for address: 0000000000006020
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 132110067 P4D 132110067 PUD 1320b6067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 13844 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:can_rcv_filter+0x44/0x4e0 net/can/af_can.c:584
Code: 00 00 00 e8 3e 86 0f fd 49 8b 9e d8 00 00 00 48 89 df e8 af 81
0f fd 44 8b 23 48 8d bd 20 60 00 00 e8 a0 81 0f fd 48 89 2c 24 <8b> 9d
20 60 00 00 45 31 ed 31 ff 89 de e8 9a 1c fc fc 85 db 0f 84
RSP: 0018:ffffc90000003d50 EFLAGS: 00010246
RAX: ffff88813bc274d8 RBX: ffff8881310c5a10 RCX: ffffffff842b9940
RDX: 0000000000000522 RSI: 0000000000000000 RDI: 0000000000006020
RBP: 0000000000000000 R08: 0000000000006023 R09: 0000000000000000
R10: 0001ffffffffffff R11: 00018881310c5a04 R12: 0000000000000000
R13: ffff888106fb8880 R14: ffff8881308cba00 R15: 0000000000000000
FS:  00007fc9368b0700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000006020 CR3: 0000000132249000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000020000180 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <IRQ>
 can_receive+0x182/0x1f0 net/can/af_can.c:664
 canfd_rcv+0x9a/0x120 net/can/af_can.c:703
 __netif_receive_skb_one_core net/core/dev.c:5482 [inline]
 __netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
 process_backlog+0x23f/0x3b0 net/core/dev.c:5924
 __napi_poll+0x65/0x420 net/core/dev.c:6485
 napi_poll net/core/dev.c:6552 [inline]
 net_rx_action+0x37e/0x730 net/core/dev.c:6663
 __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
 do_softirq+0xb1/0xf0 kernel/softirq.c:472
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
 local_bh_enable+0x1b/0x20 include/linux/bottom_half.h:33
 netif_rx+0x63/0x1c0 net/core/dev.c:5003
 can_send+0x521/0x5b0 net/can/af_can.c:286
 bcm_can_tx+0x2f0/0x3f0 net/can/bcm.c:302
 bcm_tx_setup net/can/bcm.c:1020 [inline]
 bcm_sendmsg+0x1f78/0x2c50 net/can/bcm.c:1351
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
 ___sys_sendmsg net/socket.c:2530 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2559
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x4697f9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc9368afc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000006
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffe26483e60
 </TASK>
Modules linked in:
CR2: 0000000000006020
---[ end trace 0000000000000000 ]---
RIP: 0010:can_rcv_filter+0x44/0x4e0 net/can/af_can.c:584
Code: 00 00 00 e8 3e 86 0f fd 49 8b 9e d8 00 00 00 48 89 df e8 af 81
0f fd 44 8b 23 48 8d bd 20 60 00 00 e8 a0 81 0f fd 48 89 2c 24 <8b> 9d
20 60 00 00 45 31 ed 31 ff 89 de e8 9a 1c fc fc 85 db 0f 84
RSP: 0018:ffffc90000003d50 EFLAGS: 00010246
RAX: ffff88813bc274d8 RBX: ffff8881310c5a10 RCX: ffffffff842b9940
RDX: 0000000000000522 RSI: 0000000000000000 RDI: 0000000000006020
RBP: 0000000000000000 R08: 0000000000006023 R09: 0000000000000000
R10: 0001ffffffffffff R11: 00018881310c5a04 R12: 0000000000000000
R13: ffff888106fb8880 R14: ffff8881308cba00 R15: 0000000000000000
FS:  00007fc9368b0700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000006020 CR3: 0000000132249000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000020000180 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
----------------
Code disassembly (best guess):
   0: 00 00                add    %al,(%rax)
   2: 00 e8                add    %ch,%al
   4: 3e 86 0f              xchg   %cl,%ds:(%rdi)
   7: fd                    std
   8: 49 8b 9e d8 00 00 00 mov    0xd8(%r14),%rbx
   f: 48 89 df              mov    %rbx,%rdi
  12: e8 af 81 0f fd        callq  0xfd0f81c6
  17: 44 8b 23              mov    (%rbx),%r12d
  1a: 48 8d bd 20 60 00 00 lea    0x6020(%rbp),%rdi
  21: e8 a0 81 0f fd        callq  0xfd0f81c6
  26: 48 89 2c 24          mov    %rbp,(%rsp)
* 2a: 8b 9d 20 60 00 00    mov    0x6020(%rbp),%ebx <-- trapping instruction
  30: 45 31 ed              xor    %r13d,%r13d
  33: 31 ff                xor    %edi,%edi
  35: 89 de                mov    %ebx,%esi
  37: e8 9a 1c fc fc        callq  0xfcfc1cd6
  3c: 85 db                test   %ebx,%ebx
  3e: 0f                    .byte 0xf
  3f: 84                    .byte 0x84

Best,
Wei
