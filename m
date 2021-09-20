Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B5F411156
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 10:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhITIvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 04:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhITIvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 04:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C53C60E9C;
        Mon, 20 Sep 2021 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632127807;
        bh=PMAu1SOCeXgbCyPAs6Jl9+PJeHOyDhaKXgIITm59uEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOWTy5cYwraiIIxiVVvmiTp0s5b4DeEt4tAkV5IqntRLjCuRhG6Ke7mNzIRvxgwAo
         kioXLRzXjV4JRurclAXW7u1Q2huHlHtaCBmTN4SLyGhv9XwhfKttLuCtLxkreX+7mX
         1GnkO7BRnQaMLftgGA7INGe+uQtPrdLD44/MPm2A09ACXctJ0li/3cS+lzXBg5st9j
         M8j9R7mBKhSQzvxfDl+3Ztu4cP+ZpueuTZJ9UP1ppjR5iiic3BjxhG3pX9D6XJn5/h
         Za5ZMCIf/vCnPis3k3IxrS2q4SLcOIwWEvL7mDI7YAHSAxt1DosxhOfGWdp1keO6G3
         BbuESYPda033g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57E7460A3A;
        Mon, 20 Sep 2021 08:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163212780735.18640.4066785038039010628.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 08:50:07 +0000
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com, bjorn@kernel.org,
        arnd@arndb.de, memxor@gmail.com, nhorman@redhat.com,
        dust.li@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 18 Sep 2021 16:52:32 +0800 you wrote:
> The process will cause napi.state to contain NAPI_STATE_SCHED and
> not in the poll_list, which will cause napi_disable() to get stuck.
> 
> The prefix "NAPI_STATE_" is removed in the figure below, and
> NAPI_STATE_HASHED is ignored in napi.state.
> 
>                       CPU0       |                   CPU1       | napi.state
> ===============================================================================
> napi_disable()                   |                              | SCHED | NPSVC
> napi_enable()                    |                              |
> {                                |                              |
>     smp_mb__before_atomic();     |                              |
>     clear_bit(SCHED, &n->state); |                              | NPSVC
>                                  | napi_schedule_prep()         | SCHED | NPSVC
>                                  | napi_poll()                  |
>                                  |   napi_complete_done()       |
>                                  |   {                          |
>                                  |      if (n->state & (NPSVC | | (1)
>                                  |               _BUSY_POLL)))  |
>                                  |           return false;      |
>                                  |     ................         |
>                                  |   }                          | SCHED | NPSVC
>                                  |                              |
>     clear_bit(NPSVC, &n->state); |                              | SCHED
> }                                |                              |
>                                  |                              |
> napi_schedule_prep()             |                              | SCHED | MISSED (2)
> 
> [...]

Here is the summary with links:
  - [net,v2] napi: fix race inside napi_enable
    https://git.kernel.org/netdev/net/c/3765996e4f0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


