Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176DC5BD948
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiITBUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiITBUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0243C8EE
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD4C62029
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4D04C433B5;
        Tue, 20 Sep 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636815;
        bh=LMG1tilXSYlPL8PUcUaBSd4reLlj3vj0kqxvtk3fUww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tDovmDxFRpIEgYw+9rE8fBoaeWoLFFRS6ZmazOy9g59ntU2KLjv809QynDAJ+ch0e
         +OWsmP2WQNnMEFT7HRr+43lLv8SMbBPbvQEkxFiVqRHsD6e9zYe/l68W5bH1fLsVqZ
         8RlS2cFRABOSZJrG3aJS0ZiUqB1VcIAv+PD8hV6EdFxiajV01f+IUOjnFgVgc9Lqrh
         /AZoH6jwHcoLtBCxjSHVqaj7jw8na46X7geCdyqD0AHqYMvkz6ojnvLnSfnfMmvTog
         IdP36UekdO1CAzC2z7UgFrWCQM++WCwPL2GKOw/1RviD4Uj84BmDKF/a4B8f06nPOy
         W6QmE7kBnCO8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA5BAE52536;
        Tue, 20 Sep 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix TX channel offset when using legacy interrupts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363681482.30260.9951271868233069504.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:20:14 +0000
References: <20220914103648.16902-1-ihuguet@redhat.com>
In-Reply-To: <20220914103648.16902-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com
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

On Wed, 14 Sep 2022 12:36:48 +0200 you wrote:
> In legacy interrupt mode the tx_channel_offset was hardcoded to 1, but
> that's not correct if efx_sepparate_tx_channels is false. In that case,
> the offset is 0 because the tx queues are in the single existing channel
> at index 0, together with the rx queue.
> 
> Without this fix, as soon as you try to send any traffic, it tries to
> get the tx queues from an uninitialized channel getting these errors:
>   WARNING: CPU: 1 PID: 0 at drivers/net/ethernet/sfc/tx.c:540 efx_hard_start_xmit+0x12e/0x170 [sfc]
>   [...]
>   RIP: 0010:efx_hard_start_xmit+0x12e/0x170 [sfc]
>   [...]
>   Call Trace:
>    <IRQ>
>    dev_hard_start_xmit+0xd7/0x230
>    sch_direct_xmit+0x9f/0x360
>    __dev_queue_xmit+0x890/0xa40
>   [...]
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>   [...]
>   RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]
>   [...]
>   Call Trace:
>    <IRQ>
>    dev_hard_start_xmit+0xd7/0x230
>    sch_direct_xmit+0x9f/0x360
>    __dev_queue_xmit+0x890/0xa40
>   [...]
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix TX channel offset when using legacy interrupts
    https://git.kernel.org/netdev/net/c/f232af429565

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


