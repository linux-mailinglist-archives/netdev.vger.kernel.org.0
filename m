Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5226FEE81A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfKDTSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:18:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47330 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728709AbfKDTSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572895108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zs/AvQwXwWpt7Urm8Vcs4dWF4CPpFhVLJwVL/sE+W78=;
        b=VetTDQtjx8FYb8enllYe48PRtmURIAZ2pp2waQLikePF2XU49erJGYgsXe9bfB8lWNoKve
        EKVp+q6jxtMAtuzyws/vPN0MwlpBe+dTzDH4qnStflwfUSekAWXT5yVYUqe2YpoFlhYeaw
        KwG2no8xeltbRfPYH3zMb8QRvBGKHAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-PE_S9-BONkCuAPXRiTCSRA-1; Mon, 04 Nov 2019 14:18:24 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D473477;
        Mon,  4 Nov 2019 19:18:20 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEAA35C1B2;
        Mon,  4 Nov 2019 19:18:12 +0000 (UTC)
Date:   Mon, 4 Nov 2019 14:18:11 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
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
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191104191811.GI5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: PE_S9-BONkCuAPXRiTCSRA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 11:04:38AM -0800, John Hubbard wrote:
> On 11/4/19 9:33 AM, Jerome Glisse wrote:
> ...
> >=20
> > Few nitpick belows, nonetheless:
> >=20
> > Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> > [...]
> >> +
> >> +CASE 3: ODP
> >> +-----------
> >> +(Mellanox/Infiniband On Demand Paging: the hardware supports
> >> +replayable page faulting). There are GUP references to pages serving =
as DMA
> >> +buffers. For ODP, MMU notifiers are used to synchronize with page_mkc=
lean()
> >> +and munmap(). Therefore, normal GUP calls are sufficient, so neither =
flag
> >> +needs to be set.
> >=20
> > I would not include ODP or anything like it here, they do not use
> > GUP anymore and i believe it is more confusing here. I would how-
> > ever include some text in this documentation explaining that hard-
> > ware that support page fault is superior as it does not incur any
> > of the issues described here.
>=20
> OK, agreed, here's a new write up that I'll put in v3:
>=20
>=20
> CASE 3: ODP
> -----------

ODP is RDMA, maybe Hardware with page fault support instead

> Advanced, but non-CPU (DMA) hardware that supports replayable page faults=
.
> Here, a well-written driver doesn't normally need to pin pages at all. Ho=
wever,
> if the driver does choose to do so, it can register MMU notifiers for the=
 range,
> and will be called back upon invalidation. Either way (avoiding page pinn=
ing, or
> using MMU notifiers to unpin upon request), there is proper synchronizati=
on with=20
> both filesystem and mm (page_mkclean(), munmap(), etc).
>=20
> Therefore, neither flag needs to be set.

In fact GUP should never be use with those.

>=20
> It's worth mentioning here that pinning pages should not be the first des=
ign
> choice. If page fault capable hardware is available, then the software sh=
ould
> be written so that it does not pin pages. This allows mm and filesystems =
to
> operate more efficiently and reliably.
>=20
> > [...]
> >=20
> >> diff --git a/mm/gup.c b/mm/gup.c
> >> index 199da99e8ffc..1aea48427879 100644
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >=20
> > [...]
> >=20
> >> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_lo=
cked(struct task_struct *tsk,
> >>  =09=09BUG_ON(*locked !=3D 1);
> >>  =09}
> >> =20
> >> -=09if (pages)
> >> +=09/*
> >> +=09 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behav=
ior
> >> +=09 * is to set FOLL_GET if the caller wants pages[] filled in (but h=
as
> >> +=09 * carelessly failed to specify FOLL_GET), so keep doing that, but=
 only
> >> +=09 * for FOLL_GET, not for the newer FOLL_PIN.
> >> +=09 *
> >> +=09 * FOLL_PIN always expects pages to be non-null, but no need to as=
sert
> >> +=09 * that here, as any failures will be obvious enough.
> >> +=09 */
> >> +=09if (pages && !(flags & FOLL_PIN))
> >>  =09=09flags |=3D FOLL_GET;
> >=20
> > Did you look at user that have pages and not FOLL_GET set ?
> > I believe it would be better to first fix them to end up
> > with FOLL_GET set and then error out if pages is !=3D NULL but
> > nor FOLL_GET or FOLL_PIN is set.
> >=20
>=20
> I was perhaps overly cautious, and didn't go there. However, it's probabl=
y
> doable, given that there was already the following in __get_user_pages():
>=20
>     VM_BUG_ON(!!pages !=3D !!(gup_flags & FOLL_GET));
>=20
> ...which will have conditioned people and code to set FOLL_GET together w=
ith
> pages. So I agree that the time is right.
>=20
> In order to make bisecting future failures simpler, I can insert a patch =
right=20
> before this one, that changes the FOLL_GET setting into an assert, like t=
his:
>=20
> diff --git a/mm/gup.c b/mm/gup.c
> index 8f236a335ae9..be338961e80d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1014,8 +1014,8 @@ static __always_inline long __get_user_pages_locked=
(struct task_struct *tsk,
>                 BUG_ON(*locked !=3D 1);
>         }
> =20
> -       if (pages)
> -               flags |=3D FOLL_GET;
> +       if (pages && WARN_ON_ONCE(!(gup_flags & FOLL_GET)))
> +               return -EINVAL;
> =20
>         pages_done =3D 0;
>         lock_dropped =3D false;
>=20
>=20
> ...and then add in FOLL_PIN, with this patch.

