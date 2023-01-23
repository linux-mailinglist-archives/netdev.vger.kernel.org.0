Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A42678AFE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjAWWq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAWWq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:46:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDFA367ED;
        Mon, 23 Jan 2023 14:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LdoL9WInNn9g+7kuigf9617DZzkmnyUk0PPwEqtnDNs=; b=Wec3MZQ4Im+pfSZhNixMoikgQp
        dmKOI1VP02JxTetKhMElCRQohV5UlH7bhT0BzBqDbpvYyuJYJWxjXRxbgvhpmeUlzdCIQFeuKq/A0
        jCu0V4X2OYa1fc5HkzlSNF/fHViupU5ybyDv7lCZbWBVBHYVW8M+USztiscjCz+X+nAUnDTxEisH5
        71HMkc7qFGE4VRVNmLKFEizQCLLWsJX+lovKSQVkUc7p3kV9EZQljwmNOGfSh4d1U/PYToPKA1QbI
        n0eZstbbByNQIOrRWB8Kpy8kAFlH6RUnzb9MT7/zm0BKA8LENilntYWJHHi06b8R2qWJKVB4mgozr
        IbueYMUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pK5aM-004aMF-EK; Mon, 23 Jan 2023 22:46:42 +0000
Date:   Mon, 23 Jan 2023 22:46:42 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     nvdimm@lists.linux.dev, lsf-pc@lists.linuxfoundation.org,
        linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        dri-devel@lists.freedesktop.org, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe via Lsf-pc 
        <lsf-pc@lists.linux-foundation.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [Lsf-pc] [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y88OUobZeJH2ak+s@casper.infradead.org>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
 <Y87p9i0vCZo/3Qa0@casper.infradead.org>
 <63cef32cbafc3_3a36e529465@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63cef32cbafc3_3a36e529465@dwillia2-xfh.jf.intel.com.notmuch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 12:50:52PM -0800, Dan Williams wrote:
> Matthew Wilcox wrote:
> > On Mon, Jan 23, 2023 at 11:36:51AM -0800, Dan Williams wrote:
> > > Jason Gunthorpe via Lsf-pc wrote:
> > > > I would like to have a session at LSF to talk about Matthew's
> > > > physr discussion starter:
> > > > 
> > > >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> > > > 
> > > > I have become interested in this with some immediacy because of
> > > > IOMMUFD and this other discussion with Christoph:
> > > > 
> > > >  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
> > > 
> > > I think this is a worthwhile discussion. My main hangup with 'struct
> > > page' elimination in general is that if anything needs to be allocated
> > 
> > You're the first one to bring up struct page elimination.  Neither Jason
> > nor I have that as our motivation.
> 
> Oh, ok, then maybe I misread the concern in the vfio discussion. I
> thought the summary there is debating the ongoing requirement for
> 'struct page' for P2PDMA?

My reading of that thread is that while it started out that way, it
became more about "So what would a good interface be for doing this".  And
Jason's right, he and I are approaching this from different directions.
My concern is from the GUP side where we start out by getting a folio
(which we know is physically contiguous) and decomposing it into pages.
Then we aggregate all those pages together which are physically contiguous
and stuff them into a bio_vec.  After that, I lose interest; I was
planning on having DMA mapping interfaces which took in an array of
phyr and spat out scatterlists.  Then we could shrink the scatterlist
by removing page_link and offset, leaving us with only dma_address,
length and maybe flags.
