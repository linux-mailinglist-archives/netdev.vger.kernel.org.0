Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA91AEE7B3
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfKDSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:52:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728602AbfKDSw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572893575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhvFv/gKEXA1cmin4yO0xx1/Gf0U1DoUV0cjNAwwQns=;
        b=AwPUH1Gw9pb2VEuimGsZm+pjX1CrtX1/7Ed6HwMaKy/ZPUFZ0zSVYAO0Z54UIpDwl8H69t
        gWhD+1ZLensUPVPHSFxB9TOGSe88J7eC6ZI4L0LyPYTrr9ONpXlB7K7kmlv9RccXfesO2B
        tzG2CoqH/FEbnYvo+xskH7FTRFMnj4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-BYegrK4JPIWXqhL6bCqv8A-1; Mon, 04 Nov 2019 13:52:51 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F2011800D53;
        Mon,  4 Nov 2019 18:52:47 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1977960878;
        Mon,  4 Nov 2019 18:52:40 +0000 (UTC)
Date:   Mon, 4 Nov 2019 13:52:38 -0500
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
Message-ID: <20191104185238.GG5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-13-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-13-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: BYegrK4JPIWXqhL6bCqv8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 01:18:07PM -0800, John Hubbard wrote:
> Add tracking of pages that were pinned via FOLL_PIN.
>=20
> As mentioned in the FOLL_PIN documentation, callers who effectively set
> FOLL_PIN are required to ultimately free such pages via put_user_page().
> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
> for DIO and/or RDMA use".
>=20
> Pages that have been pinned via FOLL_PIN are identifiable via a
> new function call:
>=20
>    bool page_dma_pinned(struct page *page);
>=20
> What to do in response to encountering such a page, is left to later
> patchsets. There is discussion about this in [1].
>=20
> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
>=20
> This also has a couple of trivial, non-functional change fixes to
> try_get_compound_head(). That function got moved to the top of the
> file.

Maybe split that as a separate trivial patch.

>=20
> This includes the following fix from Ira Weiny:
>=20
> DAX requires detection of a page crossing to a ref count of 1.  Fix this
> for GUP pages by introducing put_devmap_managed_user_page() which
> accounts for GUP_PIN_COUNTING_BIAS now used by GUP.

Please do the put_devmap_managed_page() changes in a separate
patch, it would be a lot easier to follow, also on that front
see comments below.

