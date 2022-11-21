Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6816323CA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiKUNfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiKUNf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:35:28 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACCEC2861;
        Mon, 21 Nov 2022 05:35:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n20so28704370ejh.0;
        Mon, 21 Nov 2022 05:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MT/mDPunmpZkQYduqB03m7NQP5pzN87dgitwN/HYU7A=;
        b=CoKc/6Bb1AV3k8IdxTbt6tZlHKsivkOczhPKox/V+QTlkT1uargtP2LUV+8sT9WkQj
         pvJRFVonvKjnpRezaZvWQx7rLIMagOo4WJ1Ypi5na3LEIAN2o3VLoaOHray1VmypR2Ga
         NKLjCVG7aZ78Q8QXkeHI0g29W7j7G25xC8hFtxuBKnpij+6sdVQQv0Ji4xZNHFpgD53C
         enOm2roqiG5g9ZwDL3R5zp+lx0gO4f0BHTtZ2dMwXto77rBxmgBl5lUg8Lvci8VqYlJE
         pb+Vw/v4caRD6odLlAD6Q5R6wDjqFqbjw1nrLPK6cRxFxapFrtTrET7NFTWxblYdMwYp
         hw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MT/mDPunmpZkQYduqB03m7NQP5pzN87dgitwN/HYU7A=;
        b=7YcpkMKHdamnqL0ZbQ8E9QyIeiZ0imF2ULIPmCCXFTevjn5u0/JL1xHP+wxfcIpGBH
         KPL5Sfz8ts8wHBimuYJxlVvhpMhyMJjkt8jV6vW8Yf7aiaurESOIrtaBLRAEt63VFCkd
         ZcX+QqHbFEFkN8/WwRvpaYWckV82x0xus3FRzaipFViw9s5Fk1wF+habj60FxwNHEZLL
         9Z9J3aW56mmZD1zfo+oe9y+SmMfPRTKUJ3lGRwoyqCqxWXyuFOIPdO45vHKlvC1OtLO9
         yyICJw5w4uaQInzr6hhklqZO+WrmCE+zq+mK0K1PQdiP7qsiWJG4948bAyfdOHP8UsO+
         5LHA==
X-Gm-Message-State: ANoB5pkPGTPJtjkz9+1+D7tzMHlfs4m82MdW/JbUOKIXXLpiHZ4NCNbT
        WKH75CXmGsp8EKCZ86tS2isc1vZyhTn5F31sx/0=
X-Google-Smtp-Source: AA0mqf5eQ9XpfksKT4UVIy9uA1NGYop+bHN7t5i1m6nQQsgiEtLOugGVUxnfu/27Dni+z1g27Jn5QGQ/nOS5cunBEH8=
X-Received: by 2002:a17:906:802:b0:7b5:6f12:f2c9 with SMTP id
 e2-20020a170906080200b007b56f12f2c9mr5513648ejd.739.1669037725740; Mon, 21
 Nov 2022 05:35:25 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 21 Nov 2022 21:34:50 +0800
Message-ID: <CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in sk_diag_fill
To:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, Jason@zx2c4.com,
        chentao.kernel@linux.alibaba.com, harshit.m.mogalapalli@oracle.com
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

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit: 147307c69ba
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1WZBgd9dodq3qWgqIXNNBHNEpayHthWr5/view?usp=share_link
kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link

Unfortunately, I didn't have a reproducer for this crash. My manual
check identifies that sk->sk_socket in sk_user_ns is null.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: kernel NULL pointer dereference, address: 0000000000000270
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unix_diag_get_exact net/unix/diag.c:285 [inline]
 unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
 __sock_diag_cmd net/core/sock_diag.c:235 [inline]
 sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
 netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
 sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
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
RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
 </TASK>
Modules linked in:
CR2: 0000000000000270
---[ end trace 0000000000000000 ]---
RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 89 ef                mov    %ebp,%edi
   2: e8 66 d4 2d fd        callq  0xfd2dd46d
   7: c7 44 24 40 00 00 00 movl   $0x0,0x40(%rsp)
   e: 00
   f: 49 8d 7c 24 18        lea    0x18(%r12),%rdi
  14: e8 54 d7 2d fd        callq  0xfd2dd76d
  19: 49 8b 5c 24 18        mov    0x18(%r12),%rbx
  1e: 48 8d bb 70 02 00 00 lea    0x270(%rbx),%rdi
  25: e8 43 d7 2d fd        callq  0xfd2dd76d
* 2a: 48 8b 9b 70 02 00 00 mov    0x270(%rbx),%rbx <-- trapping instruction
  31: 48 8d 7b 10          lea    0x10(%rbx),%rdi
  35: e8 33 d7 2d fd        callq  0xfd2dd76d
  3a: 48 8b 5b 10          mov    0x10(%rbx),%rbx
  3e: 48                    rex.W
  3f: 8d                    .byte 0x8d


Best,
Wei
