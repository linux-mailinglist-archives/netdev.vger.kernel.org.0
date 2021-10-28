Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4E43D8B4
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhJ1BmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhJ1BmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977AF610FD;
        Thu, 28 Oct 2021 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635385177;
        bh=xkFahs+LkXzJAPcyet8YGPQgljBdb8edIwQPk96AQt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=khnJGAK0vkBGjaXPHgSYpqlFadspAUz907Xz5Wode8aXYNDcTC9Lu8Ppha8szZEmr
         KcHTBjFw2IWf+VJwejY9Ec0HHRK1LaFaP71vV+ioCfRlzQhAySSATUIC2XqjM7cetn
         aAb3UpZpo9m5T+nY1PuHuPPtbUyzK9xJjllTEDHIs6G5mFmw/UVv7yRVqxQOVpdZqN
         9mL3xL7rHK48eMp3Esqgc6keO6S8JgkzRkNygpXlVQh+J8tjT+oB++1BLQ0oVBy/Ay
         OJLj4x8phftSFNitarwjp7NlFon2tNafb4xoj2Sn5uZbjw69PEr49ySYdxTb+sy3I6
         mfclWPW3YW0zA==
Date:   Wed, 27 Oct 2021 20:39:34 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Dongdong Liu <liudongdong3@huawei.com>, hch@infradead.org,
        kw@linux.com, leon@kernel.org, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V10 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Message-ID: <20211028013934.GA267985@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <136155cc-d28c-ef36-c69b-557f7af456be@deltatee.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 05:41:07PM -0600, Logan Gunthorpe wrote:
> On 2021-10-27 5:11 p.m., Bjorn Helgaas wrote:
> >> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
> >>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> >>  	}
> >>  done:
> >> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
> >> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> > 
> > I need to be convinced that this check is in the right spot to catch
> > all potential P2PDMA situations.  The pci_p2pmem_find() and
> > pci_p2pdma_distance() interfaces eventually call
> > calc_map_type_and_dist().  But those interfaces don't actually produce
> > DMA bus addresses, and I'm not convinced that all P2PDMA users use
> > them.
> > 
> > nvme *does* use them, but infiniband (rdma_rw_map_sg()) does not, and
> > it calls pci_p2pdma_map_sg().
> 
> The rules of the current code is that calc_map_type_and_dist() must be
> called before pci_p2pdma_map_sg(). The calc function caches the mapping
> type in an xarray. If it was not called ahead of time,
> pci_p2pdma_map_type() will return PCI_P2PDMA_MAP_NOT_SUPPORTED, and the
> WARN_ON_ONCE will be hit in
> pci_p2pdma_map_sg_attrs().

Seems like it requires fairly deep analysis to prove all this.  Is
this something we don't want to put directly in the map path because
it's a hot path, or it just doesn't fit there in the model, or ...?

> Both NVMe and RDMA (only used in the nvme fabrics code) do the correct
> thing here and we can be sure calc_map_type_and_dist() is called before
> any pages are mapped.
> 
> The patch set I'm currently working on will ensure that
> calc_map_type_and_dist() is called before anyone maps a PCI P2PDMA page
> with dma_map_sg*().
> 
> > amdgpu_dma_buf_attach() calls pci_p2pdma_distance_many() but I don't
> > know where it sets up P2PDMA transactions.
> 
> The amdgpu driver hacked this in before proper support was done, but at
> least it's using pci_p2pdma_distance_many() presumably before trying any
> transfer. Though it's likely broken as it doesn't take into account the
> mapping type and thus I think it always assumes traffic goes through the
> host bridge (seeing it doesn't use pci_p2pdma_map_sg()).

What does it mean to go through the host bridge?  Obviously DMA to
system memory would go through the host bridge, but this seems
different.  Is this a "between PCI hierarchies" case like to a device
below a different root port?  I don't know what the tag rules are for
that.

> > cxgb4 and qed mention "peer2peer", but I don't know whether they are
> > related; they don't seem to use any pci_p2p.* interfaces.
> 
> I'm really not sure what these drivers are doing at all. However, I
> think this is unrelated based on this old patch description[1]:
> 
>   Open MPI, Intel MPI and other applications don't support the iWARP
>   requirement that the client side send the first RDMA message. This
>   class of application connection setup is called peer-2-peer. Typically
>   once the connection is setup, _both_ sides want to send data.
> 
>   This patch enables supporting peer-2-peer over the chelsio rnic by
>   enforcing this iWARP requirement in the driver itself as part of RDMA
>   connection setup.

Thanks!

> Logan
> 
> [1] http://lkml.iu.edu/hypermail/linux/kernel/0804.3/1416.html
