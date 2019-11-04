Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6E4EE859
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbfKDTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:30:36 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2050 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDTaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:30:35 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc07c5f0000>; Mon, 04 Nov 2019 11:30:39 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 11:30:33 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 11:30:33 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 19:30:32 +0000
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
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
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
Date:   Mon, 4 Nov 2019 11:30:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104191811.GI5134@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572895839; bh=4bBXDhcnAvf/UNaIaERnnHztx1MZo0i9KcDepWFrcDI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=N7o5kNr/onfpbpTkDkcET17D1txOG2LPXemOd+E+RUCurbTzfnK4HybyAK4eO9VMh
         /WA6Gjpr3d+HnPyWwcFQjIWqh6PFu25AQdh6E4cPKroXl6Z6PiXQQNZd9O8NbKe2VJ
         EALC1QWpHVawx3KHhJ4QlFBaBQaAtVQmfTfjtc1ixIWfqESqAK5r4Iwv5NkSGDw7Ru
         RX+Qmp3UxOLe+pMgAfJDtJmiX1zSTnb30+KbUkFzsr+NuVeSs4gFqmy/tdw2feg3JN
         c47Fjq2XnouO8SaER8nRQLLk9EaLzIhVe73FJUSIkcSD+fYv0Gi7WxfIP0kuBSYref
         5Xxmg51W0i3PQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 11:18 AM, Jerome Glisse wrote:
> On Mon, Nov 04, 2019 at 11:04:38AM -0800, John Hubbard wrote:
>> On 11/4/19 9:33 AM, Jerome Glisse wrote:
>> ...
>>>
>>> Few nitpick belows, nonetheless:
>>>
>>> Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
>>> [...]
>>>> +
>>>> +CASE 3: ODP
>>>> +-----------
>>>> +(Mellanox/Infiniband On Demand Paging: the hardware supports
>>>> +replayable page faulting). There are GUP references to pages serving =
as DMA
>>>> +buffers. For ODP, MMU notifiers are used to synchronize with page_mkc=
lean()
>>>> +and munmap(). Therefore, normal GUP calls are sufficient, so neither =
flag
>>>> +needs to be set.
>>>
>>> I would not include ODP or anything like it here, they do not use
>>> GUP anymore and i believe it is more confusing here. I would how-
>>> ever include some text in this documentation explaining that hard-
>>> ware that support page fault is superior as it does not incur any
>>> of the issues described here.
>>
>> OK, agreed, here's a new write up that I'll put in v3:
>>
>>
>> CASE 3: ODP
>> -----------
>=20
> ODP is RDMA, maybe Hardware with page fault support instead
>=20
>> Advanced, but non-CPU (DMA) hardware that supports replayable page fault=
s.

OK, so:

    "RDMA hardware with page faulting support."

for the first sentence.


>> Here, a well-written driver doesn't normally need to pin pages at all. H=
owever,
>> if the driver does choose to do so, it can register MMU notifiers for th=
e range,
>> and will be called back upon invalidation. Either way (avoiding page pin=
ning, or
>> using MMU notifiers to unpin upon request), there is proper synchronizat=
ion with=20
>> both filesystem and mm (page_mkclean(), munmap(), etc).
>>
>> Therefore, neither flag needs to be set.
>=20
> In fact GUP should never be use with those.


Yes. The next paragraph says that, but maybe not strong enough.


>>
>> It's worth mentioning here that pinning pages should not be the first de=
sign
>> choice. If page fault capable hardware is available, then the software s=
hould
>> be written so that it does not pin pages. This allows mm and filesystems=
 to
>> operate more efficiently and reliably.

Here's what we have after the above changes:

CASE 3: ODP
-----------
RDMA hardware with page faulting support. Here, a well-written driver doesn=
't
normally need to pin pages at all. However, if the driver does choose to do=
 so,
it can register MMU notifiers for the range, and will be called back upon
invalidation. Either way (avoiding page pinning, or using MMU notifiers to =
unpin
upon request), there is proper synchronization with both filesystem and mm
(page_mkclean(), munmap(), etc).

Therefore, neither flag needs to be set.

In this case, ideally, neither get_user_pages() nor pin_user_pages() should=
 be=20
called. Instead, the software should be written so that it does not pin pag=
es.=20
This allows mm and filesystems to operate more efficiently and reliably.