looks good but double check that it should not happens, i will try
to check on my side too.

>=20
> >> =20
> >>  =09pages_done =3D 0;
> >=20
> >> @@ -2373,24 +2402,9 @@ static int __gup_longterm_unlocked(unsigned lon=
g start, int nr_pages,
> >>  =09return ret;
> >>  }
> >> =20
> >> -/**
> >> - * get_user_pages_fast() - pin user pages in memory
> >> - * @start:=09starting user address
> >> - * @nr_pages:=09number of pages from start to pin
> >> - * @gup_flags:=09flags modifying pin behaviour
> >> - * @pages:=09array that receives pointers to the pages pinned.
> >> - *=09=09Should be at least nr_pages long.
> >> - *
> >> - * Attempt to pin user pages in memory without taking mm->mmap_sem.
> >> - * If not successful, it will fall back to taking the lock and
> >> - * calling get_user_pages().
> >> - *
> >> - * Returns number of pages pinned. This may be fewer than the number
> >> - * requested. If nr_pages is 0 or negative, returns 0. If no pages
> >> - * were pinned, returns -errno.
> >> - */
> >> -int get_user_pages_fast(unsigned long start, int nr_pages,
> >> -=09=09=09unsigned int gup_flags, struct page **pages)
> >> +static int internal_get_user_pages_fast(unsigned long start, int nr_p=
ages,
> >> +=09=09=09=09=09unsigned int gup_flags,
> >> +=09=09=09=09=09struct page **pages)
> >=20
> > Usualy function are rename to _old_func_name ie add _ in front. So
> > here it would become _get_user_pages_fast but i know some people
> > don't like that as sometimes we endup with ___function_overloaded :)
>=20
> Exactly: the __get_user_pages* names were already used for *non*-internal
> routines, so I attempted to pick the next best naming prefix.

Didn't know we were that far in the ___ :)

