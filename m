Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE03AA495
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhFPTwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhFPTwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2C8F61351;
        Wed, 16 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873004;
        bh=kuEA/+ER84jE0UKU4LppXGc2qArbUble506oDWAm+Iw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lTa9bKzV6c+3XHwwA6ML87/1h4wCI41vjnfwnyXDr7+UAaobx4kwXdW+HFAVeU/Bg
         4ckCqdbcTB6+ClIvwjB4yUMpIaQOEqhhxAstyzWUgKRcKZpELKAI/GCdDABVix37qY
         5vGrrmK7GMDyZCmLX1ckKz68tqEeio0FDDIimw6fyYNDiU3RbIgk0Hletk51ja0rkJ
         gJ9dMByiOcbfA2DkqBqcTgwUEr4GhI9JaBMAdLBmyM7OzqNM+t7GUqcqT9xpxPX9rY
         RtL27KIJWZHudWBvMQWFxK9zlhZfnxBWyXBiqT/WMfYXhgj3p3D41RJYH8HfdG+liY
         24wI2fPP7V1jQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D950C609D8;
        Wed, 16 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv4: fix memory leak in ip_mc_add1_src
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387300488.13042.4367542088797700653.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:50:04 +0000
References: <20210616095925.1571600-1-cy.fan@huawei.com>
In-Reply-To: <20210616095925.1571600-1-cy.fan@huawei.com>
To:     Chengyang Fan <cy.fan@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, liuhangbin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 17:59:25 +0800 you wrote:
> BUG: memory leak
> unreferenced object 0xffff888101bc4c00 (size 32):
>   comm "syz-executor527", pid 360, jiffies 4294807421 (age 19.329s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>     01 00 00 00 00 00 00 00 ac 14 14 bb 00 00 02 00 ................
>   backtrace:
>     [<00000000f17c5244>] kmalloc include/linux/slab.h:558 [inline]
>     [<00000000f17c5244>] kzalloc include/linux/slab.h:688 [inline]
>     [<00000000f17c5244>] ip_mc_add1_src net/ipv4/igmp.c:1971 [inline]
>     [<00000000f17c5244>] ip_mc_add_src+0x95f/0xdb0 net/ipv4/igmp.c:2095
>     [<000000001cb99709>] ip_mc_source+0x84c/0xea0 net/ipv4/igmp.c:2416
>     [<0000000052cf19ed>] do_ip_setsockopt net/ipv4/ip_sockglue.c:1294 [inline]
>     [<0000000052cf19ed>] ip_setsockopt+0x114b/0x30c0 net/ipv4/ip_sockglue.c:1423
>     [<00000000477edfbc>] raw_setsockopt+0x13d/0x170 net/ipv4/raw.c:857
>     [<00000000e75ca9bb>] __sys_setsockopt+0x158/0x270 net/socket.c:2117
>     [<00000000bdb993a8>] __do_sys_setsockopt net/socket.c:2128 [inline]
>     [<00000000bdb993a8>] __se_sys_setsockopt net/socket.c:2125 [inline]
>     [<00000000bdb993a8>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2125
>     [<000000006a1ffdbd>] do_syscall_64+0x40/0x80 arch/x86/entry/common.c:47
>     [<00000000b11467c4>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - net: ipv4: fix memory leak in ip_mc_add1_src
    https://git.kernel.org/netdev/net/c/d8e2973029b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


