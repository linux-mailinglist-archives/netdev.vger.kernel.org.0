Return-Path: <netdev+bounces-11223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6883B732078
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C53EF28146F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBC8EAEE;
	Thu, 15 Jun 2023 19:47:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D7DEAD9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 19:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95106C433C8;
	Thu, 15 Jun 2023 19:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686858458;
	bh=AKMJ9Nhuvfu6Z+tz0mQlySiQlu7rOvQ1VIdI1LAzQI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UrrR+aU7enX0JTf+4gH04k7J/WrkrFfXZFRL74tHMQftQDtSHeeBkpgAnQgt406+J
	 s+bBqIyk15lb3vvecX4AW2J/x+AjbJVPS8jGe9voJTky8KUUvenuQ1rxBiBl7CKifh
	 hdb5jcQ5cHaJIF+gSAc4pwTdVwPLj3d5MFiiCnJriN7E8b3VLoNVv+l1UA6bq0Wbk7
	 t7hKzl6sT1vSn35jUPT/dsxnBc+HC2SAibQZ/uP6AeJ/il/R6XDx6FsFiBIjPHWXcn
	 rz6BFAx04PFV97Z4AprMLZ5gFKdDTu/A0vLcI5Atu7HJ8JRH3FLU1Mf0KFjZ/C0SM+
	 NvPjUrW2daDuQ==
Date: Thu, 15 Jun 2023 12:47:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Louis Peens <louis.peens@corigine.com>
Cc: David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <simon.horman@corigine.com>, Tianyu Yuan
 <tianyu.yuan@corigine.com>, netdev@vger.kernel.org, stable@vger.kernel.org,
 oss-drivers@corigine.com
Subject: Re: [PATCH net v2] nfp: fix rcu_read_lock/unlock while
 rcu_derefrencing
Message-ID: <20230615124737.43025acb@kernel.org>
In-Reply-To: <20230615073139.8656-1-louis.peens@corigine.com>
References: <20230615073139.8656-1-louis.peens@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 09:31:39 +0200 Louis Peens wrote:
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> 
> When CONFIG_PROVE_LOCKING and CONFIG_PROVE_RCU are enabled, using OVS with
> vf reprs on bridge will lead to following log in dmesg:
> 
>  .../nfp/flower/main.c:269 suspicious rcu_dereference_check() usage!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 2, debug_locks = 1
>  no locks held by swapper/15/0.
> 
>  ......
>  Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x8c/0xa0
>   lockdep_rcu_suspicious+0x118/0x1a0
>   nfp_flower_dev_get+0xc1/0x240 [nfp]
>   nfp_nfd3_rx+0x419/0xb90 [nfp]
>   ? validate_chain+0x640/0x1880
>   nfp_nfd3_poll+0x3e/0x180 [nfp]
>   __napi_poll+0x28/0x1d0
>   net_rx_action+0x2bd/0x3c0
>   ? _raw_spin_unlock_irqrestore+0x42/0x70
>   __do_softirq+0xc3/0x3c6
>   irq_exit_rcu+0xeb/0x130
>   common_interrupt+0xb9/0xd0
>   </IRQ>
>   <TASK>
>   ......
>   </TASK>
> 
> In previous patch rcu_read_lock()/unlock() are removed because rcu-lock may
> affect xdp_prog. However this removal will make RCU lockdep report above
> warning because of missing of rcu_read_lock()/unlock() pair around
> rcu_deference().
> 
> This patch resolves this problem by replacing rcu_deference() with
> rcu_dereference_check() to annotate that access is safe if
> rcu_read_lock/rcu_read_lock_bh is held.
> 
> Fixes: d5789621b658 ("nfp: Remove rcu_read_lock() around XDP program invocation")

I'd vote to simply revert that commit. Toke likely assumed that the RCU
protection is only for XDP but turns out we have more datapath stuff
that depends on it. No strong preference but my vote would be to not
play with RCU flavors at the driver level.

> CC: stable@vger.kernel.org
> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>

> -	reprs = rcu_dereference(app->reprs[rtype]);
> +	reprs = rcu_dereference_check(app->reprs[rtype], rcu_read_lock_bh_held());

If you prefer to keep the patch I think this is just
rcu_dereference_bh() ?
-- 
pw-bot: cr

