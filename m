Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF8F62DE07
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiKQO0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbiKQO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:26:35 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF901D30E;
        Thu, 17 Nov 2022 06:26:34 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x102so2840838ede.0;
        Thu, 17 Nov 2022 06:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tPgDODezOqapNLak2ClY913Sk/tGT4urpTjZrSqrFWc=;
        b=BwL5w/ieioLD3xswKd5nvAmWkUyRWuW7ndyAIVFmKQHyf6M6ONlRruMPOgeHTPRszc
         98hTdPPHeWmTrUt8skzwnVf4VY3/mR+K4NADFTzJIPftEq7aiQdLVO0tzwRNjj9jfVhQ
         ThbrAoJiO5wKEu/GsymZVc1kjhjU3AQIOfYa+3IkBQ19HBwcHEtHfEDclEgEnDKANzcu
         I/HBv1i0i0iC4PnDjvLqjktZ1qg3Vh8Tg8cMSUEA7N2fvQTeNinsvSLkS1IaY/9VxTct
         z1s1kZU7P2hQ3U7+pBIXBbpBae7dNaLryTJNWD0+qnQrbxN3Mig79hm0uV6QBl3gboN7
         7EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tPgDODezOqapNLak2ClY913Sk/tGT4urpTjZrSqrFWc=;
        b=hHFvuLa3udogMyWpJQJr1euOFsiqq2wnab1rWE8vK8POjKaejRqGcJ+TRg7jroT39O
         Xmq87FNDpvPUeN2uzaX6E0BrWVG8EutMpyi1LJde8Vm0INoLnS5vrVWQX05DOYUDvf7u
         6DDJYanF3i8/Y+dyVtWdCrkBWYP1cMKrcaGuHqDZe2iDy5XxxVv7atomXNRCbJ8lm7C9
         Ho+6qRHklxgM4jpBF++tspQZQALQJw8B4+LR4NZM6SK1UO9POh2NMcaj8TgxYgc0XqIv
         PfDb+oU/5M/cMWZCDrKpmMPj4KJ/KpnyuZ7JYEu35+d9nbYMeH1CeiaQ0DLiJKjXe1Hy
         awLw==
X-Gm-Message-State: ANoB5pnaMvMTtakw2oXvk+RhXyHXBUiRJeEQ+i42BvTqFEC6Otjuqg0/
        IsqBqQ35+RD076mVOE8h5sm9ComnV4YihYLWCbM=
X-Google-Smtp-Source: AA0mqf5eYEN1B4oV3uuqSlcDYiLEhQfL2x4HoPlpwh659V+5J6FCFmiZByQHzPLTN9OMY8jKO8GqiIHz3W3lLZ4P8Yk=
X-Received: by 2002:a05:6402:612:b0:456:7669:219b with SMTP id
 n18-20020a056402061200b004567669219bmr2459902edv.221.1668695192991; Thu, 17
 Nov 2022 06:26:32 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Thu, 17 Nov 2022 22:25:59 +0800
Message-ID: <CAO4mrfcvXC5+DfuyY4dhMR3-=7B4BH7r5o-DeL0UYfDifdt+TA@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request in ip6_pol_route
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

HEAD commit: d418a331631b v6.1.0-rc5
git tree: kmsan
compiler: gcc 8.4.0
console output:
https://drive.google.com/file/d/1mvry1KoOmIUFrTN-qWTkHS9W0w7fRJvb/view?usp=share_link
kernel config: https://drive.google.com/file/d/1qltDw7jrn7_DnXvhf7MgsxO08nqGSCDe/view?usp=share_link

