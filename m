Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B86101029
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfKSAWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:22:46 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6982 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKSAWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:22:45 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd335d60001>; Mon, 18 Nov 2019 16:22:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 18 Nov 2019 16:22:44 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 18 Nov 2019 16:22:44 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 00:22:43 +0000
Subject: Re: [PATCH v5 17/24] mm/gup: track FOLL_PIN pages
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
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-18-jhubbard@nvidia.com>
 <20191118115829.GJ17319@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <8424f891-271d-5c34-8f7c-ebf3e3aa6664@nvidia.com>
Date:   Mon, 18 Nov 2019 16:22:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191118115829.GJ17319@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574122967; bh=ip2xVJC+jxbL/7d2eWhZjqdIi4kB0uoxgzyWnYDs5q4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=kZWTJaB6BUYpdW+z0HXxRztjdsBPgYMtIagp6++GXQ1xMYEqmDvkuTu5SJexcfc3Z
         aqvcG/+YbvfnrntTmKpTzXcCcJ1vacUs8Vt+kkZFmecCKGt5ESA8XOWs62Cbve3dr3
         XsCtQVKM4yFI8r3EtkYIToV94nBwkk0bzSnRfhI6IY4EfMEr9iYp9o7iElBN+PNDoe
         GYMLDs4YJjT+MkCB6avfM8/DST4lwWHJbTQrh01mIBzcPCF4cBGDQd1OqtdqCqvly5
         URQ6TTy1wBAC/IlVtHZs8b+E7d7tANvL2AVJcuHSx7ushKjPgli8Izd92XqBpLulsV
         NLxmWdrhMpwGw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 3:58 AM, Jan Kara wrote:
> On Thu 14-11-19 21:53:33, John Hubbard wrote:
>> Add tracking of pages that were pinned via FOLL_PIN.
>>
>> As mentioned in the FOLL_PIN documentation, callers who effectively set
>> FOLL_PIN are required to ultimately free such pages via put_user_page().
>> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
>> for DIO and/or RDMA use".
>>
>> Pages that have been pinned via FOLL_PIN are identifiable via a
>> new function call:
>>
>>    bool page_dma_pinned(struct page *page);
>>
>> What to do in response to encountering such a page, is left to later
>> patchsets. There is discussion about this in [1].
> 						^^ missing this reference
> in the changelog...

I'll add that.=20

>=20
>> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 6588d2e02628..db872766480f 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1054,6 +1054,8 @@ static inline __must_check bool try_get_page(struc=
t page *page)
>>  	return true;
>>  }
>> =20
>> +__must_check bool user_page_ref_inc(struct page *page);
>> +
>>  static inline void put_page(struct page *page)
>>  {
>>  	page =3D compound_head(page);
>> @@ -1071,29 +1073,70 @@ static inline void put_page(struct page *page)
>>  		__put_page(page);
>>  }
>> =20
>> -/**
>> - * put_user_page() - release a gup-pinned page
>> - * @page:            pointer to page to be released
>> +/*
>> + * GUP_PIN_COUNTING_BIAS, and the associated functions that use it, ove=
rload
>> + * the page's refcount so that two separate items are tracked: the orig=
inal page
>> + * reference count, and also a new count of how many get_user_pages() c=
alls were
> 							^^ pin_user_pages()
>=20
>> + * made against the page. ("gup-pinned" is another term for the latter)=
.
>> + *
>> + * With this scheme, get_user_pages() becomes special: such pages are m=
arked
> 			^^^ pin_user_pages()
>=20
>> + * as distinct from normal pages. As such, the put_user_page() call (an=
d its
>> + * variants) must be used in order to release gup-pinned pages.
>> + *
>> + * Choice of value:
>>   *
>> - * Pages that were pinned via pin_user_pages*() must be released via ei=
ther
>> - * put_user_page(), or one of the put_user_pages*() routines. This is s=
o that
>> - * eventually such pages can be separately tracked and uniquely handled=
. In
>> - * particular, interactions with RDMA and filesystems need special hand=
ling.
>> + * By making GUP_PIN_COUNTING_BIAS a power of two, debugging of page re=
ference
>> + * counts with respect to get_user_pages() and put_user_page() becomes =
simpler,
> 				^^^ pin_user_pages()
>=20

Yes.

>> + * due to the fact that adding an even power of two to the page refcoun=
t has
>> + * the effect of using only the upper N bits, for the code that counts =
up using
>> + * the bias value. This means that the lower bits are left for the excl=
usive
>> + * use of the original code that increments and decrements by one (or a=
t least,
>> + * by much smaller values than the bias value).
>>   *
>> - * put_user_page() and put_page() are not interchangeable, despite this=
 early
>> - * implementation that makes them look the same. put_user_page() calls =
must
>> - * be perfectly matched up with pin*() calls.
>> + * Of course, once the lower bits overflow into the upper bits (and thi=
s is
>> + * OK, because subtraction recovers the original values), then visual i=
nspection
>> + * no longer suffices to directly view the separate counts. However, fo=
r normal
>> + * applications that don't have huge page reference counts, this won't =
be an
>> + * issue.
>> + *
>> + * Locking: the lockless algorithm described in page_cache_get_speculat=
ive()
>> + * and page_cache_gup_pin_speculative() provides safe operation for
>> + * get_user_pages and page_mkclean and other calls that race to set up =
page
>> + * table entries.
>>   */
> ...
>> @@ -2070,9 +2191,16 @@ static int gup_hugepte(pte_t *ptep, unsigned long=
 sz, unsigned long addr,
>>  	page =3D head + ((addr & (sz-1)) >> PAGE_SHIFT);
>>  	refs =3D __record_subpages(page, addr, end, pages + *nr);
>> =20
>> -	head =3D try_get_compound_head(head, refs);
>> -	if (!head)
>> -		return 0;
>> +	if (flags & FOLL_PIN) {
>> +		head =3D page;
>> +		if (unlikely(!user_page_ref_inc(head)))
>> +			return 0;
>> +		head =3D page;
>=20
> Why do you assign 'head' twice? Also the refcounting logic is repeated
> several times so perhaps you can factor it out in to a helper function or
> even move it to __record_subpages()?

OK.

>=20
>> +	} else {
>> +		head =3D try_get_compound_head(head, refs);
>> +		if (!head)
>> +			return 0;
>> +	}
>> =20
>>  	if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
>>  		put_compound_head(head, refs);
>=20
> So this will do the wrong thing for FOLL_PIN. We took just one "pin"
> reference there but here we'll release 'refs' normal references AFAICT.
> Also the fact that you take just one pin reference for each huge page
> substantially changes how GUP refcounting works in the huge page case.
> Currently, FOLL_GET users can be completely agnostic of huge pages. So yo=
u
> can e.g. GUP whole 2 MB page, submit it as 2 different bios and then
> drop page references from each bio completion function. With your new
> FOLL_PIN behavior you cannot do that and I believe it will be a problem f=
or
> some users. So I think you have to maintain the behavior that you increas=
e
> the head->_refcount by (refs * GUP_PIN_COUNTING_BIAS) here.
>=20

Yes, completely agreed, this was a (big) oversight. I went through the same
reasoning and reached your conclusions, in __gup_device_huge(), but then
did it wrong in these functions. Will fix.

thanks,
--=20
John Hubbard
NVIDIA
