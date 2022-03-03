Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A44CB6DF
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiCCGU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiCCGU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:20:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DDC166E3E;
        Wed,  2 Mar 2022 22:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E67DC61874;
        Thu,  3 Mar 2022 06:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C9B9C340F0;
        Thu,  3 Mar 2022 06:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646288411;
        bh=vX5vbaikPiileJ6XCxRR8wC2/rB2/17rVCRkkZXIKbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I5HykwcBsuqO22vRlMc/9uFH6c6KUeLXLHK6HauHb789dDoFcSUKBfch/XKMBtECi
         IlCg1/RaWkjUHYTxNfstT0S1/qS8cZdCGcDTzfqq3DVfSeEIM+bzdMShsBq5ZJirOm
         ekz1WhscjoS5rlpiHgupYBr1vBwHvlsSV37vz1Gw6KSsj0TYsPfDrLZjjqrKm2rbta
         72iMxJvNRZAHwNW2THKEqX+uClBhKVjCavFVVamltNGmtAnb3PSQrzvfUMZU31vqq1
         ob/eFvZ0IH8S3yoUUyuVNfqHQbjFpxWdHGoiSWG9ZCw5lmBWWDKb8iC/VgrOJ/Xsgj
         bqIayr9gnyCgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C6CAEAC096;
        Thu,  3 Mar 2022 06:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: fix up skbs delta_truesize in UDP GRO frag_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628841116.5215.9483451947853237118.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:20:11 +0000
References: <1646133431-8948-1-git-send-email-lena.wang@mediatek.com>
In-Reply-To: <1646133431-8948-1-git-send-email-lena.wang@mediatek.com>
To:     lena wang <lena.wang@mediatek.com>
Cc:     pabeni@redhat.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, willemb@google.com,
        daniel@iogearbox.net, dseok.yi@samsung.com,
        wsd_upstream@mediatek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 1 Mar 2022 19:17:09 +0800 you wrote:
> The truesize for a UDP GRO packet is added by main skb and skbs in main
> skb's frag_list:
> skb_gro_receive_list
>         p->truesize += skb->truesize;
> 
> The commit 53475c5dd856 ("net: fix use-after-free when UDP GRO with
> shared fraglist") introduced a truesize increase for frag_list skbs.
> When uncloning skb, it will call pskb_expand_head and trusesize for
> frag_list skbs may increase. This can occur when allocators uses
> __netdev_alloc_skb and not jump into __alloc_skb. This flow does not
> use ksize(len) to calculate truesize while pskb_expand_head uses.
> skb_segment_list
> err = skb_unclone(nskb, GFP_ATOMIC);
> pskb_expand_head
>         if (!skb->sk || skb->destructor == sock_edemux)
>                 skb->truesize += size - osize;
> 
> [...]

Here is the summary with links:
  - [net,v2] net: fix up skbs delta_truesize in UDP GRO frag_list
    https://git.kernel.org/netdev/net/c/224102de2ff1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


