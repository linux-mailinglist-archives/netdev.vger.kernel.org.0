Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA6563DF5
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiGBDU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiGBDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E01326C4;
        Fri,  1 Jul 2022 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1720B832C2;
        Sat,  2 Jul 2022 03:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9043FC341DB;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732015;
        bh=FrVW95x2SQ8FV/XOJFEuHWJd0qX9legd8nZ8qX/udBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IybdRVYpV5DhjZAdnWsjjMsWODQ1k4XqW/D7SHO81iTN8JqgHPbYwk1e46eEGFVZQ
         cHu29ziu23r0VelujmLJF3T8WCXwwgdgPQjrYE9mNfzeli0EXWNJrG/M+8QewZbZrC
         OONVoeWirAwmIWiDs4qStEu33pvUCAxgbDKvlUFPl1gBV5pyf3nTtBk8KDQA3q3NmE
         /tWPxvt4hjN7RRRCKR79q3rKlBxJzwy/5Db2XDZBOJQ4GclqIInPyUcRMan7t0uIBo
         +PfXFjU4Z7gsx6fvFdWIf67uO9WS1wfflATzLG/IfcVCGEA7VNZKXqiSln9fKFsbFD
         xdBUGNIC/wqyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7118CE49FA3;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pcs: rzn1-miic: update speed only if interface
 is changed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201545.6297.13593698889727547584.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:15 +0000
References: <20220629122003.189397-1-clement.leger@bootlin.com>
In-Reply-To: <20220629122003.189397-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, herve.codina@bootlin.com,
        miquel.raynal@bootlin.com, milan.stevanovic@se.com,
        jimmy.lalande@se.com, pascal.eberhard@se.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jun 2022 14:20:03 +0200 you wrote:
> As stated by Russel King, miic_config() can be called as a result of
> ethtool setting the configuration while the link is already up. Since
> the speed is also set in this function, it could potentially modify
> the current speed that is set. This will only happen if there is
> no PHY present and we aren't using fixed-link mode.
> 
> Handle that by storing the current interface mode in the miic_port
> structure and update the speed only if the interface mode is going to
> be changed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: pcs: rzn1-miic: update speed only if interface is changed
    https://git.kernel.org/netdev/net-next/c/90c74f4d90ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


