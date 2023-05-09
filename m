Return-Path: <netdev+bounces-1071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 321EE6FC14E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1685F1C20AD4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE1A17AC3;
	Tue,  9 May 2023 08:09:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351533D6A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2225BC433D2;
	Tue,  9 May 2023 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683619740;
	bh=oLPGG3Po1TNl0+q1Yr4nbOFH3WY9okHZvkw178oc7jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=noCCmyJhmfduedn/aT6XKmmmfQXsk0YJcoc4IcYnzcgZSonZD9dEiQpWZuiDz7WAg
	 OFyDFCaZHGF34eRenJtAbq6S4G5u19LwmJgRxQBkbEGiy1iGnnE3HmDRJLhVTiOLOs
	 RuV5sNX4t5uwdZevNgLuYlWqdAZuY2khz5AcFdZHoS5VILF58AUVQpjriwe1uI6KVh
	 NefIe8LSe03KrQoTdMOb12AOsKmrQaj+jfni9fgjeaovqeSA0J2QJgL/EPlEsxwS8y
	 9+f14tzdZWivO4dCB0z3SoUwI+3napiCWjtsfeL/94Ioq6rK2nIcqkYUAaLqnKQs+2
	 ub6tBN4WhMbbg==
Date: Tue, 9 May 2023 11:08:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Louis Peens <louis.peens@corigine.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	stable@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: fix rcu_read_lock/unlock while rcu_derefrencing
Message-ID: <20230509080856.GG38143@unreal>
References: <20230509060632.8233-1-louis.peens@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509060632.8233-1-louis.peens@corigine.com>

On Tue, May 09, 2023 at 08:06:32AM +0200, Louis Peens wrote:
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> 
> When CONFIG_PROVE_LOCKING and CONFIG_PROVE_RCU are enabled, using
> OVS with vf reprs on bridge will lead to following log in dmesg:
> 
> '''
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
> '''
> 
> This debug log is caused by missing of rcu_read_lock()/unlock().
> In previous patch rcu_read_lock/unlock are removed while they are
> still needed when calling rcu_dereference() in nfp_app_dev_get().
> 
> Fixes: d5789621b658 ("nfp: Remove rcu_read_lock() around XDP program invocation")
> CC: stable@vger.kernel.org
> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  4 ++--
>  drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  2 +-
>  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |  4 ++--
>  drivers/net/ethernet/netronome/nfp/nfp_app.h  | 16 ++++++++++++++++
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

