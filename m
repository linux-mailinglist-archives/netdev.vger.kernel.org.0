Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F26E2E90
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDOCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjDOCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBC659D2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 19:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8547649F5
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BB33C4339B;
        Sat, 15 Apr 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681525218;
        bh=XolYpPsB7LkNfzWSV51lbDnShsMOYRq3tNb78rmQBXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lVC3nUSsUaH3SkrdiPf/u8fBXMe4W8cVoVnicuVMb4drfwkZfL1/rMh//Nsdo/F7t
         ARpindzdtm19sT0ogbWlppfzuKXxtwG//zux9agoIRoDe8w74COqtNRMRwdJqT6MZA
         LhHILEBlqGozdEzsNgaIRvsNzrLXKsIAdriQrVdWvELAhHLVUJebOieROKUQCL1jdq
         o3prOc4o/rYPMSAkrk/lEhPskDnvjR7Hz52mmNPz/Wrurb3k2HQiGZ5UDJjIxZryMg
         v9VqZGfafuTVMWk81RuxGMqfEByJWUdO11YnitHUJcg61rvN8YDvDoVhojiReHb8Jx
         wRJs6MLbFca2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30463E29F41;
        Sat, 15 Apr 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] page_pool: allow caching from safely
 localized NAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168152521818.19909.13076060995417512854.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Apr 2023 02:20:18 +0000
References: <20230413042605.895677-1-kuba@kernel.org>
In-Reply-To: <20230413042605.895677-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, alexander.duyck@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 21:26:02 -0700 you wrote:
> I went back to the explicit "are we in NAPI method", mostly
> because I don't like having both around :( (even tho I maintain
> that in_softirq() && !in_hardirq() is as safe, as softirqs do
> not nest).
> 
> Still returning the skbs to a CPU, tho, not to the NAPI instance.
> I reckon we could create a small refcounted struct per NAPI instance
> which would allow sockets and other users so hold a persisent
> and safe reference. But that's a bigger change, and I get 90+%
> recycling thru the cache with just these patches (for RR and
> streaming tests with 100% CPU use it's almost 100%).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: skb: plumb napi state thru skb freeing paths
    https://git.kernel.org/netdev/net-next/c/b07a2d97ba5e
  - [net-next,v2,2/3] page_pool: allow caching from safely localized NAPI
    https://git.kernel.org/netdev/net-next/c/8c48eea3adf3
  - [net-next,v2,3/3] bnxt: hook NAPIs to page pools
    https://git.kernel.org/netdev/net-next/c/294e39e0d034

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