>>> [...]
>>>
>>>> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_lo=
cked(struct task_struct *tsk,
>>>>  		BUG_ON(*locked !=3D 1);
>>>>  	}
>>>> =20
>>>> -	if (pages)
>>>> +	/*
>>>> +	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavio=
r
>>>> +	 * is to set FOLL_GET if the caller wants pages[] filled in (but has
>>>> +	 * carelessly failed to specify FOLL_GET), so keep doing that, but o=
nly
>>>> +	 * for FOLL_GET, not for the newer FOLL_PIN.
>>>> +	 *
>>>> +	 * FOLL_PIN always expects pages to be non-null, but no need to asse=
rt
>>>> +	 * that here, as any failures will be obvious enough.
>>>> +	 */
>>>> +	if (pages && !(flags & FOLL_PIN))
>>>>  		flags |=3D FOLL_GET;
>>>
>>> Did you look at user that have pages and not FOLL_GET set ?
>>> I believe it would be better to first fix them to end up
>>> with FOLL_GET set and then error out if pages is !=3D NULL but
>>> nor FOLL_GET or FOLL_PIN is set.
>>>
>>
>> I was perhaps overly cautious, and didn't go there. However, it's probab=
ly
>> doable, given that there was already the following in __get_user_pages()=
:
>>
>>     VM_BUG_ON(!!pages !=3D !!(gup_flags & FOLL_GET));
>>
>> ...which will have conditioned people and code to set FOLL_GET together =
with
>> pages. So I agree that the time is right.
>>
>> In order to make bisecting future failures simpler, I can insert a patch=
 right=20
>> before this one, that changes the FOLL_GET setting into an assert, like =
this:
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 8f236a335ae9..be338961e80d 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -1014,8 +1014,8 @@ static __always_inline long __get_user_pages_locke=
d(struct task_struct *tsk,
>>                 BUG_ON(*locked !=3D 1);
>>         }
>> =20
>> -       if (pages)
>> -               flags |=3D FOLL_GET;
>> +       if (pages && WARN_ON_ONCE(!(gup_flags & FOLL_GET)))
>> +               return -EINVAL;
>> =20
>>         pages_done =3D 0;
>>         lock_dropped =3D false;
>>
>>
>> ...and then add in FOLL_PIN, with this patch.
>=20
> looks good but double check that it should not happens, i will try
> to check on my side too.

Yes, I'll look.

...
>>>> +	 */
>>>> +	gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
>>>
>>> Wouldn't it be better to not add pin_longterm_pages_remote() until
>>> it can be properly implemented ?
>>>
>>
>> Well, the problem is that I need each call site that requires FOLL_PIN
>> to use a proper wrapper. It's the FOLL_PIN that is the focus here, becau=
se
>> there is a hard, bright rule, which is: if and only if a caller sets
>> FOLL_PIN, then the dma-page tracking happens, and put_user_page() must
>> be called.
>>
>> So this leaves me with only two reasonable choices:
>>
>> a) Convert the call site as above: pin_longterm_pages_remote(), which se=
ts
>> FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation exactl=
y
>> as it has been so far. When the FOLL_LONGTERM situation is fixed, the ca=
ll
>> site *might* not need any changes to adopt the working gup.c code.
>>
>> b) Convert the call site to pin_user_pages_remote(), which also sets
>> FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as before.
>> There would also be a comment at the call site, to the effect of, "this
>> is the wrong call to make: it really requires FOLL_LONGTERM behavior".
>>
>> When the FOLL_LONGTERM situation is fixed, the call site will need to be
>> changed to pin_longterm_pages_remote().
>>
>> So you can probably see why I picked (a).
>=20
> But right now nobody has FOLL_LONGTERM and FOLL_REMOTE. So you should
> never have the need for pin_longterm_pages_remote(). My fear is that
> longterm has implication and it would be better to not drop this implicat=
ion
> by adding a wrapper that does not do what the name says.
>=20
> So do not introduce pin_longterm_pages_remote() until its first user
> happens. This is option c)
>=20

Almost forgot, though: there is already another user: Infiniband:

drivers/infiniband/core/umem_odp.c:646:         npages =3D pin_longterm_pag=
es_remote(owning_process, owning_mm,



thanks,

John Hubbard
NVIDIA
