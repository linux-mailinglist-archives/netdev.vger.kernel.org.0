Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8D16EBD75
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 08:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjDWGp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 02:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDWGp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 02:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C09EE44;
        Sat, 22 Apr 2023 23:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A784D60E06;
        Sun, 23 Apr 2023 06:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE8CC433EF;
        Sun, 23 Apr 2023 06:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682232324;
        bh=6U3YK+jrkCeYg2VcFTGvmYY91foHisTgGR6l+rzIBs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upsdKEMCi6YShWBP+knnDO06sugKBkjejsf/HXK7WHgAq48Q/r4B8fb/GBZ3K+CD4
         dwJl+8grCqHYhHVG2P3bbgiBLoBAbVnd7D2kA82JDNSV7YoXUa9kqI9L39aj3bD1FM
         KOQ2iIoibBZ829K1gt5f/UTex5zDI6GWB3eIrCP0=
Date:   Sun, 23 Apr 2023 08:45:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH net-next v1] xsk: introduce xsk_dma_cbs
Message-ID: <ZETUAMqKc8iLhTk3@kroah.com>
References: <20230423062546.96880-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423062546.96880-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 02:25:45PM +0800, Xuan Zhuo wrote:
> The purpose of this patch is to allow driver pass the own dma callbacks
> to xsk.
> 
> This is to cope with the scene of virtio-net. If virtio does not have
> VIRTIO_F_ACCESS_PLATFORM, then virtio cannot use DMA API. In this case,
> xsk cannot use DMA API directly to achieve DMA address. Based on this
> scene, we must let xsk support driver to use the driver's dma callbacks.

Why does virtio need to use dma?  That seems to go against the overall
goal of virtio's new security restrictions that are being proposed
(where they do NOT want it to use dma as it is not secure).

And why is virtio special here?  If you have access to a device, it
should have all of the needed dma hooks already set up based on the
bus it is on.  Or is the issue you don't have a real bus set up?  If so,
why not fix that?

> More is here:
>     https://lore.kernel.org/virtualization/1681265026.6082013-1-xuanzhuo@linux.alibaba.com/
>     https://lore.kernel.org/all/20230421065059.1bc78133@kernel.org

Am I missing the user of this new api?  Don't you need to submit that at
the same time so we can at least see if this new api works properly?

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  include/net/xdp_sock_drv.h  | 20 ++++++++++-
>  include/net/xsk_buff_pool.h | 19 ++++++++++
>  net/xdp/xsk_buff_pool.c     | 71 +++++++++++++++++++++++++++----------
>  3 files changed, 90 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 9c0d860609ba..8b5284b272e4 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -67,7 +67,17 @@ static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
>  {
>  	struct xdp_umem *umem = pool->umem;
>  
> -	return xp_dma_map(pool, dev, attrs, umem->pgs, umem->npgs);
> +	return xp_dma_map(pool, dev, NULL, attrs, umem->pgs, umem->npgs);
> +}
> +
> +static inline int xsk_pool_dma_map_with_cbs(struct xsk_buff_pool *pool,
> +					    struct device *dev,
> +					    struct xsk_dma_cbs *dma_cbs,
> +					    unsigned long attrs)
> +{
> +	struct xdp_umem *umem = pool->umem;
> +
> +	return xp_dma_map(pool, dev, dma_cbs, attrs, umem->pgs, umem->npgs);
>  }
>  
>  static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
> @@ -226,6 +236,14 @@ static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
>  	return 0;
>  }
>  
> +static inline int xsk_pool_dma_map_with_cbs(struct xsk_buff_pool *pool,
> +					    struct device *dev,
> +					    struct xsk_dma_cbs *dma_cbs,
> +					    unsigned long attrs)
> +{
> +	return 0;
> +}
> +
>  static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
>  {
>  	return 0;
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..2de88be9188b 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -43,6 +43,23 @@ struct xsk_dma_map {
>  	bool dma_need_sync;
>  };
>  
> +struct xsk_dma_cbs {
> +	dma_addr_t (*map_page)(struct device *dev, struct page *page,

Why are you working on a "raw" struct device here and everywhere else?
Are you sure that is ok?  What is it needed for?

> +			       size_t offset, size_t size,
> +			       enum dma_data_direction dir, unsigned long attrs);
> +	void (*unmap_page)(struct device *dev, dma_addr_t addr,
> +			   size_t size, enum dma_data_direction dir,
> +			   unsigned long attrs);
> +	int (*mapping_error)(struct device *dev, dma_addr_t addr);
> +	bool (*need_sync)(struct device *dev, dma_addr_t addr);
> +	void (*sync_single_range_for_cpu)(struct device *dev, dma_addr_t addr,
> +					  size_t offset, size_t size,
> +					  enum dma_data_direction dir);
> +	void (*sync_single_range_for_device)(struct device *dev, dma_addr_t addr,
> +					     size_t offset, size_t size,
> +					     enum dma_data_direction dir);
> +};

No documentation for any of these callbacks?  Please use kerneldoc so we
at least have a clue as to what they should be doing.

> +
>  struct xsk_buff_pool {
>  	/* Members only used in the control path first. */
>  	struct device *dev;
> @@ -85,6 +102,7 @@ struct xsk_buff_pool {
>  	 * sockets share a single cq when the same netdev and queue id is shared.
>  	 */
>  	spinlock_t cq_lock;
> +	struct xsk_dma_cbs *dma_cbs;
>  	struct xdp_buff_xsk *free_heads[];
>  };
>  
> @@ -131,6 +149,7 @@ static inline void xp_init_xskb_dma(struct xdp_buff_xsk *xskb, struct xsk_buff_p
>  /* AF_XDP ZC drivers, via xdp_sock_buff.h */
>  void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq);
>  int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> +	       struct xsk_dma_cbs *dma_cbs,
>  	       unsigned long attrs, struct page **pages, u32 nr_pages);
>  void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
>  struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..e7e6c91f6e51 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -328,7 +328,8 @@ static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
>  	kfree(dma_map);
>  }
>  
> -static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
> +static void __xp_dma_unmap(struct xsk_dma_map *dma_map,
> +			   struct xsk_dma_cbs *dma_cbs, unsigned long attrs)
>  {
>  	dma_addr_t *dma;
>  	u32 i;
> @@ -337,8 +338,12 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
>  		dma = &dma_map->dma_pages[i];
>  		if (*dma) {
>  			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
> -			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
> -					     DMA_BIDIRECTIONAL, attrs);
> +			if (unlikely(dma_cbs))

If you can not measure the use of likely/unlikely in a benchmark, then
you should never use it as the compiler and CPU will work better without
it (and will work better over time as hardware and compiler change).

thanks,

greg k-h
