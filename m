Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20EB578D8D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiGRWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiGRWaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55BF82870A
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658183416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7eV+61Xf7Nk8gDFrv+v1q6ohxcJC6yxReFdoiCJjK4=;
        b=O+2WGZFNvXBz3dj0ejGCRRhB69PhgfeBLtpO2r5yHf/Hvunj3EFwAA1gWata4S6oE93GQI
        PEiwj7XSuyZPFZl4ipnP6P/I1CAySVQKXVJlx5RaYzZFlmKF0vM53lyua8DDHJ6Sx8nSl0
        bwQ96uHK+uaRhWBhOFJm4bIic4PvfDE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-g6RBN0wWP8OO5Y5OmPpM4g-1; Mon, 18 Jul 2022 18:30:15 -0400
X-MC-Unique: g6RBN0wWP8OO5Y5OmPpM4g-1
Received: by mail-io1-f72.google.com with SMTP id i16-20020a5d9350000000b0067bce490d06so5917430ioo.14
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=B7eV+61Xf7Nk8gDFrv+v1q6ohxcJC6yxReFdoiCJjK4=;
        b=WGt0I4+i63F4WKuB2BUBsrE6xqNOjIIWwEVJ7jKqs8vvbKvfFvmvt/6gvllumFBi/0
         PZgNov7NdmnmGqf3X+kt+Pc9aL5N+uC9xXnctsS9SEOBVv/N4/bibu89EVEXmlfg2MC0
         jQk0SO0zjRANtOjmHhra6kKbLei2qvVsvG0KTKLbcmb6Yck3KCkJJrfTWqrQRnjmH1Dd
         4jj57t92GnVNeBsyg0IXXQABUBfLoAcFOt35535lkm3UuZ2vtxTekowVzUDXudRuItVt
         vuUxS0kMGrs8ibn8OkOkdXzEXRPPX4H2nRiX0b/cEVax8KARXHSLWNeWL6Wsh4SyoAPR
         ysyg==
X-Gm-Message-State: AJIora9DOtQ/C+STShGVDWEIYoNWTp0CE2Eg+cCY7rFAXGozBgfkbzic
        xr0PYtnvEh36U0oG9TBIh2xsJZr82KK/iBmmV65eDRYq8/yf7Ng+jmwNgmC8dIvz182rEh5Au3Q
        qtR0TJSnTlAzldjs8
X-Received: by 2002:a05:6638:2410:b0:341:5daa:2bc9 with SMTP id z16-20020a056638241000b003415daa2bc9mr6468566jat.306.1658183412839;
        Mon, 18 Jul 2022 15:30:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sIR85HSvfgnClgwhT22oRjzh54mdEg8LM8gL6cHN/1ETkpLY9l5Dv1QtkWfb2Os7Vm8c9yew==
X-Received: by 2002:a05:6638:2410:b0:341:5daa:2bc9 with SMTP id z16-20020a056638241000b003415daa2bc9mr6468554jat.306.1658183412595;
        Mon, 18 Jul 2022 15:30:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cs3-20020a056638470300b0033ebd7a6225sm5930976jab.76.2022.07.18.15.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 15:30:12 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:30:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Message-ID: <20220718163010.01e11c20.alex.williamson@redhat.com>
In-Reply-To: <20220714081251.240584-6-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-6-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 11:12:45 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Joao Martins <joao.m.martins@oracle.com>
> 
> The new facility adds a bunch of wrappers that abstract how an IOVA
> range is represented in a bitmap that is granulated by a given
> page_size. So it translates all the lifting of dealing with user
> pointers into its corresponding kernel addresses backing said user
> memory into doing finally the bitmap ops to change various bits.
> 
> The formula for the bitmap is:
> 
>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> 
> Where 64 is the number of bits in a unsigned long (depending on arch)
> 
> An example usage of these helpers for a given @iova, @page_size, @length
> and __user @data:
> 
> 	iova_bitmap_init(&iter.dirty, iova, __ffs(page_size));
> 	ret = iova_bitmap_iter_init(&iter, iova, length, data);
> 	if (ret)
> 		return -ENOMEM;
> 
> 	for (; !iova_bitmap_iter_done(&iter);
> 	     iova_bitmap_iter_advance(&iter)) {
> 		ret = iova_bitmap_iter_get(&iter);
> 		if (ret)
> 			break;
> 		if (dirty)
> 			iova_bitmap_set(iova_bitmap_iova(&iter),
> 					iova_bitmap_iova_length(&iter),
> 					&iter.dirty);
> 
> 		iova_bitmap_iter_put(&iter);
> 
> 		if (ret)
> 			break;
> 	}
> 
> 	iova_bitmap_iter_free(&iter);
> 
> The facility is intended to be used for user bitmaps representing
> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/Makefile       |   6 +-
>  drivers/vfio/iova_bitmap.c  | 164 ++++++++++++++++++++++++++++++++++++
>  include/linux/iova_bitmap.h |  46 ++++++++++

I'm still working my way through the guts of this, but why is it being
proposed within the vfio driver when this is not at all vfio specific,
proposes it's own separate header, and doesn't conform with any of the
namespace conventions of being a sub-component of vfio?  Is this
ultimately meant for lib/ or perhaps an extension of iova.c within the
iommu subsystem?  Thanks,

