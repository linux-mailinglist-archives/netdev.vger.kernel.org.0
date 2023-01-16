Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D52466C22E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjAPO1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjAPO1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:27:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9773728846;
        Mon, 16 Jan 2023 06:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9850360FDF;
        Mon, 16 Jan 2023 14:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E03BFC433D2;
        Mon, 16 Jan 2023 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673878215;
        bh=XgIJguZ7ZaiVTjSmOPmCve4AczLxN5ZWopM1ZYKEDgs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l4iQ2KvMVKAhuz7f44UXda2iQI5ZKw8cb0vZyYGWqvdofplX/YCrhfzfhtatcyFF+
         EFIphvEs1sZXpsDxo0xEPo2yexjeQYLW7YIgFwsz2BN348R+bvD7yipeiUK8XQ1/BP
         tpvJCwfiDcWW3NnQ+5Kly89BFchZ8FVLULhAovfPiCuvIi2LI5cRcJt9WDRjkLm2D9
         LKeuhAxX/X7tvM543142XK0Kavw4xqWv8IK4DiFOC5wNvnbVjZhnIX5KqXl0jITMHp
         QbJjkrqfQWQwaagDVVIiNaFG5wk5AWDGy0ryj9E+++i2OQx1RNsWmg8equjFVKPVZk
         TA/Me5O1yt3yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6346E54D2B;
        Mon, 16 Jan 2023 14:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic
 context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387821580.26138.13339580254916063174.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 14:10:15 +0000
References: <20230113061902.6061-1-gakula@marvell.com>
In-Reply-To: <20230113061902.6061-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 13 Jan 2023 11:49:02 +0530 you wrote:
> Using GFP_KERNEL in preemption disable context, causing below warning
> when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
> 
> [   32.542271] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> [   32.550883] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> [   32.558707] preempt_count: 1, expected: 0
> [   32.562710] RCU nest depth: 0, expected: 0
> [   32.566800] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc2-00269-gae9dcb91c606 #7
> [   32.576188] Hardware name: Marvell CN106XX board (DT)
> [   32.581232] Call trace:
> [   32.583670]  dump_backtrace.part.0+0xe0/0xf0
> [   32.587937]  show_stack+0x18/0x30
> [   32.591245]  dump_stack_lvl+0x68/0x84
> [   32.594900]  dump_stack+0x18/0x34
> [   32.598206]  __might_resched+0x12c/0x160
> [   32.602122]  __might_sleep+0x48/0xa0
> [   32.605689]  __kmem_cache_alloc_node+0x2b8/0x2e0
> [   32.610301]  __kmalloc+0x58/0x190
> [   32.613610]  otx2_sq_aura_pool_init+0x1a8/0x314
> [   32.618134]  otx2_open+0x1d4/0x9d0
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context
    https://git.kernel.org/netdev/net/c/87b93b678e95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


