Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EAD4E3E2D
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiCVMLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiCVMLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43C083B36
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F54361463
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 892BAC340F4;
        Tue, 22 Mar 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647951010;
        bh=FUQzt4BH5JXwKVpjoUcrIaPYcPkS2IHtXHuDh1UX6N4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kWMzj3x0X70FKR7uQ1JXE5ot9pf21NTWHXmHerI9BtycVu2HLefkTbY+UzhlSn7f+
         64Uu89w4WoE0zmpXRL8jnCMupLIod9enk9QGZ428LqCTBgv7fKscGbvPNh9M4SN5n5
         sInJSUpZpeHXtBKEttRpoQAtGcc15Q4/lXLjGmDL2HTahEu0gMRJ3v1ngeWjh5NCSe
         LCDhahcklRHWTj1Oo23/9Y9tLRX4eTiPlcUj/Qqf+fWCbRPJcGBpUofRSsTcRyTBY2
         coCA2xE+6aG3XRjzQLS8l1FpUp4kWlsb6rLm4+dYBkm9lv1oXIZG/j6h+AvM5DAVIf
         q31bvzedFHqtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67B64EAC09C;
        Tue, 22 Mar 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: mst: prevent NULL deref in
 br_mst_info_size()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164795101042.4693.5112708366114265101.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 12:10:10 +0000
References: <20220322012314.795187-1-eric.dumazet@gmail.com>
In-Reply-To: <20220322012314.795187-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        tobias@waldekranz.com, razor@blackwall.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 21 Mar 2022 18:23:14 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Call br_mst_info_size() only if vg pointer is not NULL.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000058: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
> CPU: 0 PID: 975 Comm: syz-executor.0 Tainted: G        W         5.17.0-next-20220321-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:br_mst_info_size+0x97/0x270 net/bridge/br_mst.c:242
> Code: 00 00 31 c0 e8 ba 10 53 f9 31 c0 b9 40 00 00 00 4c 8d 6c 24 30 4c 89 ef f3 48 ab 48 8d 83 c0 02 00 00 48 89 04 24 48 c1 e8 03 <80> 3c 28 00 0f 85 ae 01 00 00 48 8b 83 c0 02 00 00 41 bf 04 00 00
> RSP: 0018:ffffc900153770a8 EFLAGS: 00010202
> RAX: 0000000000000058 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff88259876 RDI: ffffc900153772d8
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8db68957
> R10: ffffffff881f737b R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900153770d8 R14: 00000000000002a0 R15: 00000000ffffffff
> FS:  00007f18bbb6f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001a80 CR3: 000000001a7d9000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 00000000000000d8 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  br_get_link_af_size_filtered+0x6e9/0xc00 net/bridge/br_netlink.c:123
>  rtnl_link_get_af_size net/core/rtnetlink.c:598 [inline]
>  if_nlmsg_size+0x40c/0xa50 net/core/rtnetlink.c:1040
>  rtnl_calcit.isra.0+0x25f/0x460 net/core/rtnetlink.c:3780
>  rtnetlink_rcv_msg+0xa65/0xb80 net/core/rtnetlink.c:5937
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f18baa89049
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f18bbb6f168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f18bab9bf60 RCX: 00007f18baa89049
> RDX: 0000000000000000 RSI: 0000000020001a80 RDI: 0000000000000004
> RBP: 00007f18baae308d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffeedb2be2f R14: 00007f18bbb6f300 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: mst: prevent NULL deref in br_mst_info_size()
    https://git.kernel.org/netdev/net-next/c/cde3fc244b3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


