Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921184F9F46
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiDHVmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiDHVmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D0EDE7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 14:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C3EB82D97
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 21:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 898D8C385A5;
        Fri,  8 Apr 2022 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454012;
        bh=XQ4EIO/qav3sykjXEVJYh50lbHCTXM22yScq/oq+N8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FlymvqMI+jmEr9PS6mDp+LplRLqc6+UOGxD+GQ3/IUiSKxRtuf6Ts3mrJO+u9Kn+0
         rD4r2i8FAKDI5FOvNttYmtwzbPJT00JX6nvrrT4pKKs15pxsSmqRtQRYqpvSLfNHA1
         rg9Z1HEsKtyj+nWeGMh/TsKv5xPc4LrE9ERbg0qyfX+KzDgVP9o0aesdVUEnW5OpUu
         AyPD3t5mLz/cVUtYdzp6jQMOlVbmxTf/j5F8pDZSQlvxh5nctshZLHDay5OgJx3EjN
         jhnBYvXy1Mp6s8tym3TtsekkJebySOTPwI0v904DNRZf9x1yn1DwfzJzVTX7YIE5dx
         7KRz7QJJ6juUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 718A7E8DD5E;
        Fri,  8 Apr 2022 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945401246.15686.1891424640500147918.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:40:12 +0000
References: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        geert+renesas@glider.be, saravanak@google.com, robh@kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org, robin.murphy@arm.com
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

On Thu,  7 Apr 2022 19:55:38 +0300 you wrote:
> When a driver for an interrupt controller is missing, of_irq_get()
> returns -EPROBE_DEFER ad infinitum, causing
> fwnode_mdiobus_phy_device_register(), and ultimately, the entire
> of_mdiobus_register() call, to fail. In turn, any phy_connect() call
> towards a PHY on this MDIO bus will also fail.
> 
> This is not what is expected to happen, because the PHY library falls
> back to poll mode when of_irq_get() returns a hard error code, and the
> MDIO bus, PHY and attached Ethernet controller work fine, albeit
> suboptimally, when the PHY library polls for link status. However,
> -EPROBE_DEFER has special handling given the assumption that at some
> point probe deferral will stop, and the driver for the supplier will
> kick in and create the IRQ domain.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: mdio: don't defer probe forever if PHY IRQ provider is missing
    https://git.kernel.org/netdev/net/c/74befa447e68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


