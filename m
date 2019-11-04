Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7468EEE7E5
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfKDTEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:04:42 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16344 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDTEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:04:41 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc0764e0000>; Mon, 04 Nov 2019 11:04:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 11:04:39 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 11:04:39 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 19:04:38 +0000
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
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
Date:   Mon, 4 Nov 2019 11:04:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104173325.GD5134@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572894286; bh=kXFfoa96CjeMxu/yNlagPA6LLNAu70eBUsA06ExlOtg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=CGhErLefJ4Rd4fl6xSTC12CgERoyFjHWQGLEBwXbgJ2nZYGGuplhwaAucXTJzeeNK
         7KRJyNQnA11L4vItnHz1sLBsORlDWdAkA/ZWVdCe/zvdJMM52vn/1Yk2OBp/W/Dq1T
         cFSSDEh86RVrVz/0q78GLgUN0uUGLFJZUZdX2Fl6rpKC6TlU/Ir0hTy7uItCyFW8Za
         W+S8GdUZi+MhpaV5QT4z4khopwYOYhIHRBDl1hUf1rvr4b1dc8B1ZAcRLRgjjchNom
         s2Ey6jwAxh3PTYyEBkc6VY0f/i8pk0d/xLfZmGpLvA4HcRrg88VOSkXk7tAEv24uKR
         Y51dSM7lMwnHw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 9:33 AM, Jerome Glisse wrote:
...
>=20
> Few nitpick belows, nonetheless:
>=20
> Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> [...]
>> +
>> +CASE 3: ODP
>> +-----------
>> +(Mellanox/Infiniband On Demand Paging: the hardware supports
>> +replayable page faulting). There are GUP references to pages serving as=
 DMA
>> +buffers. For ODP, MMU notifiers are used to synchronize with page_mkcle=
an()
>> +and munmap(). Therefore, normal GUP calls are sufficient, so neither fl=
ag
>> +needs to be set.
>=20
> I would not include ODP or anything like it here, they do not use
> GUP anymore and i believe it is more confusing here. I would how-
> ever include some text in this documentation explaining that hard-
> ware that support page fault is superior as it does not incur any
> of the issues described here.

OK, agreed, here's a new write up that I'll put in v3:


CASE 3: ODP
-----------
Advanced, but non-CPU (DMA) hardware that supports replayable page faults.
Here, a well-written driver doesn't normally need to pin pages at all. Howe=
ver,
if the driver does choose to do so, it can register MMU notifiers for the r=
ange,
and will be called back upon invalidation. Either way (avoiding page pinnin=
g, or
using MMU notifiers to unpin upon request), there is proper synchronization=
 with=20
both filesystem and mm (page_mkclean(), munmap(), etc).

Therefore, neither flag needs to be set.

It's worth mentioning here that pinning pages should not be the first desig=
n
choice. If page fault capable hardware is available, then the software shou=
ld
be written so that it does not pin pages. This allows mm and filesystems to
operate more efficiently and reliably.

> [...]
>=20
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 199da99e8ffc..1aea48427879 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>=20
> [...]
>=20
>> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_lock=
ed(struct task_struct *tsk,
>>  		BUG_ON(*locked !=3D 1);
>>  	}
>> =20
>> -	if (pages)
>> +	/*
>> +	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
>> +	 * is to set FOLL_GET if the caller wants pages[] filled in (but has
>> +	 * carelessly failed to specify FOLL_GET), so keep doing that, but onl=
y
>> +	 * for FOLL_GET, not for the newer FOLL_PIN.
>> +	 *
>> +	 * FOLL_PIN always expects pages to be non-null, but no need to assert
>> +	 * that here, as any failures will be obvious enough.
>> +	 */
>> +	if (pages && !(flags & FOLL_PIN))
>>  		flags |=3D FOLL_GET;
>=20
> Did you look at user that have pages and not FOLL_GET set ?
> I believe it would be better to first fix them to end up
> with FOLL_GET set and then error out if pages is !=3D NULL but
> nor FOLL_GET or FOLL_PIN is set.
>=20

I was perhaps overly cautious, and didn't go there. However, it's probably
doable, given that there was already the following in __get_user_pages():

    VM_BUG_ON(!!pages !=3D !!(gup_flags & FOLL_GET));

...which will have conditioned people and code to set FOLL_GET together wit=
h
pages. So I agree that the time is right.

In order to make bisecting future failures simpler, I can insert a patch ri=
ght=20
before this one, that changes the FOLL_GET setting into an assert, like thi=
s:

diff --git a/mm/gup.c b/mm/gup.c
index 8f236a335ae9..be338961e80d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1014,8 +1014,8 @@ static __always_inline long __get_user_pages_locked(s=
truct task_struct *tsk,
                BUG_ON(*locked !=3D 1);
        }
=20
-       if (pages)
-               flags |=3D FOLL_GET;
+       if (pages && WARN_ON_ONCE(!(gup_flags & FOLL_GET)))
+               return -EINVAL;
=20
        pages_done =3D 0;
        lock_dropped =3D false;


...and then add in FOLL_PIN, with this patch.

