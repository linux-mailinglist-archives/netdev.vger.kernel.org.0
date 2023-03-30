Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB326D0E13
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjC3Su0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjC3SuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8D9D33C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDEC3B829E7
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE4C5C433D2;
        Thu, 30 Mar 2023 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680202218;
        bh=CRyaHUr/HY9YNRsthVVCD/w+meEA/ttqh8fIGWAqRj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q5EgtiBY5sSSawVSC+U58j6fxCKMUVghA6jYBlxLC9Zu/Kw3y1GuSnzNft/C3Wmcb
         NgFrUCif4kkpxa3WBw9RH4JWb0rBZ8lnmFM4xr1DdRsoL65Ad0laI5XqtBpsg/s0OI
         lgU/m2iavSamDnqJdmmOcNO559mYjDEtXUiV1edlWEBc9hyEJcM+W0a8nL3xBDFvRf
         GetiUJIp5qpA4rjA412+rfdJnLopTJWS0/Wo38MOSOEqsVjGG+0TUKekIgKSV0XAJl
         sOE9Ic5/5crU3CUWI9YoGYKuvDieXOSVG1QvRHTRTiJk8ORzmnPzj2xiIiUICOjUkn
         4bLfnpvbEZBbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D943E2A037;
        Thu, 30 Mar 2023 18:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvneta: fix potential double-frees in
 mvneta_txq_sw_deinit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168020221856.6825.13004510044660053984.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 18:50:18 +0000
References: <E1phUe5-00EieL-7q@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1phUe5-00EieL-7q@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, kabel@kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 13:11:17 +0100 you wrote:
> Reported on the Turris forum, mvneta provokes kernel warnings in the
> architecture DMA mapping code when mvneta_setup_txqs() fails to
> allocate memory. This happens because when mvneta_cleanup_txqs() is
> called in the mvneta_stop() path, we leave pointers in the structure
> that have been freed.
> 
> Then on mvneta_open(), we call mvneta_setup_txqs(), which starts
> allocating memory. On memory allocation failure, mvneta_cleanup_txqs()
> will walk all the queues freeing any non-NULL pointers - which includes
> pointers that were previously freed in mvneta_stop().
> 
> [...]

Here is the summary with links:
  - [net] net: mvneta: fix potential double-frees in mvneta_txq_sw_deinit()
    https://git.kernel.org/netdev/net/c/2960a2d33b02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


