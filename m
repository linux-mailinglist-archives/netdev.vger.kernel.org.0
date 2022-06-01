Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B345E539BEF
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiFAEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFAEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3133D9A9BD
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 21:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB749B80F79
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C211C34119;
        Wed,  1 Jun 2022 04:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654056012;
        bh=GbhPSamtydDBES8MbHnz5pLQI3wIs9En+il/RLQUydc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=irabpDq6XEABiZ1+pZ2ORlmPrY+8WAQ6ku2505eDgK2s5J5H/DA/5689NWxQ8h9gi
         aQ+o0H0DfPkudjwihTnoNMy01iF7YyKG5tPosJ/C5YLljWOhSY6EORdxVFhjERzbT7
         9DBzFWcQOaXsYMa15w1nKkWxCBkDaDZ1kNd0XYS0n7GkWTM4Mnm0J9GSLwIdvCgRx7
         2dFv+NvtG2C7Mpa2+lD6Zo7/Rq1h1EgpPlMk3XpU2rtiU0j38mZEioBygms/2pVjZS
         tgdleMCnr6hVAoq9nLqYwgr1e3BlNkW04hNUS+01OXXPUBfbPJ7Q+XGcDRD7Xu1NUh
         UqEYGbQ8rbEgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20E0CEAC081;
        Wed,  1 Jun 2022 04:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] net: sched: add barrier to fix packet stuck problem
 for lockless qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165405601213.26403.11241639383072394003.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 04:00:12 +0000
References: <20220528101628.120193-1-gjfang@linux.alibaba.com>
In-Reply-To: <20220528101628.120193-1-gjfang@linux.alibaba.com>
To:     Guoju Fang <gjfang@linux.alibaba.com>
Cc:     linyunsheng@huawei.com, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, guoju.fgj@alibaba-inc.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rgauguey@kalrayinc.com,
        sjones@kalrayinc.com, vladimir.oltean@nxp.com, vray@kalrayinc.com,
        will@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 28 May 2022 18:16:28 +0800 you wrote:
> In qdisc_run_end(), the spin_unlock() only has store-release semantic,
> which guarantees all earlier memory access are visible before it. But
> the subsequent test_bit() has no barrier semantics so may be reordered
> ahead of the spin_unlock(). The store-load reordering may cause a packet
> stuck problem.
> 
> The concurrent operations can be described as below,
>          CPU 0                      |          CPU 1
>    qdisc_run_end()                  |     qdisc_run_begin()
>           .                         |           .
> 
> [...]

Here is the summary with links:
  - [v4,net] net: sched: add barrier to fix packet stuck problem for lockless qdisc
    https://git.kernel.org/netdev/net/c/2e8728c955ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


