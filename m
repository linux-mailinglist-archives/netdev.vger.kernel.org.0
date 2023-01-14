Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5966A972
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjANFkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjANFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76443A81
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7C6608CC
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEDB2C433F1;
        Sat, 14 Jan 2023 05:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673674816;
        bh=nOhl/sFVQXcNh6TzQzWGrYovHbFrg4cTqrSOG8y/YGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGJGHFssI4pLmiBZkAu7l5DKrGmrjkFkiD4ciFeT7ILP7JamRNpPzcsrG45ZlLR7l
         1CbvOJdy9Jw1ebLJNiVQ6izwKc2HeDHIujQqz3hQhmZZRHtKQyaxX1KJtm1hSoAKv0
         NuYCS3YzEPQP0/kcRrmwXCt3ZMmioUtVhYbhbo7QU7zzh1ekXMphbEyhj7UMATrRQR
         vNzexg8dZON2rUcVz1n4fxYuX8YEiFj8hFI44W2b1ZdUqemGUKVJC5YpP4tviDEnZU
         TPa220mH/QpH3zdCfu+Ntu6Bp0ljvbxntihMeCc4mCnnpOCuPR506rIFMsz3nEIzsv
         ZAgNrb43FlAvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0C35C395C8;
        Sat, 14 Jan 2023 05:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367481671.11900.6865579468078679623.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:40:16 +0000
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        yangbo.lu@nxp.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 12:54:40 +0200 you wrote:
> This lockdep splat says it better than I could:
> 
> ================================
> WARNING: inconsistent lock state
> 6.2.0-rc2-07010-ga9b9500ffaac-dirty #967 Not tainted
> --------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> kworker/1:3/179 [HC0[0]:SC0[0]:HE1:SE1] takes:
> ffff3ec4036ce098 (_xmit_ETHER#2){+.?.}-{3:3}, at: netif_freeze_queues+0x5c/0xc0
> {IN-SOFTIRQ-W} state was registered at:
>   _raw_spin_lock+0x5c/0xc0
>   sch_direct_xmit+0x148/0x37c
>   __dev_queue_xmit+0x528/0x111c
>   ip6_finish_output2+0x5ec/0xb7c
>   ip6_finish_output+0x240/0x3f0
>   ip6_output+0x78/0x360
>   ndisc_send_skb+0x33c/0x85c
>   ndisc_send_rs+0x54/0x12c
>   addrconf_rs_timer+0x154/0x260
>   call_timer_fn+0xb8/0x3a0
>   __run_timers.part.0+0x214/0x26c
>   run_timer_softirq+0x3c/0x74
>   __do_softirq+0x14c/0x5d8
>   ____do_softirq+0x10/0x20
>   call_on_irq_stack+0x2c/0x5c
>   do_softirq_own_stack+0x1c/0x30
>   __irq_exit_rcu+0x168/0x1a0
>   irq_exit_rcu+0x10/0x40
>   el1_interrupt+0x38/0x64
> irq event stamp: 7825
> hardirqs last  enabled at (7825): [<ffffdf1f7200cae4>] exit_to_kernel_mode+0x34/0x130
> hardirqs last disabled at (7823): [<ffffdf1f708105f0>] __do_softirq+0x550/0x5d8
> softirqs last  enabled at (7824): [<ffffdf1f7081050c>] __do_softirq+0x46c/0x5d8
> softirqs last disabled at (7811): [<ffffdf1f708166e0>] ____do_softirq+0x10/0x20
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
    https://git.kernel.org/netdev/net/c/3c463721a73b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


