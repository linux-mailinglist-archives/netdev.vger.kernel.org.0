Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64B2677998
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjAWKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjAWKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73E46B1;
        Mon, 23 Jan 2023 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B78E9B80D21;
        Mon, 23 Jan 2023 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60C38C4339B;
        Mon, 23 Jan 2023 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674471015;
        bh=dCbrJJE9mH9LfCBEeDNAhic0iHCxsaDbfb1CiqKpPXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RmozU3ekomEM43zWX0QFDb4cS5ZK6AgDC4UzL32enyPpzmLbvXwPdPoxkwwWN6wzI
         W6OM68k36bxg7rFEKJnKHOYfCBf0faZZyoN+EtwMayEY+R+ERjBBgk0M8PiULFy368
         3B75KY14on3MNeQELL9OcBnt0XpbIBxXd1PerBfRKDIodBi0CTy/VM0lBZLNOnPa9e
         2XIe+EeztLSijjvzVK8TTQ3mDA2MiaZ/LPfiE5PrOm1OkYOHamGjqO0Qe6u+wNWyI5
         I9sNr3SCVjWQfnwhTJvZoTSPn01cMaeowJwOz6WHLMq8yULzC1ga+Fys74JWrFBoFs
         4WcA9W9SIm7mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47E5EE5256E;
        Mon, 23 Jan 2023 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fec: Use page_pool_put_full_page when freeing rx
 buffers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167447101529.31244.5946300408564570569.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 10:50:15 +0000
References: <20230119043747.943452-1-wei.fang@nxp.com>
In-Reply-To: <20230119043747.943452-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 12:37:47 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The page_pool_release_page was used when freeing rx buffers, and this
> function just unmaps the page (if mapped) and does not recycle the page.
> So after hundreds of down/up the eth0, the system will out of memory.
> For more details, please refer to the following reproduce steps and
> bug logs. To solve this issue and refer to the doc of page pool, the
> page_pool_put_full_page should be used to replace page_pool_release_page.
> Because this API will try to recycle the page if the page refcnt equal to
> 1. After testing 20000 times, the issue can not be reproduced anymore
> (about testing 391 times the issue will occur on i.MX8MN-EVK before).
> 
> [...]

Here is the summary with links:
  - [net] net: fec: Use page_pool_put_full_page when freeing rx buffers
    https://git.kernel.org/netdev/net/c/e38553bdc377

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


