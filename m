Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3A845928D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbhKVQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhKVQDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 57E02604D1;
        Mon, 22 Nov 2021 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637596809;
        bh=W+qq48wAA+1Eab5h8O1UnNFpX71xEOZgk0D2Su4jwn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VLjGUjk+MygGTF32+lSOf+oUnObOkissJPgXp4ZeaeV79HeN/LApyDcf6SpdpGaTv
         wwEs9NMbPcktF3MZlhIXEjKlupuEp9p+YlW3OX/iOGmehoBlhyCGua4MvZNDyuB97P
         HSQu9R3sjbMznxZYn7H7/Z0S+pw3KwcUjmPr5xmVn+q2KdTp/OyHeqdCVum+Z+S278
         6o77KzW4ya1JAeh7vrO4QBe6lpcnZ4BJGUnnMjB0unG86nztpL02SPmd6WM21pKnme
         p7RoZzeOr5lFoKvDcSRj+3YsODIG+dcUjiL4zOi5xflxCi/+tuZm62T+S0Y5Z2fXUX
         BqyjS8lNta5IQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 483C460A3B;
        Mon, 22 Nov 2021 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] net: nexthop: fix refcount issues when replacing
 groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759680929.8210.9267049257110301740.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 16:00:09 +0000
References: <20211122151514.2813935-1-razor@blackwall.org>
In-Reply-To: <20211122151514.2813935-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org, davem@davemloft.net,
        kuba@kernel.org, dsahern@gmail.com, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 17:15:11 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set fixes a refcount bug when replacing nexthop groups and
> modifying routes. It is complex because the objects look valid when
> debugging memory dumps, but we end up having refcount dependency between
> unlinked objects which can never be released, so in turn they cannot
> free their resources and refcounts. The problem happens because we can
> have stale IPv6 per-cpu dsts in nexthops which were removed from a
> group. Even though the IPv6 gen is bumped, the dsts won't be released
> until traffic passes through them or the nexthop is freed, that can take
> arbitrarily long time, and even worse we can create a scenario[1] where it
> can never be released. The fix is to release the IPv6 per-cpu dsts of
> replaced nexthops after an RCU grace period so no new ones can be
> created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
> is used by the nexthop code only when necessary. We can further optimize
> group replacement, but that is more suited for net-next as these patches
> would have to be backported to stable releases.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: ipv6: add fib6_nh_release_dsts stub
    https://git.kernel.org/netdev/net/c/8837cbbf8542
  - [net,v2,2/3] net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
    https://git.kernel.org/netdev/net/c/1005f19b9357
  - [net,v2,3/3] selftests: net: fib_nexthops: add test for group refcount imbalance bug
    https://git.kernel.org/netdev/net/c/02ebe49ab061

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


