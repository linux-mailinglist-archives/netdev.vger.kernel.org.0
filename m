Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF474BF8DF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiBVNNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiBVNNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:13:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13B47C3C30
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645535596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qGnK7o/yk4EPAynjeZKrwke33X1jNpAGcK0gpScFC0=;
        b=MPg1cEYXSPAZ+NpbNcA9pEyNWXIPR1/6Y/wTEJ4Ds0PwKTLVMcyuVJXM0HiNHYAbQyOl+c
        f5bhY9EpcQGGd9R3K3ElBrPX6W0/AYIkM1KhFME61qmKSD+sNuBFlJqzgSNTbAj/5OyaB1
        cTlWJW9u60Qjn+QhtWuyK5oL4FodlG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-NqnnJI28Mwm8xBOhW0CAWw-1; Tue, 22 Feb 2022 08:13:12 -0500
X-MC-Unique: NqnnJI28Mwm8xBOhW0CAWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F12C1006AA6;
        Tue, 22 Feb 2022 13:13:09 +0000 (UTC)
Received: from localhost (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B629797DC;
        Tue, 22 Feb 2022 13:12:57 +0000 (UTC)
Date:   Tue, 22 Feb 2022 21:12:54 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>, x86@kernel.org
Subject: Re: [PATCH 00/22] Don't use kmalloc() with GFP_DMA
Message-ID: <YhThVgoRJoZ7Voyy@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <YhOaTsWUKO0SWsh7@osiris>
 <20220222084422.GA6139@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222084422.GA6139@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/22/22 at 09:44am, Christoph Hellwig wrote:
> On Mon, Feb 21, 2022 at 02:57:34PM +0100, Heiko Carstens wrote:
> > > 1) Kmalloc(GFP_DMA) in s390 platform, under arch/s390 and drivers/s390;
> > 
> > So, s390 partially requires GFP_DMA allocations for memory areas which
> > are required by the hardware to be below 2GB. There is not necessarily
> > a device associated when this is required. E.g. some legacy "diagnose"
> > calls require buffers to be below 2GB.
> > 
> > How should something like this be handled? I'd guess that the
> > dma_alloc API is not the right thing to use in such cases. Of course
> > we could say, let's waste memory and use full pages instead, however
> > I'm not sure this is a good idea.
> 
> Yeah, I don't think the DMA API is the right thing for that.  This
> is one of the very rare cases where a raw allocation makes sense.
> 
> That being said being able to drop kmalloc support for GFP_DMA would
> be really useful. How much memory would we waste if switching to the
> page allocator?
> 
> > s390 drivers could probably converted to dma_alloc API, even though
> > that would cause quite some code churn.
> 
> I think that would be a very good thing to have.
> 
> > > For this first patch series, thanks to Hyeonggon for helping
> > > reviewing and great suggestions on patch improving. We will work
> > > together to continue the next steps of work.
> > > 
> > > Any comment, thought, or suggestoin is welcome and appreciated,
> > > including but not limited to:
> > > 1) whether we should remove dma-kmalloc support in kernel();
> > 
> > The question is: what would this buy us? As stated above I'd assume
> > this comes with quite some code churn, so there should be a good
> > reason to do this.
> 
> There is two steps here.  One is to remove GFP_DMA support from
> kmalloc, which would help to cleanup the slab allocator(s) very nicely,
> as at that point it can stop to be zone aware entirely.
> 
> The long term goal is to remove ZONE_DMA entirely at least for
> architectures that only use the small 16MB ISA-style one.  It can
> then be replaced with for example a CMA area and fall into a movable
> zone.  I'd have to prototype this first and see how it applies to the
> s390 case.  It might not be worth it and maybe we should replace
> ZONE_DMA and ZONE_DMA32 with a ZONE_LIMITED for those use cases as
> the amount covered tends to not be totally out of line for what we
> built the zone infrastructure.
> 
> > >From this cover letter I only get that there was a problem with kdump
> > on x86, and this has been fixed. So why this extra effort?
> > 
> > >     3) Drop support for allocating DMA memory from slab allocator
> > >     (as Christoph Hellwig said) and convert them to use DMA32
> > >     and see what happens
> > 
> > Can you please clarify what "convert to DMA32" means? I would assume
> > this does _not_ mean that passing GFP_DMA32 to slab allocator would
> > work then?
> 
> I'm really not sure what this means.

Thanks a lot to Heiko for valuable input, it's very helpful. And thanks
a lot to Christoph for explaining.

I guess this "convert to DMA32" is similar to "replace ZONE_DMA and
ZONE_DMA32 with a ZONE_LIMITED".

When I use 'git grep "GFP_DMA/>"' to search all places specifying GFP_DMA,
I noticed the main usage of kmalloc(GFP_DMA) is to get memory under a
memory limitation, but not for DMA buffer allocation. Below is what I got
for earlier kdump issue explanation. It can help explain why kmalloc(GFP_DMA)
is useful on ARCHes w/o ZONE_DMA32, but doesn't make sense on x86_64 which
has both zone DMA and DMA32. The 16M ZONE_DMA is only for very rarely used
legacy ISA device, but most pci devices driver supporting 32bit addressing
likes to abuse kmalloc(GFP_DMA) to get DMA buffer from the zone DMA.
That obviously is unsafe and unreasonable.

Like risc-V which doesn't have the burden of legacy ISA devices, it can
take only containing DMA32 zone way. ARM64 also adjusts to have only
arm64 if not on Raspberry Pi. Using kmalloc(GFP_DMA) makes them no
inconvenience. If finally having dma32-kmalloc, the name may need be
carefully considerred, it seems to be acceptable. We just need to pick
up those ISA device driver and handle their 24bit addressing DMA well.

For this patchset, I only find out places in which GPF_DMA is
redundant and can be removed directly, and places where
kmalloc(GFP_DMA)|dma_map_ pair can be replaced with dma_alloc_xxxx() API
and the memory wasting is not so big. I have patches converting
kmalloc(GFP_DMA) to alloc_pages(GFP_DMA), but not easy to replace with
dma_alloc_xxx(), Hyeonggon suggested not adding them to this series.
I will continue investigating the left places, see whether or how we can
convert them.

=============================
ARCH which has DMA32
        ZONE_DMA       ZONE_DMA32
arm64   0~X            X~4G  (X is got from ACPI or DT. Otherwise it's 4G by default, DMA32 is empty)
ia64    None           0~4G
mips    0 or 0~16M     X~4G  (zone DMA is empty on SGI_IP22 or SGI_IP28, otherwise 16M by default like i386)
riscv   None           0~4G
x86_64  16M            16M~4G


=============================
ARCH which has no DMA32
        ZONE_DMA
alpha   0~16M or empty if IOMMU enabled
arm     0~X (X is reported by fdt, 4G by default)
m68k    0~total memory
microblaze 0~total low memory
powerpc 0~2G
s390    0~2G
sparc   0~ total low memory
i386    0~16M

> 
> > 
> > btw. there are actually two kmalloc allocations which pass GFP_DMA32;
> > I guess this is broken(?):
> > 
> > drivers/hid/intel-ish-hid/ishtp-fw-loader.c:    dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
> > drivers/media/test-drivers/vivid/vivid-osd.c:   dev->video_vbase = kzalloc(dev->video_buffer_size, GFP_KERNEL | GFP_DMA32);
> 
> Yes, this is completely broken.
> 