>=20
> [1] https://lwn.net/Articles/784574/ "Some slow progress on
> get_user_pages()"
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  include/linux/mm.h       |  80 +++++++++++----
>  include/linux/mmzone.h   |   2 +
>  include/linux/page_ref.h |  10 ++
>  mm/gup.c                 | 213 +++++++++++++++++++++++++++++++--------
>  mm/huge_memory.c         |  32 +++++-
>  mm/hugetlb.c             |  28 ++++-
>  mm/memremap.c            |   4 +-
>  mm/vmstat.c              |   2 +
>  8 files changed, 300 insertions(+), 71 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cdfb6fedb271..03b3600843b7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -972,9 +972,10 @@ static inline bool is_zone_device_page(const struct =
page *page)
>  #endif
> =20
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page);
> +void __put_devmap_managed_page(struct page *page, int count);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> -static inline bool put_devmap_managed_page(struct page *page)
> +
> +static inline bool page_is_devmap_managed(struct page *page)
>  {
>  =09if (!static_branch_unlikely(&devmap_managed_key))
>  =09=09return false;
> @@ -983,7 +984,6 @@ static inline bool put_devmap_managed_page(struct pag=
e *page)
>  =09switch (page->pgmap->type) {
>  =09case MEMORY_DEVICE_PRIVATE:
>  =09case MEMORY_DEVICE_FS_DAX:
> -=09=09__put_devmap_managed_page(page);
>  =09=09return true;
>  =09default:
>  =09=09break;
> @@ -991,6 +991,19 @@ static inline bool put_devmap_managed_page(struct pa=
ge *page)
>  =09return false;
>  }
> =20
> +static inline bool put_devmap_managed_page(struct page *page)
> +{
> +=09bool is_devmap =3D page_is_devmap_managed(page);
> +
> +=09if (is_devmap) {
> +=09=09int count =3D page_ref_dec_return(page);
> +
> +=09=09__put_devmap_managed_page(page, count);
> +=09}
> +
> +=09return is_devmap;
> +}

I think the __put_devmap_managed_page() should be rename
to free_devmap_managed_page() and that the count !=3D 1
case move to this inline function ie:

static inline bool put_devmap_managed_page(struct page *page)
{
=09bool is_devmap =3D page_is_devmap_managed(page);

=09if (is_devmap) {
=09=09int count =3D page_ref_dec_return(page);

=09=09/*
=09=09 * If refcount is 1 then page is freed and refcount is stable as nobo=
dy
=09=09 * holds a reference on the page.
=09=09 */
=09=09if (count =3D=3D 1)
=09=09=09free_devmap_managed_page(page, count);
=09=09else if (!count)
=09=09=09__put_page(page);
=09}

=09return is_devmap;
}


> +
>  #else /* CONFIG_DEV_PAGEMAP_OPS */
>  static inline bool put_devmap_managed_page(struct page *page)
>  {
> @@ -1038,6 +1051,8 @@ static inline __must_check bool try_get_page(struct=
 page *page)
>  =09return true;
>  }
> =20
> +__must_check bool user_page_ref_inc(struct page *page);
> +

What about having it as an inline here as it is pretty small.


>  static inline void put_page(struct page *page)
>  {
>  =09page =3D compound_head(page);
> @@ -1055,31 +1070,56 @@ static inline void put_page(struct page *page)
>  =09=09__put_page(page);
>  }
> =20
> -/**
> - * put_user_page() - release a gup-pinned page
> - * @page:            pointer to page to be released
> +/*
> + * GUP_PIN_COUNTING_BIAS, and the associated functions that use it, over=
load
> + * the page's refcount so that two separate items are tracked: the origi=
nal page
> + * reference count, and also a new count of how many get_user_pages() ca=
lls were
> + * made against the page. ("gup-pinned" is another term for the latter).
> + *
> + * With this scheme, get_user_pages() becomes special: such pages are ma=
rked
> + * as distinct from normal pages. As such, the new put_user_page() call =
(and
> + * its variants) must be used in order to release gup-pinned pages.
> + *
> + * Choice of value:
>   *
> - * Pages that were pinned via get_user_pages*() must be released via
> - * either put_user_page(), or one of the put_user_pages*() routines
> - * below. This is so that eventually, pages that are pinned via
> - * get_user_pages*() can be separately tracked and uniquely handled. In
> - * particular, interactions with RDMA and filesystems need special
> - * handling.
> + * By making GUP_PIN_COUNTING_BIAS a power of two, debugging of page ref=
erence
> + * counts with respect to get_user_pages() and put_user_page() becomes s=
impler,
> + * due to the fact that adding an even power of two to the page refcount=
 has
> + * the effect of using only the upper N bits, for the code that counts u=
p using
> + * the bias value. This means that the lower bits are left for the exclu=
sive
> + * use of the original code that increments and decrements by one (or at=
 least,
> + * by much smaller values than the bias value).
>   *
> - * put_user_page() and put_page() are not interchangeable, despite this =
early
> - * implementation that makes them look the same. put_user_page() calls m=
ust
> - * be perfectly matched up with get_user_page() calls.
> + * Of course, once the lower bits overflow into the upper bits (and this=
 is
> + * OK, because subtraction recovers the original values), then visual in=
spection
> + * no longer suffices to directly view the separate counts. However, for=
 normal
> + * applications that don't have huge page reference counts, this won't b=
e an
> + * issue.
> + *
> + * Locking: the lockless algorithm described in page_cache_get_speculati=
ve()
> + * and page_cache_gup_pin_speculative() provides safe operation for
> + * get_user_pages and page_mkclean and other calls that race to set up p=
age
> + * table entries.
>   */
> -static inline void put_user_page(struct page *page)
> -{
> -=09put_page(page);
> -}
> +#define GUP_PIN_COUNTING_BIAS (1UL << 10)
> =20
> +void put_user_page(struct page *page);
>  void put_user_pages_dirty_lock(struct page **pages, unsigned long npages=
,
>  =09=09=09       bool make_dirty);
> -
>  void put_user_pages(struct page **pages, unsigned long npages);
> =20
> +/**
> + * page_dma_pinned() - report if a page is pinned by a call to pin_user_=
pages*()
> + * or pin_longterm_pages*()
> + * @page:=09pointer to page to be queried.
> + * @Return:=09True, if it is likely that the page has been "dma-pinned".
> + *=09=09False, if the page is definitely not dma-pinned.
> + */

Maybe add a small comment about wrap around :)

