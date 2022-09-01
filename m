Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10E05A9F63
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 20:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiIASr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 14:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiIASru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 14:47:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A85E82D3E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 11:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662058067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQKmugClFbSSnhHoA7JyigMd6BhQdVNuTu6/tdZRhIU=;
        b=M5Eqg9LrnhJu+V9LtqAmFWjTlzuUYMcU31P2bN1vKKphtAAoDKzNr4slD88MMhqZL9FZpy
        A9sjK0AWdAphcwC10VTrgcMpfDmI77WcORgwRPn/IZHKzepKnfaGNjANCpIBu1+C2nFFAd
        e88E+/8OsXTCeGXMqmbwN5u9VELasSg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-_jj3eejfOBWGYcLld5-AjA-1; Thu, 01 Sep 2022 14:47:46 -0400
X-MC-Unique: _jj3eejfOBWGYcLld5-AjA-1
Received: by mail-io1-f70.google.com with SMTP id c2-20020a6bec02000000b00689b26e92f0so11265352ioh.6
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 11:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=EQKmugClFbSSnhHoA7JyigMd6BhQdVNuTu6/tdZRhIU=;
        b=KIB/0rfe2Y1/Thhs2RgSSt7QbEob65wNC6aqDDcJdS8EStbehCexCYxk5dpGgfIagV
         yokDRtwGigMr9CjqMyiXXLgEgbca1bx09jG984tYywQtZMANr8kZqm5sWcZHL3UT0t9w
         axS1rrFOWDDDMwAgRvwih1AQnS2datFPGMdyLq1J+Uf6q3KtKKcgG78kUlT/W427pNFL
         kMFdy1ztPVbLBH2D+9xV4TmX3jzt+vhn4a7UmJCjblsyn7T/7dg3BiFRuJdT1sEJvPVZ
         7vvA3eATAc/fvFrThOFwvSuNPHT2BJSIh4vwxDT/fG0ZiWVzSNyh3kbmDrpWGwLHnA2/
         UQ0Q==
X-Gm-Message-State: ACgBeo1jgNpcG+omrtVLlR3Jdni1uia3YWDDEhYVrWk8sgc9h9ueQph5
        nA5JJtzyhCzuigzJBvmUrtWYqolqZ6GhDS017NxF8rYaS8wdGaHvnavC5LQZSh0cH/ks4kZs0RB
        rJRe9i7okwiSiIUaG
X-Received: by 2002:a05:6e02:198b:b0:2ea:1ad:1c92 with SMTP id g11-20020a056e02198b00b002ea01ad1c92mr16334295ilf.2.1662058064979;
        Thu, 01 Sep 2022 11:47:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7iULFw17pmq7xFFMbmmh66+fX5fVUJV9/agJaP3IiG3bb1qvnaaI16acdfl9Kwr2a+DfhtyQ==
X-Received: by 2002:a05:6e02:198b:b0:2ea:1ad:1c92 with SMTP id g11-20020a056e02198b00b002ea01ad1c92mr16334276ilf.2.1662058064543;
        Thu, 01 Sep 2022 11:47:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x15-20020a0566380caf00b0034c0bb200edsm2843039jad.146.2022.09.01.11.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 11:47:44 -0700 (PDT)
Date:   Thu, 1 Sep 2022 12:47:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <20220901124742.35648bd5.alex.williamson@redhat.com>
In-Reply-To: <20220901093853.60194-5-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
        <20220901093853.60194-5-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Sep 2022 12:38:47 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Joao Martins <joao.m.martins@oracle.com>
