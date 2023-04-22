Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD36EB714
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDVDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDVDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42B19A8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66AFA6136E
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD4EAC4339C;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134218;
        bh=NZUJsVZwgBrl6Gr9jWgCk3jcu39oCs6ejdOBaUV0xuU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m6g26HmFuI//I2I/FzmTfmeFNgjLaf98iJRjGbKaPB/FyPtuDBhFD3OOh6hT90Al+
         Ph6b4BLhtTzxBqyVX8PnwKXZJ5PYx4vQnZDSGnL0Cw7gCgLBIR20mm9hmj6ihcOFF4
         uDXPpCVHhIyZWZqBzARgESsiYw67TjH647k0arxacy/gPGDKjTcw39rfH98ky0NND7
         rBrOh5KclNN4ZM9g7FfQtQG+aP9ofn8+jCa0Y2sYdYGMbtfIKNDKFcOLqhliZOF4eT
         nXkzNTedXEQX207m7P2HgVpDvHN6UtAsqkRHhE4qNYa433Ou1NDHQUfydycPvxlzGf
         MapWJJjd2rQNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2BF8E270E2;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dst: fix missing initialization of
 rt_uncached
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213421866.22496.2612093116428373828.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:30:18 +0000
References: <20230420182508.2417582-1-mbizon@freebox.fr>
In-Reply-To: <20230420182508.2417582-1-mbizon@freebox.fr>
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     davem@davemloft.net, edumazet@google.com, tglx@linutronix.de,
        wangyang.guo@intel.com, netdev@vger.kernel.org,
        oliver.sang@intel.com, dsahern@kernel.org, leon@kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 20:25:08 +0200 you wrote:
> xfrm_alloc_dst() followed by xfrm4_dst_destroy(), without a
> xfrm4_fill_dst() call in between, causes the following BUG:
> 
>  BUG: spinlock bad magic on CPU#0, fbxhostapd/732
>   lock: 0x890b7668, .magic: 890b7668, .owner: <none>/-1, .owner_cpu: 0
>  CPU: 0 PID: 732 Comm: fbxhostapd Not tainted 6.3.0-rc6-next-20230414-00613-ge8de66369925-dirty #9
>  Hardware name: Marvell Kirkwood (Flattened Device Tree)
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x28/0x30
>   dump_stack_lvl from do_raw_spin_lock+0x20/0x80
>   do_raw_spin_lock from rt_del_uncached_list+0x30/0x64
>   rt_del_uncached_list from xfrm4_dst_destroy+0x3c/0xbc
>   xfrm4_dst_destroy from dst_destroy+0x5c/0xb0
>   dst_destroy from rcu_process_callbacks+0xc4/0xec
>   rcu_process_callbacks from __do_softirq+0xb4/0x22c
>   __do_softirq from call_with_stack+0x1c/0x24
>   call_with_stack from do_softirq+0x60/0x6c
>   do_softirq from __local_bh_enable_ip+0xa0/0xcc
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dst: fix missing initialization of rt_uncached
    https://git.kernel.org/netdev/net-next/c/418a73074da9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


