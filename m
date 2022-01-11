Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108A948AA1B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349138AbiAKJFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 04:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiAKJFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:05:53 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DAC061756
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:05:53 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q186so16477883oih.8
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjYGG4Mqq7wY6CDKzIIHdAwcntS1fcaEqeO52o9kuCo=;
        b=aj32NzB5DXtXPhsv65Yawh1K41rQQVKEISKPYIQz7P3mXLb0B34EfYh587Asp5+hwU
         G+p5GOcSTno2KmORLfdSw7988hfVeE8U6Bp7xJn8Hjyqwo8juM+K1YycYf76R+L8otYO
         wi4uULReXi5fhrFTlp6px6jAIXsQHy50uAH4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjYGG4Mqq7wY6CDKzIIHdAwcntS1fcaEqeO52o9kuCo=;
        b=r/aruC5w795bwSbjHX7W9Jk5BcyvqOjYrjyQOjCbwxuJMkTkzokc9piHDmte0AcvYn
         IN4yPfIl/VkplDn9DlDsMLCZ/J39OG2fbLYh5Yk6MPdYxiDdI7d1lgH/caxIth0g7vgX
         Vly9cbf/c4vij47Ee6pglYsOqlOnZqNdAkc0Fwf/b6jUwdWXRw5+bNWcCWi8XeeE5aWd
         S7qy90pvWVIbHlpMsmoNA00V3T9RqQjTogrhNztOcyomFSufgqp6cW8ofkQe/7CmjOAq
         TuOJ2/j1oc8UMVMdQqFhepIpz5OYoGUKd7AP2TCcafi/6NLU+F+fIZJp6n+KMuqOL2v0
         2tPg==
X-Gm-Message-State: AOAM532Hj9IufJ7AdRVq1ddwwXlSuCGKQ1aM3L6hKkdLxfqTchfAL5rJ
        LWXAwBtX6sP+uR5nGjnZrxtr587wm5GuyWiPJViIypGCGZc=
X-Google-Smtp-Source: ABdhPJxhDq3BvTLlSca+MsSLzCtT9n/Enjn62SMAefOQGarIUm6cKqdqaniOy/Xvm7lcKJaeiswM4kBpupKlPG9r368=
X-Received: by 2002:aca:b103:: with SMTP id a3mr1089511oif.14.1641891952360;
 Tue, 11 Jan 2022 01:05:52 -0800 (PST)
MIME-Version: 1.0
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com>
In-Reply-To: <20220111004126.GJ2328285@nvidia.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 11 Jan 2022 10:05:40 +0100
Message-ID: <CAKMK7uFfpTKQEPpVQxNDi0NeO732PJMfiZ=N6u39bSCFY3d6VQ@mail.gmail.com>
Subject: Re: Phyr Starter
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, nvdimm@lists.linux.dev,
        linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dropping some thoughts from the gpu driver perspective, feel free to
tell me it's nonsense from the mm/block view :-)

Generally I think we really, really need something like this that's
across all subsystems and consistent.

On Tue, Jan 11, 2022 at 1:41 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> > Finally, it may be possible to stop using scatterlist to describe the
> > input to the DMA-mapping operation.  We may be able to get struct
> > scatterlist down to just dma_address and dma_length, with chaining
> > handled through an enclosing struct.
>
> Can you talk about this some more? IMHO one of the key properties of
> the scatterlist is that it can hold huge amounts of pages without
> having to do any kind of special allocation due to the chaining.
>
> The same will be true of the phyr idea right?
>
> > I would like to see phyr replace bio_vec everywhere it's currently used.
> > I don't have time to do that work now because I'm busy with folios.
> > If someone else wants to take that on, I shall cheer from the sidelines.
> > What I do intend to do is:
>
> I wonder if we mixed things though..
>
> IMHO there is a lot of optimization to be had by having a
> datastructure that is expressly 'the physical pages underlying a
> contiguous chunk of va'
>
> If you limit to that scenario then we can be more optimal because
> things like byte granular offsets and size in the interior pages don't
> need to exist. Every interior chunk is always aligned to its order and
> we only need to record the order.

At least from the gfx side of things only allowing page sized chunks
makes a lot of sense. sg chains kinda feel wrong because they allow
byte chunks (but really that's just not allowed), so quite some
mismatch.

If we go with page size I think hardcoding a PHYS_PAGE_SIZE KB(4)
would make sense, because thanks to x86 that's pretty much the lowest
common denominator that all hw (I know of at least) supports. Not
having to fiddle with "which page size do we have" in driver code
would be neat. It makes writing portable gup code in drivers just
needlessly silly.

> An overall starting offset and total length allow computing the slice
> of the first/last entry.
>
> If the physical address is always aligned then we get 12 free bits
> from the min 4k alignment and also only need to store order, not an
> arbitary byte granular length.
>
> The win is I think we can meaningfully cover most common cases using
> only 8 bytes per physical chunk. The 12 bits can be used to encode the
> common orders (4k, 2M, 1G, etc) and some smart mechanism to get
> another 16 bits to cover 'everything'.
>
> IMHO storage density here is quite important, we end up having to keep
> this stuff around for a long time.
>
> I say this here, because I've always though bio_vec/etc are more
> general than we actually need, being byte granular at every chunk.
>
> >  - Add an interface to gup.c to pin/unpin N phyrs
> >  - Add a sg_map_phyrs()
> >    This will take an array of phyrs and allocate an sg for them
> >  - Whatever else I need to do to make one RDMA driver happy with
> >    this scheme
>
> I spent alot of time already cleaning all the DMA code in RDMA - it is
> now nicely uniform and ready to do this sort of change. I was
> expecting to be a bio_vec, but this is fine too.
>
> What is needed is a full scatterlist replacement, including the IOMMU
> part.
>
> For the IOMMU I would expect the datastructure to be re-used, we start
> with a list of physical pages and then 'dma map' gives us a list of
> IOVA physical pages, in another allocation, but exactly the same
> datastructure.
>
> This 'dma map' could return a pointer to the first datastructure if
> there is no iommu, allocate a single entry list if the whole thing can
> be linearly mapped with the iommu, and other baroque cases (like pci
> offset/etc) will need to allocate full array. ie good HW runs fast and
> is memory efficient.
>
> It would be nice to see a patch sketching showing what this
> datastructure could look like.
>
> VFIO would like this structure as well as it currently is a very
> inefficient page at a time loop when it iommu maps things.

I also think that it would be nice if we can have this as a consistent
set of datastructures, both for dma_addr_t and phys_addr_t. Roughly my
wishlist:
- chained by default, because of the allocation headaches, so I'm with
Jason here
- comes compressed out of gup, I think we all agree on this, I don't
really care how it's compressed as long as I don't get 512 entries for
2M pages :-)
- ideally the dma_ and the phys_ part are split since for dma-buf and
some gpu driver internal use-case there's some where really only the
dma addr is valid, and nothing else. But we can also continue the
current hack of pretending the other side isn't there (atm we scramble
those pointers to make sure dma-buf users don't cheat)
- I think minimally an sg list form of dma-mapped stuff which does not
have a struct page, iirc last time we discussed that we agreed that
this really needs to be part of such a rework or it's not really
improving things much
- a few per-entry driver bits would be nice in both the phys/dma
chains, if we can have them. gpus have funny gpu interconnects, this
would allow us to put all the gpu addresses into dma_addr_t if we can
have some bits indicating whether it's on the pci bus, gpu local
memory or the gpu<->gpu interconnect.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
