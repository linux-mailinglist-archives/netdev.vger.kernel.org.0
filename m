Return-Path: <netdev+bounces-3159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 325A6705CCA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E42DB1C20D97
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC1D111AA;
	Wed, 17 May 2023 02:04:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF19567C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B3DC433D2;
	Wed, 17 May 2023 02:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684289093;
	bh=pJn/g+qAiwAHKm8RNj9qrB2eBRohyE4E8icX69OybcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JkC8VDrEsQT6q+Ip+HXUSZU04eXhgMC0Dq0qI8hAU5KVo6Kw27DM0X/8ZGku2aKLt
	 hfF38jPXEV+Her8DRJ3L3XCFa3GORXc1fkIxfU/b9MnSORDt0metlRmtWcknHvtLIq
	 75dj2SpcuQKTMhi597TGNQjYCsCkkJEjBmsmyBzyqZ6jcQ/EC4zxPToehwmR4y3aHO
	 aGVaIng/8YzooSukp5leJkw7qaOi9HK8nwolWcOmbbfbbQVque0PEMPnHkWza/k0Zr
	 Xqq610ikwG0v1UpTIBlmIOO63TzjNsqG8Yxx4zHd+2uRT0wOJUKLUfuq/nm4gFDzP9
	 thtaHakpR9BYg==
Date: Tue, 16 May 2023 19:04:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, Tariq
 Toukan <tariqt@nvidia.com>, saeedm@nvidia.com, leon@kernel.org,
 brouer@redhat.com
Subject: Re: [PATCH net v2] net/mlx5e: do as little as possible in napi poll
 when budget is 0
Message-ID: <20230516190452.0a2229f8@kernel.org>
In-Reply-To: <20230517015935.1244939-1-kuba@kernel.org>
References: <20230517015935.1244939-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 18:59:35 -0700 Jakub Kicinski wrote:
> NAPI gets called with budget of 0 from netpoll, which has interrupts
> disabled. We should try to free some space on Tx rings and nothing
> else.
> 
> Specifically do not try to handle XDP TX or try to refill Rx buffers -
> we can't use the page pool from IRQ context. Don't check if IRQs moved,
> either, that makes no sense in netpoll. Netpoll calls _all_ the rings
> from whatever CPU it happens to be invoked on.
> 
> In general do as little as possible, the work quickly adds up when
> there's tens of rings to poll.
> 
> The immediate stack trace I was seeing is:
> 
>     __do_softirq+0xd1/0x2c0
>     __local_bh_enable_ip+0xc7/0x120
>     </IRQ>
>     <TASK>
>     page_pool_put_defragged_page+0x267/0x320
>     mlx5e_free_xdpsq_desc+0x99/0xd0
>     mlx5e_poll_xdpsq_cq+0x138/0x3b0
>     mlx5e_napi_poll+0xc3/0x8b0
>     netpoll_poll_dev+0xce/0x150
> 
> AFAIU page pool takes a BH lock, releases it and since BH is now
> enabled tries to run softirqs.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

There's a condition which should be simplified later on:

		if (budget && work_done == budget)
			work_done--;

but I think we may be better off doing that as a follow up,
to keep this patch short and readable.

