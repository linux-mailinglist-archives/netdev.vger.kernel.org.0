Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA911C5AD
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 06:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfLLF4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 00:56:38 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14305 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfLLF4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 00:56:37 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df1d68d0000>; Wed, 11 Dec 2019 21:56:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Dec 2019 21:56:36 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Dec 2019 21:56:36 -0800
Received: from [10.2.165.195] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 05:56:35 +0000
Subject: Re: [PATCH v9 23/25] mm/gup: track FOLL_PIN pages
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
 <20191211025318.457113-24-jhubbard@nvidia.com>
 <20191211112807.GN1551@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <f961d0b6-c660-85b9-ad01-53bce74e39e9@nvidia.com>
Date:   Wed, 11 Dec 2019 21:53:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191211112807.GN1551@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576130189; bh=WUvMFBOwsTbLT+9CzNbxGtAponFsFsmTJOyg8MjL8ds=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lsWfVOx2mYuCSEqMXkqo0p3SpKqw9VwSL+20QlVcuyoMSELQtTCN0YxM6RzLVo9oa
         uq4Hl9KFn70q6l1bzqmgaiV5HLk4+H2168Aq1l5uWc+mWWgNKPzhftF1QMyxl40GPe
         nNNgDtbzvAru+MjxE1MbEaMe+90vfqRYKPVuX/JzejQXCe2EVI5eyYy9CwInRuqtjp
         2idGFh4dXFAMfDwQiKAN1Pz/TUuUoswEkyfXdQEyWp7z5jAlzfpntkPH8s96FOaimZ
         1olYa+8gPiG8ccYKitvEKwCbv3GPr0UXUD+T0zjEzw7D9d6fQ9awWSzCOfMJ4VZl20
         16ivttgOjkh4A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 3:28 AM, Jan Kara wrote:
...
>=20
> The patch looks mostly good to me now. Just a few smaller comments below.
>=20
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20
> I think you inherited here the Reviewed-by tags from the "add flags" patc=
h
> you've merged into this one but that's not really fair since this patch
> does much more... In particular I didn't give my Reviewed-by tag for this
> patch yet.

OK, I've removed those reviewed-by's. (I felt bad about dropping them, afte=
r
people had devoted time to reviewing, but I do see that it's wrong to imply
that they've reviewed this much much larger thing.)

...
>=20
> I somewhat wonder about the asymmetry of try_grab_compound_head() vs
> try_grab_page() in the treatment of 'flags'. How costly would it be to ma=
ke
> them symmetric (i.e., either set FOLL_GET for try_grab_compound_head()
> callers or make sure one of FOLL_GET, FOLL_PIN is set for try_grab_page()=
)?
>=20
> Because this difference looks like a subtle catch in the long run...

Done. It is only a modest code-level change, at least the way I've done it,=
 which is
setting FOLL_GET for try_grab_compound_head(). In order to do that, I set
it at the top of the internal gup fast calling stacks, which is actually a =
good
design anyway: gup fast is logically doing FOLL_GET in all cases. So settin=
g
the flag internally is accurate and consistent with the overall design.


> ...
>=20
>> @@ -1522,8 +1536,8 @@ struct page *follow_trans_huge_pmd(struct vm_area_=
struct *vma,
>>   skip_mlock:
>>   	page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>>   	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), pag=
e);
>> -	if (flags & FOLL_GET)
>> -		get_page(page);
>> +	if (!try_grab_page(page, flags))
>> +		page =3D ERR_PTR(-EFAULT);
>=20
> I think you need to also move the try_grab_page() earlier in the function=
.
> At this point the page may be marked as mlocked and you'd need to undo th=
at
> in case try_grab_page() fails.


OK, I've moved it up, adding a "subpage" variable in order to make that wor=
k.

>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ac65bb5e38ac..0aab6fe0072f 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4356,7 +4356,13 @@ long follow_hugetlb_page(struct mm_struct *mm, st=
ruct vm_area_struct *vma,
>>   same_page:
>>   		if (pages) {
>>   			pages[i] =3D mem_map_offset(page, pfn_offset);
>> -			get_page(pages[i]);
>> +			if (!try_grab_page(pages[i], flags)) {
>> +				spin_unlock(ptl);
>> +				remainder =3D 0;
>> +				err =3D -ENOMEM;
>> +				WARN_ON_ONCE(1);
>> +				break;
>> +			}
>>   		}
>=20
> This function does a refcount overflow check early so that it doesn't hav=
e
> to do try_get_page() here. So that check can be now removed when you do
> try_grab_page() here anyway since that early check seems to be just a tin=
y
> optimization AFAICT.
>=20
> 								Honza
>=20

Yes. I've removed it, good spot.


thanks,
--=20
John Hubbard
NVIDIA