> 
> The new facility adds a bunch of wrappers that abstract how an IOVA range
> is represented in a bitmap that is granulated by a given page_size. So it
> translates all the lifting of dealing with user pointers into its
> corresponding kernel addresses backing said user memory into doing finally
> the (non-atomic) bitmap ops to change various bits.
> 
> The formula for the bitmap is:
> 
>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> 
> Where 64 is the number of bits in a unsigned long (depending on arch)
> 
> It introduces an IOVA iterator that uses a windowing scheme to minimize the
> pinning overhead, as opposed to pinning it on demand 4K at a time. Assuming
> a 4K kernel page and 4K requested page size, we can use a single kernel
> page to hold 512 page pointers, mapping 2M of bitmap, representing 64G of
> IOVA space.
> 
> An example usage of these helpers for a given @base_iova, @page_size,
> @length and __user @data:
> 
>    bitmap = iova_bitmap_alloc(base_iova, page_size, length, data);
>    if (IS_ERR(bitmap))
>        return -ENOMEM;
> 
>    ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
> 
>    iova_bitmap_free(bitmap);
> 
> An implementation of the lower end -- referred to above as
> dirty_reporter_fn to exemplify -- that is tracking dirty bits would mark
> an IOVA as dirty as following:
> 
> 	iova_bitmap_set(bitmap, iova, page_size);
> 
> Or a contiguous range (example two pages):
> 
> 	iova_bitmap_set(bitmap, iova, 2 * page_size);
> 
> The facility is intended to be used for user bitmaps representing dirtied
> IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/Makefile       |   6 +-
>  drivers/vfio/iova_bitmap.c  | 426 ++++++++++++++++++++++++++++++++++++
>  include/linux/iova_bitmap.h |  24 ++
>  3 files changed, 454 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/iova_bitmap.c
>  create mode 100644 include/linux/iova_bitmap.h
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 1a32357592e3..d67c604d0407 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,9 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0
>  vfio_virqfd-y := virqfd.o
>  
> -vfio-y += vfio_main.o
> -
>  obj-$(CONFIG_VFIO) += vfio.o
> +
> +vfio-y += vfio_main.o \
> +	  iova_bitmap.o \
> +
>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> new file mode 100644
> index 000000000000..4211a16eb542
> --- /dev/null
> +++ b/drivers/vfio/iova_bitmap.c
> @@ -0,0 +1,426 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +#include <linux/iova_bitmap.h>
> +#include <linux/mm.h>
> +#include <linux/highmem.h>
> +
> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
> +
> +/*
> + * struct iova_bitmap_map - A bitmap representing an IOVA range
> + *
> + * Main data structure for tracking mapped user pages of bitmap data.
> + *
> + * For example, for something recording dirty IOVAs, it will be provided a
> + * struct iova_bitmap structure, as a general structure for iterating the
> + * total IOVA range. The struct iova_bitmap_map, though, represents the
> + * subset of said IOVA space that is pinned by its parent structure (struct
> + * iova_bitmap).
> + *
> + * The user does not need to exact location of the bits in the bitmap.
> + * From user perspective the only API available is iova_bitmap_set() which
> + * records the IOVA *range* in the bitmap by setting the corresponding
> + * bits.
> + *
> + * The bitmap is an array of u64 whereas each bit represents an IOVA of
> + * range of (1 << pgshift). Thus formula for the bitmap data to be set is:
> + *
> + *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> + */
> +struct iova_bitmap_map {
> +	/* base IOVA representing bit 0 of the first page */
> +	unsigned long iova;
> +
> +	/* page size order that each bit granules to */
> +	unsigned long pgshift;
> +
> +	/* page offset of the first user page pinned */
> +	unsigned long pgoff;
> +
> +	/* number of pages pinned */
> +	unsigned long npages;
> +
> +	/* pinned pages representing the bitmap data */
> +	struct page **pages;
> +};
> +
> +/*
> + * struct iova_bitmap - The IOVA bitmap object
> + *
> + * Main data structure for iterating over the bitmap data.
> + *
> + * Abstracts the pinning work and iterates in IOVA ranges.
> + * It uses a windowing scheme and pins the bitmap in relatively
> + * big ranges e.g.
> + *
> + * The bitmap object uses one base page to store all the pinned pages
> + * pointers related to the bitmap. For sizeof(struct page) == 64 it stores

sizeof(struct page*) == 8?

> + * 512 struct pages which, if the base page size is 4K, it means 2M of bitmap

s/struct pages/struct page pointers/

> + * data is pinned at a time. If the iova_bitmap page size is also 4K
> + * then the range window to iterate is 64G.
> + *
> + * For example iterating on a total IOVA range of 4G..128G, it will walk
> + * through this set of ranges:
> + *
> + *    4G  -  68G-1 (64G)
> + *    68G - 128G-1 (64G)
> + *
> + * An example of the APIs on how to use/iterate over the IOVA bitmap:
> + *
> + *   bitmap = iova_bitmap_alloc(iova, length, page_size, data);
> + *   if (IS_ERR(bitmap))
> + *       return PTR_ERR(bitmap);
> + *
> + *   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
> + *
> + *   iova_bitmap_free(bitmap);
> + *
> + * An implementation of the lower end (referred to above as
> + * dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
> + * an IOVA as dirty as following:
> + *     iova_bitmap_set(bitmap, iova, page_size);
> + * Or a contiguous range (example two pages):
> + *     iova_bitmap_set(bitmap, iova, 2 * page_size);

This seems like it implies a stronger correlation to the
iova_bitmap_alloc() page_size than actually exists.  The implementation
of the dirty_reporter_fn() may not know the reporting page_size.  The
value here is just a size_t and iova_bitmap handles the rest, right?

> + *
> + * The internals of the object uses an index @mapped_base_index that indexes
> + * which u64 word of the bitmap is mapped, up to @mapped_total_index.
> + * Those keep being incremented until @mapped_total_index reaches while

s/reaches/is reached/

> + * mapping up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
> + *
> + * The IOVA bitmap is usually located on what tracks DMA mapped ranges or
> + * some form of IOVA range tracking that co-relates to the user passed
> + * bitmap.
> + */
> +struct iova_bitmap {
> +	/* IOVA range representing the currently mapped bitmap data */
> +	struct iova_bitmap_map mapped;
> +
> +	/* userspace address of the bitmap */
> +	u64 __user *bitmap;
> +
> +	/* u64 index that @mapped points to */
> +	unsigned long mapped_base_index;
> +
> +	/* how many u64 can we walk in total */
> +	unsigned long mapped_total_index;
> +
> +	/* base IOVA of the whole bitmap */
> +	unsigned long iova;
> +
> +	/* length of the IOVA range for the whole bitmap */
> +	size_t length;
> +};
> +
> +/*
> + * Converts a relative IOVA to a bitmap index.
> + * This function provides the index into the u64 array (bitmap::bitmap)
> + * for a given IOVA offset.
> + * Relative IOVA means relative to the bitmap::mapped base IOVA
> + * (stored in mapped::iova). All computations in this file are done using
> + * relative IOVAs and thus avoid an extra subtraction against mapped::iova.
> + * The user API iova_bitmap_set() always uses a regular absolute IOVAs.
> + */
> +static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
> +						 unsigned long iova)
> +{
> +	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
> +
> +	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
> +}
> +
> +/*
> + * Converts a bitmap index to a *relative* IOVA.
> + */
> +static unsigned long iova_bitmap_index_to_offset(struct iova_bitmap *bitmap,
> +						 unsigned long index)
> +{
> +	unsigned long pgshift = bitmap->mapped.pgshift;
> +
> +	return (index * BITS_PER_TYPE(*bitmap->bitmap)) << pgshift;
> +}
> +
> +/*
> + * Returns the base IOVA of the mapped range.
> + */
> +static unsigned long iova_bitmap_mapped_iova(struct iova_bitmap *bitmap)
> +{
> +	unsigned long skip = bitmap->mapped_base_index;
> +
> +	return bitmap->iova + iova_bitmap_index_to_offset(bitmap, skip);
> +}
> +
> +/*
> + * Pins the bitmap user pages for the current range window.
> + * This is internal to IOVA bitmap and called when advancing the
> + * index (@mapped_base_index) or allocating the bitmap.
> + */
> +static int iova_bitmap_get(struct iova_bitmap *bitmap)
> +{
> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
> +	unsigned long npages;
> +	u64 __user *addr;
> +	long ret;
> +
> +	/*
> +	 * @mapped_base_index is the index of the currently mapped u64 words
> +	 * that we have access. Anything before @mapped_base_index is not
> +	 * mapped. The range @mapped_base_index .. @mapped_total_index-1 is
> +	 * mapped but capped at a maximum number of pages.
> +	 */
> +	npages = DIV_ROUND_UP((bitmap->mapped_total_index -
> +			       bitmap->mapped_base_index) *
> +			       sizeof(*bitmap->bitmap), PAGE_SIZE);
> +
> +	/*
> +	 * We always cap at max number of 'struct page' a base page can fit.
> +	 * This is, for example, on x86 means 2M of bitmap data max.
> +	 */
> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
> +
> +	/*
> +	 * Bitmap address to be pinned is calculated via pointer arithmetic
> +	 * with bitmap u64 word index.
> +	 */
> +	addr = bitmap->bitmap + bitmap->mapped_base_index;
> +
> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
> +				  FOLL_WRITE, mapped->pages);
> +	if (ret <= 0)
> +		return -EFAULT;
> +
> +	mapped->npages = (unsigned long)ret;
> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
> +	mapped->iova = iova_bitmap_mapped_iova(bitmap);
> +
> +	/*
> +	 * offset of the page where pinned pages bit 0 is located.
> +	 * This handles the case where the bitmap is not PAGE_SIZE
> +	 * aligned.
> +	 */
> +	mapped->pgoff = offset_in_page(addr);
> +	return 0;
> +}
> +
> +/*
> + * Unpins the bitmap user pages and clears @npages
> + * (un)pinning is abstracted from API user and it's done when advancing
> + * the index or freeing the bitmap.
> + */
> +static void iova_bitmap_put(struct iova_bitmap *bitmap)
> +{
> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
> +
> +	if (mapped->npages) {
> +		unpin_user_pages(mapped->pages, mapped->npages);
> +		mapped->npages = 0;
> +	}
> +}
> +
> +/**
> + * iova_bitmap_alloc() - Allocates an IOVA bitmap object
> + * @iova: Start address of the IOVA range
> + * @length: Length of the IOVA range
> + * @page_size: Page size of the IOVA bitmap. It defines what each bit
> + *             granularity represents
> + * @data: Userspace address of the bitmap
> + *
> + * Allocates an IOVA object and initializes all its fields including the
> + * first user pages of @data.
> + *
> + * Return: A pointer to a newly allocated struct iova_bitmap
> + * or ERR_PTR() on error.
> + */
> +struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
> +				      unsigned long page_size, u64 __user *data)
> +{
> +	struct iova_bitmap_map *mapped;
> +	struct iova_bitmap *bitmap;
> +	int rc;
> +
> +	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
> +	if (!bitmap)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mapped = &bitmap->mapped;
> +	mapped->pgshift = __ffs(page_size);
> +	bitmap->bitmap = data;
> +	bitmap->mapped_total_index =
> +		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
> +	bitmap->iova = iova;
> +	bitmap->length = length;
> +	mapped->iova = iova;
> +	mapped->pages = (struct page **)__get_free_page(GFP_KERNEL);
> +	if (!mapped->pages) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
> +
> +	rc = iova_bitmap_get(bitmap);
> +	if (rc)
> +		goto err;
> +	return bitmap;
> +
> +err:
> +	iova_bitmap_free(bitmap);
> +	return ERR_PTR(rc);
> +}
> +
> +/**
> + * iova_bitmap_free() - Frees an IOVA bitmap object
> + * @bitmap: IOVA bitmap to free
> + *
> + * It unpins and releases pages array memory and clears any leftover
> + * state.
> + */
> +void iova_bitmap_free(struct iova_bitmap *bitmap)
> +{
> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
> +
> +	iova_bitmap_put(bitmap);
> +
> +	if (mapped->pages) {
> +		free_page((unsigned long)mapped->pages);
> +		mapped->pages = NULL;
> +	}
> +
> +	kfree(bitmap);
> +}
> +
> +/*
> + * Returns the remaining bitmap indexes from mapped_total_index to process for
> + * the currently pinned bitmap pages.
> + */
> +static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
> +{
> +	unsigned long remaining;
> +
> +	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
> +	remaining = min_t(unsigned long, remaining,
> +	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
> +
> +	return remaining;
> +}
> +
> +/*
> + * Returns the length of the mapped IOVA range.
> + */
> +static unsigned long iova_bitmap_mapped_length(struct iova_bitmap *bitmap)
> +{
> +	unsigned long max_iova = bitmap->iova + bitmap->length - 1;
> +	unsigned long iova = iova_bitmap_mapped_iova(bitmap);
> +	unsigned long remaining;
> +
> +	/*
> +	 * iova_bitmap_mapped_remaining() returns a number of indexes which
> +	 * when converted to IOVA gives us a max length that the bitmap
> +	 * pinned data can cover. Afterwards, that is capped to
> +	 * only cover the IOVA range in @bitmap::iova .. @bitmap::length.
> +	 */
> +	remaining = iova_bitmap_index_to_offset(bitmap,
> +			iova_bitmap_mapped_remaining(bitmap));
> +
> +	if (iova + remaining - 1 > max_iova)
> +		remaining -= ((iova + remaining - 1) - max_iova);
> +
> +	return remaining;
> +}
> +
> +/*
> + * Returns true if there's not more data to iterate.
> + */
> +static bool iova_bitmap_done(struct iova_bitmap *bitmap)
> +{
> +	return bitmap->mapped_base_index >= bitmap->mapped_total_index;
> +}
> +
> +/*
> + * Advances to the next range, releases the current pinned
> + * pages and pins the next set of bitmap pages.
> + * Returns 0 on success or otherwise errno.
> + */
> +static int iova_bitmap_advance(struct iova_bitmap *bitmap)
> +{
> +	unsigned long iova = iova_bitmap_mapped_length(bitmap) - 1;
> +	unsigned long count = iova_bitmap_offset_to_index(bitmap, iova) + 1;
> +
> +	bitmap->mapped_base_index += count;
> +
> +	iova_bitmap_put(bitmap);
> +	if (iova_bitmap_done(bitmap))
> +		return 0;
> +
> +	/* When advancing the index we pin the next set of bitmap pages */
> +	return iova_bitmap_get(bitmap);
> +}
> +
> +/**
> + * iova_bitmap_for_each() - Iterates over the bitmap
> + * @bitmap: IOVA bitmap to iterate
> + * @opaque: Additional argument to pass to the callback
> + * @fn: Function that gets called for each IOVA range
> + *
> + * Helper function to iterate over bitmap data representing a portion of IOVA
> + * space. It hides the complexity of iterating bitmaps and translating the
> + * mapped bitmap user pages into IOVA ranges to process.
> + *
> + * Return: 0 on success, and an error on failure either upon
> + * iteration or when the callback returns an error.
> + */
> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
> +			 int (*fn)(struct iova_bitmap *bitmap,
> +				   unsigned long iova, size_t length,
> +				   void *opaque))

