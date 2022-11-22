Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D76633804
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiKVJKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiKVJKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:10:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B58845ECE;
        Tue, 22 Nov 2022 01:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E948CE1B37;
        Tue, 22 Nov 2022 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63D8FC43141;
        Tue, 22 Nov 2022 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669108215;
        bh=yPvb+AoqGuUwGoBBZauxC+OEtyXHX1OiJohZ6EOZPZc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IfqIZcoAjmcC0WV8wYok4g21EHKjMnYoMp0gmktIz2ge+YAoXkjVECndeg3PrSpJx
         jnOBO9qOedWl2aXlDlwJCoX4XC8RQk9R1FMqx/rgcT8OLcYzRJheER2aX77qrXQ5IG
         hIHdmfvBbGNcG3pOPwYSxQevMBkjlP8sZ6t/f7aH/rvJEn8gbiVHTqRMYOWPsmy2zo
         Eom6kOc2mNpDk2s1ZgzBH+Q3zpY1swASKcSgpCYBrpxrrjCHnoqmrCVReLzJ+IuIjC
         BrLzL0YKuvl2rFEKKkFZWZfNLVjbpzaPhWyZyql9Ixrpk+4G9V+tqs9/SFA3iLQKet
         eg59LXEysxZfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 493ADE4D038;
        Tue, 22 Nov 2022 09:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-pf: Add additional checks while
 configuring ucast/bcast/mcast rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166910821529.27872.4243816404919308717.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 09:10:15 +0000
References: <20221118053329.2288486-1-sumang@marvell.com>
In-Reply-To: <20221118053329.2288486-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 18 Nov 2022 11:03:29 +0530 you wrote:
> 1. If a profile does not support DMAC extraction then avoid installing NPC
> flow rules for unicast. Similarly, if LXMB(L2 and L3) extraction is not
> supported by the profile then avoid installing broadcast and multicast
> rules.
> 2. Allow MCAM entry insertion for promiscuous mode.
> 3. For the profiles where DMAC is not extracted in MKEX key default
> unicast entry installed by AF is not valid. Hence do not use action
> from the AF installed default unicast entry for such cases.
> 4. Adjacent packet header fields in a packet like IP header source
> and destination addresses or UDP/TCP header source port and destination
> can be extracted together in MKEX profile. Therefore MKEX profile can be
> configured to in two ways:
> 	a. Total of 4 bytes from start of UDP header(src port
> 	   + destination port)
> 	or
> 	b. Two bytes from start and two bytes from offset 2
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules
    https://git.kernel.org/netdev/net-next/c/674b3e164238

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


