Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D61B51DFD3
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391986AbiEFTyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392131AbiEFTx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473B26A42F;
        Fri,  6 May 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E00B5B80E9E;
        Fri,  6 May 2022 19:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65DDCC385AC;
        Fri,  6 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651866612;
        bh=PYVzOsaqyIFnBW0vYPhJBYe8z0KWXMzyyEIw8eb7s3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j7e50OOPWY4QBsefK2HmKkaVW3t5lBTw0e4ErIx6d1vctqofZ/SdFXPSXpfjAVj9T
         0wNAyWw1ICesH1eQRYdKtGy/Lyp4bvK4SHyOl+CaVQZ8SBD8lhWwNsgDOfrLyRQsbq
         lv3qs3Zao0ygNzliLNbyKgSxDvkxLPCwvGiOLdpsS7ieSa1pK0zJJvZO2eL6NUruvK
         odDyWsYFZURFe3APoqhtmbFgNag8npt+scpL9TLe15+PmrSDrFmnpcl1ENmMLjefkU
         eJaPS9B5r2Q/dF8Xig93HajNlHgZ5h9z1gQv9+N2MAtyiXPGvBpyk7t154ICXceNNB
         pM2ZDftmBmIGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 495FFF03876;
        Fri,  6 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] ipv4: drop dst in multicast routing path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165186661229.28900.13083700844153444313.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 19:50:12 +0000
References: <20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tgraf@suug.ch, lokesh.dhoundiyal@alliedtelesis.co.nz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 May 2022 14:00:17 +1200 you wrote:
> From: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
> 
> kmemleak reports the following when routing multicast traffic over an
> ipsec tunnel.
> 
> Kmemleak output:
> unreferenced object 0x8000000044bebb00 (size 256):
>   comm "softirq", pid 0, jiffies 4294985356 (age 126.810s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 80 00 00 00 05 13 74 80  ..............t.
>     80 00 00 00 04 9b bf f9 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000f83947e0>] __kmalloc+0x1e8/0x300
>     [<00000000b7ed8dca>] metadata_dst_alloc+0x24/0x58
>     [<0000000081d32c20>] __ipgre_rcv+0x100/0x2b8
>     [<00000000824f6cf1>] gre_rcv+0x178/0x540
>     [<00000000ccd4e162>] gre_rcv+0x7c/0xd8
>     [<00000000c024b148>] ip_protocol_deliver_rcu+0x124/0x350
>     [<000000006a483377>] ip_local_deliver_finish+0x54/0x68
>     [<00000000d9271b3a>] ip_local_deliver+0x128/0x168
>     [<00000000bd4968ae>] xfrm_trans_reinject+0xb8/0xf8
>     [<0000000071672a19>] tasklet_action_common.isra.16+0xc4/0x1b0
>     [<0000000062e9c336>] __do_softirq+0x1fc/0x3e0
>     [<00000000013d7914>] irq_exit+0xc4/0xe0
>     [<00000000a4d73e90>] plat_irq_dispatch+0x7c/0x108
>     [<000000000751eb8e>] handle_int+0x16c/0x178
>     [<000000001668023b>] _raw_spin_unlock_irqrestore+0x1c/0x28
> 
> [...]

Here is the summary with links:
  - [net] ipv4: drop dst in multicast routing path
    https://git.kernel.org/netdev/net/c/9e6c6d17d1d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


