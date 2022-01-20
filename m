Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A814494F25
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiATNjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:39:17 -0500
Received: from verein.lst.de ([213.95.11.211]:44631 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbiATNjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 08:39:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 906E668BEB; Thu, 20 Jan 2022 14:39:11 +0100 (CET)
Date:   Thu, 20 Jan 2022 14:39:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120133911.GA11052@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> TLDR: I want to introduce a new data type:
> 
> struct phyr {
>         phys_addr_t addr;
>         size_t len;
> };
> 
> and use it to replace bio_vec as well as using it to replace the array
> of struct pages used by get_user_pages() and friends.

FYI, I've done a fair amount of work (some already mainline as in all
the helpers for biovec page access), some of it still waiting (switching
more users over to these helpers and cleaning up some other mess)
to move bio_vecs into a form like that.  The difference in my plan
is to have a u32 len, both to allow for flags space on 64-bit which
we might need to support things like P2P without dev_pagemap structures.

> Finally, it may be possible to stop using scatterlist to describe the
> input to the DMA-mapping operation.  We may be able to get struct
> scatterlist down to just dma_address and dma_length, with chaining
> handled through an enclosing struct.

Yes, I have some prototype could that takes a bio_vec as input and
returns an array of

struct dma_range {
	dma_addr_t	addr;
	u32		len;
}

І need to get back to it and especially back to the question if this
needs the chaining support that the current scatterlist has.
