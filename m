Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B67E3B351D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhFXSC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXSC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8905613EA;
        Thu, 24 Jun 2021 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624557607;
        bh=pM6bQ2mpdIH2Xq0e5attPpRJYFmyPq9/Y/Z5ebrECRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbeoCBGnre9ooVhkdhU+TaIBkzwrVfpLfN91cGQ8fgpabd9u9gaWSJhFjrAWjprjj
         Q/2JKeE2y5y3B+lnojb2RDasXY1cV5YVTaFO24tUbBFXQ+6P9/hTtiOsS6U41FJggf
         JpIkE2fdGKMb+jkqYzRQpbuTpCy4vOobFf3lTG+KBC6lf6FRqHux7f6esNNJunSJwh
         J3ijd/+QczE+ZMqaqRoXDR1+2zDUFMjhFk2mCP2WVccR92mWZQDemroqPRjF97qmAi
         l201hEFGlKjjfPVfeXl7FEF7dkVYvRkGrHLoUTkjWYuUxFKqhAv2g47VkFouV05+UM
         qoqSEZxeCcUeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA22060952;
        Thu, 24 Jun 2021 18:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 00/19] Clean up and document RCU-based object
 protection for XDP and TC BPF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162455760775.19513.3320386456200490614.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:00:07 +0000
References: <20210624160609.292325-1-toke@redhat.com>
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, kafai@fb.com,
        liuhangbin@gmail.com, brouer@redhat.com, magnus.karlsson@gmail.com,
        paulmck@kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 24 Jun 2021 18:05:50 +0200 you wrote:
> During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
> that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
> no means obvious. I promised to look into cleaning this up, and Paul helpfully
> provided some hints and a new unrcu_pointer() helper to aid in this.
> 
> It seems[1] that back in the early days of XDP, local_bh_disable() did not
> provide RCU protection, which is why the rcu_read_lock() calls were added
> to drivers in the first place. But according to Paul[2], in recent kernels
> a local_bh_disable()/local_bh_enable() pair functions as one big RCU
> read-side section, so no further protection is needed. This even applies to
> -rt kernels, which has an explicit rcu_read_lock() in place as part of the
> local_bh_disable()[3].
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,01/19] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
    https://git.kernel.org/bpf/bpf-next/c/b9964ce74544
  - [bpf-next,v5,02/19] doc: Clarify and expand RCU updaters and corresponding readers
    https://git.kernel.org/bpf/bpf-next/c/9a145c04a293
  - [bpf-next,v5,03/19] doc: Give XDP as example of non-obvious RCU reader/updater pairing
    https://git.kernel.org/bpf/bpf-next/c/e74c74f9e51d
  - [bpf-next,v5,04/19] bpf: allow RCU-protected lookups to happen from bh context
    https://git.kernel.org/bpf/bpf-next/c/694cea395fde
  - [bpf-next,v5,05/19] xdp: add proper __rcu annotations to redirect map entries
    https://git.kernel.org/bpf/bpf-next/c/782347b6bcad
  - [bpf-next,v5,06/19] sched: remove unneeded rcu_read_lock() around BPF program invocation
    https://git.kernel.org/bpf/bpf-next/c/77151ccf1065
  - [bpf-next,v5,07/19] ena: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/0939e0537896
  - [bpf-next,v5,08/19] bnxt: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/158c1399fc45
  - [bpf-next,v5,09/19] thunderx: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/36baafe347a8
  - [bpf-next,v5,10/19] freescale: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/547aabcac325
  - [bpf-next,v5,11/19] net: intel: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/49589b23d5a9
  - [bpf-next,v5,12/19] marvell: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/959ad7ec066d
  - [bpf-next,v5,13/19] mlx4: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/c4411b371c10
  - [bpf-next,v5,14/19] nfp: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/d5789621b658
  - [bpf-next,v5,15/19] qede: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/4415db6ca85a
  - [bpf-next,v5,16/19] sfc: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/4eb14e3fc619
  - [bpf-next,v5,17/19] netsec: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/7b6ee873ff20
  - [bpf-next,v5,18/19] stmmac: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/2f1e432d339c
  - [bpf-next,v5,19/19] net: ti: remove rcu_read_lock() around XDP program invocation
    https://git.kernel.org/bpf/bpf-next/c/0cc84b9a6003

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


