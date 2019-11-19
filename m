Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4421027BF
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfKSPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:11:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57857 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727836AbfKSPL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574176285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9N9IO0/XD+xiSOuz/a6MQLrZktW895fzHFoi9+HvgOo=;
        b=gt5pWSV8xPm4lOxdvpAjLwyx9/Vv+rw5Bjpy9WY+apnt570ixj0iamRcC/giZR2+vyIsNa
        P3hmP6SyxPgbl5d+3fplMDVS73f5G1L+zvMg5VWyHb6OVN7tbN0w+h9O7fNLpcY7kuHnGm
        spHkwxfTaqb8hLuMgsbAkigc4csw3TI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-37ldGzVCN8O_frxDcRm73g-1; Tue, 19 Nov 2019 10:11:21 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00370DB61;
        Tue, 19 Nov 2019 15:11:19 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36C9A1001B32;
        Tue, 19 Nov 2019 15:11:10 +0000 (UTC)
Date:   Tue, 19 Nov 2019 16:11:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119161109.7cd83965@carbon>
In-Reply-To: <20191119113336.GA25152@apalos.home>
References: <cover.1574083275.git.lorenzo@kernel.org>
        <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
        <20191119122358.12276da4@carbon>
        <20191119113336.GA25152@apalos.home>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 37ldGzVCN8O_frxDcRm73g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 13:33:36 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

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
> +1 we sync based on the min() value of those=20
>=20
> >=20
> > I'm up for discussing if there should be a similar check for .offset.
> > IMHO we should also check .offset is configured, and then be open to
> > remove this check once a driver user want to use offset=3D0.  Does the
> > mvneta driver already have a use-case for this (in non-XDP mode)? =20
>=20
> Not sure about this, since it does not break anything apart from some
> performance hit

I don't follow the 'performance hit' comment.  This is checked at setup
time (page_pool_init), thus it doesn't affect runtime.

This is a generic optimization principle that I use a lot. Moving code
checks out of fast-path, and instead do more at setup/load-time, or
even at shutdown-time (like we do for page_pool e.g. check refcnt
invariance).  This principle is also heavily used by BPF, that adjust
BPF-instructions at load-time.  It is core to getting the performance
we need for high-speed networking.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

