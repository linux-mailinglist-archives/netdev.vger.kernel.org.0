Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF6102E1F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfKSVRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:17:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726911AbfKSVRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574198252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAGsvuknSxBFMrzU8TPh63ZgjOWKvtXFHTopm1H1Chk=;
        b=LQBiIA1KHuikI1Kcu7Fudqt0FHqeKFMsNS5O2yt/KMDmSsocLzJNUiCl+3iWxgVLdpHmG5
        TcxrO8mUJGwEOHbCL73K/gSlqNnWx25WzGjjwWjxjiSFYcv7iR3Jmuyl4GYHMO1jKrYkjS
        6EISESCHLS/9q5qDcquZ9Dfmm6hMSxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-kpjJ1TExO6CzkS-AZ8jTCA-1; Tue, 19 Nov 2019 16:17:31 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2E3E107ACC4;
        Tue, 19 Nov 2019 21:17:29 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB1B71ED;
        Tue, 19 Nov 2019 21:17:19 +0000 (UTC)
Date:   Tue, 19 Nov 2019 22:17:18 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     mcroce@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119221718.3d050008@carbon>
In-Reply-To: <20191119152543.GD3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
        <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
        <20191119122358.12276da4@carbon>
        <20191119121430.GA3449@localhost.localdomain>
        <20191119161332.56faa205@carbon>
        <20191119152543.GD3449@localhost.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: kpjJ1TExO6CzkS-AZ8jTCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 17:25:43 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Tue, 19 Nov 2019 14:14:30 +0200
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> >  =20
> > > > On Mon, 18 Nov 2019 15:33:45 +0200
> > > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > >    =20
> > > > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > > > index 1121faa99c12..6f684c3a3434 100644
> > > > > --- a/include/net/page_pool.h
> > > > > +++ b/include/net/page_pool.h
> > > > > @@ -34,8 +34,15 @@
> > > > >  #include <linux/ptr_ring.h>
> > > > >  #include <linux/dma-direction.h>
> > > > > =20
> > > > > -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unm=
ap */
> > > > > -#define PP_FLAG_ALL=09PP_FLAG_DMA_MAP
> > > > > +#define PP_FLAG_DMA_MAP=09=091 /* Should page_pool do the DMA ma=
p/unmap */
> > > > > +#define PP_FLAG_DMA_SYNC_DEV=092 /* if set all pages that the dr=
iver gets
> > > > > +=09=09=09=09   * from page_pool will be
> > > > > +=09=09=09=09   * DMA-synced-for-device according to the
> > > > > +=09=09=09=09   * length provided by the device driver.
> > > > > +=09=09=09=09   * Please note DMA-sync-for-CPU is still
> > > > > +=09=09=09=09   * device driver responsibility
> > > > > +=09=09=09=09   */
> > > > > +#define PP_FLAG_ALL=09=09(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV=
)
> > > > >     =20
> > > > [...]
> > > >=20
> > > > Can you please change this to use the BIT(X) api.
> > > >=20
> > > > #include <linux/bits.h>
> > > >=20
> > > > #define PP_FLAG_DMA_MAP=09=09BIT(0)
> > > > #define PP_FLAG_DMA_SYNC_DEV=09BIT(1)   =20
> > >=20
> > > Hi Jesper,
> > >=20
> > > sure, will do in v5
> > >  =20
> > > >=20
> > > >=20
> > > >    =20
> > > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > > index dfc2501c35d9..4f9aed7bce5a 100644
> > > > > --- a/net/core/page_pool.c
> > > > > +++ b/net/core/page_pool.c
> > > > > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *po=
ol,
> > > > >  =09    (pool->p.dma_dir !=3D DMA_BIDIRECTIONAL))
> > > > >  =09=09return -EINVAL;
> > > > > =20
> > > > > +=09/* In order to request DMA-sync-for-device the page needs to
> > > > > +=09 * be mapped
> > > > > +=09 */
> > > > > +=09if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > > > > +=09    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > > > > +=09=09return -EINVAL;
> > > > > +   =20
> > > >=20
> > > > I like that you have moved this check to setup time.
> > > >=20
> > > > There are two other parameters the DMA_SYNC_DEV depend on:
> > > >=20
> > > >  =09struct page_pool_params pp_params =3D {
> > > >  =09=09.order =3D 0,
> > > > -=09=09.flags =3D PP_FLAG_DMA_MAP,
> > > > +=09=09.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > > >  =09=09.pool_size =3D size,
> > > >  =09=09.nid =3D cpu_to_node(0),
> > > >  =09=09.dev =3D pp->dev->dev.parent,
> > > >  =09=09.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> > > > +=09=09.offset =3D pp->rx_offset_correction,
> > > > +=09=09.max_len =3D MVNETA_MAX_RX_BUF_SIZE,
> > > >  =09};
> > > >=20
> > > > Can you add a check, that .max_len must not be zero.  The reason is
> > > > that I can easily see people misconfiguring this.  And the effect i=
s
> > > > that the DMA-sync-for-device is essentially disabled, without user
> > > > realizing this. The not-realizing part is really bad, especially
> > > > because bugs that can occur from this are very rare and hard to cat=
ch.   =20
> > >=20
> > > I guess we need to check it just if we provide PP_FLAG_DMA_SYNC_DEV.
> > > Something like:
> > >=20
> > > =09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
> > > =09=09if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> > > =09=09=09return -EINVAL;
> > >=20
> > > =09=09if (!pool->p.max_len)
> > > =09=09=09return -EINVAL;
> > >=09} =20
> >=20
> > Yes, exactly.
> >  =20
>=20
> ack, I will add it to v5
>=20
> > > >=20
> > > > I'm up for discussing if there should be a similar check for .offse=
t.
> > > > IMHO we should also check .offset is configured, and then be open t=
o
> > > > remove this check once a driver user want to use offset=3D0.  Does =
the
> > > > mvneta driver already have a use-case for this (in non-XDP mode)?  =
 =20
> > >=20
> > > With 'non-XDP mode' do you mean not loading a BPF program? If so yes,=
 it used
> > > in __page_pool_alloc_pages_slow getting pages from page allocator.
> > > What would be a right min value for it? Just 0 or
> > > XDP_PACKET_HEADROOM/NET_SKB_PAD? I guess here it matters if a BPF pro=
gram is
> > > loaded or not. =20
> >=20
> > I think you are saying, that we need to allow .offset=3D=3D0, because i=
t is
> > used by mvneta.  Did I understand that correctly? =20
>=20
> I was just wondering what is the right value for the min offset, but
> rethinking about it yes, there is a condition where  mvneta is using
> offset set 0 (it is the regression reported by Andrew, when mvneta is
> running on a hw bm device  but bm code is not compiled). Do you think
> we can skip this check for the moment until we fix XDP on that
> particular board?

Yes. I guess we just accept .offset can be zero.  It is an artificial
limitation.

The check is not important if API is used correctly. It comes from my
API design philosophy for page_pool, which is "Easy to use, and hard to
misuse".  This is a case of catching "misuse" and signaling that this
was a wrong config.  The check for pool->p.max_len should be enough,
for driver developer to notice, that they also need to set offset.
Maybe a comment close to pool->p.max_len check about "offset" will be
enough.  Given you return the "catch all" -EINVAL, we/you force driver
devel to read code for page_pool_init(), which IMHO is sufficiently
clear.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

