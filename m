Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C64FB8B4
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKMTXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:23:32 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38685 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKMTXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:23:32 -0500
Received: by mail-oi1-f196.google.com with SMTP id a14so2870828oid.5
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 11:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4HKVOkxUXCqQFAssnrt5HN+d13KJzjRJ1pFFkgydGzo=;
        b=bb6122LJyN4TYG5IK7mHh5xygfwPeVWP6I4JnFmlEb2IzPnSXePzt9c7h6VlwCNKNf
         6iTeoCZ+WCekF2UjJKYypJ3VDkp2bZI1sBd8OZia/73qpNgBlVpDNRkT98ztqaV4Pdpl
         ZVL0JboDgCGP8I4MHVFtdYs0p8UDQrSyipyLboTogqOsqYbQVAZcsnUwAJG32rUPMPmj
         ssxQ90TSW2CRqTDYyVFKczonUtqdX4nXBKSakXhSzcp3X5BqgSICBAOxp0Q1Cy1lQWwq
         g444805boKvN2nKVTBF8Zd13UMFnq8mUuIPok109u72I0derPDbhoGvKrYVRikRhE4Pc
         Y6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4HKVOkxUXCqQFAssnrt5HN+d13KJzjRJ1pFFkgydGzo=;
        b=TcyKS1Nqvkm/xt4lpAGs2ridpQATpO+SsbLJ1cEKj83ra/u787jT3dGvbLHbe8PU5/
         SzQK68xWcEKjdBsWel7VDfQxhiELQocwPPBjmyt59EehkRcHxpy+gYXXM4PW6JIdNDWK
         zkdgvMzjWbEuIvyKelmCp+Myz5HiDfj2zVlcxxy5QP4Wzt1fmILttDuRCYOEKwDckCos
         aKQ9WcVdRw+quJwXInakKgxgJnbe2GWd2bqlQ4BilOg0YZEIrTNSK+MrUNrqEjfvMr0l
         SPZVlmKBbv2vAVFkxTWrBKeoQaxMRE3HEyQIRbL6l583sZdtieap5M/WDMJaQ8L52tik
         3lEA==
X-Gm-Message-State: APjAAAVSGx1AGYr76ByswIbOlw2MKFtrzuq0U0K3HVdQxRRB/oFxMKj/
        vJxT20Ewf6mQ9GZeTSj/OoiQJq9jDGxWPpLZ0W7gzw==
X-Google-Smtp-Source: APXvYqw/J/xJikM9Sn2uJoSKIkSXprx6L2hjLUq/51PEKKOZdQDk8LIwVzxcWXUccXtFtayP/c8+SilHtOvsl5tzGrQ=
X-Received: by 2002:aca:ea57:: with SMTP id i84mr174326oih.73.1573673011067;
 Wed, 13 Nov 2019 11:23:31 -0800 (PST)
MIME-Version: 1.0
References: <20191113042710.3997854-1-jhubbard@nvidia.com> <20191113042710.3997854-5-jhubbard@nvidia.com>
In-Reply-To: <20191113042710.3997854-5-jhubbard@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 13 Nov 2019 11:23:19 -0800
Message-ID: <CAPcyv4gGu=G-c1czSAYJ3joTYS_ZYOJ6i9umKzCQEFzpwZMiiA@mail.gmail.com>
Subject: Re: [PATCH v4 04/23] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 8:27 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> An upcoming patch changes and complicates the refcounting and
> especially the "put page" aspects of it. In order to keep
> everything clean, refactor the devmap page release routines:
>
> * Rename put_devmap_managed_page() to page_is_devmap_managed(),
>   and limit the functionality to "read only": return a bool,
>   with no side effects.
>
> * Add a new routine, put_devmap_managed_page(), to handle checking
>   what kind of page it is, and what kind of refcount handling it
>   requires.
>
> * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
>   and limit the functionality to unconditionally freeing a devmap
>   page.
>
> This is originally based on a separate patch by Ira Weiny, which
> applied to an early version of the put_user_page() experiments.
> Since then, J=C3=A9r=C3=B4me Glisse suggested the refactoring described a=
bove.
>
> Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  include/linux/mm.h | 27 ++++++++++++++++---
>  mm/memremap.c      | 67 ++++++++++++++++++++--------------------------
>  2 files changed, 53 insertions(+), 41 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2adf95b3f9c..96228376139c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -967,9 +967,10 @@ static inline bool is_zone_device_page(const struct =
page *page)
>  #endif
>
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page);
> +void free_devmap_managed_page(struct page *page);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> -static inline bool put_devmap_managed_page(struct page *page)
> +
> +static inline bool page_is_devmap_managed(struct page *page)
>  {
>         if (!static_branch_unlikely(&devmap_managed_key))
>                 return false;
> @@ -978,7 +979,6 @@ static inline bool put_devmap_managed_page(struct pag=
e *page)
>         switch (page->pgmap->type) {
>         case MEMORY_DEVICE_PRIVATE:
>         case MEMORY_DEVICE_FS_DAX:
> -               __put_devmap_managed_page(page);
>                 return true;
>         default:
>                 break;
> @@ -986,6 +986,27 @@ static inline bool put_devmap_managed_page(struct pa=
ge *page)
>         return false;
>  }
>
> +static inline bool put_devmap_managed_page(struct page *page)
> +{
> +       bool is_devmap =3D page_is_devmap_managed(page);
> +
> +       if (is_devmap) {
> +               int count =3D page_ref_dec_return(page);
> +
> +               /*
> +                * devmap page refcounts are 1-based, rather than 0-based=
: if
> +                * refcount is 1, then the page is free and the refcount =
is
> +                * stable because nobody holds a reference on the page.
> +                */
> +               if (count =3D=3D 1)
> +                       free_devmap_managed_page(page);
> +               else if (!count)
> +                       __put_page(page);
> +       }
> +
> +       return is_devmap;
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
>
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page)
> +void free_devmap_managed_page(struct page *page)
>  {
> -       int count =3D page_ref_dec_return(page);
> +       /* Clear Active bit in case of parallel mark_page_accessed */
> +       __ClearPageActive(page);
> +       __ClearPageWaiters(page);
> +
> +       mem_cgroup_uncharge(page);

Ugh, when did all this HMM specific manipulation sneak into the
generic ZONE_DEVICE path? It used to be gated by pgmap type with its
own put_zone_device_private_page(). For example it's certainly
unnecessary and might be broken (would need to check) to call
mem_cgroup_uncharge() on a DAX page. ZONE_DEVICE users are not a
monolith and the HMM use case leaks pages into code paths that DAX
explicitly avoids.