Alex


>  3 files changed, 214 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/iova_bitmap.c
>  create mode 100644 include/linux/iova_bitmap.h
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 1a32357592e3..1d6cad32d366 100644
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
> +vfio-y := vfio_main.o \
> +          iova_bitmap.o \
> +
>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> new file mode 100644
> index 000000000000..9ad1533a6aec
> --- /dev/null
> +++ b/drivers/vfio/iova_bitmap.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/iova_bitmap.h>
> +
> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
> +					       unsigned long iova_length)
> +{
> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
> +
> +	return DIV_ROUND_UP(iova_length, BITS_PER_TYPE(*iter->data) * pgsize);
> +}
> +
> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
> +					       unsigned long index)
> +{
> +	unsigned long pgshift = iter->dirty.pgshift;
> +
> +	return (index * sizeof(*iter->data) * BITS_PER_BYTE) << pgshift;
> +}
> +
> +static unsigned long iova_bitmap_iter_left(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long left = iter->count - iter->offset;
> +
> +	left = min_t(unsigned long, left,
> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
> +
> +	return left;
> +}
> +
> +/*
> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> + * further casts to signed integer for unaligned multi-bit operation,
> + * __bitmap_set().
> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> + * system.
> + */
> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
> +			  unsigned long iova, unsigned long length,
> +			  u64 __user *data)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	iter->data = data;
> +	iter->offset = 0;
> +	iter->count = iova_bitmap_iova_to_index(iter, length);
> +	iter->iova = iova;
> +	iter->length = length;
> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
> +
> +	return !dirty->pages ? -ENOMEM : 0;
> +}
> +
> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	if (dirty->pages) {
> +		free_page((unsigned long)dirty->pages);
> +		dirty->pages = NULL;
> +	}
> +}
> +
> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
> +{
> +	return iter->offset >= iter->count;
> +}
> +
> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long max_iova = iter->dirty.iova + iter->length;
> +	unsigned long left = iova_bitmap_iter_left(iter);
> +	unsigned long iova = iova_bitmap_iova(iter);
> +
> +	left = iova_bitmap_index_to_iova(iter, left);
> +	if (iova + left > max_iova)
> +		left -= ((iova + left) - max_iova);
> +
> +	return left;
> +}
> +
> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long skip = iter->offset;
> +
> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
> +}
> +
> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long length = iova_bitmap_length(iter);
> +
> +	iter->offset += iova_bitmap_iova_to_index(iter, length);
> +}
> +
> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	if (dirty->npages)
> +		unpin_user_pages(dirty->pages, dirty->npages);
> +}
> +
> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +	unsigned long npages;
> +	u64 __user *addr;
> +	long ret;
> +
> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
> +			      sizeof(*iter->data), PAGE_SIZE);
> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
> +	addr = iter->data + iter->offset;
> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
> +				  FOLL_WRITE, dirty->pages);
> +	if (ret <= 0)
> +		return ret;
> +
> +	dirty->npages = (unsigned long)ret;
> +	dirty->iova = iova_bitmap_iova(iter);
> +	dirty->start_offset = offset_in_page(addr);
> +	return 0;
> +}
> +
> +void iova_bitmap_init(struct iova_bitmap *bitmap,
> +		      unsigned long base, unsigned long pgshift)
> +{
> +	memset(bitmap, 0, sizeof(*bitmap));
> +	bitmap->iova = base;
> +	bitmap->pgshift = pgshift;
> +}
> +
> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
> +			     unsigned long iova,
> +			     unsigned long length)
> +{
> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
> +
> +	nbits = max(1UL, length >> dirty->pgshift);
> +	offset = (iova - dirty->iova) >> dirty->pgshift;
> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
> +	start_offset = dirty->start_offset;
> +
> +	while (nbits > 0) {
> +		kaddr = kmap_local_page(dirty->pages[idx]) + start_offset;
> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
> +		bitmap_set(kaddr, offset, size);
> +		kunmap_local(kaddr - start_offset);
> +		start_offset = offset = 0;
> +		nbits -= size;
> +		idx++;
> +	}
> +
> +	return nbits;
> +}
> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
> +
> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
> new file mode 100644
> index 000000000000..c474c351634a
> --- /dev/null
> +++ b/include/linux/iova_bitmap.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#ifndef _IOVA_BITMAP_H_
> +#define _IOVA_BITMAP_H_
> +
> +#include <linux/highmem.h>
> +#include <linux/mm.h>
> +#include <linux/uio.h>
> +
> +struct iova_bitmap {
> +	unsigned long iova;
> +	unsigned long pgshift;
> +	unsigned long start_offset;
> +	unsigned long npages;
> +	struct page **pages;
> +};
> +
> +struct iova_bitmap_iter {
> +	struct iova_bitmap dirty;
> +	u64 __user *data;
> +	size_t offset;
> +	size_t count;
> +	unsigned long iova;
> +	unsigned long length;
> +};
> +
> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
> +			  unsigned long length, u64 __user *data);
> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter);
> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
> +void iova_bitmap_init(struct iova_bitmap *bitmap,
> +		      unsigned long base, unsigned long pgshift);
> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
> +			     unsigned long iova,
> +			     unsigned long length);
> +
> +#endif

