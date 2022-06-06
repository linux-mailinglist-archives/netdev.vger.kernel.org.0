Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B2C53EDC0
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiFFSUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiFFSUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C979F92703;
        Mon,  6 Jun 2022 11:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 648A161335;
        Mon,  6 Jun 2022 18:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3DB5C385A9;
        Mon,  6 Jun 2022 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654539612;
        bh=44SzrEgcZC4Ze2JxLGZlcL4zkzuRWW91q9X/6/lv8K4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bHQv4B/DNvIk4Pfpos8c1wB/OOhY6ANTKT7P6TcHGHanR11JasFbC4bCj3xPr3tvU
         DfdnITF4zqNFkpyDT8MBm+K/TVYVgFdQyYnW6G43J6mn0VIZ5BOix2bS2jWpMgyTTX
         R3ns1axd6vlGrBSMnHDUz7c3Ibj/1NbkrqbfCeM198052417FHqjs6YzBKdTa942fd
         7d96UygE/9dkPY9zRPuS80IbN+QEDOzBn2OgYYTvGfhaB2sUyTkqjn3PE888PxPKUV
         KkV4l5MHtTFzo59L70LY0z3+GPx9iX7AxDt8esf9+CSWpG4YO9p5HSRZc15ZcE0RYX
         MDVtuJ6ROJ1FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAC82E737ED;
        Mon,  6 Jun 2022 18:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN when
 link change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165453961269.17643.13140581506341939026.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Jun 2022 18:20:12 +0000
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
In-Reply-To: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dmurphy@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        weifeng.voon@intel.com, michael.wei.hong.sit@intel.com,
        pei.lee.ling@intel.com, hong.aun.looi@intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 26 May 2022 17:03:47 +0800 you wrote:
> There is a limitation in TI DP83867 PHY device where SGMII AN is only
> triggered once after the device is booted up. Even after the PHY TPI is
> down and up again, SGMII AN is not triggered and hence no new in-band
> message from PHY to MAC side SGMII.
> 
> This could cause an issue during power up, when PHY is up prior to MAC.
> At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> receive new in-band message from TI PHY with correct link status, speed
> and duplex info.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: phy: dp83867: retrigger SGMII AN when link change
    https://git.kernel.org/netdev/net/c/c76acfb7e19d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