It might make sense to typedef an iova_bitmap_fn_t in the header to use
here.

> +{
> +	int ret = 0;
> +
> +	for (; !iova_bitmap_done(bitmap) && !ret;
> +	     ret = iova_bitmap_advance(bitmap)) {
> +		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
> +			 iova_bitmap_mapped_length(bitmap), opaque);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * iova_bitmap_set() - Records an IOVA range in bitmap
> + * @bitmap: IOVA bitmap
> + * @iova: IOVA to start
> + * @length: IOVA range length
> + *
> + * Set the bits corresponding to the range [iova .. iova+length-1] in
> + * the user bitmap.
> + *
> + * Return: The number of bits set.

Is this relevant to the caller?

> + */
> +unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> +			      unsigned long iova, size_t length)
> +{
> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
> +	unsigned long nbits = max(1UL, length >> mapped->pgshift), set = nbits;
> +	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;

There's no sanity testing here that the caller provided an iova within
the mapped ranged.  Thanks,

Alex

> +	unsigned long page_idx = offset / BITS_PER_PAGE;
> +	unsigned long page_offset = mapped->pgoff;
> +	void *kaddr;
> +
> +	offset = offset % BITS_PER_PAGE;
> +
> +	do {
> +		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
> +
> +		kaddr = kmap_local_page(mapped->pages[page_idx]);
> +		bitmap_set(kaddr + page_offset, offset, size);
> +		kunmap_local(kaddr);
> +		page_offset = offset = 0;
> +		nbits -= size;
> +		page_idx++;
> +	} while (nbits > 0);
> +
> +	return set;
> +}
> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
> new file mode 100644
> index 000000000000..ab3b4fa6ac48
> --- /dev/null
> +++ b/include/linux/iova_bitmap.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +#ifndef _IOVA_BITMAP_H_
> +#define _IOVA_BITMAP_H_
> +
> +#include <linux/types.h>
> +
> +struct iova_bitmap;
> +
> +struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
> +				      unsigned long page_size,
> +				      u64 __user *data);
> +void iova_bitmap_free(struct iova_bitmap *bitmap);
> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
> +			 int (*fn)(struct iova_bitmap *bitmap,
> +				   unsigned long iova, size_t length,
> +				   void *opaque));
> +unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> +			      unsigned long iova, size_t length);
> +
> +#endif

