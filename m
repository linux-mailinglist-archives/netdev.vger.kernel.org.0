Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E864DD33
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLOPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLOPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE262FBEF
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 07:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1781BB81BB2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 15:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80911C433F0;
        Thu, 15 Dec 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671116416;
        bh=uxVbmtJDGRIssQrK0ceAU1d9J/foU7eYysfCGlRTRH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JT0W7Bx6ck6DLLqW7q1Ah8RngUpkWT6dEu25ZDt8XnjBbggYP+49VrI+1xdjtu/97
         fesizQGXmPugLuF6g2arJWXvNWuNI2B6AW1uZh59FL+FpjT9zPnF6Ngoca118JCXBE
         mkHfng8PnOPtvQaKjSSvq6qX7v68JkMFs5XDTbiPtubm6Zpm6rvmHYMjyH9MA/SuzC
         AJhkrufB7hegfFI3AeFcylnHYMs0ivbpgYIOq258cs+zsPJr0Rk0efwiwutlMbKbHG
         KXLJXGWTlye2DzN3hU8BKUevcs144PyEwXpLFPNDDte9+gNOk3uCOXl37w6iDEISk2
         mEovvrce9XRRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62C7CE4D029;
        Thu, 15 Dec 2022 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: avoid reg_lock deadlock in
 mv88e6xxx_setup_port()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167111641640.8543.4604993324306345394.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 15:00:16 +0000
References: <20221214110120.3368472-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221214110120.3368472-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mw@semihalf.com, bigunclemax@gmail.com,
        fido_max@inbox.ru, linux@armlinux.org.uk, kabel@kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 14 Dec 2022 13:01:20 +0200 you wrote:
> In the blamed commit, it was not noticed that one implementation of
> chip->info->ops->phylink_get_caps(), called by mv88e6xxx_get_caps(),
> may access hardware registers, and in doing so, it takes the
> mv88e6xxx_reg_lock(). Namely, this is mv88e6352_phylink_get_caps().
> 
> This is a problem because mv88e6xxx_get_caps(), apart from being
> a top-level function (method invoked by dsa_switch_ops), is now also
> directly called from mv88e6xxx_setup_port(), which runs under the
> mv88e6xxx_reg_lock() taken by mv88e6xxx_setup(). Therefore, when running
> on mv88e6352, the reg_lock would be acquired a second time and the
> system would deadlock on driver probe.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
    https://git.kernel.org/netdev/net/c/a7d82367daa6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


