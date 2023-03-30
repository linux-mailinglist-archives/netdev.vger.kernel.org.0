Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8747A6CFF71
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjC3JKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC3JKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4165AC;
        Thu, 30 Mar 2023 02:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9EE61F99;
        Thu, 30 Mar 2023 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0391C433EF;
        Thu, 30 Mar 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680167418;
        bh=ymeU3o8/9PtiSs8Vgt+JPAOcdnOCe8xU/f65yNA3Nr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VKBzjsXzDtCajcfNjW7LDQt0aXdN2NYsALF978kVb5EYiBE9Qxc06JgVk5MEYHYT6
         YxyMZleDD0aZC1OskKUKnVHdvoUj7dDluQ9wdRrY0xGc+E8q9FYD6p8XFKTDFfFXQ8
         DdBMWp3PZRmP8kjqukhrKd1eU3jHL4tKaLpz07xv6WpR4YIEQFbscoMr5pDODkaGD/
         r/WGfEsQ7zDLEnx+Ra27je39Xkazr6Jfw7TMaRKgrSys9x8b1YDBtE/0kWITACuYGG
         6SApGFSkjzP3I1awQHW1pYkHlm3co4Udy1NTDx8yCb3wRSqoijBzYZQBUzpMcFUc1j
         GglCdxJ/xeVpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF9F0E49FA7;
        Thu, 30 Mar 2023 09:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] fix header length on skb merging
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168016741871.21198.8299198857300036519.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 09:10:18 +0000
References: <0683cc6e-5130-484c-1105-ef2eb792d355@sberdevices.ru>
In-Reply-To: <0683cc6e-5130-484c-1105-ef2eb792d355@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 28 Mar 2023 14:30:10 +0300 you wrote:
> Hello,
> 
> this patchset fixes appending newly arrived skbuff to the last skbuff of
> the socket's queue during rx path. Problem fires when we are trying to
> append data to skbuff which was already processed in dequeue callback
> at least once. Dequeue callback calls function 'skb_pull()' which changes
> 'skb->len'. In current implementation 'skb->len' is used to update length
> in header of last skbuff after new data was copied to it. This is bug,
> because value in header is used to calculate 'rx_bytes'/'fwd_cnt' and
> thus must be constant during skbuff lifetime. Here is example, we have
> two skbuffs: skb0 with length 10 and skb1 with length 4.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] virtio/vsock: fix header length on skb merging
    https://git.kernel.org/netdev/net/c/f7154d967bc4
  - [net,v2,2/3] virtio/vsock: WARN_ONCE() for invalid state of socket
    https://git.kernel.org/netdev/net/c/b8d2f61fdf2a
  - [net,v2,3/3] test/vsock: new skbuff appending test
    https://git.kernel.org/netdev/net/c/25209a3209ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


