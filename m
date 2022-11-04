Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69226194FE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiKDLAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiKDLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:00:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D58D20F50;
        Fri,  4 Nov 2022 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93248CE2BA9;
        Fri,  4 Nov 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E41B3C43470;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559617;
        bh=nFblqHRepnbgnMP/bfhjFkuaedd0Cm2zjzCq6sFY8WM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A0GC/c8V3Qi5fopYUf8unh5wI75tUIO7/oZfWo5wlJZRa+NBgj9O97B0xwYeh17vQ
         JlcksBbeiTuRfGgNd8gSMLZNjRWx4zaoVIad5KKwK837V1qPOHQc9hVwCKTiI2TlTA
         tZ+jZGBHzZlMWEVzpCNhMQw+GC3YkKLXxTczozZHYZX/7xlMzkHqG0x0MRp+6E3aEh
         sskFkJbhuLY9/pYraC4TP4sR9RtZdXIrAcGdvKRoIhIq98dOLh5KHS4sIieuWSB1u8
         UE1kBpMSUO1VzFWzTWHm9XLJQAsf4Q1ZuSj1B1fSRaZc2cBPMhkxR6ERw/w95ZuPOS
         svlEpbdqRhG2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4895E52509;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: tun: Fix memory leaks of napi_get_frags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755961680.11617.8800451482056670890.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 11:00:16 +0000
References: <1667382079-6499-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1667382079-6499-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        peterpenkov96@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 2 Nov 2022 17:41:19 +0800 you wrote:
> kmemleak reports after running test_progs:
> 
> unreferenced object 0xffff8881b1672dc0 (size 232):
>   comm "test_progs", pid 394388, jiffies 4354712116 (age 841.975s)
>   hex dump (first 32 bytes):
>     e0 84 d7 a8 81 88 ff ff 80 2c 67 b1 81 88 ff ff  .........,g.....
>     00 40 c5 9b 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
>   backtrace:
>     [<00000000c8f01748>] napi_skb_cache_get+0xd4/0x150
>     [<0000000041c7fc09>] __napi_build_skb+0x15/0x50
>     [<00000000431c7079>] __napi_alloc_skb+0x26e/0x540
>     [<000000003ecfa30e>] napi_get_frags+0x59/0x140
>     [<0000000099b2199e>] tun_get_user+0x183d/0x3bb0 [tun]
>     [<000000008a5adef0>] tun_chr_write_iter+0xc0/0x1b1 [tun]
>     [<0000000049993ff4>] do_iter_readv_writev+0x19f/0x320
>     [<000000008f338ea2>] do_iter_write+0x135/0x630
>     [<000000008a3377a4>] vfs_writev+0x12e/0x440
>     [<00000000a6b5639a>] do_writev+0x104/0x280
>     [<00000000ccf065d8>] do_syscall_64+0x3b/0x90
>     [<00000000d776e329>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net,v2] net: tun: Fix memory leaks of napi_get_frags
    https://git.kernel.org/netdev/net/c/1118b2049d77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


