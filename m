Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9024E5A19F3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiHYUB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbiHYUA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E35C6CD1F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A935661181
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 007EFC43144;
        Thu, 25 Aug 2022 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457618;
        bh=WEwkjv+SNVa+fRU64wpKmLH8loYcwWf8LGObhUM/nyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TIWE9sCUflL5SdYILoA50L7KjGYQfmykOYYd1Y1/UdWQhAIBE0lzG1v3j70/4Nva+
         Q2qMy+60jNQmjE/I82IdS17Mh/fmvCdLyGdNgrS+Yy4cEVcb+sNt3epNyNr/0MEkkx
         O9DJ8/gckRUBjRB2h0Aia573KzLEOXtNKGDkmOa7H+PrfLUQjYwgyBcd9Uurpoq0w5
         9ScwlYRNUHXubQRYRBESsaxSLRdQJmLOSPc6sW2j+v5gPVmfGrmneuOHybKKlFL2L6
         rMehZRzpNMvQg8qsa8nR+H3acDyHDWhVHJs7nrm0KoX+U9pMDei+BO5NoNruUybS6P
         MJOKzHFHi8Xsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9615E2A042;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: stmmac: work around sporadic tx issue on link-up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145761788.4210.4923470466947390397.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:00:17 +0000
References: <e99857ce-bd90-5093-ca8c-8cd480b5a0a2@gmail.com>
In-Reply-To: <e99857ce-bd90-5093-ca8c-8cd480b5a0a2@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qi.duan@amlogic.com,
        da@lessconfused.com, jbrunet@baylibre.com, rayagond@vayavyalabs.com
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

On Wed, 24 Aug 2022 22:34:49 +0200 you wrote:
> This is a follow-up to the discussion in [0]. It seems to me that
> at least the IP version used on Amlogic SoC's sometimes has a problem
> if register MAC_CTRL_REG is written whilst the chip is still processing
> a previous write. But that's just a guess.
> Adding a delay between two writes to this register helps, but we can
> also simply omit the offending second write. This patch uses the second
> approach and is based on a suggestion from Qi Duan.
> Benefit of this approach is that we can save few register writes, also
> on not affected chip versions.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: stmmac: work around sporadic tx issue on link-up
    https://git.kernel.org/netdev/net/c/a3a57bf07de2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


