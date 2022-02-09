Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BB84AF117
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiBIMLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiBIMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53642E024635
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07EAEB8207A
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2749C340EE;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408012;
        bh=e79RCyEHDM1FzQdq7nh+YWFvPYoCDEnLxEodwXB/2u0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sxAQs6+P+TaS0X6F/4wvppUExYFyWB/DKHR5grqohRnzF+smbG45qWxvpHw30/UfS
         Ss/v+kNVytAPWTsJxJxWn5IPfbb4UBKBvhHoOhjzJTYZwIXNaeep0LBg2ZclEODyr8
         mvatWpH2uC9IenijL2sX+AsgVN5yGpKNPCmqBL61Zdiq1H3GxAtWpanXJrcHJAMz9d
         yyd73TCE+Qux+3HsRZOZkePQeoteDJ81RTINvP+mEAi7ZDnQSPk+BrIRBeFZ6KASCZ
         MvRKt+5WeQe+r5UngSsgiSCOrsGGX87VgdIhhF1besBsodZbQlPLqWPExM3P3xKnSs
         tZg6a+byKZdCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91B6FE5D084;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip6_tunnel: fix possible NULL deref in ip6_tnl_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440801259.11178.4882319405110539289.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:12 +0000
References: <20220208214148.3282081-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208214148.3282081-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, i@moy.cat,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Feb 2022 13:41:48 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Make sure to test that skb has a dst attached to it.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000011: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
> CPU: 0 PID: 32650 Comm: syz-executor.4 Not tainted 5.17.0-rc2-next-20220204-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:ip6_tnl_xmit+0x2140/0x35f0 net/ipv6/ip6_tunnel.c:1127
> Code: 4d 85 f6 0f 85 c5 04 00 00 e8 9c b0 66 f9 48 83 e3 fe 48 b8 00 00 00 00 00 fc ff df 48 8d bb 88 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 07 7f 05 e8 11 25 b2 f9 44 0f b6 b3 88 00 00
> RSP: 0018:ffffc900141b7310 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000c77a000
> RDX: 0000000000000011 RSI: ffffffff8811f854 RDI: 0000000000000088
> RBP: ffffc900141b7480 R08: 0000000000000000 R09: 0000000000000008
> R10: ffffffff8811f846 R11: 0000000000000008 R12: ffffc900141b7548
> R13: ffff8880297c6000 R14: 0000000000000000 R15: ffff8880351c8dc0
> FS:  00007f9827ba2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31322000 CR3: 0000000033a70000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ipxip6_tnl_xmit net/ipv6/ip6_tunnel.c:1386 [inline]
>  ip6_tnl_start_xmit+0x71e/0x1830 net/ipv6/ip6_tunnel.c:1435
>  __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4697 [inline]
>  xmit_one net/core/dev.c:3473 [inline]
>  dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3489
>  __dev_queue_xmit+0x2a24/0x3760 net/core/dev.c:4116
>  packet_snd net/packet/af_packet.c:3057 [inline]
>  packet_sendmsg+0x2265/0x5460 net/packet/af_packet.c:3084
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  sock_write_iter+0x289/0x3c0 net/socket.c:1061
>  call_write_iter include/linux/fs.h:2075 [inline]
>  do_iter_readv_writev+0x47a/0x750 fs/read_write.c:726
>  do_iter_write+0x188/0x710 fs/read_write.c:852
>  vfs_writev+0x1aa/0x630 fs/read_write.c:925
>  do_writev+0x27f/0x300 fs/read_write.c:968
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f9828c2d059
> 
> [...]

Here is the summary with links:
  - [net-next] ip6_tunnel: fix possible NULL deref in ip6_tnl_xmit
    https://git.kernel.org/netdev/net-next/c/3a5f238f2b36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


