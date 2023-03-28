Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26166CBC23
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 12:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjC1KKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 06:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjC1KKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 06:10:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE98819A3;
        Tue, 28 Mar 2023 03:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5BF66162F;
        Tue, 28 Mar 2023 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35F2AC433D2;
        Tue, 28 Mar 2023 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679998219;
        bh=zSDBSOhDjfN/K7WH4y7LW1rJDe/pE9vrURd3pMLRMtg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uF3I6wSbd+4EcVywrze49L/ypnknPj+2mn4fvIJYM31sXYROxe1CrlAq8swF2dY7Q
         K1nfQLkEKzpMGEL6NLaPPCuXKweozonFzHJuLN2D/lCyFKbbqJN0Iv8vwyF4ibP/Rz
         OTDCJMjraYhVCc/zFnt1zOqo0JERK8VZ2XMvSGEYicWuLHVNlyH8mR2oyQea85b/03
         85PPbctHrrIF5+3UnQbZ5KhziHt92tXWtxatPHlEdnTzMalvW7bAHFG3oahoDOm8x1
         gGO1lNKTVVHRYWeRFZjOQCGYYYSdnuyVbMC5+4lqx8JvvV/lzLfkChtbtSN7L8J1k3
         kWAp4psmYXTLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B432E4D01A;
        Tue, 28 Mar 2023 10:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/2] allocate multiple skbuffs on tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167999821910.6518.13997608603920855143.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 10:10:19 +0000
References: <b0d15942-65ba-3a32-ba8d-fed64332d8f6@sberdevices.ru>
In-Reply-To: <b0d15942-65ba-3a32-ba8d-fed64332d8f6@sberdevices.ru>
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

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 26 Mar 2023 01:02:43 +0300 you wrote:
> This adds small optimization for tx path: instead of allocating single
> skbuff on every call to transport, allocate multiple skbuff's until
> credit space allows, thus trying to send as much as possible data without
> return to af_vsock.c.
> 
> Also this patchset includes second patch which adds check and return from
> 'virtio_transport_get_credit()' and 'virtio_transport_put_credit()' when
> these functions are called with 0 argument. This is needed, because zero
> argument makes both functions to behave as no-effect, but both of them
> always tries to acquire spinlock. Moreover, first patch always calls
> function 'virtio_transport_put_credit()' with zero argument in case of
> successful packet transmission.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/2] virtio/vsock: allocate multiple skbuffs on tx
    https://git.kernel.org/netdev/net-next/c/b68ffb1b3bee
  - [net-next,v5,2/2] virtio/vsock: check argument to avoid no effect call
    https://git.kernel.org/netdev/net-next/c/e3ec366eb0d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


