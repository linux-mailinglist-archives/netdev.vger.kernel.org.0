Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914ED244129
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 00:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHMWQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 18:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHMWQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 18:16:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEA6C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 15:16:50 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B64912824848;
        Thu, 13 Aug 2020 15:00:02 -0700 (PDT)
Date:   Thu, 13 Aug 2020 15:16:45 -0700 (PDT)
Message-Id: <20200813.151645.2237092382995289461.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, w@1wt.eu,
        sedat.dilek@gmail.com
Subject: Re: [PATCH net] random32: add a tracepoint for prandom_u32()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200813170643.4031609-1-edumazet@google.com>
References: <20200813170643.4031609-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Aug 2020 15:00:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 13 Aug 2020 10:06:43 -0700

> There has been some heat around prandom_u32() lately, and some people
> were wondering if there was a simple way to determine how often
> it was used, before considering making it maybe 10 times more expensive.
> 
> This tracepoint exports the generated pseudo random value.
> 
> Tested:
> 
> perf list | grep prandom_u32
>   random:prandom_u32                                 [Tracepoint event]
> 
> perf record -a [-g] [-C1] -e random:prandom_u32 sleep 1
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 259.748 MB perf.data (924087 samples) ]
> 
> perf report --nochildren
>     ...
>     97.67%  ksoftirqd/1     [kernel.vmlinux]  [k] prandom_u32
>             |
>             ---prandom_u32
>                prandom_u32
>                |
>                |--48.86%--tcp_v4_syn_recv_sock
>                |          tcp_check_req
>                |          tcp_v4_rcv
>                |          ...
>                 --48.81%--tcp_conn_request
>                           tcp_v4_conn_request
>                           tcp_rcv_state_process
>                           ...
> perf script
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
