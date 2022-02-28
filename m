Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50F74C69F2
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiB1LPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiB1LOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:14:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E50A6E2AA;
        Mon, 28 Feb 2022 03:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CDC60F33;
        Mon, 28 Feb 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D015CC340EE;
        Mon, 28 Feb 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646046610;
        bh=yUVHn57kdLjS6xtDWfHz+vte27rGDl5QBlu+zCXToME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MI0gOhBmPbcDlF7xNQ8ByO5nEUqF8knh4sRvnewpOZil3M+rAG7FlovuihG6q5GBT
         0E7vhU9C5Jeok3EZaX33kIDCeS4GkpEpL9XnCVBXOX6CkY19mov1wn/GFtyvfg0tjg
         3B3Rt6CT+gFlKxxbX6nGPo0eA54KtLlccyRTHmSj2q6Z3AYnoiuRYKnKioDpNqXRgF
         W7Ukqh9d7TM9PKLzonplZLzzxC4wxRypPRi2fgTzPm2DrqOCpoKFxmlFfZM8aqMkD2
         vZ5VBAWwPwur7Ho6hhzWoroZmTQUAeQ/2gYyXtTHgCGQ51vb00JA/iTGgvwn9uFF7k
         WpckZBhEbbGAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4D0FEAC09E;
        Mon, 28 Feb 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv6: ensure we call ipv6_mc_down() at most once 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604661073.20013.1894707946002547929.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:10:10 +0000
References: <OF120FC6BB.53B5B31C-ONC12587F3.002A9E5A-C12587F3.0032105C@avm.de>
In-Reply-To: <OF120FC6BB.53B5B31C-ONC12587F3.002A9E5A-C12587F3.0032105C@avm.de>
To:     None <j.nixdorf@avm.de>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com,
        hannes@stressinduktion.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Feb 2022 10:06:49 +0100 you wrote:
> There are two reasons for addrconf_notify() to be called with NETDEV_DOWN:
> either the network device is actually going down, or IPv6 was disabled
> on the interface.
> 
> If either of them stays down while the other is toggled, we repeatedly
> call the code for NETDEV_DOWN, including ipv6_mc_down(), while never
> calling the corresponding ipv6_mc_up() in between. This will cause a
> new entry in idev->mc_tomb to be allocated for each multicast group
> the interface is subscribed to, which in turn leaks one struct ifmcaddr6
> per nontrivial multicast group the interface is subscribed to.
> 
> [...]

Here is the summary with links:
  - net: ipv6: ensure we call ipv6_mc_down() at most once
    https://git.kernel.org/netdev/net/c/9995b408f17f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


