Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3396D5085AD
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377574AbiDTKXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377530AbiDTKW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302241400E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB9061790
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 10:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 038FEC385A8;
        Wed, 20 Apr 2022 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650450011;
        bh=/kdrOscUXpoTe8OKXrVoGjhZrmlONVarr3cDpQHst9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4euG7tA1dKEixKtNEorriN9zHT/PHz65n++wmmdngajFBvjX1BpmR3HS1B3dPmvs
         ACZgRaO+sTLRl06co6jxBAGu3LelTq4yHaKHEM1KeJ/wBs+FAJGvAsD4E6fMgq5wTr
         6ZnzYXjhj60w5lsL1Bj+8+cUUKgdIV7jHj2JYbZBALB3tmeZnmAgXTqL9TZ6jN2IYa
         vN+NChKpFlgPwqWcQ3HwsrIr8aJiLlxUBB57D2nzj7Xii3XbeUPUtjSTo+zEnEem46
         YNRr/+IHFg9WfL5CXNU3E6T1UwiNn3zWi8InFzzv3zTUPS7ssBEebc5l1BTcrAxn0E
         miEuziuYqydIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC37EE7399D;
        Wed, 20 Apr 2022 10:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: stmmac: Use readl_poll_timeout_atomic() in atomic
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165045001089.14273.9231245992154971496.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:20:10 +0000
References: <20220419084226.38340-1-haokexin@gmail.com>
In-Reply-To: <20220419084226.38340-1-haokexin@gmail.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, zhengdejin5@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Apr 2022 16:42:26 +0800 you wrote:
> The init_systime() may be invoked in atomic state. We have observed the
> following call trace when running "phc_ctl /dev/ptp0 set" on a Intel
> Agilex board.
>   BUG: sleeping function called from invalid context at drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c:74
>   in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 381, name: phc_ctl
>   preempt_count: 1, expected: 0
>   RCU nest depth: 0, expected: 0
>   Preemption disabled at:
>   [<ffff80000892ef78>] stmmac_set_time+0x34/0x8c
>   CPU: 2 PID: 381 Comm: phc_ctl Not tainted 5.18.0-rc2-next-20220414-yocto-standard+ #567
>   Hardware name: SoCFPGA Agilex SoCDK (DT)
>   Call trace:
>    dump_backtrace.part.0+0xc4/0xd0
>    show_stack+0x24/0x40
>    dump_stack_lvl+0x7c/0xa0
>    dump_stack+0x18/0x34
>    __might_resched+0x154/0x1c0
>    __might_sleep+0x58/0x90
>    init_systime+0x78/0x120
>    stmmac_set_time+0x64/0x8c
>    ptp_clock_settime+0x60/0x9c
>    pc_clock_settime+0x6c/0xc0
>    __arm64_sys_clock_settime+0x88/0xf0
>    invoke_syscall+0x5c/0x130
>    el0_svc_common.constprop.0+0x4c/0x100
>    do_el0_svc+0x7c/0xa0
>    el0_svc+0x58/0xcc
>    el0t_64_sync_handler+0xa4/0x130
>    el0t_64_sync+0x18c/0x190
> 
> [...]

Here is the summary with links:
  - [v2,net] net: stmmac: Use readl_poll_timeout_atomic() in atomic state
    https://git.kernel.org/netdev/net/c/234901de2bc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


