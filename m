Return-Path: <netdev+bounces-3487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA22707890
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BF131C21006
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C574D39A;
	Thu, 18 May 2023 03:46:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D12394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26449C433D2;
	Thu, 18 May 2023 03:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684381593;
	bh=LVqrx9FSnoK95b2r+pfjkvtzhodfsQ3937DJvnW28Ac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HQzkuB/y3n2cmA+kuausxtQnwtdrkxb12uwF1i8XLM7pz4rKIcSikpf+9HHSELfJj
	 fbFZVHrAYogVfor5Y6GsggiKlv0osTLVFUCxApy05k+QYCx9p2YHH7FMsm2uwMP/op
	 IiwkF9Ujrd6ADk1hBzEpK7x4WsUnNnjYS3BNQWjO1kydYAKZskzdnms0Iyu5WNZti3
	 BiSqFGyJllQuwPFQQ2mZlPikUd209OnGPmuTv/UFCcV7v+ZCkm5dI8/EFVC8SzF2sY
	 ZQBxewq1nPJPQx7PsJ0t8KDEg2OmS+RoSOWYCNEIdDvfGZIPpLixBSVuiaCY7G4MMu
	 Nzlv8ITNz+0dg==
Date: Wed, 17 May 2023 20:46:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <sbhatta@marvell.com>, <gakula@marvell.com>,
 <schalla@marvell.com>, <hkelam@marvell.com>
Subject: Re: [PATH net-next v1] octeontx2-pf: Add support for page pool
Message-ID: <20230517204632.5f80a7bf@kernel.org>
In-Reply-To: <20230517041511.2532997-1-rkannoth@marvell.com>
References: <20230517041511.2532997-1-rkannoth@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 09:45:11 +0530 Ratheesh Kannoth wrote:
> Page pool for each rx queue enhance rx side performance
> by reclaiming buffers back to each queue specific pool. DMA
> mapping is done only for first allocation of buffers.
> As subsequent buffers allocation avoid DMA mapping,
> it results in performance improvement.
> 
> Image        |  Performance with Linux kernel Packet Generator
> ------------ | -----------------------------------------------
> Vannila      |   3Mpps
>              |
> with this    |   42Mpps
> change	     |
> ----------------------------------------------------------------
> 
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> 

Put an extra --- here, to place the change log outside the normal
commit message.

> ChangeLog
> v0 -> v1: Removed CONFIG_PAGE_POOL #ifdefs in code
> 	  Used compound page APIs
> 	  Replaced page_pool_put_page API with page_pool_put_full_page API

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index f9286648e45c..49df1876eca3 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -518,11 +518,36 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
>  		     (pfvf->hw.cq_ecount_wait - 1));
>  }
>  
> +static int otx2_alloc_pool_buf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> +			       dma_addr_t *dma)
> +{
> +	unsigned int offset = 0;
> +	struct page *page;
> +	size_t sz;
> +
> +	sz = SKB_DATA_ALIGN(pool->rbsize);
> +	sz = ALIGN(sz, OTX2_ALIGN);
> +
> +	page = page_pool_alloc_frag(pool->page_pool, &offset, sz,
> +				    (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL) |

in_interrupt() should not be used in drivers, AFAIR.
Pass the correct flags from the caller (or don't -- it seems like 
the only caller assumes softirq context already).

> +				    GFP_DMA);

GFP_DMA? Why?

> +	if (unlikely(!page)) {
> +		netdev_err(pfvf->netdev, "Allocation of page pool failed\n");

No prints on allocation errors, please, it only adds stress to 
the system. You can add a statistic if you want.

> +		return -ENOMEM;
> +	}
> +
> +	*dma = page_pool_get_dma_addr(page) + offset;
> +	return 0;
> +}

> +	pp_params.flags = PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
> +	pp_params.pool_size = numptrs;
> +	pp_params.nid = NUMA_NO_NODE;
> +	pp_params.dev = pfvf->dev;
> +	pp_params.dma_dir = DMA_FROM_DEVICE;
> +	pool->page_pool = page_pool_create(&pp_params);
> +	if (!pool->page_pool) {
> +		netdev_err(pfvf->netdev, "Creation of page pool failed\n");
> +		return -EFAULT;

EFAULT == "Bad address", doesn't sound right

> +	}
> +
>  	return 0;
>  }
-- 
pw-bot: cr

