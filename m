Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3446E1ADB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 05:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDNDgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 23:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDNDgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 23:36:06 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25AB30FA;
        Thu, 13 Apr 2023 20:36:04 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q5so20405984ybk.7;
        Thu, 13 Apr 2023 20:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681443364; x=1684035364;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=paJ5hRO9EMV/Yv7G3XVsFSJRRP7FHyA9IIQOu6K6c3U=;
        b=gypS9R9Xjh3IysKxBOiWkZXgor4O2y0l74oKJrOxWOZlqFtbGq1I0SvZM6worKJ1/8
         RShsktY20SsfNpilwszhDQJ5tmcgYCoARcr7101Y1Udo/Qh2cv0V4Kr75OvFlfac8SBm
         Luj9KNQs871SbNeOIdYrkT7CpaVBR7uhMpmNCxzb/xDokXG0S0LXPFlUHa4/6JnFYlWC
         FiYP+BTFMDelAnrUHEzLxGw9MhETXUDhjIMSO0VHw99t3PCymhcaqqiUcCKpTy4Zmc38
         oIqgMPxb41+XPd5HIq08Ril4dN4/M3eYGg0zPZhfgnJFjlLS+XMS7dJbw+jP149DuTRU
         6NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681443364; x=1684035364;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=paJ5hRO9EMV/Yv7G3XVsFSJRRP7FHyA9IIQOu6K6c3U=;
        b=exbNnQyLBGbG2PgWZddKwBbc9RQf0ZkSNUKFMQwlmpzpVW/NKjgM9nvJAkq4B3CAt4
         7b4Arcns9daebY+WdUGqzX1xeBv/ndQ50IqawsnSCYGvWv59NhLRcp3hrYic/vCPQ6yt
         Sdc6pvPyLb17aP9BV28POKgTcSrvIZPVDjms+M9k/IJt1dsS+c7vDGo48K2oPElKg9yP
         55MsxzXFnol9QOD9uhDnHbQ2sd+B/bM9y3OooD4WV1FD6HsH05eRd6krY4Fef3Fd5MFY
         A/sXyeiyxG+/b2y6qwPKBWet9Zq3wceV5RSNfkz+PnMu83f1OGVuN5V8vZzwwtv++Z+N
         nbTw==
X-Gm-Message-State: AAQBX9fBp5f6eHQNVaUPZIb7FCcHfwEUv82Q5sN4qyFVjWizWSKn35Bw
        7puz0v/iiH5yK90TCSUlP0PAkWyBLFOFnIVDZ5OU7iyVqN7mf6c3
X-Google-Smtp-Source: AKy350ZUb9uD4VSSEoJLYAGtmi4TfBtVx2vd7ZIcrZM9ZYLkdhZ7os26wKYWujqZGdJQz1DyHZKk/tkvuyPVPqJgPak=
X-Received: by 2002:a25:d2d2:0:b0:b8f:480c:ba49 with SMTP id
 j201-20020a25d2d2000000b00b8f480cba49mr2528936ybg.4.1681443363892; Thu, 13
 Apr 2023 20:36:03 -0700 (PDT)
MIME-Version: 1.0
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Thu, 13 Apr 2023 20:35:52 -0700
Message-ID: <CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com>
Subject: kernel BUG in fou_build_udp
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I found the following issue using syzkaller with enriched corpus on:
HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
git tree: linux

