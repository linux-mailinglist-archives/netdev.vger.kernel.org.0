Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9188FB882
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfKMTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:10:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727290AbfKMTKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:10:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573672210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZKcq2+kOyDCaVGdS9JomObq8I4bIijQAekiTqk+QoQ=;
        b=P9aAbaATvWtFc2rWffL1YeinkVUo0M4DYzmnFsWaIFs93f1llboEze32J8DUBArtZlV+7J
        Bh+vBs2oxNG6+fkZVIXQMMuStrI30Itj8B0y+rqeW5jp7NPnZNz+3aCQCnYFJZNsBo8GcK
        F2SWbDdvo4f2IHVlAriL18OzHN/SSzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-lVqDgIG9Os6vw3HkWylEYw-1; Wed, 13 Nov 2019 14:10:08 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5FAA8048E2;
        Wed, 13 Nov 2019 19:10:01 +0000 (UTC)
Received: from redhat.com (ovpn-121-71.rdu2.redhat.com [10.10.121.71])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3175B601B8;
        Wed, 13 Nov 2019 19:09:54 +0000 (UTC)
Date:   Wed, 13 Nov 2019 14:09:52 -0500
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
Subject: Re: [PATCH v4 04/23] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
Message-ID: <20191113190952.GA4369@redhat.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-5-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191113042710.3997854-5-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: lVqDgIG9Os6vw3HkWylEYw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 08:26:51PM -0800, John Hubbard wrote:
> An upcoming patch changes and complicates the refcounting and
> especially the "put page" aspects of it. In order to keep
> everything clean, refactor the devmap page release routines:
>=20
> * Rename put_devmap_managed_page() to page_is_devmap_managed(),
>   and limit the functionality to "read only": return a bool,
>   with no side effects.
>=20
> * Add a new routine, put_devmap_managed_page(), to handle checking
>   what kind of page it is, and what kind of refcount handling it
>   requires.
>=20
> * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
>   and limit the functionality to unconditionally freeing a devmap
>   page.
>=20
> This is originally based on a separate patch by Ira Weiny, which
> applied to an early version of the put_user_page() experiments.
> Since then, J=E9r=F4me Glisse suggested the refactoring described above.
>=20
> Suggested-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>

