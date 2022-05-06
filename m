Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65551CE0F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbiEFBYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245039AbiEFBX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E706188;
        Thu,  5 May 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742C562017;
        Fri,  6 May 2022 01:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9374C385AC;
        Fri,  6 May 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800012;
        bh=0fJpRM9EOsyHyYtoKg1rPGzOc1kwRtJnNYc4y7kFSto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GGtrJIiF3RnaWBJ3Ee7DiSDdgbWARZuBmzb6ODCQLnCvHnRKUtSPruXrlfgh3CpuC
         gqA/BjETGAI0RY9VVgfLesfhfEMR+7/v/Rnj8vOdr2Y6ZDD0UVKhPB47FtAl66Z3lu
         tuJ+iY4q9V25a/+kO07/Z6zn3mHm7nZaYbTAtavPnFbGX29DUK/FfXhZKyMhhqCFas
         OBs2w6rHTZ5J04Qb4hrWR/nFeYQCKdmDUIsSS9aHsczIrO6a79h18Pp6Bni43E3UVm
         +7lBB3VSK1RC+gwEtaXWlC1Fp/1MpINErTclmlXFDLQnlUMxRpBvqFXLYfYeZ2xGiY
         wkjPmvL2/L1Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CB70E8DBDA;
        Fri,  6 May 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] net: phy: micrel: Do not use kszphy_suspend/resume
 for KSZ8061
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001263.16316.832292136667758937.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:12 +0000
References: <20220504143104.1286960-1-festevam@gmail.com>
In-Reply-To: <20220504143104.1286960-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        o.rempel@pengutronix.de, linux@armlinux.org.uk, festevam@denx.de,
        stable@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 11:31:03 -0300 you wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit f1131b9c23fb ("net: phy: micrel: use
> kszphy_suspend()/kszphy_resume for irq aware devices") the following
> NULL pointer dereference is observed on a board with KSZ8061:
> 
>  # udhcpc -i eth0
> udhcpc: started, v1.35.0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000008
> pgd = f73cef4e
> [00000008] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at kszphy_config_reset+0x10/0x114
> LR is at kszphy_resume+0x24/0x64
> ...
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
    https://git.kernel.org/netdev/net/c/e333eed63a09
  - [net,v2,2/2] net: phy: micrel: Pass .probe for KS8737
    https://git.kernel.org/netdev/net/c/15f03ffe4bb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