C Reproducer : https://gist.github.com/oswalpalash/2a4bdb639c605ec80dbeec220e09603c
Kernel .config :
https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f
syz-repro :
r0 = socket$inet6(0xa, 0x2, 0x0)
r1 = socket$nl_route(0x10, 0x3, 0x0)
r2 = socket(0x10, 0x803, 0x0)
sendmsg$nl_route(r2, &(0x7f0000000380)={0x0, 0x0,
&(0x7f0000000340)={0x0, 0x14}}, 0x0)
getsockname$packet(r2, &(0x7f0000000100)={0x11, 0x0, <r3=>0x0, 0x1,
0x0, 0x6, @broadcast}, &(0x7f00000000c0)=0x14)
sendmsg$nl_route(r1, &(0x7f0000000080)={0x0, 0x0,
&(0x7f0000000500)={&(0x7f0000000180)=@newlink={0x60, 0x10, 0x439, 0x0,
0x0, {0x0, 0x0, 0x0, 0x0, 0x9801}, [@IFLA_LINKINFO={0x40, 0x12, 0x0,
0x1, @sit={{0x8}, {0x34, 0x2, 0x0, 0x1, [@IFLA_IPTUN_LINK={0x8, 0x1,
r3}, @IFLA_IPTUN_ENCAP_TYPE={0x6, 0xf, 0x2},
@IFLA_IPTUN_ENCAP_SPORT={0x6, 0x11, 0x4e21},
@IFLA_IPTUN_ENCAP_SPORT={0x6, 0x11, 0x4e24}, @IFLA_IPTUN_LOCAL={0x8,
0x2, @dev={0xac, 0x14, 0x14, 0x16}}, @IFLA_IPTUN_ENCAP_FLAGS={0x6,
0x10, 0xfff}]}}}]}, 0x60}}, 0x20048894)
sendmmsg$inet(r0, &(0x7f00000017c0)=[{{&(0x7f0000000040)={0x2, 0x4e20,
@multicast1}, 0x10, 0x0, 0x0, &(0x7f0000000000)=[@ip_pktinfo={{0x1c,
0x0, 0x8, {r3, @empty, @remote}}}], 0x20}}], 0x1, 0x0)


Console log:

skbuff: skb_under_panic: text:ffffffff88a09da0 len:48 put:8
head:ffff88801e4be680 data:ffff88801e4be67c tail:0x2c end:0x140
dev:sit1
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:150!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10068 Comm: syz-executor.3 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_panic+0x152/0x1d0
Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48
c7 c7 80 b3 5b 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 ae 15 6c f9 <0f> 0b
4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 69 1f d8 f9 4c
RSP: 0018:ffffc900029bead0 EFLAGS: 00010282
RAX: 0000000000000084 RBX: ffff88801d1c3d00 RCX: ffffc9000d863000
RDX: 0000000000000000 RSI: ffffffff816695cc RDI: 0000000000000005
RBP: ffffffff8b5bc1e0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000400 R11: 0000000000000000 R12: ffffffff88a09da0
R13: 0000000000000008 R14: ffff8880306b8000 R15: 0000000000000140
FS:  00007f1dae5ed700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564f403b7d10 CR3: 0000000117f1c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_push+0xc8/0xe0
 fou_build_udp+0x30/0x370
 gue_build_header+0xfb/0x150
 ip_tunnel_xmit+0x66e/0x3150
 sit_tunnel_xmit__.isra.0+0xe7/0x150
 sit_tunnel_xmit+0xf7e/0x28e0
 dev_hard_start_xmit+0x187/0x700
 __dev_queue_xmit+0x2ce4/0x3c40
 neigh_connected_output+0x3c2/0x550
 ip_finish_output2+0x78a/0x22e0
 __ip_finish_output+0x396/0x650
 ip_finish_output+0x31/0x280
 ip_mc_output+0x21f/0x710
 ip_send_skb+0xd8/0x260
 udp_send_skb+0x73a/0x1480
 udp_sendmsg+0x1bb2/0x2840
 udpv6_sendmsg+0x1710/0x2c20
 inet6_sendmsg+0x9d/0xe0
 sock_sendmsg+0xde/0x190
 ____sys_sendmsg+0x334/0x900
 ___sys_sendmsg+0x110/0x1b0
 __sys_sendmmsg+0x18f/0x460
 __x64_sys_sendmmsg+0x9d/0x100
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f1dad88eacd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1dae5ecbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1dad9bbf80 RCX: 00007f1dad88eacd
RDX: 0000000000000001 RSI: 00000000200017c0 RDI: 0000000000000003
RBP: 00007f1dad8fcb05 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff4922802f R14: 00007fff492281d0 R15: 00007f1dae5ecd80
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_panic+0x152/0x1d0
Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48
c7 c7 80 b3 5b 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 ae 15 6c f9 <0f> 0b
4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 69 1f d8 f9 4c
RSP: 0018:ffffc900029bead0 EFLAGS: 00010282
RAX: 0000000000000084 RBX: ffff88801d1c3d00 RCX: ffffc9000d863000
RDX: 0000000000000000 RSI: ffffffff816695cc RDI: 0000000000000005
RBP: ffffffff8b5bc1e0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000400 R11: 0000000000000000 R12: ffffffff88a09da0
R13: 0000000000000008 R14: ffff8880306b8000 R15: 0000000000000140
FS:  00007f1dae5ed700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564f403b7d10 CR3: 0000000117f1c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
