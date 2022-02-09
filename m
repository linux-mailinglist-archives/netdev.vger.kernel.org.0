Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932D14AE94D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbiBIF2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiBIFU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0F1C03C1A6
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0310CB81EDC
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9463CC340F7;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=eBUnnxSxyEOtbkW22R24x0eFl2BbHRaJXAu04OzBd4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IQuY80bLJxKgACwxkIjBNlCYuld9Xt5yMiwrmFMnDxVVXYXFQoRQaMk0oAgsxi/Oo
         g9BuaRCgc5Blhsx8T7gi5YpirSRia44qm3E61AwGjS6FCMzmwm51NZj8Q8NahTW6hz
         2ItG0Usaa8wQD0bJ6F8v+blMUFfKEdgDo43Q54Y2S/4KLAFOekBcOEy/Vuqp1vExWP
         5mCqTkZRlnsXzIMsblE8juBuwZvUxOiTllUceq0vDCZTYBQ3205lO3MLlL487gEnzf
         NqycNmXwo1C61rsd4r0ORPkLySa/4ogbA5rztJRHC6ncDhKsG6YYg8JrJa6+LzPaLs
         bgq6Rf9mq60qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82AF2E5D09D;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipmr,ip6mr: acquire RTNL before calling
 ip[6]mr_free_table() on failure path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402852.12376.16869529673433089283.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220208053451.2885398-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208053451.2885398-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, cong.wang@bytedance.com,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 21:34:51 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ip[6]mr_free_table() can only be called under RTNL lock.
> 
> RTNL: assertion failed at net/core/dev.c (10367)
> WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> Modules linked in:
> CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
> RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
> R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
> FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
>  ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
>  ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
>  ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
>  ip6mr_net_init+0x3f0/0x4e0 net/ipv6/ip6mr.c:1298
>  ops_init+0xaf/0x470 net/core/net_namespace.c:140
>  setup_net+0x54f/0xbb0 net/core/net_namespace.c:331
>  copy_net_ns+0x318/0x760 net/core/net_namespace.c:475
>  create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
>  copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
>  copy_process+0x2e0c/0x7300 kernel/fork.c:2167
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2555
>  __do_sys_clone+0xc8/0x110 kernel/fork.c:2672
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f4ab89f9059
> Code: Unable to access opcode bytes at RIP 0x7f4ab89f902f.
> RSP: 002b:00007f4ab736e118 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 00007f4ab8b0bf60 RCX: 00007f4ab89f9059
> RDX: 0000000020000280 RSI: 0000000020000270 RDI: 0000000040200000
> RBP: 00007f4ab8a5308d R08: 0000000020000300 R09: 0000000020000300
> R10: 00000000200002c0 R11: 0000000000000206 R12: 0000000000000000
> R13: 00007ffc3977cc1f R14: 00007f4ab736e300 R15: 0000000000022000
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [net] ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
    https://git.kernel.org/netdev/net/c/5611a00697c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


