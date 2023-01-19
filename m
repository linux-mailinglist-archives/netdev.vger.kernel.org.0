Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90A673C92
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 15:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjASOmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 09:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjASOln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 09:41:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7F798FD
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85A2061B2D
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE2FBC433D2;
        Thu, 19 Jan 2023 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674139216;
        bh=likVrr1HVuM5OzUf8xX4eGm8gqngCe0xxe+SRPmhsTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mMDWKstRSIhDR8xv3iOXuK5yq7Qu3G8fo130gS2Tw5pDVY21T8PTwXdK3euhYKgYo
         yON6FP2++A0YkfVbLXJK5eXKEBs5I59jMkRC+0wOWRjWrIuB6z36xGfO7M8Gx0tQCC
         WdUWEtlXLRn7UxiNEC/vikPo686W/NWyWynKS5xzHvFRc2Pn9o/H/B++ILEG3RegJC
         dWcfvwSOtmrRnQxJBbrGB9wMUtGmEQdK31ioeSGsDvjO9sO1x40eAHXHU7XfwyFHjb
         iLkHqvD1xKWO8gXRW1AQdbQI7W2f1QtjGX1cBQ8v7ojEwdJHQ9QUtmA7Xdr5oJb06B
         dQkGom5wOAH/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF217C39563;
        Thu, 19 Jan 2023 14:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: Fix the use of GFP_KERNEL in atomic context
 on rt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167413921677.5837.12129131594293392656.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 14:40:16 +0000
References: <20230118071300.3271125-1-haokexin@gmail.com>
In-Reply-To: <20230118071300.3271125-1-haokexin@gmail.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 Jan 2023 15:13:00 +0800 you wrote:
> The commit 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura
> free") uses the get/put_cpu() to protect the usage of percpu pointer
> in ->aura_freeptr() callback, but it also unnecessarily disable the
> preemption for the blockable memory allocation. The commit 87b93b678e95
> ("octeontx2-pf: Avoid use of GFP_KERNEL in atomic context") tried to
> fix these sleep inside atomic warnings. But it only fix the one for
> the non-rt kernel. For the rt kernel, we still get the similar warnings
> like below.
>   BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>   preempt_count: 1, expected: 0
>   RCU nest depth: 0, expected: 0
>   3 locks held by swapper/0/1:
>    #0: ffff800009fc5fe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
>    #1: ffff000100c276c0 (&mbox->lock){+.+.}-{3:3}, at: otx2_init_hw_resources+0x8c/0x3a4
>    #2: ffffffbfef6537e0 (&cpu_rcache->lock){+.+.}-{2:2}, at: alloc_iova_fast+0x1ac/0x2ac
>   Preemption disabled at:
>   [<ffff800008b1908c>] otx2_rq_aura_pool_init+0x14c/0x284
>   CPU: 20 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc3-rt1-yocto-preempt-rt #1
>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>   Call trace:
>    dump_backtrace.part.0+0xe8/0xf4
>    show_stack+0x20/0x30
>    dump_stack_lvl+0x9c/0xd8
>    dump_stack+0x18/0x34
>    __might_resched+0x188/0x224
>    rt_spin_lock+0x64/0x110
>    alloc_iova_fast+0x1ac/0x2ac
>    iommu_dma_alloc_iova+0xd4/0x110
>    __iommu_dma_map+0x80/0x144
>    iommu_dma_map_page+0xe8/0x260
>    dma_map_page_attrs+0xb4/0xc0
>    __otx2_alloc_rbuf+0x90/0x150
>    otx2_rq_aura_pool_init+0x1c8/0x284
>    otx2_init_hw_resources+0xe4/0x3a4
>    otx2_open+0xf0/0x610
>    __dev_open+0x104/0x224
>    __dev_change_flags+0x1e4/0x274
>    dev_change_flags+0x2c/0x7c
>    ic_open_devs+0x124/0x2f8
>    ip_auto_config+0x180/0x42c
>    do_one_initcall+0x90/0x4dc
>    do_basic_setup+0x10c/0x14c
>    kernel_init_freeable+0x10c/0x13c
>    kernel_init+0x2c/0x140
>    ret_from_fork+0x10/0x20
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt
    https://git.kernel.org/netdev/net/c/55ba18dc62de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


