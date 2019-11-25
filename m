Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49FB1094CD
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfKYUrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:47:06 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3447 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYUrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:47:05 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc3dc40000>; Mon, 25 Nov 2019 12:47:00 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 12:46:58 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 12:46:58 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 20:46:57 +0000
Subject: Re: [PATCH 17/19] powerpc: book3s64: convert to pin_user_pages() and
 put_user_page()
To:     Jan Kara <jack@suse.cz>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>,
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
References: <20191125042011.3002372-1-jhubbard@nvidia.com>
 <20191125042011.3002372-18-jhubbard@nvidia.com>
 <20191125085915.GB1797@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <9abfd0bf-ffb9-9fad-848c-caff4a490773@nvidia.com>
Date:   Mon, 25 Nov 2019 12:46:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191125085915.GB1797@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574714820; bh=7Gmrre2tneNEWRU9G5+DIn5rrxtRLBtJ55Uj7bfaWRw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Vc2WP6DAAbNZStXBl+ln2+kB/EuUuvRZHzMpZNW80Fm3ZctGnvM4O+tZRCgS3669B
         /qldmeczkVi9pQJMXYF/4i2XGVt4Gm+gOJ/tFv/RnDb4dopV+tz5b0cyQc9YOTVtBS
         P/yYNUzd4pjDhuvvDyZmybC/J7abTjT/ntYJJMbyGr8NCKnGXhEtDqS5T7TKRE2hwU
         dbPgyN9eu9VXPtG/lD5Uk37zf69kjzXTl/JkUlunTht14kOdHqRRRORI90fFcZ/kGC
         NFhCuK40TfQ4yRLkmLaKp7qlIx6xeGOy5CzKXKx/3W33foWMDjA/xuDpoO/15JsFQy
         0FiT0Aycu6K+g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 12:59 AM, Jan Kara wrote:
> On Sun 24-11-19 20:20:09, John Hubbard wrote:
>> 1. Convert from get_user_pages() to pin_user_pages().
>>
>> 2. As required by pin_user_pages(), release these pages via
>> put_user_page(). In this case, do so via put_user_pages_dirty_lock().
>>
>> That has the side effect of calling set_page_dirty_lock(), instead
>> of set_page_dirty(). This is probably more accurate.
>>
>> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
>> dealing with a file backed page where we have reference on the inode it
>> hangs off." [1]
>>
>> 3. Release each page in mem->hpages[] (instead of mem->hpas[]), because
>> that is the array that pin_longterm_pages() filled in. This is more
>> accurate and should be a little safer from a maintenance point of
>> view.
> 
> Except that this breaks the code. hpages is unioned with hpas...
> 

OK. 

>> @@ -212,10 +211,9 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>>  		if (!page)
>>  			continue;
>>  
>> -		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
>> -			SetPageDirty(page);
>> +		put_user_pages_dirty_lock(&mem->hpages[i], 1,
>> +					  MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);
> 
> And the dirtying condition is wrong here as well. Currently it is always
> true.
> 
> 								Honza
> 

Yes. Fixed up locally. The function now looks like this (for this patch, not for
the entire series, which renames "put" to "unpin"):


static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
{
	long i;
	struct page *page = NULL;

	if (!mem->hpas)
		return;

	for (i = 0; i < mem->entries; ++i) {
		if (!mem->hpas[i])
			continue;

		page = pfn_to_page(mem->hpas[i] >> PAGE_SHIFT);
		if (!page)
			continue;

		put_user_pages_dirty_lock(&page, 1,
				mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);

		mem->hpas[i] = 0;
	}
}

thanks,
-- 
John Hubbard
NVIDIA

