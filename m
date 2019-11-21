Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FB5105C0D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKUVfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:35:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKUVfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574372139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YslT4VlrB9mGxRqN5ZKGkdoWX+pImdvI3tx38/mJv/g=;
        b=F3+4lkP3uqyXkGQy92eLDyAWlOZz+Dqr0YZIfkLtyHHYVwohbTEqIdCNRsxde0wfDY7knz
        XBDvHo51Hj2F1EIeKg+VyyiD24pZJ2SWYGKVbsb+MJOoqWwlrQoTt76Qmvo17+pHXH9ajy
        RZwA4C+3Vw5Wc333VaXIQm3zSkrXFs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-_8mqkejRPqeFlprORl3o9g-1; Thu, 21 Nov 2019 16:35:36 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42006801E58;
        Thu, 21 Nov 2019 21:35:30 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C5BA6E703;
        Thu, 21 Nov 2019 21:35:26 +0000 (UTC)
Date:   Thu, 21 Nov 2019 14:35:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
        =?UTF-8?B?SsOpcsO0?= =?UTF-8?B?bWU=?= Glisse 
        <jglisse@redhat.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@mellanox.com>
Subject: Re: [PATCH v7 09/24] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191121143525.50deb72f@x1.home>
In-Reply-To: <20191121071354.456618-10-jhubbard@nvidia.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
        <20191121071354.456618-10-jhubbard@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: _8mqkejRPqeFlprORl3o9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 23:13:39 -0800
John Hubbard <jhubbard@nvidia.com> wrote:

> As it says in the updated comment in gup.c: current FOLL_LONGTERM
> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> FS DAX check requirement on vmas.
>=20
> However, the corresponding restriction in get_user_pages_remote() was
> slightly stricter than is actually required: it forbade all
> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> that do not set the "locked" arg.
>=20
> Update the code and comments accordingly, and update the VFIO caller
> to take advantage of this, fixing a bug as a result: the VFIO caller
> is logically a FOLL_LONGTERM user.
>=20
> Also, remove an unnessary pair of calls that were releasing and
> reacquiring the mmap_sem. There is no need to avoid holding mmap_sem
> just in order to call page_to_pfn().
>=20
> Also, move the DAX check ("if a VMA is DAX, don't allow long term
> pinning") from the VFIO call site, all the way into the internals
> of get_user_pages_remote() and __gup_longterm_locked(). That is:
> get_user_pages_remote() calls __gup_longterm_locked(), which in turn
> calls check_dax_vmas(). It's lightly explained in the comments as well.
>=20
> Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
> and to Dan Williams for helping clarify the DAX refactoring.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++-------------------------
>  mm/gup.c                        | 27 ++++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 30 deletions(-)

Tested with device assignment and Intel mdev vGPU assignment with QEMU
userspace:

Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>

Feel free to include for 19/24 as well.  Thanks,

Alex

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index d864277ea16f..c7a111ad9975 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -340,7 +340,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsign=
ed long vaddr,
>  {
>  =09struct page *page[1];
>  =09struct vm_area_struct *vma;
> -=09struct vm_area_struct *vmas[1];
>  =09unsigned int flags =3D 0;
>  =09int ret;
> =20
> @@ -348,33 +347,14 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsi=
gned long vaddr,
>  =09=09flags |=3D FOLL_WRITE;
> =20
>  =09down_read(&mm->mmap_sem);
> -=09if (mm =3D=3D current->mm) {
> -=09=09ret =3D get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> -=09=09=09=09     vmas);
> -=09} else {
> -=09=09ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> -=09=09=09=09=09    vmas, NULL);
> -=09=09/*
> -=09=09 * The lifetime of a vaddr_get_pfn() page pin is
> -=09=09 * userspace-controlled. In the fs-dax case this could
> -=09=09 * lead to indefinite stalls in filesystem operations.
> -=09=09 * Disallow attempts to pin fs-dax pages via this
> -=09=09 * interface.
> -=09=09 */
> -=09=09if (ret > 0 && vma_is_fsdax(vmas[0])) {
> -=09=09=09ret =3D -EOPNOTSUPP;
> -=09=09=09put_page(page[0]);
> -=09=09}
> -=09}
> -=09up_read(&mm->mmap_sem);
> -
> +=09ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTE=
RM,
> +=09=09=09=09    page, NULL, NULL);
>  =09if (ret =3D=3D 1) {
>  =09=09*pfn =3D page_to_pfn(page[0]);
> -=09=09return 0;
> +=09=09ret =3D 0;
> +=09=09goto done;
>  =09}
> =20
> -=09down_read(&mm->mmap_sem);
> -
>  =09vaddr =3D untagged_addr(vaddr);
> =20
>  =09vma =3D find_vma_intersection(mm, vaddr, vaddr + 1);
> @@ -384,7 +364,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsign=
ed long vaddr,
>  =09=09if (is_invalid_reserved_pfn(*pfn))
>  =09=09=09ret =3D 0;
>  =09}
> -
> +done:
>  =09up_read(&mm->mmap_sem);
>  =09return ret;
>  }
> diff --git a/mm/gup.c b/mm/gup.c
> index 14fcdc502166..cce2c9676853 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -29,6 +29,13 @@ struct follow_page_context {
>  =09unsigned int page_mask;
>  };
> =20
> +static __always_inline long __gup_longterm_locked(struct task_struct *ts=
k,
> +=09=09=09=09=09=09  struct mm_struct *mm,
> +=09=09=09=09=09=09  unsigned long start,
> +=09=09=09=09=09=09  unsigned long nr_pages,
> +=09=09=09=09=09=09  struct page **pages,
> +=09=09=09=09=09=09  struct vm_area_struct **vmas,
> +=09=09=09=09=09=09  unsigned int flags);
>  /*
>   * Return the compound head page with ref appropriately incremented,
>   * or NULL if that failed.
> @@ -1167,13 +1174,23 @@ long get_user_pages_remote(struct task_struct *ts=
k, struct mm_struct *mm,
>  =09=09struct vm_area_struct **vmas, int *locked)
>  {
>  =09/*
> -=09 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
> +=09 * Parts of FOLL_LONGTERM behavior are incompatible with
>  =09 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
> -=09 * vmas.  As there are no users of this flag in this call we simply
> -=09 * disallow this option for now.
> +=09 * vmas. However, this only comes up if locked is set, and there are
> +=09 * callers that do request FOLL_LONGTERM, but do not set locked. So,
> +=09 * allow what we can.
>  =09 */
> -=09if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
> -=09=09return -EINVAL;
> +=09if (gup_flags & FOLL_LONGTERM) {
> +=09=09if (WARN_ON_ONCE(locked))
> +=09=09=09return -EINVAL;
> +=09=09/*
> +=09=09 * This will check the vmas (even if our vmas arg is NULL)
> +=09=09 * and return -ENOTSUPP if DAX isn't allowed in this case:
> +=09=09 */
> +=09=09return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
> +=09=09=09=09=09     vmas, gup_flags | FOLL_TOUCH |
> +=09=09=09=09=09     FOLL_REMOTE);
> +=09}
> =20
>  =09return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
>  =09=09=09=09       locked,

