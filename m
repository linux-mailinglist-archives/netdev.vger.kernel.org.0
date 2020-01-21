Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A43B144131
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAUQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgAUQBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:01:02 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372B321569;
        Tue, 21 Jan 2020 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579622461;
        bh=3dbhCVeNtCuc8YQbYn1bmqDupP8Gx2N3OakjJc34Xsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i1teIZ/63aJPR1QxN5NbJUCzyrn1bGc5I1JL8DpaFLqZqV4M/8P+KBc/gPD/zR3gv
         YklrMaJ79nglAd/RPT7LReElBzdYa2w4r4QBDxcpAHmJc+WTtgmXHLASu4S9BzEM3B
         nqWKBV4kKX7UFKTsPM3AvsTiQ/SWB6/1+ce7H46k=
Date:   Tue, 21 Jan 2020 08:00:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [PATCH v4 04/17] octeontx2-pf: Initialize and config queues
Message-ID: <20200121080058.42b0c473@cakuba>
In-Reply-To: <1579612911-24497-5-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:38 +0530, sunil.kovvuri@gmail.com wrote:
> +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> +			   gfp_t gfp)
> +{
> +	dma_addr_t iova;
> +
> +	/* Check if request can be accommodated in previous allocated page */
> +	if (pool->page &&
> +	    ((pool->page_offset + pool->rbsize) <= PAGE_SIZE)) {
> +		pool->pageref++;
> +		goto ret;
> +	}
> +
> +	otx2_get_page(pool);
> +
> +	/* Allocate a new page */
> +	pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> +				 pool->rbpage_order);
> +	if (unlikely(!pool->page))
> +		return -ENOMEM;
> +
> +	pool->page_offset = 0;
> +ret:
> +	iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> +				      pool->rbsize, DMA_FROM_DEVICE);
> +	if (!iova) {
> +		if (!pool->page_offset)
> +			__free_pages(pool->page, pool->rbpage_order);
> +		pool->page = NULL;
> +		return -ENOMEM;
> +	}
> +	pool->page_offset += pool->rbsize;
> +	return iova;
> +}

You don't seem to be doing any page recycling if I'm reading this right.
Can't you use the standard in-kernel page frag allocator
(netdev_alloc_frag/napi_alloc_frag)?
