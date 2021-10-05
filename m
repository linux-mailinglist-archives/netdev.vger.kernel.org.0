Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42D04225B2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhJELwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJELv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE91861425;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633434608;
        bh=IQ3fpWNuaV4mQp5C5VvIE3AuQM6/pWCeKZxi/DGFUis=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q7TaEf9t0IOp2SL1f0AHWpyBpjMHO/egoilcTu8j65D+UnL55RVQgB7LPNOcnQPiB
         VjX74s0JaIRi6fW1RVLe8J4Nlap0gRM9PRsWppV3DMPYhnhbxDc2alXu+S+vFWlQpV
         WWczjBh8B/HgUSAukw9oN8a74ZkWQ3w4QWJfN/vsOtmCyozprNVSZULq7K395fdo/c
         065o6LDI6I6ZS+rtP27QoR83spKw5YFXxBTrO9DmSuet8qzaTg9NFcvMTxUfVfWWrm
         8unC5SnwJ5eIqSWCM0HahSMUobgoI+tdZX9cpyUxLimb6kbKNDEEDIIp/4Mq8R24N7
         K+MovhP4Om16Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4B5060A3A;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: bridge: br_get_linkxstats_size() fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343460880.12488.17875417849029374981.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 11:50:08 +0000
References: <20211005010508.2194560-1-eric.dumazet@gmail.com>
In-Reply-To: <20211005010508.2194560-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Oct 2021 18:05:06 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch series attempts to fix the following syzbot report.
> 
> WARNING: CPU: 1 PID: 21425 at net/core/rtnetlink.c:5388 rtnl_stats_get+0x80f/0x8c0 net/core/rtnetlink.c:5388
> Modules linked in:
> CPU: 1 PID: 21425 Comm: syz-executor394 Not tainted 5.13.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:rtnl_stats_get+0x80f/0x8c0 net/core/rtnetlink.c:5388
> Code: e9 9c fc ff ff 4c 89 e7 89 0c 24 e8 ab 8b a8 fa 8b 0c 24 e9 bc fc ff ff 4c 89 e7 e8 9b 8b a8 fa e9 df fe ff ff e8 61 85 63 fa <0f> 0b e9 f7 fc ff ff 41 be ea ff ff ff e9 f9 fc ff ff 41 be 97 ff
> RSP: 0018:ffffc9000cf77688 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000000000000012c RCX: 0000000000000000
> RDX: ffff8880211754c0 RSI: ffffffff8711571f RDI: 0000000000000003
> RBP: ffff8880175aa780 R08: 00000000ffffffa6 R09: ffff88823bd5c04f
> R10: ffffffff87115413 R11: 0000000000000001 R12: ffff8880175aab74
> R13: ffff8880175aab40 R14: 00000000ffffffa6 R15: 0000000000000006
> FS:  0000000001ff9300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000005cfd58 CR3: 000000002cd43000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4440d9
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
    https://git.kernel.org/netdev/net/c/dbe0b8806449
  - [net,2/2] net: bridge: fix under estimation in br_get_linkxstats_size()
    https://git.kernel.org/netdev/net/c/0854a0513321

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


