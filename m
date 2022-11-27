Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E9F639C92
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiK0TUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiK0TUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F1DECA
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 11:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F9560E76
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 19:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20435C433D6;
        Sun, 27 Nov 2022 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669576816;
        bh=gtoAxGzBoX5X8nQ8j1EMj4ZB2MmUMZMk0SeZzhgLjno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3/4/vPlvXNmLIb7T/wX+mH00NtUuUYS3y4Sg0A37i0qEv9sQDW2IGCG59HLkozQH
         5brKn1FUX9E2wM5AcGa0cVzoLNDFOPQylw1jvLCOAlkiMwoQmZW1W/nYDUFpqVTEn9
         cureayxoowtCDZPXDZAh90TzdPfjzS5GMMESAtJInCLnK8oL7mRdvko2wea1+cOKOs
         SCzu/b1DaCSeBXcskI7INIWO5/1OZnH/UdNxpFOHGTC3QlFo84JDjLpM/9Y927CPeY
         BTisMNbuMFW6y1xOdVGQpEqiO5DBA5WGCsMntVI10XSVREKDx/C+1id0wQwVfQdMR6
         ZfF9UH37lR09A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC0D5E29F3D;
        Sun, 27 Nov 2022 19:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: fix null-ptr-deref while probe() failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166957681596.30355.9393526382130336310.git-patchwork-notify@kernel.org>
Date:   Sun, 27 Nov 2022 19:20:15 +0000
References: <20221123132808.2090427-1-yangyingliang@huawei.com>
In-Reply-To: <20221123132808.2090427-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, afleming@freescale.com,
        jgarzik@pobox.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 21:28:08 +0800 you wrote:
> I got a null-ptr-deref report as following when doing fault injection test:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000058
> Oops: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 1 PID: 253 Comm: 507-spi-dm9051 Tainted: G    B            N 6.1.0-rc3+
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:klist_put+0x2d/0xd0
> Call Trace:
>  <TASK>
>  klist_remove+0xf1/0x1c0
>  device_release_driver_internal+0x23e/0x2d0
>  bus_remove_device+0x1bd/0x240
>  device_del+0x357/0x770
>  phy_device_remove+0x11/0x30
>  mdiobus_unregister+0xa5/0x140
>  release_nodes+0x6a/0xa0
>  devres_release_all+0xf8/0x150
>  device_unbind_cleanup+0x19/0xd0
> 
> [...]

Here is the summary with links:
  - [net] net: phy: fix null-ptr-deref while probe() failed
    https://git.kernel.org/netdev/net/c/369eb2c9f1f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


