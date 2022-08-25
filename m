Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0E5A0762
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiHYCkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiHYCkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2AC6D9E0;
        Wed, 24 Aug 2022 19:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A522616F1;
        Thu, 25 Aug 2022 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98E68C433D7;
        Thu, 25 Aug 2022 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395217;
        bh=IE4hQFun8JSnxjm2Q0UcQgd/lLzYv5USvZ8/gig6nCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=luzOM+Bl2RG7GXGXdyAauxwLaR/ZRmimLBFtA1aC3e6nR246Sl3HvfTwA9TUDGzdH
         pp7Qx7tcpDUaLCzTBL+xn8qFZe6KfqJXzEDqNixer8U4KMgy89y3mOnSGS3DTVs4kJ
         wjM4fFZwimeHOVnSfvt085PHxHpYBOGS52kiU1gSVgC2pSUKXXtczB+O9JiU91pdlr
         7VMK4XVP7kCXlRwOfu0mQNHekh8CnpZcmZ7HfK4m2KPyYl1cP0IrsZvddlSrVujfKL
         bZ2r5jw1uOGaCCyzb4PkrCxM6f7VnyDbzAYZnL1URxF9ShUyziCbnLoNPxkH7hZoDp
         uWwEkmOvyHSfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79E97C0C3EC;
        Thu, 25 Aug 2022 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/14] netfilter: ebtables: reject blobs that don't
 provide all entry points
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139521749.434.10265986987169590728.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 02:40:17 +0000
References: <20220824220330.64283-2-pablo@netfilter.org>
In-Reply-To: <20220824220330.64283-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 25 Aug 2022 00:03:17 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Harshit Mogalapalli says:
>  In ebt_do_table() function dereferencing 'private->hook_entry[hook]'
>  can lead to NULL pointer dereference. [..] Kernel panic:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> [..]
> RIP: 0010:ebt_do_table+0x1dc/0x1ce0
> Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 5c 16 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 6c df 08 48 8d 7d 2c 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 88
> [..]
> Call Trace:
>  nf_hook_slow+0xb1/0x170
>  __br_forward+0x289/0x730
>  maybe_deliver+0x24b/0x380
>  br_flood+0xc6/0x390
>  br_dev_xmit+0xa2e/0x12c0
> 
> [...]

Here is the summary with links:
  - [net,01/14] netfilter: ebtables: reject blobs that don't provide all entry points
    https://git.kernel.org/netdev/net/c/7997eff82828
  - [net,02/14] netfilter: conntrack: work around exceeded receive window
    https://git.kernel.org/netdev/net/c/cf97769c761a
  - [net,03/14] netfilter: nft_tproxy: restrict to prerouting hook
    https://git.kernel.org/netdev/net/c/18bbc3213383
  - [net,04/14] netfilter: nf_tables: disallow updates of implicit chain
    https://git.kernel.org/netdev/net/c/5dc52d83baac
  - [net,05/14] netfilter: nf_tables: make table handle allocation per-netns friendly
    https://git.kernel.org/netdev/net/c/ab482c6b66a4
  - [net,06/14] netfilter: nft_payload: report ERANGE for too long offset and length
    https://git.kernel.org/netdev/net/c/94254f990c07
  - [net,07/14] netfilter: nft_payload: do not truncate csum_offset and csum_type
    https://git.kernel.org/netdev/net/c/7044ab281feb
  - [net,08/14] netfilter: nf_tables: do not leave chain stats enabled on error
    https://git.kernel.org/netdev/net/c/43eb8949cfdf
  - [net,09/14] netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
    https://git.kernel.org/netdev/net/c/5f3b7aae14a7
  - [net,10/14] netfilter: nft_tunnel: restrict it to netdev family
    https://git.kernel.org/netdev/net/c/01e4092d53bc
  - [net,11/14] netfilter: nf_tables: disallow binding to already bound chain
    https://git.kernel.org/netdev/net/c/e02f0d397040
  - [net,12/14] netfilter: flowtable: add function to invoke garbage collection immediately
    https://git.kernel.org/netdev/net/c/759eebbcfafc
  - [net,13/14] netfilter: flowtable: fix stuck flows on cleanup due to pending work
    https://git.kernel.org/netdev/net/c/9afb4b27349a
  - [net,14/14] netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases
    https://git.kernel.org/netdev/net/c/00cd7bf9f9e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


