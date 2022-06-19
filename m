Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E615509F1
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbiFSLAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 07:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiFSLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 07:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5935710559;
        Sun, 19 Jun 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5EC961008;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48F93C385A2;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655636413;
        bh=20JR7nT8G5bJeQJyO8axcUxLo+YTGuYoe8oJ8zxl0dE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f6v0wefA3Sa0E3Y/ePc9cK2K1JkTwz0iCh9H/soi3EkJ3Bxj5gp/soDjf62TN+2cw
         Rf5nqs17jDS/Vda2M/gX87MxnNVCpk1Y6Rau8vL3Bjm7S4KBFLKPSQXrB0/EK3Mov4
         V6XptXaa6dBXCyKAXbXskeyUzuaI1xNBrQWuRmEkS4CtghVe9OxxZ3O5Ha7i9jMn7O
         TJnEqxC0zKskHjyJweeJxVv1wNgA62mRZHvJ7dlTI3uD3A/9NutfPr8RvwyrNNJZyr
         hJMWp1wM6KjmufU4NanfIZ2NUHn5Y88u4r9jaiJBRQFFQ8O4a/id6gK4n7X0IUgTaF
         k5pQGcKX9jOtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B00BE7BB29;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] net: phy: at803x: fix NULL pointer dereference on
 AR9331 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165563641317.16837.6254544371044547115.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 11:00:13 +0000
References: <20220618122333.235139-1-o.rempel@pengutronix.de>
In-Reply-To: <20220618122333.235139-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Jun 2022 14:23:33 +0200 you wrote:
> Latest kernel will explode on the PHY interrupt config, since it depends
> now on allocated priv. So, run probe to allocate priv to fix it.
> 
>  ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
>  CPU 0 Unable to handle kernel paging request at virtual address 0000000a, epc == 8050e8a8, ra == 80504b34
>          ...
>  Call Trace:
>  [<8050e8a8>] at803x_config_intr+0x5c/0xd0
>  [<80504b34>] phy_request_interrupt+0xa8/0xd0
>  [<8050289c>] phylink_bringup_phy+0x2d8/0x3ac
>  [<80502b68>] phylink_fwnode_phy_connect+0x118/0x130
>  [<8074d8ec>] dsa_slave_create+0x270/0x420
>  [<80743b04>] dsa_port_setup+0x12c/0x148
>  [<8074580c>] dsa_register_switch+0xaf0/0xcc0
>  [<80511344>] ar9331_sw_probe+0x370/0x388
>  [<8050cb78>] mdio_probe+0x44/0x70
>  [<804df300>] really_probe+0x200/0x424
>  [<804df7b4>] __driver_probe_device+0x290/0x298
>  [<804df810>] driver_probe_device+0x54/0xe4
>  [<804dfd50>] __device_attach_driver+0xe4/0x130
>  [<804dcb00>] bus_for_each_drv+0xb4/0xd8
>  [<804dfac4>] __device_attach+0x104/0x1a4
>  [<804ddd24>] bus_probe_device+0x48/0xc4
>  [<804deb44>] deferred_probe_work_func+0xf0/0x10c
>  [<800a0ffc>] process_one_work+0x314/0x4d4
>  [<800a17fc>] worker_thread+0x2a4/0x354
>  [<800a9a54>] kthread+0x134/0x13c
>  [<8006306c>] ret_from_kernel_thread+0x14/0x1c
> 
> [...]

Here is the summary with links:
  - [net,v3,1/1] net: phy: at803x: fix NULL pointer dereference on AR9331 PHY
    https://git.kernel.org/netdev/net/c/9926de7315be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


