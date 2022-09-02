Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC225AADB9
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiIBLcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiIBLbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15352B248
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88ADFB82A6F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33EEAC433D6;
        Fri,  2 Sep 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662118215;
        bh=4zwp8RVvDmDdbg/P/HHaLUw9iIiFn0/LZvlq0jim6sg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qBmIhYASJN2mZ2P1p0hHWlvFSO8Wtz4oUReO1ogt4+6JGRBJjF2R+p3FN5oq5tx9c
         GlRm47qsNO9R72omSPWugcuLxGLZOROv26S0Bgoq6REcy9zS/c43eP+V7/xYSLHyy5
         Uz6fPr8dx23qnNMjsOKyeXvsyXC8njU7VxApyzzjSgCXrfaZqiAi4ts37qvHgOM+wY
         Xl5TbPXARBUtB7AHLNZXimL2GxHNwVbR0lk/am7e5Ykzwn7uTkcKq3OksxvCbvKazH
         0GBPjkUq9zPoHd6DMCC+33GgQlCzTc78oWswvevJGkbdaraWXu1sSoey9BvNjur1q4
         102DIsWI7z5bQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13AB8E924D5;
        Fri,  2 Sep 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sch_sfb: Don't assume the skb is still around after
 enqueueing to child
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166211821507.29115.10248294582452708288.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 11:30:15 +0000
References: <20220831215219.499563-1-toke@toke.dk>
In-Reply-To: <20220831215219.499563-1-toke@toke.dk>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+?=@ci.codeaurora.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        eric.dumazet@gmail.com, davem@davemloft.net,
        zdi-disclosures@trendmicro.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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

On Wed, 31 Aug 2022 23:52:18 +0200 you wrote:
> The sch_sfb enqueue() routine assumes the skb is still alive after it has
> been enqueued into a child qdisc, using the data in the skb cb field in the
> increment_qlen() routine after enqueue. However, the skb may in fact have
> been freed, causing a use-after-free in this case. In particular, this
> happens if sch_cake is used as a child of sfb, and the GSO splitting mode
> of CAKE is enabled (in which case the skb will be split into segments and
> the original skb freed).
> 
> [...]

Here is the summary with links:
  - [net,v2] sch_sfb: Don't assume the skb is still around after enqueueing to child
    https://git.kernel.org/netdev/net/c/9efd23297cca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


