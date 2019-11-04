Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7658FEF16A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfKDXtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:49:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729921AbfKDXtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 18:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572911378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ls7Zx2AkPrMXy+LPLj5cuy1SX8JbSG4GMzPShaYe1yw=;
        b=IfL7MkPxB5zySA4vbb0QuMZy55v/zvaTiCX93aqMVcli8IDb/YZcsYaBLOCP7wWMujkRzf
        8sA/scHwe1+PbSRCdhJLnQpOQhPaZdnG7HBDxjBnicb7qaM1vlIZX+/P5gpceiGKOi/E2x
        4s8SrZfgAaTUPA5+CIq0y+fn/ckofvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-aDWO2QFVNLO1s54amWQi-Q-1; Mon, 04 Nov 2019 18:49:35 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0E0D107ACC2;
        Mon,  4 Nov 2019 23:49:30 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D177919C4F;
        Mon,  4 Nov 2019 23:49:21 +0000 (UTC)
Date:   Mon, 4 Nov 2019 18:49:20 -0500
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
Subject: Re: [PATCH v2 12/18] mm/gup: track FOLL_PIN pages
Message-ID: <20191104234920.GA18515@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-13-jhubbard@nvidia.com>
 <20191104185238.GG5134@redhat.com>
 <7821cf87-75a8-45e2-cf28-f85b62192416@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <7821cf87-75a8-45e2-cf28-f85b62192416@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: aDWO2QFVNLO1s54amWQi-Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 02:49:18PM -0800, John Hubbard wrote:
> On 11/4/19 10:52 AM, Jerome Glisse wrote:
> > On Sun, Nov 03, 2019 at 01:18:07PM -0800, John Hubbard wrote:
> >> Add tracking of pages that were pinned via FOLL_PIN.
> >>
> >> As mentioned in the FOLL_PIN documentation, callers who effectively se=
t
> >> FOLL_PIN are required to ultimately free such pages via put_user_page(=
).
> >> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
> >> for DIO and/or RDMA use".
> >>
> >> Pages that have been pinned via FOLL_PIN are identifiable via a
> >> new function call:
> >>
> >>    bool page_dma_pinned(struct page *page);
> >>
> >> What to do in response to encountering such a page, is left to later
> >> patchsets. There is discussion about this in [1].
> >>
> >> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
> >>
> >> This also has a couple of trivial, non-functional change fixes to
> >> try_get_compound_head(). That function got moved to the top of the
> >> file.
> >=20
> > Maybe split that as a separate trivial patch.
>=20
>=20
> Will do.
>=20
>=20
> >=20
> >>
> >> This includes the following fix from Ira Weiny:
> >>
> >> DAX requires detection of a page crossing to a ref count of 1.  Fix th=
is
> >> for GUP pages by introducing put_devmap_managed_user_page() which
> >> accounts for GUP_PIN_COUNTING_BIAS now used by GUP.
> >=20
> > Please do the put_devmap_managed_page() changes in a separate
> > patch, it would be a lot easier to follow, also on that front
> > see comments below.
>=20
>=20
> Oh! OK. It makes sense when you say it out loud. :)
>=20
>=20
> ...
> >> +static inline bool put_devmap_managed_page(struct page *page)
> >> +{
> >> +=09bool is_devmap =3D page_is_devmap_managed(page);
> >> +
> >> +=09if (is_devmap) {
> >> +=09=09int count =3D page_ref_dec_return(page);
> >> +
> >> +=09=09__put_devmap_managed_page(page, count);
> >> +=09}
> >> +
> >> +=09return is_devmap;
> >> +}
> >=20
> > I think the __put_devmap_managed_page() should be rename
> > to free_devmap_managed_page() and that the count !=3D 1
> > case move to this inline function ie:
> >=20
> > static inline bool put_devmap_managed_page(struct page *page)
> > {
> > =09bool is_devmap =3D page_is_devmap_managed(page);
> >=20
> > =09if (is_devmap) {
> > =09=09int count =3D page_ref_dec_return(page);
> >=20
> > =09=09/*
> > =09=09 * If refcount is 1 then page is freed and refcount is stable as =
nobody
> > =09=09 * holds a reference on the page.
> > =09=09 */
> > =09=09if (count =3D=3D 1)
> > =09=09=09free_devmap_managed_page(page, count);
> > =09=09else if (!count)
> > =09=09=09__put_page(page);
> > =09}
> >=20
> > =09return is_devmap;
> > }
> >=20
>=20
> Thanks, that does look cleaner and easier to read.
>=20
> >=20
> >> +
> >>  #else /* CONFIG_DEV_PAGEMAP_OPS */
> >>  static inline bool put_devmap_managed_page(struct page *page)
> >>  {
> >> @@ -1038,6 +1051,8 @@ static inline __must_check bool try_get_page(str=
uct page *page)
> >>  =09return true;
> >>  }
> >> =20
> >> +__must_check bool user_page_ref_inc(struct page *page);
> >> +
> >=20
> > What about having it as an inline here as it is pretty small.
>=20
>=20
> You mean move it to a static inline function in mm.h? It's worse than it=
=20
> looks, though: *everything* that it calls is also a static function, loca=
l
> to gup.c. So I'd have to expose both try_get_compound_head() and
> __update_proc_vmstat(). And that also means calling mod_node_page_state()=
 from
> mm.h, and it goes south right about there. :)

Ok fair enough

