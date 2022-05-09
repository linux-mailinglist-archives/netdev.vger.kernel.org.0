Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2AA51F94F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiEIKJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiEIKJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534D92655E5;
        Mon,  9 May 2022 03:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA255B810B6;
        Mon,  9 May 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49070C385B0;
        Mon,  9 May 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652090412;
        bh=29mSpAua4b8hjk9GKvTkGUR9JajuXItC18hWIP0Js8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O11DO6mYOO600sMRMllIbjLkarWSnk5FMiBm79/PWIWaAuiYSyCCavJbhm0hg+KzO
         DQhvNtMZW5ILPkNUbD5QfiTkLpLy2r8rN0C4RFyBUFqWqEyq0PHK/vo4GSiPM9XEIO
         4ftwcJxqiiW+g9c41Dk/7ixHMPjSBQ+V+3VYAvp/yAkWglySpqoylz3rCT7ifKJ5rR
         9jfF5PMeSRvJMI1TDFZyug/E5Oyzv3EXur/Pryk6tj+c9MaiGqWVnUMDvtCgduQBMS
         u/c0O76qUzl4o/VEiQ5Id0B0eKAcdigpVH/e0S5/6MdV5VVSjbqPFjPWauHcBka19r
         eYmpP52r2ieow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30B4DE85D8A;
        Mon,  9 May 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 1/2] net: fix wrong network header length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165209041219.866.7810964831911496184.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 10:00:12 +0000
References: <20220505054850.4878-1-lina.wang@mediatek.com>
In-Reply-To: <20220505054850.4878-1-lina.wang@mediatek.com>
To:     Lina Wang <lina.wang@mediatek.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, matthias.bgg@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, edumazet@google.com,
        willemb@google.com, maze@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, llvm@lists.linux.dev
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 5 May 2022 13:48:49 +0800 you wrote:
> When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
> several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
> ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> network_header\transport_header\mac_header have been updated as ipv4 acts,
> but other skbs in frag_list didnot update anything, just ipv6 packets.
> 
> udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
> frag_list and make sure right udp payload is delivered to user space.
> Unfortunately, other skbs in frag_list who are still ipv6 packets are
> updated like the first skb and will have wrong transport header length.
> 
> [...]

Here is the summary with links:
  - [v6,1/2] net: fix wrong network header length
    https://git.kernel.org/netdev/net/c/cf3ab8d4a797
  - [v6,2/2] selftests net: add UDP GRO fraglist + bpf self-tests
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


