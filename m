Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1908234E9BE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhC3N6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232053AbhC3N6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E7D619BD;
        Tue, 30 Mar 2021 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617112687;
        bh=hYRhNMLlTmRS49zqmK73a4rY3ELSUI6jQmXx6ZVo0cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxQyKHu5yHesTmxq2PlalF5XHUJ/+Rz412pFuRTbOozoN7Mb60JpgX7hut5OdEhIO
         3lhluE7Xa6MpXg3B8jJjwxAjN02v/8u9IIZbCapDIo4/QtFBPU0zmQmESgHa2t7Seu
         6BfPY0dg5NZYx/R7AOola1TbKI9OxKnLxPZP+rpYYr6+R5Ndgmvd/j0LAJoV9qX48G
         HdxYp8mDmAdckAQuEcf27Px7bJMTyHZRvvOYlBEvaxIhQdMxNFZle45RAuCX5K6jbI
         VaV9P5LlYytyR5H+pRG+Kw1836+9tx7uFAyXMe0zIdPnrbYLEXjvHvSEw1AHvXRIao
         Ee9HUuuOMjrmw==
Date:   Tue, 30 Mar 2021 14:58:02 +0100
From:   Will Deacon <will@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Message-ID: <20210330135801.GA6187@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-17-hch@lst.de>
 <20210330131149.GP5908@willie-the-truck>
 <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 02:19:38PM +0100, Robin Murphy wrote:
> On 2021-03-30 14:11, Will Deacon wrote:
> > On Tue, Mar 16, 2021 at 04:38:22PM +0100, Christoph Hellwig wrote:
> > > From: Robin Murphy <robin.murphy@arm.com>
> > > 
> > > Instead make the global iommu_dma_strict paramete in iommu.c canonical by
> > > exporting helpers to get and set it and use those directly in the drivers.
> > > 
> > > This make sure that the iommu.strict parameter also works for the AMD and
> > > Intel IOMMU drivers on x86.  As those default to lazy flushing a new
> > > IOMMU_CMD_LINE_STRICT is used to turn the value into a tristate to
> > > represent the default if not overriden by an explicit parameter.
> > > 
> > > Signed-off-by: Robin Murphy <robin.murphy@arm.com>.
> > > [ported on top of the other iommu_attr changes and added a few small
> > >   missing bits]
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >   drivers/iommu/amd/iommu.c                   | 23 +-------
> > >   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 50 +---------------
> > >   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
> > >   drivers/iommu/arm/arm-smmu/arm-smmu.c       | 27 +--------
> > >   drivers/iommu/dma-iommu.c                   |  9 +--
> > >   drivers/iommu/intel/iommu.c                 | 64 ++++-----------------
> > >   drivers/iommu/iommu.c                       | 27 ++++++---
> > >   include/linux/iommu.h                       |  4 +-
> > >   8 files changed, 40 insertions(+), 165 deletions(-)
> > 
> > I really like this cleanup, but I can't help wonder if it's going in the
> > wrong direction. With SoCs often having multiple IOMMU instances and a
> > distinction between "trusted" and "untrusted" devices, then having the
> > flush-queue enabled on a per-IOMMU or per-domain basis doesn't sound
> > unreasonable to me, but this change makes it a global property.
> 
> The intent here was just to streamline the existing behaviour of stuffing a
> global property into a domain attribute then pulling it out again in the
> illusion that it was in any way per-domain. We're still checking
> dev_is_untrusted() before making an actual decision, and it's not like we
> can't add more factors at that point if we want to.

Like I say, the cleanup is great. I'm just wondering whether there's a
better way to express the complicated logic to decide whether or not to use
the flush queue than what we end up with:

	if (!cookie->fq_domain && (!dev || !dev_is_untrusted(dev)) &&
	    domain->ops->flush_iotlb_all && !iommu_get_dma_strict())

which is mixing up globals, device properties and domain properties. The
result is that the driver code ends up just using the global to determine
whether or not to pass IO_PGTABLE_QUIRK_NON_STRICT to the page-table code,
which is a departure from the current way of doing things.

> > For example, see the recent patch from Lu Baolu:
> > 
> > https://lore.kernel.org/r/20210225061454.2864009-1-baolu.lu@linux.intel.com
> 
> Erm, this patch is based on that one, it's right there in the context :/

Ah, sorry, I didn't spot that! I was just trying to illustrate that this
is per-device.

Will
