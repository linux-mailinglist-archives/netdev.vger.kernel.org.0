Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1853AEE4D6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfKDQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:39:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43468 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728999AbfKDQjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:39:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572885575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKRtyHtWqxotoMRVCD2L231GIf5CzzOu6K7yMpGCV1E=;
        b=EISj5KjZrUl3kZNHgeVxg9gzAbcLy4Tpe15p04ZJX+1X/PP0zhFi/jqdDWYjMDEhoU+i0C
        JuU/cWz6scDZOZMQlwE2N2QuxICFFYXRzNVTjImH796mEQWD/wjXHkzq8BvJ4gOxbXcJlq
        N9g+v2tQVhedXU+Lsqq3rbwA789furQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-XcpsC-lSP4a7ehsn9d2sxg-1; Mon, 04 Nov 2019 11:39:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6C88017DD;
        Mon,  4 Nov 2019 16:39:27 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A6F5C240;
        Mon,  4 Nov 2019 16:39:20 +0000 (UTC)
Date:   Mon, 4 Nov 2019 11:39:19 -0500
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v2 01/18] mm/gup: pass flags arg to __gup_device_*
 functions
Message-ID: <20191104163919.GA5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-2-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-2-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: XcpsC-lSP4a7ehsn9d2sxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 01:17:56PM -0800, John Hubbard wrote:
> A subsequent patch requires access to gup flags, so
> pass the flags argument through to the __gup_device_*
> functions.
>=20
> Also placate checkpatch.pl by shortening a nearby line.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>

> ---
>  mm/gup.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>=20
> diff --git a/mm/gup.c b/mm/gup.c
> index 8f236a335ae9..85caf76b3012 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1890,7 +1890,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long a=
ddr, unsigned long end,
> =20
>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HU=
GEPAGE)
>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
> -=09=09unsigned long end, struct page **pages, int *nr)
> +=09=09=09     unsigned long end, unsigned int flags,
> +=09=09=09     struct page **pages, int *nr)
>  {
>  =09int nr_start =3D *nr;
>  =09struct dev_pagemap *pgmap =3D NULL;
> @@ -1916,13 +1917,14 @@ static int __gup_device_huge(unsigned long pfn, u=
nsigned long addr,
>  }
> =20
>  static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long =
addr,
> -=09=09unsigned long end, struct page **pages, int *nr)
> +=09=09=09=09 unsigned long end, unsigned int flags,
> +=09=09=09=09 struct page **pages, int *nr)
>  {
>  =09unsigned long fault_pfn;
>  =09int nr_start =3D *nr;
> =20
>  =09fault_pfn =3D pmd_pfn(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> -=09if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
> +=09if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
>  =09=09return 0;
> =20
>  =09if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
> @@ -1933,13 +1935,14 @@ static int __gup_device_huge_pmd(pmd_t orig, pmd_=
t *pmdp, unsigned long addr,
>  }
> =20
>  static int __gup_device_huge_pud(pud_t orig, pud_t *pudp, unsigned long =
addr,
> -=09=09unsigned long end, struct page **pages, int *nr)
> +=09=09=09=09 unsigned long end, unsigned int flags,
> +=09=09=09=09 struct page **pages, int *nr)
>  {
>  =09unsigned long fault_pfn;
>  =09int nr_start =3D *nr;
> =20
>  =09fault_pfn =3D pud_pfn(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> -=09if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
> +=09if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
>  =09=09return 0;
> =20
>  =09if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
> @@ -1950,14 +1953,16 @@ static int __gup_device_huge_pud(pud_t orig, pud_=
t *pudp, unsigned long addr,
>  }
>  #else
>  static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long =
addr,
> -=09=09unsigned long end, struct page **pages, int *nr)
> +=09=09=09=09 unsigned long end, unsigned int flags,
> +=09=09=09=09 struct page **pages, int *nr)
>  {
>  =09BUILD_BUG();
>  =09return 0;
>  }
> =20
>  static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long a=
ddr,
> -=09=09unsigned long end, struct page **pages, int *nr)
> +=09=09=09=09 unsigned long end, unsigned int flags,
> +=09=09=09=09 struct page **pages, int *nr)
>  {
>  =09BUILD_BUG();
>  =09return 0;
> @@ -2062,7 +2067,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, un=
signed long addr,
>  =09if (pmd_devmap(orig)) {
>  =09=09if (unlikely(flags & FOLL_LONGTERM))
>  =09=09=09return 0;
> -=09=09return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
> +=09=09return __gup_device_huge_pmd(orig, pmdp, addr, end, flags,
> +=09=09=09=09=09     pages, nr);
>  =09}
> =20
>  =09refs =3D 0;
> @@ -2092,7 +2098,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, un=
signed long addr,
>  }
> =20
>  static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
> -=09=09unsigned long end, unsigned int flags, struct page **pages, int *n=
r)
> +=09=09=09unsigned long end, unsigned int flags,
> +=09=09=09struct page **pages, int *nr)
>  {
>  =09struct page *head, *page;
>  =09int refs;
> @@ -2103,7 +2110,8 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, un=
signed long addr,
>  =09if (pud_devmap(orig)) {
>  =09=09if (unlikely(flags & FOLL_LONGTERM))
>  =09=09=09return 0;
> -=09=09return __gup_device_huge_pud(orig, pudp, addr, end, pages, nr);
> +=09=09return __gup_device_huge_pud(orig, pudp, addr, end, flags,
> +=09=09=09=09=09     pages, nr);
>  =09}
> =20
>  =09refs =3D 0;
> --=20
> 2.23.0
>=20

