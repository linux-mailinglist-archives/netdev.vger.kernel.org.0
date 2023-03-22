Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8A6C4183
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCVEUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCVEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AEA570BA;
        Tue, 21 Mar 2023 21:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 175BAB81B03;
        Wed, 22 Mar 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACBDCC4339C;
        Wed, 22 Mar 2023 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679458817;
        bh=F6vuGM7sSTkr5wsPWlMknYZ6DkrLPvUZjWjwffYmuXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ocwgyvzOPXntz6uc6g4ArcQwJl1wQJ8Ah3T9KkhAQ3rsGrFm9nRAtTvhwyqtELNYW
         9Nle4aLxaIVd5nrieOTn8jK8Mva8PHhS9ITxXWmR2poa4xXqz75qDMaifhfsMHJ+bI
         AfpDiXkw/KrHTnGxzMZYShk8iBZOynO70YlgQ/nev32ejkhh7Q3GddkDSLlIeUZ8K+
         Yo0kan3DmgLReyzzet1BJ0WuyyL6YkRE5fK7Y6zYA+en8CzW3IVnzTatD5m8QxJGiH
         UIaB6u2jiiyzhwq1iQ54Y0jj0DGbLtf8rM6CWRRQ7iAXKerH6ELu0vLKQ886IvexmT
         Sw6lOhDT2R6gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BEBCE66C8D;
        Wed, 22 Mar 2023 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] atm: idt77252: fix kmemleak when rmmod idt77252
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167945881756.16584.2824605929360811785.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 04:20:17 +0000
References: <20230320143318.2644630-1-lizetao1@huawei.com>
In-Reply-To: <20230320143318.2644630-1-lizetao1@huawei.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        romieu@fr.zoreil.com
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

On Mon, 20 Mar 2023 14:33:18 +0000 you wrote:
> There are memory leaks reported by kmemleak:
> 
>   unreferenced object 0xffff888106500800 (size 128):
>     comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
>     hex dump (first 32 bytes):
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
>       [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
>       [<000000000e947e2a>] idt77252_init_one+0x2847/0x3c90 [idt77252]
>       [<000000006efb048e>] local_pci_probe+0xeb/0x1a0
>     ...
> 
> [...]

Here is the summary with links:
  - [v2] atm: idt77252: fix kmemleak when rmmod idt77252
    https://git.kernel.org/netdev/net/c/4fe3c88552a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


