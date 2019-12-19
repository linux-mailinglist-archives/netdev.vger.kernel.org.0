Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E7012588B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLSAfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:35:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4798 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSAfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:35:22 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfac5be0002>; Wed, 18 Dec 2019 16:35:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Dec 2019 16:35:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Dec 2019 16:35:20 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 00:35:19 +0000
Subject: Re: [PATCH v11 04/25] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-5-jhubbard@nvidia.com>
 <20191218160420.gyt4c45e6zsnxqv6@box>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <ddd08105-f48a-dbe1-7de1-f2fa2c5772a9@nvidia.com>
Date:   Wed, 18 Dec 2019 16:32:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218160420.gyt4c45e6zsnxqv6@box>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576715711; bh=lLxcLcvWuEdaa9mbUu8pEb7NikbQGA+3x199V+Yf2Go=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cYi9HYXpThVPsCQ2FAhPpBmvg9pzZEnocfVab3p1rbztjUsDI5b7umJJYuIEvZ0PR
         vx+h2sHA10T2/Q1X4aDK6z59gq6N+0cBNEv1SBLGL1VNlncyvmlNdNaO1iWAyTGswr
         udKbzxqm/wjq006CK108fXCeD0IesoZvzh/gx+LNePAFcn6r9jhacWQ3SpCYW8xspg
         AWQc+0t7+YICrLyj0yQoqsCoU6687MNUgeKhf8m6yAmv/OIxmxbjV85i5eQJrONL9B
         rit0zRnR4Y3ZhStASBSUCGicK22P7QWUhCF8hgj/JAlQLXg8wWjGsZLK//Xu0ERwbe
         cFLl9sQIYjnfg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 8:04 AM, Kirill A. Shutemov wrote:
> On Mon, Dec 16, 2019 at 02:25:16PM -0800, John Hubbard wrote:
>> An upcoming patch changes and complicates the refcounting and
>> especially the "put page" aspects of it. In order to keep
>> everything clean, refactor the devmap page release routines:
>>
>> * Rename put_devmap_managed_page() to page_is_devmap_managed(),
>>    and limit the functionality to "read only": return a bool,
>>    with no side effects.
>>
>> * Add a new routine, put_devmap_managed_page(), to handle checking
>>    what kind of page it is, and what kind of refcount handling it
>>    requires.
>>
>> * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
>>    and limit the functionality to unconditionally freeing a devmap
>>    page.
> 
> What the reason to separate put_devmap_managed_page() from
> free_devmap_managed_page() if free_devmap_managed_page() has exacly one
> caller? Is it preparation for the next patches?


Yes. A later patch, #23, adds another caller: __unpin_devmap_managed_user_page().

...
>> @@ -971,7 +971,14 @@ static inline bool put_devmap_managed_page(struct page *page)
>>   	return false;
>>   }
>>   
>> +bool put_devmap_managed_page(struct page *page);
>> +
>>   #else /* CONFIG_DEV_PAGEMAP_OPS */
>> +static inline bool page_is_devmap_managed(struct page *page)
>> +{
>> +	return false;
>> +}
>> +
>>   static inline bool put_devmap_managed_page(struct page *page)
>>   {
>>   	return false;
>> @@ -1028,8 +1035,10 @@ static inline void put_page(struct page *page)
>>   	 * need to inform the device driver through callback. See
>>   	 * include/linux/memremap.h and HMM for details.
>>   	 */
>> -	if (put_devmap_managed_page(page))
>> +	if (page_is_devmap_managed(page)) {
>> +		put_devmap_managed_page(page);
> 
> put_devmap_managed_page() has yet another page_is_devmap_managed() check
> inside. It looks strange.
> 

Good point, it's an extra unnecessary check. So to clean it up, I'll note
that the "if" check is required here in put_page(), in order to stay out of
non-inlined function calls in the hot path (put_page()). So I'll do the
following:

* Leave the above code as it is here

* Simplify put_devmap_managed_page(), it was trying to do two separate things,
   and those two things have different requirements. So change it to a void
   function, with a WARN_ON_ONCE to assert that page_is_devmap_managed() is true,

* And change the other caller (release_pages()) to do that check.

...
>> @@ -1102,3 +1102,27 @@ void __init swap_setup(void)
>>   	 * _really_ don't want to cluster much more
>>   	 */
>>   }
>> +
>> +#ifdef CONFIG_DEV_PAGEMAP_OPS
>> +bool put_devmap_managed_page(struct page *page)
>> +{
>> +	bool is_devmap = page_is_devmap_managed(page);
>> +
>> +	if (is_devmap) {
> 
> Reversing the condition would save you an indentation level.

Yes. Done.

I'll also git-reply with an updated patch so you can see what it looks like.


thanks,
-- 
John Hubbard
NVIDIA
