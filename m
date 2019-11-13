Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5CFBC2C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKMXDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:03:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55996 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfKMXDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 18:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573686229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XjW0CpMRM7lIuk5UP56xIe9TjleU12DYiFXbT2LVzkE=;
        b=Tn/huwhfSqiBPFiOvUIYoWMNx3+3r86V3ddRNJCNVe/5xAAgukAmsmM7wqfxSGncthCTio
        oAG7YJmAft/E2rTfcVqaSuZ1eFa+16UHqim9u3uUzQA8Mv9As+Y6d/mWTteGl6ADRPWVdy
        ZBMIOKtvFO6o9u2dYjmJjHI+TQ/aaPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-rGYPkL_YNcCM_ji45nIZag-1; Wed, 13 Nov 2019 18:03:45 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 411F11852E21;
        Wed, 13 Nov 2019 23:03:41 +0000 (UTC)
Received: from redhat.com (ovpn-121-71.rdu2.redhat.com [10.10.121.71])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8980691AE;
        Wed, 13 Nov 2019 23:03:33 +0000 (UTC)
Date:   Wed, 13 Nov 2019 18:03:31 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
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
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 04/23] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
Message-ID: <20191113230331.GB6171@redhat.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-5-jhubbard@nvidia.com>
 <CAPcyv4gGu=G-c1czSAYJ3joTYS_ZYOJ6i9umKzCQEFzpwZMiiA@mail.gmail.com>
 <CAPcyv4hr64b-k4j7ZY796+k-+Dy11REMcvPJ+QjTsyJ3vSdfKg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hr64b-k4j7ZY796+k-+Dy11REMcvPJ+QjTsyJ3vSdfKg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: rGYPkL_YNcCM_ji45nIZag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 02:00:06PM -0800, Dan Williams wrote:
