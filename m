Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60347F40F
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhLYRUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 12:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37228 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhLYRUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 12:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20A81B80D7A;
        Sat, 25 Dec 2021 17:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C91A8C36AEA;
        Sat, 25 Dec 2021 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640452809;
        bh=o3Pf+IfD+k+6HQtvuTcdYOOE8ws0DVEFchXqe/MQp2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P1YDhRh1Jv3Rm/CddN1mb79zfKfCLbPS57mwc0SjxbUWxXRm4WtknhN4A+rHLFFf1
         hXza2k/Nu5uCFiWTaTJgBWqPjZOHGvgwVtYZe5U2ugIogdgcXKabI7iHRP10ZJYy2o
         9g9KC78sKb60y2aLN+mcnH3L/gWia22L9+ptcQ3v61KAnKLifAm5dVwDeazshEFVen
         6iAUFcNJVJysvLxfgs2Ehsd2a24JV/C3YPa3tXKi24+o9w6HjV+G5UqHXSjId1Iavi
         dPzK2fGQwdSGe+HXeR1FPcTS/nKiiDv3/tYyt3c0rrfe+4iyxLCQe8bU66aKm4k0eH
         F2UqDDF36apdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5162EAC06B;
        Sat, 25 Dec 2021 17:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] sctp: use call_rcu to free endpoint
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164045280966.14262.4507680284847266063.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Dec 2021 17:20:09 +0000
References: <152f3b81e78d311514330a5b97131beb459b01f5.1640282670.git.lucien.xin@gmail.com>
In-Reply-To: <152f3b81e78d311514330a5b97131beb459b01f5.1640282670.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        lee.jones@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 13:04:30 -0500 you wrote:
> This patch is to delay the endpoint free by calling call_rcu() to fix
> another use-after-free issue in sctp_sock_dump():
> 
>   BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
>   Call Trace:
>     __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
>     lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>     _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
>     spin_lock_bh include/linux/spinlock.h:334 [inline]
>     __lock_sock+0x203/0x350 net/core/sock.c:2253
>     lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
>     lock_sock include/net/sock.h:1492 [inline]
>     sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
>     sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
>     sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
>     __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
>     inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
>     netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
>     __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
>     netlink_dump_start include/linux/netlink.h:216 [inline]
>     inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
>     __sock_diag_cmd net/core/sock_diag.c:232 [inline]
>     sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
>     netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
>     sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] sctp: use call_rcu to free endpoint
    https://git.kernel.org/netdev/net/c/5ec7d18d1813

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


