Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6194EE608
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfKDRdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:33:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50720 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729322AbfKDRdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572888822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yb3yyO2PYYBql1Fagu7xeohR5a32M0AhAOb3BjMNyXY=;
        b=GQpRsC5biVZrcUCmm8/d04vdDBWTuHXVl8fb8jnmz/BzWrplmXBDOnR98lt+lHYe5O/hHE
        9oWG3Fr/fLPXSyC3dqzkScENA9u159VHaMg1ma8eS+XpmYO3EEfQKxKr2ZNHoMSNcYUrNr
        J/0gg23fD/hQuRHU0rEkm6E4WJ5AkjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-BOKr1PBBNByJ6qT6wX4yEA-1; Mon, 04 Nov 2019 12:33:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 847CA8017DD;
        Mon,  4 Nov 2019 17:33:33 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89C995C557;
        Mon,  4 Nov 2019 17:33:27 +0000 (UTC)
Date:   Mon, 4 Nov 2019 12:33:25 -0500
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
Message-ID: <20191104173325.GD5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-6-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: BOKr1PBBNByJ6qT6wX4yEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 01:18:00PM -0800, John Hubbard wrote:
> Introduce pin_user_pages*() variations of get_user_pages*() calls,
> and also pin_longterm_pages*() variations.
>=20
> These variants all set FOLL_PIN, which is also introduced, and
> thoroughly documented.
>=20
> The pin_longterm*() variants also set FOLL_LONGTERM, in addition
> to FOLL_PIN:
>=20
>     pin_user_pages()
>     pin_user_pages_remote()
>     pin_user_pages_fast()
>=20
>     pin_longterm_pages()
>     pin_longterm_pages_remote()
>     pin_longterm_pages_fast()
>=20
> All pages that are pinned via the above calls, must be unpinned via
> put_user_page().
>=20
> The underlying rules are:
>=20
> * These are gup-internal flags, so the call sites should not directly
> set FOLL_PIN nor FOLL_LONGTERM. That behavior is enforced with
> assertions, for the new FOLL_PIN flag. However, for the pre-existing
> FOLL_LONGTERM flag, which has some call sites that still directly
> set FOLL_LONGTERM, there is no assertion yet.
>=20
> * Call sites that want to indicate that they are going to do DirectIO
>   ("DIO") or something with similar characteristics, should call a
>   get_user_pages()-like wrapper call that sets FOLL_PIN. These wrappers
>   will:
>         * Start with "pin_user_pages" instead of "get_user_pages". That
>           makes it easy to find and audit the call sites.
>         * Set FOLL_PIN
>=20
> * For pages that are received via FOLL_PIN, those pages must be returned
>   via put_user_page().
>=20
> Thanks to Jan Kara and Vlastimil Babka for explaining the 4 cases
> in this documentation. (I've reworded it and expanded on it slightly.)
>=20
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Few nitpick belows, nonetheless:

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>

> ---
>  Documentation/vm/index.rst          |   1 +
>  Documentation/vm/pin_user_pages.rst | 212 ++++++++++++++++++++++
>  include/linux/mm.h                  |  62 ++++++-
>  mm/gup.c                            | 265 +++++++++++++++++++++++++---
>  4 files changed, 514 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/vm/pin_user_pages.rst
>=20

[...]

> diff --git a/Documentation/vm/pin_user_pages.rst b/Documentation/vm/pin_u=
ser_pages.rst
> new file mode 100644
> index 000000000000..3910f49ca98c
> --- /dev/null
> +++ b/Documentation/vm/pin_user_pages.rst

[...]

> +
> +FOLL_PIN, FOLL_GET, FOLL_LONGTERM: when to use which flags
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Thanks to Jan Kara, Vlastimil Babka and several other -mm people, for de=
scribing
> +these categories:
> +
> +CASE 1: Direct IO (DIO)
> +-----------------------
> +There are GUP references to pages that are serving
> +as DIO buffers. These buffers are needed for a relatively short time (so=
 they
> +are not "long term"). No special synchronization with page_mkclean() or
> +munmap() is provided. Therefore, flags to set at the call site are: ::
> +
> +    FOLL_PIN
> +
> +...but rather than setting FOLL_PIN directly, call sites should use one =
of
> +the pin_user_pages*() routines that set FOLL_PIN.
> +
> +CASE 2: RDMA
> +------------
> +There are GUP references to pages that are serving as DMA
> +buffers. These buffers are needed for a long time ("long term"). No spec=
ial
> +synchronization with page_mkclean() or munmap() is provided. Therefore, =
flags
> +to set at the call site are: ::
> +
> +    FOLL_PIN | FOLL_LONGTERM
> +
> +NOTE: Some pages, such as DAX pages, cannot be pinned with longterm pins=
. That's
> +because DAX pages do not have a separate page cache, and so "pinning" im=
plies
> +locking down file system blocks, which is not (yet) supported in that wa=
y.
> +
> +CASE 3: ODP
> +-----------
> +(Mellanox/Infiniband On Demand Paging: the hardware supports
> +replayable page faulting). There are GUP references to pages serving as =
DMA
> +buffers. For ODP, MMU notifiers are used to synchronize with page_mkclea=
n()
> +and munmap(). Therefore, normal GUP calls are sufficient, so neither fla=
g
> +needs to be set.

I would not include ODP or anything like it here, they do not use
GUP anymore and i believe it is more confusing here. I would how-
ever include some text in this documentation explaining that hard-
ware that support page fault is superior as it does not incur any
of the issues described here.

> +
> +CASE 4: Pinning for struct page manipulation only
> +-------------------------------------------------
> +Here, normal GUP calls are sufficient, so neither flag needs to be set.
> +

[...]

> diff --git a/mm/gup.c b/mm/gup.c
> index 199da99e8ffc..1aea48427879 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c

[...]

> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_locke=
d(struct task_struct *tsk,
>  =09=09BUG_ON(*locked !=3D 1);
>  =09}
> =20
> -=09if (pages)
> +=09/*
> +=09 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
> +=09 * is to set FOLL_GET if the caller wants pages[] filled in (but has
> +=09 * carelessly failed to specify FOLL_GET), so keep doing that, but on=
ly
> +=09 * for FOLL_GET, not for the newer FOLL_PIN.
> +=09 *
> +=09 * FOLL_PIN always expects pages to be non-null, but no need to asser=
t
> +=09 * that here, as any failures will be obvious enough.
> +=09 */
> +=09if (pages && !(flags & FOLL_PIN))
>  =09=09flags |=3D FOLL_GET;

Did you look at user that have pages and not FOLL_GET set ?
I believe it would be better to first fix them to end up
with FOLL_GET set and then error out if pages is !=3D NULL but
nor FOLL_GET or FOLL_PIN is set.

> =20
>  =09pages_done =3D 0;

> @@ -2373,24 +2402,9 @@ static int __gup_longterm_unlocked(unsigned long s=
tart, int nr_pages,
>  =09return ret;
>  }
> =20
> -/**
> - * get_user_pages_fast() - pin user pages in memory
> - * @start:=09starting user address
> - * @nr_pages:=09number of pages from start to pin
> - * @gup_flags:=09flags modifying pin behaviour
> - * @pages:=09array that receives pointers to the pages pinned.
> - *=09=09Should be at least nr_pages long.
> - *
> - * Attempt to pin user pages in memory without taking mm->mmap_sem.
> - * If not successful, it will fall back to taking the lock and
> - * calling get_user_pages().
> - *
> - * Returns number of pages pinned. This may be fewer than the number
> - * requested. If nr_pages is 0 or negative, returns 0. If no pages
> - * were pinned, returns -errno.
> - */
> -int get_user_pages_fast(unsigned long start, int nr_pages,
> -=09=09=09unsigned int gup_flags, struct page **pages)
> +static int internal_get_user_pages_fast(unsigned long start, int nr_page=
s,
> +=09=09=09=09=09unsigned int gup_flags,
> +=09=09=09=09=09struct page **pages)

Usualy function are rename to _old_func_name ie add _ in front. So
here it would become _get_user_pages_fast but i know some people
don't like that as sometimes we endup with ___function_overloaded :)

>  {
>  =09unsigned long addr, len, end;
>  =09int nr =3D 0, ret =3D 0;


> @@ -2435,4 +2449,215 @@ int get_user_pages_fast(unsigned long start, int =
nr_pages,

[...]

> +/**
> + * pin_user_pages_remote() - pin pages for (typically) use by Direct IO,=
 and
> + * return the pages to the user.

Not a fan of (typically) maybe:
pin_user_pages_remote() - pin pages of a remote process (task !=3D current)

I think here the remote part if more important that DIO. Remote is use by
other thing that DIO.

> + *
> + * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is s=
et. See
> + * get_user_pages_remote() for documentation on the function arguments, =
because
> + * the arguments here are identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). P=
lease
> + * see Documentation/vm/pin_user_pages.rst for details.
> + *
> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.=
rst. It
> + * is NOT intended for Case 2 (RDMA: long-term pins).
> + */
> +long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm=
,
> +=09=09=09   unsigned long start, unsigned long nr_pages,
> +=09=09=09   unsigned int gup_flags, struct page **pages,
> +=09=09=09   struct vm_area_struct **vmas, int *locked)
> +{
> +=09/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +=09if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +=09=09return -EINVAL;
> +
> +=09gup_flags |=3D FOLL_TOUCH | FOLL_REMOTE | FOLL_PIN;
> +
> +=09return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
> +=09=09=09=09       locked, gup_flags);
> +}
> +EXPORT_SYMBOL(pin_user_pages_remote);
> +
> +/**
> + * pin_longterm_pages_remote() - pin pages for (typically) use by Direct=
 IO, and
> + * return the pages to the user.

I think you copy pasted this from pin_user_pages_remote() :)

> + *
> + * Nearly the same as get_user_pages_remote(), but note that FOLL_TOUCH =
is not
> + * set, and FOLL_PIN and FOLL_LONGTERM are set. See get_user_pages_remot=
e() for
> + * documentation on the function arguments, because the arguments here a=
re
> + * identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). P=
lease
> + * see Documentation/vm/pin_user_pages.rst for further details.
> + *
> + * FOLL_LONGTERM means that the pages are being pinned for "long term" u=
se,
> + * typically by a non-CPU device, and we cannot be sure that waiting for=
 a
> + * pinned page to become unpin will be effective.
> + *
> + * This is intended for Case 2 (RDMA: long-term pins) in
> + * Documentation/vm/pin_user_pages.rst.
> + */
> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct=
 *mm,
> +=09=09=09       unsigned long start, unsigned long nr_pages,
> +=09=09=09       unsigned int gup_flags, struct page **pages,
> +=09=09=09       struct vm_area_struct **vmas, int *locked)
> +{
> +=09/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +=09if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +=09=09return -EINVAL;
> +
> +=09/*
> +=09 * FIXME: as noted in the get_user_pages_remote() implementation, it
> +=09 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONGTER=
M
> +=09 * needs to be set, but for now the best we can do is a "TODO" item.
> +=09 */
> +=09gup_flags |=3D FOLL_REMOTE | FOLL_PIN;

Wouldn't it be better to not add pin_longterm_pages_remote() until
it can be properly implemented ?

