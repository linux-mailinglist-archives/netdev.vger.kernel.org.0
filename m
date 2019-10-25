Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7ACBE5109
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505437AbfJYQTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:19:02 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:60042 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502249AbfJYQTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:19:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2019 12:19:01 EDT
Received: (qmail 62457 invoked by uid 89); 25 Oct 2019 16:12:21 -0000
Received: from unknown (HELO ?172.20.54.239?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMjk=) (POLARISLOCAL)  
  by smtp4.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 25 Oct 2019 16:12:21 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Laurentiu Tudor" <laurentiu.tudor@nxp.com>
Cc:     hch@lst.de, joro@8bytes.org,
        "Ioana Ciocoi Radulescu" <ruxandra.radulescu@nxp.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, "Ioana Ciornei" <ioana.ciornei@nxp.com>,
        "Leo Li" <leoyang.li@nxp.com>, robin.murphy@arm.com,
        "Diana Madalina Craciun" <diana.craciun@nxp.com>,
        davem@davemloft.net, "Madalin Bucur" <madalin.bucur@nxp.com>
Subject: Re: [PATCH v2 3/3] dpaa2_eth: use new unmap and sync dma api variants
Date:   Fri, 25 Oct 2019 09:12:15 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <BC2F1623-D8A5-4A6E-BAF4-5C551637E472@flugsvamp.com>
In-Reply-To: <20191024124130.16871-4-laurentiu.tudor@nxp.com>
References: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
 <20191024124130.16871-4-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24 Oct 2019, at 5:41, Laurentiu Tudor wrote:

> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>
> Convert this driver to usage of the newly introduced dma unmap and
> sync DMA APIs. This will get rid of the unsupported direct usage of
> iommu_iova_to_phys() API.
>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 40 
> +++++++------------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
>  2 files changed, 15 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c 
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 19379bae0144..8c3391e6e598 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -29,16 +29,6 @@ MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Freescale Semiconductor, Inc");
>  MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
>
> -static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
> -				dma_addr_t iova_addr)
> -{
> -	phys_addr_t phys_addr;
> -
> -	phys_addr = domain ? iommu_iova_to_phys(domain, iova_addr) : 
> iova_addr;
> -
> -	return phys_to_virt(phys_addr);
> -}
> -
>  static void validate_rx_csum(struct dpaa2_eth_priv *priv,
>  			     u32 fd_status,
>  			     struct sk_buff *skb)
> @@ -85,9 +75,10 @@ static void free_rx_fd(struct dpaa2_eth_priv *priv,
>  	sgt = vaddr + dpaa2_fd_get_offset(fd);
>  	for (i = 1; i < DPAA2_ETH_MAX_SG_ENTRIES; i++) {
>  		addr = dpaa2_sg_get_addr(&sgt[i]);
> -		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
> -		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
> -			       DMA_BIDIRECTIONAL);
> +		sg_vaddr = page_to_virt
> +				(dma_unmap_page_desc(dev, addr,
> +						    DPAA2_ETH_RX_BUF_SIZE,
> +						    DMA_BIDIRECTIONAL));

This is doing virt -> page -> virt.  Why not just have the new
function return the VA corresponding to the addr, which would
match the other functions?
-- 
Jonathan


>
>  		free_pages((unsigned long)sg_vaddr, 0);
>  		if (dpaa2_sg_is_final(&sgt[i]))
> @@ -143,9 +134,10 @@ static struct sk_buff *build_frag_skb(struct 
> dpaa2_eth_priv *priv,
>
>  		/* Get the address and length from the S/G entry */
>  		sg_addr = dpaa2_sg_get_addr(sge);
> -		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, sg_addr);
> -		dma_unmap_page(dev, sg_addr, DPAA2_ETH_RX_BUF_SIZE,
> -			       DMA_BIDIRECTIONAL);
> +		sg_vaddr = page_to_virt
> +				(dma_unmap_page_desc(dev, sg_addr,
> +						    DPAA2_ETH_RX_BUF_SIZE,
> +						    DMA_BIDIRECTIONAL));
>
>  		sg_length = dpaa2_sg_get_len(sge);
>
> @@ -210,9 +202,9 @@ static void free_bufs(struct dpaa2_eth_priv *priv, 
> u64 *buf_array, int count)
>  	int i;
>
>  	for (i = 0; i < count; i++) {
> -		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
> -		dma_unmap_page(dev, buf_array[i], DPAA2_ETH_RX_BUF_SIZE,
> -			       DMA_BIDIRECTIONAL);
> +		vaddr = page_to_virt(dma_unmap_page_desc(dev, buf_array[i],
> +							 DPAA2_ETH_RX_BUF_SIZE,
> +							 DMA_BIDIRECTIONAL));
>  		free_pages((unsigned long)vaddr, 0);
>  	}
>  }
> @@ -369,9 +361,8 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv 
> *priv,
>  	/* Tracing point */
>  	trace_dpaa2_rx_fd(priv->net_dev, fd);
>
> -	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
> -	dma_sync_single_for_cpu(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
> -				DMA_BIDIRECTIONAL);
> +	vaddr = dma_sync_single_for_cpu_desc(dev, addr, 
> DPAA2_ETH_RX_BUF_SIZE,
> +					     DMA_BIDIRECTIONAL);
>
>  	fas = dpaa2_get_fas(vaddr, false);
>  	prefetch(fas);
> @@ -682,7 +673,8 @@ static void free_tx_fd(const struct dpaa2_eth_priv 
> *priv,
>  	u32 fd_len = dpaa2_fd_get_len(fd);
>
>  	fd_addr = dpaa2_fd_get_addr(fd);
> -	buffer_start = dpaa2_iova_to_virt(priv->iommu_domain, fd_addr);
> +	buffer_start = dma_sync_single_for_cpu_desc(dev, fd_addr, 
> sizeof(*swa),
> +						    DMA_BIDIRECTIONAL);
>  	swa = (struct dpaa2_eth_swa *)buffer_start;
>
>  	if (fd_format == dpaa2_fd_single) {
> @@ -3448,8 +3440,6 @@ static int dpaa2_eth_probe(struct fsl_mc_device 
> *dpni_dev)
>  	priv = netdev_priv(net_dev);
>  	priv->net_dev = net_dev;
>
> -	priv->iommu_domain = iommu_get_domain_for_dev(dev);
> -
>  	/* Obtain a MC portal */
>  	err = fsl_mc_portal_allocate(dpni_dev, 
> FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
>  				     &priv->mc_io);
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h 
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> index 8a0e65b3267f..4e5183617ebd 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> @@ -374,7 +374,6 @@ struct dpaa2_eth_priv {
>
>  	struct fsl_mc_device *dpbp_dev;
>  	u16 bpid;
> -	struct iommu_domain *iommu_domain;
>
>  	bool tx_tstamp; /* Tx timestamping enabled */
>  	bool rx_tstamp; /* Rx timestamping enabled */
> -- 
> 2.17.1
