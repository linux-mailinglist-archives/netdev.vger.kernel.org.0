Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB874BF3E7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiBVIox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBVIox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:44:53 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01256D3ACC;
        Tue, 22 Feb 2022 00:44:27 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0390A68AA6; Tue, 22 Feb 2022 09:44:23 +0100 (CET)
Date:   Tue, 22 Feb 2022 09:44:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 00/22] Don't use kmalloc() with GFP_DMA
Message-ID: <20220222084422.GA6139@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <YhOaTsWUKO0SWsh7@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhOaTsWUKO0SWsh7@osiris>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 02:57:34PM +0100, Heiko Carstens wrote:
> > 1) Kmalloc(GFP_DMA) in s390 platform, under arch/s390 and drivers/s390;
> 
> So, s390 partially requires GFP_DMA allocations for memory areas which
> are required by the hardware to be below 2GB. There is not necessarily
> a device associated when this is required. E.g. some legacy "diagnose"
> calls require buffers to be below 2GB.
> 
> How should something like this be handled? I'd guess that the
> dma_alloc API is not the right thing to use in such cases. Of course
> we could say, let's waste memory and use full pages instead, however
> I'm not sure this is a good idea.

Yeah, I don't think the DMA API is the right thing for that.  This
is one of the very rare cases where a raw allocation makes sense.

That being said being able to drop kmalloc support for GFP_DMA would
be really useful. How much memory would we waste if switching to the
page allocator?

> s390 drivers could probably converted to dma_alloc API, even though
> that would cause quite some code churn.

I think that would be a very good thing to have.

> > For this first patch series, thanks to Hyeonggon for helping
> > reviewing and great suggestions on patch improving. We will work
> > together to continue the next steps of work.
> > 
> > Any comment, thought, or suggestoin is welcome and appreciated,
> > including but not limited to:
> > 1) whether we should remove dma-kmalloc support in kernel();
> 
> The question is: what would this buy us? As stated above I'd assume
> this comes with quite some code churn, so there should be a good
> reason to do this.

There is two steps here.  One is to remove GFP_DMA support from
kmalloc, which would help to cleanup the slab allocator(s) very nicely,
as at that point it can stop to be zone aware entirely.

The long term goal is to remove ZONE_DMA entirely at least for
architectures that only use the small 16MB ISA-style one.  It can
then be replaced with for example a CMA area and fall into a movable
zone.  I'd have to prototype this first and see how it applies to the
s390 case.  It might not be worth it and maybe we should replace
ZONE_DMA and ZONE_DMA32 with a ZONE_LIMITED for those use cases as
the amount covered tends to not be totally out of line for what we
built the zone infrastructure.

> >From this cover letter I only get that there was a problem with kdump
> on x86, and this has been fixed. So why this extra effort?
> 
> >     3) Drop support for allocating DMA memory from slab allocator
> >     (as Christoph Hellwig said) and convert them to use DMA32
> >     and see what happens
> 
> Can you please clarify what "convert to DMA32" means? I would assume
> this does _not_ mean that passing GFP_DMA32 to slab allocator would
> work then?

I'm really not sure what this means.

> 
> btw. there are actually two kmalloc allocations which pass GFP_DMA32;
> I guess this is broken(?):
> 
> drivers/hid/intel-ish-hid/ishtp-fw-loader.c:    dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
> drivers/media/test-drivers/vivid/vivid-osd.c:   dev->video_vbase = kzalloc(dev->video_buffer_size, GFP_KERNEL | GFP_DMA32);

Yes, this is completely broken.