> ... =20
> >> +/**
> >> + * page_dma_pinned() - report if a page is pinned by a call to pin_us=
er_pages*()
> >> + * or pin_longterm_pages*()
> >> + * @page:=09pointer to page to be queried.
> >> + * @Return:=09True, if it is likely that the page has been "dma-pinne=
d".
> >> + *=09=09False, if the page is definitely not dma-pinned.
> >> + */
> >=20
> > Maybe add a small comment about wrap around :)
>=20
>=20
> I don't *think* the count can wrap around, due to the checks in user_page=
_ref_inc().
>=20
> But it's true that the documentation is a little light here...What did yo=
u have=20
> in mind?

About false positive case (and how unlikely they are) and that wrap
around is properly handle. Maybe just a pointer to the documentation
so that people know they can go look there for details. I know my
brain tend to forget where to look for things so i like to be constantly
reminded hey the doc is Documentations/foobar :)

> > [...]
> >=20
> >> @@ -1930,12 +2028,20 @@ static int __gup_device_huge(unsigned long pfn=
, unsigned long addr,
> >> =20
> >>  =09=09pgmap =3D get_dev_pagemap(pfn, pgmap);
> >>  =09=09if (unlikely(!pgmap)) {
> >> -=09=09=09undo_dev_pagemap(nr, nr_start, pages);
> >> +=09=09=09undo_dev_pagemap(nr, nr_start, flags, pages);
> >>  =09=09=09return 0;
> >>  =09=09}
> >>  =09=09SetPageReferenced(page);
> >>  =09=09pages[*nr] =3D page;
> >> -=09=09get_page(page);
> >> +
> >> +=09=09if (flags & FOLL_PIN) {
> >> +=09=09=09if (unlikely(!user_page_ref_inc(page))) {
> >> +=09=09=09=09undo_dev_pagemap(nr, nr_start, flags, pages);
> >> +=09=09=09=09return 0;
> >> +=09=09=09}
> >=20
> > Maybe add a comment about a case that should never happens ie
> > user_page_ref_inc() fails after the second iteration of the
> > loop as it would be broken and a bug to call undo_dev_pagemap()
> > after the first iteration of that loop.
> >=20
> > Also i believe that this should never happens as if first
> > iteration succeed than __page_cache_add_speculative() will
> > succeed for all the iterations.
> >=20
> > Note that the pgmap case above follows that too ie the call to
> > get_dev_pagemap() can only fail on first iteration of the loop,
> > well i assume you can never have a huge device page that span
> > different pgmap ie different devices (which is a reasonable
> > assumption). So maybe this code needs fixing ie :
> >=20
> > =09=09pgmap =3D get_dev_pagemap(pfn, pgmap);
> > =09=09if (unlikely(!pgmap))
> > =09=09=09return 0;
> >=20
> >=20
>=20
> OK, yes that does make sense. And I think a comment is adequate,
> no need to check for bugs during every tail page iteration. So how=20
> about this, as a preliminary patch:

Actualy i thought about it and i think that there is pgmap
per section and thus maybe one device can have multiple pgmap
and that would be an issue for page bigger than section size
(ie bigger than 128MB iirc). I will go double check that, but
maybe Dan can chime in.

In any case my comment above is correct for the page ref
increment, if the first one succeed than others will too
or otherwise it means someone is doing too many put_page()/
put_user_page() which is _bad_ :)

>=20
> diff --git a/mm/gup.c b/mm/gup.c
> index 8f236a335ae9..a4a81e125832 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1892,17 +1892,18 @@ static int gup_pte_range(pmd_t pmd, unsigned long=
 addr, unsigned long end,
>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>                 unsigned long end, struct page **pages, int *nr)
>  {
> -       int nr_start =3D *nr;
> -       struct dev_pagemap *pgmap =3D NULL;
> +       /*
> +        * Huge pages should never cross dev_pagemap boundaries. Therefor=
e, use
> +        * this same pgmap for the entire huge page.
> +        */
> +       struct dev_pagemap *pgmap =3D get_dev_pagemap(pfn, NULL);
> +
> +       if (unlikely(!pgmap))
> +               return 0;
> =20
>         do {
>                 struct page *page =3D pfn_to_page(pfn);
> =20
> -               pgmap =3D get_dev_pagemap(pfn, pgmap);
> -               if (unlikely(!pgmap)) {
> -                       undo_dev_pagemap(nr, nr_start, pages);
> -                       return 0;
> -               }
>                 SetPageReferenced(page);
>                 pages[*nr] =3D page;
>                 get_page(page);
>=20
>=20
>=20
>=20
> >> +=09=09} else
> >> +=09=09=09get_page(page);
> >> +
> >>  =09=09(*nr)++;
> >>  =09=09pfn++;
> >>  =09} while (addr +=3D PAGE_SIZE, addr !=3D end);
> >=20
> > [...]
> >=20
> >> @@ -2409,7 +2540,7 @@ static int internal_get_user_pages_fast(unsigned=
 long start, int nr_pages,
> >>  =09unsigned long addr, len, end;
> >>  =09int nr =3D 0, ret =3D 0;
> >> =20
> >> -=09if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
> >> +=09if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_P=
IN)))
> >=20
> > Maybe add a comments to explain, something like:
> >=20
> > /*
> >  * The only flags allowed here are: FOLL_WRITE, FOLL_LONGTERM, FOLL_PIN
> >  *
> >  * Note that get_user_pages_fast() imply FOLL_GET flag by default but
> >  * callers can over-ride this default to pin case by setting FOLL_PIN.
> >  */
>=20
> Good idea. Here's the draft now:
>=20
> /*
>  * The only flags allowed here are: FOLL_WRITE, FOLL_LONGTERM, FOLL_PIN.
>  *
>  * Note that get_user_pages_fast() implies FOLL_GET flag by default, but
>  * callers can override this default by setting FOLL_PIN instead of
>  * FOLL_GET.
>  */
> if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)))
>         return -EINVAL;

Looks good to me.

...

Cheers,
J=E9r=F4me

