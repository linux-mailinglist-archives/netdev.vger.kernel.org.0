Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17C60FFB9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiJ0SBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiJ0SBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0D697EDA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7323623FE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEEFEC433C1;
        Thu, 27 Oct 2022 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666893619;
        bh=0WBilGnLlMmX984s3wZ44VB3v2HjKAzKt3sbnH2L2zE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gNO9XJjazASg1dYZ8IrpFi+qOcCr+NNLpoNhSYFu5DlmMJz+JF1a2OkQWiU77ly8i
         jhLoH5HK/+6p+kpwqsLpW/OeSkuNKlJhCdw0qy6Yc6ZWhi8sXtSYFrI6+WWLrtKrA4
         osOMH695oyrRUqqPKQ29Uv3gMR3wIKbQPIg8+tlMnWt6KU7EvJbFtInfELyY9yAR1b
         2zO6wcGHSTfkRiJ62CG8Ql2NdZ5Y4ZME82Kg09eKQ/2e4f8aR5Fjd+cXrsYytqROaP
         8zNm42iAKcXiQenVSD26jjv+EhWagGqGoXj9srpW2MhHeOkeugL5Rbff69FbyfkGC1
         GOnR5rdKPwUlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3FA9E270D9;
        Thu, 27 Oct 2022 18:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netdevsim: fix memory leak in nsim_bus_dev_new()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689361886.21530.15766841922004344115.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:00:18 +0000
References: <20221026015405.128795-1-shaozhengchao@huawei.com>
In-Reply-To: <20221026015405.128795-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jiri@mellanox.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Oct 2022 09:54:05 +0800 you wrote:
> If device_register() failed in nsim_bus_dev_new(), the value of reference
> in nsim_bus_dev->dev is 1. obj->name in nsim_bus_dev->dev will not be
> released.
> 
> unreferenced object 0xffff88810352c480 (size 16):
>   comm "echo", pid 5691, jiffies 4294945921 (age 133.270s)
>   hex dump (first 16 bytes):
>     6e 65 74 64 65 76 73 69 6d 31 00 00 00 00 00 00  netdevsim1......
>   backtrace:
>     [<000000005e2e5e26>] __kmalloc_node_track_caller+0x3a/0xb0
>     [<0000000094ca4fc8>] kvasprintf+0xc3/0x160
>     [<00000000aad09bcc>] kvasprintf_const+0x55/0x180
>     [<000000009bac868d>] kobject_set_name_vargs+0x56/0x150
>     [<000000007c1a5d70>] dev_set_name+0xbb/0xf0
>     [<00000000ad0d126b>] device_add+0x1f8/0x1cb0
>     [<00000000c222ae24>] new_device_store+0x3b6/0x5e0
>     [<0000000043593421>] bus_attr_store+0x72/0xa0
>     [<00000000cbb1833a>] sysfs_kf_write+0x106/0x160
>     [<00000000d0dedb8a>] kernfs_fop_write_iter+0x3a8/0x5a0
>     [<00000000770b66e2>] vfs_write+0x8f0/0xc80
>     [<0000000078bb39be>] ksys_write+0x106/0x210
>     [<00000000005e55a4>] do_syscall_64+0x35/0x80
>     [<00000000eaa40bbc>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> [...]

Here is the summary with links:
  - [net] netdevsim: fix memory leak in nsim_bus_dev_new()
    https://git.kernel.org/netdev/net/c/cf2010aa1c73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


