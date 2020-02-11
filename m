Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB13159621
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 18:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgBKR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 12:27:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45868 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgBKR1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 12:27:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=XN3k80jAjBnLXnZHypuHoeyUQPQKU2tTkCZKngcR1wk=; b=jriBwzahpX1iiNuiycukvzVifg
        2Pfz1MXNXxRaIHdRaUuF/sAHZjzv7WfYrKic0p0CB1We6+llzKq2o8pl330TIZYc4KSfvi+gLTpdB
        RYdiJxD80QCEWXTKB9LPn5iSW83n6b88Vu5q/a73TRs2GYDp7Tm7KaqpxyZdbqrZSuoDa2DEXZ6SZ
        3k+C8dX2F8uLv5zE5gEkCgcbUCirmlXsKEvvvMGXz5TJFyyfsWJfFTv/W+zRflCddWa8eaDVh05DT
        rgf+TSo908vHSRyktlZs4OR2FYgV1mQbQoC+o1xIxPanz/h2aE2jLknS/ftSnfs3+iY+xlmmTalnp
        1g6ZccEA==;
Received: from [2603:3004:32:9a00::c450]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j1ZK6-0008OA-38; Tue, 11 Feb 2020 17:27:46 +0000
Subject: Re: [PATCH, net-next] net: page_pool: Add documentation on page_pool
 API
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com,
        lorenzo@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
References: <20200211154227.1169600-1-ilias.apalodimas@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <25360a12-90ce-39ac-4956-8591a8c4eb74@infradead.org>
Date:   Tue, 11 Feb 2020 09:22:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211154227.1169600-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here are some doc comments for you...

On 2/11/20 7:42 AM, Ilias Apalodimas wrote:
> Add documentation explaining the basic functionality and design
> principles of the API
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  Documentation/networking/page_pool.rst | 153 +++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>  create mode 100644 Documentation/networking/page_pool.rst
> 
> diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> new file mode 100644
> index 000000000000..e143339e4c80
> --- /dev/null
> +++ b/Documentation/networking/page_pool.rst
> @@ -0,0 +1,153 @@
> +=============
> +Page Pool API
> +=============
> +
> +The page_pool allocator is optimized for the XDP mode that uses one frame 
> +per-page, but it can fallback on the regular page allocator APIs.
> +
> +Basic use involve replacing alloc_pages() calls with the
> +page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages() 
> +replacing dev_alloc_pages().
> +
> +API keeps track of in-flight pages, in-order to let API user know

                                       in order

> +when it is safe to free a page_pool object.  Thus, API users
> +must run page_pool_release_page() when a page is leaving the page_pool or
> +call page_pool_put_page() where appropriate in order to maintain correct
> +accounting.
> +
> +API user must call page_pool_put_page() once on a page, as it
> +will either recycle the page, or in case of refcnt > 1, it will
> +release the DMA mapping and in-flight state accounting.
> +
> +Architecture overview
> +=====================
> +
> +.. code-block:: none
> +
> +    +------------------+
> +    |       Driver     | 
> +    +------------------+
> +            ^ 
> +            |
> +            |
> +            |
> +            v
> +    +--------------------------------------------+
> +    |                request memory              | 
> +    +--------------------------------------------+
> +        ^                                  ^
> +        |                                  |
> +        | Pool empty                       | Pool has entries
> +        |                                  |
> +        v                                  v
> +    +-----------------------+     +------------------------+       
> +    | alloc (and map) pages |     |  get page from cache   |
> +    +-----------------------+     +------------------------+
> +                                    ^                    ^
> +                                    |                    |
> +                                    | cache available    | No entries, refill
> +                                    |                    | from ptr-ring
> +                                    |                    |
> +                                    v                    v
> +                          +-----------------+     +------------------+  
> +                          |     Fast cache  |     |  ptr-ring cache  | 
> +                          +-----------------+     +------------------+
> +
> +API interface
> +=============
> +The number of pools created **must** match the number of hardware queues
> +unless hardware restrictions make that impossible. This would otherwise beat the
> +purpose of page pool, which is allocate pages fast from cache without locking.
> +This lockless guarantee naturally comes from running under a NAPI softirq.
> +The protection doesn't strictly has to be NAPI, any guarantee that allocating a

                                   have to be NAPI;

> +page will cause no race-conditions is enough.

                      race conditions

> +
> +* page_pool_create(): Create a pool.
> +    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV

what about 'order'?  is it optional?

> +    * pool_size:  size of the ptr_ring
> +    * nid:        preferred NUMA node for allocation
> +    * dev:        struct device. Used on DMA operations
> +    * dma_dir:    DMA direction
> +    * max_len:    max DMA sync memory size
> +    * offset:     DMA address offset
> +
> +* page_pool_put_page(): The outcome of this depends on the page refcnt. If the
> +  driver uses refcnt > 1 this will unmap the page. If the pool object is
> +  responsible for DMA operations and account for the in-flight counting. 

Hm, above is not a sentence and it ends with a space character.
Several lines end with a space character.  :(

> +  If the refcnt is 1, the allocator owns the page and will try to recycle and 
> +  sync it to be re-used by the device using dma_sync_single_range_for_device().
> +
> +* page_pool_release_page(): Unmap the page (if mapped) and account for it on
> +  inflight counters.

inflight is spelled as in-flight earlier.  Just choose one way, please.

> +
> +* page_pool_dev_alloc_pages(): Get a page from the page allocator or page_pool 
> +  caches.
> +
> +* page_pool_get_dma_addr(): Retrieve the stored DMA address.
> +
> +* page_pool_get_dma_dir(): Retrieve the stored DMA direction.
> +
> +* page_pool_recycle_direct(): Recycle the page immediately. Must be used under
> +  NAPI context
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
> +
> +
> +.. code-block:: c
> +
> +    /* NAPI Rx poller */
> +    enum dma_data_direction dma_dir;
> +
> +    dma_dir = page_pool_get_dma_dir(dring->page_pool);
> +    while (done < budget) {
> +        if (some error)
> +            page_pool_recycle_direct(page_pool, page);
> +        if (packet_is_xdp) {
> +            if XDP_DROP:
> +                page_pool_recycle_direct(page_pool, page);
> +        } else (packet_is_skb) {
> +            page_pool_release_page(page_pool, page);
> +            new_page = page_pool_dev_alloc_pages(page_pool);
> +        }
> +    }
> +    
> +Driver unload
> +-------------
> +
> +.. code-block:: c
> +    
> +    /* Driver unload */
> +    page_pool_put_page(page_pool, page, false);
> +    xdp_rxq_info_unreg(&xdp_rxq);
> +    page_pool_destroy(page_pool);
> 

thanks.
-- 
~Randy
