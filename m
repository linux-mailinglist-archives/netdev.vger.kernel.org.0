Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F14D649B70
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiLLJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiLLJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFEBA195;
        Mon, 12 Dec 2022 01:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09252B80BA4;
        Mon, 12 Dec 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD6C3C433F1;
        Mon, 12 Dec 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670838614;
        bh=KnsL4KWSHtWzanbpgeKsKtos90grrMjVEnvc3TFDe6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sh6VbmrEFHrscHu/5kbMWudzQAokWDjW6dRNvQiUb8Z+smEKY7lHmDvLaW1E5HsPK
         Vf4b9uCtCsnDtWEyEVgQU0KET8SiGuaIkNI9O/gDL3DumjF5zcabRKBV6oZc9Irgcz
         6lKHGWod6/imPY1y+yFbxEs2dV52TriJr6YYjID7V8pqypn6/KoiQr3mTE091QN6MD
         WADPXm3qMpVKyh0l+nTnLEQjJ3iABv9CPf2fH3U+6mGIxK8uKShFwmEjpaWseF+yAr
         tMuiQfiWW3k75G6ERWJWAZ2rR/DhUt9u/j5B70oqlu2O6Xwh6eK30oE99vbjynIUWg
         KRw7NcdD1Eo0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A35A1C41612;
        Mon, 12 Dec 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: farsync: Fix kmemleak when rmmods farsync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083861466.6188.11052191900852417459.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 09:50:14 +0000
References: <20221208120540.3758720-1-lizetao1@huawei.com>
In-Reply-To: <20221208120540.3758720-1-lizetao1@huawei.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     kevin.curtis@farsite.co.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 20:05:40 +0800 you wrote:
> There are two memory leaks reported by kmemleak:
> 
>   unreferenced object 0xffff888114b20200 (size 128):
>     comm "modprobe", pid 4846, jiffies 4295146524 (age 401.345s)
>     hex dump (first 32 bytes):
>       e0 62 57 09 81 88 ff ff e0 62 57 09 81 88 ff ff  .bW......bW.....
>       01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
>       [<ffffffff83d35c78>] __hw_addr_add_ex+0x198/0x6c0
>       [<ffffffff83d3989d>] dev_addr_init+0x13d/0x230
>       [<ffffffff83d1063d>] alloc_netdev_mqs+0x10d/0xe50
>       [<ffffffff82b4a06e>] alloc_hdlcdev+0x2e/0x80
>       [<ffffffffa016a741>] fst_add_one+0x601/0x10e0 [farsync]
>       ...
> 
> [...]

Here is the summary with links:
  - net: farsync: Fix kmemleak when rmmods farsync
    https://git.kernel.org/netdev/net/c/2f623aaf9f31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


