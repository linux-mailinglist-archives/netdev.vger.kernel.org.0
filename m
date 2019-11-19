Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8609B1027CC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfKSPNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:13:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727124AbfKSPNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574176428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iU2o0S3rWF/eJUkJlr351EcMOLTVo0g68Y6w0KqKwGE=;
        b=CvdGFz2dN5EyvBzwRY8IvE2EfjNIO8HtT69X5bbPTjcq4RKZr0f29djlvepugXBJbdvHXf
        K/dGo1YG1XbC26CmObh/Qq71ms/4DCS/3Nz8YByHcXZw2CEfP+H6I07Z6yiu+dA+80xjpv
        qmswXjn/XbrFO9L3xcorrO52XhKvN2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-7YKBntXTNeuUxsmSU44lFw-1; Tue, 19 Nov 2019 10:13:44 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC398EDBDA;
        Tue, 19 Nov 2019 15:13:42 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE6AF605BC;
        Tue, 19 Nov 2019 15:13:33 +0000 (UTC)
Date:   Tue, 19 Nov 2019 16:13:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, mcroce@redhat.com
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119161332.56faa205@carbon>
In-Reply-To: <20191119121430.GA3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
        <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
        <20191119122358.12276da4@carbon>
        <20191119121430.GA3449@localhost.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 7YKBntXTNeuUxsmSU44lFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 14:14:30 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Mon, 18 Nov 2019 15:33:45 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >  =20
> > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > index 1121faa99c12..6f684c3a3434 100644
> > > --- a/include/net/page_pool.h
> > > +++ b/include/net/page_pool.h
> > > @@ -34,8 +34,15 @@
> > >  #include <linux/ptr_ring.h>
> > >  #include <linux/dma-direction.h>
> > > =20
> > > -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap *=
/
> > > -#define PP_FLAG_ALL=09PP_FLAG_DMA_MAP
> > > +#define PP_FLAG_DMA_MAP=09=091 /* Should page_pool do the DMA map/un=
map */
> > > +#define PP_FLAG_DMA_SYNC_DEV=092 /* if set all pages that the driver=
 gets
> > > +=09=09=09=09   * from page_pool will be
> > > +=09=09=09=09   * DMA-synced-for-device according to the
> > > +=09=09=09=09   * length provided by the device driver.
> > > +=09=09=09=09   * Please note DMA-sync-for-CPU is still
> > > +=09=09=09=09   * device driver responsibility
> > > +=09=09=09=09   */
> > > +#define PP_FLAG_ALL=09=09(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> > >   =20
> > [...]
> >=20
> > Can you please change this to use the BIT(X) api.
> >=20
> > #include <linux/bits.h>
> >=20
> > #define PP_FLAG_DMA_MAP=09=09BIT(0)
> > #define PP_FLAG_DMA_SYNC_DEV=09BIT(1) =20
>=20
> Hi Jesper,
>=20
> sure, will do in v5
>=20
> >=20
> >=20
> >  =20
> > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > index dfc2501c35d9..4f9aed7bce5a 100644
> > > --- a/net/core/page_pool.c
> > > +++ b/net/core/page_pool.c
> > > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
> > >  =09    (pool->p.dma_dir !=3D DMA_BIDIRECTIONAL))
> > >  =09=09return -EINVAL;
> > > =20
> > > +=09/* In order to request DMA-sync-for-device the page needs to
> > > +=09 * be mapped
> > > +=09 */
> > > +=09if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > > +=09    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > > +=09=09return -EINVAL;
> > > + =20
> >=20
> > I like that you have moved this check to setup time.
> >=20
> > There are two other parameters the DMA_SYNC_DEV depend on:
> >=20
> >  =09struct page_pool_params pp_params =3D {
> >  =09=09.order =3D 0,
> > -=09=09.flags =3D PP_FLAG_DMA_MAP,
> > +=09=09.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> >  =09=09.pool_size =3D size,
> >  =09=09.nid =3D cpu_to_node(0),
> >  =09=09.dev =3D pp->dev->dev.parent,
> >  =09=09.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> > +=09=09.offset =3D pp->rx_offset_correction,
> > +=09=09.max_len =3D MVNETA_MAX_RX_BUF_SIZE,
> >  =09};
> >=20
> > Can you add a check, that .max_len must not be zero.  The reason is
> > that I can easily see people misconfiguring this.  And the effect is
> > that the DMA-sync-for-device is essentially disabled, without user
> > realizing this. The not-realizing part is really bad, especially
> > because bugs that can occur from this are very rare and hard to catch. =
=20
>=20
> I guess we need to check it just if we provide PP_FLAG_DMA_SYNC_DEV.
> Something like:
>=20
> =09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
> =09=09if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> =09=09=09return -EINVAL;
>=20
> =09=09if (!pool->p.max_len)
> =09=09=09return -EINVAL;
> =09}

Yes, exactly.

> >=20
> > I'm up for discussing if there should be a similar check for .offset.
> > IMHO we should also check .offset is configured, and then be open to
> > remove this check once a driver user want to use offset=3D0.  Does the
> > mvneta driver already have a use-case for this (in non-XDP mode)? =20
>=20
> With 'non-XDP mode' do you mean not loading a BPF program? If so yes, it =
used
> in __page_pool_alloc_pages_slow getting pages from page allocator.
> What would be a right min value for it? Just 0 or
> XDP_PACKET_HEADROOM/NET_SKB_PAD? I guess here it matters if a BPF program=
 is
> loaded or not.

I think you are saying, that we need to allow .offset=3D=3D0, because it is
used by mvneta.  Did I understand that correctly?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

