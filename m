Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA5166B5E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgBUAOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:14:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729416AbgBUAOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=hl2GPzrt5tb1QgNeUKbjy8zbDJVp2hFuVIssZQ2kG18=; b=TxRpIh9UGNphPByn50vHrFoELY
        RReJ97XLMO1uV+LuHMbRddBW2m9zq7yltzWAQ7r9v9Hhir57OW3H5mgAZK1kyT1s+nkP7mNRKzJ1G
        JVhO9Ih313O9wYp8DTZykmf/6me60rj8ZwujNtLIcjCZBkm4khzGKWfrgtyGNRi5335q9aybuEswA
        pS3tIETkfsTHK3WiqZpFdvLDiVuhTuZr7CFF8ePkjjao094DDW6MIvxTvPp6kyWU28WzloeTYwhYC
        lIMbGzaRWB+ZoHaw3eUpG8g/TKib1aTLegiWqN/N2VLVWmx61Rj0G+3X5eHr5A4YYNoEYtaKH7KJW
        XOrvLxcw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4vxC-000877-0C; Fri, 21 Feb 2020 00:14:02 +0000
Subject: Re: [PATCH net-next] net: page_pool: Add documentation for page_pool
 API
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     lorenzo@kernel.org, toke@redhat.com
References: <20200220182521.859730-1-ilias.apalodimas@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0bfe362b-276d-21ad-24b9-67813c0cd50a@infradead.org>
Date:   Thu, 20 Feb 2020 16:14:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220182521.859730-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again Ilias,

On 2/20/20 10:25 AM, Ilias Apalodimas wrote:
> Add documentation explaining the basic functionality and design
> principles of the API
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  Documentation/networking/page_pool.rst | 159 +++++++++++++++++++++++++
>  1 file changed, 159 insertions(+)
>  create mode 100644 Documentation/networking/page_pool.rst
> 
> diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> new file mode 100644
> index 000000000000..098d339ef272
> --- /dev/null
> +++ b/Documentation/networking/page_pool.rst
> @@ -0,0 +1,159 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============
> +Page Pool API
> +=============
> +
> +The page_pool allocator is optimized for the XDP mode that uses one frame
> +per-page, but it can fallback on the regular page allocator APIs.
> +
> +Basic use involve replacing alloc_pages() calls with the

             involves

> +page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
> +replacing dev_alloc_pages().
> +
...

> +
> +Architecture overview
> +=====================
> +
> +.. code-block:: none
> +
...

> +
> +API interface
> +=============
> +The number of pools created **must** match the number of hardware queues
> +unless hardware restrictions make that impossible. This would otherwise beat the
> +purpose of page pool, which is allocate pages fast from cache without locking.
> +This lockless guarantee naturally comes from running under a NAPI softirq.
> +The protection doesn't strictly have to be NAPI, any guarantee that allocating
> +a page will cause no race conditions is enough.
> +
> +* page_pool_create(): Create a pool.
> +    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV
> +    * order:      order^n pages on allocation

what is "n" above?
My quick reading of mm/page_alloc.c suggests that order is the power of 2
that should be used for the memory allocation... ???

> +    * pool_size:  size of the ptr_ring
> +    * nid:        preferred NUMA node for allocation
> +    * dev:        struct device. Used on DMA operations
> +    * dma_dir:    DMA direction
> +    * max_len:    max DMA sync memory size
> +    * offset:     DMA address offset
> +
...

> +
> +Coding examples
> +===============
> +
> +Registration
> +------------
> +
> +.. code-block:: c
> +
> +    /* Page pool registration */
> +    struct page_pool_params pp_params = { 0 };
> +    struct xdp_rxq_info xdp_rxq;
> +    int err;
> +
> +    pp_params.order = 0;

so 0^n?

> +    /* internal DMA mapping in page_pool */
> +    pp_params.flags = PP_FLAG_DMA_MAP;
> +    pp_params.pool_size = DESC_NUM;
> +    pp_params.nid = NUMA_NO_NODE;
> +    pp_params.dev = priv->dev;
> +    pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> +    page_pool = page_pool_create(&pp_params);
> +
> +    err = xdp_rxq_info_reg(&xdp_rxq, ndev, 0);
> +    if (err)
> +        goto err_out;
> +
> +    err = xdp_rxq_info_reg_mem_model(&xdp_rxq, MEM_TYPE_PAGE_POOL, page_pool);
> +    if (err)
> +        goto err_out;
> +
> +NAPI poller
> +-----------

thanks.
-- 
~Randy