> >=20
> >>  {
> >>  =09unsigned long addr, len, end;
> >>  =09int nr =3D 0, ret =3D 0;
> >=20
> >=20
> >> @@ -2435,4 +2449,215 @@ int get_user_pages_fast(unsigned long start, i=
nt nr_pages,
> >=20
> > [...]
> >=20
> >> +/**
> >> + * pin_user_pages_remote() - pin pages for (typically) use by Direct =
IO, and
> >> + * return the pages to the user.
> >=20
> > Not a fan of (typically) maybe:
> > pin_user_pages_remote() - pin pages of a remote process (task !=3D curr=
ent)
> >=20
> > I think here the remote part if more important that DIO. Remote is use =
by
> > other thing that DIO.
>=20
> Yes, good point. I'll use your wording:
>=20
>  * pin_user_pages_remote() - pin pages of a remote process (task !=3D cur=
rent)
>=20
>=20
>=20
> >=20
> >> + *
> >> + * Nearly the same as get_user_pages_remote(), except that FOLL_PIN i=
s set. See
> >> + * get_user_pages_remote() for documentation on the function argument=
s, because
> >> + * the arguments here are identical.
> >> + *
> >> + * FOLL_PIN means that the pages must be released via put_user_page()=
. Please
> >> + * see Documentation/vm/pin_user_pages.rst for details.
> >> + *
> >> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pag=
es.rst. It
> >> + * is NOT intended for Case 2 (RDMA: long-term pins).
> >> + */
> >> +long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct =
*mm,
> >> +=09=09=09   unsigned long start, unsigned long nr_pages,
> >> +=09=09=09   unsigned int gup_flags, struct page **pages,
> >> +=09=09=09   struct vm_area_struct **vmas, int *locked)
> >> +{
> >> +=09/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> >> +=09if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> >> +=09=09return -EINVAL;
> >> +
> >> +=09gup_flags |=3D FOLL_TOUCH | FOLL_REMOTE | FOLL_PIN;
> >> +
> >> +=09return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vm=
as,
> >> +=09=09=09=09       locked, gup_flags);
> >> +}
> >> +EXPORT_SYMBOL(pin_user_pages_remote);
> >> +
> >> +/**
> >> + * pin_longterm_pages_remote() - pin pages for (typically) use by Dir=
ect IO, and
> >> + * return the pages to the user.
> >=20
> > I think you copy pasted this from pin_user_pages_remote() :)
>=20
> I admit to nothing, with respect to copy-paste! :)
>=20
> This one can simply be:
>=20
>  * pin_longterm_pages_remote() - pin pages of a remote process (task !=3D=
 current)
>=20
>=20
> >=20
> >> + *
> >> + * Nearly the same as get_user_pages_remote(), but note that FOLL_TOU=
CH is not
> >> + * set, and FOLL_PIN and FOLL_LONGTERM are set. See get_user_pages_re=
mote() for
> >> + * documentation on the function arguments, because the arguments her=
e are
> >> + * identical.
> >> + *
> >> + * FOLL_PIN means that the pages must be released via put_user_page()=
. Please
> >> + * see Documentation/vm/pin_user_pages.rst for further details.
> >> + *
> >> + * FOLL_LONGTERM means that the pages are being pinned for "long term=
" use,
> >> + * typically by a non-CPU device, and we cannot be sure that waiting =
for a
> >> + * pinned page to become unpin will be effective.
> >> + *
> >> + * This is intended for Case 2 (RDMA: long-term pins) in
> >> + * Documentation/vm/pin_user_pages.rst.
> >> + */
> >> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_str=
uct *mm,
> >> +=09=09=09       unsigned long start, unsigned long nr_pages,
> >> +=09=09=09       unsigned int gup_flags, struct page **pages,
> >> +=09=09=09       struct vm_area_struct **vmas, int *locked)
> >> +{
> >> +=09/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> >> +=09if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> >> +=09=09return -EINVAL;
> >> +
> >> +=09/*
> >> +=09 * FIXME: as noted in the get_user_pages_remote() implementation, =
it
> >> +=09 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONG=
TERM
> >> +=09 * needs to be set, but for now the best we can do is a "TODO" ite=
m.
> >> +=09 */
> >> +=09gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
> >=20
> > Wouldn't it be better to not add pin_longterm_pages_remote() until
> > it can be properly implemented ?
> >=20
>=20
> Well, the problem is that I need each call site that requires FOLL_PIN
> to use a proper wrapper. It's the FOLL_PIN that is the focus here, becaus=
e
> there is a hard, bright rule, which is: if and only if a caller sets
> FOLL_PIN, then the dma-page tracking happens, and put_user_page() must
> be called.
>=20
> So this leaves me with only two reasonable choices:
>=20
> a) Convert the call site as above: pin_longterm_pages_remote(), which set=
s
> FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation exactly
> as it has been so far. When the FOLL_LONGTERM situation is fixed, the cal=
l
> site *might* not need any changes to adopt the working gup.c code.
>=20
> b) Convert the call site to pin_user_pages_remote(), which also sets
> FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as before.
> There would also be a comment at the call site, to the effect of, "this
> is the wrong call to make: it really requires FOLL_LONGTERM behavior".
>=20
> When the FOLL_LONGTERM situation is fixed, the call site will need to be
> changed to pin_longterm_pages_remote().
>=20
> So you can probably see why I picked (a).

But right now nobody has FOLL_LONGTERM and FOLL_REMOTE. So you should
never have the need for pin_longterm_pages_remote(). My fear is that
longterm has implication and it would be better to not drop this implicatio=
n
by adding a wrapper that does not do what the name says.

So do not introduce pin_longterm_pages_remote() until its first user
happens. This is option c)

Cheers,
J=E9r=F4me

