Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23884692DDB
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBKDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBKDaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:30:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96991A977;
        Fri, 10 Feb 2023 19:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51F49CE29AA;
        Sat, 11 Feb 2023 03:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 954EBC4339B;
        Sat, 11 Feb 2023 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086218;
        bh=gFzGcza27GWOf1I4M4AaB0D4hAVBYBLR2BGElcS5NmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XUB2fRf45eaih5T3SdIhRnMI4Pwj+OppH4zhHhGE3pMRAGjWGtGMXxL2w4DobTtU5
         2GYAooHj3pHsxvhJw3U4DE9+6pe2Pr7a2nvg3BkhXGWSlqo1YlxOq1UBHtugf62uiB
         zkWcEQtnFeQDai7XzAimAR3OAI+YKK1vLwyqwCW4ZKyYIoEjdznovCVjGqwvb0t9D9
         nvHXKJFB1mbpvJmJcbbMwnrJKe6ndNhFGcSKW1bGCg1pgPRzLfEKVrvRwcqY1GqvVY
         W0WP4TBj0A64gRoaw3FKFwun6vuVHjZxCMXlCM/jlbAX+vzfSjTnMwd51A338OxjKZ
         KwuT7IAJAq/aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71F0EE55EFD;
        Sat, 11 Feb 2023 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown
 Quirk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608621845.18578.16368476756723971269.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:30:18 +0000
References: <20230209084432.189222-1-s-vadapalli@ti.com>
In-Reply-To: <20230209084432.189222-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Feb 2023 14:14:32 +0530 you wrote:
> In TI's AM62x/AM64x SoCs, successful teardown of RX DMA Channel raises an
> interrupt. The process of servicing this interrupt involves flushing all
> pending RX DMA descriptors and clearing the teardown completion marker
> (TDCM). The am65_cpsw_nuss_rx_packets() function invoked from the RX
> NAPI callback services the interrupt. Thus, it is necessary to wait for
> this handler to run, drain all packets and clear TDCM, before calling
> napi_disable() in am65_cpsw_nuss_common_stop() function post channel
> teardown. If napi_disable() executes before ensuring that TDCM is
> cleared, the TDCM remains set when the interfaces are down, resulting in
> an interrupt storm when the interfaces are brought up again.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk
    https://git.kernel.org/netdev/net/c/0ed577e7e8e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


