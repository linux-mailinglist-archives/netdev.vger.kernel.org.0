Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0BF6BE02E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCQEah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCQEad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F016751C9B;
        Thu, 16 Mar 2023 21:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E9A6B82426;
        Fri, 17 Mar 2023 04:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13EB3C433A7;
        Fri, 17 Mar 2023 04:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679027422;
        bh=gXCHNGEsUjN3g6h+h6sJj6x5pX74SmvLBRKcxhppG4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fEDSqpvsljZkEAnlqfR2bL8b2NH4fi4YJ5xjMrk+fMvxha0OvAYAl/TCSWq096MFJ
         Z9tW5Hg8JPHtTzQ2lOaVW3TJBDnZL8qrb6ogWvcnBmD+lr7NmspA8lmrhE3KFxacmw
         YpymOliFRk8OMTica4FVq3lidhxfjoqrcWkfl6roog92Q+dIdxmzFLla01XH3oEWXP
         sKHZ3tBNP3yHYx3IEHJr0Z1fyA1Gzw91NS/3B9mBHjYLmVsRFNLPnMKmqar2L/GEAf
         hWdFVKzjnLk9qTC7chDgaTnSeDKCfpjLFwGKXVCLiOE/I77BDelX6CwLOodKn9eYjO
         pkEqb6dxwFMLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8C92E2A03A;
        Fri, 17 Mar 2023 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: microchip: fix RGMII delay configuration on
 KSZ8765/KSZ8794/KSZ8795
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902742194.2591.76071224988388030.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:30:21 +0000
References: <20230315231916.2998480-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230315231916.2998480-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, arun.ramadoss@microchip.com,
        linux@armlinux.org.uk, marex@denx.de, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 01:19:16 +0200 you wrote:
> From: Marek Vasut <marex@denx.de>
> 
> The blamed commit has replaced a ksz_write8() call to address
> REG_PORT_5_CTRL_6 (0x56) with a ksz_set_xmii() -> ksz_pwrite8() call to
> regs[P_XMII_CTRL_1], which is also defined as 0x56 for ksz8795_regs[].
> 
> The trouble is that, when compared to ksz_write8(), ksz_pwrite8() also
> adjusts the register offset with the port base address. So in reality,
> ksz_pwrite8(offset=0x56) accesses register 0x56 + 0x50 = 0xa6, which in
> this switch appears to be unmapped, and the RGMII delay configuration on
> the CPU port does nothing.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795
    https://git.kernel.org/netdev/net/c/5ae06327a3a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


