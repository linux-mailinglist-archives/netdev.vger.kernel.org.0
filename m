Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25416E86A6
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjDTAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDTAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD37172E;
        Wed, 19 Apr 2023 17:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388F5643D6;
        Thu, 20 Apr 2023 00:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89257C4339B;
        Thu, 20 Apr 2023 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681951218;
        bh=d3TZbO4+237pZFYOwvrP67MCEB2VLaI8i3CT5Pk9jS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HZgMPyJCIeocbXYDnQkLhmFT2fyCv2eLeNUk/aU0XPJWXvGN0jZk+ehxmpCc90xSX
         cAj70Nw4avGQksi6gmzk/pp2U+orQC9RLZsX4cCG2cALe8WD8tmZpr/VRxLn7ddcUe
         Mcrk9DTGXmDaM64UY4x7ohJAktlIOe4zM23QHfKvvORMdFhjE56KN+1BK3gb9JrHwK
         5ppyblgLpPnNvEWtHkwji1J4YnpQ6HPwPq8RObaxWP0Ec3AJxxPbxE3cr6a5iMutAK
         tyFQfDnvvtmGnloPJT4y0HZhdm5vpcmzvMy1Kn5V1woI9JrFN+bx/f9ZblMUmWn62m
         W5wtDbQadlaBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E743C395EA;
        Thu, 20 Apr 2023 00:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix support for MT7531BE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195121844.11748.18224511099245962254.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 00:40:18 +0000
References: <ZDvlLhhqheobUvOK@makrotopia.org>
In-Reply-To: <ZDvlLhhqheobUvOK@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
        arinc.unal@arinc9.com, jesse.brandeburg@intel.com
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

On Sun, 16 Apr 2023 13:08:14 +0100 you wrote:
> There are two variants of the MT7531 switch IC which got different
> features (and pins) regarding port 5:
>  * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes PCS
>  * MT7531BE: RGMII
> 
> Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
> with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation
> to mt7530_probe function") works fine for MT7531AE which got two
> instances of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup
> to setup clocks before the single PCS on port 6 (usually used as CPU
> port) starts to work and hence the PCS creation failed on MT7531BE.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: mt7530: fix support for MT7531BE
    https://git.kernel.org/netdev/net-next/c/91daa4f62ce8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


