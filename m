Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674044AD023
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbiBHEKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiBHEKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0479C0401DC;
        Mon,  7 Feb 2022 20:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D06B81705;
        Tue,  8 Feb 2022 04:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66DBBC340EC;
        Tue,  8 Feb 2022 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644293408;
        bh=GqFK8IaEAujKFc1PL5zDQT0/2j7Js8arML9ggTjK7Gs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSFM6skrD/pWnh0vWVlq9MJp72zknjPYn4p4guMf2+SnDzC9I6+kHKbTVAWqtbiYv
         vjEZsPpCKK0pDfnLr5SA2XZ/eHcMO0JfgukEAi9RMjyNd7f1RuCdUmBaviuaRX5eP5
         Zvdpq4uffaBveAnjb6dEotj3WYPlK/dqU7sPlYh1dkmZQ6wcTgXtcjYUfncRToBGSY
         xYgnPZQfHdI3NNkRQoDYSsWODFxJDIzw3gDtFor7G+EAU+cq5u+rLN7EVhlBwbAJsh
         SHDIDu45ln3OjQHQ8sauUzaJOBrURJ+lyl0u9OzTvZ42XxDDtiLa7BT90u1Rgm5Apk
         Rk/KVM8zQvRtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B8FFE6BB3D;
        Tue,  8 Feb 2022 04:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164429340830.30538.1321723584310321832.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 04:10:08 +0000
References: <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
In-Reply-To: <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
To:     Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        Alexey.Malahov@baikalelectronics.ru,
        Sergey.Semin@baikalelectronics.ru, fancer.lancer@gmail.com,
        rmk+kernel@armlinux.org.uk, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sat, 5 Feb 2022 23:39:32 +0300 you wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply it'
> being done on the PHY side will consequently cause the traffic loss. We
> discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
    https://git.kernel.org/netdev/net/c/fe4f57bf7b58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


