Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4526DB88F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDHDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0D1BEA;
        Fri,  7 Apr 2023 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D83064D4B;
        Sat,  8 Apr 2023 03:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90B9FC433D2;
        Sat,  8 Apr 2023 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680924017;
        bh=s6+/BzltS4eg674aI8cdbmK7B09+uVXtkxWgUQ7ZBtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YF6+I70trLdvxzvom3TPyCSs86ZMZ0JBbdm74+c14OXiQT6cKmq6vA/+HOKgwH6n1
         K6xPH7XoLIv7yRjaktHTwlvJDCQON/+UawNFmeKiOWchdFUoKxtuQWELj92LIb/4Wl
         iu+q2fNIHQL8OC2/xtVULLg7UiJxdwbjE6sBK0aUE6/9/LULbNMnb3ozxfPNYCwKfa
         3XzGhlMLgfZOzxMqAe0D4KpQh2Lf0MMnu3+o/gQqni7d5J2TOpGJlOdRkkUF/Ro2xs
         3u4ul6kV1ZbBxAPaTZIhObldjpesZ2pNBhwycP0b3STf18J7FnTkhq4hWOvcTCvypf
         aRVB4hh+Wmigw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7203DE21EF2;
        Sat,  8 Apr 2023 03:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] r8152: Add __GFP_NOWARN to big allocations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092401746.26294.3498569400410508226.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 03:20:17 +0000
References: <20230406171411.1.I84dbef45786af440fd269b71e9436a96a8e7a152@changeid>
In-Reply-To: <20230406171411.1.I84dbef45786af440fd269b71e9436a96a8e7a152@changeid>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, git@apitzsch.eu, bjorn@mork.no,
        dober6023@gmail.com, hayeswang@realtek.com, jflf_kernel@gmx.com,
        svenva@chromium.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 17:14:26 -0700 you wrote:
> When memory is a little tight on my system, it's pretty easy to see
> warnings that look like this.
> 
>   ksoftirqd/0: page allocation failure: order:3, mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
>   ...
>   Call trace:
>    dump_backtrace+0x0/0x1e8
>    show_stack+0x20/0x2c
>    dump_stack_lvl+0x60/0x78
>    dump_stack+0x18/0x38
>    warn_alloc+0x104/0x174
>    __alloc_pages+0x588/0x67c
>    alloc_rx_agg+0xa0/0x190 [r8152 ...]
>    r8152_poll+0x270/0x760 [r8152 ...]
>    __napi_poll+0x44/0x1ec
>    net_rx_action+0x100/0x300
>    __do_softirq+0xec/0x38c
>    run_ksoftirqd+0x38/0xec
>    smpboot_thread_fn+0xb8/0x248
>    kthread+0x134/0x154
>    ret_from_fork+0x10/0x20
> 
> [...]

Here is the summary with links:
  - r8152: Add __GFP_NOWARN to big allocations
    https://git.kernel.org/netdev/net/c/5cc33f139e11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


