Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB916BD71E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCPRaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCPRax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:30:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9331ACA1F0;
        Thu, 16 Mar 2023 10:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92EDCCE1E1C;
        Thu, 16 Mar 2023 17:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD5F8C433D2;
        Thu, 16 Mar 2023 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678987820;
        bh=rFOBIEh1pPzhvRn5Gb5UlmOzo4rc1g3fvU1dUCn/28k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=exgkn63BgIJ4+Cgh5LxbgQ95J2yMVgUhyMeAlDPcwj8d3e1QKwECqOm/0szJg3FNF
         MPUQ2M2T1CQNWJpSsUZpInNJKUondL5leR1XZtBucCGgUBNcIShy22LxToWtNUuPUf
         LcmCHkpPaSVfCOa2L30CXtcOnZS9TyL621Afnc0lDfaq7HTek0u2OA6J6sxzN6gCAk
         HvsrLcp44qgBzZntBez6TqMlrNhY492CrkL5dZ1A//8TOi22nbh9ZB3QRx/7QO1wFp
         i1SMUXeC5yiCX59Q44x/o5t8WZz+KBlcB1hW0ZDJPBay7fNOcHSYJB06mq/UXS8JMS
         1sPwlf1xxzYvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A896AE29F32;
        Thu, 16 Mar 2023 17:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net v4 0/4] several updates to virtio/vsock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898782068.22462.15920934490206565808.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:30:20 +0000
References: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
In-Reply-To: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 14:03:23 +0300 you wrote:
> Hello,
> 
> this patchset evolved from previous v2 version (see link below). It does
> several updates to virtio/vsock:
> 1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>    using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>    and 'rx_bytes', integer value is passed as an input argument. This
>    makes code more simple, because in this case we don't need to update
>    skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>    more common words - we don't need to change skbuff state to update
>    'rx_bytes' and 'fwd_cnt' correctly.
> 2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>    not dropped. Next read attempt will use same skbuff and last offset.
>    Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>    This behaviour was implemented before skbuff support.
> 3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>    this type of socket each skbuff is used only once: after removing it
>    from socket's queue, it will be freed anyway.
> 
> [...]

Here is the summary with links:
  - [RESEND,net,v4,1/4] virtio/vsock: don't use skbuff state to account credit
    https://git.kernel.org/netdev/net/c/077706165717
  - [RESEND,net,v4,2/4] virtio/vsock: remove redundant 'skb_pull()' call
    https://git.kernel.org/netdev/net/c/6825e6b4f8e5
  - [RESEND,net,v4,3/4] virtio/vsock: don't drop skbuff on copy failure
    https://git.kernel.org/netdev/net/c/8daaf39f7f6e
  - [RESEND,net,v4,4/4] test/vsock: copy to user failure test
    https://git.kernel.org/netdev/net/c/7e699d2a4e81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


