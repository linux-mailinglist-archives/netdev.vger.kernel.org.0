Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D367F660C3C
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjAGDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjAGDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8B8392D9;
        Fri,  6 Jan 2023 19:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EEA461FD5;
        Sat,  7 Jan 2023 03:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA49EC4339B;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673062816;
        bh=iL1zQgdqfFHz2uikqYZASk9ArPq/tgbaQNSC5l2L1XQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jyxT4Nmd7gkAVrRNMhJs0y0UGNreSfIVFSrTJsaB6kpcytHTtiDsAbR8Zn4HWr2K1
         +3rf1sASgHRb/jGdRMMADltet3A2EHzKM0DcPeMV8zEAaTPIe5VEkU8iiAwdxxFSwo
         dXMfUVzuAJYuZCFYK6sIkdJ81olH29SK43pHog2BlZUcfDaLNOFAPnhjhN9Pn/gUhh
         Yb6bU9jLyzv24FiBGaQKZVDuP8GwPo/ypjDwcvnrcjkXmAwocZkt6MXM4BFsKgEA8B
         N87nJY/1PFoID3Y12eTvIiYj/RFz6K+8lAi5dIyDZtqafK5frQ9Y1ESBCodymj4evg
         jHtjGyF8zTuDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F690E57254;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: micrel: Change handler interrupt for
 lan8814
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167306281658.4583.1807795313935970592.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 03:40:16 +0000
References: <20230104194218.3785229-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230104194218.3785229-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Jan 2023 20:42:18 +0100 you wrote:
> The lan8814 represents a package of 4 PHYs. All of them are sharing the
> same interrupt line. So when a link was going down/up or a frame was
> timestamped, then the interrupt handler of all the PHYs was called.
> Which is all fine and expected but the problem is the way the handler
> interrupt works.
> Basically if one of the PHYs timestamp a frame, then all the other 3
> PHYs were polling the status of the interrupt until that PHY actually
> cleared the interrupt by reading the timestamp.
> The reason of polling was in case another PHY was also timestamping a
> frame at the same time, it could miss this interrupt. But this is not
> the right approach, because it is the interrupt controller who needs to
> call the interrupt handlers again if the interrupt line is still
> active.
> Therefore change this such when the interrupt handler is called check
> only if the interrupt is for itself, otherwise just exit. In this way
> save CPU usage.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: micrel: Change handler interrupt for lan8814
    https://git.kernel.org/netdev/net-next/c/7abd92a5b98f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


