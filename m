Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA7056987A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiGGDAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiGGDAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916622F669;
        Wed,  6 Jul 2022 20:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F27D62153;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A37AC341C6;
        Thu,  7 Jul 2022 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162813;
        bh=N8b8Kgo3TvZmFgrWYY3ovqkpBeOo6ywQTI9gO+NvEcI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DYo65RSKuCA308SwdH4IS29/zn5qkE/oeVaqJUNnCyepBLgX4fyYSRZ08pJORE3iq
         XN6bn5MlDIAhE2SAURtNVGix1erky5naN9BYVUee+BSF+dzcUm/D0l1Aa//8Vj3l80
         W/tSUvXK0bfLxlh9tp+1luFwK6Iz6SFOeMItwneLSm+O+va/AwXxOUWwAWX38q54Rf
         KhnR5ApY7PksUeJy8GLzeEIplzlW5MNmNV95UhWmPGUQTreHdUjyuSKl081QSwd5+i
         K4Ai8GrmyR5bKBPMjuBBps0BGJhW+rAqvryQMYLHnFc3+ZUD7fnGIv/99Ogo8eGMHy
         YoAlLlMveOlPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D51CE45BD9;
        Thu,  7 Jul 2022 03:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: rose: fix UAF bug caused by rose_t0timer_expiry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281344.11165.3540358551022288195.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:13 +0000
References: <20220705125610.77971-1-duoming@zju.edu.cn>
In-Reply-To: <20220705125610.77971-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 20:56:10 +0800 you wrote:
> There are UAF bugs caused by rose_t0timer_expiry(). The
> root cause is that del_timer() could not stop the timer
> handler that is running and there is no synchronization.
> One of the race conditions is shown below:
> 
>     (thread 1)             |        (thread 2)
>                            | rose_device_event
>                            |   rose_rt_device_down
>                            |     rose_remove_neigh
> rose_t0timer_expiry        |       rose_stop_t0timer(rose_neigh)
>   ...                      |         del_timer(&neigh->t0timer)
>                            |         kfree(rose_neigh) //[1]FREE
>   neigh->dce_mode //[2]USE |
> 
> [...]

Here is the summary with links:
  - [net,v2] net: rose: fix UAF bug caused by rose_t0timer_expiry
    https://git.kernel.org/netdev/net/c/148ca0451807

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


