Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE725FC97
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGDRjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:39:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfGDRjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 13:39:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BCE9356F5;
        Thu,  4 Jul 2019 17:39:52 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3383B9CB0;
        Thu,  4 Jul 2019 17:39:45 +0000 (UTC)
Date:   Thu, 4 Jul 2019 19:39:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        arnd@arndb.de
Subject: Re: [net-next, PATCH, v2] net: netsec: Sync dma for device on
 buffer allocation
Message-ID: <20190704193944.5ef80468@carbon>
In-Reply-To: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 04 Jul 2019 17:39:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jul 2019 17:46:09 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Quoting Arnd,
> 
> We have to do a sync_single_for_device /somewhere/ before the
> buffer is given to the device. On a non-cache-coherent machine with
> a write-back cache, there may be dirty cache lines that get written back
> after the device DMA's data into it (e.g. from a previous memset
> from before the buffer got freed), so you absolutely need to flush any
> dirty cache lines on it first.
> 
> Since the coherency is configurable in this device make sure we cover
> all configurations by explicitly syncing the allocated buffer for the
> device before refilling it's descriptors
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
> 
> Changes since V1: 
> - Make the code more readable
>  
>  drivers/net/ethernet/socionext/netsec.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 5544a722543f..ada7626bf3a2 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -727,21 +727,26 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
>  {
>  
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> +	enum dma_data_direction dma_dir;
> +	dma_addr_t dma_start;
>  	struct page *page;
>  
>  	page = page_pool_dev_alloc_pages(dring->page_pool);
>  	if (!page)
>  		return NULL;
>  
> +	dma_start = page_pool_get_dma_addr(page);
>  	/* We allocate the same buffer length for XDP and non-XDP cases.
>  	 * page_pool API will map the whole page, skip what's needed for
>  	 * network payloads and/or XDP
>  	 */
> -	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
> +	*dma_handle = dma_start + NETSEC_RXBUF_HEADROOM;
>  	/* Make sure the incoming payload fits in the page for XDP and non-XDP
>  	 * cases and reserve enough space for headroom + skb_shared_info
>  	 */
>  	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> +	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> +	dma_sync_single_for_device(priv->dev, dma_start, PAGE_SIZE, dma_dir);

It's it costly to sync_for_device the entire page size?

E.g. we already know that the head-room is not touched by device.  And
we actually want this head-room cache-hot for e.g. xdp_frame, thus it
would be unfortunate if the head-room is explicitly evicted from the
cache here.

Even smarter, the driver could do the sync for_device, when it
release/recycle page, as it likely know the exact length that was used
by the packet.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
