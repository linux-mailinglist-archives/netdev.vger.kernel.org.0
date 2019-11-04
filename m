Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E99EE679
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfKDRpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:45:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728144AbfKDRpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572889500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YOrYp+dHNK++F3TdjbhwlDZUdTKuNCY8bLNbrJapJJQ=;
        b=ZN2NiQ3rqfZx8iq/tcB47dII+1zdUZU6gUqQ4N8Z0uxbTlfsiZIkqz6vF1vrIrxOICEcO1
        zXPYT73zyFDZ8egp7B9jlBNEp2PrQ2Fwmpat2lNWT0Yr8vtU7gIo2gYEhwFHA8E1WV4z2H
        zB6SnQ6/dYsdwm16bO7XCMOS7zXdP1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-fsjodwpeO-WySaLYuw_60g-1; Mon, 04 Nov 2019 12:44:56 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3BE31005500;
        Mon,  4 Nov 2019 17:44:52 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7484E600C4;
        Mon,  4 Nov 2019 17:44:47 +0000 (UTC)
Date:   Mon, 4 Nov 2019 12:44:45 -0500
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
Subject: Re: [PATCH v2 09/18] drm/via: set FOLL_PIN via pin_user_pages_fast()
Message-ID: <20191104174445.GF5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-10-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-10-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: fsjodwpeO-WySaLYuw_60g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 01:18:04PM -0800, John Hubbard wrote:
> Convert drm/via to use the new pin_user_pages_fast() call, which sets
> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
> tracking of pinned pages, and therefore for any code that calls
> put_user_page().
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Please be more explicit that via_dmablit.c is already using put_user_page()
as i am expecting that any conversion to pin_user_pages*() must be pair wit=
h
a put_user_page(). I find above commit message bit unclear from that POV.

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>


> ---
>  drivers/gpu/drm/via/via_dmablit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_=
dmablit.c
> index 3db000aacd26..37c5e572993a 100644
> --- a/drivers/gpu/drm/via/via_dmablit.c
> +++ b/drivers/gpu/drm/via/via_dmablit.c
> @@ -239,7 +239,7 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_v=
ia_dmablit_t *xfer)
>  =09vsg->pages =3D vzalloc(array_size(sizeof(struct page *), vsg->num_pag=
es));
>  =09if (NULL =3D=3D vsg->pages)
>  =09=09return -ENOMEM;
> -=09ret =3D get_user_pages_fast((unsigned long)xfer->mem_addr,
> +=09ret =3D pin_user_pages_fast((unsigned long)xfer->mem_addr,
>  =09=09=09vsg->num_pages,
>  =09=09=09vsg->direction =3D=3D DMA_FROM_DEVICE ? FOLL_WRITE : 0,
>  =09=09=09vsg->pages);
> --=20
> 2.23.0
>=20

