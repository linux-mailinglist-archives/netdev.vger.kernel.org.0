Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF964DAC4
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 13:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLOMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 07:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiLOMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 07:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125042A95F;
        Thu, 15 Dec 2022 04:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9157B81B8C;
        Thu, 15 Dec 2022 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DC5EC433F0;
        Thu, 15 Dec 2022 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671105617;
        bh=M6vpEoJ3FxMMmItoiz8CY4zrJ7rPXsaS/7JyHG557AY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XHGQg6LRhdDm4v9tycx6M0xqkVTkXXIezvTW4RV5JQQw1+uLAh+cGUDnDJ0C7fjGs
         q0hEBFsgVk9eZSAtd3twoQobz9BZeMmhD5YcjfPIl04NHPqLcNevhycNkSDQd5cxnR
         dAR+J9MB/9ANHU/M0lZLjASl0rLaVRI58HVWu8NFoceDWj5iUsdVYZBcYxtZj4jbR5
         +mD+IPdVwP6Daou9CjIO0xsbvCjhgqvuhVoimnf6TXFnf5h1iHqU7L4lgEotuH6uiA
         WNRDn16QkdWfn1R+roq/3K1v+wxg6XbQ9DmIl/oZ8wQSyO6QVm8ddWvC28enfY+/T1
         1xkvHxBlq72Fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 208EBE4D00F;
        Thu, 15 Dec 2022 12:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] r6040: Fix kmemleak in probe and remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167110561712.17327.3063641334105199044.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 12:00:17 +0000
References: <20221213125614.927754-1-lizetao1@huawei.com>
In-Reply-To: <20221213125614.927754-1-lizetao1@huawei.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     weiyongjun1@huawei.com, davem@davemloft.net, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 13 Dec 2022 20:56:14 +0800 you wrote:
> There is a memory leaks reported by kmemleak:
> 
>   unreferenced object 0xffff888116111000 (size 2048):
>     comm "modprobe", pid 817, jiffies 4294759745 (age 76.502s)
>     hex dump (first 32 bytes):
>       00 c4 0a 04 81 88 ff ff 08 10 11 16 81 88 ff ff  ................
>       08 10 11 16 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
>       [<ffffffff827e20ee>] phy_device_create+0x4e/0x90
>       [<ffffffff827e6072>] get_phy_device+0xd2/0x220
>       [<ffffffff827e7844>] mdiobus_scan+0xa4/0x2e0
>       [<ffffffff827e8be2>] __mdiobus_register+0x482/0x8b0
>       [<ffffffffa01f5d24>] r6040_init_one+0x714/0xd2c [r6040]
>       ...
> 
> [...]

Here is the summary with links:
  - [net,v2] r6040: Fix kmemleak in probe and remove
    https://git.kernel.org/netdev/net/c/7e43039a49c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


