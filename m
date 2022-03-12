Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6A74D6BB4
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiCLBlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCLBlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:41:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE31724FE7C;
        Fri, 11 Mar 2022 17:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED9561620;
        Sat, 12 Mar 2022 01:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAC2DC340EE;
        Sat, 12 Mar 2022 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647049210;
        bh=SL14ucMY0664sEX8YQjuCnVMCkZwZLl/4EypFG6lkho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jiTaJjfyU6oBcSgFN9FuCROZR2v8qVMKIjRljXUpk6hPqvXi/39rt/AY/igBOOHjU
         TjsouEcQWrUXSHbWo6j+YR2K5eZkX+iFkQM0/Vai6BREwIQvrCNkO6BKYUvgOHoEFx
         oAEioDTKGZonPqCcL2ojfX5DxaR10ISar7pqIEbBAjXBhk+uLovlmoiEcB99jgRhQq
         FXQULQVp2NCRPeMSPAAT3cdtHTNhObiIvUK59aDADzQ1Gz7kCnyII0rGzTrmT0hhIc
         ySZYLdRwNZ8Z0zuQE1MFPQ1Rw37Ex9VlwD16DD3UqpcRk4ZnfT1N7nhbyhSG7QVEmn
         tukMpaI//POFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83303E6D3DD;
        Sat, 12 Mar 2022 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ipv6: fix skb_over_panic in __ip6_append_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164704921053.16208.7597460524504713837.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 01:40:10 +0000
References: <20220310232538.1044947-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220310232538.1044947-1-tadeusz.struk@linaro.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Mar 2022 15:25:38 -0800 you wrote:
> Syzbot found a kernel bug in the ipv6 stack:
> LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
> The reproducer triggers it by sending a crafted message via sendmmsg()
> call, which triggers skb_over_panic, and crashes the kernel:
> 
> skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
> head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
> dev:<NULL>
> 
> [...]

Here is the summary with links:
  - [v3] net: ipv6: fix skb_over_panic in __ip6_append_data
    https://git.kernel.org/netdev/net/c/5e34af4142ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


