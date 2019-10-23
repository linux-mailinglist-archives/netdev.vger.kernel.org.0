Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D48E2284
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389772AbfJWScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:32:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55152 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbfJWScJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571855527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trYBfmu0/h2Xj7LHPj9GiCPYPw7fA57m7bgDr/vzOYg=;
        b=RJfB5o1NwiTr83fa5G/0GZfw2siNNxKo0DP8f5olMojrYTAEfwNNHDgs4CVMNH7nQkvcLI
        A6eYPDgFi6IZ+LukDbsXWGBnzCyt8RXPAedZeFnQ57S+qrrm5u45aXRllxnxLabNK+SjMm
        q7oMCRh/J1mmVsfO8gaHH0SnlQoLVps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-P9604vo7P06Gy8GTZ1EyCQ-1; Wed, 23 Oct 2019 14:32:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 137AA1800D6B;
        Wed, 23 Oct 2019 18:32:02 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF2BB19C78;
        Wed, 23 Oct 2019 18:31:53 +0000 (UTC)
Date:   Wed, 23 Oct 2019 20:31:49 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH net-next 3/4] page_pool: Restructure
 __page_pool_put_page()
Message-ID: <20191023203149.6b9f6d50@carbon>
In-Reply-To: <20191023084515.GA3726@apalos.home>
References: <20191022044343.6901-1-saeedm@mellanox.com>
        <20191022044343.6901-4-saeedm@mellanox.com>
        <20191023084515.GA3726@apalos.home>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: P9604vo7P06Gy8GTZ1EyCQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 11:45:15 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Tue, Oct 22, 2019 at 04:44:24AM +0000, Saeed Mahameed wrote:
> > From: Jonathan Lemon <jonathan.lemon@gmail.com>
> >=20
> > 1) Rename functions to reflect what they are actually doing.
> >=20
> > 2) Unify the condition to keep a page.
> >=20
> > 3) When page can't be kept in cache, fallback to releasing page to page
> > allocator in one place, instead of calling it from multiple conditions,
> > and reuse __page_pool_return_page().
> >=20
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  net/core/page_pool.c | 38 +++++++++++++++++++-------------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 8120aec999ce..65680aaa0818 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -258,6 +258,7 @@ static bool __page_pool_recycle_into_ring(struct pa=
ge_pool *pool,
> >  =09=09=09=09   struct page *page)
> >  {
> >  =09int ret;
> > +
> >  =09/* BH protection not needed if current is serving softirq */
> >  =09if (in_serving_softirq())
> >  =09=09ret =3D ptr_ring_produce(&pool->ring, page);
> > @@ -272,8 +273,8 @@ static bool __page_pool_recycle_into_ring(struct pa=
ge_pool *pool,
> >   *
> >   * Caller must provide appropriate safe context.
> >   */
> > -static bool __page_pool_recycle_direct(struct page *page,
> > -=09=09=09=09       struct page_pool *pool)
> > +static bool __page_pool_recycle_into_cache(struct page *page,
> > +=09=09=09=09=09   struct page_pool *pool)
> >  {
> >  =09if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
> >  =09=09return false;
> > @@ -283,15 +284,18 @@ static bool __page_pool_recycle_direct(struct pag=
e *page,
> >  =09return true;
> >  }
> > =20
> > -/* page is NOT reusable when:
> > - * 1) allocated when system is under some pressure. (page_is_pfmemallo=
c)
> > - * 2) belongs to a different NUMA node than pool->p.nid.
> > +/* Keep page in caches only if page:
> > + * 1) wasn't allocated when system is under some pressure (page_is_pfm=
emalloc).
> > + * 2) belongs to pool's numa node (pool->p.nid).
> > + * 3) refcount is 1 (owned by page pool).
> >   *
> >   * To update pool->p.nid users must call page_pool_update_nid.
> >   */
> > -static bool pool_page_reusable(struct page_pool *pool, struct page *pa=
ge)
> > +static bool page_pool_keep_page(struct page_pool *pool, struct page *p=
age)
> >  {
> > -=09return !page_is_pfmemalloc(page) && page_to_nid(page) =3D=3D pool->=
p.nid;
> > +=09return !page_is_pfmemalloc(page) &&
> > +=09       page_to_nid(page) =3D=3D pool->p.nid &&
> > +=09       page_ref_count(page) =3D=3D 1;
> >  }
> > =20
> >  void __page_pool_put_page(struct page_pool *pool,
> > @@ -300,22 +304,19 @@ void __page_pool_put_page(struct page_pool *pool,
> >  =09/* This allocator is optimized for the XDP mode that uses
> >  =09 * one-frame-per-page, but have fallbacks that act like the
> >  =09 * regular page allocator APIs.
> > -=09 *
> > -=09 * refcnt =3D=3D 1 means page_pool owns page, and can recycle it.
> >  =09 */
> > -=09if (likely(page_ref_count(page) =3D=3D 1 &&
> > -=09=09   pool_page_reusable(pool, page))) {
> > +
> > +=09if (likely(page_pool_keep_page(pool, page))) {
> >  =09=09/* Read barrier done in page_ref_count / READ_ONCE */
> > =20
> >  =09=09if (allow_direct && in_serving_softirq())
> > -=09=09=09if (__page_pool_recycle_direct(page, pool))
> > +=09=09=09if (__page_pool_recycle_into_cache(page, pool))
> >  =09=09=09=09return;
> > =20
> > -=09=09if (!__page_pool_recycle_into_ring(pool, page)) {
> > -=09=09=09/* Cache full, fallback to free pages */
> > -=09=09=09__page_pool_return_page(pool, page);
> > -=09=09}
> > -=09=09return;
> > +=09=09if (__page_pool_recycle_into_ring(pool, page))
> > +=09=09=09return;
> > +
> > +=09=09/* Cache full, fallback to return pages */
> >  =09}
> >  =09/* Fallback/non-XDP mode: API user have elevated refcnt.
> >  =09 *
> > @@ -330,8 +331,7 @@ void __page_pool_put_page(struct page_pool *pool,
> >  =09 * doing refcnt based recycle tricks, meaning another process
> >  =09 * will be invoking put_page.
> >  =09 */
> > -=09__page_pool_clean_page(pool, page);
> > -=09put_page(page);
> > +=09__page_pool_return_page(pool, page); =20
>=20
> I think Jesper had a reason for calling them separately instead of=20
> __page_pool_return_page + put_page() (which in fact does the same thing).=
=20
>=20
> In the future he was planning on removing the __page_pool_clean_page call=
 from
> there, since someone might call __page_pool_put_page() after someone has =
called
> __page_pool_clean_page()

Yes.  We need to work on removing this  __page_pool_clean_page() call,
to fulfill the plans of SKB returning/recycling page_pool pages.

> Can we leave the calls there as-is?

Yes, please.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

