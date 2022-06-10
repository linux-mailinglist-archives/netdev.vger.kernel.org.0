Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E67545B93
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345926AbiFJFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345675AbiFJFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA23B02E;
        Thu,  9 Jun 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C65B8311E;
        Fri, 10 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86908C3411F;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654838414;
        bh=3+ptgkURu5j/U/TB6us2tRzvYo3qtMDT4Iv/qWB/00s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QDvR5wH0vFFz4de7OobFJJRZydbivqgo1dbcMzSxGBIkHNxeMfywxBd2Lkh6sJiyM
         iMrwuv3bGxjSBKNtXePQKvuEMnoWfMLhDzGeaQUY0XzO9NyCPW3tHkBmfpJTxumFgO
         Dtrj2Y8So3ozs/W1OmyvqUBOucoq74A+Q7pXSlyWnnmtcBDaxumjqqe0kENZlVU/zW
         7Lir34ZwNO3N7hoj6znK1JEGnxIyHKF8p+DG+4IrkBd0oOlzX0fh8C5WGT+ULAKrz/
         yPo4Dqzuk8RhdUWJI3Q4pd6miszTgS0uutS1mMAfyWPVOmkUUgiEzcNKF5eol7emNB
         X0rVSQu2JoEJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EC78E737F6;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using
 flowi_l3mdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483841444.4442.5625018841783300532.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:20:14 +0000
References: <20220608091917.20345-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20220608091917.20345-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stefano.salsano@uniroma2.it, paolo.lungaroni@uniroma2.it,
        ahabdels.dev@gmail.com, am@3a-alliance.com
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

On Wed,  8 Jun 2022 11:19:17 +0200 you wrote:
> Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
> reset for port devices") adds a new entry (flowi_l3mdev) in the common
> flow struct used for indicating the l3mdev index for later rule and
> table matching.
> The l3mdev_update_flow() has been adapted to properly set the
> flowi_l3mdev based on the flowi_oif/flowi_iif. In fact, when a valid
> flowi_iif is supplied to the l3mdev_update_flow(), this function can
> update the flowi_l3mdev entry only if it has not yet been set (i.e., the
> flowi_l3mdev entry is equal to 0).
> 
> [...]

Here is the summary with links:
  - [net] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev
    https://git.kernel.org/netdev/net/c/a3bd2102e464

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


