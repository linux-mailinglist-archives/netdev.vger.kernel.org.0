Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428184A3E24
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 08:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348050AbiAaHVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 02:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244130AbiAaHU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 02:20:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF25C061714;
        Sun, 30 Jan 2022 23:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2A06128E;
        Mon, 31 Jan 2022 07:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FA4C340E8;
        Mon, 31 Jan 2022 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643613657;
        bh=dOH4qTrfCAlGRwNf4g1KYdZmXGQX8HlE2W5ZivxPsgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhMis8+ppudLodJ5Oc5DG8qUQyfcLn0gijgAHMcVHU+umIKXKj3Etf9S8Uqotqv4E
         Tl+G7Xwum4WxNkkEJhLTgX3HblKiZR+uYcFdpvTjAGQ8iFpTmXvDC5oAkchG3OqJLY
         qRyOcuZNHnsOjNwlTyqTjrZABLL9oGkq6vx5EtPNtwp23ysSnhaYyDW0IXRZJvXLRW
         EhmeQOAFbSTjZQ3kaBujs8VzIP88UXn/WIBCFvYiOp6r7LCwfIc/J7tpkiB0xOhfSs
         ppl/D2LNkp7aQFQa9a7Ju0Sgdk5E5gX2Qja0aH/t0J72M+Fu6ji6xPKlR83pQQlc9n
         d3ycME0hRJtKw==
Date:   Mon, 31 Jan 2022 09:20:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA
 node
Message-ID: <YfeN1BfPqhVz8mvy@unreal>
References: <20220130190259.94593-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220130190259.94593-1-tonylu@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 03:03:00AM +0800, Tony Lu wrote:
> Currently, pages are allocated in the process context, for its NUMA node
> isn't equal to ibdev's, which is not the best policy for performance.
> 
> Applications will generally perform best when the processes are
> accessing memory on the same NUMA node. When numa_balancing enabled
> (which is enabled by most of OS distributions), it moves tasks closer to
> the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
> to the same node usually. This reduces the latency when accessing remote
> memory.

It is very subjective per-specific test. I would expect that
application will control NUMA memory policies (set_mempolicy(), ...)
by itself without kernel setting NUMA node.

Various *_alloc_node() APIs are applicable for in-kernel allocations
where user can't control memory policy.

I don't know SMC-R enough, but if I judge from your description, this
allocation is controlled by the application.

Thanks

> 
> According to our tests in different scenarios, there has up to 15.30%
> performance drop (Redis benchmark) when accessing remote memory.
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  net/smc/smc_core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 8935ef4811b0..2a28b045edfa 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2065,9 +2065,10 @@ int smcr_buf_reg_lgr(struct smc_link *lnk)
>  	return rc;
>  }
>  
> -static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
> +static struct smc_buf_desc *smcr_new_buf_create(struct smc_connection *conn,
>  						bool is_rmb, int bufsize)
>  {
> +	int node = ibdev_to_node(conn->lnk->smcibdev->ibdev);
>  	struct smc_buf_desc *buf_desc;
>  
>  	/* try to alloc a new buffer */
> @@ -2076,10 +2077,10 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
>  		return ERR_PTR(-ENOMEM);
>  
>  	buf_desc->order = get_order(bufsize);
> -	buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
> -				      __GFP_NOMEMALLOC | __GFP_COMP |
> -				      __GFP_NORETRY | __GFP_ZERO,
> -				      buf_desc->order);
> +	buf_desc->pages = alloc_pages_node(node, GFP_KERNEL | __GFP_NOWARN |
> +					   __GFP_NOMEMALLOC | __GFP_COMP |
> +					   __GFP_NORETRY | __GFP_ZERO,
> +					   buf_desc->order);
>  	if (!buf_desc->pages) {
>  		kfree(buf_desc);
>  		return ERR_PTR(-EAGAIN);
> @@ -2190,7 +2191,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>  		if (is_smcd)
>  			buf_desc = smcd_new_buf_create(lgr, is_rmb, bufsize);
>  		else
> -			buf_desc = smcr_new_buf_create(lgr, is_rmb, bufsize);
> +			buf_desc = smcr_new_buf_create(conn, is_rmb, bufsize);
>  
>  		if (PTR_ERR(buf_desc) == -ENOMEM)
>  			break;
> -- 
> 2.32.0.3.g01195cf9f
> 
