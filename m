Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8DC520A9B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiEJBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiEJBYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B481A20F774
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D486B81A6A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A1C3C385C7;
        Tue, 10 May 2022 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652145613;
        bh=3CWkc1QD+14BPOojWsyLteAn9/GOrTidNxwF2KiexpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tp2/iHxjfCA9n+GE8ZyCrVD5GkhvWbFOfHwBvRNg5ipuwkYDi8L/coBzkZVhC2tCl
         hd91vEWgrmIILT1rO5MVLvhxwsRkH9aerNiA0sk8U4o4hxCGBvqwKIPH/1LqOlEVaO
         ZgWefZFZ8hse2C+4BAwcT4t+lrckeLi8rNIqPAfwMHOrzfuXhvjragbXiNSCr1vnO3
         GOw7RgPXAyrYVK3mb1euUgbfFA2GDnptPNQyHUeoAfHR4Ik0vQIleWH6GuH3NJ8OpO
         cEhW0K+PwZu4y8psqjaSMlbGoQ6BV70TflCXBAQWRd+vQsboTjMBy37L7s15l7Jbmw
         8zVxcZLMlABUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9B83F03931;
        Tue, 10 May 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: Don't skb_split skbuffs with frag_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214561288.15844.2929287601845577779.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:20:12 +0000
References: <20220508132110.20451-2-sw@simonwunderlich.de>
In-Reply-To: <20220508132110.20451-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, sven@narfation.org,
        felix@kaechele.ca
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
by Simon Wunderlich <sw@simonwunderlich.de>:

On Sun,  8 May 2022 15:21:10 +0200 you wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> The receiving interface might have used GRO to receive more fragments than
> MAX_SKB_FRAGS fragments. In this case, these will not be stored in
> skb_shinfo(skb)->frags but merged into the frag list.
> 
> batman-adv relies on the function skb_split to split packets up into
> multiple smaller packets which are not larger than the MTU on the outgoing
> interface. But this function cannot handle frag_list entries and is only
> operating on skb_shinfo(skb)->frags. If it is still trying to split such an
> skb and xmit'ing it on an interface without support for NETIF_F_FRAGLIST,
> then validate_xmit_skb() will try to linearize it. But this fails due to
> inconsistent information. And __pskb_pull_tail will trigger a BUG_ON after
> skb_copy_bits() returns an error.
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: Don't skb_split skbuffs with frag_list
    https://git.kernel.org/netdev/net/c/a063f2fba3fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


