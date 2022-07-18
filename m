Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B92C578025
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiGRKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169EF1EC60
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5B02B81123
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6567BC341CE;
        Mon, 18 Jul 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658141413;
        bh=d5CGhdAZmG9xZNcJ+jN+xu4JouHOoCaRGoqLMug8DJE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T4/hm1/jZuBzdXS4fv0Y86xGcc4kjhcbdqKOQi+hmDMXIde5eSrfkgK8z2wEPR4NF
         ifHg+7nnqC0nChYANYj5bBu5bh/l55dXSwH9na+A91p0cPZjQ7fXdIi4yrz7SfBp5u
         X0AYRQFO+dsCPcNt1ISAraMGCqVnd3ZnOULFDvJakGUW+TAyGKQim4YisdIRvNi+VU
         BJIqaVtt0lhcPRmnMs12RZG2IeLQHU3jLOAm9DEz0PB4/yR0aowLhQI6lMz2iR18oG
         1ptJ/4xjrnN+FkKKUC6etQxBtd12Nz0bLZg80Dp8CWFZGy0tz+kyftL2KdjEQ9FAUs
         sUhDPpTI1Upow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BD88E451AF;
        Mon, 18 Jul 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tls: Fix race in TLS device down flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814141330.26482.840632241080820266.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:50:13 +0000
References: <20220715084216.4778-1-tariqt@nvidia.com>
In-Reply-To: <20220715084216.4778-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com,
        maximmi@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Jul 2022 11:42:16 +0300 you wrote:
> Socket destruction flow and tls_device_down function sync against each
> other using tls_device_lock and the context refcount, to guarantee the
> device resources are freed via tls_dev_del() by the end of
> tls_device_down.
> 
> In the following unfortunate flow, this won't happen:
> - refcount is decreased to zero in tls_device_sk_destruct.
> - tls_device_down starts, skips the context as refcount is zero, going
>   all the way until it flushes the gc work, and returns without freeing
>   the device resources.
> - only then, tls_device_queue_ctx_destruction is called, queues the gc
>   work and frees the context's device resources.
> 
> [...]

Here is the summary with links:
  - [net] net/tls: Fix race in TLS device down flow
    https://git.kernel.org/netdev/net/c/f08d8c1bb97c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