> +static inline bool page_dma_pinned(struct page *page)
> +{
> +=09return (page_ref_count(compound_head(page))) >=3D GUP_PIN_COUNTING_BI=
AS;
> +}
> +
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  #define SECTION_IN_PAGE_FLAGS
>  #endif

[...]

> diff --git a/mm/gup.c b/mm/gup.c
> index 1aea48427879..c9727e65fad3 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c

[...]

> @@ -1930,12 +2028,20 @@ static int __gup_device_huge(unsigned long pfn, u=
nsigned long addr,
> =20
>  =09=09pgmap =3D get_dev_pagemap(pfn, pgmap);
>  =09=09if (unlikely(!pgmap)) {
> -=09=09=09undo_dev_pagemap(nr, nr_start, pages);
> +=09=09=09undo_dev_pagemap(nr, nr_start, flags, pages);
>  =09=09=09return 0;
>  =09=09}
>  =09=09SetPageReferenced(page);
>  =09=09pages[*nr] =3D page;
> -=09=09get_page(page);
> +
> +=09=09if (flags & FOLL_PIN) {
> +=09=09=09if (unlikely(!user_page_ref_inc(page))) {
> +=09=09=09=09undo_dev_pagemap(nr, nr_start, flags, pages);
> +=09=09=09=09return 0;
> +=09=09=09}

Maybe add a comment about a case that should never happens ie
user_page_ref_inc() fails after the second iteration of the
loop as it would be broken and a bug to call undo_dev_pagemap()
after the first iteration of that loop.

Also i believe that this should never happens as if first
iteration succeed than __page_cache_add_speculative() will
succeed for all the iterations.

Note that the pgmap case above follows that too ie the call to
get_dev_pagemap() can only fail on first iteration of the loop,
well i assume you can never have a huge device page that span
different pgmap ie different devices (which is a reasonable
assumption). So maybe this code needs fixing ie :

=09=09pgmap =3D get_dev_pagemap(pfn, pgmap);
=09=09if (unlikely(!pgmap))
=09=09=09return 0;


> +=09=09} else
> +=09=09=09get_page(page);
> +
>  =09=09(*nr)++;
>  =09=09pfn++;
>  =09} while (addr +=3D PAGE_SIZE, addr !=3D end);

[...]

> @@ -2409,7 +2540,7 @@ static int internal_get_user_pages_fast(unsigned lo=
ng start, int nr_pages,
>  =09unsigned long addr, len, end;
>  =09int nr =3D 0, ret =3D 0;
> =20
> -=09if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
> +=09if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)=
))

Maybe add a comments to explain, something like:

/*
 * The only flags allowed here are: FOLL_WRITE, FOLL_LONGTERM, FOLL_PIN
 *
 * Note that get_user_pages_fast() imply FOLL_GET flag by default but
 * callers can over-ride this default to pin case by setting FOLL_PIN.
 */

>  =09=09return -EINVAL;
> =20
>  =09start =3D untagged_addr(start) & PAGE_MASK;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 13cc93785006..66bf4c8b88f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c

[...]

> @@ -968,7 +973,12 @@ struct page *follow_devmap_pmd(struct vm_area_struct=
 *vma, unsigned long addr,
>  =09if (!*pgmap)
>  =09=09return ERR_PTR(-EFAULT);
>  =09page =3D pfn_to_page(pfn);
> -=09get_page(page);
> +
> +=09if (flags & FOLL_GET)
> +=09=09get_page(page);
> +=09else if (flags & FOLL_PIN)
> +=09=09if (unlikely(!user_page_ref_inc(page)))
> +=09=09=09page =3D ERR_PTR(-ENOMEM);

While i agree that user_page_ref_inc() (ie page_cache_add_speculative())
should never fails here as we are holding the pmd lock and thus no one
can unmap the pmd and free the page it points to. I believe you should
return -EFAULT like for the pgmap and not -ENOMEM as the pgmap should
not fail either for the same reason. Thus it would be better to have
consistent error. Maybe also add a comments explaining that it should
not fail here.

> =20
>  =09return page;
>  }