Unfortunately, I didn't have a reproducer for this bug.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: unable to handle page fault for address: ffff887f0c83f180
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 14 Comm: ksoftirqd/0 Not tainted 6.1.0-rc5-63183-gd418a331631b #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
RIP: 0010:rt6_get_pcpu_route net/ipv6/route.c:1396 [inline]
RIP: 0010:ip6_pol_route+0x465/0x690 net/ipv6/route.c:2251
Code: 84 24 60 07 00 00 48 89 45 a8 e9 c2 fc ff ff e8 f1 30 4b fd 48
8d 75 a8 4c 89 e7 e8 25 8b ff ff e9 c4 fc ff ff e8 db 30 4b fd <44> 8b
bb 80 00 00 00 31 ff 44 89 fe e8 da 31 4b fd 45 85 ff 74 8a
RSP: 0018:ffff88800705f988 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff887f0c83f100 RCX: ffff8880070b0000
RDX: 0000000000000000 RSI: ffff8880070b0000 RDI: 0000000000000002
RBP: ffff88800705fa08 R08: ffffffff83e034d5 R09: 0000000000000000
R10: 0000000000000007 R11: ffff887f0c83f100 R12: ffff88800db93480
R13: 0000607f810261e0 R14: 0000000000000080 R15: 0000000000000019
FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff887f0c83f180 CR3: 000000000e17a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ip6_pol_route_input+0x38/0x50 net/ipv6/route.c:2275
 pol_lookup_func include/net/ip6_fib.h:582 [inline]
 fib6_rule_lookup+0x6c/0x330 net/ipv6/fib6_rules.c:116
 ip6_route_input_lookup+0x8f/0xa0 net/ipv6/route.c:2287
 ip6_route_input+0x260/0x350 net/ipv6/route.c:2583
 ip6_rcv_finish_core.isra.21+0x6c/0x180 net/ipv6/ip6_input.c:66
 ip6_rcv_finish+0xad/0xf0 net/ipv6/ip6_input.c:77
 NF_HOOK include/linux/netfilter.h:302 [inline]
 NF_HOOK include/linux/netfilter.h:296 [inline]
 ipv6_rcv+0x10d/0x120 net/ipv6/ip6_input.c:309
 __netif_receive_skb_one_core+0x69/0xa0 net/core/dev.c:5489
 __netif_receive_skb+0x22/0xa0 net/core/dev.c:5603
 process_backlog+0xda/0x1b0 net/core/dev.c:5931
 __napi_poll+0x44/0x2c0 net/core/dev.c:6498
 napi_poll net/core/dev.c:6565 [inline]
 net_rx_action+0x397/0x480 net/core/dev.c:6676
 __do_softirq+0xe4/0x2d7 kernel/softirq.c:571
 run_ksoftirqd kernel/softirq.c:934 [inline]
 run_ksoftirqd+0x26/0x30 kernel/softirq.c:926
 smpboot_thread_fn+0x27a/0x370 kernel/smpboot.c:164
 kthread+0x13e/0x180 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
CR2: ffff887f0c83f180
---[ end trace 0000000000000000 ]---
RIP: 0010:rt6_get_pcpu_route net/ipv6/route.c:1396 [inline]
RIP: 0010:ip6_pol_route+0x465/0x690 net/ipv6/route.c:2251
Code: 84 24 60 07 00 00 48 89 45 a8 e9 c2 fc ff ff e8 f1 30 4b fd 48
8d 75 a8 4c 89 e7 e8 25 8b ff ff e9 c4 fc ff ff e8 db 30 4b fd <44> 8b
bb 80 00 00 00 31 ff 44 89 fe e8 da 31 4b fd 45 85 ff 74 8a
RSP: 0018:ffff88800705f988 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff887f0c83f100 RCX: ffff8880070b0000
RDX: 0000000000000000 RSI: ffff8880070b0000 RDI: 0000000000000002
RBP: ffff88800705fa08 R08: ffffffff83e034d5 R09: 0000000000000000
R10: 0000000000000007 R11: ffff887f0c83f100 R12: ffff88800db93480
R13: 0000607f810261e0 R14: 0000000000000080 R15: 0000000000000019
FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff887f0c83f180 CR3: 000000000e17a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 4 bytes skipped:
   0: 00 00                add    %al,(%rax)
   2: 48 89 45 a8          mov    %rax,-0x58(%rbp)
   6: e9 c2 fc ff ff        jmpq   0xfffffccd
   b: e8 f1 30 4b fd        callq  0xfd4b3101
  10: 48 8d 75 a8          lea    -0x58(%rbp),%rsi
  14: 4c 89 e7              mov    %r12,%rdi
  17: e8 25 8b ff ff        callq  0xffff8b41
  1c: e9 c4 fc ff ff        jmpq   0xfffffce5
  21: e8 db 30 4b fd        callq  0xfd4b3101
* 26: 44 8b bb 80 00 00 00 mov    0x80(%rbx),%r15d <-- trapping instruction
  2d: 31 ff                xor    %edi,%edi
  2f: 44 89 fe              mov    %r15d,%esi
  32: e8 da 31 4b fd        callq  0xfd4b3211
  37: 45 85 ff              test   %r15d,%r15d
  3a: 74 8a                je     0xffffffc6

Best,
Wei
