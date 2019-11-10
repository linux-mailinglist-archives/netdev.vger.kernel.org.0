Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC5F67F0
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 09:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfKJH7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 02:59:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726586AbfKJH7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 02:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573372790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gv5JBjRuXYVZQbC+eZMDz/DzjRT3p9TbD0icISk6mbE=;
        b=QwXzpGSpO9f8eNDNte7SLbdmGLkVgMIa8jb6O/eKO7cfOmS/PBLv8kNO194StEyVaozSts
        Ig3gavecUEDy6FnTAZxA+mBWqFbGcBNvehNs+pmVqphIcLLFOetDAfG3KJfNVyzsXjeXaj
        4H4rCeTTXSCmbAK+G/fqA3/RxYqeoAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-NaAFNjdEP922PMaWmCIz0w-1; Sun, 10 Nov 2019 02:59:49 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DE771852E20;
        Sun, 10 Nov 2019 07:59:48 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3E0728999;
        Sun, 10 Nov 2019 07:59:40 +0000 (UTC)
Date:   Sun, 10 Nov 2019 08:59:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        netdev@vger.kernel.org,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>, brouer@redhat.com
Subject: Re: [net-next v1 PATCH 1/2] xdp: revert forced mem allocator
 removal for page_pool
Message-ID: <20191110085939.23013f83@carbon>
In-Reply-To: <5FDB1D3C-3A80-4F70-A7F0-03D4CD4061EB@gmail.com>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
        <157323722276.10408.11333995838112864686.stgit@firesoul>
        <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
        <20191109171109.38c90490@carbon>
        <5FDB1D3C-3A80-4F70-A7F0-03D4CD4061EB@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: NaAFNjdEP922PMaWmCIz0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 09 Nov 2019 09:34:50 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> On 9 Nov 2019, at 8:11, Jesper Dangaard Brouer wrote:
>=20
> > On Fri, 08 Nov 2019 11:16:43 -0800
> > "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
> > =20
> >>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >>> index 5bc65587f1c4..226f2eb30418 100644
> >>> --- a/net/core/page_pool.c
> >>> +++ b/net/core/page_pool.c
> >>> @@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool
> >>> *pool)
> >>>
> >>>  =09distance =3D _distance(hold_cnt, release_cnt);
> >>>
> >>> -=09/* Drivers should fix this, but only problematic when DMA is used=
 */
> >>> +=09/* BUG but warn as kernel should crash later */
> >>>  =09WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> >>>  =09     distance, hold_cnt, release_cnt); =20
> >
> > Because this is kept as a WARN, I set pool->ring.queue =3D NULL later. =
=20
>=20
> ... which is also an API violation, reaching into the ring internals.
> I strongly dislike this.

I understand your dislike of reaching into ptr_ring "internals".
But my plan was to add this here, and then in a followup patch move this
pool->ring.queue=3DNULL into the ptr_ring.

=20
> >>>  }
> >>> @@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
> >>>  =09WARN(pool->alloc.count, "API usage violation");
> >>>  =09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> >>>
> >>> -=09/* Can happen due to forced shutdown */
> >>>  =09if (!__page_pool_safe_to_destroy(pool))
> >>>  =09=09__warn_in_flight(pool); =20
> >>
> >> If it's not safe to destroy, we shouldn't be getting here. =20
> >
> > Don't make such assumptions. The API is going to be used by driver
> > developer and they are always a little too creative... =20
>=20
> If the driver hits this case, the driver has a bug, and it isn't
> safe to continue in any fashion.  The developer needs to fix their
> driver in that case.  (see stmmac code)

The stmmac driver is NOT broken, they simply use page_pool as their
driver level page-cache.  That is exactly what page_pool was designed
for, creating a generic page-cache for drivers to use.  They use this
to simplify their driver.  They don't use the advanced features, which
requires hooking into mem model reg.

>=20
> > The page_pool is a separate facility, it is not tied to the
> > xdp_rxq_info memory model.  Some drivers use page_pool directly e.g.
> > drivers/net/ethernet/stmicro/stmmac.  It can easily trigger this case,
> > when some extend that driver. =20
>=20
> Yes, and I pointed out that the mem_info should likely be completely
> detached from xdp.c since it really has nothing to do with XDP.
> The stmmac driver is actually broken at the moment, as it tries to
> free the pool immediately without a timeout.
>=20
> What should be happening is that drivers just call page_pool_destroy(),
> which kicks off the shutdown process if this was the last user ref,
> and delays destruction if packets are in flight.

Sorry, but I'm getting frustrated with you. I've already explained you
(offlist), that the memory model reg/unreg system have been created to
support multiple memory models (even per RX-queue).  We already have
AF_XDP zero copy, but I actually want to keep the flexibility and add
more in the future.

=20
> >>>  =09ptr_ring_cleanup(&pool->ring, NULL);
> >>>
> >>> +=09/* Make sure kernel will crash on use-after-free */
> >>> +=09pool->ring.queue =3D NULL;
> >>> +=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
> >>> +=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE; =20
> >>
> >> The pool is going to be freed.  This is useless code; if we're
> >> really concerned about use-after-free, the correct place for catching
> >> this is with the memory-allocator tools, not scattering things like
> >> this ad-hoc over the codebase. =20
> >
> > No, I need this code here, because we kept the above WARN() and didn't
> > change that into a BUG().  It is obviously not a full solution for
> > use-after-free detection.  The memory subsystem have kmemleak to catch
> > this kind of stuff, but nobody runs this in production.  I need this
> > here to catch some obvious runtime cases. =20
>=20
> The WARN() indicates something went off the rails already.  I really
> don't like half-assed solutions like the above; it may or may not work
> properly.  If it doesn't work properly, then what's the point?

So, you are suggesting to use BUG_ON() instead and crash the kernel
immediately... you do know Linus hates when we do that, right?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

