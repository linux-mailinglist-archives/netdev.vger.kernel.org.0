Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C05AD3B7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbiIENUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiIENUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047F73A4AC;
        Mon,  5 Sep 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B598FB81199;
        Mon,  5 Sep 2022 13:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 687F0C433B5;
        Mon,  5 Sep 2022 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662384014;
        bh=e9NEwRa9nVE7vDMPK/zgYTGoSMf7Tlz/nhF2GzBSrgs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUJvm8xP4h0LpId+ykFj4g/mw6OA0294exGolRgPYQ7tz2omje0h8GgbjxPyyZRw0
         Bcgb94YPKvVlsgnKzV3mxcQuNZoBZ1KQV/CB2z/A8WIuyw1+DUscKZSZrPirDrVj1A
         SWOBelSxMOXMEzYbP8HhXOWEmylTefH07+XTqlyWe2MUQR0gp2aU77sX37qqvnuSBv
         fVDbeHuVtFPG8Ikrp+CFQyEM7f+uYEHRsKYsF5UfBr0nTCoTftEZONU5YiIBKak57H
         lyaTH9+bDrcYp9BiiMx6D3V7av9HroHYkQQCNY8HhCuGz2udy4677/+kC3RI4kJRtZ
         9V+/ZvyL3VMpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F006E1CABF;
        Mon,  5 Sep 2022 13:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix memory leak when using
 debugfs_lookup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238401431.22589.16841027268928953217.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:20:14 +0000
References: <20220902134111.280657-1-gregkh@linuxfoundation.org>
In-Reply-To: <20220902134111.280657-1-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mw@semihalf.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, stable@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 15:41:11 +0200 you wrote:
> When calling debugfs_lookup() the result must have dput() called on it,
> otherwise the memory will leak over time.  Fix this up to be much
> simpler logic and only create the root debugfs directory once when the
> driver is first accessed.  That resolves the memory leak and makes
> things more obvious as to what the intent is.
> 
> Cc: Marcin Wojtas <mw@semihalf.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: stable <stable@kernel.org>
> Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [...]

Here is the summary with links:
  - [net] net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()
    https://git.kernel.org/netdev/net/c/fe2c9c61f668

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


