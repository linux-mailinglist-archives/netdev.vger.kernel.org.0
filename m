Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558762CB3D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiKPUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiKPUkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2167140922
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6EAFB81D85
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 435C5C433D6;
        Wed, 16 Nov 2022 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668631221;
        bh=6kuTtlEYWsFvEuamRg47m89ENW8349ouW2H94ZDAe30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fDENrTfo5GWXzG+NE6NIxjEq8ZEaXM6+qtOlWcH544JOinC0Cc9Zw5biRzIcJGruf
         Re/4qzFeSNUwYvrK5Gn7B/93VqRs1b9fICs3/FhKtFWUX/GBZ4Tdvi6pFc99XTfEEs
         YZvS3MwSPSYtMD6bb4WVJgn2v8m3HN1LVzHqi4jxYiYIlyvktuEWbPJ9+GvlQC354j
         w1WHCGkK70kBPNJW4OK+oF08ushxqT8Hq72c13KofYYM932ZryOkbAgWGLnncqIY/P
         Va1CfxwFH+9e2d4fs1eNPYw2S6IjROJbK0RPN792qHSfbHjJvLFtqIB8cVUaBJQcZX
         1GqtuzHNIL9fQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23771E270D5;
        Wed, 16 Nov 2022 20:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] netdevsim: Fix memory leak of nsim_dev->fa_cookie
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166863122113.12042.15149520651135830878.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 20:40:21 +0000
References: <1668504625-14698-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1668504625-14698-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jiri@mellanox.com
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

On Tue, 15 Nov 2022 17:30:25 +0800 you wrote:
> kmemleak reports this issue:
> 
> unreferenced object 0xffff8881bac872d0 (size 8):
>   comm "sh", pid 58603, jiffies 4481524462 (age 68.065s)
>   hex dump (first 8 bytes):
>     04 00 00 00 de ad be ef                          ........
>   backtrace:
>     [<00000000c80b8577>] __kmalloc+0x49/0x150
>     [<000000005292b8c6>] nsim_dev_trap_fa_cookie_write+0xc1/0x210 [netdevsim]
>     [<0000000093d78e77>] full_proxy_write+0xf3/0x180
>     [<000000005a662c16>] vfs_write+0x1c5/0xaf0
>     [<000000007aabf84a>] ksys_write+0xed/0x1c0
>     [<000000005f1d2e47>] do_syscall_64+0x3b/0x90
>     [<000000006001c6ec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net,v2] netdevsim: Fix memory leak of nsim_dev->fa_cookie
    https://git.kernel.org/netdev/net/c/064bc7312bd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


