Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025A9349E3C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCZAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhCZAuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3916A61A0D;
        Fri, 26 Mar 2021 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616719810;
        bh=p+edR8BhaOsFtoCTytaf6Y3/npVY1ug57weWTdMGE+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UDcUkm0B9HY3vJc6dPQsSbEc1IvdXylxntmzJX8DpRkqBIOzefdegrkOMZM/5zYlM
         ekYuhALyPWzWRI9f7jG3V1diXYhGkE9oI/CjZ3jU4qr8Ekl/LemTXcMH8wJCtdOze5
         fMiYI9joGaSVPUjLYgDfiImSK7sZOonkoce7Q5/e8kjGNLw9+9w4lQmq9t2+J/BJOP
         4bFhhmCFJo7F4esKz5ZwGoT4XBRQABe0Zm/CMd5QONUr9k0wWqv4YPP48NALGT19/N
         afYWwyBbcTTAn8ioINc6I76Nx56iZh6NCywAkNQ7h+EmfBLCzvqcFy6T/Xv1aajXGW
         b/I660xzgfSQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 28D346008E;
        Fri, 26 Mar 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_red: fix off-by-one checks in red_check_params()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671981016.9054.3223205777802322875.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:50:10 +0000
References: <20210325181453.993235-1-eric.dumazet@gmail.com>
In-Reply-To: <20210325181453.993235-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Mar 2021 11:14:53 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This fixes following syzbot report:
> 
> UBSAN: shift-out-of-bounds in ./include/net/red.h:237:23
> shift exponent 32 is too large for 32-bit type 'unsigned int'
> CPU: 1 PID: 8418 Comm: syz-executor170 Not tainted 5.12.0-rc4-next-20210324-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
>  red_set_parms include/net/red.h:237 [inline]
>  choke_change.cold+0x3c/0xc8 net/sched/sch_choke.c:414
>  qdisc_create+0x475/0x12f0 net/sched/sch_api.c:1247
>  tc_modify_qdisc+0x4c8/0x1a50 net/sched/sch_api.c:1663
>  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f039
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdfa725168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
> RBP: 0000000000403020 R08: 0000000000400488 R09: 0000000000400488
> R10: 0000000000400488 R11: 0000000000000246 R12: 00000000004030b0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
> [...]

Here is the summary with links:
  - [net] sch_red: fix off-by-one checks in red_check_params()
    https://git.kernel.org/netdev/net/c/3a87571f0ffc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


