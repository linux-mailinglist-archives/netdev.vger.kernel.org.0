Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151B2617526
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKCDkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKCDkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3F140CE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 20:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143EBB82638
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 03:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE960C433B5;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667446815;
        bh=ar3OUTKQQTbbxfUxU9MMkSqyTblaf1g1hBZZaPGWfeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XvTiDcRQq/xfaVt+EUivJdYTi94H8Y/fLMbBd3ybzB8A+n4z4BwHh7JeQ+D3O66j5
         ad1muO3bINfTCjHB7Ck/Nr6dwp6kXQ9TazfRd/pRcs0dIJoV0dHQ3HBUM1E/Q0PwHf
         FWSRyjvtMU/ls8a4LzM6W18FxOUvQgq0oMRz/q1HRU2V9rfMVmxGH/gC1b70XEuIhR
         /tTWx95wOnBj74bBxIdY5PTAY1DcItRITGgcPnBGPRJsSO+PI5LvYSFRpAu1RqKwfy
         KR9gLaRIJWFmg69z15FazFGQGRenVLfLwPz9g2E9DCuoliit2jjpLMpDjzXpcfc8NM
         VcEJmO6pL91Ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9077FE270D3;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mdio: fix undefined behavior in bit shift for
 __mdiobus_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744681557.6035.7101480587913433832.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:40:15 +0000
References: <20221031132645.168421-1-cuigaosheng1@huawei.com>
In-Reply-To: <20221031132645.168421-1-cuigaosheng1@huawei.com>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, afleming@freescale.com, buytenh@wantstofly.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Oct 2022 21:26:45 +0800 you wrote:
> Shifting signed 32-bit value by 31 bits is undefined, so changing
> significant bit to unsigned. The UBSAN warning calltrace like below:
> 
> UBSAN: shift-out-of-bounds in drivers/net/phy/mdio_bus.c:586:27
> left shift of 1 by 31 places cannot be represented in type 'int'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x7d/0xa5
>  dump_stack+0x15/0x1b
>  ubsan_epilogue+0xe/0x4e
>  __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
>  __mdiobus_register+0x49d/0x4e0
>  fixed_mdio_bus_init+0xd8/0x12d
>  do_one_initcall+0x76/0x430
>  kernel_init_freeable+0x3b3/0x422
>  kernel_init+0x24/0x1e0
>  ret_from_fork+0x1f/0x30
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [v2] net: mdio: fix undefined behavior in bit shift for __mdiobus_register
    https://git.kernel.org/netdev/net/c/40e4eb324c59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