> ---
>  include/linux/mm.h | 27 ++++++++++++++++---
>  mm/memremap.c      | 67 ++++++++++++++++++++--------------------------
>  2 files changed, 53 insertions(+), 41 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2adf95b3f9c..96228376139c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -967,9 +967,10 @@ static inline bool is_zone_device_page(const struct =
page *page)
>  #endif
> =20
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page);
> +void free_devmap_managed_page(struct page *page);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> -static inline bool put_devmap_managed_page(struct page *page)
> +
> +static inline bool page_is_devmap_managed(struct page *page)
>  {
>  =09if (!static_branch_unlikely(&devmap_managed_key))
>  =09=09return false;
> @@ -978,7 +979,6 @@ static inline bool put_devmap_managed_page(struct pag=
e *page)
>  =09switch (page->pgmap->type) {
>  =09case MEMORY_DEVICE_PRIVATE:
>  =09case MEMORY_DEVICE_FS_DAX:
> -=09=09__put_devmap_managed_page(page);
>  =09=09return true;
>  =09default:
>  =09=09break;
> @@ -986,6 +986,27 @@ static inline bool put_devmap_managed_page(struct pa=
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
> +=09=09/*
> +=09=09 * devmap page refcounts are 1-based, rather than 0-based: if
> +=09=09 * refcount is 1, then the page is free and the refcount is
> +=09=09 * stable because nobody holds a reference on the page.
> +=09=09 */
> +=09=09if (count =3D=3D 1)
> +=09=09=09free_devmap_managed_page(page);
> +=09=09else if (!count)
> +=09=09=09__put_page(page);
> +=09}
> +
> +=09return is_devmap;
> +}
> +
>  #else /* CONFIG_DEV_PAGEMAP_OPS */
>  static inline bool put_devmap_managed_page(struct page *page)
>  {
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 03ccbdfeb697..bc7e2a27d025 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -410,48 +410,39 @@ struct dev_pagemap *get_dev_pagemap(unsigned long p=
fn,
>  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> =20
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page)
> +void free_devmap_managed_page(struct page *page)
>  {
> -=09int count =3D page_ref_dec_return(page);
> +=09/* Clear Active bit in case of parallel mark_page_accessed */
> +=09__ClearPageActive(page);
> +=09__ClearPageWaiters(page);
> +
> +=09mem_cgroup_uncharge(page);
> =20
>  =09/*
> -=09 * If refcount is 1 then page is freed and refcount is stable as nobo=
dy
> -=09 * holds a reference on the page.
> +=09 * When a device_private page is freed, the page->mapping field
> +=09 * may still contain a (stale) mapping value. For example, the
> +=09 * lower bits of page->mapping may still identify the page as
> +=09 * an anonymous page. Ultimately, this entire field is just
> +=09 * stale and wrong, and it will cause errors if not cleared.
> +=09 * One example is:
> +=09 *
> +=09 *  migrate_vma_pages()
> +=09 *    migrate_vma_insert_page()
> +=09 *      page_add_new_anon_rmap()
> +=09 *        __page_set_anon_rmap()
> +=09 *          ...checks page->mapping, via PageAnon(page) call,
> +=09 *            and incorrectly concludes that the page is an
> +=09 *            anonymous page. Therefore, it incorrectly,
> +=09 *            silently fails to set up the new anon rmap.
> +=09 *
> +=09 * For other types of ZONE_DEVICE pages, migration is either
> +=09 * handled differently or not done at all, so there is no need
> +=09 * to clear page->mapping.
>  =09 */
> -=09if (count =3D=3D 1) {
> -=09=09/* Clear Active bit in case of parallel mark_page_accessed */
> -=09=09__ClearPageActive(page);
> -=09=09__ClearPageWaiters(page);
> -
> -=09=09mem_cgroup_uncharge(page);
> -
> -=09=09/*
> -=09=09 * When a device_private page is freed, the page->mapping field
> -=09=09 * may still contain a (stale) mapping value. For example, the
> -=09=09 * lower bits of page->mapping may still identify the page as
> -=09=09 * an anonymous page. Ultimately, this entire field is just
> -=09=09 * stale and wrong, and it will cause errors if not cleared.
> -=09=09 * One example is:
> -=09=09 *
> -=09=09 *  migrate_vma_pages()
> -=09=09 *    migrate_vma_insert_page()
> -=09=09 *      page_add_new_anon_rmap()
> -=09=09 *        __page_set_anon_rmap()
> -=09=09 *          ...checks page->mapping, via PageAnon(page) call,
> -=09=09 *            and incorrectly concludes that the page is an
> -=09=09 *            anonymous page. Therefore, it incorrectly,
> -=09=09 *            silently fails to set up the new anon rmap.
> -=09=09 *
> -=09=09 * For other types of ZONE_DEVICE pages, migration is either
> -=09=09 * handled differently or not done at all, so there is no need
> -=09=09 * to clear page->mapping.
> -=09=09 */
> -=09=09if (is_device_private_page(page))
> -=09=09=09page->mapping =3D NULL;
> +=09if (is_device_private_page(page))
> +=09=09page->mapping =3D NULL;
> =20
> -=09=09page->pgmap->ops->page_free(page);
> -=09} else if (!count)
> -=09=09__put_page(page);
> +=09page->pgmap->ops->page_free(page);
>  }
> -EXPORT_SYMBOL(__put_devmap_managed_page);
> +EXPORT_SYMBOL(free_devmap_managed_page);
>  #endif /* CONFIG_DEV_PAGEMAP_OPS */
> --=20
> 2.24.0
>=20

