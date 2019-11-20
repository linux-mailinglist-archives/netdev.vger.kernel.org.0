Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78021043E0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKTTEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:04:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbfKTTEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574276660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpEtQs3UxFQUegUZrSUv1R7T7SsFuZ3Q6EsdyBQuWmY=;
        b=gQbpyfYVkygfwS/Tk7Hrj+Zp37M9Z6mvPJcNj4ORQYJm4R47kYAda9EWuiWogqDWNcEcTz
        UPM7GUEsO1QSqyYJBGxbv05WrJPfJBfiOx+f6lwQ1ydi9OQwG03s5w/J1yURaYHY8+wJ8B
        cUldmMhbJZKZjBZ4f2C5rCRzFxzvj/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-7ps7GRO_Mj-dnqDSygWcXA-1; Wed, 20 Nov 2019 14:04:19 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5B26800A02;
        Wed, 20 Nov 2019 19:04:17 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A84D1C947;
        Wed, 20 Nov 2019 19:04:09 +0000 (UTC)
Date:   Wed, 20 Nov 2019 20:04:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, mcroce@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191120200408.38b39201@carbon>
In-Reply-To: <3DD728CA-CF0B-4F26-AF64-4E1C357D0F0C@gmail.com>
References: <cover.1574261017.git.lorenzo@kernel.org>
        <4a22dd0ef91220748c4d3da366082a13190fb794.1574261017.git.lorenzo@kernel.org>
        <20191120184901.59306f16@carbon>
        <3DD728CA-CF0B-4F26-AF64-4E1C357D0F0C@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 7ps7GRO_Mj-dnqDSygWcXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 10:42:47 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> On 20 Nov 2019, at 9:49, Jesper Dangaard Brouer wrote:
>=20
> > On Wed, 20 Nov 2019 16:54:18 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > =20
> >> Introduce the following parameters in order to add the possibility to=
=20
> >> sync
> >> DMA memory for device before putting allocated pages in the page_pool
> >> caches:
> >> - PP_FLAG_DMA_SYNC_DEV: if set in page_pool_params flags, all pages=20
> >> that
> >>   the driver gets from page_pool will be DMA-synced-for-device=20
> >> according
> >>   to the length provided by the device driver. Please note=20
> >> DMA-sync-for-CPU
> >>   is still device driver responsibility
> >> - offset: DMA address offset where the DMA engine starts copying rx=20
> >> data
> >> - max_len: maximum DMA memory size page_pool is allowed to flush.=20
> >> This
> >>   is currently used in __page_pool_alloc_pages_slow routine when=20
> >> pages
> >>   are allocated from page allocator
> >> These parameters are supposed to be set by device drivers.
> >>
> >> This optimization reduces the length of the DMA-sync-for-device.
> >> The optimization is valid because pages are initially
> >> DMA-synced-for-device as defined via max_len. At RX time, the driver
> >> will perform a DMA-sync-for-CPU on the memory for the packet length.
> >> What is important is the memory occupied by packet payload, because
> >> this is the area CPU is allowed to read and modify. As we don't track
> >> cache-lines written into by the CPU, simply use the packet payload=20
> >> length
> >> as dma_sync_size at page_pool recycle time. This also take into=20
> >> account
> >> any tail-extend.
> >>
> >> Tested-by: Matteo Croce <mcroce@redhat.com>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> --- =20
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >
> > [...] =20
> >> @@ -281,8 +309,8 @@ static bool __page_pool_recycle_direct(struct=20
> >> page *page,
> >>  =09return true;
> >>  }
> >>
> >> -void __page_pool_put_page(struct page_pool *pool,
> >> -=09=09=09  struct page *page, bool allow_direct)
> >> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> >> +=09=09=09  unsigned int dma_sync_size, bool allow_direct)
> >>  {
> >>  =09/* This allocator is optimized for the XDP mode that uses
> >>  =09 * one-frame-per-page, but have fallbacks that act like the
> >> @@ -293,6 +321,10 @@ void __page_pool_put_page(struct page_pool=20
> >> *pool,
> >>  =09if (likely(page_ref_count(page) =3D=3D 1)) {
> >>  =09=09/* Read barrier done in page_ref_count / READ_ONCE */
> >>
> >> +=09=09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> >> +=09=09=09page_pool_dma_sync_for_device(pool, page,
> >> +=09=09=09=09=09=09      dma_sync_size);
> >> +
> >>  =09=09if (allow_direct && in_serving_softirq())
> >>  =09=09=09if (__page_pool_recycle_direct(page, pool))
> >>  =09=09=09=09return; =20
> >
> > I am slightly concerned this touch the fast-path code. But at-least on
> > Intel, I don't think this is measurable.  And for the ARM64 board it
> > was a huge win... thus I'll accept this. =20
>=20
> For the next series:
>=20
> The "in_serving_softirq()" check shows up on profiling.  I'd
> like to remove this and just have a "direct" flag, where the
> caller takes the responsibility of the correct context.

As far as I can remember, this was added due to a bug in mlx5 shutdown
path... that needs to be fixed first.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

