Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0694350382
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhCaPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235702AbhCaPdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 11:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E51260FEC;
        Wed, 31 Mar 2021 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617204782;
        bh=VEAokRAUwmqk6b1XNvz8xq2ssgOe8XarXhR7rguGo64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CcBcHfkJsWOGdBJ54F4tHzTqX8odPThBv/+nD0XArAtpvbHrAUS3tfD4yLFqBUaXA
         QIInRYII0xdx1nOaRk+v0SR3QhU7nQpWQvM9VNaJVeQhfC5WlD8XyuyDp4rA8fB3AC
         qzeNuO8OLYAUJTsUGZw7wRW0Gfsjg/mq1nhGmLolpbwE//OYgdwBNalxL0IxznuQrK
         utcZFNOfP8j+Phf/ENFUerPLJ0/uDGWVsR5mmQHpALnrqdH0ffLWfYgIIAPRdTOAnA
         8dcoEDthoYC+/5HqphI9KhMkMzfNppf0PCUVFfgYM5FnvGgHzJ5E2cOcTyJ8oPhL3s
         OVTrYXihR510A==
Date:   Wed, 31 Mar 2021 16:32:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Message-ID: <20210331153256.GA7815@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-17-hch@lst.de>
 <20210330131149.GP5908@willie-the-truck>
 <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com>
 <20210330135801.GA6187@willie-the-truck>
 <578d6aa5-4239-f5d7-2e9f-686b18e52bba@arm.com>
 <20210331114947.GA7626@willie-the-truck>
 <ef895942-e115-7878-ab86-37e8a1614df5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef895942-e115-7878-ab86-37e8a1614df5@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 02:09:37PM +0100, Robin Murphy wrote:
> On 2021-03-31 12:49, Will Deacon wrote:
> > On Tue, Mar 30, 2021 at 05:28:19PM +0100, Robin Murphy wrote:
> > > On 2021-03-30 14:58, Will Deacon wrote:
> > > > On Tue, Mar 30, 2021 at 02:19:38PM +0100, Robin Murphy wrote:
> > > > > On 2021-03-30 14:11, Will Deacon wrote:
> > > > > > On Tue, Mar 16, 2021 at 04:38:22PM +0100, Christoph Hellwig wrote:
> > > > > > > From: Robin Murphy <robin.murphy@arm.com>
> > > > > > > 
> > > > > > > Instead make the global iommu_dma_strict paramete in iommu.c canonical by
> > > > > > > exporting helpers to get and set it and use those directly in the drivers.
> > > > > > > 
> > > > > > > This make sure that the iommu.strict parameter also works for the AMD and
> > > > > > > Intel IOMMU drivers on x86.  As those default to lazy flushing a new
> > > > > > > IOMMU_CMD_LINE_STRICT is used to turn the value into a tristate to
> > > > > > > represent the default if not overriden by an explicit parameter.
> > > > > > > 
> > > > > > > Signed-off-by: Robin Murphy <robin.murphy@arm.com>.
> > > > > > > [ported on top of the other iommu_attr changes and added a few small
> > > > > > >     missing bits]
> > > > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > > > ---
> > > > > > >     drivers/iommu/amd/iommu.c                   | 23 +-------
> > > > > > >     drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 50 +---------------
> > > > > > >     drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
> > > > > > >     drivers/iommu/arm/arm-smmu/arm-smmu.c       | 27 +--------
> > > > > > >     drivers/iommu/dma-iommu.c                   |  9 +--
> > > > > > >     drivers/iommu/intel/iommu.c                 | 64 ++++-----------------
> > > > > > >     drivers/iommu/iommu.c                       | 27 ++++++---
> > > > > > >     include/linux/iommu.h                       |  4 +-
> > > > > > >     8 files changed, 40 insertions(+), 165 deletions(-)
> > > > > > 
> > > > > > I really like this cleanup, but I can't help wonder if it's going in the
> > > > > > wrong direction. With SoCs often having multiple IOMMU instances and a
> > > > > > distinction between "trusted" and "untrusted" devices, then having the
> > > > > > flush-queue enabled on a per-IOMMU or per-domain basis doesn't sound
> > > > > > unreasonable to me, but this change makes it a global property.
> > > > > 
> > > > > The intent here was just to streamline the existing behaviour of stuffing a
> > > > > global property into a domain attribute then pulling it out again in the
> > > > > illusion that it was in any way per-domain. We're still checking
> > > > > dev_is_untrusted() before making an actual decision, and it's not like we
> > > > > can't add more factors at that point if we want to.
> > > > 
> > > > Like I say, the cleanup is great. I'm just wondering whether there's a
> > > > better way to express the complicated logic to decide whether or not to use
> > > > the flush queue than what we end up with:
> > > > 
> > > > 	if (!cookie->fq_domain && (!dev || !dev_is_untrusted(dev)) &&
> > > > 	    domain->ops->flush_iotlb_all && !iommu_get_dma_strict())
> > > > 
> > > > which is mixing up globals, device properties and domain properties. The
> > > > result is that the driver code ends up just using the global to determine
> > > > whether or not to pass IO_PGTABLE_QUIRK_NON_STRICT to the page-table code,
> > > > which is a departure from the current way of doing things.
> > > 
> > > But previously, SMMU only ever saw the global policy piped through the
> > > domain attribute by iommu_group_alloc_default_domain(), so there's no
> > > functional change there.
> > 
> > For DMA domains sure, but I don't think that's the case for unmanaged
> > domains such as those used by VFIO.
> 
> Eh? This is only relevant to DMA domains anyway. Flush queues are part of
> the IOVA allocator that VFIO doesn't even use. It's always been the case
> that unmanaged domains only use strict invalidation.

Maybe I'm going mad. With this patch, the SMMU driver unconditionally sets
IO_PGTABLE_QUIRK_NON_STRICT for page-tables if iommu_get_dma_strict() is
true, no? In which case, that will get set for page-tables corresponding
to unmanaged domains as well as DMA domains when it is enabled. That didn't
happen before because you couldn't set the attribute for unmanaged domains.

What am I missing?

> > > Obviously some of the above checks could be factored out into some kind of
> > > iommu_use_flush_queue() helper that IOMMU drivers can also call if they need
> > > to keep in sync. Or maybe we just allow iommu-dma to set
> > > IO_PGTABLE_QUIRK_NON_STRICT directly via iommu_set_pgtable_quirks() if we're
> > > treating that as a generic thing now.
> > 
> > I think a helper that takes a domain would be a good starting point.
> 
> You mean device, right? The one condition we currently have is at the device
> level, and there's really nothing inherent to the domain itself that matters
> (since the type is implicitly IOMMU_DOMAIN_DMA to even care about this).

Device would probably work too; you'd pass the first device to attach to the
domain when querying this from the SMMU driver, I suppose.

Will
