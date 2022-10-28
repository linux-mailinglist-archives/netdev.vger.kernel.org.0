Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF42610D76
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJ1JkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJ1JkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DB44D81A;
        Fri, 28 Oct 2022 02:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 350B9B828C7;
        Fri, 28 Oct 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D257EC433D6;
        Fri, 28 Oct 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666950014;
        bh=WRRGcNNCROx1+Z4NlDm9dGYO6hp9XY5M+L6HTZmlWnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rhC4s7A4uatXGkPPtzjbUtHoVgKJkWEMACi/sXJKoFJuiVgoOnkdOBZ2W1Tsu3DGy
         mI1M6HsIJsoANBFVaJMDzCLlZcWRvOmOyMA5zpjpg01a/fELZzWWNbJnMowvMk/TgC
         cNBzDU7Hz+CjPWb8GkQwKLgH2lbFoOWu3yL8ajZfYixrS0V33yJfiRwe7eppUeIarf
         hHvailWwg0Nbgpcnf1Zs7XBzKMIASfGwlAja0+1MNrQD2oHF76/ZxqAuD3IPzXgcT2
         LbhO4XwXk93GRKwKL2XYzB6318/wo1AEHjek8MyjcAT3jDdD4roTOzwbX9P9EL7OV0
         nRoVAVuUnAIBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9AC7C4314C;
        Fri, 28 Oct 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: Fix possible memory leaks in dsa_loop_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695001475.8410.5727114306921032694.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 09:40:14 +0000
References: <20221026020321.58615-1-chenzhongjin@huawei.com>
In-Reply-To: <20221026020321.58615-1-chenzhongjin@huawei.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Oct 2022 10:03:21 +0800 you wrote:
> kmemleak reported memory leaks in dsa_loop_init():
> 
> kmemleak: 12 new suspected memory leaks
> 
> unreferenced object 0xffff8880138ce000 (size 2048):
>   comm "modprobe", pid 390, jiffies 4295040478 (age 238.976s)
>   backtrace:
>     [<000000006a94f1d5>] kmalloc_trace+0x26/0x60
>     [<00000000a9c44622>] phy_device_create+0x5d/0x970
>     [<00000000d0ee2afc>] get_phy_device+0xf3/0x2b0
>     [<00000000dca0c71f>] __fixed_phy_register.part.0+0x92/0x4e0
>     [<000000008a834798>] fixed_phy_register+0x84/0xb0
>     [<0000000055223fcb>] dsa_loop_init+0xa9/0x116 [dsa_loop]
>     ...
> 
> [...]

Here is the summary with links:
  - net: dsa: Fix possible memory leaks in dsa_loop_init()
    https://git.kernel.org/netdev/net/c/633efc8b3dc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


