Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6E103504
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfKTHRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:17:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19872 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfKTHRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:17:23 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd4e87e0000>; Tue, 19 Nov 2019 23:17:18 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 23:17:17 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 23:17:17 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Nov
 2019 07:17:16 +0000
Subject: Re: [PATCH v6 17/24] mm/gup: track FOLL_PIN pages
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
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-18-jhubbard@nvidia.com>
 <20191119113746.GD25605@quack2.suse.cz>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <92d0385a-90be-e900-e5ec-1eeafd24ff81@nvidia.com>
Date:   Tue, 19 Nov 2019 23:17:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191119113746.GD25605@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574234238; bh=XS1elsnwWY0rNKRca94CapnxJDsibdDqnD818d/G+io=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cgfFkxVckFKph83JpaLozX1BPV67pcDvc4zYdLq9ggt/6dUFhjSjEUfkPlJ6YS85y
         Tzbfkd2Ssh+1cnbHZVu22ZxAYWyCv1b8X10VXVS5hS2byaCvY0Vg9ipA7x3Fo3odW9
         mJ8QOlZhdrlbORb/tooq8lEuT6AxTt5cVxDPZE9pOLHClbe3whACaJnf15veA5FbxQ
         N7Z3c9PH3VSrAZwjy0whi7ko1Q5RU1C8PJUljAOR0JzSWQ7k8UX3NdOtoVh+QLcZ15
         DmGFCQcpIJbV8FkJKisaDhzEEJcucwABlIhBeXVZln5jK7XEYXo5n/Z8Yardu3zdea
         jFCxWfbFbwpdA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 3:37 AM, Jan Kara wrote:
> On Tue 19-11-19 00:16:36, John Hubbard wrote:
>> @@ -2025,6 +2149,20 @@ static int __record_subpages(struct page *page, unsigned long addr,
>>  	return nr;
>>  }
>>  
>> +static bool __pin_compound_head(struct page *head, int refs, unsigned int flags)
>> +{
> 
> I don't quite like the proliferation of names starting with __. I don't
> think there's a good reason for that, particularly in this case. Also 'pin'
> here is somewhat misleading as we already use term "pin" for the particular
> way of pinning the page. We could have grab_compound_head() or maybe
> nail_compound_head() :), but you're native speaker so you may come up with
> better word.


Yes, it is ugly naming, I'll change these as follows:

    __pin_compound_head() --> grab_compound_head()    
    __record_subpages()   --> record_subpages()

I loved the "nail_compound_head()" suggestion, it just seems very vivid, but
in the end, I figured I'd better keep it relatively drab and colorless. :)

> 
>> +	if (flags & FOLL_PIN) {
>> +		if (unlikely(!try_pin_compound_head(head, refs)))
>> +			return false;
>> +	} else {
>> +		head = try_get_compound_head(head, refs);
>> +		if (!head)
>> +			return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  static void put_compound_head(struct page *page, int refs)
>>  {
>>  	/* Do a get_page() first, in case refs == page->_refcount */
> 
> put_compound_head() needs similar treatment as undo_dev_pagemap(), doesn't
> it?
> 

Yes, will fix that up.


>> @@ -968,7 +973,18 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
>>  	if (!*pgmap)
>>  		return ERR_PTR(-EFAULT);
>>  	page = pfn_to_page(pfn);
>> -	get_page(page);
>> +
>> +	if (flags & FOLL_GET)
>> +		get_page(page);
>> +	else if (flags & FOLL_PIN) {
>> +		/*
>> +		 * try_pin_page() is not actually expected to fail here because
>> +		 * we hold the pmd lock so no one can unmap the pmd and free the
>> +		 * page that it points to.
>> +		 */
>> +		if (unlikely(!try_pin_page(page)))
>> +			page = ERR_PTR(-EFAULT);
>> +	}
> 
> This pattern is rather common. So maybe I'd add a helper grab_page(page,
> flags) doing
> 
> 	if (flags & FOLL_GET)
> 		get_page(page);
> 	else if (flags & FOLL_PIN)
> 		return try_pin_page(page);
> 	return true;
> 

OK.

> Otherwise the patch looks good to me now.
> 
> 								Honza

Great! I thought I'd have a v7 out today, but fate decided to have me repair
my test machine instead. So, soon. ha. :)

thanks,
-- 
John Hubbard
NVIDIA
