Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB969045D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBIKAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBIKAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:00:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0C14483;
        Thu,  9 Feb 2023 02:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85F8BCE23D5;
        Thu,  9 Feb 2023 10:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D18CC433D2;
        Thu,  9 Feb 2023 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675936818;
        bh=/9NKdtzCo8tJI2tx/w0c3GPDs6qabtJxV2vUSaqbF8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rdv/L7N2BCBAsTYdAphzX0pwogwF/oz57Mn/WoV1Uik65XHZPdYyRbok0nBCsCJYE
         bWu7G4My2oQ2aNiYg0FipkQdKoeivc8TLtTPUPuX2Tu6qRbFrVcY1pXyqCpYm+Ou23
         rdfXK6s0FxGOth7NyI3As2P38snEdkJ65ASHaEOPLYbFRT93bii7roSOsJHD4Zkqa1
         0h5YL+wy/1jOOJL0HhwCFaUhuFYVbMOYPMOx0eQ/EQv38XCd9xvYtAKkfy4yep+ZLF
         WBPxwm5G5Wp1iHeMUw2vaO4JARmdA5QqPdOc4Ou9N5Ncmgg44tK3hp57S9tuHfQR0j
         X6HzRs9llxidw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81BDDE21ECB;
        Thu,  9 Feb 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix all IPv6 getting trapped to CPU
 when PTP timestamping is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167593681852.28731.14622804997135621411.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 10:00:18 +0000
References: <20230207183117.1745754-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230207183117.1745754-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        colin.foster@in-advantage.com, xiaoliang.yang_1@nxp.com,
        richard.pearn@nxp.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  7 Feb 2023 20:31:17 +0200 you wrote:
> While running this selftest which usually passes:
> 
> ~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
> TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
> TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
> TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used
    https://git.kernel.org/netdev/net/c/2fcde9fe258e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


