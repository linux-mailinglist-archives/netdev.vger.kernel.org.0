Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4B6AD0F6
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCFWAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCFWAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:00:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC5A3CE0F;
        Mon,  6 Mar 2023 14:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFC5DCE17D5;
        Mon,  6 Mar 2023 22:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16414C433D2;
        Mon,  6 Mar 2023 22:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678140019;
        bh=E6ffbDOM6Vr/OgGspczlxERJkY+WFlvEdjkFwcftpQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rJN7rE4aaA9TioixAKhoHBb0CRiUTciC7N+X1m/02PBt2jFveDXLnIZHimDmEvoaH
         M+nYJ/U4OEv9zj90vsCZxFNz75yXAik2pFDDBHAAs+lMHofqm53pC3AYzccfzPe3wH
         xVyowdOpBCCzP28EFeD/zrEhY1dyxU4ub+DPdZmW+FtcQqW/MTJ/t7i4nHvSA85JGu
         XhI7iGrnchipdCguLUrUEZYf32EbZz7tvFC7ATwdHQIaRwPHBHx2QyX6/Pdw2oGTx0
         uD2DJ6Gds57vozeHolfcot6qZtJPzyPxDXICBdukeEMpSiAeI4pYbO6bIPd7S0jaWI
         AP2Ac3CQwxx+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E83CDE68C35;
        Mon,  6 Mar 2023 22:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix RX data corruption issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167814001894.23313.3204096836474065574.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 22:00:18 +0000
References: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
In-Reply-To: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, lorenzo@kernel.org,
        Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
        dqfext@gmail.com, Landen.Chao@mediatek.com, sean.wang@mediatek.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vladimir.oltean@nxp.com, bjorn@mork.no
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 4 Mar 2023 13:43:20 +0000 you wrote:
> Fix data corruption issue with SerDes connected PHYs operating at 1.25
> Gbps speed where we could previously observe about 30% packet loss while
> the bad packet counter was increasing.
> 
> As almost all boards with MediaTek MT7622 or MT7986 use either the MT7531
> switch IC operating at 3.125Gbps SerDes rate or single-port PHYs using
> rate-adaptation to 2500Base-X mode, this issue only got exposed now when
> we started trying to use SFP modules operating with 1.25 Gbps with the
> BananaPi R3 board.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix RX data corruption issue
    https://git.kernel.org/netdev/net/c/193250ace270

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


