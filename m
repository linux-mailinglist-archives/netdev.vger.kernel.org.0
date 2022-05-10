Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC76D520A75
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiEJBEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiEJBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:04:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF976205F18;
        Mon,  9 May 2022 18:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E45B81A59;
        Tue, 10 May 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 015C4C385C6;
        Tue, 10 May 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652144413;
        bh=ziS3WCHioEKf1pR5CDM4tX9+GV1g1JENVBzt48tvVFg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hs6iPTsTeqsbF6Fhl7cf8H3O32eKb+lziCo5nbA9Jn+r4ymCc2jKHEaDmsQMSezGd
         sOD8QvxClWAHR/hLGtCffrDam2rlxzbjcDawPtkTc3aRb3QRw72oC6g3X6yAn/5wnm
         VAZUD6RWWaKro9qpStn7/B3FSG52C2G5Rp/IeimLNs/CE/4WhXCo/Kcsyo64sGvTnD
         Bq993rjcCg5Lf2NBhofGRsCtd+2JmLaRTWLWwWUFkcUCK/EoQS8naSZLV1G8WIl1fg
         rexWnsA1ZUdkIwpqbS2vhdf1ebhEKz5mUtqOSj02zlEzJnAI3yms2kvmHB6fxPEBcI
         CQqAfBKG39wFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8B22F0392B;
        Tue, 10 May 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: phy: Fix race condition on link status change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214441281.5782.4607549809987119589.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:00:12 +0000
References: <20220506060815.327382-1-francesco.dolcini@toradex.com>
In-Reply-To: <20220506060815.327382-1-francesco.dolcini@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  6 May 2022 08:08:15 +0200 you wrote:
> This fixes the following error caused by a race condition between
> phydev->adjust_link() and a MDIO transaction in the phy interrupt
> handler. The issue was reproduced with the ethernet FEC driver and a
> micrel KSZ9031 phy.
> 
> [  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
> [  146.201779] ------------[ cut here ]------------
> [  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
> [  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
> [  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
> [  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  146.236257]  unwind_backtrace from show_stack+0x10/0x14
> [  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
> [  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
> [  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
> [  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
> [  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
> [  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
> [  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
> [  146.279605]  irq_thread from kthread+0xe4/0x104
> [  146.284267]  kthread from ret_from_fork+0x14/0x28
> [  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
> [  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
> [  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  146.318262] irq event stamp: 12325
> [  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
> [  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
> [  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
> [  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
> [  146.354447] ---[ end trace 0000000000000000 ]---
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: Fix race condition on link status change
    https://git.kernel.org/netdev/net/c/91a7cda1f4b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


