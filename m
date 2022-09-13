Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DEF5B698F
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiIMIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiIMIaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0DF201BC;
        Tue, 13 Sep 2022 01:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E9EB6135A;
        Tue, 13 Sep 2022 08:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B36A5C433D7;
        Tue, 13 Sep 2022 08:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663057814;
        bh=f8cbvegniSre6PNiF0ogaPf3CaNWmNQWhQF7CWp+T3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxnivyGRxio2Hsbge/ByEzeeqeH2LnPnkIljsIeeqGVJZJBxwJECdZpfyVNNwMGXN
         hdPu5/aaL4Pm3kqJODp+dJWMySO/bwhu8sEypLYM4qGlFSA9DcNFLKHfL7bKvUa2Nz
         B9+zrqh/LZzluhxH2G9+AXcZ/uFooVn2Z5D58yxQHTvD+J1wtOBjhNjt25cOrMdFQz
         gSRGopcWCvGy+ARREr4AJK/aZXh8E93oC2svNte2CBNexWSSMx4+JH8BK11/LMbJn+
         OFWleXas6te8T+NbnMhobs9+F05JhrJrzNMFvDDqVbc1Ya+Gdlq0AUmXFsa1FfVfCt
         oK+BImdmZSkbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F11BC73FED;
        Tue, 13 Sep 2022 08:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] mptcp: fix fwd memory accounting on coalesce
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166305781458.5487.11715290784826413918.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Sep 2022 08:30:14 +0000
References: <20220906180404.1255873-1-matthieu.baerts@tessares.net>
In-Reply-To: <20220906180404.1255873-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        oliver.sang@intel.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Sep 2022 20:04:01 +0200 you wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> The intel bot reported a memory accounting related splat:
> 
> [  240.473094] ------------[ cut here ]------------
> [  240.478507] page_counter underflow: -4294828518 nr_pages=4294967290
> [  240.485500] WARNING: CPU: 2 PID: 14986 at mm/page_counter.c:56 page_counter_cancel+0x96/0xc0
> [  240.570849] CPU: 2 PID: 14986 Comm: mptcp_connect Tainted: G S                5.19.0-rc4-00739-gd24141fe7b48 #1
> [  240.581637] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
> [  240.590600] RIP: 0010:page_counter_cancel+0x96/0xc0
> [  240.596179] Code: 00 00 00 45 31 c0 48 89 ef 5d 4c 89 c6 41 5c e9 40 fd ff ff 4c 89 e2 48 c7 c7 20 73 39 84 c6 05 d5 b1 52 04 01 e8 e7 95 f3
> 01 <0f> 0b eb a9 48 89 ef e8 1e 25 fc ff eb c3 66 66 2e 0f 1f 84 00 00
> [  240.615639] RSP: 0018:ffffc9000496f7c8 EFLAGS: 00010082
> [  240.621569] RAX: 0000000000000000 RBX: ffff88819c9c0120 RCX: 0000000000000000
> [  240.629404] RDX: 0000000000000027 RSI: 0000000000000004 RDI: fffff5200092deeb
> [  240.637239] RBP: ffff88819c9c0120 R08: 0000000000000001 R09: ffff888366527a2b
> [  240.645069] R10: ffffed106cca4f45 R11: 0000000000000001 R12: 00000000fffffffa
> [  240.652903] R13: ffff888366536118 R14: 00000000fffffffa R15: ffff88819c9c0000
> [  240.660738] FS:  00007f3786e72540(0000) GS:ffff888366500000(0000) knlGS:0000000000000000
> [  240.669529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  240.675974] CR2: 00007f966b346000 CR3: 0000000168cea002 CR4: 00000000003706e0
> [  240.683807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  240.691641] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  240.699468] Call Trace:
> [  240.702613]  <TASK>
> [  240.705413]  page_counter_uncharge+0x29/0x80
> [  240.710389]  drain_stock+0xd0/0x180
> [  240.714585]  refill_stock+0x278/0x580
> [  240.718951]  __sk_mem_reduce_allocated+0x222/0x5c0
> [  240.729248]  __mptcp_update_rmem+0x235/0x2c0
> [  240.734228]  __mptcp_move_skbs+0x194/0x6c0
> [  240.749764]  mptcp_recvmsg+0xdfa/0x1340
> [  240.763153]  inet_recvmsg+0x37f/0x500
> [  240.782109]  sock_read_iter+0x24a/0x380
> [  240.805353]  new_sync_read+0x420/0x540
> [  240.838552]  vfs_read+0x37f/0x4c0
> [  240.842582]  ksys_read+0x170/0x200
> [  240.864039]  do_syscall_64+0x5c/0x80
> [  240.872770]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  240.878526] RIP: 0033:0x7f3786d9ae8e
> [  240.882805] Code: c0 e9 b6 fe ff ff 50 48 8d 3d 6e 18 0a 00 e8 89 e8 01 00 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
> [  240.902259] RSP: 002b:00007fff7be81e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [  240.910533] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f3786d9ae8e
> [  240.918368] RDX: 0000000000002000 RSI: 00007fff7be87ec0 RDI: 0000000000000005
> [  240.926206] RBP: 0000000000000005 R08: 00007f3786e6a230 R09: 00007f3786e6a240
> [  240.934046] R10: fffffffffffff288 R11: 0000000000000246 R12: 0000000000002000
> [  240.941884] R13: 00007fff7be87ec0 R14: 00007fff7be87ec0 R15: 0000000000002000
> [  240.949741]  </TASK>
> [  240.952632] irq event stamp: 27367
> [  240.956735] hardirqs last  enabled at (27366): [<ffffffff81ba50ea>] mem_cgroup_uncharge_skmem+0x6a/0x80
> [  240.966848] hardirqs last disabled at (27367): [<ffffffff81b8fd42>] refill_stock+0x282/0x580
> [  240.976017] softirqs last  enabled at (27360): [<ffffffff83a4d8ef>] mptcp_recvmsg+0xaf/0x1340
> [  240.985273] softirqs last disabled at (27364): [<ffffffff83a4d30c>] __mptcp_move_skbs+0x18c/0x6c0
> [  240.994872] ---[ end trace 0000000000000000 ]---
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: fix fwd memory accounting on coalesce
    https://git.kernel.org/netdev/net/c/7288ff6ec795
  - [net,2/2] Documentation: mptcp: fix pm_type formatting
    https://git.kernel.org/netdev/net/c/0727a9a5fbc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


