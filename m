Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA71FCCE9
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKNSOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:14:25 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:28963 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfKNSOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:14:25 -0500
Received: (qmail 19684 invoked by uid 89); 14 Nov 2019 18:14:23 -0000
Received: from unknown (HELO ?172.20.189.1?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4z) (POLARISLOCAL)  
  by smtp1.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 14 Nov 2019 18:14:23 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 3/3] net: mvneta: get rid of huge DMA sync in
 mvneta_rx_refill
Date:   Thu, 14 Nov 2019 10:14:19 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <79304C3A-EC21-4D15-8D03-BA035D9E0F4C@flugsvamp.com>
In-Reply-To: <b18159e702ec28bb33c492da216a12eaf3e7490c.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <b18159e702ec28bb33c492da216a12eaf3e7490c.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Nov 2019, at 4:09, Lorenzo Bianconi wrote:

> Get rid of costly dma_sync_single_for_device in mvneta_rx_refill
> since now the driver can let page_pool API to manage needed DMA
> sync with a proper size.
>
> - XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
> - XDP_DROP DMA sync managed by page_pool API:	~595Kpps
>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c 
> b/drivers/net/ethernet/marvell/mvneta.c
> index ed93eecb7485..591d580c68b4 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1846,7 +1846,6 @@ static int mvneta_rx_refill(struct mvneta_port 
> *pp,
>  			    struct mvneta_rx_queue *rxq,
>  			    gfp_t gfp_mask)
>  {
> -	enum dma_data_direction dma_dir;
>  	dma_addr_t phys_addr;
>  	struct page *page;
>
> @@ -1856,9 +1855,6 @@ static int mvneta_rx_refill(struct mvneta_port 
> *pp,
>  		return -ENOMEM;
>
>  	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> -	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> -	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> -				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
>  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
>
>  	return 0;
> @@ -2097,8 +2093,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct 
> mvneta_rx_queue *rxq,
>  		err = xdp_do_redirect(pp->dev, xdp, prog);
>  		if (err) {
>  			ret = MVNETA_XDP_DROPPED;
> -			page_pool_recycle_direct(rxq->page_pool,
> -						 virt_to_head_page(xdp->data));
> +			__page_pool_put_page(rxq->page_pool,
> +					virt_to_head_page(xdp->data),
> +					xdp->data_end - xdp->data_hard_start,
> +					true);

I just have a clarifying question.  Here, the RX buffer was received and 
then
dma_sync'd to the CPU.  Now, it is going to be recycled for RX again; 
does it
actually need to be sync'd back to the device?

I'm asking since several of the other network drivers (mellanox, for 
example)
don't resync the buffer back to the device when recycling it for reuse.
-- 
Jonathan
