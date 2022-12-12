Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B42649B8D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiLLKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiLLKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BB3DE9E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2045A60F7D
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72405C433F1;
        Mon, 12 Dec 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839215;
        bh=+nURirQBeLNorHFzLMDqstH780TcVvtJ0H+Pu1WgkXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kBmRaxYHwscHAfXTPHLYqX9ErSjdKYdp8awawXOoOOImK2bphCfhJxUAfpWYAZVjh
         c0or1n88+izBkZ++tFvkqq6GbtlwUaA4rHO1qmWaR/EfxONNBLRprSU8uhbbXyJHhj
         XFxsdNYXqGYQPyQvWYRLTStemvCnDlDOP+5MDi0c/aYCseEb8MsD7IZGbqipbbsm5k
         6mO6uDOE8Mra9rfW7ThpR66O85icjWH/Ic1BLHW6e322YlIEm3CeRzfha6Qh502kqu
         1ITeSZWQU6Umao92MWLSJxM6vIbcJy5LZW5g5S0BFaNwT16Jd5SAgVJPR0wCzxqnTS
         4zIQQPQg17P/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5266EE21EF1;
        Mon, 12 Dec 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tunnel: wait until all sk_user_data reader finish
 before releasing the sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083921533.10817.12351306583540223600.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:00:15 +0000
References: <20221208120452.556997-1-liuhangbin@gmail.com>
In-Reply-To: <20221208120452.556997-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        u9012063@gmail.com, azhou@nicira.com, roopa@nvidia.com,
        jishi@redhat.com, jakub@cloudflare.com
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

On Thu,  8 Dec 2022 20:04:52 +0800 you wrote:
> There is a race condition in vxlan that when deleting a vxlan device
> during receiving packets, there is a possibility that the sock is
> released after getting vxlan_sock vs from sk_user_data. Then in
> later vxlan_ecn_decapsulate(), vxlan_get_sk_family() we will got
> NULL pointer dereference. e.g.
> 
>    #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
>    #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
>    #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
>    #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
>    #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
>    #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
>    #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
>       [exception RIP: vxlan_ecn_decapsulate+0x3b]
>       RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
>       RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
>       RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
>       RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
>       R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
>       R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
>       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>    #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
>    #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
>    #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
>   #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
>   #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
>   #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
>   #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
>   #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
>   #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
>   #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
>   #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
>   #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3
> 
> [...]

Here is the summary with links:
  - [net] net/tunnel: wait until all sk_user_data reader finish before releasing the sock
    https://git.kernel.org/netdev/net/c/3cf7203ca620

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


