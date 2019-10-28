Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09928E708B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 12:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbfJ1LiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 07:38:19 -0400
Received: from verein.lst.de ([213.95.11.211]:34037 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfJ1LiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 07:38:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C917068BE1; Mon, 28 Oct 2019 12:38:16 +0100 (CET)
Date:   Mon, 28 Oct 2019 12:38:16 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Jonathan Lemon <jlemon@flugsvamp.com>, "hch@lst.de" <hch@lst.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [PATCH v2 3/3] dpaa2_eth: use new unmap and sync dma api
 variants
Message-ID: <20191028113816.GB24055@lst.de>
References: <20191024124130.16871-1-laurentiu.tudor@nxp.com> <20191024124130.16871-4-laurentiu.tudor@nxp.com> <BC2F1623-D8A5-4A6E-BAF4-5C551637E472@flugsvamp.com> <00a138f0-3651-5441-7241-5f02956b6c2c@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00a138f0-3651-5441-7241-5f02956b6c2c@nxp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 10:55:05AM +0000, Laurentiu Tudor wrote:
> >> @@ -85,9 +75,10 @@ static void free_rx_fd(struct dpaa2_eth_priv *priv,
> >>      sgt = vaddr + dpaa2_fd_get_offset(fd);
> >>      for (i = 1; i < DPAA2_ETH_MAX_SG_ENTRIES; i++) {
> >>          addr = dpaa2_sg_get_addr(&sgt[i]);
> >> -        sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
> >> -        dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
> >> -                   DMA_BIDIRECTIONAL);
> >> +        sg_vaddr = page_to_virt
> >> +                (dma_unmap_page_desc(dev, addr,
> >> +                            DPAA2_ETH_RX_BUF_SIZE,
> >> +                            DMA_BIDIRECTIONAL));
> > 
> > This is doing virt -> page -> virt.  Why not just have the new
> > function return the VA corresponding to the addr, which would
> > match the other functions?
> 
> I'd really like that as it would get rid of the page_to_virt() calls but 
> it will break the symmetry with the dma_map_page() API. I'll let the 
> maintainers decide.

It would be symmetric with dma_map_single, though.  Maybe we need
both variants?
