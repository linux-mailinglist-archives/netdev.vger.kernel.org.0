Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5ADF6038
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 17:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfKIQLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 11:11:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41177 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726125AbfKIQLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 11:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573315880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAEove3d2E+bHEIl91eaavRo/liToIb7pRx0YHENVv8=;
        b=G3a+f1/3sNFQh2q8i/Zqd6xM+X5w8QZijiuZ8vfr83qJKo/ySVodoULLmaunNPgDF7mKba
        zoakN/FJpY6FwOpPLc/ToofKgdAl5SJnmskCizgy7DOyc5Jgh4uw4fNbvQh313CdETpnM9
        GvK9zHh4HEflqbtH3cZ7JdWU+t53Obo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-JxS6mEBcPDuJUQcG3L-F4Q-1; Sat, 09 Nov 2019 11:11:19 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78D121005500;
        Sat,  9 Nov 2019 16:11:18 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF4606085E;
        Sat,  9 Nov 2019 16:11:10 +0000 (UTC)
Date:   Sat, 9 Nov 2019 17:11:09 +0100
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
Message-ID: <20191109171109.38c90490@carbon>
In-Reply-To: <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
        <157323722276.10408.11333995838112864686.stgit@firesoul>
        <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: JxS6mEBcPDuJUQcG3L-F4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 Nov 2019 11:16:43 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 5bc65587f1c4..226f2eb30418 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool=20
> > *pool)
> >
> >  =09distance =3D _distance(hold_cnt, release_cnt);
> >
> > -=09/* Drivers should fix this, but only problematic when DMA is used *=
/
> > +=09/* BUG but warn as kernel should crash later */
> >  =09WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> >  =09     distance, hold_cnt, release_cnt);

Because this is kept as a WARN, I set pool->ring.queue =3D NULL later.

> >  }
> > @@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
> >  =09WARN(pool->alloc.count, "API usage violation");
> >  =09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> >
> > -=09/* Can happen due to forced shutdown */
> >  =09if (!__page_pool_safe_to_destroy(pool))
> >  =09=09__warn_in_flight(pool); =20
>=20
> If it's not safe to destroy, we shouldn't be getting here.

Don't make such assumptions. The API is going to be used by driver
developer and they are always a little too creative...

The page_pool is a separate facility, it is not tied to the
xdp_rxq_info memory model.  Some drivers use page_pool directly e.g.
drivers/net/ethernet/stmicro/stmmac.  It can easily trigger this case,
when some extend that driver.

=20
> >  =09ptr_ring_cleanup(&pool->ring, NULL);
> >
> > +=09/* Make sure kernel will crash on use-after-free */
> > +=09pool->ring.queue =3D NULL;
> > +=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
> > +=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE; =20
>=20
> The pool is going to be freed.  This is useless code; if we're
> really concerned about use-after-free, the correct place for catching
> this is with the memory-allocator tools, not scattering things like
> this ad-hoc over the codebase.

No, I need this code here, because we kept the above WARN() and didn't
change that into a BUG().  It is obviously not a full solution for
use-after-free detection.  The memory subsystem have kmemleak to catch
this kind of stuff, but nobody runs this in production.  I need this
here to catch some obvious runtime cases.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

