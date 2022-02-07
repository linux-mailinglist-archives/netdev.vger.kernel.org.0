Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591954ABF46
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447864AbiBGNCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387650AbiBGLl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 06:41:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B167C03E93D;
        Mon,  7 Feb 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF4160DBF;
        Mon,  7 Feb 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B98DAC340F0;
        Mon,  7 Feb 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644234010;
        bh=LurCH/FgOiyF5tRrbMdN+klo1M8jNPBO4OqOYHEWz0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mYdEQ5TF4K7TDhfDM0t+ipH+GXJwozzx0b4HKEOm8Z/3jLqExCl+JPAeTL4j2PQRk
         x8saaTkchxeQDBGwtUh65hlYDWvYkhYAhj+PHdVZNzRIaY+15cLzK3Asv6p5uIGiRG
         mY9zSav585jh+RV2u+Hijtn5/2UREuxXG3DwS8StLuBQHEo7XhWA411IJiiAUJPYml
         +cRQimmc5+FIAmTJaNlQTEx7hcdDlTuL49rn8Dn0/cEaPjTwEnQK6JUPZFAhRWWCru
         E6xFayawpyctWduU1zQtfo5m3xqOY2+S5beS8Bj3VrQJj6CWW4VToyVD7chq/vduE9
         t/WTmeyG25Y2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E069E6BB3D;
        Mon,  7 Feb 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/7] net: use kfree_skb_reason() for ip/udp packet
 receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423401064.10014.14060566984987490532.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 11:40:10 +0000
References: <20220205074739.543606-1-imagedong@tencent.com>
In-Reply-To: <20220205074739.543606-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, kuba@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 15:47:32 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In this series patches, kfree_skb() is replaced with kfree_skb_reason()
> during ipv4 and udp4 packet receiving path, and following drop reasons
> are introduced:
> 
> SKB_DROP_REASON_SOCKET_FILTER
> SKB_DROP_REASON_NETFILTER_DROP
> SKB_DROP_REASON_OTHERHOST
> SKB_DROP_REASON_IP_CSUM
> SKB_DROP_REASON_IP_INHDR
> SKB_DROP_REASON_IP_RPFILTER
> SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
> SKB_DROP_REASON_XFRM_POLICY
> SKB_DROP_REASON_IP_NOPROTO
> SKB_DROP_REASON_SOCKET_RCVBUFF
> SKB_DROP_REASON_PROTO_MEM
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/7] net: skb_drop_reason: add document for drop reasons
    https://git.kernel.org/netdev/net-next/c/88590b369354
  - [v4,net-next,2/7] net: netfilter: use kfree_drop_reason() for NF_DROP
    https://git.kernel.org/netdev/net-next/c/2df3041ba3be
  - [v4,net-next,3/7] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
    https://git.kernel.org/netdev/net-next/c/33cba42985c8
  - [v4,net-next,4/7] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
    https://git.kernel.org/netdev/net-next/c/c1f166d1f7ee
  - [v4,net-next,5/7] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
    https://git.kernel.org/netdev/net-next/c/10580c479190
  - [v4,net-next,6/7] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
    https://git.kernel.org/netdev/net-next/c/1379a92d38e3
  - [v4,net-next,7/7] net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
    https://git.kernel.org/netdev/net-next/c/08d4c0370c40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


