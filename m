Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA3163253F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiKUONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiKUONL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:13:11 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E763524F3E;
        Mon, 21 Nov 2022 06:11:41 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f7so16405632edc.6;
        Mon, 21 Nov 2022 06:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UHA9rIzJ9/gTEBo19qjyssF/du+MFeKm2CzLk5c34xQ=;
        b=G/quACGGOWzWxeKq0s1KITXzkrvMrZR11yIzpxDp70M/Qu886FsqugPPrTX89DFOtH
         HX5EwgVzr5hvq/3BhVn2H+rgy0K26AEPENCz3WTDjyNoO4rbKBB2KglvL+81QmroJflv
         yS1ozF1GNEnwjj1GL7QJQ0picBu0oXDeNKyEpaSf+JEP+1EpEdDbMiUnyi2+7U6wKOwn
         ShpjvgUgDmrBRxMG40dcnhXujoT25tIRAY7bbnsc1Oxy1fN59n63MyCCDmYl12vhF2wZ
         wYv0289t7QacR6o6ECINfW1BSoxm9bfwyoj94iJ5iQYqakq8k3cM1LeT0lyixQBABcbA
         x+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UHA9rIzJ9/gTEBo19qjyssF/du+MFeKm2CzLk5c34xQ=;
        b=zYW7gmft6LupVFQJWcd4Y3SJkdVRDVNfhmsuogqRC+a6ZWNO/hvuI0EkgTVYsQs3WT
         jP3RtJGKX1lgDYts4/rzKpP1HXEO73aTVKyUE3Qb4vW3lTuncVgIE57ey/pmk8n/tIr8
         K5op/kDMqAYMEc6YNGd9Mmh14H0htJEi6QbvIh4B1sMmpqAlrUfUyAxjJuEAHWw8vOMw
         toHq+LKUwt8Hx4m5OegUZkeUpgbK6qdsM9+5yq83ZTiE6Zjlx4dualYL02CBsLkOFDoK
         o2Fjqp9dnbjxGu113hlNWHdmmahLQ0qZM7KBMgXwGAg2ZaBAXUZyVmrnwoPxPQk3JY04
         1B/g==
X-Gm-Message-State: ANoB5pl6ikDq2lqH/Km6n2Hn6F++hRzmdadKF1cpb7CL2wQL0T0kaIB/
        LpP0nKeksJBXQGVpyuibXr4K6d934knDb9jevOU=
X-Google-Smtp-Source: AA0mqf5O44KsvtOmhTRgFJbGf177wr1VgGD6xdeDRetLHzjTklK3rYSYgQ1g4bgY8eWmf3YQdhpPH7uv1zOpCTjwRDQ=
X-Received: by 2002:a05:6402:612:b0:456:7669:219b with SMTP id
 n18-20020a056402061200b004567669219bmr777927edv.221.1669039900345; Mon, 21
 Nov 2022 06:11:40 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 21 Nov 2022 22:11:04 +0800
Message-ID: <CAO4mrfdN6_FE5ObRkcgwYZqedOijbwhjDnBKRf5qfE69DxwEhA@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in udpv6_sendmsg
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
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
https://drive.google.com/file/d/1bYT7pFbYHlDqcmYuvw_x7kvX9_cNEscg/view?usp=share_link
kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link
Syz reproducer:
https://drive.google.com/file/d/17GPbM4-sjSZMdakHzuLiksNE4xGUG3pU/view?usp=share_link

