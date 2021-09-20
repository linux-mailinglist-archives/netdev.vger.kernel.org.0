Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179594126D0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346345AbhITTXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236146AbhITTVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 15:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF65661175;
        Mon, 20 Sep 2021 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632165625;
        bh=zXdDGgY5gXiIiBAq/y88VgaVgw1XYqFo5HlbyWyooWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U4H8/RijLpO+XatHIAdTVtHkg3V6YsakeNXTt0cNZafazH/JsgdfuF7/pQxrTmW25
         gL0SFU08GgMbb43+/RJVIOST3Uzgdk2TWeMYI2xnnBwjkCquxnARC3vs/oOiZJDWus
         LqzhGSyanpr0WWgZ1kyK2DuSMtDmcP3+TMsGazpqD3q1DO/j1yCxFHT0UVMYICI3Jm
         Vukcja7xWjZOaYpWQMjSt4l2Scq+7r9G+suwc7nRRIrs05jOrAwQ5Rq4cTCJS5Yb1y
         IzLuP10EWwsuXnOEaVmg7kpwM+nprl6AP7OfTW2NBK7t41AFtJUxyB+wIFceBCzGa2
         0za0nDti5K/Iw==
Date:   Mon, 20 Sep 2021 12:20:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20210920122024.283fe8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Sep 2021 16:52:32 +0800 Xuan Zhuo wrote:
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
> (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
> (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
> 
> Since NAPI_STATE_SCHED already exists and napi is not in the
> sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
> exist.
> 
> 1. This will cause this queue to no longer receive packets.
> 2. If you encounter napi_disable under the protection of rtnl_lock, it
>    will cause the entire rtnl_lock to be locked, affecting the overall
>    system.
> 
> This patch uses cmpxchg to implement napi_enable(), which ensures that
> there will be no race due to the separation of clear two bits.
> 
> Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Why don't you just invert the order of clearing the bits:

diff --git a/net/core/dev.c b/net/core/dev.c
index a796754f75cc..706eca8112c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6953,8 +6953,8 @@ void napi_enable(struct napi_struct *n)
 {
        BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
        smp_mb__before_atomic();
-       clear_bit(NAPI_STATE_SCHED, &n->state);
        clear_bit(NAPI_STATE_NPSVC, &n->state);
+       clear_bit(NAPI_STATE_SCHED, &n->state);
        if (n->dev->threaded && n->thread)
                set_bit(NAPI_STATE_THREADED, &n->state);
 }

That's simpler and symmetric with the disable path.