>> =20
>>  	pages_done =3D 0;
>=20
>> @@ -2373,24 +2402,9 @@ static int __gup_longterm_unlocked(unsigned long =
start, int nr_pages,
>>  	return ret;
>>  }
>> =20
>> -/**
>> - * get_user_pages_fast() - pin user pages in memory
>> - * @start:	starting user address
>> - * @nr_pages:	number of pages from start to pin
>> - * @gup_flags:	flags modifying pin behaviour
>> - * @pages:	array that receives pointers to the pages pinned.
>> - *		Should be at least nr_pages long.
>> - *
>> - * Attempt to pin user pages in memory without taking mm->mmap_sem.
>> - * If not successful, it will fall back to taking the lock and
>> - * calling get_user_pages().
>> - *
>> - * Returns number of pages pinned. This may be fewer than the number
>> - * requested. If nr_pages is 0 or negative, returns 0. If no pages
>> - * were pinned, returns -errno.
>> - */
>> -int get_user_pages_fast(unsigned long start, int nr_pages,
>> -			unsigned int gup_flags, struct page **pages)
>> +static int internal_get_user_pages_fast(unsigned long start, int nr_pag=
es,
>> +					unsigned int gup_flags,
>> +					struct page **pages)
>=20
> Usualy function are rename to _old_func_name ie add _ in front. So
> here it would become _get_user_pages_fast but i know some people
> don't like that as sometimes we endup with ___function_overloaded :)

Exactly: the __get_user_pages* names were already used for *non*-internal
routines, so I attempted to pick the next best naming prefix.

>=20
>>  {
>>  	unsigned long addr, len, end;
>>  	int nr =3D 0, ret =3D 0;
>=20
>=20
>> @@ -2435,4 +2449,215 @@ int get_user_pages_fast(unsigned long start, int=
 nr_pages,
>=20
> [...]
>=20
>> +/**
>> + * pin_user_pages_remote() - pin pages for (typically) use by Direct IO=
, and
>> + * return the pages to the user.
>=20
> Not a fan of (typically) maybe:
> pin_user_pages_remote() - pin pages of a remote process (task !=3D curren=
t)
>=20
> I think here the remote part if more important that DIO. Remote is use by
> other thing that DIO.

Yes, good point. I'll use your wording:

 * pin_user_pages_remote() - pin pages of a remote process (task !=3D curre=
nt)



>=20
>> + *
>> + * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is =
set. See
>> + * get_user_pages_remote() for documentation on the function arguments,=
 because
>> + * the arguments here are identical.
>> + *
>> + * FOLL_PIN means that the pages must be released via put_user_page(). =
Please
>> + * see Documentation/vm/pin_user_pages.rst for details.
>> + *
>> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages=
.rst. It
>> + * is NOT intended for Case 2 (RDMA: long-term pins).
>> + */
>> +long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *m=
m,
>> +			   unsigned long start, unsigned long nr_pages,
>> +			   unsigned int gup_flags, struct page **pages,
>> +			   struct vm_area_struct **vmas, int *locked)
>> +{
>> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
>> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
>> +		return -EINVAL;
>> +
>> +	gup_flags |=3D FOLL_TOUCH | FOLL_REMOTE | FOLL_PIN;
>> +
>> +	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
>> +				       locked, gup_flags);
>> +}
>> +EXPORT_SYMBOL(pin_user_pages_remote);
>> +
>> +/**
>> + * pin_longterm_pages_remote() - pin pages for (typically) use by Direc=
t IO, and
>> + * return the pages to the user.
>=20
> I think you copy pasted this from pin_user_pages_remote() :)

I admit to nothing, with respect to copy-paste! :)

This one can simply be:

 * pin_longterm_pages_remote() - pin pages of a remote process (task !=3D c=
urrent)


>=20
>> + *
>> + * Nearly the same as get_user_pages_remote(), but note that FOLL_TOUCH=
 is not
>> + * set, and FOLL_PIN and FOLL_LONGTERM are set. See get_user_pages_remo=
te() for
>> + * documentation on the function arguments, because the arguments here =
are
>> + * identical.
>> + *
>> + * FOLL_PIN means that the pages must be released via put_user_page(). =
Please
>> + * see Documentation/vm/pin_user_pages.rst for further details.
>> + *
>> + * FOLL_LONGTERM means that the pages are being pinned for "long term" =
use,
>> + * typically by a non-CPU device, and we cannot be sure that waiting fo=
r a
>> + * pinned page to become unpin will be effective.
>> + *
>> + * This is intended for Case 2 (RDMA: long-term pins) in
>> + * Documentation/vm/pin_user_pages.rst.
>> + */
>> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struc=
t *mm,
>> +			       unsigned long start, unsigned long nr_pages,
>> +			       unsigned int gup_flags, struct page **pages,
>> +			       struct vm_area_struct **vmas, int *locked)
>> +{
>> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
>> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * FIXME: as noted in the get_user_pages_remote() implementation, it
>> +	 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONGTERM
>> +	 * needs to be set, but for now the best we can do is a "TODO" item.
>> +	 */
>> +	gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
>=20
> Wouldn't it be better to not add pin_longterm_pages_remote() until
> it can be properly implemented ?
>=20

Well, the problem is that I need each call site that requires FOLL_PIN
to use a proper wrapper. It's the FOLL_PIN that is the focus here, because
there is a hard, bright rule, which is: if and only if a caller sets
FOLL_PIN, then the dma-page tracking happens, and put_user_page() must
be called.

So this leaves me with only two reasonable choices:

a) Convert the call site as above: pin_longterm_pages_remote(), which sets
FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation exactly
as it has been so far. When the FOLL_LONGTERM situation is fixed, the call
site *might* not need any changes to adopt the working gup.c code.

b) Convert the call site to pin_user_pages_remote(), which also sets
FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as before.
There would also be a comment at the call site, to the effect of, "this
is the wrong call to make: it really requires FOLL_LONGTERM behavior".

When the FOLL_LONGTERM situation is fixed, the call site will need to be
changed to pin_longterm_pages_remote().

So you can probably see why I picked (a).


thanks,

John Hubbard
NVIDIA
