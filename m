Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4DFEC40
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfKPMRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 07:17:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727471AbfKPMRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 07:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573906673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5e836FtExJw28OZVxlgH02W1ihrshgAA9cjRIRi2vCA=;
        b=ZR6yq+jrUEYSkfDCI+r2D6rMbUMxPsyGOOyFzWUFZvXozmJfnb8uIZq5HrYt/JTOuhEudJ
        oGCBLnjTZzM1dHk7eQQNLpD8OKQNMQOu1PY+RGu9g0RJ8cycOjJFELSyr7B9h5aoKpv5+n
        L3HWWBalifYqK5qMGoJNw3kgyI5VW5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-rupxIHayNNyMNZKeh_D6aQ-1; Sat, 16 Nov 2019 07:17:51 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59A0E5B37E;
        Sat, 16 Nov 2019 12:17:50 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5573560F8B;
        Sat, 16 Nov 2019 12:17:43 +0000 (UTC)
Date:   Sat, 16 Nov 2019 13:17:41 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191116131741.2657e1bb@carbon>
In-Reply-To: <20191116113630.GB20820@localhost.localdomain>
References: <cover.1573844190.git.lorenzo@kernel.org>
        <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
        <20191116122017.78e29e27@carbon>
        <20191116113630.GB20820@localhost.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: rupxIHayNNyMNZKeh_D6aQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Nov 2019 13:36:30 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > On Fri, 15 Nov 2019 21:01:38 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >  =20
> > >  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> > > -=09=09=09=09   struct page *page)
> > > +=09=09=09=09=09  struct page *page,
> > > +=09=09=09=09=09  unsigned int dma_sync_size)
> > >  {
> > >  =09int ret;
> > >  =09/* BH protection not needed if current is serving softirq */
> > > @@ -264,6 +285,9 @@ static bool __page_pool_recycle_into_ring(struct =
page_pool *pool,
> > >  =09else
> > >  =09=09ret =3D ptr_ring_produce_bh(&pool->ring, page);
> > > =20
> > > +=09if (ret =3D=3D 0 && (pool->p.flags & PP_FLAG_DMA_SYNC_DEV))
> > > +=09=09page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > > +
> > >  =09return (ret =3D=3D 0) ? true : false;
> > >  } =20
> >=20
> >=20
> > I do wonder if we should DMA-sync-for-device BEFORE putting page into
> > ptr_ring, as this is a channel between several concurrent CPUs. =20
>=20
> Hi Jesper,
>=20
> in this way we can end up syncing the DMA page even if it is unmapped in
> __page_pool_clean_page (e.g. if the ptr_ring is full), right?

Yes.  The call __page_pool_clean_page() will do a dma_unmap_page, so it
should still be safe/correct.   I can see, that it is not optimal
performance wise, in-case the ptr_ring is full, as DMA-sync-for-device
is wasted work.

I don't know if you can find an argument, that proves that it cannot
happen, that a remote CPU can dequeue/consume the page from ptr_ring
and give it to the device, while you (the CPU the enqueued) are still
doing the DMA-sync-for-device.

=20
> > > @@ -273,18 +297,22 @@ static bool __page_pool_recycle_into_ring(struc=
t page_pool *pool,
> > >   * Caller must provide appropriate safe context.
> > >   */
> > >  static bool __page_pool_recycle_direct(struct page *page,
> > > -=09=09=09=09       struct page_pool *pool)
> > > +=09=09=09=09       struct page_pool *pool,
> > > +=09=09=09=09       unsigned int dma_sync_size)
> > >  {
> > >  =09if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
> > >  =09=09return false;
> > > =20
> > >  =09/* Caller MUST have verified/know (page_ref_count(page) =3D=3D 1)=
 */
> > >  =09pool->alloc.cache[pool->alloc.count++] =3D page;
> > > +
> > > +=09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > > +=09=09page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > >  =09return true;
> > >  } =20
> >=20
> > We know __page_pool_recycle_direct() is concurrency safe, and only a
> > single (NAPI processing) CPU can enter. (So, the DMA-sync order is not
> > wrong here, but it could be swapped) =20
>=20
> do you mean move it before putting the page in the cache?
>=20
> pool->alloc.cache[pool->alloc.count++] =3D page;

Yes, but here the order doesn't matter.

If you choose to do the DMA-sync-for-device earlier/before, then look
at the code, and see of it makes sense to do it in __page_pool_put_page() ?
(I've not checked the details)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

