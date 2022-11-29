Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3663B7B5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiK2CUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiK2CUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092D22AC69
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92B3661525
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8E49C433B5;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688417;
        bh=gZXnDY7IhpgdHyjCbmERoRzA1KhRoeosA5Rc793/4Yk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jQQr+eu/eA0OfQvjM4/ZdQzYUWx/3Uv+k3boubBV+h4HUGDsPu11TwSCNR+V0BLqQ
         fJwuVrbzOSzvVJNUpAS7OTvW+jsNr3mZ2D+GFAOw1cmywN8H1Mn/CdxZpo4Up2EFIu
         M4F92aiYTk8gWz+sPizi4EUb0L/trE6Be9uCdL5KsrIHIzLrx1P/sh0PyBs3HcCqTW
         4kU2SL0Xqqv3Y+E9VMgt8mgC6OpTbvbveRsYViw/YjjBgxMVu5Ac6t5oBDsN0DP8iD
         ufopvjqVF+91JuS4xHa07ngbyWtC9inkbVJGMyRbK2z3Wy1Nu5oGw/GqL4x463qhbe
         R2x1+jTAgYMQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAC31E21EF7;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: re-fetch skb cb after tipc_msg_validate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841682.21086.10246937991954611.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <1b1cdba762915325bd8ef9a98d0276eb673df2a5.1669398403.git.lucien.xin@gmail.com>
In-Reply-To: <1b1cdba762915325bd8ef9a98d0276eb673df2a5.1669398403.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        shuali@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 12:46:43 -0500 you wrote:
> As the call trace shows, the original skb was freed in tipc_msg_validate(),
> and dereferencing the old skb cb would cause an use-after-free crash.
> 
>   BUG: KASAN: use-after-free in tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
>   Call Trace:
>    <IRQ>
>    tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
>    tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
>    tipc_rcv+0x744/0x1150 [tipc]
>   ...
>   Allocated by task 47078:
>    kmem_cache_alloc_node+0x158/0x4d0
>    __alloc_skb+0x1c1/0x270
>    tipc_buf_acquire+0x1e/0xe0 [tipc]
>    tipc_msg_create+0x33/0x1c0 [tipc]
>    tipc_link_build_proto_msg+0x38a/0x2100 [tipc]
>    tipc_link_timeout+0x8b8/0xef0 [tipc]
>    tipc_node_timeout+0x2a1/0x960 [tipc]
>    call_timer_fn+0x2d/0x1c0
>   ...
>   Freed by task 47078:
>    tipc_msg_validate+0x7b/0x440 [tipc]
>    tipc_crypto_rcv_complete+0x4b5/0x2240 [tipc]
>    tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
>    tipc_rcv+0x744/0x1150 [tipc]
> 
> [...]

Here is the summary with links:
  - [net] tipc: re-fetch skb cb after tipc_msg_validate
    https://git.kernel.org/netdev/net/c/3067bc61fcfe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


