Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214C9EF1D6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbfKEASi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:18:38 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17961 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfKEASh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:18:37 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc0bfe10001>; Mon, 04 Nov 2019 16:18:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 16:18:35 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 16:18:35 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 00:18:34 +0000
Subject: Re: [PATCH v2 12/18] mm/gup: track FOLL_PIN pages
To:     Jerome Glisse <jglisse@redhat.com>
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
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-13-jhubbard@nvidia.com>
 <20191104185238.GG5134@redhat.com>
 <7821cf87-75a8-45e2-cf28-f85b62192416@nvidia.com>
 <20191104234920.GA18515@redhat.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <f587647d-83dc-5bde-d244-f522ec5bda60@nvidia.com>
Date:   Mon, 4 Nov 2019 16:18:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104234920.GA18515@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572913121; bh=it/avAzbdjbPt9c7ZhR3SugLAHDAeo7qSUQnTa8Gd0Y=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nx62lGrPMlwQBcqF9vYxqUTNBIlMwnY3v4vXnUqcAbCO2/xdO7aUYp8qclkmts9z7
         gtH9Ov6maSgTLFms+gOL/dE2dCoQ1xMQpdGQy9Akbo7N7NyETXXQXZTJZqjI7N8kF+
         n3RQEPIGAaiZBh6nvWW7FoLz32nqtlJ71DClIb0EMAf4xWjkAmpFYtedbKPVLxdf/b
         tlQKPTEISDGthKQTi64XGZlvQXC4V843TbV9Pv5FMwu9POX8T7Ox5OlQOI/t1RVVuU
         ehgOt7zOUTQcQRd6bK+4WI3VER1yK/cV2GljR29nekSSEXFENv8o9uy5i0m+683Ub0
         piAG/LY3Z7DNw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan, there is a question for you further down:


On 11/4/19 3:49 PM, Jerome Glisse wrote:
> On Mon, Nov 04, 2019 at 02:49:18PM -0800, John Hubbard wrote:
...
>>> Maybe add a small comment about wrap around :)
>>
>>
>> I don't *think* the count can wrap around, due to the checks in user_page_ref_inc().
>>
>> But it's true that the documentation is a little light here...What did you have 
>> in mind?
> 
> About false positive case (and how unlikely they are) and that wrap
> around is properly handle. Maybe just a pointer to the documentation
> so that people know they can go look there for details. I know my
> brain tend to forget where to look for things so i like to be constantly
> reminded hey the doc is Documentations/foobar :)
> 

I see. OK, here's a version with a thoroughly overhauled comment header:

/**
 * page_dma_pinned() - report if a page is pinned for DMA.
 *
 * This function checks if a page has been pinned via a call to
 * pin_user_pages*() or pin_longterm_pages*().
 *
 * The return value is partially fuzzy: false is not fuzzy, because it means
 * "definitely not pinned for DMA", but true means "probably pinned for DMA, but
 * possibly a false positive due to having at least GUP_PIN_COUNTING_BIAS worth
 * of normal page references".
 *
 * False positives are OK, because: a) it's unlikely for a page to get that many
 * refcounts, and b) all the callers of this routine are expected to be able to
 * deal gracefully with a false positive.
 *
 * For more information, please see Documentation/vm/pin_user_pages.rst.
 *
 * @page:	pointer to page to be queried.
 * @Return:	True, if it is likely that the page has been "dma-pinned".
 *		False, if the page is definitely not dma-pinned.
 */
static inline bool page_dma_pinned(struct page *page)


>>> [...]
>>>
>>>> @@ -1930,12 +2028,20 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>  
>>>>  		pgmap = get_dev_pagemap(pfn, pgmap);
>>>>  		if (unlikely(!pgmap)) {
>>>> -			undo_dev_pagemap(nr, nr_start, pages);
>>>> +			undo_dev_pagemap(nr, nr_start, flags, pages);
>>>>  			return 0;
>>>>  		}
>>>>  		SetPageReferenced(page);
>>>>  		pages[*nr] = page;
>>>> -		get_page(page);
>>>> +
>>>> +		if (flags & FOLL_PIN) {
>>>> +			if (unlikely(!user_page_ref_inc(page))) {
>>>> +				undo_dev_pagemap(nr, nr_start, flags, pages);
>>>> +				return 0;
>>>> +			}
>>>
>>> Maybe add a comment about a case that should never happens ie
>>> user_page_ref_inc() fails after the second iteration of the
>>> loop as it would be broken and a bug to call undo_dev_pagemap()
>>> after the first iteration of that loop.
>>>
>>> Also i believe that this should never happens as if first
>>> iteration succeed than __page_cache_add_speculative() will
>>> succeed for all the iterations.
>>>
>>> Note that the pgmap case above follows that too ie the call to
>>> get_dev_pagemap() can only fail on first iteration of the loop,
>>> well i assume you can never have a huge device page that span
>>> different pgmap ie different devices (which is a reasonable
>>> assumption). So maybe this code needs fixing ie :
>>>
>>> 		pgmap = get_dev_pagemap(pfn, pgmap);
>>> 		if (unlikely(!pgmap))
>>> 			return 0;
>>>
>>>
>>
>> OK, yes that does make sense. And I think a comment is adequate,
>> no need to check for bugs during every tail page iteration. So how 
>> about this, as a preliminary patch:
> 
> Actualy i thought about it and i think that there is pgmap
> per section and thus maybe one device can have multiple pgmap
> and that would be an issue for page bigger than section size
> (ie bigger than 128MB iirc). I will go double check that, but
> maybe Dan can chime in.
> 
> In any case my comment above is correct for the page ref
> increment, if the first one succeed than others will too
> or otherwise it means someone is doing too many put_page()/
> put_user_page() which is _bad_ :)
> 

I'll wait to hear from Dan before doing anything rash. :)


thanks,

John Hubbard
NVIDIA
