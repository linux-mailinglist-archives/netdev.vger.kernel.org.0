Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5D560FDA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiF3EAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiF3EAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A1029CB8;
        Wed, 29 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35146B8283C;
        Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDEC0C341D0;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561614;
        bh=YQpWjizCBU1xfBzC7Z22FeM34H9iQzhmg7Khyd+0GoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L2Istz2Mjg1Z/LwOfWIS6971JJcb/ENJPP9qn7NosUwoWlZB71zhXmZknc8h7tzpb
         3l1/b8a8ginD9iPeh7sXXa+6qjT912Kpm2dIpj4EKxp9SWqA/SYQI8z4ZTaSdbqvzh
         MmUwANc+IFb5xys7a1Q0IL8hDstKbnCALo694SAC0xzpo72zpgrpBnXUzu2cwMMjuX
         C6j7R1Fn0kwlAcWrA2ZWnsty/DCsKWPvNdvEwYPwqlgSOcESfp9/QYC7mRTidZgyD8
         Bwm4lubYWwweF4Q/rRwO3VJNswcvCSHwrTLGp+Njj2YGdUbzhArkEECxPWSK91hB/6
         wZuUz+63vt/0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C670CE49FA2;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: phy: Don't trigger state machine while in suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161380.1686.7209297223304066004.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:13 +0000
References: <b7f386d04e9b5b0e2738f0125743e30676f309ef.1656410895.git.lukas@wunner.de>
In-Reply-To: <b7f386d04e9b5b0e2738f0125743e30676f309ef.1656410895.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, m.szyprowski@samsung.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        oneukum@suse.com, andre.edich@microchip.com,
        linux@rempel-privat.de, martyn.welch@collabora.com,
        ghojda@yo2urs.ro, chf.fritz@googlemail.com, LinoSanfilippo@gmx.de,
        p.rosenberger@kunbus.com, fntoth@gmail.com, krzk@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rafael@kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 12:15:08 +0200 you wrote:
> Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
> but subsequent interrupts may retrigger it:
> 
> They may have been left enabled to facilitate wakeup and are not
> quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
> hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
> as well as between dpm_resume_noirq() and mdio_bus_phy_resume().
> 
> [...]

Here is the summary with links:
  - [net,v4] net: phy: Don't trigger state machine while in suspend
    https://git.kernel.org/netdev/net/c/1758bde2e4aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