Unfortunately, if we transform the syz reproducer to C reproducer with
syz-prog2c, the crash would not happen. Please consider to use
syz-execprog and syz-executor to reproduce the crash.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: kernel NULL pointer dereference, address: 000000000000004e
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 129e71067 P4D 129e71067 PUD 107f78067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 3472 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:udpv6_sendmsg+0x4f3/0x16a0 net/ipv6/udp.c:1440
Code: b7 6f 02 31 ff 89 ee e8 ab 10 14 fd 85 ed 0f 84 41 03 00 00 66
89 ac 24 64 01 00 00 48 8b 6c 24 10 48 8d 7d 4e e8 9d 71 27 fd <0f> b7
6d 4e 83 e5 02 31 ff 89 ee e8 7d 10 14 fd 66 85 ed 0f 85 cb
RSP: 0018:ffffc90002a1b710 EFLAGS: 00010246
RAX: ffff888128fbca48 RBX: 0000000000000000 RCX: ffffffff8413a4c3
RDX: 00000000000008cd RSI: 0000000000000000 RDI: 000000000000004e
RBP: 0000000000000000 R08: 000000000000004f R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff888128fbc000 R12: ffff88810117dee0
R13: ffff88810117db00 R14: 00000000ffff02ff R15: ffff8881280fd088
FS:  00007ffb0eb4e700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000004e CR3: 0000000129c82000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_udp_sendmsg net/rxrpc/output.c:27 [inline]
 rxrpc_send_data_packet+0x962/0x1690 net/rxrpc/output.c:485
 rxrpc_queue_packet+0x5eb/0x6f0 net/rxrpc/sendmsg.c:264
 rxrpc_send_data+0x8ca/0xcb0 net/rxrpc/sendmsg.c:411
 rxrpc_do_sendmsg+0xb48/0xbe0 net/rxrpc/sendmsg.c:733
 rxrpc_sendmsg+0x3d7/0x4c0 net/rxrpc/af_rxrpc.c:561
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
RSP: 002b:00007ffb0eb4dc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 00000000200036c0 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffd80eca0a0
 </TASK>
Modules linked in:
CR2: 000000000000004e
---[ end trace 0000000000000000 ]---
RIP: 0010:udpv6_sendmsg+0x4f3/0x16a0 net/ipv6/udp.c:1440
Code: b7 6f 02 31 ff 89 ee e8 ab 10 14 fd 85 ed 0f 84 41 03 00 00 66
89 ac 24 64 01 00 00 48 8b 6c 24 10 48 8d 7d 4e e8 9d 71 27 fd <0f> b7
6d 4e 83 e5 02 31 ff 89 ee e8 7d 10 14 fd 66 85 ed 0f 85 cb
RSP: 0018:ffffc90002a1b710 EFLAGS: 00010246
RAX: ffff888128fbca48 RBX: 0000000000000000 RCX: ffffffff8413a4c3
RDX: 00000000000008cd RSI: 0000000000000000 RDI: 000000000000004e
RBP: 0000000000000000 R08: 000000000000004f R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff888128fbc000 R12: ffff88810117dee0
R13: ffff88810117db00 R14: 00000000ffff02ff R15: ffff8881280fd088
FS:  00007ffb0eb4e700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000004e CR3: 0000000129c82000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: b7 6f                mov    $0x6f,%bh
   2: 02 31                add    (%rcx),%dh
   4: ff 89 ee e8 ab 10    decl   0x10abe8ee(%rcx)
   a: 14 fd                adc    $0xfd,%al
   c: 85 ed                test   %ebp,%ebp
   e: 0f 84 41 03 00 00    je     0x355
  14: 66 89 ac 24 64 01 00 mov    %bp,0x164(%rsp)
  1b: 00
  1c: 48 8b 6c 24 10        mov    0x10(%rsp),%rbp
  21: 48 8d 7d 4e          lea    0x4e(%rbp),%rdi
  25: e8 9d 71 27 fd        callq  0xfd2771c7
* 2a: 0f b7 6d 4e          movzwl 0x4e(%rbp),%ebp <-- trapping instruction
  2e: 83 e5 02              and    $0x2,%ebp
  31: 31 ff                xor    %edi,%edi
  33: 89 ee                mov    %ebp,%esi
  35: e8 7d 10 14 fd        callq  0xfd1410b7
  3a: 66 85 ed              test   %bp,%bp
  3d: 0f                    .byte 0xf
  3e: 85 cb                test   %ecx,%ebx

Best,
Wei
