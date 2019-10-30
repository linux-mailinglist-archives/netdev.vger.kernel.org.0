Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25828EA779
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfJ3XF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:05:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17582 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfJ3XF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:05:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dba17390001>; Wed, 30 Oct 2019 16:05:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 30 Oct 2019 16:05:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 30 Oct 2019 16:05:23 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 23:05:22 +0000
Subject: Re: [PATCH 14/19] vfio, mm: pin_longterm_pages (FOLL_PIN) and
 put_user_page() conversion
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-15-jhubbard@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <cfa579f0-999c-9712-494a-9d519bbc4314@nvidia.com>
Date:   Wed, 30 Oct 2019 16:05:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191030224930.3990755-15-jhubbard@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572476729; bh=53l+EYxovXaJJmkDDYPwp5PBwN0eKGoaifL7qKM0Mds=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=md/zgeBc2zml8TuAaTKRK2oyv1Btng0H6ozq8zn2sRJiXmTfxKbYsvkGcjK6gQS+q
         3nPYnJq+1Eps5VG6ooIJSjGzkjOCMYIGUlSFcOJoUyjFNZ1H0vd+dWvWBSOqDkH5Uc
         dvFo63nthImmg9iCDmU6xj0EE8b8pgUM6g95EetFKN1/r0QnPl5BygVRpoyVLlCyiH
         iCMwhme/pZSwh1q5oOeHae8CYEOAkIwb1y6ebulV3/7WSgE5bb3SmwuYCg/xWfmbmX
         iPDY0K1xyswztlMvQmBw8+uJFpl2scC5scONZ/nlQeN+ZcWegNbDORlz6y4lLuTxuj
         WJ+vmX9yZfaww==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 3:49 PM, John Hubbard wrote:
> This also fixes one or two likely bugs.

Well, actually just one...

> 
> 1. Change vfio from get_user_pages(FOLL_LONGTERM), to
> pin_longterm_pages(), which sets both FOLL_LONGTERM and FOLL_PIN.
> 
> Note that this is a change in behavior, because the
> get_user_pages_remote() call was not setting FOLL_LONGTERM, but the
> new pin_user_pages_remote() call that replaces it, *is* setting
> FOLL_LONGTERM. It is important to set FOLL_LONGTERM, because the
> DMA case requires it. Please see the FOLL_PIN documentation in
> include/linux/mm.h, and Documentation/pin_user_pages.rst for details.

Correction: the above comment is stale and wrong. I wrote it before 
getting further into the details, and the patch doesn't do this. 

Instead, it keeps exactly the old behavior: pin_longterm_pages_remote()
is careful to avoid setting FOLL_LONGTERM. Instead of setting that flag,
it drops in a "TODO" comment nearby. :)

I'll update the commit description in the next version of the series.


thanks,

John Hubbard
NVIDIA

> 
> 2. Because all FOLL_PIN-acquired pages must be released via
> put_user_page(), also convert the put_page() call over to
> put_user_pages().
> 
> Note that this effectively changes the code's behavior in
> vfio_iommu_type1.c: put_pfn(): it now ultimately calls
> set_page_dirty_lock(), instead of set_page_dirty(). This is
> probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [1]
> 
> [1] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d864277ea16f..795e13f3ef08 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -327,9 +327,8 @@ static int put_pfn(unsigned long pfn, int prot)
>  {
>  	if (!is_invalid_reserved_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
> -		if (prot & IOMMU_WRITE)
> -			SetPageDirty(page);
> -		put_page(page);
> +
> +		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
>  		return 1;
>  	}
>  	return 0;
> @@ -349,11 +348,11 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  
>  	down_read(&mm->mmap_sem);
>  	if (mm == current->mm) {
> -		ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> -				     vmas);
> +		ret = pin_longterm_pages(vaddr, 1, flags, page, vmas);
>  	} else {
> -		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> -					    vmas, NULL);
> +		ret = pin_longterm_pages_remote(NULL, mm, vaddr, 1,
> +						flags, page, vmas,
> +						NULL);
>  		/*
>  		 * The lifetime of a vaddr_get_pfn() page pin is
>  		 * userspace-controlled. In the fs-dax case this could
> @@ -363,7 +362,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  		 */
>  		if (ret > 0 && vma_is_fsdax(vmas[0])) {
>  			ret = -EOPNOTSUPP;
> -			put_page(page[0]);
> +			put_user_page(page[0]);
>  		}
>  	}
>  	up_read(&mm->mmap_sem);
> 
