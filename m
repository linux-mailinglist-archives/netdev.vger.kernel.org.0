Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2946E7ED9
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjDSPtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjDSPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:49:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6982FA256
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D770663733
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 15:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100D2C433EF;
        Wed, 19 Apr 2023 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681919250;
        bh=zPaYHlCyzBKhGiDqbza2QRzwDKWYkIQvXkPIjTDmtvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmdBHXgcZg4tq3UBpMLHJaq7hc0BOK1gqbaNC8XVha/JK9du1knkhwGxoFqOyXS3U
         RaJv9aFdqpgSXLaKF6L0ob3v1rtYChDhwEdpZ5vQNL7z8MSoDGfXwweRTDHAVFYpHp
         nDlrIZErWf8fPT3HjMAyzZ1esxyiCFV4uhkwjpk9dc1b5R5t55DGeah3plO194PItX
         aqPyfpzdFFuCwcNaPZRsZX6YVYNaio3suc4JlNPIUmphKXioQj2aX26+WzTDrN5KEB
         cz0IUBl7vpNTglfntQxvrC8HlraZ7Ak1QiCHGGFDZFxz8Hc2kSnaKw0y2J/zG1gRnq
         8WMSWtRj9E2pw==
Date:   Wed, 19 Apr 2023 09:47:28 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     davem@davemloft.net, edumazet@google.com, tglx@linutronix.de,
        wangyang.guo@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dst: fix missing initialization of
 rt_uncached
Message-ID: <20230419154728.GA23087@u2004-local>
References: <20230418165426.1869051-1-mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418165426.1869051-1-mbizon@freebox.fr>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 06:54:26PM +0200, Maxime Bizon wrote:
> xfrm_alloc_dst() followed by xfrm4_dst_destroy(), without a
> xfrm4_fill_dst() call in between, causes the following BUG:
> 
>  BUG: spinlock bad magic on CPU#0, fbxhostapd/732
>   lock: 0x890b7668, .magic: 890b7668, .owner: <none>/-1, .owner_cpu: 0
>  CPU: 0 PID: 732 Comm: fbxhostapd Not tainted 6.3.0-rc6-next-20230414-00613-ge8de66369925-dirty #9
>  Hardware name: Marvell Kirkwood (Flattened Device Tree)
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x28/0x30
>   dump_stack_lvl from do_raw_spin_lock+0x20/0x80
>   do_raw_spin_lock from rt_del_uncached_list+0x30/0x64
>   rt_del_uncached_list from xfrm4_dst_destroy+0x3c/0xbc
>   xfrm4_dst_destroy from dst_destroy+0x5c/0xb0
>   dst_destroy from rcu_process_callbacks+0xc4/0xec
>   rcu_process_callbacks from __do_softirq+0xb4/0x22c
>   __do_softirq from call_with_stack+0x1c/0x24
>   call_with_stack from do_softirq+0x60/0x6c
>   do_softirq from __local_bh_enable_ip+0xa0/0xcc
> 
> Patch "net: dst: Prevent false sharing vs. dst_entry:: __refcnt" moved
> rt_uncached and rt_uncached_list fields from rtable struct to dst
> struct, so they are more zeroed by memset_after(xdst, 0, u.dst) in
> xfrm_alloc_dst().
> 
> Note that rt_uncached (list_head) was never properly initialized at
> alloc time, but xfrm[46]_dst_destroy() is written in such a way that
> it was not an issue thanks to the memset:
> 
> 	if (xdst->u.rt.dst.rt_uncached_list)
> 		rt_del_uncached_list(&xdst->u.rt);
> 
> The route code does it the other way around: rt_uncached_list is
> assumed to be valid IIF rt_uncached list_head is not empty:
> 
> void rt_del_uncached_list(struct rtable *rt)
> {
>         if (!list_empty(&rt->dst.rt_uncached)) {
>                 struct uncached_list *ul = rt->dst.rt_uncached_list;
> 
>                 spin_lock_bh(&ul->lock);
>                 list_del_init(&rt->dst.rt_uncached);
>                 spin_unlock_bh(&ul->lock);
>         }
> }
> 
> This patch adds mandatory rt_uncached list_head initialization in
> generic dst_init(), and adapt xfrm[46]_dst_destroy logic to match the
> rest of the code.
> 
> Fixes: d288a162dd1c ("net: dst: Prevent false sharing vs. dst_entry:: __refcnt")
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> ---
>  net/core/dst.c          | 1 +
>  net/ipv4/xfrm4_policy.c | 4 +---
>  net/ipv6/route.c        | 1 -
>  net/ipv6/xfrm6_policy.c | 4 +---
>  4 files changed, 3 insertions(+), 7 deletions(-)
> 

This fixes the bug introduced by the Fixes commit, so:

Reviewed-by: David Ahern <dsahern@kernel.org>

uncached_list is defined twice  - net/ipv{4,6}/route.c.
Since uncached_list was moved from protocol local structs to dst_entry,
the definition for uncached_list should be moved there as well.