> On Wed, Nov 13, 2019 at 11:23 AM Dan Williams <dan.j.williams@intel.com> =
wrote:
> >
> > On Tue, Nov 12, 2019 at 8:27 PM John Hubbard <jhubbard@nvidia.com> wrot=
e:
> > >
> > > An upcoming patch changes and complicates the refcounting and
> > > especially the "put page" aspects of it. In order to keep
> > > everything clean, refactor the devmap page release routines:
> > >
> > > * Rename put_devmap_managed_page() to page_is_devmap_managed(),
> > >   and limit the functionality to "read only": return a bool,
> > >   with no side effects.
> > >
> > > * Add a new routine, put_devmap_managed_page(), to handle checking
> > >   what kind of page it is, and what kind of refcount handling it
> > >   requires.
> > >
> > > * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
> > >   and limit the functionality to unconditionally freeing a devmap
> > >   page.
> > >
> > > This is originally based on a separate patch by Ira Weiny, which
> > > applied to an early version of the put_user_page() experiments.
> > > Since then, J=E9r=F4me Glisse suggested the refactoring described abo=
ve.
> > >
> > > Suggested-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> > > ---
> > >  include/linux/mm.h | 27 ++++++++++++++++---
> > >  mm/memremap.c      | 67 ++++++++++++++++++++------------------------=
--
> > >  2 files changed, 53 insertions(+), 41 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index a2adf95b3f9c..96228376139c 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -967,9 +967,10 @@ static inline bool is_zone_device_page(const str=
uct page *page)
> > >  #endif
> > >
> > >  #ifdef CONFIG_DEV_PAGEMAP_OPS
> > > -void __put_devmap_managed_page(struct page *page);
> > > +void free_devmap_managed_page(struct page *page);
> > >  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> > > -static inline bool put_devmap_managed_page(struct page *page)
> > > +
> > > +static inline bool page_is_devmap_managed(struct page *page)
> > >  {
> > >         if (!static_branch_unlikely(&devmap_managed_key))
> > >                 return false;
> > > @@ -978,7 +979,6 @@ static inline bool put_devmap_managed_page(struct=
 page *page)
> > >         switch (page->pgmap->type) {
> > >         case MEMORY_DEVICE_PRIVATE:
> > >         case MEMORY_DEVICE_FS_DAX:
> > > -               __put_devmap_managed_page(page);
> > >                 return true;
> > >         default:
> > >                 break;
> > > @@ -986,6 +986,27 @@ static inline bool put_devmap_managed_page(struc=
t page *page)
> > >         return false;
> > >  }
> > >
> > > +static inline bool put_devmap_managed_page(struct page *page)
> > > +{
> > > +       bool is_devmap =3D page_is_devmap_managed(page);
> > > +
> > > +       if (is_devmap) {
> > > +               int count =3D page_ref_dec_return(page);
> > > +
> > > +               /*
> > > +                * devmap page refcounts are 1-based, rather than 0-b=
ased: if
> > > +                * refcount is 1, then the page is free and the refco=
unt is
> > > +                * stable because nobody holds a reference on the pag=
e.
> > > +                */
> > > +               if (count =3D=3D 1)
> > > +                       free_devmap_managed_page(page);
> > > +               else if (!count)
> > > +                       __put_page(page);
> > > +       }
> > > +
> > > +       return is_devmap;
> > > +}
> > > +
> > >  #else /* CONFIG_DEV_PAGEMAP_OPS */
> > >  static inline bool put_devmap_managed_page(struct page *page)
> > >  {
> > > diff --git a/mm/memremap.c b/mm/memremap.c
> > > index 03ccbdfeb697..bc7e2a27d025 100644
> > > --- a/mm/memremap.c
> > > +++ b/mm/memremap.c
> > > @@ -410,48 +410,39 @@ struct dev_pagemap *get_dev_pagemap(unsigned lo=
ng pfn,
> > >  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> > >
> > >  #ifdef CONFIG_DEV_PAGEMAP_OPS
> > > -void __put_devmap_managed_page(struct page *page)
> > > +void free_devmap_managed_page(struct page *page)
> > >  {
> > > -       int count =3D page_ref_dec_return(page);
> > > +       /* Clear Active bit in case of parallel mark_page_accessed */
> > > +       __ClearPageActive(page);
> > > +       __ClearPageWaiters(page);
> > > +
> > > +       mem_cgroup_uncharge(page);
> >
> > Ugh, when did all this HMM specific manipulation sneak into the
> > generic ZONE_DEVICE path? It used to be gated by pgmap type with its
> > own put_zone_device_private_page(). For example it's certainly
> > unnecessary and might be broken (would need to check) to call
> > mem_cgroup_uncharge() on a DAX page. ZONE_DEVICE users are not a
> > monolith and the HMM use case leaks pages into code paths that DAX
> > explicitly avoids.
>=20
> It's been this way for a while and I did not react previously,
> apologies for that. I think __ClearPageActive, __ClearPageWaiters, and
> mem_cgroup_uncharge, belong behind a device-private conditional. The
> history here is:
>=20
> Move some, but not all HMM specifics to hmm_devmem_free():
>     2fa147bdbf67 mm, dev_pagemap: Do not clear ->mapping on final put
>=20
> Remove the clearing of mapping since no upstream consumers needed it:
>     b7a523109fb5 mm: don't clear ->mapping in hmm_devmem_free
>=20
> Add it back in once an upstream consumer arrived:
>     7ab0ad0e74f8 mm/hmm: fix ZONE_DEVICE anon page mapping reuse
>=20
> We're now almost entirely free of ->page_free callbacks except for
> that weird nouveau case, can that FIXME in nouveau_dmem_page_free()
> also result in killing the ->page_free() callback altogether? In the
> meantime I'm proposing a cleanup like this:

No we need the callback, cleanup looks good.

>=20
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ad8e4df1282b..4eae441f86c9 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -337,13 +337,7 @@ static void pmem_release_disk(void *__pmem)
>         put_disk(pmem->disk);
>  }
>=20
> -static void pmem_pagemap_page_free(struct page *page)
> -{
> -       wake_up_var(&page->_refcount);
> -}
> -
>  static const struct dev_pagemap_ops fsdax_pagemap_ops =3D {
> -       .page_free              =3D pmem_pagemap_page_free,
>         .kill                   =3D pmem_pagemap_kill,
>         .cleanup                =3D pmem_pagemap_cleanup,
>  };
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 03ccbdfeb697..157edb8f7cf8 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -419,12 +419,6 @@ void __put_devmap_managed_page(struct page *page)
>          * holds a reference on the page.
>          */
>         if (count =3D=3D 1) {
> -               /* Clear Active bit in case of parallel mark_page_accesse=
d */
> -               __ClearPageActive(page);
> -               __ClearPageWaiters(page);
> -
> -               mem_cgroup_uncharge(page);
> -
>                 /*
>                  * When a device_private page is freed, the page->mapping=
 field
>                  * may still contain a (stale) mapping value. For example=
, the
> @@ -446,10 +440,17 @@ void __put_devmap_managed_page(struct page *page)
>                  * handled differently or not done at all, so there is no=
 need
>                  * to clear page->mapping.
>                  */
> -               if (is_device_private_page(page))
> -                       page->mapping =3D NULL;
> +               if (is_device_private_page(page)) {
> +                       /* Clear Active bit in case of parallel
> mark_page_accessed */
> +                       __ClearPageActive(page);
> +                       __ClearPageWaiters(page);
>=20
> -               page->pgmap->ops->page_free(page);
> +                       mem_cgroup_uncharge(page);
> +
> +                       page->mapping =3D NULL;
> +                       page->pgmap->ops->page_free(page);
> +               } else
> +                       wake_up_var(&page->_refcount);
>         } else if (!count)
>                 __put_page(page);
>  }
>=20