[...]

> @@ -1100,7 +1115,7 @@ struct page *follow_devmap_pud(struct vm_area_struc=
t *vma, unsigned long addr,
>  =09 * device mapped pages can only be returned if the
>  =09 * caller will manage the page reference count.
>  =09 */
> -=09if (!(flags & FOLL_GET))
> +=09if (!(flags & (FOLL_GET | FOLL_PIN)))
>  =09=09return ERR_PTR(-EEXIST);

Maybe add a comment that FOLL_GET or FOLL_PIN must be set.

>  =09pfn +=3D (addr & ~PUD_MASK) >> PAGE_SHIFT;
> @@ -1108,7 +1123,12 @@ struct page *follow_devmap_pud(struct vm_area_stru=
ct *vma, unsigned long addr,
>  =09if (!*pgmap)
>  =09=09return ERR_PTR(-EFAULT);
>  =09page =3D pfn_to_page(pfn);
> -=09get_page(page);
> +
> +=09if (flags & FOLL_GET)
> +=09=09get_page(page);
> +=09else if (flags & FOLL_PIN)
> +=09=09if (unlikely(!user_page_ref_inc(page)))
> +=09=09=09page =3D ERR_PTR(-ENOMEM);

Same as for follow_devmap_pmd() see above.

> =20
>  =09return page;
>  }
> @@ -1522,8 +1542,12 @@ struct page *follow_trans_huge_pmd(struct vm_area_=
struct *vma,
>  skip_mlock:
>  =09page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>  =09VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), pag=
e);
> +
>  =09if (flags & FOLL_GET)
>  =09=09get_page(page);
> +=09else if (flags & FOLL_PIN)
> +=09=09if (unlikely(!user_page_ref_inc(page)))
> +=09=09=09page =3D NULL;

This should not fail either as we are holding the pmd lock maybe add
a comment. Dunno if we want a WARN() or something to catch this
degenerate case, or dump the page.

> =20
>  out:
>  =09return page;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b45a95363a84..da335b1cd798 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4462,7 +4462,17 @@ long follow_hugetlb_page(struct mm_struct *mm, str=
uct vm_area_struct *vma,
>  same_page:
>  =09=09if (pages) {
>  =09=09=09pages[i] =3D mem_map_offset(page, pfn_offset);
> -=09=09=09get_page(pages[i]);
> +
> +=09=09=09if (flags & FOLL_GET)
> +=09=09=09=09get_page(pages[i]);
> +=09=09=09else if (flags & FOLL_PIN)
> +=09=09=09=09if (unlikely(!user_page_ref_inc(pages[i]))) {
> +=09=09=09=09=09spin_unlock(ptl);
> +=09=09=09=09=09remainder =3D 0;
> +=09=09=09=09=09err =3D -ENOMEM;
> +=09=09=09=09=09WARN_ON_ONCE(1);
> +=09=09=09=09=09break;
> +=09=09=09=09}
>  =09=09}

user_page_ref_inc() should not fail here either because we hold the
ptl, so the WAR_ON_ONCE() is right but maybe add a comment.

> =20
>  =09=09if (vmas)

[...]

> @@ -5034,8 +5050,14 @@ follow_huge_pmd(struct mm_struct *mm, unsigned lon=
g address,
>  =09pte =3D huge_ptep_get((pte_t *)pmd);
>  =09if (pte_present(pte)) {
>  =09=09page =3D pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
> +
>  =09=09if (flags & FOLL_GET)
>  =09=09=09get_page(page);
> +=09=09else if (flags & FOLL_PIN)
> +=09=09=09if (unlikely(!user_page_ref_inc(page))) {
> +=09=09=09=09page =3D NULL;
> +=09=09=09=09goto out;
> +=09=09=09}

This should not fail either (again holding pmd lock), dunno if we want
a warn or something to catch this degenerate case.

>  =09} else {
>  =09=09if (is_hugetlb_entry_migration(pte)) {
>  =09=09=09spin_unlock(ptl);

[...]

