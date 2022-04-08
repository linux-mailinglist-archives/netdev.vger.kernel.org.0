Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509044F9F6A
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiDHWCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDHWCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10411136C2A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 15:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA72D620B5
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 22:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18EB6C385A5;
        Fri,  8 Apr 2022 22:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649455212;
        bh=xRJ0VaH+UdSY2G8XSKJ40GGjbS6Pa5CtZNLnWnvIono=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yn0YDqA0qBx5st8sJjk2XXUs4mLZEHqDTAW91nS2LJ2jZbgH8c81OmqLUyfK2S1Yz
         o9P2Z8Vuxx8OZg41Pe9wcV/UCT+J4lfZ9c3GZ3/uYUnWpQazYzwXhLkQ2XBe4AfzAz
         QXcdQxF9li1C+jAU+ubIEcYjL6kDSzXmIjjcxkgQdwdEY4h7Y94xepcxd+Cn4VZnCB
         64ODdI6XsZ3brXvFTIkw1XUZrkaFnIP4cOAZUcsN3k3fB0WrdLzFaNpRwafLFHL4YV
         TO9RPWQRyqRUKGujoJh7K74nM2i3/qc9YEo6KEZZ1vuspzUfqbosnLQBAjmpy+v3PL
         Rga1Z0v95AcUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE591E8DD5E;
        Fri,  8 Apr 2022 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: fix initialization order when updating chain 0
 head
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945521197.24737.6537631009276589069.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 22:00:11 +0000
References: <b97d5f4eaffeeb9d058155bcab63347527261abf.1649341369.git.marcelo.leitner@gmail.com>
In-Reply-To: <b97d5f4eaffeeb9d058155bcab63347527261abf.1649341369.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, dcaratti@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        lariel@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 11:29:23 -0300 you wrote:
> Currently, when inserting a new filter that needs to sit at the head
> of chain 0, it will first update the heads pointer on all devices using
> the (shared) block, and only then complete the initialization of the new
> element so that it has a "next" element.
> 
> This can lead to a situation that the chain 0 head is propagated to
> another CPU before the "next" initialization is done. When this race
> condition is triggered, packets being matched on that CPU will simply
> miss all other filters, and will flow through the stack as if there were
> no other filters installed. If the system is using OVS + TC, such
> packets will get handled by vswitchd via upcall, which results in much
> higher latency and reordering. For other applications it may result in
> packet drops.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: fix initialization order when updating chain 0 head
    https://git.kernel.org/netdev/net/c/e65812fd22eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


