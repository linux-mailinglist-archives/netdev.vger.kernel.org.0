Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC36F34E7C9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhC3MrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231853AbhC3Mq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3199619B1;
        Tue, 30 Mar 2021 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617108417;
        bh=Gp7K5d/9JkaqMV3qnVlhi8uY18tBiGcqTqq9JQwzkk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpwoXfzSTI3OVxxT2qtuhI8DBVsGK1w2yo1XJO96Mcl6Cf7j98u0D7WhigRHOVp76
         jDVKAszVft1N//apcCn6FfTFty159qo7bzFF1FayYDictlQn2pRCLv717rqFyesXh6
         g/qwrAId2++/WokGRt8nGZEDGbvdPTeM6c+yqRQokfC3Qr+akdDdbTY7EJdRxABvTD
         356fURN2pLtcawXNYFkMj/4iVtdUrMed1IC/yAYXh7FliEQtMGcEDxYEIh/YHATK5l
         0cbhI80eGEGy6vBu0Pz0nymgiC2g+OQuCq7/dYQEV4VJ4nIDFcytvB+5jrYD5CldVL
         VUbbcLl88d4eQ==
Date:   Tue, 30 Mar 2021 13:46:51 +0100
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/18] iommu/fsl_pamu: merge pamu_set_liodn and map_liodn
Message-ID: <20210330124651.GH5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-9-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:14PM +0100, Christoph Hellwig wrote:
> Merge the two fuctions that configure the ppaace into a single coherent
> function.  I somehow doubt we need the two pamu_config_ppaace calls,
> but keep the existing behavior just to be on the safe side.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 65 +++++++++------------------------
>  1 file changed, 17 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
> index 40eff4b7bc5d42..4a4944332674f7 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -54,25 +54,6 @@ static int __init iommu_init_mempool(void)
>  	return 0;
>  }
>  
> -/* Map the DMA window corresponding to the LIODN */
> -static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
> -{
> -	int ret;
> -	struct iommu_domain_geometry *geom = &dma_domain->iommu_domain.geometry;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&iommu_lock, flags);
> -	ret = pamu_config_ppaace(liodn, geom->aperture_start,
> -				 geom->aperture_end - 1, ~(u32)0,
> -				 0, dma_domain->snoop_id, dma_domain->stash_id,
> -				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);
> -	spin_unlock_irqrestore(&iommu_lock, flags);
> -	if (ret)
> -		pr_debug("PAACE configuration failed for liodn %d\n", liodn);
> -
> -	return ret;
> -}
> -
>  static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
>  			      u32 val)
>  {
> @@ -94,11 +75,11 @@ static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
>  }
>  
>  /* Set the geometry parameters for a LIODN */
> -static int pamu_set_liodn(int liodn, struct device *dev,
> -			  struct fsl_dma_domain *dma_domain,
> -			  struct iommu_domain_geometry *geom_attr)
> +static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
> +			  int liodn)
>  {
> -	phys_addr_t window_addr, window_size;
> +	struct iommu_domain *domain = &dma_domain->iommu_domain;
> +	struct iommu_domain_geometry *geom = &domain->geometry;
>  	u32 omi_index = ~(u32)0;
>  	unsigned long flags;
>  	int ret;
> @@ -110,22 +91,25 @@ static int pamu_set_liodn(int liodn, struct device *dev,
>  	 */
>  	get_ome_index(&omi_index, dev);
>  
> -	window_addr = geom_attr->aperture_start;
> -	window_size = geom_attr->aperture_end + 1;
> -
>  	spin_lock_irqsave(&iommu_lock, flags);
>  	ret = pamu_disable_liodn(liodn);
> -	if (!ret)
> -		ret = pamu_config_ppaace(liodn, window_addr, window_size, omi_index,
> -					 0, dma_domain->snoop_id,
> -					 dma_domain->stash_id, 0);
> +	if (ret)
> +		goto out_unlock;
> +	ret = pamu_config_ppaace(liodn, geom->aperture_start,
> +				 geom->aperture_end - 1, omi_index, 0,
> +				 dma_domain->snoop_id, dma_domain->stash_id, 0);
> +	if (ret)
> +		goto out_unlock;
> +	ret = pamu_config_ppaace(liodn, geom->aperture_start,
> +				 geom->aperture_end - 1, ~(u32)0,
> +				 0, dma_domain->snoop_id, dma_domain->stash_id,
> +				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);

There's more '+1' / '-1' confusion here with aperture_end which I'm not
managing to follow. What am I missing?

Will
