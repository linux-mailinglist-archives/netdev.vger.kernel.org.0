Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06437D2162
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbfJJHIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 03:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbfJJHIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 03:08:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0F3488384B;
        Thu, 10 Oct 2019 07:08:48 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F4415ED21;
        Thu, 10 Oct 2019 07:08:33 +0000 (UTC)
Date:   Thu, 10 Oct 2019 09:08:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191010090831.5d6c41f2@carbon>
In-Reply-To: <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
References: <cover.1570662004.git.lorenzo@kernel.org>
        <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 10 Oct 2019 07:08:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 01:18:34 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> mvneta driver can run on not cache coherent devices so it is
> necessary to sync dma buffers before sending them to the device
> in order to avoid memory corruption. This patch introduce a performance
> penalty and it is necessary to introduce a more sophisticated logic
> in order to avoid dma sync as much as we can

Report with benchmarks here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_espressobin08_bench_xdp.org

We are testing this on an Espressobin board, and do see a huge
performance cost associated with this DMA-sync.   Regardless we still
want to get this patch merged, to move forward with XDP support for
this driver. 

We promised each-other (on IRC freenode #xdp) that we will follow-up
with a solution/mitigation, after this patchset is merged.  There are
several ideas, that likely should get separate upstream review.

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 79a6bac0192b..ba4aa9bbc798 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  			    struct mvneta_rx_queue *rxq,
>  			    gfp_t gfp_mask)
>  {
> +	enum dma_data_direction dma_dir;
>  	dma_addr_t phys_addr;
>  	struct page *page;
>  
> @@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  		return -ENOMEM;
>  
>  	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> +	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> +	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> +				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
>  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
>  
>  	return 0;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
